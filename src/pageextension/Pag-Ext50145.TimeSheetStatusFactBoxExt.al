pageextension 50145 TimeSheetStatusFactBoxExt extends "Time Sheet Status FactBox"
{
    layout
    {
        addbefore(Comment)
        {
            field("Work Percent"; WorkPercent)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Work Percent';
            }
        }
    }
    var WorkPercent: Decimal;
    procedure SetWorkPercent(var TimeSheetHeader: Record "Time Sheet Header")
    var
        TimeSheetLine: Record "Time Sheet Line";
    begin
        WorkPercent:=0;
        TimeSheetLine.Reset();
        TimeSheetLine.SetRange("Time Sheet No.", TimeSheetHeader."No.");
        if TimeSheetLine.FindSet()then repeat WorkPercent:=WorkPercent + TimeSheetLine."Work Percent";
            until TimeSheetLine.Next() = 0;
    end;
}
