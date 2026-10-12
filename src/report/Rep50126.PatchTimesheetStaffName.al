report 50126 "Patch Timesheet Staff Name"
{
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;
    Caption = 'Timesheet Staff Name Patch';

    dataset
    {
        dataitem("Time Sheet Header"; "Time Sheet Header")
        {
            trigger OnAfterGetRecord();
            var
                l_recResource: Record Resource;
            begin
                l_recResource.Reset();
                l_recResource.SetRange("No.", "Time Sheet Header"."Resource No.");
                if l_recResource.FindFirst()then begin
                    "Time Sheet Header"."Staff Name":=l_recResource.Name;
                    "Time Sheet Header".Modify();
                end;
            end;
        }
    }
    trigger OnPostReport();
    begin
        Message('Patch completed.');
    end;
}
