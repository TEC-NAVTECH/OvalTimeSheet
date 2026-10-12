table 50129 "Staff Expense Claim form Line"
{
    LookupPageId = "Staff Expense Claim Lines";

    fields
    {
        field(1; "EXP Form No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Staff Expense Claim form Heade"."EXP Form No." where("EXP Form No." = field("EXP Form No."));
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Attachment Indicator"; Boolean)
        {
            //DataClassification = ToBeClassified;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist("Document Attachment" where("No." = field("EXP Form No."), "Line No." = field("Line No.")));
        }
        field(4; "Apply Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                ExpClaimLineAtt: Record "Staff Expense Claim Line Atten";
            begin
                if ("Invoice Date" <> xRec."Invoice Date") then begin
                    ExpClaimLineAtt.Reset();
                    ExpClaimLineAtt.SetRange("EXP Form No.", "EXP Form No.");
                    ExpClaimLineAtt.SetRange("Line No.", "Line No.");
                    ExpClaimLineAtt.SetFilter(Attendees, '<>%1', '');
                    if not ExpClaimLineAtt.IsEmpty() then //ExpClaimLineAtt.FindFirst() then
                        Error('Attendee list must be clear');
                end;
            end;
        }
        field(6; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Job;

            trigger OnValidate()
            var
                JobRec: Record Job;
            begin
                if JobRec.get("Project Code") then begin
                    //#004 <<
                    if JobRec.Blocked <> JobRec.Blocked::" " then Error(StrSubstNo('Job %1 is blocked and not available for expense claim.', JobRec."No."));
                    //#004 >>
                    PIC := JobRec."Person Responsible";
                    //Validate("Currency Code", 'HKD');
                    "Project Name" := JobRec.Description;
                end;
            end;
        }
        field(7; "Expense Category Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Expense Category Posting Group";

            // TableRelation = "Expense Category Posting Group"."Expense Category Code";
            trigger OnValidate()
            var
                expenseCatPostGrp: Record "Expense Category Posting Group";
                StaffExpAttendee: Record "Staff Expense Claim Line Atten";
                StaffExpFormHeader: Record "Staff Expense Claim form Heade";
                StaffExpLine: Record "Staff Expense Claim form Line";
                LastLine: Integer;
            begin
                StaffExpFormHeader.get("EXP Form No.");
                if expenseCatPostGrp.Get("Expense Category Code") then
                    "Expense Category Description" := expenseCatPostGrp."Expense Category Description"
                else
                    "Expense Category Description" := '';
                FindResource();
                //Payee := Resource."No.";
                Payee := StaffExpFormHeader."Staff No.";
                Vendor := Resource."Vendor No.";
                //Message('%1', "Line No.");
                // insert default attendee for staff no. if category is 1-WORK MEAL
            end;
        }
        field(8; "Expense Category Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;

            trigger OnValidate()
            var
                CurrExchRate: Record "Currency Exchange Rate";
                l_recStaffExpHeader: Record "Staff Expense Claim form Heade";
            begin
                if "Currency Code" <> '' then begin
                    "Currency Factor" := CurrExchRate.ExchangeRate("Invoice Date", "Currency Code");
                    //"Exchange Rate" := 1 / "Currency Factor";
                    IF Rec.Amount = 0 then
                        "Exchange Rate" := 0
                    ELSE
                        "Exchange Rate" := ROUND("Staff currency amount" / REC.Amount, 0.01);
                    Validate(Amount);
                end
                else begin
                    "Currency Factor" := 0;
                    "Exchange Rate" := 0;
                    Validate(Amount);
                end;
                // if "Currency Code" <> '' then begin
                //     l_recStaffExpHeader.Reset();
                //     l_recStaffExpHeader.SetRange("EXP Form No.", Rec."EXP Form No.");
                //     if l_recStaffExpHeader.FindFirst() then begin
                //         if l_recStaffExpHeader."Currency Code" = Rec."Currency Code" then
                //             Rec."Exchange Rate" := 1
                //         else begin
                //             if l_recStaffExpHeader."Currency Code" <> 'HKD' then begin
                //                 Rec."Exchange Rate" := Round(CurrExchRate.ExchangeRate("Invoice Date", l_recStaffExpHeader."Currency Code"), 0.01);
                //                 "Currency Factor" := CurrExchRate.ExchangeRate("Invoice Date", l_recStaffExpHeader."Currency Code");
                //             end
                //             else begin
                //                 Rec."Exchange Rate" := Round(1 / CurrExchRate.ExchangeRate("Invoice Date", rec."Currency Code"), 0.01);
                //                 "Currency Factor" := CurrExchRate.ExchangeRate("Invoice Date", rec."Currency Code");
                //             end;

                //             //"Exchange Rate" := 1 / "Currency Factor";
                //             /*
                //                 IF Rec.Amount = 0 then "Exchange Rate":=0
                //                 ELSE
                //                     "Exchange Rate":=ROUND("Staff currency amount" / REC.Amount, 0.01);
                //             */
                //         end;
                //     end;
                //     Validate(Amount);
                // end
                // else begin
                //     "Currency Factor" := 0;
                //     "Exchange Rate" := 0;
                //     Validate(Amount);
                // end;
            end;
        }
        field(10; "Exchange Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; Amount; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                CurrExchRate: Record "Currency Exchange Rate";
                l_recStaffExpClaimHeader: Record "Staff Expense Claim form Heade";
                l_decCurrencyFactor: Decimal;
            begin
                if "Currency Code" = '' then
                    "Amount (HKD)" := Amount
                else
                    // "Amount (HKD)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Apply Date", "Currency Code", Amount, CurrExchRate.ExchangeRate("Apply Date", "Currency Code")));//VJ 7May2026
                    "Amount (HKD)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Invoice Date", "Currency Code", Amount, CurrExchRate.ExchangeRate("Invoice Date", "Currency Code")));

                //#004 <<
                l_recStaffExpClaimHeader.Reset();
                l_recStaffExpClaimHeader.SetRange("EXP Form No.", Rec."EXP Form No.");
                if l_recStaffExpClaimHeader.FindFirst() then
                    if (l_recStaffExpClaimHeader."Currency Code" <> '') then begin
                        l_decCurrencyFactor := CurrExchRate.ExchangeRate("Invoice Date", l_recStaffExpClaimHeader."Currency Code");
                        // "Staff currency amount" := Round(CurrExchRate.ExchangeAmtLCYToFCY("Apply Date", l_recStaffExpClaimHeader."Currency Code", Rec."Amount (HKD)", l_decCurrencyFactor));//VJ 7May2026
                        "Staff currency amount" := Round(CurrExchRate.ExchangeAmtLCYToFCY("Invoice Date", l_recStaffExpClaimHeader."Currency Code", Rec."Amount (HKD)", l_decCurrencyFactor));

                        IF Rec.Amount = 0 then
                            "Exchange Rate" := 0
                        ELSE
                            "Exchange Rate" := ROUND("Staff currency amount" / REC.Amount, 0.01);
                    end
                    else begin
                        "Staff currency amount" := Amount;
                        "Exchange Rate" := 1;
                    end;
                // //#004 >>
                // "Staff currency amount" := "Amount (HKD)";
            end;
        }
        field(12; "Amount (HKD)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18; Attendees; Integer)
        {
            //DataClassification = ToBeClassified;
            FieldClass = FlowField;
            CalcFormula = count("Staff Expense Claim Line Atten" where("EXP Form No." = field("EXP Form No."), "Line No." = field("Line No.")));
        }
        field(19; "Pre-Approval No."; Text[12])
        {
            DataClassification = ToBeClassified;
        }
        field(17; Chargeability; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Chargeable,"Non-Chargeable";
        }
        field(13; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(14; Payee; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Resource;

            trigger OnValidate()
            var
                resourcevar: Record Resource;
            begin
                if resourcevar.get(Payee) then if (resourcevar.Blocked) and (resourcevar."Close Date" <= Rec."Invoice Date") then Error('You can not select blocked resource');
            end;
        }
        field(15; Vendor; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(16; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,"Submitted Pending Approval",Approved;
            //Editable = false;
        }
        field(20; "Reference No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(21; PIC; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Project Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Staff currency amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; "EXP Form No.", "Line No.")
        {
            SumIndexFields = Amount, "Amount (HKD)", "Staff currency amount"; //
        }
        key(key2; "Expense Category Description", "Invoice Date")
        {
            SumIndexFields = Amount, "Amount (HKD)", "Staff currency amount"; //
        }
        //TEC#003
        key(Key3; "Expense Category Code", "Invoice Date")
        {
            SumIndexFields = Amount, "Amount (HKD)", "Staff currency amount"; //
        }
    }
    fieldgroups
    {
    }
    trigger OnInsert()
    begin
        "Apply Date" := Today;
        //"Currency Code" := 'HKD';
        Chargeability := Chargeability::"Non-Chargeable";
        CheckStatusOpen();
    end;

    trigger OnModify()
    begin
        CheckStatusOpen();
        ;
    end;

    trigger OnDelete()
    var
        StaffClaimFormAttendee: Record "Staff Expense Claim Line Atten";
    begin
        CheckStatusOpen();
        ;
        StaffClaimFormAttendee.SetRange("EXP Form No.", "EXP Form No.");
        StaffClaimFormAttendee.SetRange("Line No.", "Line No.");
        if StaffClaimFormAttendee.FindFirst() then StaffClaimFormAttendee.delete();
    end;

    trigger OnRename()
    begin
    end;

    var
        ExpClaimHeader: Record "Staff Expense Claim form Heade";
        Resource: Record Resource;

    procedure ShowLineAttachments()
    var
        l_recDocAttach: Record "Document Attachment";
        l_pagDocAttachPR: Page "Document Attachment Details2";
    begin
        TestField("EXP Form No.");
        TestField("Line No.");
        l_recDocAttach.SetRange("Table ID", DATABASE::"Staff Expense Claim form Line");
        l_recDocAttach.SetRange("No.", "EXP Form No.");
        l_recDocAttach.SetRange("Line No.", "Line No.");
        l_pagDocAttachPR.SETTABLEVIEW(l_recDocAttach);
        l_pagDocAttachPR.RUNMODAL();
    end;

    procedure CheckStatusOpen()
    var
        l_rec_StaffExpHdr: Record "Staff Expense Claim form Heade";
    begin
        //TEC#002 <<
        l_rec_StaffExpHdr.RESET();
        l_rec_StaffExpHdr.SETRANGE("EXP Form No.", "EXP Form No.");
        if l_rec_StaffExpHdr.FindFirst() then //l_rec_StaffExpHdr.FINDSET() then
            if l_rec_StaffExpHdr.Status in [l_rec_StaffExpHdr.Status::Open, l_rec_StaffExpHdr.Status::Rejected] then
                l_rec_StaffExpHdr := l_rec_StaffExpHdr //
            else
                ERROR('Status must be Open / Rejected');
        //GetExpClaimHeader();
        //CheckStatusOpen();
        //TEC#002 >>
    end;

    procedure GetExpClaimHeader()
    begin
        ExpClaimHeader.Get("EXP Form No.");
    end;

    procedure FindResource()
    var
        l_rec_StaffExpClaimHdr: Record "Staff Expense Claim form Heade";
    begin
        l_rec_StaffExpClaimHdr.Reset();
        l_rec_StaffExpClaimHdr.SETRANGE("EXP Form No.", Rec."EXP Form No.");
        if l_rec_StaffExpClaimHdr.FindFirst() then; //l_rec_StaffExpClaimHdr.FINDSET() then;
        Resource.SETRANGE("No.", l_rec_StaffExpClaimHdr."Staff No.");
        //Resource.SetRange("Time Sheet Owner User ID", UserId);
        if Resource.FindFirst() then;
    end;

    procedure ApproveStaffExpense(var StaffExpenseClaimfromLine: Record "Staff Expense Claim form Line")
    var
        StaffExpClaimLine: Record "Staff Expense Claim form Line";
        StaffExpClaimHead: Record "Staff Expense Claim form Heade";
        unapprovedfind: Boolean;
        CreateStaffInvoice: Report 50122;
    begin
        //Message('start app');
        if StaffExpenseClaimfromLine.Status = StaffExpenseClaimfromLine.Status::Approved then exit;
        StaffExpenseClaimfromLine.Status := StaffExpenseClaimfromLine.Status::Approved;
        //Message('stop app');
        StaffExpenseClaimfromLine.Modify();
        unapprovedfind := true;
        StaffExpClaimLine.Reset();
        StaffExpClaimLine.SetRange("EXP Form No.", StaffExpenseClaimfromLine."EXP Form No.");
        StaffExpClaimLine.SetFILTER(Status, '<>%1', StaffExpClaimLine.Status::Approved);
        if not StaffExpClaimLine.IsEmpty() then //StaffExpClaimLine.FindFirst() then
            unapprovedfind := true
        else
            unapprovedfind := false;
        if not unapprovedfind then begin
            StaffExpClaimHead.Get(StaffExpenseClaimfromLine."EXP Form No.");
            StaffExpClaimHead.Status := StaffExpClaimHead.Status::Approved;
            StaffExpClaimHead.Modify();
        end
        else begin
            StaffExpClaimHead.Get(StaffExpenseClaimfromLine."EXP Form No.");
            StaffExpClaimHead.Status := StaffExpClaimHead.Status::"Partial Approved";
            StaffExpClaimHead.Modify();
        end;
        if StaffExpClaimHead.Status = StaffExpClaimHead.Status::Approved then begin
            StaffExpClaimHead.SetRecFilter();
            CreateStaffInvoice.UseRequestPage := false;
            CreateStaffInvoice.Showmessage(false);
            CreateStaffInvoice.SetTableView(StaffExpClaimHead);
            CreateStaffInvoice.Run();
            clear(CreateStaffInvoice);
        end;
    end;

    procedure OpenStaffExpense(var StaffExpenseClaimfromLine: Record "Staff Expense Claim form Line")
    begin
        if StaffExpenseClaimfromLine.Status = StaffExpenseClaimfromLine.Status::Open then exit;
        StaffExpenseClaimfromLine.Status := StaffExpenseClaimfromLine.Status::Open;
        StaffExpenseClaimfromLine.Modify();
    end;
}
