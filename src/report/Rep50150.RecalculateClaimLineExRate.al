report 50150 "Recalculate Claim Line Ex.Rate"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Staff Expense Claim form Heade"; "Staff Expense Claim form Heade")
        {
            RequestFilterFields = "EXP Form No.", "Apply Date";

            trigger OnAfterGetRecord()
            var
                l_Rec_ClaimLine: Record "Staff Expense Claim form Line";
            begin
                VALIDATE("Staff No.");
                MODIFY;
                l_Rec_ClaimLine.RESET;
                l_Rec_ClaimLine.SETRANGE("EXP Form No.", "EXP Form No.");
                IF l_Rec_ClaimLine.FINDSET THEN repeat l_Rec_ClaimLine.VALIDATE("Currency Code");
                        l_Rec_ClaimLine.MODIFY;
                    UNTIL l_Rec_ClaimLine.NEXT = 0;
            end;
        }
    }
    var myInt: Integer;
}
