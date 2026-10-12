report 50125 "Create Staff Exp Form"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(Resource; Resource)
        {
            RequestFilterFields = "No.", Type;

            trigger OnAfterGetRecord()
            begin
                NoofFormCreated+=1;
                StaffExpenseClaimHeader."EXP Form No.":=' ';
                StaffExpenseClaimHeader.INSERT(true);
                StaffExpenseClaimHeader."Created User":="Time Sheet Owner User ID";
                StaffExpenseClaimHeader.VALIDATE("Staff No.", Resource."No.");
                StaffExpenseClaimHeader."Apply Date":=StartingDate;
                StaffExpenseClaimHeader.MODIFY();
            end;
            trigger OnPostDataItem()
            begin
                Message('No. of %1 forms are created', NoofFormCreated);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                field("Starting Date"; StartingDate)
                {
                    ApplicationArea = All; //
                    Caption = 'Starting Date'; //
                }
            }
        }
        actions
        {
        }
    }
    labels
    {
    }
    trigger OnPreReport()
    begin
        if StartingDate <> CALCDATE('<-CM>', StartingDate)then ERROR('Start Date must be first date of month');
    end;
    var StartingDate: Date;
    StaffExpenseClaimHeader: Record "Staff Expense Claim form Heade";
    NoofFormCreated: Integer;
}
