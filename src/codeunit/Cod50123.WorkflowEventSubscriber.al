codeunit 50123 "Workflow Event Subscriber"
{
    trigger OnRun()
    begin
    end;
    var WorkflowSetup: Codeunit "Workflow Setup";
    StaffExpenseApprWorkflowCodeTxt: Label 'SEAPW', Locked = true;
    StaffExpenseApprWorkflowDescTxt: Label 'Staff Expense Approval Workflow';
    StaffExpenseCategoryTxt: Label 'EXPENSE', Locked = true;
    StaffExpenseHeaderTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Staff Expense Claim form Heade">%1</DataItem><DataItem name="Staff Expense Claim form Line">%2</DataItem></DataItems></ReportParameters>', Locked = true;
    StaffExpenseCategoryDescTxt: Label 'Staff Expense';
    BlankDateFormula: DateFormula;
    WorkflowEventHandling: Codeunit "Workflow Event Handling";
    WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    StaffExpenseSendForApprovalEventDescTxt: Label 'Approval of a Staff Expense Line is requested.';
    StaffExpenseApprReqCancelledEventDescTxt: Label 'An approval request for a Staff Expense Line is canceled.';
    WorkflowManagement: Codeunit "Workflow Management";
    StaffExpenseClaimfromLine: Record "Staff Expense Claim form Line";
    //ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    StaffExpenseStatusChangedMsg: Label 'Expense No. : %1 has been automatically approved. The status has been changed to %2.', Comment = '%1 %2 Order 1001 has been automatically approved. The status has been changed to Released.'; //
    NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
    UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this workflow response.', Comment = '%1 Record type Customer is not supported by this workflow response.'; //
    StaffExpenseClaimfromLine2: Record "Staff Expense Claim form Line";
    //StaffExpenseSendForApprovalEventDescHdrTxt: Label 'Approval of a Staff Expense is requested.';
    //StaffExpenseApprReqCancelledEventDescHdrTxt: Label 'An approval request for a Staff Expense is canceled.';
    // local procedure "------------------------------------------ Subscriber for workflow setup -------------------------------------------"()
    // begin
    // end;
    [EventSubscriber(ObjectType::Codeunit, 1502, 'OnInsertWorkflowTemplates', '', false, false)]
    local procedure OnInsertWorkflowTemplates(var Sender: Codeunit "Workflow Setup")
    begin
        InsertStaffExpenseApprovalWorkflowTemplate();
    end;
    [EventSubscriber(ObjectType::Codeunit, 1502, 'OnAddWorkflowCategoriesToLibrary', '', false, false)]
    local procedure OnAddWorkflowCategoriesToLibrary()
    begin
        WorkflowSetup.InsertWorkflowCategory(StaffExpenseCategoryTxt, StaffExpenseCategoryDescTxt);
    end;
    [EventSubscriber(ObjectType::Codeunit, 1502, 'OnAfterInsertApprovalsTableRelations', '', false, false)]
    local procedure OnAfterInsertApprovalsTableRelations()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        WorkflowSetup.InsertTableRelation(DATABASE::"Staff Expense Claim form Line", 0, DATABASE::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;
    [EventSubscriber(ObjectType::Codeunit, 1520, 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CreateEventsLiberaryWorkflowEventHandling()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendStaffExpenseForApprovalCode(), DATABASE::"Staff Expense Claim form Line", StaffExpenseSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelStaffExpenseApprovalRequestCode(), DATABASE::"Staff Expense Claim form Line", StaffExpenseApprReqCancelledEventDescTxt, 0, false);
    end;
    [EventSubscriber(ObjectType::Codeunit, 1520, 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure CreateEventsPredecessorLiberaryWorkflowEventHandling(EventFunctionName: Code[128])
    begin
        case EventFunctionName of RunWorkflowOnCancelStaffExpenseApprovalRequestCode(): WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelStaffExpenseApprovalRequestCode(), RunWorkflowOnSendStaffExpenseForApprovalCode());
        WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode(): WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode(), RunWorkflowOnSendStaffExpenseForApprovalCode());
        WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode(): WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode(), RunWorkflowOnSendStaffExpenseForApprovalCode());
        WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode(): WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode(), RunWorkflowOnSendStaffExpenseForApprovalCode());
        end;
    end;
    // local procedure "----------------------------------------- Workflow Response Handling ------------------------------------------------"()
    // begin
    // end;
    [EventSubscriber(ObjectType::Codeunit, 1521, 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure AddResponsePredecessorsWorkflowResHadling(ResponseFunctionName: Code[128])
    begin
        case ResponseFunctionName of WorkflowResponseHandling.SetStatusToPendingApprovalCode(): WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), RunWorkflowOnSendStaffExpenseForApprovalCode());
        WorkflowResponseHandling.CreateApprovalRequestsCode(): WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode(), RunWorkflowOnSendStaffExpenseForApprovalCode());
        WorkflowResponseHandling.SendApprovalRequestForApprovalCode(): WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), RunWorkflowOnSendStaffExpenseForApprovalCode()); //yk
        WorkflowResponseHandling.RejectAllApprovalRequestsCode(): WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.RejectAllApprovalRequestsCode(), WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode());
        WorkflowResponseHandling.OpenDocumentCode(): WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), RunWorkflowOnCancelStaffExpenseApprovalRequestCode());
        WorkflowResponseHandling.CancelAllApprovalRequestsCode(): WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), RunWorkflowOnCancelStaffExpenseApprovalRequestCode());
        end;
    end;
    [EventSubscriber(ObjectType::Codeunit, 1521, 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
    //Varient: Variant;
    begin
        case RecRef.Number of DATABASE::"Staff Expense Claim form Line": begin
            RecRef.SetTable(StaffExpenseClaimfromLine2);
            //Message('start');
            StaffExpenseClaimfromLine.OpenStaffExpense(StaffExpenseClaimfromLine2); //yk
            Handled:=true;
        end;
        end;
    end;
    [EventSubscriber(ObjectType::Codeunit, 1521, 'OnReleaseDocument', '', false, false)]
    local procedure OnReleasedDocument(RecRef: RecordRef; var Handled: Boolean)
    var
    //Varient: Variant;
    begin
        StaffExpenseClaimfromLine2.Reset();
        case RecRef.Number of DATABASE::"Staff Expense Claim form Line": begin
            RecRef.SetTable(StaffExpenseClaimfromLine2);
            StaffExpenseClaimfromLine.ApproveStaffExpense(StaffExpenseClaimfromLine2);
            Handled:=true;
        end;
        end;
    end;
    // local procedure "------------------------------------------Workflow Management ---------------------------------------"()
    // begin
    // end;
    [EventSubscriber(ObjectType::Codeunit, 1535, 'OnAfterIsSufficientApprover', '', false, false)]
    local procedure IsSufficientApprover(UserSetup: Record "User Setup"; ApprovalEntryArgument: Record "Approval Entry"; var IsSufficient: Boolean)
    begin
        case ApprovalEntryArgument."Table ID" of DATABASE::"Staff Expense Claim form Line": IsSufficient:=IsSufficientStaffExpenseApprover(UserSetup, ApprovalEntryArgument."Amount (LCY)");
        end;
    end;
    [EventSubscriber(ObjectType::Codeunit, 1535, 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure SetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        StaffExpClaimFormHeader: Record "Staff Expense Claim form Heade";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of DATABASE::"Staff Expense Claim form Line": begin
            RecRef.SetTable(StaffExpenseClaimfromLine);
            StaffExpenseClaimfromLine.Status:=StaffExpenseClaimfromLine.Status::"Submitted Pending Approval"; //yk
            StaffExpenseClaimfromLine.Modify();
            StaffExpClaimFormHeader.Get(StaffExpenseClaimfromLine."EXP Form No.");
            StaffExpClaimFormHeader.Status:=StaffExpClaimFormHeader.Status::"Pending Approval";
            StaffExpClaimFormHeader.Modify();
            Variant:=StaffExpenseClaimfromLine;
        end;
        else
        begin
            IsHandled:=false;
            if not IsHandled then Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;
        end;
        IsHandled:=true;
    end;
    [IntegrationEvent(false, false)]
    //[Scope('Personalization')]
    procedure OnSendStaffExpenseForApproval(var StaffExpenseClaimfromLine: Record "Staff Expense Claim form Line")
    begin
    end;
    [IntegrationEvent(false, false)]
    //[Scope('Personalization')]
    procedure OnCancelStaffExpenseApprovalRequest(var StaffExpenseClaimfromLine: Record "Staff Expense Claim form Line")
    begin
    end;
    local procedure ShowStaffExpenseApprovalStatus(pStaffExpenseClaimfromLine: Record "Staff Expense Claim form Line") //
    var
        PendingApprovalMsg: Label 'An approval request has been sent.';
    begin
        pStaffExpenseClaimfromLine.FindFirst(); // pStaffExpenseClaimfromLine.Find();//
        case StaffExpenseClaimfromLine.Status of StaffExpenseClaimfromLine.Status::Approved: Message(StaffExpenseStatusChangedMsg, StaffExpenseClaimfromLine."EXP Form No.", StaffExpenseClaimfromLine.Status);
        // StaffExpenseClaimfromLine.Status::Pending://yk
        //   IF ApprovalsMgmt.HasOpenOrPendingApprovalEntries(StaffExpenseClaimfromLine.RECORDID) THEN
        //    MESSAGE(PendingApprovalMsg);
        end;
    end;
    local procedure IsSufficientStaffExpenseApprover(UserSetup: Record "User Setup"; ApprovalAmountLCY: Decimal): Boolean begin
        if UserSetup."User ID" = UserSetup."Approver ID" then exit(true);
        if UserSetup."Unlimited Sales Approval" or ((ApprovalAmountLCY <= UserSetup."Sales Amount Approval Limit") and (UserSetup."Sales Amount Approval Limit" <> 0))then exit(true);
        exit(false);
    end;
    procedure IsStaffExpenseApprovalsWorkflowEnabled(var pStaffExpenseClaimfromLine: Record "Staff Expense Claim form Line"): Boolean //
 begin
        exit(WorkflowManagement.CanExecuteWorkflow(pStaffExpenseClaimfromLine, RunWorkflowOnSendStaffExpenseForApprovalCode())); //
    end;
    //[Scope('Personalization')]
    procedure CheckStaffExpenseApprovalPossible(var pStaffExpenseClaimfromLine: Record "Staff Expense Claim form Line"): Boolean //
 begin
        if not IsStaffExpenseApprovalsWorkflowEnabled(pStaffExpenseClaimfromLine)then //
 Error(NoWorkflowEnabledErr);
        exit(true);
    end;
    [EventSubscriber(ObjectType::Codeunit, 1535, 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure PopulateApprovalEntryArg(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    begin
        ApprovalEntryArgument.Init();
        ApprovalEntryArgument."Table ID":=RecRef.Number;
        ApprovalEntryArgument."Record ID to Approve":=RecRef.RecordId;
        ApprovalEntryArgument."Document Type":=ApprovalEntryArgument."Document Type"::" ";
        ApprovalEntryArgument."Approval Code":=WorkflowStepInstance."Workflow Code";
        ApprovalEntryArgument."Workflow Step Instance ID":=WorkflowStepInstance.ID;
        case RecRef.Number of DATABASE::"Staff Expense Claim form Line": begin
            RecRef.SetTable(StaffExpenseClaimfromLine);
            ApprovalEntryArgument."Document No.":=StaffExpenseClaimfromLine."EXP Form No.";
            ApprovalEntryArgument.Amount:=StaffExpenseClaimfromLine."Amount (HKD)"; //yk
        end;
        else
        // ApprovalsMgmt.OnPopulateApprovalEntryArgument(RecRef,ApprovalEntryArgument,WorkflowStepInstance);
        end;
    end;
    //Vijay
    // [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
    // procedure UpdateStaffExpClaimHeaderStatus(var ApprovalEntry: Record "Approval Entry")
    // var
    //     StaffExpClaimLine: Record "Staff Expense Claim form Line";
    //     StaffExpClaimHead: Record "Staff Expense Claim form Heade";
    //     ApprovalEntry2: Record "Approval Entry";
    //     LineNoText: Text;
    //     LineNo: Integer;
    // begin
    //     if ApprovalEntry."Table ID" = 50129 then begin
    //         ApprovalEntry2.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
    //         ApprovalEntry2.SetFilter(Status, '<>%1', ApprovalEntry2.Status::Approved);
    //         if not ApprovalEntry2.FindFirst() then begin
    //             LineNoText := SELECTSTR(2, FORMAT(ApprovalEntry."Record ID to Approve", 0, 1));
    //             Evaluate(LineNo, LineNoText);
    //             StaffExpClaimLine.Reset();
    //             StaffExpClaimLine.SetRange("EXP Form No.", ApprovalEntry."Document No.");
    //             StaffExpClaimLine.SetRange("Line No.", LineNo);
    //             IF StaffExpClaimLine.FindFirst() THEN begin
    //                 if StaffExpClaimLine.Status = StaffExpClaimLine.Status::"Submitted Pending Approval" then begin
    //                     StaffExpClaimLine.Status := StaffExpClaimLine.Status::Approval;
    //                     StaffExpClaimLine.Modify();
    //                 end;
    //             end;
    //         end;
    //     StaffExpClaimLine.Reset();
    //     StaffExpClaimLine.SetRange("EXP Form No.", ApprovalEntry."Document No.");
    //     StaffExpClaimLine.SetFilter(Status, '<>%1', StaffExpClaimLine.Status::Approved);
    //     IF Not StaffExpClaimLine.FindFirst() THEN begin
    //         IF StaffExpClaimHead.Get(StaffExpClaimLine."EXP Form No.") then begin
    //             StaffExpClaimHead.Status := StaffExpClaimHead.Status::Approved;
    //             StaffExpClaimHead.Modify();
    //         END;
    //     END;
    //     //     end;
    // end;
    local procedure "---------------------------------------Other------------------------------------------------"()
    begin
    end;
    local procedure InsertStaffExpenseApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, StaffExpenseApprWorkflowCodeTxt, StaffExpenseApprWorkflowDescTxt, StaffExpenseCategoryTxt);
        InsertStaffExpenseApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;
    local procedure InsertStaffExpenseApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        // StaffExpenseClaimfromHeadeL: Record "Staff Expense Claim form Heade";
        //  StaffExpenseClaimfromLine: Record "Staff Expense Claim form Line";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        Workflow:=Workflow; //
        WorkflowSetup.InsertTableRelation(DATABASE::"Staff Expense Claim form Line", StaffExpenseClaimfromLine.FieldNo("EXP Form No."), DATABASE::"Staff Expense Claim form Heade", StaffExpenseClaimfromLine.FieldNo("EXP Form No."));
        WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument, WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser", WorkflowStepArgument."Approver Limit Type"::"Approver Chain", 0, '', BlankDateFormula, true);
    end;
    //[Scope('Internal')]
    procedure BuildStaffExpenseHeaderTypeConditions(Status: Option): Text var
        StaffExpenseClaimfromHeade: Record "Staff Expense Claim form Heade";
        _recStaffExpenseClaimfromLine: Record "Staff Expense Claim form Line";
    begin
        _recStaffExpenseClaimfromLine.SetRange(Status, Status); //
    //exit(StrSubstNo(StaffExpenseHeaderTypeCondnTxt, Encode(StaffExpenseClaimfromLine.GetView(false)), Encode(StaffExpenseClaimfromLine.GetView(false))));
    end;
    // [Scope('Personalization')]
    // procedure Encode(Text: Text): Text
    // var
    //     XMLDOMManagement: Codeunit "XML DOM Management";
    // begin
    //     EXIT(XMLDOMManagement.XMLEscape(Text));
    // end;
    //[Scope('Personalization')]
    procedure RunWorkflowOnSendStaffExpenseForApprovalCode(): Code[128]begin
        exit(UpperCase('RunWorkflowOnSendStaffExpenseForApproval'));
    end;
    //[Scope('Personalization')]
    procedure RunWorkflowOnCancelStaffExpenseApprovalRequestCode(): Code[128]begin
        exit(UpperCase('RunWorkflowOnCancelStaffExpenseApprovalRequest'));
    end;
    //[Scope('Personalization')]
    procedure RunWorkflowOnSendStaffExpenseForApproval(var pStaffExpenseClaimfromLine: Record "Staff Expense Claim form Line") //
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendStaffExpenseForApprovalCode(), pStaffExpenseClaimfromLine); //
    end;
    //[Scope('Personalization')]
    procedure RunWorkflowOnCancelStaffExpenseApprovalRequest(var pStaffExpenseClaimfromLine: Record "Staff Expense Claim form Line") //
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelStaffExpenseApprovalRequestCode(), pStaffExpenseClaimfromLine); //
    end;
}
