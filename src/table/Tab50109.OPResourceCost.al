table 50109 "OP Resource Cost"
{
    Caption = 'Resource Cost';

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Resource,Group(Resource),All';
            OptionMembers = Resource, "Group(Resource)", All;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = if(Type=const(Resource))Resource
            else if(Type=const("Group(Resource)"))"Resource Group";

            trigger OnValidate()
            begin
                if(Code <> '') and (Type = Type::All)then FieldError(Code, StrSubstNo(Text000, FieldCaption(Type), Format(Type)));
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
            OptionMembers = "Fixed", "% Extra", "LCY Extra";

            trigger OnValidate()
            begin
                if "Work Type Code" = '' then TestField("Cost Type", "Cost Type"::Fixed);
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
            OptionMembers = "Actual", "Projected";
        }
    }
    keys
    {
        key(Key1; Type, "Code", "Work Type Code")
        {
            Clustered = true;
        }
        key(Key2; "Cost Type", "Code", "Work Type Code")
        {
        }
    }
    fieldgroups
    {
    }
    var Text000: Label 'cannot be specified when %1 is %2';
}
