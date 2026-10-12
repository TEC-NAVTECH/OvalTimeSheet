pageextension 50122 "Resource Card Ext." extends "Resource Card"
{
    layout
    {
        modify("Search Name")
        {
            Visible = false;
        }
        modify("Privacy Blocked")
        {
            Visible = false;
        }
        modify(Type)
        {
            Visible = false;
        }
        modify("Base Unit of Measure")
        {
            Visible = false;
        }
        modify("Last Date Modified")
        {
            Visible = false;
        }
        // modify(Blocked)
        // {
        //     Visible = false;
        // }
        addlast(General)
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
            }
            field("Staff Type"; Rec."Staff Type")
            {
                ApplicationArea = All;
            }
            field("Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = all;
            }
            //field("Name 2"; Rec."Name 2")
            // {
            //     ApplicationArea = all;
            //}
            field("Staff Cluster"; Rec."Staff Cluster")
            {
                ApplicationArea = All;
            }
            field("Staff Level"; Rec."Staff Level")
            {
                ApplicationArea = All;
            }
            field("Close Date"; Rec."Close Date")
            {
                ApplicationArea = ALL;
            }
            // field(Blocked1; Blocked)
            // {
            //     ApplicationArea = all;
            // }
            field("Default Currency"; Rec."Default Currency")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Close Date"; Blocked)
    }
    actions
    {
        // Add changes to page actions here
        //modify(Costs)
        //{
        //   Caption = 'Salary History';
        //}
        addafter(PurchPriceLists)
        {
            action("Salary History")
            {
                ApplicationArea = Jobs;
                Caption = 'Salary History';
                Image = ResourceCosts;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page 50129;
                RunPageLink = Type=const(Resource), Code=field("No.");
                ToolTip = 'View or change detailed information about costs for the resource.';
            }
        }
    }
    var
}
