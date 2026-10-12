pageextension 50150 "Job List Ext" extends "Job List"
{
    layout
    {
        addafter(Description)
        {
            field(PIC; Rec."Person Responsible")
            {
                ApplicationArea = ALL;
                Caption = 'PIC';
            }
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
        ResourceRec.RESET();
        ResourceRec.SetRange("Time Sheet Approver User ID", UserId);
        if not ResourceRec.FindSet()then EntryUser:=true
        else
            entryuser:=false;
        if(ResourceFilterText <> '') and (not Usersetup."Time Sheet Admin.") and (not EntryUser)then Rec.SetFilter("Person Responsible", ResourceFilterText);
    end;
    var ResourceRec: Record Resource;
    ResourceFilterText: Text;
    Usersetup: Record "User Setup";
    EntryUser: Boolean;
}
