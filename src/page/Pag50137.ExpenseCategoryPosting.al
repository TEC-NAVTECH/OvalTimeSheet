page 50137 "Expense Category Posting"
{
    PageType = Card;
    SourceTable = "Expense Category Posting Group";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Expense Category Code"; Rec."Expense Category Code")
                {
                    ApplicationArea = all;
                }
                field("Expense Category Description"; Rec."Expense Category Description")
                {
                    ApplicationArea = all;
                }
                field("General Ledger COA Mapping"; Rec."General Ledger COA Mapping")
                {
                    ApplicationArea = all;
                }
                field("Expense checking per person"; Rec."Expense checking per person")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
}
