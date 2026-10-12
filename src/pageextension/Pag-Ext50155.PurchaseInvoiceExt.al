pageextension 50155 "Purchase Invoice Ext" extends "Purchase Invoice"
{
    layout
    {
        modify("Vendor Invoice No.")
        {
            //Editable = false;
            trigger OnAfterValidate()
            begin
                if Rec."Staff Expense Form No." <> '' then if Rec."Vendor Invoice No." <> xRec."Vendor Invoice No." then Error('You can not modify this field');
            end;
            trigger OnLookup(var Text: Text): Boolean var
                StaffExpClaimHeader: Record "Staff Expense Claim form Heade";
                StffExpClaim: Page "Staff Expense Claim";
            begin
                StaffExpClaimHeader.SETRANGE("EXP Form No.", Rec."Vendor Invoice No.");
                if StaffExpClaimHeader.FindFirst()then begin
                    StffExpClaim.SetTableView(StaffExpClaimHeader);
                    StffExpClaim.SetRecord(StaffExpClaimHeader);
                    StffExpClaim.LookupMode(true);
                    StffExpClaim.RunModal();
                end;
            //PAGE.RunModal(50134, StaffExpClaimHeader);
            end;
        }
        modify("Posting Description")
        {
            ApplicationArea = all;
            Visible = true;
            Editable = true;
        }
    }
}
