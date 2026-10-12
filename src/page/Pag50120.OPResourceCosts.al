page 50120 "OP Resource Costs"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Resource Costs';
    DataCaptionFields = "Code";
    PageType = List;
    SourceTable = "OP Resource Cost";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field(Type; Rec.Type)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the type.';
                }
                field("Code"; Rec.Code)
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
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }
    actions
    {
    }
}
