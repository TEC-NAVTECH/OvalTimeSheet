pageextension 50131 "Manager Time Sheet List Ext" extends "Manager Time Sheet List"
{
    layout
    {
        addafter("Resource No.")
        {
            //field("Resource Name"; "Resource Name")
            // {
            //     ApplicationArea = all;
            // }
            field("Time Sheet Type"; Rec."Time Sheet Type")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addbefore("MoveTimeSheetsToArchive") //
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
                    PAGE.RUN(PAGE::"Manager Time Sheet Monthly", TimeSheetLine);
                end;
            }
        }
    }
}
