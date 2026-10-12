pageextension 50140 "Job Project Manager RC Ext" extends "Job Project Manager RC"
{
    actions
    {
        addlast(NewGroup)
        {
            // group(new)
            // {
            action("Expense Claim Form")
            {
                ApplicationArea = All;
                Caption = 'Expense Claim Form';
                Image = Document;
                //Promoted = true;
                //PromotedCategory = New;
                RunObject = page "Staff Expense Claim List";
            }
        // Add changes to page actions here
        //}
        }
    }
}
