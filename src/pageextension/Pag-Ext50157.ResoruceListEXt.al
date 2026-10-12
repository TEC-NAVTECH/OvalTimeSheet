pageextension 50157 "Resoruce List EXt" extends "Resource List"
{
    layout
    {
        //movebefore(Control1; "Base Unit of Measure", Type)
        modify("Resource Group No.")
        {
            Visible = true;
        }
        modify("Unit Cost")
        {
            Visible = false;
        }
        modify("Profit %")
        {
            Visible = false;
        }
        modify("Price/Profit Calculation")
        {
            Visible = false;
        }
        modify("Unit Price")
        {
            Visible = false;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        modify("Search Name")
        {
            Visible = false;
        }
        modify("Default Deferral Template Code")
        {
            Visible = false;
        }
        modify("Base Unit of Measure")
        {
            Visible = false;
        }
        modify(Type)
        {
            Visible = false;
        }
        addafter("Resource Group No.")
        {
            field("Use Time Sheet"; Rec."Use Time Sheet")
            {
                ApplicationArea = all;
            }
            field("Time Sheet Owner User ID"; Rec."Time Sheet Owner User ID")
            {
                ApplicationArea = all;
            }
            field("Time Sheet Approver User ID"; Rec."Time Sheet Approver User ID")
            {
                ApplicationArea = all;
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = all;
            }
            field("Staff Type"; Rec."Staff Type")
            {
                ApplicationArea = all;
            }
            field("Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = all;
            }
            field("Default Currency"; Rec."Default Currency")
            {
                ApplicationArea = All;
            }
            field("Close Date"; Rec."Close Date")
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
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = All;
            }
        }
    }
    var
}
