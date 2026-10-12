page 50134 "Staff Expense Claim"
{
    PageType = Document;
    SourceTable = "Staff Expense Claim form Heade";
    UsageCategory = Tasks;
    ApplicationArea = All;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("EXP Form No."; Rec."EXP Form No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Apply Date"; Rec."Apply Date")
                {
                    ApplicationArea = all;
                }
                field("Total Amount (HKD)"; Rec."Total Amount (HKD)")
                {
                    ApplicationArea = all;
                    Visible = false;
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Created User"; Rec."Created User")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Submit User"; Rec."Staff No.")
                {
                    ApplicationArea = all;
                }
                field("Staff Name"; Rec."Staff Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                //TEC#002 <<
                //field("No. of Approved Lines"; Rec."No. of Approved Lines")
                //{
                //    ApplicationArea = all;
                //}
                //field("No. of Lines"; Rec."No. of Lines")
                //{
                //    ApplicationArea = all;
                //}
                //TEC#002 >>
                field("Invoice Created"; Rec."Invoice Created")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Time Sheet Approver ID"; Rec."Time Sheet Approver ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ToolTip = 'Specifies the value of the Total Amount field.', Comment = '%';
                }
            }
            part(ExpenseLines; "Staff Expense Claim Subform")
            {
                SubPageLink = "EXP Form No." = field("EXP Form No.");
                ApplicationArea = all;
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group(Print)
            {
                Caption = 'Print';
                Image = Print;

                action("Print Form")
                {
                    ApplicationArea = all;
                    Promoted = true;
                    Image = Print;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    PromotedOnly = true; //

                    trigger OnAction()
                    var
                        StaffExpClaimHeader: Record "Staff Expense Claim form Heade";
                    begin
                        fn_checkClaimLines();
                        PreRef := '00';
                        StaffExpenseClaimfromLine.Reset();
                        StaffExpenseClaimfromLine.SetRange("EXP Form No.", Rec."EXP Form No.");
                        if StaffExpenseClaimfromLine.FindSet() then
                            repeat
                                PreRef := IncStr(PreRef);
                                StaffExpenseClaimfromLine."Reference No." := copystr(StaffExpenseClaimfromLine."EXP Form No." + PreRef, 1, MaxStrLen(StaffExpenseClaimfromLine."Reference No.")); //
                                StaffExpenseClaimfromLine.Modify();
                            until StaffExpenseClaimfromLine.Next() = 0;
                        Commit();
                        StaffExpClaimHeader.SetRange("EXP Form No.", rec."EXP Form No.");
                        if StaffExpClaimHeader.FindFirst() then report.RunModal(Report::"Staff Expense Claim Print", true, false, StaffExpClaimHeader);
                    end;
                }
            }
            //TEC#002 <<
            group("Approver")
            {
                //Caption = 'Request Approval';
                Image = SendApprovalRequest;

                action(Approve)
                {
                    Image = Approve;

                    trigger OnAction()
                    begin
                        Rec.testfield(status, Rec.Status::"Pending Approval");
                        Rec.CALCFIELDS("Time Sheet Approver ID");
                        if (not IsAdmin()) and (USERID <> Rec."Time Sheet Approver ID") then
                            MESSAGE('Unable to Approve this Expense form, invalid User')
                        else begin
                            Rec.Status := Rec.Status::Approved;
                            Rec.MODIFY();
                        end;
                    end;
                }
                action(Reject)
                {
                    Image = Reject;

                    trigger OnAction()
                    begin
                        //testfield(status, Status::"Pending Approval");
                        Rec.CALCFIELDS("Time Sheet Approver ID");
                        if (not IsAdmin()) and (USERID <> Rec."Time Sheet Approver ID") then
                            MESSAGE('Unable to Approve this Expense form, invalid User')
                        else begin
                            Rec.Status := Rec.Status::Rejected;
                            Rec.MODIFY();
                        end;
                    end;
                }
            }
            //TEC#002 >>
            group("Request Approval")
            {
                action(Submit)
                {
                    ApplicationArea = Basic, Suite;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        //ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        //WorkflowEventSubscriber: Codeunit 50125;
                        ResourceVar: Record Resource;
                        l_Rec_UserSetup: Record "User Setup";
                    //PendingApprovalMsg: Label 'An approval request has been sent.';
                    begin
                        //TEC#002 <<
                        if Rec.status in [Rec.Status::Open, Rec.Status::Rejected] then begin
                            if not Confirm('Do you want to send request', false) then exit;
                            l_Rec_UserSetup.RESET;
                            l_Rec_UserSetup.SETRANGE("User ID", USERID);
                            l_Rec_UserSetup.SETRANGE("Staff Expense Bypass Appr. Checking", TRUE);
                            IF NOT l_Rec_UserSetup.FINDSET THEN BEGIN
                                CreateDefaultAttendeeforWorkMeal();
                                //CheckifmorethanoneforminsameMonth();                        //#003 Commented, allow submitting 2 or more claims per person in same month
                                //CheckIfTimeSheetDetailSubmitOrNot();
                                fn_checkClaimLines(); //#003
                            END;
                            if ResourceVar.Blocked = true then Error('Request can not be send for blocked resource %1', ResourceVar."No.");
                            if (IsAdmin()) or (Resource."Time Sheet Owner User ID" = USERID) then begin
                                Rec.Status := Rec.Status::"Pending Approval";
                                Rec.MODIFY();
                            end
                            else
                                MESSAGE('Unable to submit this entry, invalid owner / creator');
                        end
                        else
                            Message('Status must be Open / Rejected');
                        //TEC#001 DC <<
                        //IF WorkflowEventSubscriber.IsStaffExpenseEnabled(Rec) THEN BEGIN
                        //    WorkflowEventSubscriber.OnSendStaffExpenseforApproval(Rec);
                        //    MESSAGE(PendingApprovalMsg);
                        //END ELSE begin
                        //    MESSAGE('No Workflow enabled');
                        //END;
                        //StaffExpenseClaimfromLine.SETRANGE(StaffExpenseClaimfromLine."EXP Form No.", Rec."EXP Form No.");
                        //IF StaffExpenseClaimfromLine.FINDSET THEN
                        //    REPEAT
                        //        if ResourceVar.Blocked = true then
                        //            Error('Request can not be send for blocked resource %1', ResourceVar."No.");
                        //IF WorkflowEventSubscriber.CheckStaffExpenseApprovalPossible(StaffExpenseClaimfromLine) THEN
                        //    WorkflowEventSubscriber.RunWorkflowOnSendStaffExpenseForApproval(StaffExpenseClaimfromLine);                                                                                                
                        //    UNTIL StaffExpenseClaimfromLine.NEXT = 0;
                        //if ApprovalsMgmt.CheckStaffExpenseApprovalPossible(Rec) then
                        //   ApprovalsMgmt.OnSendStaffExpenseForApproval(Rec);
                        //Message('Under Development');
                        //TEC#001 DC >>
                        //TEC#002 >>
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic, Suite;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true; //

                    trigger OnAction()
                    var
                        //WorkflowEventSubscriber: Codeunit "Workflow Event Subscriber";
                        //ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        //WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                        //WorkflowManagement: Codeunit "Workflow Management";
                        Resource: Record Resource;
                    begin
                        //TEC#002 <<
                        if (IsAdmin()) or (Resource."Time Sheet Owner User ID" = USERID) then begin
                            if (isadmin()) and (Rec.Status = Rec.Status::Approved) then begin
                                if CONFIRM('Do you want to reopen this entry?') then begin
                                    Rec.Status := Rec.Status::Open;
                                    Rec.MODIFY();
                                end;
                            end
                            else begin
                                Rec.testfield(status, Rec.Status::"Pending Approval");
                                Rec.Status := Rec.Status::Open;
                                Rec.MODIFY();
                            end;
                        end
                        else
                            MESSAGE('Unable to reopen this entry, invalid owner');
                        //StaffExpenseClaimfromLine.SETRANGE(StaffExpenseClaimfromLine."EXP Form No.", Rec."EXP Form No.");
                        //IF StaffExpenseClaimfromLine.FINDSET THEN
                        //    REPEAT
                        //        WorkflowEventSubscriber.RunWorkflowOnCancelStaffExpenseApprovalRequest(StaffExpenseClaimfromLine);
                        //        WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
                        //    UNTIL StaffExpenseClaimfromLine.NEXT = 0;
                        //ApprovalsMgmt.OnCancelStaffExpenseApprovalRequest(Rec);
                        // WorkflowWebhookMgt.FindAndCancel(RecordId);
                        //Message('Under Development');
                        //TEC#002 >>
                    end;
                }
            }
            group(Process)
            {
                action("Re-Assign Reference No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Image = GetSourceDoc; //

                    trigger OnAction()
                    var
                    //"CreateExpenseClaimPurchInv": Report "Create Expense Claim Purch Inv";
                    begin
                        if not Confirm('Do you want to Assign Reference No?', false) then exit;
                        PreRef := '00';
                        StaffExpenseClaimfromLine.Reset();
                        StaffExpenseClaimfromLine.SetRange("EXP Form No.", Rec."EXP Form No.");
                        if StaffExpenseClaimfromLine.FindSet() then
                            repeat
                                PreRef := IncStr(PreRef);
                                StaffExpenseClaimfromLine."Reference No." := copystr(StaffExpenseClaimfromLine."EXP Form No." + PreRef, 1, MaxStrLen(StaffExpenseClaimfromLine."Reference No.")); //
                                StaffExpenseClaimfromLine.Modify();
                            until StaffExpenseClaimfromLine.Next() = 0;
                    end;
                }
                // action("Create Purchase Invoice")
                // {
                //     trigger OnAction()
                //     var
                //"CreateExpenseClaimPurchInv": Report "Create Expense Claim Purch Inv";
                //         staffexpclaimhead: Record "Staff Expense Claim form Heade";
                //     begin
                //         if not confirm('Do you want to create purchase invoice', false) then
                //             exit;
                //         TestField(Status, Status::Approved);
                //     end;
                // }
            }
        }
    }
    procedure CheckifmorethanoneforminsameMonth()
    var
        StaffExpClaimFormHead: Record "Staff Expense Claim form Heade";
        MonthStartDate: Date;
        MonthEndDate: Date;
    begin
        Rec.TestField("Apply Date");
        Rec.TestField("Created User");
        MonthStartDate := CalcDate('<-CM>', Rec."Apply Date");
        MonthEndDate := CalcDate('<CM>', Rec."Apply Date");
        StaffExpClaimFormHead.RESET();
        StaffExpClaimFormHead.SetRange("Staff No.", Rec."Staff No.");
        StaffExpClaimFormHead.SetRange("Apply Date", MonthStartDate, MonthEndDate);
        StaffExpClaimFormHead.SetFilter("EXP Form No.", '<>%1', Rec."EXP Form No.");
        if StaffExpClaimFormHead.FindFirst() then ERROR('Form No. %1 is already exist for same month', StaffExpClaimFormHead."EXP Form No.");
    end;

    procedure CheckIfTimeSheetDetailSubmitOrNot()
    var
        staffExpenseclaimLine: Record "Staff Expense Claim form Line";
        _recTimeSheetHeader: Record "Time Sheet Header";
    begin
        staffExpenseclaimLine.Reset();
        staffExpenseclaimLine.SetRange("EXP Form No.", Rec."EXP Form No.");
        if staffExpenseclaimLine.FindSet() then
            repeat
                _recTimeSheetHeader.Reset();
                _recTimeSheetHeader.SetRange("Resource No.", staffExpenseclaimLine.Payee);
                _recTimeSheetHeader.SetFilter("Ending Date", '>=%1', calcdate('<CM>', staffExpenseclaimLine."Apply Date"));
                _recTimeSheetHeader.setrange("Submitted Exists", true);
                if not _recTimeSheetHeader.IsEmpty() then //_recTimeSheetHeader.FindFirst() then
                    Error('Please submit timesheet for the same month\ Error in Form No. %1 Line No %2', staffExpenseclaimLine."EXP Form No.", staffExpenseclaimLine."Line No.");
            until staffExpenseclaimLine.Next() = 0;
    end;

    procedure IsAdmin(): Boolean
    begin
        if UserSetup.GET(USERID) then if UserSetup."Staff Expense Form Admin" then exit(true);
    end;

    procedure CreateDefaultAttendeeforWorkMeal()
    var
        StaffExpFormHeader: Record "Staff Expense Claim form Heade";
        StaffExpAttendee: Record "Staff Expense Claim Line Atten";
        StaffExpLine: Record "Staff Expense Claim form Line";
    begin
        StaffExpLine.Reset();
        StaffExpLine.SetRange("EXP Form No.", Rec."EXP Form No.");
        StaffExpLine.SetFilter("Expense Category Code", '1-WORK MEAL');
        if StaffExpLine.FindFirst() then begin
            StaffExpLine.CalcFields(Attendees);
            if StaffExpLine.Attendees = 0 then begin
                if not Confirm('There is no attendee selected for expense category 1-WORK MEAL\ Do you want to create default for staff no. %1?', true, Rec."Staff No.") then exit;
                StaffExpLine.Reset();
                StaffExpLine.SetRange("EXP Form No.", Rec."EXP Form No.");
                if StaffExpLine.FindLast() then begin
                    StaffExpFormHeader.Get(Rec."EXP Form No.");
                    StaffExpFormHeader.TestField("Staff No.");
                    StaffExpAttendee.Init();
                    StaffExpAttendee."EXP Form No." := Rec."EXP Form No.";
                    StaffExpAttendee."Line No." := StaffExpLine."Line No.";
                    StaffExpAttendee.validate(Attendees, StaffExpFormHeader."Staff No.");
                    StaffExpAttendee.Insert();
                end;
            end;
        end;
    end;
    //  #003 <<
    procedure fn_checkClaimLines()
    var
        l_recClaimLine: Record "Staff Expense Claim form Line";
        l_booExpCateCode: Boolean;
        l_booInvDate: Boolean;
        l_booProjCode: Boolean;
        l_booAmt: Boolean;
        l_booError: Boolean;
        l_txtErrorText: Text;
        l_recJob: Record 167;
        l_recExpCatePost: Record "Expense Category Posting Group";
        l_recExpCurrency: Record "Expense Category Currency";
        l_txt_ErrorPerLine: Text;
        l_int_NoOfAttendees: integer;
        l_txt_PerPerson: Text;
    begin
        l_recClaimLine.Reset();
        l_recClaimLine.SetRange("EXP Form No.", Rec."EXP Form No.");
        if l_recClaimLine.FindSet() then
            repeat // Check must fill fields
                IF l_recClaimLine."Expense Category Code" = '' then begin
                    l_booExpCateCode := true;
                    l_booError := true;
                end;
                if l_recClaimLine."Invoice Date" = 0D then begin
                    l_booInvDate := true;
                    l_booError := true;
                end;
                if l_recClaimLine."Project Code" = '' then begin
                    l_booProjCode := true;
                    l_booError := true;
                end;
                if l_recClaimLine.Amount = 0 then begin
                    l_booAmt := true;
                    l_booError := true;
                end;
                if l_booError then begin
                    IF l_txtErrorText <> '' then l_txtErrorText += '\\';
                    l_txtErrorText += 'The following field(s) is/are missing for line ' + Format(l_recClaimLine."Line No.");
                    if l_booExpCateCode then l_txtErrorText += '\-    Expense Category Code';
                    if l_booInvDate then l_txtErrorText += '\-    Invoice Date';
                    if l_booProjCode then l_txtErrorText += '\-    Project Code';
                    if l_booAmt then l_txtErrorText += '\-    Amount';
                end;
                l_txt_ErrorPerLine := '';
                // Check if job code is closed for claims
                l_recJob.Reset();
                l_recJob.SetRange("No.", l_recClaimLine."Project Code");
                if l_recJob.FindFirst() then if l_recJob.Blocked <> l_recJob.Blocked::" " then l_txt_ErrorPerLine += StrSubstNo('\- Job %1 is blocked and not available for expense claim.', l_recClaimLine."Project Code");
                // Check preapproval for amount > pre-approval required amount                
                l_int_NoOfAttendees := 1;
                l_txt_PerPerson := '';
                l_RecClaimLine.CALCFIELDS("Attendees");
                l_recExpCatePost.RESET;
                l_recExpCatePost.SETRANGE("Expense Category Code", l_recClaimLine."Expense Category Code");
                l_recExpCatePost.SETRANGE("Expense checking per person", true);
                IF l_recExpCatePost.FINDSET THEN BEGIN
                    l_txt_PerPerson := 'Per person';
                    l_int_NoOfAttendees := l_RecClaimLine."Attendees";
                END;
                l_recExpCurrency.Reset();
                l_recExpCurrency.SetRange("Expense Category Code", l_recClaimLine."Expense Category Code");
                l_recExpCurrency.SETRANGE("Currency Code", l_recClaimLine."Currency Code");
                if l_recExpCurrency.FindFirst() then begin
                    if (l_recExpCurrency."Maximum Allowed amount" <> 0) OR (l_recExpCurrency."Pre-approval required amount" <> 0) then
                        if (l_recExpCurrency."Maximum Allowed amount" * l_int_NoOfAttendees < l_recClaimLine."Amount") AND (l_recExpCurrency."Maximum Allowed amount" <> 0) then begin
                            l_txt_ErrorPerLine += StrSubstNo('\- Amount must not be larger than maximum allowed amount (Exp. Code: %1 - %3 %2 %4)', l_recExpCurrency."Expense Category Code", Format(l_recExpCurrency."Maximum Allowed amount"), l_recClaimLine."Currency Code", l_txt_PerPerson);
                        end
                        else begin
                            if l_recExpCurrency."Pre-approval required amount" <> 0 then if (l_recExpCurrency."Pre-approval required amount" * l_int_NoOfAttendees < l_recClaimLine."Amount") AND (l_recClaimLine."Pre-Approval No." = '') then l_txt_ErrorPerLine += StrSubstNo('\- Pre-Approval number must be entered before submission  (Exp. Code: %1 - %3 %2 %4)', l_recExpCurrency."Expense Category Code", Format(l_recExpCurrency."Pre-approval required amount"), l_recClaimLine."Currency Code", l_txt_PerPerson);
                        END;
                end;
                IF NOT l_booError THEN begin
                    IF l_txt_ErrorPerLine <> '' THEN begin
                        IF l_txtErrorText <> '' then l_txtErrorText += '\\';
                        l_txtErrorText += 'The following field(s) is/are missing for line ' + Format(l_recClaimLine."Line No.");
                    end;
                end;
                l_txtErrorText += l_txt_ErrorPerLine;
            until l_recClaimLine.Next() = 0;
        IF l_txtErrorText <> '' then ERROR(l_txtErrorText);
    end;
    //  #003 >>
    trigger OnOpenPage()
    var
        l_rpt_Patch: Report 50150;
        l_Rec_ExpClaimHdr: Record "Staff Expense Claim form Heade";
    begin
        UserSetup.get(UserId);
        Rec.FilterGroup(2);
        Resource.reset();
        Resource.SetRange("Time Sheet Owner User ID", UserId);
        if Resource.FindSet() then
            repeat
                if ResourceFilterText = '' then
                    ResourceFilterText := Resource."No."
                else
                    ResourceFilterText := ResourceFilterText + '|' + Resource."No.";
            until Resource.Next() = 0;
        if not UserSetup."Staff Expense Form Admin" then Rec.SETFILTER("Staff No.", ResourceFilterText);
        Rec.FilterGroup(0);
        IF Rec."Currency Code" = '' THEN begin
            IF CONFIRM('No Currency Code for this staff, Refresh?') THEN begin
                CLEAR(l_rpt_Patch);
                l_Rec_ExpClaimHdr.RESET;
                l_Rec_ExpClaimHdr.SETRANGE("EXP Form No.", Rec."EXP Form No.");
                IF l_Rec_ExpClaimHdr.FINDSET THEN;
                l_rpt_Patch.SetTableView(l_Rec_ExpClaimHdr);
                l_rpt_Patch.RUN;
            end;
        end;
    end;

    procedure SubmitChecking(p_cod_ClaimCode: Code[20]): Boolean
    var
        l_Rec_ClaimHdr: Record "Staff Expense Claim form Heade";
        l_Rec_ClaimLine: Record "Staff Expense Claim form Line";
    begin
    end;

    var
        StaffExpenseClaimfromLine: Record "Staff Expense Claim form Line";
        TimeSheetHeader: Record "Time Sheet Header";
        PreRef: Code[10];
        StaffName: Text;
        Resource: Record Resource;
        ResourceFilterText: Text;
        UserSetup: Record "User Setup";
        WorkMealCategoryCode_HardCode: Label '1-WORK MEAL';
}
