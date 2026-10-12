pageextension 50128 "Time Sheet List Extension" extends "Time Sheet List"
{
    layout
    {
        // modify("No.")
        // {
        //     Visible = false;
        // }
        addbefore("No.")
        {
            field(TimeSheetNo; TimeSheetNo)
            {
                Caption = '.';
                ApplicationArea = all;
                Editable = false;
                Width = 1;

                trigger OnDrillDown() //Fixed Upgrade issue on BC200
                var
                    TimeSheetMgt: Codeunit "Time Sheet Management";
                    TimeSheetLine: Record "Time Sheet Line";
                begin
                    TimeSheetMgt.SetTimeSheetNo(Rec."No.", TimeSheetLine);
                    PAGE.RUN(PAGE::"Time Sheet Monthly", TimeSheetLine);
                end;
            }
        }
        addafter("No.")
        {
            field("Resource No"; Rec."Resource No.")
            {
                ApplicationArea = all;
            }
            field("Staff Name"; Rec."Staff Name") //#001
            {
                ApplicationArea = All;
            }
        // field("Resource Name"; "Resource Name")
        // {
        //     ApplicationArea = all;
        // }
        }
        addafter("Ending Date")
        {
            field("Time Sheet Type"; Rec."Time Sheet Type")
            {
                ApplicationArea = all;
            }
            field("Time Sheet Nature"; Rec."Time Sheet Nature")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        // modify(EditTimeSheet)
        // {
        //     Visible = false;
        // }
        addfirst(Navigation)
        {
            action(EditTimeSheet1)
            {
                Caption = '&Edit Time Sheet';
                ApplicationArea = Jobs;
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortcutKey = Return;

                trigger OnAction()
                var
                    TimeSheetMgt: Codeunit "Time Sheet Management";
                    TimeSheetLine: Record "Time Sheet Line";
                begin
                    TimeSheetMgt.SetTimeSheetNo(Rec."No.", TimeSheetLine);
                    PAGE.RUN(PAGE::"Time Sheet Monthly", TimeSheetLine);
                end;
            }
        }
        addbefore(MoveTimeSheetsToArchive) //
        {
            action("Time Sheet Monthly")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = Timesheet;
                PromotedCategory = Process;
                Caption = 'Time Sheet Monthly';

                trigger OnAction()
                var
                    TimeSheetMgt: Codeunit "Time Sheet Management";
                    TimeSheetLine: Record "Time Sheet Line";
                begin
                    TimeSheetMgt.SetTimeSheetNo(Rec."No.", TimeSheetLine);
                    PAGE.RUN(PAGE::"Time Sheet Monthly", TimeSheetLine);
                end;
            }
            action("Update Empty Staff Name")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    l_Rec_TimeSheet: Record "Time Sheet Header";
                    l_Rec_Resource: Record Resource;
                begin
                    l_Rec_TimeSheet.RESET;
                    l_Rec_TimeSheet.SETRANGE("Staff Name", '');
                    IF l_Rec_TimeSheet.FINDSET THEN repeat l_Rec_Resource.SetRange("No.", l_Rec_TimeSheet."Resource No.");
                            if l_Rec_Resource.FindFirst()then begin
                                l_Rec_TimeSheet."Staff Name":=l_Rec_Resource.Name;
                                l_Rec_TimeSheet.MODIFY;
                            end;
                        UNTIL l_Rec_TimeSheet.NEXT = 0;
                end;
            }
            action(" Delete Time Sheet Monthly")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = Delete;
                PromotedCategory = Process;
                Caption = 'Delete Time Sheet Monthly';

                trigger OnAction()
                var
                    TSHeader: Record "Time Sheet Header";
                    TimeSheetLine: Record "Time Sheet Line";
                    TimeSheetCommentLine: Record "Time Sheet Comment Line";
                    MyTimeSheets: Record "My Time Sheets";
                    TimeSheetDetail: Record "Time Sheet Detail";
                begin
                    if Confirm('Do you want to delete selected Timesheet', false)then begin
                        TSHeader.GET(Rec."No.");
                        TimeSheetLine.SETRANGE("Time Sheet No.", Rec."No.");
                        if TimeSheetLine.FindSet()then repeat TimeSheetDetail.SETRANGE("Time Sheet No.", TimeSheetLine."Time Sheet No.");
                                TimeSheetDetail.SETRANGE("Time Sheet Line No.", TimeSheetLine."Line No.");
                                TimeSheetDetail.DELETEALL();
                                TimeSheetCommentLine.SETRANGE("No.", TimeSheetLine."Time Sheet No.");
                                TimeSheetCommentLine.SETRANGE("Time Sheet Line No.", TimeSheetLine."Line No.");
                                TimeSheetCommentLine.DELETEALL();
                            until TimeSheetLine.Next() = 0;
                        TimeSheetLine.DeleteAll();
                        TimeSheetCommentLine.SETRANGE("No.", Rec."No.");
                        TimeSheetCommentLine.SETRANGE("Time Sheet Line No.", 0);
                        TimeSheetCommentLine.DELETEALL();
                        MyTimeSheets.SETRANGE("Time Sheet No.", Rec."No.");
                        if MyTimeSheets.FINDFIRST()then MyTimeSheets.DELETEALL();
                        //TSHeader.Delete(true);
                        TSHeader.delete();
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
    //TimeSheetNo := "No.";
    end;
    var TimeSheetNo: Boolean;
}
