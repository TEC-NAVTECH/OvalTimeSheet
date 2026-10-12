tableextension 50127 "Time Sheet Header Ext" extends "Time Sheet Header"
{
    fields
    {
        field(50000; "Time Sheet Monthly"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Time Sheet Type"; Option)
        {
            OptionMembers = "Hour", "Percent";
            DataClassification = ToBeClassified;
        }
        field(50002; "Time Sheet Nature"; Option)
        {
            OptionMembers = "Actual", "Projected";
            DataClassification = ToBeClassified;
        }
        //field(50003; "Resource Name"; Text[100])
        // {
        // FieldClass = FlowField;
        // CalcFormula = lookup(Resource.Name where("No." = field("Resource No.")));
        //  }
        field(50004; "Time Sheet No."; Code[20])
        {
        }
        field(50005; "Created Exist"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Time Sheet Line" where("Time Sheet No."=field("No.")));
        }
        field(50006; "Staff Name"; Text[100])
        {
            DataClassification = ToBeClassified; //#001
        }
        modify("Resource No.") //#001
        {
        trigger OnAfterValidate();
        var
            l_recResourceNo: Record Resource;
        begin
            l_recResourceNo.SetRange("No.", Rec."Resource No.");
            if l_recResourceNo.FindFirst()then Rec."Staff Name":=l_recResourceNo.Name;
        end;
        }
    }
}
