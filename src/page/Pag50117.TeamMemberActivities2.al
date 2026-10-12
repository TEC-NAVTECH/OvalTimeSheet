page 50117 "Team Member Activities2"
{
    Caption = 'Self-Service';
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Team Member Cue";

    layout
    {
        area(content)
        {
            cuegroup("Time Sheets")
            {
                Caption = 'Time Sheets';

                field("Created Time Sheet"; Rec."Created Time Sheet")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Time Sheet List";
                    ToolTip = 'Specifies the number of time sheets that are currently created.';
                }
                // field("Open Time Sheets"; Rec."Open Time Sheets")
                // {
                //     ApplicationArea = Basic, Suite;
                //     DrillDownPageId = "Time Sheet List";
                //     ToolTip = 'Specifies the number of time sheets that are currently assigned to you and not submitted for approval.';
                // }
                field("Open Time Sheets"; Rec.CountTimeSheetsInStatus2(UserFilterOption::Owner, "Time Sheet Status"::Open))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Time Sheets In progress';
                    ToolTip = 'Specifies the number of time sheets that are currently assigned to you, have open lines and not submitted for approval.';

                    trigger OnDrillDown()
                    begin
                        Rec.DrillDownToTimeSheetList2(UserFilterOption::Owner, "Time Sheet Status"::Open);
                    end;
                }
            }
            cuegroup("Pending Time Sheets")
            {
                Caption = 'Pending Time Sheets';

                // field("Submitted Time Sheets"; Rec."Submitted Time Sheets")
                // {
                //     ApplicationArea = Basic, Suite;
                //     DrillDownPageId = "Time Sheet List";
                //     ToolTip = 'Specifies the number of time sheets that you have submitted for approval but are not yet approved.';
                // }
                // field("Rejected Time Sheets"; Rec."Rejected Time Sheets")
                // {
                //     ApplicationArea = Basic, Suite;
                //     DrillDownPageId = "Time Sheet List";
                //     ToolTip = 'Specifies the number of time sheets that you submitted for approval but were rejected.';
                // }
                // field("Approved Time Sheets"; Rec."Approved Time Sheets")
                // {
                //     ApplicationArea = Basic, Suite;
                //     DrillDownPageId = "Time Sheet List";
                //     ToolTip = 'Specifies the number of time sheets that have been approved.';
                // }
                field("Submitted Time Sheets"; Rec.CountTimeSheetsInStatus2(UserFilterOption::Owner, "Time Sheet Status"::Submitted))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Submitted Time Sheets';
                    ToolTip = 'Specifies the number of time sheets that you have submitted for approval but are not yet approved.';

                    trigger OnDrillDown()
                    begin
                        Rec.DrillDownToTimeSheetList2(UserFilterOption::Owner, "Time Sheet Status"::Submitted);
                    end;
                }
                field("Rejected Time Sheets"; Rec.CountTimeSheetsInStatus2(UserFilterOption::Owner, "Time Sheet Status"::Rejected))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Rejected Time Sheets';
                    ToolTip = 'Specifies the number of time sheets that you submitted for approval but were rejected.';

                    trigger OnDrillDown()
                    begin
                        Rec.DrillDownToTimeSheetList2(UserFilterOption::Owner, "Time Sheet Status"::Rejected);
                    end;
                }
                field("Approved Time Sheets"; Rec.CountTimeSheetsInStatus2(UserFilterOption::Owner, "Time Sheet Status"::Approved))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Approved Time Sheets';
                    ToolTip = 'Specifies the number of time sheets that have been approved.';

                    trigger OnDrillDown()
                    begin
                        Rec.DrillDownToTimeSheetList2(UserFilterOption::Owner, "Time Sheet Status"::Approved);
                    end;
                }
            }
            cuegroup(Approvals)
            {
                Caption = 'Approvals';

                //field("Requests to Approve"; "Requests to Approve")
                // {
                //   ApplicationArea = Basic, Suite;
                //   DrillDownPageID = "Requests to Approve";
                //   ToolTip = 'Specifies requests for certain documents, cards, or journal lines that you must approve for other users before they can proceed.';
                // }
                // field("Time Sheets to Approve"; Rec."Time Sheets to Approve")
                // {
                //     ApplicationArea = Basic, Suite;
                //     DrillDownPageId = "Manager Time Sheet List";
                //     ToolTip = 'Specifies the number of time sheets that need to be approved.';
                //     //Visible = ShowTimeSheetsToApprove;
                //     Visible = false;
                // }
                field("Time Sheets to Approve"; Rec.CountTimeSheetsInStatus2(UserFilterOption::Approver, "Time Sheet Status"::Submitted))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Time Sheets to Approve';
                    ToolTip = 'Specifies the number of time sheets that need to be approved.';
                    //Visible = ShowTimeSheetsToApprove;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        Rec.DrillDownToTimeSheetList2(UserFilterOption::Approver, "Time Sheet Status"::Submitted);
                    end;
                }
                field("Manager Timesheet by Job Month"; Rec."Manager Timesheet by Job Month")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Manager TS by Job Monthly";
                    ToolTip = 'Specifies the number of job time sheets that need to be approved.';
                    Visible = ShowTimeSheetsToApprove;
                }
            }
        }
    }
    actions
    {
    }
    trigger OnAfterGetCurrRecord()
    var
        RoleCenterNotificationMgt: Codeunit "Role Center Notification Mgt.";
    begin
        //RoleCenterNotificationMgt.HideEvaluationNotificationAfterStartingTrial();
        //Count staff expense form
        ResourceFilterText := '';
        NoofStaffForm := 0;
        Resource.reset();
        Resource.SetRange("Time Sheet Owner User ID", UserId);
        if Resource.FindSet() then
            repeat
                if ResourceFilterText = '' then
                    ResourceFilterText := Resource."No."
                else
                    ResourceFilterText := ResourceFilterText + '|' + Resource."No.";
            until Resource.Next() = 0;
        StaffExpHeader.Reset();
        UserSetup.get(UserId);
        StaffExpHeader.SETFILTER("Staff No.", ResourceFilterText);
        if UserSetup."Staff Expense Form Admin" then
            StaffExpHeader.SetRange("Staff No.");
        NoofStaffForm := StaffExpHeader.Count;
        //Message(StaffExpHeader.GetFilters());
        //Count staff expense form
    end;

    trigger OnOpenPage()
    var
        TimeSheetHeader: Record "Time Sheet Header";
        RoleCenterNotificationMgt: Codeunit "Role Center Notification Mgt.";
        ConfPersonalizationMgt: Codeunit "Conf./Personalization Mgt.";
    begin
        UserSetup.get(userid);
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
        TimeSheetHeader.SetRange("Approver User ID", UserId);
        if not TimeSheetHeader.IsEmpty() then begin //TimeSheetHeader.FindFirst() then begin
            Rec.SetRange("Approve ID Filter", UserId);
            Rec.SetRange("User ID Filter", UserId);
            ShowTimeSheetsToApprove := true;
        end
        else begin
            Rec.SetRange("User ID Filter", UserId);
            ShowTimeSheetsToApprove := false;
        end;
        RoleCenterNotificationMgt.ShowNotifications();
        ConfPersonalizationMgt.RaiseOnOpenRoleCenterEvent();
        // if PageNotifier.IsAvailable then begin
        //     PageNotifier := PageNotifier.Create;
        //     PageNotifier.NotifyPageReady;
        // end;
    end;

    var // [RunOnClient]
        // [WithEvents]
        // PageNotifier: DotNet PageNotifier;
        ShowTimeSheetsToApprove: Boolean;
        Resource: Record Resource;
        StaffExpHeader: Record "Staff Expense Claim form Heade";
        ResourceFilterText: Text;
        NoofStaffForm: Integer;
        UserSetup: Record "User Setup";
        UserFilterOption: Option Owner,Approver;
    // trigger PageNotifier::PageReady()
    // var
    //     NetPromoterScoreMgt: Codeunit "Net Promoter Score Mgt.";
    // begin
    //     NetPromoterScoreMgt.ShowNpsDialog;
    // end;
}
