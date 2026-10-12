pageextension 50120 MyExtension extends "Team Member Activities"
{
    layout
    {
        //addafter("Time Sheets to Approve")
        // {
        //    field("Requests to Approve1"; "Requests to Approve")
        //    {
        //        ApplicationArea = Basic, Suite;
        //        DrillDownPageId = "Requests to Approve";
        //
        //          }
        //    }
        addafter(Approvals)
        {
            cuegroup(StaffExpense)
            {
                Caption = 'Staff Expense Form';

                field("Staff Expense Claim"; NoofOpenExpApproval)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Open Staff Expense';

                    //DrillDownPageID = "Staff Expense Claim List";
                    //DrillDownPageId = "Item Picture";
                    trigger OnDrillDown()
                    begin
                        OpenStaffExpDrillDown(0);
                    end;
                }
                field("Staff Expense Approval"; NoOfPendingExpApproval)
                {
                    Caption = 'Pending Staff Expense';
                    ApplicationArea = Basic, Suite;

                    //DrillDownPageID = "Staff Expense Claim List";
                    //DrillDownPageId = "Item Picture";
                    trigger OnDrillDown()
                    begin
                        OpenStaffExpDrillDown(1);
                    end;
                }
                field("Rejected Staff Expense"; NoofRejectedExpApproval)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Rejected Staff Expense';

                    //DrillDownPageID = "Staff Expense Claim List";
                    //DrillDownPageId = "Item Picture";
                    trigger OnDrillDown()
                    begin
                        OpenStaffExpDrillDown(4);
                    end;
                }
                field("Approved Staff Expense"; NoOfApprovedExpApproval)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Approved Staff Expense';

                    //DrillDownPageID = "Staff Expense Claim List";
                    //DrillDownPageId = "Item Picture";
                    trigger OnDrillDown()
                    begin
                        OpenStaffExpDrillDown(3);
                    end;
                }
            }
        }
        addafter("Time Sheets to Approve")
        {
            field("Manager Timesheet by Job Month"; Rec."Manager Timesheet by Job Month")
            {
                ApplicationArea = ALL;
                DrillDownPageId = "Manager TS by Job Monthly";
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        //Count staff expense form
        ResourceFilterText:='';
        NoofOpenExpApproval:=StaffExpHeader.StaffExpFilter(StaffExpHeader, 0);
        NoOfPendingExpApproval:=StaffExpHeader.StaffExpFilter(StaffExpHeader, 1);
        NoOfApprovedExpApproval:=StaffExpHeader.StaffExpFilter(StaffExpHeader, 3);
        NoofRejectedExpApproval:=StaffExpHeader.StaffExpFilter(StaffExpHeader, 4);
    //Message(StaffExpHeader.GetFilters());
    //Count staff expense form
    end;
    local procedure OpenStaffExpDrillDown(Status: Integer)
    var
        l_rc_StaffExpHdr: Record "Staff Expense Claim form Heade";
    begin
        StaffExpHeader.StaffExpFilter(l_rc_StaffExpHdr, Status);
        page.RunModal(Page::"Staff Expense Claim List", l_rc_StaffExpHdr);
    end;
    var Resource: Record Resource;
    StaffExpHeader: Record "Staff Expense Claim form Heade";
    ResourceFilterText: Text;
    NoofStaffForm: Integer;
    UserSetup: Record "User Setup";
    NoOfStaffExpApproval: Integer;
    NoofOpenExpApproval: Integer;
    NoOfPendingExpApproval: Integer;
    NoOfApprovedExpApproval: Integer;
    NoofRejectedExpApproval: Integer;
}
