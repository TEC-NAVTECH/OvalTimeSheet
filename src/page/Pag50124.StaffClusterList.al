page 50124 "Staff Cluster List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Staff Cluster";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Cluster Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field("Cluster Description"; Rec."Description")
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
