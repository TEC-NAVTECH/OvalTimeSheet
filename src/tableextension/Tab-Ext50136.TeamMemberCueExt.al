namespace TimeSheetModification.TimeSheetModification;

using Microsoft.RoleCenters;
using Microsoft.Projects.TimeSheet;

tableextension 50136 "Team Member Cue Ext" extends "Team Member Cue"
{
    procedure CountTimeSheetsInStatus2(UserFilterOption: Option Owner,Approver; TimeSheetStatus: Enum "Time Sheet Status") CalculatedCount: Integer
    var
        TimeSheetLineStatusCount: Query "Time Sheet Line Status Count";
    begin
        case UserFilterOption of
            UserFilterOption::Owner:
                TimeSheetLineStatusCount.SetFilter(Filter_Owner_User, Rec.GetFilter("User ID Filter"));
            UserFilterOption::Approver:
                TimeSheetLineStatusCount.SetFilter(Filter_Approver_User, Rec.GetFilter("Approve ID Filter"));
        end;
        case TimeSheetStatus of
            TimeSheetStatus::Open:
                TimeSheetLineStatusCount.SetRange(Filter_Status, "Time Sheet Status"::Open);
            TimeSheetStatus::Submitted:
                TimeSheetLineStatusCount.SetRange(Filter_Status, "Time Sheet Status"::Submitted);
            TimeSheetStatus::Rejected:
                TimeSheetLineStatusCount.SetRange(Filter_Status, "Time Sheet Status"::Rejected);
            TimeSheetStatus::Approved:
                TimeSheetLineStatusCount.SetRange(Filter_Status, "Time Sheet Status"::Approved);
        end;

        TimeSheetLineStatusCount.Open();
        while TimeSheetLineStatusCount.Read() do
            CalculatedCount += 1
    end;

    procedure DrillDownToTimeSheetList2(UserFilterOption: Option Owner,Approver; TimeSheetStatus: Enum "Time Sheet Status")
    var
        TimeSheetHeader: Record "Time Sheet Header";
    begin
        case UserFilterOption of
            UserFilterOption::Owner:
                TimeSheetHeader.SetFilter("Owner User ID", Rec.GetFilter("User ID Filter"));
            UserFilterOption::Approver:
                TimeSheetHeader.SetFilter("Approver User ID", Rec.GetFilter("Approve ID Filter"));
        end;
        case TimeSheetStatus of
            TimeSheetStatus::Open:
                TimeSheetHeader.SetRange("Open Exists", true);
            TimeSheetStatus::Submitted:
                TimeSheetHeader.SetRange("Submitted Exists", true);
            TimeSheetStatus::Rejected:
                TimeSheetHeader.SetRange("Rejected Exists", true);
            TimeSheetStatus::Approved:
                TimeSheetHeader.SetRange("Approved Exists", true);
        end;

        case UserFilterOption of
            UserFilterOption::Owner:
                Page.Run(Page::"Time Sheet List", TimeSheetHeader);
            UserFilterOption::Approver:
                Page.Run(Page::"Manager Time Sheet List", TimeSheetHeader);
        end;
    end;
}


