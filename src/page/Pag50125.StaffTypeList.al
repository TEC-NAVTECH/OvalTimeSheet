page 50125 "Staff Type List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Staff Type";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Staff Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
        }
    }
    var
}
