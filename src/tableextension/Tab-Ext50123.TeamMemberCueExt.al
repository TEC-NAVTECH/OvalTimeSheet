tableextension 50123 "Team Member Cue Ext." extends "Team Member Cue"
{
    fields
    {
        field(50001; "Staff Expense Claim"; Integer)
        {
            //DataClassification = ToBeClassified;
            FieldClass = FlowField;
            // CalcFormula = count ("Staff Expense Claim form Heade"
            // where("Created User" = field("User ID Filter")));
            CalcFormula = count("Staff Expense Claim form Heade");
        //where("Created User" = field("User ID Filter")));
        }
        field(50002; "Manager Timesheet by Job Month"; Integer)
        {
            //DataClassification = ToBeClassified;
            FieldClass = FlowField;
            CalcFormula = count("Time Sheet Line" where("Approver ID"=field("User ID Filter")));
        //Status = filter (Open)));
        }
        field(50003; "Created Time Sheet"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Time Sheet Header" where("Created Exist"=filter(=0), "Owner User ID"=field("User ID Filter")));
        }
    }
}
