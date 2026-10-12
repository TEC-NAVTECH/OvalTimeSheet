page 50126 "Time Sheet Monthly"
{
    // version NAVW113.00
    ApplicationArea = all;
    UsageCategory = Tasks;
    AutoSplitKey = true;
    Caption = 'Time Sheet Monthly';
    DataCaptionFields = "Time Sheet No.";
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Navigate,Lines';
    RefreshOnActivate = true;
    SaveValues = true;
    SourceTable = "Time Sheet Line";
    SourceTableView = sorting(Type, "Job No."); //#001

    layout
    {
        area(content)
        {
            group(Group)
            {
                field(CurrTimeSheetNo; CurrTimeSheetNo)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Time Sheet No';
                    ToolTip = 'Specifies the number of the time sheet.';

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        CurrPage.SAVERECORD();
                        TimeSheetMgt.LookupOwnerTimeSheet(CurrTimeSheetNo, Rec, TimeSheetHeader);
                        UpdateControls();
                    end;
                    trigger OnValidate();
                    begin
                        TimeSheetHeader.RESET();
                        TimeSheetMgt.FilterTimeSheets(TimeSheetHeader, TimeSheetHeader.FIELDNO("Owner User ID"));
                        TimeSheetMgt.CheckTimeSheetNo(TimeSheetHeader, CurrTimeSheetNo);
                        CurrPage.SAVERECORD();
                        TimeSheetMgt.SetTimeSheetNo(CurrTimeSheetNo, Rec);
                        UpdateControls();
                    end;
                }
                field(ResourceNo; TimeSheetHeader."Resource No.")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource No.';
                    Editable = false;
                    ToolTip = 'Specifies a number for the resource.';
                }
                field(ApproverUserID; TimeSheetHeader."Approver User ID")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Approver User ID';
                    Editable = false;
                    ToolTip = 'Specifies the ID of the time sheet approver.';
                    Visible = false;
                }
                field(StartingDate; TimeSheetHeader."Starting Date")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Starting Date';
                    Editable = false;
                    ToolTip = 'Specifies the date from which the report or batch job processes information.';
                }
                field(EndingDate; TimeSheetHeader."Ending Date")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Ending Date';
                    Editable = false;
                    ToolTip = 'Specifies the date to which the report or batch job processes information.';
                }
                field(TimeSheetMonthly; TimeSheetHeader."Time Sheet Monthly")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Time Sheet Monthly';
                    Editable = false;
                }
                field(TimeSheetType; TimeSheetHeader."Time Sheet Type")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Time Sheet Type';
                    Editable = false;
                }
                field(TimesheetNature; TimeSheetHeader."Time Sheet Nature")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Time Sheet Nature';
                    Editable = false;
                }
                field(ResourceName; TimeSheetHeader."Resource Name")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource Name';
                    Editable = false;
                }
            }
            repeater(Lines)
            {
                FreezeColumn = "Total Hours";

                field(Type; Rec.Type)
                {
                    ApplicationArea = Jobs;
                    Editable = AllowEdit;
                    ToolTip = 'Specifies the type of time sheet line.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        AfterGetCurrentRecord();
                        CurrPage.UPDATE(true);
                    end;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = Jobs;
                    Editable = AllowEdit;
                    ToolTip = 'Specifies the number for the job that is associated with the time sheet line.';

                    //Visible = false;
                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                    end;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = Jobs;
                    Editable = AllowEdit;
                    ToolTip = 'Specifies the number of the related job task.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Jobs;
                    Editable = AllowEdit;
                    ToolTip = 'Specifies a description of the time sheet line.';
                    AssistEdit = true;

                    trigger OnAssistEdit();
                    begin
                        if Rec."Line No." = 0 then exit;
                        Rec.ShowLineDetails(false);
                        CurrPage.UPDATE(false);
                    end;
                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                    end;
                }
                field("Cause of Absence Code"; Rec."Cause of Absence Code")
                {
                    ApplicationArea = Jobs;
                    Editable = AllowEdit;
                    ToolTip = 'Specifies a list of standard absence codes, from which you may select one.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                    end;
                }
                field(Chargeable; Rec.Chargeable)
                {
                    ApplicationArea = Jobs;
                    Editable = AllowEdit;
                    ToolTip = 'Specifies if the usage that you are posting is chargeable.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                    end;
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ApplicationArea = Jobs;
                    Editable = AllowEdit;
                    ToolTip = 'Specifies which work type the resource applies to. Prices are updated based on this entry.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                    end;
                }
                field("Service Order No."; Rec."Service Order No.")
                {
                    ApplicationArea = Jobs;
                    Editable = AllowEdit;
                    ToolTip = 'Specifies the service order number that is associated with the time sheet line.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                    end;
                }
                field("Assembly Order No."; Rec."Assembly Order No.")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the assembly order number that is associated with the time sheet line.';
                    Visible = false;
                }
                field("Percent Per Month"; Rec."Percent Per Month")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'enter percent if time sheet type is percent';
                    Visible = ShowDates;
                }
                field("Estimated Work Hour"; Rec."Estimated Work Hour")
                {
                    ApplicationArea = Assembly;
                    Visible = not ShowDates;
                    Editable = false;
                }
                field("Total Hours"; Rec."Total Quantity")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Total Hours per job';
                    Caption = 'Total Qty';
                }
                field("Timesheet Nature"; Rec."Timesheet Nature")
                {
                    ApplicationArea = Assembly;
                    Visible = false;
                }
                field("Work Percent"; Rec."Work Percent")
                {
                    ApplicationArea = all;
                    Visible = not ShowDates;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Field1; CellData[1])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[1];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(1);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field2; CellData[2])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[2];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(2);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field3; CellData[3])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[3];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(3);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field4; CellData[4])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[4];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(4);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field5; CellData[5])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[5];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(5);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field6; CellData[6])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[6];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(6);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field7; CellData[7])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[7];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(7);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field8; CellData[8])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[8];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(8);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field9; CellData[9])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[9];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(9);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field10; CellData[10])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[10];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(10);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field11; CellData[11])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[11];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(11);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field12; CellData[12])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[12];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(12);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field13; CellData[13])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[13];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(13);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field14; CellData[14])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[14];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(14);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field15; CellData[15])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[15];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(15);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field16; CellData[16])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[16];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(16);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field17; CellData[17])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[17];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(17);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field18; CellData[18])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[18];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(18);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field19; CellData[19])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[19];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(19);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field20; CellData[20])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[20];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(20);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field21; CellData[21])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[21];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(21);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field22; CellData[22])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[22];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(22);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field23; CellData[23])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[23];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(23);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field24; CellData[24])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[24];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(24);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field25; CellData[25])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[25];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(25);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field26; CellData[26])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[26];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(26);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field27; CellData[27])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[27];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(27);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field28; CellData[28])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[28];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(28);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field29; CellData[29])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[29];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(29);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field30; CellData[30])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[30];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(30);
                        CellDataOnAfterValidate();
                    end;
                }
                field(Field31; CellData[31])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[31];
                    DecimalPlaces = 0: 2;
                    Editable = AllowEdit;
                    Width = 3;
                    Visible = ShowDates;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD();
                        ValidateQuantity(31);
                        CellDataOnAfterValidate();
                    end;
                }
                field("Total Quantity"; Rec."Total Quantity")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Total';
                    DrillDown = false;
                    ToolTip = 'Specifies the total number of hours that have been entered on a time sheet.';
                    Visible = false;
                }
                field("Time Sheet Type"; Rec."Time Sheet Type")
                {
                    ApplicationArea = Jobs;
                    Visible = false;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies information about the status of a time sheet line.';
                }
            }
        }
        area(factboxes)
        {
            part(TimeSheetStatusFactBox;957)
            {
                ApplicationArea = Jobs;
                Caption = 'Time Sheet Status';
            }
            part(ActualSchedSummaryFactBox;956)
            {
                ApplicationArea = Jobs;
                Caption = 'Actual/Budgeted Summary';
                Visible = false;
            }
            part(ActivityDetailsFactBox;971)
            {
                Visible = false;
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group(Print)
            {
                Caption = 'Print';
                Image = Print;

                action("Print Document")
                {
                    ApplicationArea = all;
                    Promoted = true;
                    Image = Print;
                    PromotedIsBig = true;
                    PromotedOnly = true; //

                    trigger OnAction()
                    var
                        TimeSheetHeader: Record "Time Sheet Header";
                    begin
                        CalculateTimeSheetPercent(false);
                        Commit();
                        TimeSheetHeader.SetRange("No.", rec."Time Sheet No.");
                        if TimeSheetHeader.FindFirst()then report.RunModal(Report::"Time Sheet Document Print", true, false, TimeSheetHeader);
                    end;
                }
            }
            group("&Time Sheet")
            {
                Caption = '&Time Sheet';
                Image = Timesheet;

                action(PreviousPeriod)
                {
                    ApplicationArea = Jobs;
                    Caption = '&Previous Period';
                    Image = PreviousSet;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true; //
                    ShortcutKey = 'Ctrl+PgUp';
                    ToolTip = 'Show the information based on the previous period. If you set the View by field to Day, the date filter changes to the day before.';

                    trigger OnAction();
                    begin
                        FindTimeSheet(SetWanted::Previous);
                    end;
                }
                action(NextPeriod)
                {
                    ApplicationArea = Jobs;
                    Caption = '&Next Period';
                    Image = NextSet;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortcutKey = 'Ctrl+PgDn';
                    ToolTip = 'View information for the next period.';

                    trigger OnAction();
                    begin
                        FindTimeSheet(SetWanted::Next);
                    end;
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;

                action("Time Sheet Allocation")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Time Sheet Allocation';
                    Image = Allocate;
                    ToolTip = 'Allocate posted hours among days of the week on a time sheet.';

                    trigger OnAction();
                    begin
                        TimeAllocation();
                    end;
                }
                action("Activity &Details")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Activity &Details';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ShortcutKey = 'Shift+F7';
                    ToolTip = 'View the quantity of hours for each time sheet status.';

                    trigger OnAction();
                    begin
                        Rec.ShowLineDetails(false);
                    end;
                }
            }
        // group(Comments)
        // {
        //     Caption = 'Co&mments';
        //     Image = ViewComments;
        //     action(TimeSheetComments)
        //     {
        //     }
        //     action(LineComments)
        //     {
        //     }
        // }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";

                action(Submit1)
                {
                    ApplicationArea = Jobs;
                    Caption = '&Submit';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true; //
                    ShortcutKey = 'F9';
                    ToolTip = 'Submit the time sheet for approval.';

                    trigger OnAction();
                    begin
                        Submit();
                    end;
                }
                action(Reopen1)
                {
                    ApplicationArea = Jobs;
                    Caption = '&Reopen';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true; //
                    ToolTip = 'Reopen the time sheet, for example, after it has been rejected. The approver of a time sheet has permission to approve, reject, or reopen a time sheet. The approver can also submit a time sheet for approval.';

                    trigger OnAction();
                    begin
                        Reopen();
                    end;
                }
                action("CalculatePercent")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Refresh Time Sheet';
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    begin
                        //TimeSheetHeader.TestField("Time Sheet Type", TimeSheetHeader."Time Sheet Type"::Percent);
                        CalculateTimeSheetPercent(true);
                    end;
                }
                separator(Action28)
                {
                }
                action(CopyLinesFromPrevTS)
                {
                    ApplicationArea = Jobs;
                    Caption = '&Copy lines from previous TS';
                    Image = Copy;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Copy information from the previous time sheet, such as type and description, and then modify the lines. If a line is related to a job, the job number is copied.';
                    PromotedOnly = true; //

                    trigger OnAction();
                    var
                        QtyToBeCopied: Integer;
                    begin
                        QtyToBeCopied:=TimeSheetMgt.CalcPrevTimeSheetLines(TimeSheetHeader);
                        if QtyToBeCopied = 0 then MESSAGE(Text004)
                        else if CONFIRM(Text009, true, QtyToBeCopied)then TimeSheetMgt.CopyPrevTimeSheetLines(TimeSheetHeader);
                    end;
                }
                action(CreateLinesFromJobPlanning)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Create lines from &job planning';
                    Image = CreateLinesFromJob;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Create time sheet lines that are based on job planning lines.';

                    trigger OnAction();
                    var
                        QtyToBeCreated: Integer;
                    begin
                        QtyToBeCreated:=TimeSheetMgt.CalcLinesFromJobPlanning(TimeSheetHeader);
                        if QtyToBeCreated = 0 then MESSAGE(Text003)
                        else if CONFIRM(Text010, true, QtyToBeCreated)then TimeSheetMgt.CreateLinesFromJobPlanning(TimeSheetHeader);
                    end;
                }
            }
        }
    }
    var TimeSheetHeader: Record "Time Sheet Header";
    //Timesheetpage: Page "Time Sheet";
    TimeSheetDetail: Record "Time Sheet Detail";
    TimeSheetDetail2: Record "Time Sheet Detail";
    TimeSheetLine2: Record "Time Sheet Line";
    ColumnRecords: array[32]of Record Date;
    TimeSheetMgt: Codeunit "Time Sheet Management";
    TimeSheetApprovalMgt: Codeunit "Time Sheet Approval Management";
    NoOfColumns: Integer;
    CellData: array[32]of Decimal;
    ColumnCaption: array[32]of Text[1024];
    CurrTimeSheetNo: Code[20];
    SetWanted: Option Previous, Next;
    ShowDates: Boolean;
    Text001: Label 'The type of time sheet line cannot be empty.';
    Text003: Label 'Could not find job planning lines.';
    Text004: Label 'There are no time sheet lines to copy.';
    Text009: Label 'Do you want to copy lines from the previous time sheet (%1)?', Comment = '%1'; //
    Text010: Label 'Do you want to create lines from job planning (%1)?', Comment = '%1'; //
    Text011: Label '&All open lines [%1 line(s)]', Comment = '%1'; //
    AllowEdit: Boolean;
    local procedure UpdateFactBoxes();
    begin
        CurrPage.ActualSchedSummaryFactBox.PAGE.UpdateDataMonthly(TimeSheetHeader);
        CurrPage.TimeSheetStatusFactBox.PAGE.UpdateData(TimeSheetHeader);
        CurrPage.TimeSheetStatusFactBox.Page.SetWorkPercent(TimeSheetHeader);
        if Rec."Line No." = 0 then CurrPage.ActivityDetailsFactBox.PAGE.SetEmptyLine();
    end;
    local procedure UpdateControls();
    begin
        SetColumns();
        UpdateFactBoxes();
        CurrPage.UPDATE(false);
    end;
    local procedure AfterGetCurrentRecord();
    var
        i: Integer;
    begin
        i:=0;
        while i < NoOfColumns do begin
            i:=i + 1;
            if(Rec."Line No." <> 0) and TimeSheetDetail.GET(Rec."Time Sheet No.", Rec."Line No.", ColumnRecords[i]."Period Start")then CellData[i]:=TimeSheetDetail.Quantity
            else
                CellData[i]:=0;
        end;
        UpdateFactBoxes();
        AllowEdit:=Rec.Status in[Rec.Status::Open, Rec.Status::Rejected];
    end;
    local procedure ValidateQuantity(ColumnNo: Integer);
    begin
        if(CellData[ColumnNo] <> 0) and (Rec.Type = Rec.Type::" ")then ERROR(Text001);
        if TimeSheetDetail.GET(Rec."Time Sheet No.", Rec."Line No.", ColumnRecords[ColumnNo]."Period Start")then begin
            if CellData[ColumnNo] <> TimeSheetDetail.Quantity then TestTimeSheetLineStatus();
            if CellData[ColumnNo] = 0 then TimeSheetDetail.DELETE()
            else
            begin
                TimeSheetDetail.Quantity:=CellData[ColumnNo];
                TimeSheetDetail.MODIFY(true);
            end;
        end
        else if CellData[ColumnNo] <> 0 then begin
                TestTimeSheetLineStatus();
                TimeSheetDetail.INIT();
                TimeSheetDetail.CopyFromTimeSheetLine(Rec);
                TimeSheetDetail.Date:=ColumnRecords[ColumnNo]."Period Start";
                TimeSheetDetail.Quantity:=CellData[ColumnNo];
                TimeSheetDetail.INSERT(true);
            end;
    end;
    local procedure CellDataOnAfterValidate();
    begin
        UpdateFactBoxes();
        Rec.CALCFIELDS("Total Quantity");
    //CalculateTimeSheetPercent();
    end;
    local procedure CalculateTimeSheetPercent(Showmessage: Boolean);
    var
        TimeSheetLine: Record "Time Sheet Line";
        TotalQuantity: Decimal;
        WorkPercentTotal: Decimal;
    begin
        TotalQuantity:=0;
        WorkPercentTotal:=0;
        TimeSheetLine.Reset();
        TimeSheetLine.SetRange("Time Sheet No.", Rec."Time Sheet No.");
        TimeSheetLine.SetAutoCalcFields("Total Quantity");
        if TimeSheetLine.FindSet()then repeat TotalQuantity:=TotalQuantity + TimeSheetLine."Total Quantity";
            until TimeSheetLine.Next() = 0;
        if TimeSheetHeader."Time Sheet Type" = TimeSheetHeader."Time Sheet Type"::Hour then begin
            TimeSheetLine.Reset();
            TimeSheetLine.SetRange("Time Sheet No.", Rec."Time Sheet No.");
            TimeSheetLine.SetAutoCalcFields("Total Quantity");
            if TimeSheetLine.FindSet()then repeat if TimeSheetLine."Total Quantity" = 0 then Error('Not allow to submit, please check if any blank row');
                    TimeSheetLine."Percent Per Month":=round((TimeSheetLine."Total Quantity" / TotalQuantity * 100), 0.01);
                    //message('Total qty %1..Line Qty %2..Result %3', TotalQuantity, TimeSheetLine."Total Quantity", TimeSheetLine."Percent Per Month");
                    //TimeSheetLine."Estimated Work Hour" := TimeSheetLine."Percent Per Month" * 200;
                    TimeSheetLine."Total Hours Percent":=TimeSheetLine."Percent Per Month" + TimeSheetLine."Work Percent";
                    TimeSheetLine.Modify();
                until TimeSheetLine.Next() = 0;
        end;
        //Message('%1', TimeSheetHeader."No.");
        if TimeSheetHeader."Time Sheet Type" = TimeSheetHeader."Time Sheet Type"::Percent then begin
            TimeSheetLine.Reset();
            TimeSheetLine.SetRange("Time Sheet No.", TimeSheetHeader."Time Sheet No.");
            if TimeSheetLine.FindSet()then repeat TimeSheetLine.CalcFields("Total Quantity");
                    if TotalQuantity <> 0 then TimeSheetLine."Percent Per Month":=round((TimeSheetLine."Total Quantity" / TotalQuantity * 100), 0.01);
                    //TimeSheetLine."Percent Per Month" := round((TimeSheetLine."Total Quantity" / TotalQuantity * 100), 2);
                    TimeSheetLine."Estimated Work Hour":=TimeSheetLine."Work Percent" * 200 / 100;
                    WorkPercentTotal:=WorkPercentTotal + TimeSheetLine."Work Percent";
                    TimeSheetLine.Modify();
                //Message('%1..%2', TimeSheetLine."Estimated Work Hour", TimeSheetLine."Work Percent");
                until TimeSheetLine.Next() = 0;
            if WorkPercentTotal <> 100 then Error('Work Percent must be 100 total of all lines. Current total is %1', WorkPercentTotal);
        end;
        if Showmessage then Message('Calculated');
    end;
    local procedure TestTimeSheetLineStatus();
    var
        TimeSheetLine: Record "Time Sheet Line";
    begin
        TimeSheetLine.GET(Rec."Time Sheet No.", Rec."Line No.");
        TimeSheetLine.TestStatus();
    end;
    procedure SetColumns();
    var
        Calendar: Record Date;
        Text001Copy: Label 'M,T,W,T,F,S,S';
    begin
        CLEAR(ColumnCaption);
        CLEAR(ColumnRecords);
        CLEAR(Calendar);
        CLEAR(NoOfColumns);
        TimeSheetHeader.GET(CurrTimeSheetNo);
        Calendar.SETRANGE("Period Type", Calendar."Period Type"::Date);
        Calendar.SETRANGE("Period Start", TimeSheetHeader."Starting Date", TimeSheetHeader."Ending Date");
        if Calendar.FINDSET()then repeat NoOfColumns+=1;
                ColumnRecords[NoOfColumns]."Period Start":=Calendar."Period Start";
                ColumnCaption[NoOfColumns]:=STRSUBSTNO('%1 %2', DATE2DMY(Calendar."Period Start", 1), SELECTSTR(DATE2DWY(Calendar."Period Start", 1), Text001Copy));
            //ColumnCaption[NoOfColumns] := TimeSheetMgt.FormatDate(Calendar."Period Start", 1);
            until Calendar.NEXT() = 0;
    end;
    local procedure Process("Action": Option "Submit Selected", "Submit All", "Reopen Selected", "Reopen All");
    var
        TimeSheetLine: Record "Time Sheet Line";
        TempTimeSheetLine: Record "Time Sheet Line" temporary;
        ActionType: Option Submit, Reopen;
    begin
        CalculateTimeSheetPercent(true);
        CurrPage.SAVERECORD();
        case Action of Action::"Submit All": FilterAllLines(TimeSheetLine, ActionType::Submit);
        Action::"Reopen All": FilterAllLines(TimeSheetLine, ActionType::Reopen);
        else
            CurrPage.SETSELECTIONFILTER(TimeSheetLine);
        end;
        TimeSheetLine2.copy(TimeSheetLine);
        if TimeSheetLine2.findset()then repeat TimeSheetDetail2.INIT();
                TimeSheetDetail2.CopyFromTimeSheetLine(TimeSheetLine2);
                TimeSheetDetail2.Date:=TimeSheetHeader."Starting Date";
                TimeSheetDetail2.Quantity:=TimeSheetLine2."Estimated Work Hour";
                //TimeSheetDetail2."Posted Quantity" := Quantity;
                //TimeSheetDetail2.Posted := TRUE;
                if not TimeSheetDetail2.INSERT()then TimeSheetLine2.Modify();
            until TimeSheetLine2.next() = 0;
        TimeSheetMgt.CopyFilteredTimeSheetLinesToBuffer(TimeSheetLine, TempTimeSheetLine);
        if TimeSheetLine.FINDSET()then repeat case Action of Action::"Submit Selected", Action::"Submit All": TimeSheetApprovalMgt.Submit(TimeSheetLine);
                Action::"Reopen Selected", Action::"Reopen All": TimeSheetApprovalMgt.ReopenSubmitted(TimeSheetLine);
                end;
            until TimeSheetLine.NEXT() = 0;
        CurrPage.UPDATE(true);
    end;
    local procedure FilterAllLines(var TimeSheetLine: Record "Time Sheet Line"; ActionType: Option Submit, Reopen);
    begin
        TimeSheetLine.SETRANGE("Time Sheet No.", CurrTimeSheetNo);
        TimeSheetLine.COPYFILTERS(Rec);
        TimeSheetLine.FILTERGROUP(2);
        TimeSheetLine.SETFILTER(Type, '<>%1', TimeSheetLine.Type::" ");
        TimeSheetLine.FILTERGROUP(0);
        case ActionType of ActionType::Submit: TimeSheetLine.SETFILTER(Status, '%1|%2', TimeSheetLine.Status::Open, TimeSheetLine.Status::Rejected);
        ActionType::Reopen: TimeSheetLine.SETRANGE(Status, TimeSheetLine.Status::Submitted);
        end;
    end;
    trigger OnAfterGetRecord();
    begin
        AfterGetCurrentRecord();
        TimeSheetHeader.CalcFields("Resource Name");
        if Rec."Time Sheet Type" = Rec."Time Sheet Type"::Hour then ShowDates:=true
        else
            ShowDates:=false;
    end;
    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Rec.Type:=Rec.type::Job;
        AfterGetCurrentRecord();
        CheckStatusOpen();
    end;
    trigger OnOpenPage();
    begin
        ShowDates:=true;
        if Rec."Time Sheet No." <> '' then CurrTimeSheetNo:=Rec."Time Sheet No."
        else
            CurrTimeSheetNo:=TimeSheetHeader.FindLastTimeSheetNo(TimeSheetHeader.FIELDNO("Owner User ID"));
        TimeSheetHeader.GET(CurrTimeSheetNo);
        if TimeSheetHeader."Time Sheet Type" = TimeSheetHeader."Time Sheet Type"::Hour then ShowDates:=true
        else
            ShowDates:=false;
        //Message('%1', ShowDates);
        TimeSheetMgt.SetTimeSheetNo(CurrTimeSheetNo, Rec);
        UpdateControls();
    end;
    local procedure FindTimeSheet(Which: Option);
    begin
        CurrTimeSheetNo:=TimeSheetMgt.FindTimeSheet(TimeSheetHeader, Which);
        TimeSheetMgt.SetTimeSheetNo(CurrTimeSheetNo, Rec);
        UpdateControls();
    end;
    local procedure Submit();
    var
        "Action": Option "Submit Selected", "Submit All", "Reopen Selected", "Reopen All";
        ActionType: Option Submit, Reopen;
    begin
        if not Confirm('Do you want to submit?', false)then begin
            CalculateTimeSheetPercent(true);
            exit;
        end;
        case ShowDialog(ActionType::Submit)of 1: Process(Action::"Submit All");
        2: Process(Action::"Submit Selected");
        end;
    end;
    local procedure Reopen();
    var
        ActionType: Option Submit, Reopen;
        "Action": Option "Submit Selected", "Submit All", "Reopen Selected", "Reopen All";
    begin
        case ShowDialog(ActionType::Reopen)of 1: Process(Action::"Reopen All");
        2: Process(Action::"Reopen Selected");
        end;
    end;
    local procedure TimeAllocation();
    var
        TimeSheetAllocation: Page "Time Sheet Allocation";
        AllocatedQty: array[31]of Decimal;
    begin
        Rec.TESTFIELD(Posted, true);
        Rec.CALCFIELDS("Total Quantity");
        TimeSheetAllocation.InitParameters(Rec."Time Sheet No.", Rec."Line No.", Rec."Total Quantity");
        if TimeSheetAllocation.RUNMODAL() = ACTION::OK then begin
            TimeSheetAllocation.GetAllocation(AllocatedQty);
            TimeSheetMgt.UpdateTimeAllocation(Rec, AllocatedQty);
        end;
    end;
    local procedure GetDialogText(ActionType: Option Submit, Reopen): Text[100];
    var
        TimeSheetLine: Record "Time Sheet Line";
    begin
        FilterAllLines(TimeSheetLine, ActionType);
        if ActionType = ActionType::Submit then exit(StrSubstNo(Text011, TimeSheetLine.COUNT))
        else if ActionType = ActionType::Reopen then exit(TimeSheetApprovalMgt.GetTimeSheetActionDialogText(ActionType, TimeSheetLine.COUNT))end;
    local procedure ShowDialog(ActionType: Option Submit, Reopen): Integer;
    begin
        exit(STRMENU(GetDialogText(ActionType), 1, TimeSheetApprovalMgt.GetTimeSheetActionDialogInstruction(ActionType)));
    end;
    local procedure CheckStatusOpen();
    var
        TimeSheetLine: Record "Time Sheet Line";
    begin
        TimeSheetLine.RESET();
        TimeSheetLine.SetRange("Time Sheet No.", Rec."Time Sheet No.");
        TimeSheetLine.SetFilter(Status, '%1|%2', TimeSheetLine.Status::Submitted, TimeSheetLine.Status::Approved);
        if not TimeSheetLine.IsEmpty()then //TimeSheetLine.FindFirst() then
 Error('Status must be open');
    end;
}
