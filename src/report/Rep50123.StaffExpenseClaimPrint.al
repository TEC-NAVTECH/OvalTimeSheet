report 50123 "Staff Expense Claim Print"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Report\StaffExpenseClaimPrint.rdl';

    dataset
    {
        dataitem("Staff Expense Claim Header "; "Staff Expense Claim form Heade")
        {
            RequestFilterFields = "EXP Form No.";

            column(EXPFormNo; "Staff Expense Claim Header "."EXP Form No.")
            {
            }
            column(ApplyDate; "Staff Expense Claim Header "."Apply Date")
            {
            }
            column(CreatedUser; "Staff Expense Claim Header "."Staff Name")
            {
            }
            column(Staff_No_; "Staff No.")
            {
            }
            column(TheOvalPartnershipLtdCaptionlbl; TheOvalPartnershipLtdCaptionlbl)
            {
            }
            column(ClusternoCaptionlbl; ClusternoCaptionlbl)
            {
            }
            column(StaffnameCaptionlbl; StaffnameCaptionlbl)
            {
            }
            column(ApplicationNoCaptionlbl; ApplicationNoCaptionlbl)
            {
            }
            column(SubmissiondateCaptionlbl; SubmissiondateCaptionlbl)
            {
            }
            column(StaffNoCaptionlbl; StaffNoCaptionlbl)
            {
            }
            column(StaffCluster; StaffCluster)
            {
            }
            column(ReportCaptionlbl; ReportCaptionlbl)
            {
            }
            dataitem("Staff Expense Claim Line"; "Staff Expense Claim form Line")
            {
                DataItemLink = "EXP Form No."=field("EXP Form No.");
                DataItemTableView = sorting("Expense Category Description", "Invoice Date");

                column(InvoiceDate_StaffExpenseClaimLine; "Staff Expense Claim Line"."Invoice Date")
                {
                }
                column(ProjectCode_StaffExpenseClaimLine; "Staff Expense Claim Line"."Project Code")
                {
                }
                column(ExpenseCategoryCode_StaffExpenseClaimLine; "Staff Expense Claim Line"."Expense Category Code")
                {
                }
                column(ExpenseCategoryDescription_StaffExpenseClaimLine; "Staff Expense Claim Line"."Expense Category Description")
                {
                }
                column(Pre_Approval_No_; "Pre-Approval No.")
                {
                }
                column(CurrencyCode_StaffExpenseClaimLine; CurrencyCode)
                {
                }
                column(ExchangeRate_StaffExpenseClaimLine; ROUND(ExchangeRate, 0.01))
                {
                }
                column(Amount_StaffExpenseClaimLine; "Staff Expense Claim Line".Amount)
                {
                }
                column(AmountHKD_StaffExpenseClaimLine; "Staff Expense Claim Line"."Staff currency amount")
                {
                }
                column(Remarks_StaffExpenseClaimLine; "Staff Expense Claim Line".Remarks)
                {
                }
                column(Attendees_StaffExpenseClaimLine; "Staff Expense Claim Line".Attendees)
                {
                }
                column(ReferenceNo_StaffExpenseClaimLine; "Staff Expense Claim Line"."Reference No.")
                {
                }
                column(PIC_StaffExpenseClaimLine; "Staff Expense Claim Line".PIC)
                {
                }
                column(CICapprovalCaptionlbl; CICapprovalCaptionlbl)
                {
                }
                column(LineNoCaptionlbl; LineNoCaptionlbl)
                {
                }
                column(EXPFormNo_StaffExpenseClaimLine; "Staff Expense Claim Line"."Exp Form NO.")
                {
                }
                column(ExpenseTypeCaptionlbl; ExpenseTypeCaptionlbl)
                {
                }
                column(ProjectCaptionlbl; ProjectCaptionlbl)
                {
                }
                column(ExpenseItemCaptionlbl; ExpenseItemCaptionlbl)
                {
                }
                column(InvoiceDateCaptionlbl; InvoiceDateCaptionlbl)
                {
                }
                column(CurrencyCaptionlbl; CurrencyCaptionlbl)
                {
                }
                column(AmountCaptionlbl; AmountCaptionlbl)
                {
                }
                column(ExchangeRateCaptionlbl; ExchangeRateCaptionlbl)
                {
                }
                column(EqvAmountCaptionlbl; EqvAmountCaptionlbl)
                {
                }
                column(PreaprovalnoCationlbl; PreaprovalnoCationlbl)
                {
                }
                column(RemarkCaptionlbl; RemarkCaptionlbl)
                {
                }
                column(noofstaffCaptionlbl; noofstaffCaptionlbl)
                {
                }
                column(Totalamount; TotalamountCaptionlbl)
                {
                }
                column(StaffNameForJointDinner_AttLine; StaffNameForJointDinner)
                {
                }
                column(LineNo; LineNo)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    LineNo:=IncStr(LineNo);
                    if "Currency Code" = '' then begin
                        CurrencyCode:='HKD';
                        ExchangeRate:=1;
                    end
                    else
                    begin
                        CurrencyCode:="Currency Code";
                        ExchangeRate:="Exchange Rate";
                    end;
                    IF ExchangeRate = 0 then ExchangeRate:=1;
                    StaffNameForJointDinner:='';
                    ExpClaimLineAttend.Reset();
                    ExpClaimLineAttend.SetRange("EXP Form No.", "EXP Form No.");
                    ExpClaimLineAttend.SetRange("Line No.", "Line No.");
                    if ExpClaimLineAttend.FindSet()then repeat if StaffNameForJointDinner = '' then StaffNameForJointDinner:=ExpClaimLineAttend."Attendee Name"
                            else
                                StaffNameForJointDinner:=StaffNameForJointDinner + ',' + ExpClaimLineAttend."Attendee Name";
                        until ExpClaimLineAttend.Next() = 0;
                end;
            }
            trigger OnAfterGetRecord()
            var
                // ResCostnew: Record "Resource Cost New";
                ResourceRec: Record resource;
                l_cod_CurrencyCode: Code[20];
                l_Rec_GLS: Record "General Ledger Setup";
            begin
                IF l_rec_GLS.GET()THEN;
                l_cod_CurrencyCode:=l_Rec_GLS."LCY Code";
                IF "Currency Code" <> '' then l_cod_CurrencyCode:="Currency Code";
                EqvAmountCaptionlbl:='Eqv Amount (' + l_cod_CurrencyCode + ')';
                TotalamountCaptionlbl:='Total amount';
                ResourceRec.SetRange(ResourceRec."No.", "Staff No.");
                if ResourceRec.FindFirst()then // ResCostnew.Reset();
 // ResCostnew.SetRange(Type, ResCostnew.Type::Resource);
                    // ResCostnew.SetRange(Code, ResourceRec."No.");
                    // if ResCostnew.FindLast() then
                    //     StaffCluster := ResCostnew."Staff Cluster";
                    StaffCluster:=ResourceRec."Resource Group No.";
            end;
            trigger OnPreDataItem()
            var
            begin
                Compinfo.get();
                TheOvalPartnershipLtdCaptionlbl:=CompInfo.name;
                LineNo:='00';
            end;
        }
    }
    // trigger OnPreReport()
    // begin
    //     Compinfo.get();
    //     TheOvalPartnershipLtdCaptionlbl := CompInfo.name;
    // end;
    requestpage
    {
        layout
        {
        }
        actions
        {
        }
    }
    labels
    {
    }
    var ExpClaimLineAttend: Record "Staff Expense Claim Line Atten";
    CompInfo: Record "Company Information";
    StaffNameForJointDinner: Text;
    StaffCluster: Text;
    LineNo: Code[10];
    LineNoCaptionlbl: Label 'Line No';
    TheOvalPartnershipLtdCaptionlbl: Text;
    ClusternoCaptionlbl: Label 'Cluster No';
    StaffnameCaptionlbl: Label 'Staff Name';
    ApplicationNoCaptionlbl: Label 'Application No';
    SubmissiondateCaptionlbl: Label 'Submission Month';
    StaffNoCaptionlbl: Label 'Staff No';
    CICapprovalCaptionlbl: Label 'CIC Approval';
    ExpenseTypeCaptionlbl: Label 'Expense Type';
    ProjectCaptionlbl: Label 'Project';
    ExpenseItemCaptionlbl: Label 'Expense Item';
    InvoiceDateCaptionlbl: Label 'Invoice Date';
    CurrencyCaptionlbl: Label 'Currency';
    AmountCaptionlbl: Label 'Amount';
    ExchangeRateCaptionlbl: Label 'Exchange Rate';
    EqvAmountCaptionlbl: Text; //'Eqv Amount(HKD)';
    PreaprovalnoCationlbl: Label 'Pre approval No';
    RemarkCaptionlbl: Label 'Remark';
    noofstaffCaptionlbl: Label 'Staff Name For Joint Dinner';
    CurrDate: Date;
    TotalamountCaptionlbl: Text; //'Total amount(HKD)';
    ReportCaptionlbl: Label 'Staff Expense Claim Form Summary';
    CurrencyCode: Code[10];
    ExchangeRate: Decimal;
    resource: Record Resource;
}
