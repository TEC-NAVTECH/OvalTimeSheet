pageextension 50156 "Posted Purchase Invoice Ext" extends "Posted Purchase Invoice"
{
    actions
    {
        addafter(Approvals)
        {
            action("Staff Expense Form")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Form;
                RunObject = page "Staff Expense Claim";
                RunPageLink = "EXP Form No."=field("Vendor Invoice No.");
                ApplicationArea = All; //
            }
        }
    }
}
