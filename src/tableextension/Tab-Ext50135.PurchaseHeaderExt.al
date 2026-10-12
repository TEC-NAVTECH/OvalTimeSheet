tableextension 50135 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here
        field(50101; "Staff Expense Form No."; Code[35])
        {
            DataClassification = ToBeClassified;
            //FieldPropertyName = FieldPropertyValue;
            TableRelation = "Staff Expense Claim form Heade";
        //Editable = false;
        }
    }
    trigger OnBeforeDelete()
    var
        l_Rec_StaffExpHdr: Record "Staff Expense Claim form Heade";
    begin
        l_Rec_StaffExpHdr.RESET();
        l_Rec_StaffExpHdr.SETRANGE("EXP Form No.", "Staff Expense Form No.");
        if l_Rec_StaffExpHdr.FINDSET()then begin
            l_Rec_StaffExpHdr."Invoice Created":=false;
            l_Rec_StaffExpHdr."Invoice No.":='';
            l_Rec_StaffExpHdr.MODIFY();
        end;
    end;
    var myInt: Integer;
}
