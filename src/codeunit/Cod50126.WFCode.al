codeunit 50126 WFCode
{
    trigger OnRun()
    begin
    end;
    var WFMngt: Codeunit "Workflow Management";
    //AppMgmt: Codeunit "Approvals Mgmt.";
    WorkflowEventHandling: Codeunit "Workflow Event Handling";
    WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    SendStaffExpenseReq: TextConst ENU = 'Approval Request for Staff Expense is requested', ENG = 'Approval Request for Staff Expense is requested';
    AppReqStaffExpense: TextConst ENU = 'Approval Request for Staff Expense is approved', ENG = 'Approval Request for Staff Expense is approved';
    RejReqStaffExpense: TextConst ENU = 'Approval Request for Staff Expense is rejected', ENG = 'Approval Request for Staff Expense is rejected';
    DelReqStaffExpense: TextConst ENU = 'Approval Request for Staff Expense is delegated', ENG = 'Approval Request for Staff Expense is delegated';
    SendForPendAppTxt: TextConst ENU = 'Status of StaffExpense changed to Pending approval', ENG = 'Status of StaffExpense changed to Pending approval';
    ReleaseStaffExpenseTxt: TextConst ENU = 'Release StaffExpense', ENG = 'Release StaffExpense';
    ReOpenStaffExpenseTxt: TextConst ENU = 'ReOpen StaffExpense', ENG = 'ReOpen StaffExpense';
    procedure RunWorkflowOnSendStaffExpenseApprovalCode(): Code[128]begin
        exit(UpperCase('RunWorkflowOnSendStaffExpenseApproval'))end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::IntCodeunit, 'OnSendStaffExpenseforApproval', '', false, false)]
    local procedure RunWorkflowOnSendStaffExpenseApproval(var StaffExpense: Record 50130)
    begin
        WFMngt.HandleEvent(RunWorkflowOnSendStaffExpenseApprovalCode(), StaffExpense);
    end;
    procedure RunWorkflowOnApproveStaffExpenseApprovalCode(): Code[128]begin
        exit(UpperCase('RunWorkflowOnApproveStaffExpenseApproval'))end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    local procedure RunWorkflowOnApproveStaffExpenseApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveStaffExpenseApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    procedure RunWorkflowOnRejectStaffExpenseApprovalCode(): Code[128]begin
        exit(UpperCase('RunWorkflowOnRejectStaffExpenseApproval'))end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure RunWorkflowOnRejectStaffExpenseApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnRejectStaffExpenseApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    procedure RunWorkflowOnDelegateStaffExpenseApprovalCode(): Code[128]begin
        exit(UpperCase('RunWorkflowOnDelegateStaffExpenseApproval'))end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDelegateApprovalRequest', '', false, false)]
    local procedure RunWorkflowOnDelegateStaffExpenseApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegateStaffExpenseApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    procedure SetStatusToPendingApprovalCodeStaffExpense(): Code[128]begin
        exit(UpperCase('SetStatusToPendingApprovalStaffExpense'));
    end;
    procedure SetStatusToPendingApprovalStaffExpense(var Variant: Variant)
    var
        RecRef: RecordRef;
        StaffExpense: Record 50130;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number()of 50130: begin
            RecRef.SetTable(StaffExpense);
            StaffExpense.Validate(Status, StaffExpense.Status::"Pending Approval");
            StaffExpense.Modify();
            Variant:=StaffExpense;
        end;
        end;
    end;
    procedure ReleaseStaffExpenseCode(): Code[128]begin
        exit(UpperCase('ReleaseStaffExpense'));
    end;
    procedure ReleaseStaffExpense(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        StaffExpense: Record 50130;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number()of DATABASE::"Approval Entry": begin
            ApprovalEntry:=Variant;
            TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
            Variant:=TargetRecRef;
            ReleaseStaffExpense(Variant);
        end;
        50130: begin
            RecRef.SetTable(StaffExpense);
            StaffExpense.Validate(Status, StaffExpense.Status::Approved);
            StaffExpense.Modify();
            Variant:=StaffExpense;
        end;
        end;
    end;
    procedure ReOpenStaffExpenseCode(): Code[128]begin
        exit(UpperCase('ReOpenStaffExpense'));
    end;
    procedure ReOpenStaffExpense(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        StaffExpense: Record 50130;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number()of DATABASE::"Approval Entry": begin
            ApprovalEntry:=Variant;
            TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
            Variant:=TargetRecRef;
            ReOpenStaffExpense(Variant);
        end;
        50130: begin
            RecRef.SetTable(StaffExpense);
            StaffExpense.Validate(Status, StaffExpense.Status::Open);
            StaffExpense.Modify();
            Variant:=StaffExpense;
        end;
        end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure AddStaffExpenseEventToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendStaffExpenseApprovalCode(), 50130, copystr(SendStaffExpenseReq, 1, 250), 0, false); //
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveStaffExpenseApprovalCode(), Database::"Approval Entry", Copystr(AppReqStaffExpense, 1, 250), 0, false); //
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnRejectStaffExpenseApprovalCode(), Database::"Approval Entry", Copystr(RejReqStaffExpense, 1, 250), 0, false); //
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnDelegateStaffExpenseApprovalCode(), Database::"Approval Entry", Copystr(DelReqStaffExpense, 1, 250), 0, false); //
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure AddStaffExpenseRespToLibrary()
    begin
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCodeStaffExpense(), 0, Copystr(SendForPendAppTxt, 1, 250), 'GROUP 0'); //
        WorkflowResponseHandling.AddResponseToLibrary(ReleaseStaffExpenseCode(), 0, Copystr(ReleaseStaffExpenseTxt, 1, 250), 'GROUP 0'); //
        WorkflowResponseHandling.AddResponseToLibrary(ReOpenStaffExpenseCode(), 0, Copystr(ReOpenStaffExpenseTxt, 1, 250), 'GROUP 0'); //
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    local procedure ExeRespForStaffExpense(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        if WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name")then case WorkflowResponse."Function Name" of SetStatusToPendingApprovalCodeStaffExpense(): begin
                SetStatusToPendingApprovalStaffExpense(Variant);
                ResponseExecuted:=true;
            end;
            ReleaseStaffExpenseCode(): begin
                ReleaseStaffExpense(Variant);
                ResponseExecuted:=true;
            end;
            ReOpenStaffExpenseCode(): begin
                ReOpenStaffExpense(Variant);
                ResponseExecuted:=true;
            end;
            end;
    end;
}
