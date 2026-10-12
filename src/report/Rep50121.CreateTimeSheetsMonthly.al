report 50121 "Create Time Sheets Monthly"
{
    // version NAVW113.00
    ApplicationArea = ALL;
    Caption = 'Create Time Sheets Monthly';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number);

            dataitem(Resource; Resource)
            {
                //                DataItemTableView = WHERE (Use Time Sheet = CONST (Yes));
                //DataItemTableView = where (Use Time Sheet = const(yes));
                RequestFilterFields = "No.", Type;

                trigger onpredataitem()
                var
                begin
                    setrange("Use Time Sheet", true);
                    if HidResourceFilter <> '' then SETFILTER("No.", HidResourceFilter);
                end;
                trigger OnAfterGetRecord()
                var
                    TimeSheetMgt: Codeunit "Time Sheet Management";
                begin
                    if(resource.Blocked)then Error('You can not create time sheet when resource is blocked');
                    if(format(resource."Close Date") <> '') and (resource."Close Date" <= StartingDate)then Error('You can not create time sheet when resource is blocked');
                    //IF CheckExistingPeriods THEN BEGIN //comment function to allow create multiple time sheet for same period
                    TimeSheetHeader.INIT();
                    TimeSheetHeader."No.":=NoSeriesMgt.GetNextNo(ResourcesSetup."Time Sheet Nos.", TODAY, true);
                    TimeSheetHeader."Starting Date":=StartingDate;
                    TimeSheetHeader."Ending Date":=EndingDate;
                    TimeSheetHeader.VALIDATE("Resource No.", "No.");
                    TimeSheetHeader."Time Sheet Monthly":=true;
                    TimeSheetHeader."Time Sheet Type":=TimeSheetType;
                    TimeSheetHeader."Time Sheet Nature":=TimeSheetNature;
                    TimeSheetHeader."Time Sheet No.":=TimeSheetHeader."No.";
                    TimeSheetHeader.INSERT(true);
                    TimeSheetCounter+=1;
                    if CreateLinesFromJobPlanning then TimeSheetMgt.CreateLinesFromJobPlanning(TimeSheetHeader);
                //END;
                end;
                trigger OnPostDataItem()
                begin
                    StartingDate:=CALCDATE('<1M>', StartingDate);
                end;
            }
            trigger OnAfterGetRecord()
            begin
                //EndingDate := CALCDATE('<1W>',StartingDate) - 1;
                EndingDate:=CALCDATE('<1M>', StartingDate) - 1;
            end;
            trigger OnPreDataItem()
            begin
                SETRANGE(Number, 1, NoOfPeriods);
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(StartingDate_; StartingDate) //
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the first date of the time sheet.';

                        trigger OnValidate()
                        begin
                            ValidateStartingDate();
                        end;
                    }
                    field(NoOfPeriods_; NoOfPeriods)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'No. of Periods';
                        MinValue = 1;
                        ToolTip = 'Specifies the number of periods that the time sheet covers, such as 1 or 4.';
                    }
                    field(TimeSheetType_; TimeSheetType)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Time Sheet Type';
                        OptionCaption = 'Hour,Percent'; //
                    }
                    field(TimeSheetNature_; TimeSheetNature)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Time Sheet Nature';
                        OptionCaption = 'Actual,Projected'; //
                    }
                //field(CreateLinesFromJobPlanning; CreateLinesFromJobPlanning)
                //{
                //   ApplicationArea = Jobs;
                //   Caption = 'Create Lines From Job Planning';
                //   ToolTip = 'Specifies if you want to create time sheet lines that are based on job planning lines.';
                //}
                }
            }
        }
        actions
        {
        }
        trigger OnOpenPage()
        var
        //TimeSheetMgt: Codeunit "Time Sheet Management";
        begin
            if NoOfPeriods = 0 then NoOfPeriods:=1;
            //IF TimeSheetHeader.FINDLAST THEN
            //    StartingDate := TimeSheetHeader."Ending Date" + 1
            //ELSE
            //StartingDate := TimeSheetMgt.FindNearestTimeSheetStartDate(WORKDATE);
            StartingDate:=DMY2DATE(1, DATE2DMY(WorkDate(), 2), DATE2DMY(WorkDate(), 3));
            TimeSheetType:=TimeSheetType::Percent;
            TimeSheetNature:=TimeSheetNature::Actual;
        end;
    }
    labels
    {
    }
    trigger OnInitReport()
    begin
        ResourcesSetup.GET();
    end;
    trigger OnPostReport()
    begin
        if not HideDialog then MESSAGE(Text003, TimeSheetCounter);
    end;
    trigger OnPreReport()
    var
        UserSetup: Record "User Setup";
        i: Integer;
        LastDate: Date;
        FirstAccPeriodStartingDate: Date;
        LastAccPeriodStartingDate: Date;
    begin
        if(not UserSetup.GET(USERID) or not UserSetup."Time Sheet Admin.") and UserSetup.WRITEPERMISSION then begin
            if CONFIRM(OpenUserSetupQst, true)then PAGE.RUN(PAGE::"User Setup");
            ERROR('');
        end;
        if not UserSetup."Time Sheet Admin." then ERROR(Text002);
        if StartingDate = 0D then ERROR(Text004, Text005);
        if NoOfPeriods = 0 then ERROR(Text004, Text006);
        //ResourcesSetup.TESTFIELD("Time Sheet Nos.");
        //EndingDate := CALCDATE('<1W>',StartingDate);
        EndingDate:=CALCDATE('<1M>', StartingDate);
        LastDate:=StartingDate;
        for i:=1 to NoOfPeriods do //LastDate := CALCDATE('<1W>',LastDate);
 LastDate:=CALCDATE('<1M>', LastDate);
        if AccountingPeriod.ISEMPTY then begin
            FirstAccPeriodStartingDate:=CALCDATE('<-CM>', StartingDate);
            LastAccPeriodStartingDate:=CALCDATE('<CM>', StartingDate);
        end
        else
        begin
            AccountingPeriod.SETFILTER("Starting Date", '..%1', StartingDate);
            AccountingPeriod.FINDLAST();
            FirstAccPeriodStartingDate:=AccountingPeriod."Starting Date";
            AccountingPeriod.SETFILTER("Starting Date", '..%1', LastDate);
            AccountingPeriod.FINDLAST();
            LastAccPeriodStartingDate:=AccountingPeriod."Starting Date";
            AccountingPeriod.SETRANGE("Starting Date", FirstAccPeriodStartingDate, LastAccPeriodStartingDate);
            AccountingPeriod.FINDSET();
            repeat AccountingPeriod.TESTFIELD(Closed, false);
            until AccountingPeriod.NEXT() = 0;
        end;
    end;
    var AccountingPeriod: Record "Accounting Period";
    Timesheetreport: Report "Create Time Sheets";
    ResourcesSetup: Record "Resources Setup";
    TimeSheetHeader: Record "Time Sheet Header";
    //NoSeriesMgt: Codeunit NoSeriesManagement;//SS Replaced by No. Series by MS
    NoSeriesMgt: Codeunit "No. Series";
    HidResourceFilter: Code[250];
    StartingDate: Date;
    EndingDate: Date;
    TimeSheetCounter: Integer;
    NoOfPeriods: Integer;
    TimeSheetType: Option Hour, Percent;
    TimeSheetNature: Option Actual, Projected;
    CreateLinesFromJobPlanning: Boolean;
    Text002: Label 'Time sheet administrator only is allowed to create time sheets.';
    Text003: Label '%1 time sheets have been created.', Comment = '%1';
    Text004: Label '%1 must be filled in.', Comment = '%1';
    Text005: Label 'Starting Date';
    Text006: Label 'No. of Periods';
    Text010: Label 'Starting Date must be %1.', Comment = '%1';
    HideDialog: Boolean;
    OpenUserSetupQst: Label 'You aren''t allowed to run this report. If you want, you can give yourself the Time Sheet Admin. rights, and then try again.\\ Do you want to do that now?';
    //[Scope('Personalization')]
    procedure InitParameters(NewStartingDate: Date; NewNoOfPeriods: Integer; NewResourceFilter: Code[250]; NewCreateLinesFromJobPlanning: Boolean; NewHideDialog: Boolean)
    begin
        CLEARALL();
        ResourcesSetup.GET();
        StartingDate:=NewStartingDate;
        NoOfPeriods:=NewNoOfPeriods;
        HidResourceFilter:=NewResourceFilter;
        CreateLinesFromJobPlanning:=NewCreateLinesFromJobPlanning;
        HideDialog:=NewHideDialog;
    end;
    local procedure CheckExistingPeriods(): Boolean begin
        TimeSheetHeader.SETRANGE("Resource No.", Resource."No.");
        TimeSheetHeader.SETRANGE("Starting Date", StartingDate);
        TimeSheetHeader.SETRANGE("Ending Date", EndingDate);
        if TimeSheetHeader.FINDFIRST()then exit(false);
        exit(true);
    end;
    local procedure ValidateStartingDate()
    begin
        //IF DATE2DWY(StartingDate, 1) <> ResourcesSetup."Time Sheet First Weekday" + 1 THEN
        //    ERROR(Text010, ResourcesSetup."Time Sheet First Weekday");
        if DATE2DMY(StartingDate, 1) <> 1 then ERROR('Starting Date must be first date of month');
    end;
}
