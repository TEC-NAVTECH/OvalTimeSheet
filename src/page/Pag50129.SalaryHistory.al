page 50129 "Salary History"
{
    // version NAVW113.00
    ApplicationArea = Basic, Suite;
    Caption = 'Salary History';
    DataCaptionFields = "Code";
    PageType = List;
    SourceTable = "Resource Cost New";
    UsageCategory = Administration;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(SalaryHistory)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the type.';
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code.';
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for the type of work. You can also assign a unit price to a work type.';
                }
                field("Cost Type"; Rec."Cost Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the type of cost.';
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the cost of one unit of the selected item or resource.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the cost of one unit of the item or resource on the line.';
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ApplicationArea = All;
                }
                field("Staff Cluster"; Rec."Staff Cluster")
                {
                    ApplicationArea = All;
                }
                field("Staff Level"; Rec."Staff Level")
                {
                    ApplicationArea = All;
                }
                field("Monthly Salary"; Rec."Monthly Salary")
                {
                    ApplicationArea = All;
                }
                field("Latest Record"; Rec."Latest Record")
                {
                    ApplicationArea = All;
                }
                field("History Status"; Rec."History Status")
                {
                    ApplicationArea = all;
                }
                field("Month/Year"; Rec."Month/Year")
                {
                    ApplicationArea = all;
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = all;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = all;
                }
                field("Staff Name"; Rec."Staff Name")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
    }
}
