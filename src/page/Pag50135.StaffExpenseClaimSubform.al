page 50135 "Staff Expense Claim Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Staff Expense Claim form Line";
    Caption = 'ExpenseLines';
    SourceTableView = SORTING("Expense Category Code", "Invoice Date");

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
                    Editable = false;
                }
                field("Attachment Indicator"; Rec."Attachment Indicator")
                {
                    ApplicationArea = all;

                    trigger OnAssistEdit()
                    begin
                        LookupAttachmentPage();
                    end;
                }
                field("Expense Category Code"; Rec."Expense Category Code")
                {
                    ApplicationArea = all;
                    Width = 22;

                    trigger OnValidate()
                    var
                        //StaffExpFormHeader: Record "Staff Expense Claim form Heade";
                        StaffExpAttendee: Record "Staff Expense Claim Line Atten";
                    begin
                        //EditableAttendee;
                        // "Invoice Date" := today;
                        // CurrPage.SaveRecord();
                        if (xRec."Expense Category Code" = '1-WORK MEAL') and (Rec."Expense Category Code" <> xRec."Expense Category Code") then begin
                            StaffExpAttendee.Reset();
                            StaffExpAttendee.SetRange("EXP Form No.", Rec."EXP Form No.");
                            StaffExpAttendee.SetRange("Line No.", Rec."Line No.");
                            if StaffExpAttendee.FindFirst() then StaffExpAttendee.deleteall();
                        end;
                        // if (Rec."Expense Category Code" = '1-WORK MEAL') then begin
                        //     if "Line No." = 0 then
                        //         Error('Line no. can not be 0');
                        //     StaffExpFormHeader.Get(Rec."EXP Form No.");
                        //     StaffExpFormHeader.TestField("Staff No.");
                        //     StaffExpAttendee.Init();
                        //     StaffExpAttendee."EXP Form No." := "EXP Form No.";
                        //     StaffExpAttendee."Line No." := "Line No.";
                        //     StaffExpAttendee.validate(Attendees, StaffExpFormHeader."Staff No.");
                        //     StaffExpAttendee.Insert();
                        // end;
                    end;
                }
                field("Amount (HKD)"; Rec."Amount (HKD)")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field(Date; Rec."Invoice Date")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    var
                        StaffExpFormHeader: Record "Staff Expense Claim form Heade";
                        StaffExpAttendee: Record "Staff Expense Claim Line Atten";
                    begin
                        if Rec."Invoice Date" <> 0D then begin
                            CurrPage.SaveRecord();
                            if (xRec."Expense Category Code" = '1-WORK MEAL') and (Rec."Expense Category Code" <> xRec."Expense Category Code") then begin
                                StaffExpAttendee.Reset();
                                StaffExpAttendee.SetRange("EXP Form No.", Rec."EXP Form No.");
                                StaffExpAttendee.SetRange("Line No.", Rec."Line No.");
                                if StaffExpAttendee.FindFirst() then StaffExpAttendee.deleteall();
                            end;
                            if (Rec."Expense Category Code" = '1-WORK MEAL') then begin
                                if Rec."Line No." = 0 then Error('Line no. can not be 0');
                                StaffExpFormHeader.Get(Rec."EXP Form No.");
                                StaffExpFormHeader.TestField("Staff No.");
                                StaffExpAttendee.Init();
                                StaffExpAttendee."EXP Form No." := Rec."EXP Form No.";
                                StaffExpAttendee."Line No." := Rec."Line No.";
                                StaffExpAttendee.validate(Attendees, StaffExpFormHeader."Staff No.");
                                StaffExpAttendee.Insert();
                            end;
                        end;
                    end;
                }
                field("Expense Category Description"; Rec."Expense Category Description")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Apply Date"; Rec."Apply Date")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                    Caption = 'Currency Code';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                    Width = 8;

                    trigger OnValidate()
                    begin
                        //CurrPage.UPDATE(false);
                    end;
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ApplicationArea = all;
                    Width = 8;
                }
                field("Amount (HKD) DUPLICATE"; Rec."Amount (HKD)")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Amount (HKD) Converted';
                    Visible = false;
                }
                field("Staff currency amount"; Rec."Staff currency amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Project Code"; Rec."Project Code")
                {
                    ApplicationArea = all;
                    Width = 8;
                }
                field("Project Name"; Rec."Project Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Width = 30;
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
                field(Chargeability; Rec.Chargeability)
                {
                    ApplicationArea = all;
                    Visible = false; //TEC#003
                }
                field("Pre-Approval No."; Rec."Pre-Approval No.")
                {
                    ApplicationArea = all;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Vendor; Rec.Vendor)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(PIC; Rec.PIC)
                {
                    ApplicationArea = all;
                    Visible = false;
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

                action(DocAttach)
                {
                    ApplicationArea = All;
                    Caption = 'Attachments';
                    Image = Attach;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    begin
                        LookupAttachmentPage();
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = All;
                    Image = Approvals; //

                    trigger OnAction()
                    var
                        //WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
                        //StaffExpClaimFormLine: Record "Staff Expense Claim form Line";
                        //ApprovalEntries: Page "Approval Entries";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        //StaffExpClaimFormLine.SetRange("EXP Form No.", "EXP Form No.");
                        //StaffExpClaimFormLine.SetRange("Line No.", "Line No.");
                        //IF StaffExpClaimFormLine.FindFirst() then
                        //ApprovalsMgmt.RunWorkflowEntriesPage(
                        //    RecordIDInput, TableId, "Approval Document Type".FromInteger(DocumentType), DocumentNo);
                        ApprovalsMgmt.RunWorkflowEntriesPage(Rec.RECORDID, DATABASE::"Staff Expense Claim form Line", "Approval Document Type".FromInteger(0), Rec."EXP Form No.");
                        //ApprovalEntries.Setfilters(DATABASE::"Sales Header", 0, "EXP Form No.");
                        //ApprovalEntries.RUN;
                    end;
                }
                action(Attendee)
                {
                    ApplicationArea = all;
                    Image = Line;

                    //RunObject = page "Staff Expense Claim Atten sub";
                    //RunPageLink = "EXP Form No." = field ("EXP Form No."), "Line No." = field ("Line No.");
                    trigger OnAction()
                    begin
                        LookupAttendeePage();
                    end;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Apply Date" := Today;
        IF g_rec_StaffExpHdr.GET(Rec."EXP Form No.") THEN rec.validate("Currency Code", g_rec_StaffExpHdr."Currency Code");
        //"Currency Code" := 'HKD';
        Rec.Chargeability := Rec.Chargeability::"Non-Chargeable";
        CurrPage.Update(false);
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

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Update(false);
    end;

    var
        WorkflowEventSubscriber: Codeunit "Workflow Event Subscriber";
        ExpenseCategoryPostingGroup: Record "Expense Category Posting Group";
        EditableAttendees_G: Boolean;
        g_rec_StaffExpHdr: Record "Staff Expense Claim form Heade";
        Resource: Record Resource;
        ResourceList: Page "Resource List";
        AtendeesText: Text[250];
        StaffExpenseClaimfromLine: Record "Staff Expense Claim form Line";
        GetText: Text;
        NoofString: Integer;
        I: Integer;
        CommaStr: Text;
        J: Integer;
        NoofString2: Integer;
        GetText2: Text;
        CommaStr2: Text;
        Str1: Text;
        str2: Text;

    local procedure EditableAttendee()
    begin
        if Rec."Expense Category Code" = '1-WORK MEAL' then
            EditableAttendees_G := true
        else
            EditableAttendees_G := false;
    end;

    local procedure LookupAttendeePage()
    var
        StaffExpenseClaimAttSubPage: Page "Staff Expense Claim Atten sub";
        StaffExpeClaimLineatt: Record "Staff Expense Claim Line Atten";
        l_Rec_ExpenseCategory: Record "Expense Category Posting Group";
    begin
        Clear(StaffExpenseClaimAttSubPage);
        l_Rec_ExpenseCategory.RESET;
        l_Rec_ExpenseCategory.SETRANGE("Expense Category Code", Rec."Expense Category Code");
        l_Rec_ExpenseCategory.SETRANGE("Expense checking per person", TRUE);
        IF l_Rec_ExpenseCategory.FINDSET THEN BEGIN
            Rec.FILTERGROUP(2);
            StaffExpeClaimLineatt.RESET();
            StaffExpeClaimLineatt.SetRange("EXP Form No.", Rec."EXP Form No.");
            StaffExpeClaimLineatt.SetRange("Line No.", Rec."Line No.");
            Rec.FILTERGROUP(0);
            StaffExpenseClaimAttSubPage.SetformNo(Rec."EXP Form No.", Rec."Line No.");
            StaffExpenseClaimAttSubPage.SetTableView(StaffExpeClaimLineatt);
            StaffExpenseClaimAttSubPage.SetRecord(StaffExpeClaimLineatt);
            StaffExpenseClaimAttSubPage.LookupMode(true);
            StaffExpenseClaimAttSubPage.Run();
        END
        ELSE begin
            ERROR('This Expense Category does not allow to enter Attendees');
        end;
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
        if Page.RUNMODAL(50154, l_recdocumentatt2) = Action::LookupOK then;
        //RecRef.GetTable(Rec);
        //DocumentAttachmentDetails.OpenForRecRef(RecRef);
        //DocumentAttachmentDetails.RUNMODAL;
    end;

    local procedure AttendeeCodeTest2(ResNo: Code[20]; AttendeeInText: Text): Boolean
    begin
        GetText := '';
        GetText2 := '';
        NoofString := 0;
        J := 0;
        I := 0;
        GetText := ConvertStr(AttendeeInText, '|', ',');
        NoofString := (StrLen(GetText) - StrLen(DelChr(GetText, '=', ','))) + 1;
        for I := 1 to NoofString do begin
            if I = NoofString then
                GetText2 := GetText
            else
                GetText2 := SelectStr(I, GetText);
            if ResNo = GetText2 then J += 1;
        end;
        if J >= 1 then
            exit(false)
        else
            exit(true);
    end;
}
