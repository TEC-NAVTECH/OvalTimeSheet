page 50144 "Staff Expense Claim Lines"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Staff Expense Claim form Line";
    Caption = 'ExpenseLines';
    UsageCategory = None; //

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                // field("EXP Form No."; "EXP Form No.")
                // {
                //     ApplicationArea = all;
                // }
                // field("Line No."; "Line No.")
                // {
                //     ApplicationArea = all;
                // }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                }
                field("Attachment Indicator"; Rec."Attachment Indicator")
                {
                    ApplicationArea = all;

                    trigger OnAssistEdit()
                    begin
                    //LookupAttachmentPage;
                    end;
                }
                field("Apply Date"; Rec."Apply Date")
                {
                    ApplicationArea = all;
                }
                field(Date; Rec."Invoice Date")
                {
                    ApplicationArea = all;
                }
                field("Project Code"; Rec."Project Code")
                {
                    ApplicationArea = all;
                }
                field("Project Name"; Rec."Project Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Expense Category Code"; Rec."Expense Category Code")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                    //EditableAttendee;
                    end;
                }
                field("Expense Category Description"; Rec."Expense Category Description")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                    //CurrPage.UPDATE(false);
                    end;
                }
                field("Amount (HKD)"; Rec."Amount (HKD)")
                {
                    ApplicationArea = all;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = all;
                }
                field(Vendor; Rec.Vendor)
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Chargeability; Rec.Chargeability)
                {
                    ApplicationArea = all;
                }
                field(Attendees; Rec.Attendees)
                {
                    ApplicationArea = all;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        Commit();
                        LookupAttendeePage();
                    end;
                }
                field("Pre-Approval No."; Rec."Pre-Approval No.")
                {
                    ApplicationArea = all;
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ApplicationArea = all;
                }
                field(PIC; Rec.PIC)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            group(Lines)
            {
                Caption = 'Lines';

                action(OpenDocument)
                {
                    Caption = 'Open Document';
                    ApplicationArea = All;
                    Image = Document;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    PromotedOnly = true; //

                    trigger OnAction()
                    var
                        StaffExpClaimHeader: Record "Staff Expense Claim form Heade";
                    //StaffExp: Page "Staff Expense Claim";
                    begin
                        StaffExpClaimHeader.get(Rec."EXP Form No.");
                        page.Run(50134, StaffExpClaimHeader);
                    end;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
    end;
    trigger OnAfterGetRecord()
    begin
    //EditableAttendee;
    //CurrPage.Update();
    end;
    trigger OnAfterGetCurrRecord()
    begin
    //EditableAttendee;
    end;
    trigger OnOpenPage()
    begin
    //EditableAttendee;
    end;
    trigger OnDeleteRecord(): Boolean begin
        CurrPage.Update(false);
    end;
    var WorkflowEventSubscriber: Codeunit "Workflow Event Subscriber";
    ExpenseCategoryPostingGroup: Record "Expense Category Posting Group";
    EditableAttendees_G: Boolean;
    //Resource: Record Resource;
    //ResourceList: Page "Resource List";
    //AtendeesText: Text[250];
    //StaffExpenseClaimfromLine: Record "Staff Expense Claim form Line";
    GetText: Text;
    NoofString: Integer;
    I: Integer;
    //CommaStr: Text;
    J: Integer;
    //NoofString2: Integer;
    GetText2: Text;
    //CommaStr2: Text;
    //Str1: Text;
    //str2: Text;
    local procedure EditableAttendee()
    begin
        if Rec."Expense Category Code" = 'OT-MEAL' then EditableAttendees_G:=true
        else
            EditableAttendees_G:=false;
    end;
    local procedure LookupAttendeePage()
    var
        StaffExpenseClaimAttSubPage: Page "Staff Expense Claim Atten sub";
        StaffExpeClaimLineatt: Record "Staff Expense Claim Line Atten";
        l_rec_ExpenseCategory: Record "Expense Category Posting Group";
    begin
        Clear(StaffExpenseClaimAttSubPage);
        l_rec_ExpenseCategory.RESET;
        l_rec_ExpenseCategory.SETRANGE("Expense Category Code", Rec."Expense Category Code");
        l_rec_ExpenseCategory.SETRANGE("Expense checking per person", TRUE);
        IF NOT l_rec_ExpenseCategory.FINDSET THEN ERROR('This Expense Category Code has not enabled per person mode');
        Rec.FILTERGROUP(2);
        StaffExpeClaimLineatt.RESET();
        StaffExpeClaimLineatt.SetRange("EXP Form No.", Rec."EXP Form No.");
        StaffExpeClaimLineatt.SetRange("Line No.", Rec."Line No.");
        Rec.FILTERGROUP(0);
        StaffExpenseClaimAttSubPage.SetTableView(StaffExpeClaimLineatt);
        StaffExpenseClaimAttSubPage.Run();
    end;
    local procedure LookupAttachmentPage()
    var
        //DocumentAttachmentDetails: Page "Document Attachment Details2";
        //l_pagDocAttachPR: Page "Document Attachment_Oval";
        //l_recDocAttach: Record "Document Attachments_Oval";
        l_recdocumentatt2: Record "Document Attachment";
    //RecRef: RecordRef;
    begin
        l_recdocumentatt2.SETRANGE("Table ID", DATABASE::"Staff Expense Claim form Line");
        l_recdocumentatt2.SETRANGE("No.", Rec."EXP Form No.");
        l_recdocumentatt2.SETRANGE("Line No.", Rec."Line No.");
        // l_pagDocAttachPR.SETTABLEVIEW(l_recDocAttach);
        // l_pagDocAttachPR.RUNMODAL;
        if Page.RUNMODAL(50140, l_recdocumentatt2) = Action::LookupOK then;
    //RecRef.GetTable(Rec);
    //DocumentAttachmentDetails.OpenForRecRef(RecRef);
    //DocumentAttachmentDetails.RUNMODAL;
    end;
    local procedure AttendeeCodeTest2(ResNo: Code[20]; AttendeeInText: Text): Boolean begin
        GetText:='';
        GetText2:='';
        NoofString:=0;
        J:=0;
        I:=0;
        GetText:=ConvertStr(AttendeeInText, '|', ',');
        NoofString:=(StrLen(GetText) - StrLen(DelChr(GetText, '=', ','))) + 1;
        for I:=1 to NoofString do begin
            if I = NoofString then GetText2:=GetText
            else
                GetText2:=SelectStr(I, GetText);
            if ResNo = GetText2 then J+=1;
        end;
        if J >= 1 then exit(false)
        else
            exit(true);
    end;
}
