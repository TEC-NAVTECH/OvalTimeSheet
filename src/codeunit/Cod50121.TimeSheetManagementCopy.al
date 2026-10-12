codeunit 50121 "Time Sheet Management Copy"
{
    // version NAVW113.00
    Permissions = tabledata 958=ri,
        tabledata 1003=r,
        tabledata 5200=r;

    trigger OnRun()
    begin
    end;
    var Text001: Label 'M,T,W,T,F,S,S';
    Text002: Label '%1 is already defined as Time Sheet Owner User ID for Resource No. %2 with type %3.', Comment = '%1 User1 is already defined as Resources for Resource No. LIFT with type Machine.';
    Text003: Label 'Time Sheet Header %1 is not found.', Comment = 'Time Sheet Header Archive 10 is not found.';
    Text004: Label 'cannot be greater than %1 %2.', Comment = '%1 - Quantity, %2 - Unit of measure. Example: Quantity cannot be greater than 8 HOUR.';
    Text005: Label 'Time Sheet Header Archive %1 is not found.', Comment = '%1 Time Sheet Header Archive 10 is not found.';
    TimeSheetManagment: Codeunit "Time Sheet Management";
    //[Scope('Personalization')]
    procedure CalcActSchedFactBoxDataMonthly(TimeSheetHeader: Record "Time Sheet Header"; var DateDescription: array[32]of Text[30]; var DateQuantity: array[32]of Text[30]; var TotalQtyText: Text[30]; var TotalPresenceQty: Decimal; var AbsenceQty: Decimal)
    var
        Resource: Record "Resource";
        Calendar: Record "Date";
        TotalSchedQty: Decimal;
        i: Integer;
    begin
        TotalPresenceQty:=0;
        if Resource.GET(TimeSheetHeader."Resource No.")then begin
            Calendar.SETRANGE("Period Type", Calendar."Period Type"::Date);
            Calendar.SETRANGE("Period Start", TimeSheetHeader."Starting Date", TimeSheetHeader."Ending Date");
            if Calendar.FINDSET()then repeat i+=1;
                    DateDescription[i]:=TimeSheetManagment.FormatDate(Calendar."Period Start", 0);
                    TimeSheetHeader.SETRANGE("Date Filter", Calendar."Period Start");
                    TimeSheetHeader.CALCFIELDS(Quantity);
                    Resource.SETRANGE("Date Filter", Calendar."Period Start");
                    Resource.CALCFIELDS(Capacity);
                    DateQuantity[i]:=TimeSheetManagment.FormatActualSched(TimeSheetHeader.Quantity, Resource.Capacity);
                    TotalPresenceQty+=TimeSheetHeader.Quantity;
                    TotalSchedQty+=Resource.Capacity;
                until Calendar.NEXT() = 0;
            TotalQtyText:=TimeSheetManagment.FormatActualSched(TotalPresenceQty, TotalSchedQty);
            TimeSheetHeader.SETRANGE("Type Filter", TimeSheetHeader."Type Filter"::Absence);
            TimeSheetHeader.SETRANGE("Date Filter", TimeSheetHeader."Starting Date", TimeSheetHeader."Ending Date");
            TimeSheetHeader.CALCFIELDS(Quantity);
            AbsenceQty:=TimeSheetHeader.Quantity;
        end;
    end;
    [EventSubscriber(ObjectType::Table, database::"Time Sheet Line", 'OnAfterValidateEvent', 'Job No.', true, true)]
    local procedure SetDefaultJobTaskNo(var Rec: Record "Time Sheet Line")
    var
        TimeSheetHeader: Record "Time Sheet Header";
        RecJob: Record Job;
    begin
        Rec.Validate("Job Task No.", '2000');
        RecJob.Get(Rec."Job No.");
        Rec.Description:=RecJob.Description;
        if TimeSheetHeader.get(Rec."Time Sheet No.")then begin
            Rec.Validate("Timesheet Nature", TimeSheetHeader."Time Sheet Nature");
            rec.Validate("Time Sheet Type", TimeSheetHeader."Time Sheet Type");
        end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', false, false)]
    local procedure cehckdocument()
    begin
    //message('check positing');
    end;
}
