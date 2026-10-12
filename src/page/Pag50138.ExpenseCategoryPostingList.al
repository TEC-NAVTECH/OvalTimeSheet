page 50138 "Expense Category Posting List"
{
    CardPageId = "Expense Category Posting";
    PageType = List;
    SourceTable = "Expense Category Posting Group";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
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
        area(Navigation)
        {
            Group(Process)
            {
                action("Currency Setup")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        l_pag_CurrencySetup: Page "Expense Category Currency";
                        l_Rec_CurrencySetup: Record "Expense Category Currency";
                    begin
                        CLEAR(l_pag_CurrencySetup);
                        l_Rec_CurrencySetup.RESET;
                        l_Rec_CurrencySetup.SETRANGE("Expense Category Code", Rec."Expense Category Code");
                        IF l_Rec_CurrencySetup.FINDSET THEN;
                        l_pag_CurrencySetup.SetTableView(l_Rec_CurrencySetup);
                        l_pag_CurrencySetup.RunModal();
                    end;
                }
            }
        }
    }
}
