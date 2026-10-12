pageextension 50154 "User Setup List" extends "User Setup"
{
    layout
    {
        addafter("Time Sheet Admin.")
        {
            field("Staff Expense Form Admin"; Rec."Staff Expense Form Admin")
            {
                ApplicationArea = all;
            }
            field("Staff Expense Appr. Checking"; Rec."Staff Expense Bypass Appr. Checking")
            {
                ApplicationArea = all;
            }
        }
    }
}
