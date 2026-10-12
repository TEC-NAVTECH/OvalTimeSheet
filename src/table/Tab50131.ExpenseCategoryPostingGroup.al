table 50131 "Expense Category Posting Group"
{
    LookupPageId = "Expense Category Posting List";
    DataCaptionFields = "Expense Category Code", "Expense Category Description";

    fields
    {
        field(1; "Expense Category Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Expense Category Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "General Ledger COA Mapping"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        //#001 <<
        field(4; "Pre-approval required amount"; Decimal)
        {
            Caption = 'Not use';
            DataClassification = ToBeClassified;
        }
        field(5; "Maximum Allowed amount"; Decimal)
        {
            Caption = 'Not use';
            DataClassification = ToBeClassified;
        }
        field(6; "Expense checking per person"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; "Expense Category Code")
        {
        }
    }
    fieldgroups
    {
        fieldgroup(Dropdown; "Expense Category Code", "Expense Category Description")
        {
        }
    }
}
