page 50123 "Staff Level List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Staff Level";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Level Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field("Level Description"; Rec."Description")
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
    var myInt: Integer;
}
