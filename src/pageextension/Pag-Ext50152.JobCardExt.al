pageextension 50152 "Job Card Ext" extends "Job Card"
{
    layout
    {
        addafter("Project Manager")
        {
            field("Non-Project Task"; Rec."Non-Project Task")
            {
                ApplicationArea = all;
            }
        }
        addafter("Person Responsible")
        {
            field(PICName; PICName)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'PIC Name';
            }
        }
        //modify("Sell-to Customer No.")
        // {
        //    Caption = 'Project Client';
        //   Visible = true;
        // }
        modify("Sell-to Customer Name")
        {
            Editable = false;
            Caption = 'Project Client Name';
        }
        // addafter("Sell-to Customer No.")
        // {
        //     field(ProjectClientName; ProjectClientName)
        //     {
        //         ApplicationArea = all;
        //         Editable = false;
        //     }
        //}
        modify("Sell-to")
        {
            Visible = false;
        }
        modify("Search Description")
        {
            Visible = false;
        }
        modify("Your Reference")
        {
            Visible = false;
        }
    }
    trigger OnOpenPage()
    begin
        if Usersetup.Get(USERID)then;
        ResourceRec.RESET();
        ResourceRec.SetRange("Time Sheet Owner User ID", UserId);
        if ResourceRec.FindSet()then repeat if ResourceFilterText = '' then ResourceFilterText:=ResourceRec."No."
                else
                    ResourceFilterText:=ResourceFilterText + '|' + ResourceRec."No.";
            until ResourceRec.Next() = 0;
        if(ResourceFilterText <> '') and (not Usersetup."Time Sheet Admin.")then Rec.SetFilter("Person Responsible", ResourceFilterText);
    end;
    trigger OnAfterGetRecord()
    begin
        if ResourceRec.Get(Rec."Person Responsible")then PICName:=ResourceRec.Name
        else
            PICName:='';
        if Customer.get(Rec."Bill-to Customer No.")then ProjectClientName:=Customer.Name
        else
            ProjectClientName:='';
    end;
    var ResourceRec: Record Resource;
    ResourceFilterText: Text;
    Usersetup: Record "User Setup";
    EntryUser: Boolean;
    PICName: Text[100];
    ProjectClientName: Text[100];
    Customer: Record Customer;
}
