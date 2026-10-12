table 50133 "Expense Category Currency"
{
    fields
    {
        field(1; "Expense Category Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Currency Code"; Code[20])
        {
            TableRelation = Currency;
            DataClassification = ToBeClassified;
        }
        field(4; "Pre-approval required amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Maximum Allowed amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; "Expense Category Code", "Currency Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    // Add changes to field groups here
    }
    var myInt: Integer;
    trigger OnInsert()
    begin
    end;
    trigger OnModify()
    begin
    end;
    trigger OnDelete()
    begin
    end;
    trigger OnRename()
    begin
    end;
}
