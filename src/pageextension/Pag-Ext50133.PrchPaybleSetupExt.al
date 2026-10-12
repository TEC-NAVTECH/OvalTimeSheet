pageextension 50133 "Prch. & Payble Setup Ext." extends "Purchases & Payables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("Staff Expense Claim Nos"; Rec."Staff Expense Claim Nos")
            {
                ApplicationArea = ALL;
                TableRelation = "No. Series";
            }
        }
    }
}
