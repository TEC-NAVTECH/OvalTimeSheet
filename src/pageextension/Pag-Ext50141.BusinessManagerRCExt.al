pageextension 50141 "Business Manager RC Ext" extends "Business Manager Role Center"
{
    actions
    {
        addafter("Purchase Invoice")
        {
            action("Expense Claim Form")
            {
                ApplicationArea = All;
                Caption = 'Expense Claim Form';
                Image = NewPurchaseInvoice;
                RunObject = page "Staff Expense Claim List";
            }
        // Add changes to page actions here
        }
    }
}
