page 50158 "Expense Category Currency"
{
    ApplicationArea = All;
    SourceTable = "Expense Category Currency";
    PageType = List;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(group)
            {
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Pre-approval required amount"; Rec."Pre-approval required amount")
                {
                    ApplicationArea = All;
                }
                field("Maximum Allowed amount"; Rec."Maximum Allowed amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var myInt: Integer;
}
