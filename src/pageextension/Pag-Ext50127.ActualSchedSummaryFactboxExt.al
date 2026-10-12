pageextension 50127 ActualSchedSummaryFactboxExt extends "Actual/Sched. Summary FactBox"
{
    procedure UpdateDataMonthly(TimeSheetHeader: Record "Time Sheet Header")
    var
        //TimeSheetMgt: Codeunit "Time Sheet Management";
        DateDescription: array[32]of Text[30];
        DateQuantity: array[32]of Text[30];
        TotalQtyText: Text[30];
        TotalQuantity: Decimal;
        //PresenceQty: Decimal;
        AbsenceQty: Decimal;
        TimeSheetMgtCopy: Codeunit "Time Sheet Management Copy";
    begin
        TimeSheetMgtCopy.CalcActSchedFactBoxDataMonthly(TimeSheetHeader, DateDescription, DateQuantity, TotalQtyText, TotalQuantity, AbsenceQty);
        //PresenceQty := TotalQuantity - AbsenceQty;
        CurrPage.UPDATE(false);
    end;
}
