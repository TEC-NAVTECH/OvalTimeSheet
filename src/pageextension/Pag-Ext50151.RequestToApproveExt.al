pageextension 50151 "Request To Approve Ext" extends "Requests to Approve"
{
    layout
    {
        addafter(ToApprove)
        {
            field("Project Description"; ProjDesc)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Project Description'; //
            }
            field("Expense Category Description"; ExpCatDesc)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Expense Category Description'; //
            }
            field(Amount1; Rec.Amount)
            {
                ApplicationArea = all;
                Caption = 'Amount';
            }
        }
        modify(Amount)
        {
            Visible = false;
        }
    }
    trigger OnAfterGetRecord()
    begin
        ProjDesc:='';
        ExpCatDesc:='';
        if Rec."Table ID" = 50129 then begin
            if RecRef.Get(Rec."Record ID to Approve")then;
            RecRef.SetTable(StaffExpLine);
            ProjDesc:=StaffExpLine."Project Name";
            ExpCatDesc:=StaffExpLine."Expense Category Description";
        end;
    end;
    var ProjDesc: Text[100];
    ExpCatDesc: Text[100];
    RecRef: RecordRef;
    StaffExpLine: Record "Staff Expense Claim form Line";
}
