page 50130 "Manager Time Sheet Monthly"
{
    // version NAVW113.00
    AutoSplitKey = true;
    Caption = 'Manager Time Sheet';
    DataCaptionFields = "Time Sheet No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Navigate,Show';
    SaveValues = true;
    SourceTable = "Time Sheet Line";
    UsageCategory = Administration;
    ApplicationArea = all;

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

                    trigger OnLookup(var Text: Text): Boolean begin
                        CurrPage.SAVERECORD();
                        TimeSheetMgt.LookupApproverTimeSheet(CurrTimeSheetNo, Rec, TimeSheetHeader);
                        UpdateControls();
                    end;
                    trigger OnValidate()
                    begin
                        TimeSheetHeader.RESET();
                        TimeSheetMgt.FilterTimeSheets(TimeSheetHeader, TimeSheetHeader.FIELDNO("Approver User ID"));
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
                    ToolTip = 'Specifies the number for resource.';
                }
                field(ApproverUserID; TimeSheetHeader."Approver User ID")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Approver User ID';
                    Editable = false;
                    ToolTip = 'Specifies the ID of the time sheet approver.';
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
            }
            repeater(Lines)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the type of time sheet line.';
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the number for the job that is associated with the time sheet line.';
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the number of the related job task.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies a description of the time sheet line.';

                    trigger OnAssistEdit()
                    begin
                        Rec.ShowLineDetails(true);
                        CurrPage.UPDATE();
                    end;
                }
                field("Cause of Absence Code"; Rec."Cause of Absence Code")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies a list of standard absence codes, from which you may select one.';
                    Visible = false;
                }
                field(Chargeable; Rec.Chargeable)
                {
                    ApplicationArea = Jobs;
                    Editable = ChargeableAllowEdit;
                    ToolTip = 'Specifies if the usage that you are posting is chargeable.';
                    Visible = false;
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ApplicationArea = Jobs;
                    Editable = WorkTypeCodeAllowEdit;
                    ToolTip = 'Specifies which work type the resource applies to. Prices are updated based on this entry.';
                    Visible = false;
                }
                field("Service Order No."; Rec."Service Order No.")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the service order number that is associated with the time sheet line.';
                    Visible = false;
                }
                field("Assembly Order No."; Rec."Assembly Order No.")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the assembly order number that is associated with the time sheet line.';
                    Visible = false;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether a time sheet line has been posted completely.';
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
                }
                field("Work Percent"; Rec."Work Percent")
                {
                    ApplicationArea = all;
                    Visible = not ShowDates;
                }
                field(Field1; CellData[1])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[1];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field2; CellData[2])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[2];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field3; CellData[3])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[3];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field4; CellData[4])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[4];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field5; CellData[5])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[5];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field6; CellData[6])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[6];
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field7; CellData[7])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[7];
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field8; CellData[8])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[8];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field9; CellData[9])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[9];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field10; CellData[10])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[10];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field11; CellData[11])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[11];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field12; CellData[12])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[12];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field13; CellData[13])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[13];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field14; CellData[14])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[14];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field15; CellData[15])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[15];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field16; CellData[16])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[16];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field17; CellData[17])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[17];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field18; CellData[18])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[18];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field19; CellData[19])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[19];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field20; CellData[20])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[20];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field21; CellData[21])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[21];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field22; CellData[22])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[22];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field23; CellData[23])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[23];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field24; CellData[24])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[24];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field25; CellData[25])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[25];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field26; CellData[26])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[26];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field27; CellData[27])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[27];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field28; CellData[28])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[28];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field29; CellData[29])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[29];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field30; CellData[30])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[30];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Field31; CellData[31])
                {
                    ApplicationArea = Jobs;
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaption[31];
                    DecimalPlaces = 0: 2;
                    Editable = false;
                    Visible = ShowDates;
                    Width = 6;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies information about the status of a time sheet line.';
                }
                field("Total Quantity"; Rec."Total Quantity")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Total';
                    DrillDown = false;
                    ToolTip = 'Specifies the total number of hours that have been entered on a time sheet.';
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
                Caption = 'Actual/Scheduled Summary';
                Visible = false;
            }
            part(ActivityDetailsFactBox;971)
            {
                ApplicationArea = Jobs;
                Caption = 'Activity Details';
                SubPageLink = "Time Sheet No."=field("Time Sheet No."), "Line No."=field("Line No.");
                Visible = false;
            }
        }
    }
    actions
    {
        area(navigation)
        {
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

                    trigger OnAction()
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

                    trigger OnAction()
                    begin
                        FindTimeSheet(SetWanted::Next);
                    end;
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;

                action("Posting E&ntries")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Posting E&ntries';
                    Image = PostingEntries;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ShortcutKey = 'Ctrl+F7';
                    ToolTip = 'View the resource ledger entries that have been posted in connection with the.';
                    PromotedOnly = true; //

                    trigger OnAction()
                    begin
                        TimeSheetMgt.ShowPostingEntries(Rec."Time Sheet No.", Rec."Line No.");
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
                    PromotedOnly = true; //

                    trigger OnAction()
                    begin
                        Rec.ShowLineDetails(true);
                    end;
                }
            }
            group("Co&mments")
            {
                Caption = 'Co&mments';
                Image = ViewComments;

                action(TimeSheetComment2)
                {
                    ApplicationArea = Comments;
                    Caption = '&Time Sheet Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = page "Time Sheet Comment Sheet";
                    RunPageLink = "No."=field("Time Sheet No."), "Time Sheet Line No."=const(0);
                    ToolTip = 'View comments about the time sheet.';
                }
                action(LineComments)
                {
                    ApplicationArea = Comments;
                    Caption = '&Line Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true; //
                    RunObject = page "Time Sheet Comment Sheet";
                    RunPageLink = "No."=field("Time Sheet No."), "Time Sheet Line No."=field("Line No.");
                    ToolTip = 'View or create comments.';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";

                action(Approve1)
                {
                    ApplicationArea = Jobs;
                    Caption = '&Approve';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortcutKey = 'Ctrl+F9';
                    ToolTip = 'Approve the lines on the time sheet. Choose All to approve all lines. Choose Selected to approve only selected lines.';

                    trigger OnAction()
                    begin
                        Approve();
                    end;
                }
                action(Reject1)
                {
                    ApplicationArea = Jobs;
                    Caption = '&Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Reject to approve the lines on the time sheet. Choose All to reject all lines. Choose Selected to reject only selected lines.';
                    PromotedOnly = true; //

                    trigger OnAction()
                    begin
                        Reject();
                    end;
                }
                action(Reopen1)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Reopen the time sheet to change it.';

                    trigger OnAction()
                    begin
                        Reopen();
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        AfterGetCurrentRecord();
        if TimeSheetHeader."Time Sheet Type" = TimeSheetHeader."Time Sheet Type"::Hour then ShowDates:=true
        else
            ShowDates:=false;
    end;
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        AfterGetCurrentRecord();
    end;
    trigger OnOpenPage()
    begin
        ShowDates:=true;
        if Rec."Time Sheet No." <> '' then CurrTimeSheetNo:=Rec."Time Sheet No."
        else
            CurrTimeSheetNo:=TimeSheetHeader.FindLastTimeSheetNo(TimeSheetHeader.FIELDNO("Approver User ID"));
        if TimeSheetHeader."Time Sheet Type" = TimeSheetHeader."Time Sheet Type"::Hour then ShowDates:=true
        else
            ShowDates:=false;
        TimeSheetMgt.SetTimeSheetNo(CurrTimeSheetNo, Rec);
        UpdateControls();
    end;
    var TimeSheetHeader: Record "Time Sheet Header";
    TimeSheetDetail: Record "Time Sheet Detail";
    ColumnRecords: array[32]of Record Date;
    TimeSheetMgt: Codeunit "Time Sheet Management";
    NoOfColumns: Integer;
    CellData: array[32]of Decimal;
    ColumnCaption: array[32]of Text[1024];
    CurrTimeSheetNo: Code[20];
    SetWanted: Option Previous, Next;
    WorkTypeCodeAllowEdit: Boolean;
    ChargeableAllowEdit: Boolean;
    TimeSheetApprovalMgt: Codeunit "Time Sheet Approval Management";
    ShowDates: Boolean;
    procedure SetColumns()
    var
        Calendar: Record "Date";
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
                ColumnCaption[NoOfColumns]:=TimeSheetMgt.FormatDate(Calendar."Period Start", 1);
            until Calendar.NEXT() = 0;
    end;
    local procedure AfterGetCurrentRecord()
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
        WorkTypeCodeAllowEdit:=Rec.GetAllowEdit(Rec.FIELDNO("Work Type Code"), true);
        ChargeableAllowEdit:=Rec.GetAllowEdit(Rec.FIELDNO(Chargeable), true);
    end;
    local procedure FindTimeSheet(Which: Option)
    begin
        CurrTimeSheetNo:=TimeSheetMgt.FindTimeSheet(TimeSheetHeader, Which);
        TimeSheetMgt.SetTimeSheetNo(CurrTimeSheetNo, Rec);
        UpdateControls();
    end;
    local procedure UpdateFactBoxes()
    begin
        CurrPage.ActualSchedSummaryFactBox.PAGE.UpdateDataMonthly(TimeSheetHeader);
        CurrPage.TimeSheetStatusFactBox.PAGE.UpdateData(TimeSheetHeader);
        if Rec."Line No." = 0 then CurrPage.ActivityDetailsFactBox.PAGE.SetEmptyLine();
    end;
    local procedure UpdateControls()
    begin
        SetColumns();
        UpdateFactBoxes();
        CurrPage.UPDATE(false);
    end;
    local procedure Process("Action": Option "Approve Selected", "Approve All", "Reopen Selected", "Reopen All", "Reject Selected", "Reject All")
    var
        TimeSheetLine: Record "Time Sheet Line";
        TempTimeSheetLine: Record "Time Sheet Line" temporary;
        ActionType: Option Approve, Reopen, Reject;
    begin
        CurrPage.SAVERECORD();
        case Action of Action::"Approve All", Action::"Reject All": FilterAllLines(TimeSheetLine, ActionType::Approve);
        Action::"Reopen All": FilterAllLines(TimeSheetLine, ActionType::Reopen);
        else
            CurrPage.SETSELECTIONFILTER(TimeSheetLine);
        end;
        OnProcessOnAfterTimeSheetLinesFiltered(TimeSheetLine, Action);
        TimeSheetMgt.CopyFilteredTimeSheetLinesToBuffer(TimeSheetLine, TempTimeSheetLine);
        if TimeSheetLine.FINDSET()then repeat case Action of Action::"Approve Selected", Action::"Approve All": TimeSheetApprovalMgt.Approve(TimeSheetLine);
                Action::"Reopen Selected", Action::"Reopen All": TimeSheetApprovalMgt.ReopenApproved(TimeSheetLine);
                Action::"Reject Selected", Action::"Reject All": TimeSheetApprovalMgt.Reject(TimeSheetLine);
                end;
            until TimeSheetLine.NEXT() = 0;
        OnAfterProcess(TempTimeSheetLine, Action);
        CurrPage.UPDATE(false);
    end;
    local procedure Approve()
    var
        "Action": Option "Approve Selected", "Approve All", "Reopen Selected", "Reopen All", "Reject Selected", "Reject All";
        ActionType: Option Approve, Reopen, Reject;
    begin
        case ShowDialog(ActionType::Approve)of 1: Process(Action::"Approve All");
        2: Process(Action::"Approve Selected");
        end;
    end;
    local procedure Reopen()
    var
        ActionType: Option Approve, Reopen, Reject;
        "Action": Option "Approve Selected", "Approve All", "Reopen Selected", "Reopen All", "Reject Selected", "Reject All";
    begin
        case ShowDialog(ActionType::Reopen)of 1: Process(Action::"Reopen All");
        2: Process(Action::"Reopen Selected");
        end;
    end;
    local procedure Reject()
    var
        ActionType: Option Approve, Reopen, Reject;
        "Action": Option "Approve Selected", "Approve All", "Reopen Selected", "Reopen All", "Reject Selected", "Reject All";
    begin
        case ShowDialog(ActionType::Reject)of 1: Process(Action::"Reject All");
        2: Process(Action::"Reject Selected");
        end;
    end;
    local procedure GetDialogText(ActionType: Option Approve, Reopen, Reject): Text[100]var
        TimeSheetLine: Record "Time Sheet Line";
    begin
        FilterAllLines(TimeSheetLine, ActionType);
        exit(TimeSheetApprovalMgt.GetManagerTimeSheetActionDialogText(ActionType, TimeSheetLine.COUNT));
    end;
    local procedure FilterAllLines(var TimeSheetLine: Record "Time Sheet Line"; ActionType: Option Approve, Reopen, Reject)
    begin
        TimeSheetLine.SETRANGE("Time Sheet No.", CurrTimeSheetNo);
        TimeSheetLine.COPYFILTERS(Rec);
        TimeSheetLine.FILTERGROUP(2);
        TimeSheetLine.SETFILTER(Type, '<>%1', TimeSheetLine.Type::" ");
        TimeSheetLine.FILTERGROUP(0);
        case ActionType of ActionType::Approve, ActionType::Reject: TimeSheetLine.SetFilter(Status, '%1|%2', TimeSheetLine.Status::Submitted, TimeSheetLine.Status::Approved);
        ActionType::Reopen: TimeSheetLine.SETRANGE(Status, TimeSheetLine.Status::Approved);
        end;
        OnAfterFilterAllLines(TimeSheetLine, ActionType);
    end;
    local procedure ShowDialog(ActionType: Option Approve, Reopen, Reject): Integer begin
        exit(STRMENU(GetDialogText(ActionType), 1, TimeSheetApprovalMgt.GetManagerTimeSheetActionDialogInstruction(ActionType)));
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterFilterAllLines(var TimeSheetLine: Record "Time Sheet Line"; ActionType: Option Approve, Reopen, Reject)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnProcessOnAfterTimeSheetLinesFiltered(var TimeSheetLine: Record "Time Sheet Line"; "Action": Option "Approve Selected", "Approve All", "Reopen Selected", "Reopen All", "Reject Selected", "Reject All")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterProcess(var TimeSheetLine: Record "Time Sheet Line"; "Action": Option "Approve Selected", "Approve All", "Reopen Selected", "Reopen All", "Reject Selected", "Reject All")
    begin
    end;
}
