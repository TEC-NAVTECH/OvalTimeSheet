tableextension 50126 "Time Sheet Line Ext." extends "Time Sheet Line"
{
    fields
    {
        field(50000; "Percent Per Month"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Percent Per Month" <> 0 then "Estimated Work Hour":=200 * "Percent Per Month" / 100;
                "Total Hours Percent":="Work Percent" + "Percent Per Month";
            end;
        }
        field(50001; "Work Percent"; Decimal)
        {
            DataClassification = ToBeClassified;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                "Total Hours Percent":="Work Percent" + "Percent Per Month";
            end;
        }
        field(50002; "Estimated Work Hour"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Timesheet Nature"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Actual", "Projected";
            Editable = false;
        }
        field(50004; "Total Hours Percent"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Time Sheet Type"; Option)
        {
            OptionMembers = "Hour", "Percent";
            DataClassification = ToBeClassified;
        }
    }
    var myInt: Integer;
}
