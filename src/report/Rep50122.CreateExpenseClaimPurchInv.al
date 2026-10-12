report 50122 "Create Expense Claim Purch Inv"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Staff Expense Claim form Heade"; "Staff Expense Claim form Heade")
        {
            RequestFilterFields = "EXP Form No.";

            trigger OnAfterGetRecord()
            begin
                IF(Status <> Status::Approved) OR ("Invoice No." <> '')THEN begin
                    IF l_txt_UnsuccessfulText <> '' then l_txt_UnsuccessfulText+=' , ';
                    l_txt_UnsuccessfulText+="EXP Form No.";
                    NoofInvoiceFailed+=1;
                end
                else
                begin
                    HeaderCreated:=false;
                    StaffExpenseClaimfromLine.RESET();
                    StaffExpenseClaimfromLine.SETRANGE("EXP Form No.", "EXP Form No.");
                    IF StaffExpenseClaimfromLine.FINDSET()THEN REPEAT ExpCatPostingGroup.get(StaffExpenseClaimfromLine."Expense Category Code");
                            ExpCatPostingGroup.TestField("General Ledger COA Mapping");
                            if not HeaderCreated then CreatePurchaseHeader();
                            CreatePurchaseLine();
                        UNTIL StaffExpenseClaimfromLine.NEXT() = 0;
                end;
            end;
            trigger OnPostDataItem()
            begin
                if ShowmessageText then Message(StrSubstNo(NoofinvoiceMsg, NoofInvoiceCreated) + '\\' + 'No. of Expense failed:' + FORMAT(NoofInvoiceFailed) + '\' + l_txt_UnsuccessfulText);
            end;
        }
    }
    requestpage
    {
        layout
        {
        }
        actions
        {
        }
        trigger OnOpenPage()
        begin
            ShowmessageText:=true;
        end;
    }
    labels
    {
    }
    var PurchaseSetup: Record "Purchases & Payables Setup";
    PurchaseHeader: Record "Purchase Header";
    Vendor: Record Vendor;
    StaffExpenseClaimfromLine: Record "Staff Expense Claim form Line";
    PurchaseLine: Record "Purchase Line";
    Currency: Record Currency;
    ExpCatPostingGroup: Record "Expense Category Posting Group";
    NoofInvoiceCreated: Integer;
    NoofinvoiceMsg: Label 'Total No. of %1 invoice has been created';
    HeaderCreated: Boolean;
    ShowmessageText: Boolean;
    StaffExpclaimHeader: Record "Staff Expense Claim form Heade";
    l_txt_OutputText: Text;
    l_txt_UnsuccessfulText: Text;
    NoofInvoiceFailed: integer;
    l_Rec_Resource: Record Resource;
    g_recClaimHeader: Record "Staff Expense Claim form Heade";
    local procedure CreatePurchaseHeader()
    begin
        PurchaseSetup.GET();
        CLEAR(PurchaseHeader);
        PurchaseHeader.INIT();
        PurchaseHeader."Document Type":=PurchaseHeader."Document Type"::Invoice;
        IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice THEN PurchaseSetup.TESTFIELD("Invoice Nos.");
        // IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo" THEN
        //     PurchaseSetup.TESTFIELD("Credit Memo Nos.");
        PurchaseHeader."Posting Date":=calcdate('<CM>', "Staff Expense Claim form Heade"."Apply Date");
        PurchaseHeader.INSERT(TRUE);
        Vendor.GET(StaffExpenseClaimfromLine.Vendor);
        StaffExpclaimHeader.Get(StaffExpenseClaimfromLine."EXP Form No.");
        l_Rec_Resource.RESET();
        l_Rec_Resource.SETRANGE("No.", StaffExpclaimHeader."Staff No.");
        IF l_Rec_Resource.FINDSET()THEN;
        VEndor.GET(l_Rec_Resource."Vendor No.");
        //Vendor.TESTFIELD("Bill-to Customer No.",'');
        PurchaseHeader.VALIDATE("Buy-from Vendor No.", Vendor."No.");
        /*                                                                                                  Commented #001
        IF StaffExpenseClaimfromLine."Currency Code" <> '' THEN
            PurchaseHeader.VALIDATE("Currency Code", StaffExpenseClaimfromLine."Currency Code")
        ELSE
            PurchaseHeader.VALIDATE("Currency Code", '');
        */
        //#001 <<
        g_recClaimHeader.Get(StaffExpenseClaimfromLine."EXP Form No.");
        if g_recClaimHeader."Currency Code" <> '' then PurchaseHeader.Validate("Currency Code", g_recClaimHeader."Currency Code")
        else
            PurchaseHeader.Validate("Currency Code", '');
        //#001 >>
        IF StaffExpclaimHeader."Apply Date" <> 0D THEN PurchaseHeader.VALIDATE("Posting Date", calcdate('<CM>', StaffExpclaimHeader."Apply Date")); //
        PurchaseHeader."Vendor Invoice No.":=StaffExpenseClaimfromLine."EXP Form No.";
        PurchaseHeader."Posting Description":='Expense Claim ' + FORMAT(StaffExpclaimHeader."Apply Date", 0, '<Year4>/<Month,2>') + '-' + StaffExpclaimHeader."Staff No.";
        PurchaseHeader."Staff Expense Form No.":=PurchaseHeader."Vendor Invoice No.";
        PurchaseHeader.MODIFY(TRUE);
        StaffExpclaimHeader."Invoice Created":=true;
        StaffExpclaimHeader."Invoice No.":=PurchaseHeader."No.";
        StaffExpclaimHeader.Modify();
        HeaderCreated:=true;
        NoofInvoiceCreated+=1;
    end;
    local procedure CreatePurchaseLine()
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        CLEAR(PurchaseLine);
        PurchaseLine."Document Type":=PurchaseHeader."Document Type";
        PurchaseLine."Document No.":=PurchaseHeader."No.";
        PurchaseLine."Line No.":=GetNextLineNo(PurchaseLine);
        PurchaseLine.VALIDATE(Type, PurchaseLine.Type::"G/L Account");
        PurchaseLine.VALIDATE("No.", ExpCatPostingGroup."General Ledger COA Mapping");
        //PurchaseLine.VALIDATE("Unit of Measure Code",JobPlanningLine."Unit of Measure Code");
        PurchaseLine.VALIDATE(Quantity, 1);
        PurchaseLine.Description:=StaffExpenseClaimfromLine.Remarks;
        IF PurchaseLine."Currency Code" <> '' THEN BEGIN
            Currency.GET(PurchaseLine."Currency Code");
            PurchaseLine.VALIDATE("Direct Unit Cost", ROUND(StaffExpenseClaimfromLine.Amount * PurchaseHeader."Currency Factor", Currency."Unit-Amount Rounding Precision"));
        END
        ELSE
            PurchaseLine.VALIDATE("Direct Unit Cost", StaffExpenseClaimfromLine.Amount);
        //PurchaseLine.VALIDATE("Direct Unit Cost", StaffExpenseClaimfromLine."Amount (HKD)");                  Commented #001
        PurchaseLine.Validate("Direct Unit Cost", StaffExpenseClaimfromLine."Staff currency amount"); //#001
        //PurchaseLine.VALIDATE("Unit Cost (LCY)",JobPlanningLine."Unit Cost (LCY)");
        //PurchaseLine.VALIDATE("Line Discount %",JobPlanningLine."Line Discount %");
        PurchaseLine."Inv. Discount Amount":=0;
        PurchaseLine."Inv. Disc. Amount to Invoice":=0;
        PurchaseLine.UpdateAmounts();
        //END;
        JobPlanningLine.RESET();
        JobPlanningLine.SETRANGE("Job No.", StaffExpenseClaimfromLine."Project Code");
        JobPlanningLine.SETRANGE("Job Task No.", '3000');
        JobPlanningLine.SETRANGE("Line Type", JobPlanningLine."Line Type"::Budget);
        IF JobPlanningLine.IsEmpty()THEN //   IF NOT JobPlanningLine.FINDSET() THEN
 ERROR('Job PLanning Line Record not found for Job No. ' + StaffExpenseClaimfromLine."Project Code" + ' Job Task No. 3000 Line Type Budget');
        PurchaseLine.VALIDATE("Job No.", StaffExpenseClaimfromLine."Project Code");
        PurchaseLine.VALIDATE("Job Task No.", '3000');
        PurchaseLine."Job Line Type":=PurchaseLine."Job Line Type"::Budget;
        PurchaseLIne."Dimension Set ID":=InsertDimension(PurchaseLine."No.", StaffExpenseClaimfromLine."Project Code", PurchaseLIne."Dimension Set ID");
        //IF PurchaseLine."Job Task No." <> '' THEN BEGIN
        //END;
        //PurchaseLine.Description := JobPlanningLine.Description;
        //PurchaseLine."Description 2" := JobPlanningLine."Description 2";
        PurchaseLine.INSERT(TRUE);
    end;
    local procedure InsertDimension(p_cod_AcctCode: Code[20]; p_cod_ProjectCode: Code[20]; p_int_DimSetEntry: integer): Integer var
        l_Rec_GLAccount: Record "G/L Account";
        l_Rec_DefaultDimension: Record "Default Dimension";
        l_cdu_DimMgt: Codeunit DimensionManagement;
        l_Rec_DimSetEntry: Record "Dimension Set Entry";
        l_Rec_DimSetEntryTmp: Record "Dimension Set Entry" temporary;
    begin
        l_Rec_GLAccount.RESET();
        l_Rec_GLAccount.SETRANGE("No.", p_cod_AcctCode);
        IF not l_Rec_GLAccount.IsEmpty()THEN begin //
            //l_cdu_DimMgt.GetDimensionSetID(())
            l_Rec_DimSetEntry.RESET();
            l_Rec_DimSetEntry.SETRANGE("Dimension Set ID", p_int_DimSetEntry);
            IF l_Rec_DimSetEntry.FINDSET()THEN repeat l_Rec_DimSetEntryTmp.RESET();
                    l_Rec_DimSetEntryTmp.INIT();
                    l_Rec_DimSetEntryTmp."Dimension Set ID":=-1;
                    l_Rec_DimSetEntryTmp."Dimension Code":=l_Rec_DimSetEntry."Dimension Code";
                    l_Rec_DimSetEntryTmp.VALIDATE("Dimension Value Code", l_Rec_DimSetEntry."Dimension Value Code");
                    l_Rec_DimSetEntryTmp.INSERT();
                UNTIL l_Rec_DimSetEntry.NEXT() = 0;
            l_Rec_DimSetEntryTmp.RESET();
            l_Rec_DimSetEntryTmp.SETRANGE("Dimension Code", 'PROJECT');
            IF l_Rec_DimSetEntryTmp.FINDSET()THEN begin
                l_Rec_DimSetEntryTmp.VALIDATE("Dimension Value Code", p_cod_ProjectCode);
                l_Rec_DimSetEntryTmp.MODIFY();
            end
            else
            begin
                l_Rec_DimSetEntryTmp.RESET();
                l_Rec_DimSetEntryTmp.INIT();
                l_Rec_DimSetEntryTmp."Dimension Code":='PROJECT';
                l_Rec_DimSetEntryTmp.VALIDATE("Dimension Value Code", p_cod_ProjectCode);
                l_Rec_DimSetEntryTmp."Dimension Set ID":=-1;
                l_Rec_DimSetEntryTmp.INSERT();
            end;
            EXIT(l_cdu_DimMgt.GetDimensionSetID(l_Rec_DimSetEntryTmp));
        end;
    end;
    local procedure GetNextLineNo(pPurchaseLine: Record "Purchase Line"): Integer //
 var
        NextLineNo: Integer;
    begin
        PurchaseLine.SETRANGE("Document Type", pPurchaseLine."Document Type");
        PurchaseLine.SETRANGE("Document No.", pPurchaseLine."Document No.");
        NextLineNo:=10000;
        IF PurchaseLine.FINDLAST()THEN NextLineNo:=PurchaseLine."Line No." + 10000;
        EXIT(NextLineNo);
    end;
    procedure Showmessage(ShowMsg: Boolean)
    begin
        ShowmessageText:=ShowMsg;
    end;
}
