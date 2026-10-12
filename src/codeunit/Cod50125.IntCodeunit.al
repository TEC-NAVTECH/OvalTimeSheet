codeunit 50125 IntCodeunit
{
    trigger OnRun()
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnSendStaffExpenseforApproval(var StaffExpense: Record 50130);
    begin
    end;
    procedure IsStaffExpenseEnabled(var StaffExpense: Record 50130): Boolean var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit WFCode;
    begin
        exit(WFMngt.CanExecuteWorkflow(StaffExpense, WFCode.RunWorkflowOnSendStaffExpenseApprovalCode()))end;
    local procedure CheckWorkflowEnabled(): Boolean var
        StaffExpense: Record 50130;
        NoWorkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';
    begin
        if not IsStaffExpenseEnabled(StaffExpense)then Error(NoWorkflowEnb);
    end;
    var
}
