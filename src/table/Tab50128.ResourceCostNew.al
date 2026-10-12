table 50128 "Resource Cost New"
{
    // version NAVW16.00
    Caption = 'Resource Cost New';

    fields
    {
        field(1; "Type"; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Resource,Group(Resource),All';
            OptionMembers = Resource,"Group(Resource)",All;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = if (Type = const(Resource)) Resource
            else if (Type = const("Group(Resource)")) "Resource Group";

            trigger OnValidate()
            var
                Resource: record Resource;
            begin
                if (Code <> '') and (Type = Type::All) then FIELDERROR(Code, STRSUBSTNO(Text000, FIELDCAPTION(Type), FORMAT(Type)));
                Resource.Reset();
                Resource.SetRange("No.", Code);
                if Resource.FindFirst() then
                    Rec."Staff Name" := Resource."Name (Short)";
            end;
        }
        field(3; "Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";
        }
        field(4; "Cost Type"; Option)
        {
            Caption = 'Cost Type';
            OptionCaption = 'Fixed,% Extra,LCY Extra';
            OptionMembers = "Fixed","% Extra","LCY Extra";

            trigger OnValidate()
            begin
                if "Work Type Code" = '' then TESTFIELD("Cost Type", "Cost Type"::Fixed);
            end;
        }
        field(5; "Direct Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
        }
        field(6; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
        }
        field(7; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(50000; "Effective Date"; Date)
        {
        }
        field(50001; "Staff Cluster"; Code[20])
        {
            TableRelation = "Staff Cluster";
        }
        field(50002; "Staff Level"; Code[20])
        {
            TableRelation = "Staff Level".Code;
        }
        field(50003; "Monthly Salary"; Decimal)
        {
        }
        field(50004; "Latest Record"; Boolean)
        {
        }
        field(50005; "History Status"; Option)
        {
            OptionMembers = "Actual","Projected";
        }
        field(50006; "Month/Year"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Month/Year';
        }
        field(50007; "Month"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Month';
        }
        field(50008; "Year"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Year';
        }
        field(50009; "Staff Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Staff Name';
            Editable = false;
        }
    }
    keys
    {
        key(Key1; Type, "Code", "Work Type Code", "Line No.")
        {
        }
        key(Key2; "Cost Type", "Code", "Work Type Code")
        {
        }
        key(Key3; "Type", "Code", "History Status")
        {
        }
    }
    fieldgroups
    {
    }
    var
        Text000: Label 'cannot be specified when %1 is %2', Comment = '%1,%2';
}
