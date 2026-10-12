page 50132 "Manager TS by Job Monthly"
{
    // version NAVW113.00
    ApplicationArea = Jobs;
    AutoSplitKey = true;
    Caption = 'Manager Time Sheet by Job Monthly';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Navigate,Show';
    SourceTable = "Time Sheet Line";
    SourceTableView = where(Type=const(Job));
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field(StartingDate; StartingDate)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Starting Date';
                    Editable = false;
                    ToolTip = 'Specifies the date from which the report or batch job processes information.';
                }
                field(EndingDate; EndingDate)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Ending Date';
                    Editable = false;
                    ToolTip = 'Specifies the date to which the report or batch job processes information.';
                }
            }
            repeater(Lines)
            {
                field("Time Sheet No."; Rec."Time Sheet No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the number for the job that is associated with the time sheet line.';
                }
                //field("Job Task No."; "Job Task No.")
                //{
                //   ApplicationArea = Jobs;
                //  Editable = false;
                // ToolTip = 'Specifies the number of the related job task.';
                //}
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
                field("Work Percent"; Rec."Work Percent")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Percent Per Month"; Rec."Percent Per Month")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Total Hours Percent"; Rec."Total Hours Percent")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ApplicationArea = Jobs;
                    Editable = WorkTypeCodeAllowEdit;
                    ToolTip = 'Specifies which work type the resource applies to. Prices are updated based on this entry.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Submitted);
                    end;
                }
                field(Chargeable; Rec.Chargeable)
                {
                    ApplicationArea = Jobs;
                    Editable = ChargeableAllowEdit;
                    ToolTip = 'Specifies if the usage that you are posting is chargeable.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Submitted);
                    end;
                }
                // field("Percent Per Month"; "Percent Per Month")
                // {
                //     ApplicationArea = assembly;
                //     ToolTip = 'enter percent if time sheet type is percent';
                //     Visible = ShowDates;
                // }
                field("Estimated Work Hour"; Rec."Estimated Work Hour")
                {
                    ApplicationArea = Assembly;
                    Visible = not ShowDates;
                }
                //field("Time Sheet No."; "Time Sheet No.")
                //{
                //   ApplicationArea = all;
                //}
                field("Resource Name"; TimeSheetHeader."Resource Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies information about the status of a time sheet line.';
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
                field("Total Quantity"; Rec."Total Quantity")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total number of hours that have been entered on a time sheet.';
                    Visible = false;
                }
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

                action("&Previous Period")
                {
                    ApplicationArea = Jobs;
                    Caption = '&Previous Period';
                    Image = PreviousSet;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortcutKey = 'Ctrl+PgUp';
                    ToolTip = 'Show the information based on the previous period. If you set the View by field to Day, the date filter changes to the day before.';
                    PromotedOnly = true; //

                    trigger OnAction()
                    begin
                        FindPeriod(SetWanted::Previous);
                    end;
                }
                action("&Next Period")
                {
                    ApplicationArea = Jobs;
                    Caption = '&Next Period';
                    Image = NextSet;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortcutKey = 'Ctrl+PgDn';
                    ToolTip = 'View information for the next period.';
                    PromotedOnly = true; //

                    trigger OnAction()
                    begin
                        FindPeriod(SetWanted::Next);
                    end;
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;

                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = page "Time Sheet Comment Sheet";
                    RunPageLink = "No."=field("Time Sheet No."), "Time Sheet Line No."=field("Line No.");
                    ToolTip = 'View or add comments for the record.';
                    PromotedOnly = true; //
                }
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
                    ShortcutKey = 'Shift+F7';
                    ToolTip = 'View the quantity of hours for each time sheet status.';
                    Visible = false;
                    PromotedOnly = true; //

                    trigger OnAction()
                    begin
                        Rec.ShowLineDetails(true);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";

                action(Approve)
                {
                    ApplicationArea = Jobs;
                    Caption = '&Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortcutKey = 'Ctrl+F9';
                    ToolTip = 'Approve the lines on the time sheet. Choose All to approve all lines. Choose Selected to approve only selected lines.';

                    trigger OnAction()
                    begin
                        Approve1();
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
                    Visible = false;
                    ToolTip = 'Reject to approve the lines on the time sheet. Choose All to reject all lines. Choose Selected to reject only selected lines.';
                    PromotedOnly = true; //

                    trigger OnAction()
                    begin
                        Reject();
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Reopen the time sheet to change it.';
                    PromotedOnly = true; //

                    trigger OnAction()
                    begin
                        Reopen1();
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        AfterGetCurrentRecord();
        if TimeSheetHeader.get(Rec."Time Sheet No.")then;
        if TimeSheetHeader."Time Sheet Type" = TimeSheetHeader."Time Sheet Type"::Hour then ShowDates:=true
        else
            ShowDates:=false;
        TimeSheetHeader.CalcFields("Resource Name");
    end;
    trigger OnOpenPage()
    begin
        FindPeriod(SetWanted::Initial);
    end;
    var ResourcesSetup: Record "Resources Setup";
    TimeSheetDetail: Record "Time Sheet Detail";
    ColumnRecords: array[32]of Record "Date";
    TimeSheetMgt: Codeunit "Time Sheet Management";
    TimeSheetApprovalMgt: Codeunit "Time Sheet Approval Management";
    NoOfColumns: Integer;
    CellData: array[32]of Decimal;
    ColumnCaption: array[32]of Text[1024];
    SetWanted: Option Initial, Previous, Next;
    StartingDate: Date;
    EndingDate: Date;
    WorkTypeCodeAllowEdit: Boolean;
    ChargeableAllowEdit: Boolean;
    ShowDates: Boolean;
    TimeSheetHeader: Record "Time Sheet Header";
    procedure SetColumns()
    var
        Calendar: Record "Date";
    begin
        CLEAR(ColumnCaption);
        CLEAR(ColumnRecords);
        CLEAR(Calendar);
        CLEAR(NoOfColumns);
        Calendar.SETRANGE("Period Type", Calendar."Period Type"::Date);
        Calendar.SETRANGE("Period Start", StartingDate, EndingDate);
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
        WorkTypeCodeAllowEdit:=Rec.GetAllowEdit(Rec.FIELDNO("Work Type Code"), true);
        ChargeableAllowEdit:=Rec.GetAllowEdit(Rec.FIELDNO(Chargeable), true);
        TimeSheetHeader.CalcFields("Resource Name");
    end;
    local procedure FindPeriod(Which: Option Initial, Previous, Next)
    begin
        ResourcesSetup.GET();
        case Which of Which::Initial: //    IF DATE2DWY(WORKDATE, 1) = ResourcesSetup."Time Sheet First Weekday" + 1 THEN
 //        StartingDate := WORKDATE
            //    ELSE
            //        StartingDate := CALCDATE(STRSUBSTNO('<WD%1-7D>', ResourcesSetup."Time Sheet First Weekday" + 1), WORKDATE);
            StartingDate:=CALCDATE('<-CM>', Today());
        Which::Previous: StartingDate:=CALCDATE('<-1M>', StartingDate);
        Which::Next: StartingDate:=CALCDATE('<1M>', StartingDate);
        end;
        EndingDate:=CALCDATE('<1M>', StartingDate) - 1;
        Rec.FILTERGROUP(2);
        Rec.SETRANGE("Time Sheet Starting Date", StartingDate, EndingDate);
        Rec.SETRANGE("Approver ID", USERID);
        Rec.FILTERGROUP(0);
        SetColumns();
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
                Action::"Reject Selected": RejectTimeSheetSelected(TimeSheetLine);
                Action::"Reject All": RejectTimeSheet(TimeSheetLine);
                end;
            until TimeSheetLine.NEXT() = 0;
        OnAfterProcess(TempTimeSheetLine, Action);
        CurrPage.UPDATE(false);
    end;
    local procedure Approve1()
    var
        "Action": Option "Approve Selected", "Approve All", "Reopen Selected", "Reopen All", "Reject Selected", "Reject All";
        ActionType: Option Approve, Reopen, Reject;
    begin
        case ShowDialog(ActionType::Approve)of 1: Process(Action::"Approve All");
        2: Process(Action::"Approve Selected");
        end;
    end;
    local procedure Reopen1()
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
        TimeSheetLine.COPYFILTERS(Rec);
        TimeSheetLine.FILTERGROUP(2);
        TimeSheetLine.SETRANGE("Time Sheet Starting Date", StartingDate, EndingDate);
        TimeSheetLine.SETRANGE("Approver ID", UserId);
        TimeSheetLine.SETRANGE(Type, TimeSheetLine.Type::Job);
        TimeSheetLine.FILTERGROUP(0);
        case ActionType of ActionType::Approve, ActionType::Reject: TimeSheetLine.SETRANGE(Status, TimeSheetLine.Status::Submitted);
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
    local procedure RejectTimeSheet(var TimeSheetLine: Record "Time Sheet Line")
    begin
        //WITH TimeSheetLine DO BEGIN
        if TimeSheetLine.Status = TimeSheetLine.Status::Rejected then exit;
        //TESTFIELD(Status, Status::Submitted);
        CheckApproverPermissions(TimeSheetLine);
        TimeSheetLine.Status:=TimeSheetLine.Status::Rejected;
        TimeSheetLine.MODIFY(true);
    //OnAfterReject(TimeSheetLine);
    //END;
    end;
    local procedure RejectTimeSheetSelected(var TimeSheetLine: Record "Time Sheet Line")
    var
        TimeSheetLine2: Record "Time Sheet Line";
    begin
        //        WITH TimeSheetLine DO BEGIN
        if TimeSheetLine.Status = TimeSheetLine.Status::Rejected then exit;
        //TESTFIELD(Status, Status::Submitted);
        CheckApproverPermissions(TimeSheetLine);
        TimeSheetLine.Status:=TimeSheetLine.Status::Rejected;
        TimeSheetLine.MODIFY(true);
        TimeSheetLine2.Reset();
        TimeSheetLine2.SetRange("Time Sheet No.", TimeSheetLine."Time Sheet No.");
        timesheetline2.SetFilter(Status, '%1|%2', TimeSheetLine.Status::Submitted, TimeSheetLine.Status::Approved);
        if TimeSheetLine2.FindSet()then repeat CheckApproverPermissions(TimeSheetLine2);
                TimeSheetLine2.Status:=TimeSheetLine2.Status::Rejected;
                TimeSheetLine2.MODIFY(true);
            until timesheetline2.Next() = 0;
    //OnAfterReject(TimeSheetLine);
    //        END;
    end;
    local procedure CheckApproverPermissions(TimeSheetLine: Record "Time Sheet Line")
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.GET(USERID);
        if not UserSetup."Time Sheet Admin." then if TimeSheetLine."Approver ID" <> UPPERCASE(USERID)then ERROR('You are not authorized to approve time sheet lines. Contact your time sheet administrator.');
    end;
}
