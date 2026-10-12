tableextension 50121 "Resources Extension" extends Resource
{
    fields
    {
        field(50003; "Staff Cluster"; Code[20])
        {
            TableRelation = "Staff Cluster";
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = max("Resource Cost New"."Staff Cluster" where(Type = filter(Resource), code = field("No."), "History Status" = filter(actual)));
        }
        field(50004; "Staff Level"; Code[20])
        {
            TableRelation = "Staff Level".Code;
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = max("Resource Cost New"."Staff Level" where(Type = filter(Resource), code = field("No."), "History Status" = filter(actual)));
        }
        field(50005; "Close Date"; Date)
        {
            trigger OnValidate()
            begin
                if "Close Date" <> 0D then rec.Blocked := true;
            end;
        }
        field(50006; "Default Currency"; Code[10]) //#001
        {
            TableRelation = Currency.Code;
            FieldClass = Flowfield;
            CalcFormula = Lookup(Vendor."Currency Code" WHERE("No." = Field("Vendor No.")));
        }
        // Add changes to table fields here
        field(50101; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Active","Inactive","Planning","Resigned","Rotated";
        }
        field(50102; "Staff Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Staff Type";
        }
        modify("Name 2")
        {
            Caption = 'Chinese Name';
        }
        /*
        field(50103; "Overseas Staff"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Overseas Staff';
        }
        */
        field(50104; "Name (Short)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Name (Short)';
        }
    }
    var
        myInt: Integer;
}
