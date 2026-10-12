report 50124 "Time Sheet Document Print"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Report\ReportTimeSheetDocument.rdl';

    dataset
    {
        dataitem("Time Sheet Header"; "Time Sheet Header")
        {
            RequestFilterFields = "No.";

            column(STAFFNAME; STAFFNAMECAPTIONLBL)
            {
            }
            column(StaffCaptionlbl; StaffCaptionlbl)
            {
            }
            column(ClusternoCaptionlbl; ClusternoCaptionlbl)
            {
            }
            column(ApplicationNoCaptionlbl; ApplicationNoCaptionlbl)
            {
            }
            column(SubmissiondateCaptionlbl; SubmissiondateCaptionlbl)
            {
            }
            column(SubmissiondeadlineCaptionlbl; SubmissiondeadlineCaptionlbl)
            {
            }
            column(POSITIONCAPTIONLBL; POSITIONCAPTIONLBL)
            {
            }
            column(PMDEPTSIGNCAPTIONLBL; PMDEPTSIGNCAPTIONLBL)
            {
            }
            column(Staff; Staff)
            {
            }
            column(companyinfo; companyinfo.Name)
            {
            }
            column(Staff1; Staff1)
            {
            }
            column(ApplicationNo; ApplicationNo)
            {
            }
            column(Month; Month)
            {
            }
            column(SubmissionDate; SubmissionDate)
            {
            }
            column(ClusterNo; ClusterNo)
            {
            }
            column(No1; "Time Sheet Header"."No.")
            {
            }
            column(Resource_No_; "Resource No.")
            {
            }
            column(ReportCaptionlbl; ReportCaptionlbl)
            {
            }
            dataitem("Time Sheet Line"; "Time Sheet Line")
            {
                DataItemLink = "Time Sheet No."=field("No.");

                column(PROJECTNAMECAPTIONLBL; PROJECTNAMECAPTIONLBL)
                {
                }
                column(TotalhoursCaptionlbl; TotalhoursCaptionlbl)
                {
                }
                column(STAFFNAMECAPTIONLBL; STAFFNAMECAPTIONLBL)
                {
                }
                column(W01captionlbl; W01captionlbl)
                {
                }
                column(W02captionlbl; W02captionlbl)
                {
                }
                column(W03captionlbl; W03captionlbl)
                {
                }
                column(W04captionlbl; W04captionlbl)
                {
                }
                column(W05captionlbl; W05captionlbl)
                {
                }
                column(W06captionlbl; W06captionlbl)
                {
                }
                column(TotalhrsjobCaptionlbl; TotalhrsjobCaptionlbl)
                {
                }
                column(Timesheetcaptionlbl; Timesheetcaptionlbl)
                {
                }
                column(SignaturesCaptionlbl; SignaturesCaptionlbl)
                {
                }
                column(EmployeeCaptionlbl; EmployeeCaptionlbl)
                {
                }
                column(StandardtymeweekCaptionlbl; StandardtymeweekCaptionlbl)
                {
                }
                column(Job_No_; "Job No.")
                {
                }
                column(Description; "Time Sheet Line".Description)
                {
                }
                column(No; "Time Sheet Line"."Time Sheet No.")
                {
                }
                column(NoofWorkingHourWeek1; NoofWorkingHour[1])
                {
                }
                column(NoofWorkingHourWeek2; NoofWorkingHour[2])
                {
                }
                column(NoofWorkingHourWeek3; NoofWorkingHour[3])
                {
                }
                column(NoofWorkingHourWeek4; NoofWorkingHour[4])
                {
                }
                column(NoofWorkingHourWeek5; NoofWorkingHour[5])
                {
                }
                column(NoofWorkingHourWeek6; NoofWorkingHour[6])
                {
                }
                column(TotalHourJob1; TotalHourJob1)
                {
                }
                column(TotalHourJob2; TotalHourJob2)
                {
                }
                column(Percent_Per_Month; "Percent Per Month")
                {
                }
                column(Total_Quantity; "Total Quantity")
                {
                }
                trigger OnAfterGetRecord()
                var
                    //ResCostnew: Record "Resource Cost New";
                    ResourceRec: Record resource;
                begin
                    ResourceRec.SetRange("no.", "Time Sheet Header"."Resource No.");
                    if ResourceRec.FindFirst()then // ResCostnew.Reset();
 // ResCostnew.SetRange(Type, ResCostnew.Type::Resource);
                        // ResCostnew.SetRange(Code, ResourceRec."No.");
                        // if ResCostnew.FindLast() then
                        //     ClusterNo := ResCostnew."Staff Cluster";
                        ClusterNo:=ResourceRec."Resource Group No.";
                    ApplicationNo:="Time Sheet Header"."No.";
                    Resource.GET("Time Sheet Header"."Resource No.");
                    Staff1:=Resource.Name;
                    Resource.GET("Time Sheet Header"."Resource No.");
                    Staff:=Resource."No.";
                    Month:=FORMAT("Time Sheet Header"."Starting Date", 0, '<Month Text> <year4>');
                    SubmissionDate:=format("Time Sheet Header"."Starting Date") + '..' + format("Time Sheet Header"."Ending Date");
                    NoofWorkingHour[1]:=GetTotalNoOfWorkingHour("Time Sheet Line"."Time Sheet No.", "Time Sheet Line"."Line No.", WeekArry[1], WeekArry[2]);
                    NoofWorkingHour[2]:=GetTotalNoOfWorkingHour("Time Sheet Line"."Time Sheet No.", "Time Sheet Line"."Line No.", WeekArry[3], WeekArry[4]);
                    NoofWorkingHour[3]:=GetTotalNoOfWorkingHour("Time Sheet Line"."Time Sheet No.", "Time Sheet Line"."Line No.", WeekArry[5], WeekArry[6]);
                    NoofWorkingHour[4]:=GetTotalNoOfWorkingHour("Time Sheet Line"."Time Sheet No.", "Time Sheet Line"."Line No.", WeekArry[7], WeekArry[8]);
                    NoofWorkingHour[5]:=GetTotalNoOfWorkingHour("Time Sheet Line"."Time Sheet No.", "Time Sheet Line"."Line No.", WeekArry[9], WeekArry[10]);
                    NoofWorkingHour[6]:=GetTotalNoOfWorkingHour("Time Sheet Line"."Time Sheet No.", "Time Sheet Line"."Line No.", WeekArry[11], WeekArry[12]);
                end;
            }
            trigger OnAfterGetRecord()
            begin
                StartDate:=CALCDATE('<-CM>', "Time Sheet Header"."Starting Date");
                EndDate:=CALCDATE('<CM>', "Time Sheet Header"."Ending Date");
                RecordNo:=1;
                Date.SETRANGE("Period Type", Date."Period Type"::Week);
                Date.SETFILTER("Period End", '>%1', StartDate);
                Date.SETFILTER("Period Start", '<%1', EndDate);
                if Date.FINDSET()then NoofWeekInMonth:=Date.COUNT;
                repeat if Date."Period Start" < StartDate then WeekArry[RecordNo]:=StartDate
                    else
                        WeekArry[RecordNo]:=Date."Period Start";
                    if Date."Period End" > EndDate then WeekArry[RecordNo + 1]:=EndDate
                    else
                        WeekArry[RecordNo + 1]:=Date."Period End";
                    RecordNo+=2;
                until Date.NEXT() = 0;
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
    }
    labels
    {
    }
    trigger OnInitReport()
    begin
        companyinfo.Get();
    end;
    var STAFFNAMECAPTIONLBL: Label 'STAFF NAME';
    POSITIONCAPTIONLBL: Label 'POSITION';
    PMDEPTSIGNCAPTIONLBL: Label 'PM/Dept Head Sign';
    PROJECTNAMECAPTIONLBL: Label 'Project Name';
    TotalhoursCaptionlbl: Label 'Total No. of Working Hoursper Week';
    W01captionlbl: Label 'W01';
    W02captionlbl: Label 'W02';
    W03captionlbl: Label 'W03';
    W04captionlbl: Label 'W04';
    W05captionlbl: Label 'W05';
    W06captionlbl: Label 'W06';
    TotalhrsjobCaptionlbl: Label 'Total Hours By Job';
    Timesheetcaptionlbl: Label 'Time Sheet Summary';
    SignaturesCaptionlbl: Label 'Signatures';
    EmployeeCaptionlbl: Label 'Employee ';
    StandardtymeweekCaptionlbl: Label 'Weekly Total Hours';
    ClusternoCaptionlbl: Label 'Cluster No';
    ApplicationNoCaptionlbl: Label 'Application No';
    SubmissiondateCaptionlbl: Label 'Submission Date';
    SubmissiondeadlineCaptionlbl: Label 'Submission Deadline';
    StaffCaptionlbl: Label 'Staff Name';
    ReportCaptionlbl: Label 'Time Sheet Summary';
    Resource: Record Resource;
    companyinfo: Record "Company Information";
    Staff: Text;
    Staff1: Text;
    Month: Text;
    Date: Record Date;
    //"Filter": Date;
    StartDate: Date;
    EndDate: Date;
    //DayOfWeek: Integer;
    RecordNo: Integer;
    NoofWeekInMonth: Integer;
    WeekArry: array[14]of Date;
    NoofWorkingHour: array[6]of Decimal;
    TotalHourJob1: Decimal;
    TotalHourJob2: Decimal;
    Day: Date;
    year: Date;
    SubmissionDate: Text[50];
    ApplicationNo: Code[20];
    ClusterNo: Text;
    local procedure GetTotalNoOfWorkingHour(TimeSheetNo: Code[20]; TimeSheetLineNo: Integer; pStartDate: Date; pEndDate: Date): Decimal //
 var
        TimeSheetDetail: Record "Time Sheet Detail";
        TotalQtyForWeek: Decimal;
    begin
        TimeSheetDetail.RESET();
        TimeSheetDetail.SETRANGE("Time Sheet No.", TimeSheetNo);
        TimeSheetDetail.SETRANGE("Time Sheet Line No.", TimeSheetLineNo);
        TimeSheetDetail.SETRANGE(Date, pStartDate, pEndDate); //
        if TimeSheetDetail.FINDSET()then repeat TotalQtyForWeek:=TotalQtyForWeek + TimeSheetDetail.Quantity;
            until TimeSheetDetail.NEXT() = 0;
        exit(TotalQtyForWeek);
    end;
}
