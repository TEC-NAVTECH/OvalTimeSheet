tableextension 50134 "User Setup Extension" extends "User Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50051; "Staff Expense Form Admin"; Boolean)
        {
            DataClassification = ToBeClassified;
        //FieldPropertyName = FieldPropertyValue;
        }
        field(50052; "Staff Expense Bypass Appr. Checking"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    var myInt: Integer;
}
