page 50136 "Staff Expense Claim List"
{
    CardPageId = "Staff Expense Claim";
    PageType = List;
    SourceTable = "Staff Expense Claim form Heade";
    UsageCategory = Lists;
    ApplicationArea = all;
    SourceTableView = sorting("EXP Form No.") order(descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("EXP Form No."; Rec."EXP Form No.")
                {
                    ApplicationArea = all;
                }
                field("Apply Date"; Rec."Apply Date")
                {
                    ApplicationArea = all;
                }
                field("Submit User"; Rec."Staff No.")
                {
                    ApplicationArea = all;
                }
                field("Staff Name"; Rec."Staff Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Created User"; Rec."Created User")
                {
                    ApplicationArea = all;
                }
                field("Total Amount (HKD)"; Rec."Total Amount (HKD)")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group(Process)
            {
                action(CreatePI)
                {
                    Caption = 'Create Purchase invoice';
                    Image = CreateForm;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    PromotedOnly = true; //

                    trigger OnAction()
                    var
                        l_rpt_CreatePI: Report "Create Expense Claim Purch Inv";
                        l_Rec_StaffExp: Record "Staff Expense Claim form Heade";
                        l_cdu_SelectionFilter: Codeunit SelectionFilterManagement;
                        RecRef: RecordRef;
                        l_txt_FilterList: Text;
                    begin
                        CurrPage.SetSelectionFilter(l_Rec_StaffExp);
                        RecRef.GetTable(l_Rec_StaffExp);
                        l_txt_FilterList := l_cdu_SelectionFilter.GetSelectionFilter(RecRef, l_Rec_StaffExp.FieldNo("EXP Form No."));
                        CLEAR(l_rpt_CreatePI);
                        l_Rec_StaffExp.RESET();
                        l_Rec_StaffExp.SETFILTER("EXP Form No.", l_txt_FilterList);
                        if l_Rec_StaffExp.FINDSET() then begin
                            l_rpt_CreatePI.SetTableView(l_Rec_StaffExp);
                            l_rpt_CreatePI.RUN();
                        end;
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        UserSetup.Get(UserId);
        Rec.FilterGroup(2);
        if not SkipOriginalFilter then begin
            Resource.reset();
            Resource.SetRange("Time Sheet Owner User ID", UserId);
            if Resource.FindSet() then
                repeat
                    if ResourceFilterText = '' then
                        ResourceFilterText := Resource."No."
                    else
                        ResourceFilterText := ResourceFilterText + '|' + Resource."No.";
                until Resource.Next() = 0;
            if not UserSetup."Staff Expense Form Admin" then Rec.SETFILTER("Staff No.", ResourceFilterText);
        end;
        Rec.FilterGroup(0);
    end;

    procedure ProcessFilter()
    begin
        SkipOriginalFilter := true;
    end;

    var
        Resource: Record Resource;
        SkipOriginalFilter: Boolean;
        ResourceFilterText: Text;
        UserSetup: Record "User Setup";
}
