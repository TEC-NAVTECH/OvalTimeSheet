pageextension 50142 "Team Member RC Ext" extends "Team Member Role Center"
{
    actions
    {
        addlast(Finance)
        {
            action("Expense Claim Form")
            {
                ApplicationArea = All;
                Caption = 'Expense Claim Form';
                RunObject = page "Staff Expense Claim List";
            }
        // Add changes to page actions here
        }
    }
}
