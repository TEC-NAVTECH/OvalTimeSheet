page 50143 "Staff Expense Claim Atten sub"
{
    PageType = List;
    //ApplicationArea = All;
    //    UsageCategory = Administration;
    DelayedInsert = true;
    LinksAllowed = false;
    SourceTable = "Staff Expense Claim Line Atten";
    UsageCategory = None; //

    layout
    {
        area(Content)
        {
            group(Group)
            {
            }
            repeater(Lines)
            {
                field("EXP Form No."; Rec."EXP Form No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(Attendees; Rec.Attendees)
                {
                    ApplicationArea = All;
                //Editable = false;
                }
                field("Attendee Name"; Rec."Attendee Name")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean var
        ExpClaimLineAttend: Record "Staff Expense Claim Line Atten";
        ExpClaimLineAttend2: Record "Staff Expense Claim Line Atten";
        ExpClaimLine: Record "Staff Expense Claim form Line";
        StaffExpenseClaimfromHeade: Record "Staff Expense Claim form Heade";
    begin
        //Message('%1', g_StaffFormNo);
        ExpClaimLineAttend.Reset();
        ExpClaimLineAttend.SetRange("EXP Form No.", g_StaffFormNo);
        ExpClaimLineAttend.SetRange("Line No.", g_LineNo);
        if ExpClaimLineAttend.FindSet()then repeat StaffExpenseClaimfromHeade.Get(g_StaffFormNo);
                ExpClaimLine.get(g_StaffFormNo, g_LineNo);
                ExpClaimLineAttend2.Reset();
                ExpClaimLineAttend2.SetRange("EXP Form No.", ExpClaimLineAttend."EXP Form No.");
                ExpClaimLineAttend2.SetFilter("Line No.", '<>%1', ExpClaimLineAttend."Line No.");
                ExpClaimLineAttend2.SetRange("Document Date", ExpClaimLine."Invoice Date");
                ExpClaimLineAttend2.SetRange(Attendees, ExpClaimLineAttend.Attendees);
                if ExpClaimLineAttend2.FindFirst()then ERROR('%1 has selected this staff %2 in form no %3.', StaffExpenseClaimfromHeade."Created User", ExpClaimLineAttend2."Attendee Name", StaffExpenseClaimfromHeade."EXP Form No.");
            until ExpClaimLineAttend.Next() = 0;
        ExpClaimLineAttend.Reset();
        ExpClaimLineAttend.SetRange("EXP Form No.", g_StaffFormNo);
        ExpClaimLineAttend.SetRange("Line No.", g_LineNo);
        if ExpClaimLineAttend.FindSet()then repeat ExpClaimLine.get(g_StaffFormNo, g_LineNo);
                ExpClaimLineAttend2.Reset();
                ExpClaimLineAttend2.SetFilter("EXP Form No.", '<>%1', ExpClaimLineAttend."EXP Form No.");
                ExpClaimLineAttend2.SetRange("Document Date", ExpClaimLine."Invoice Date");
                ExpClaimLineAttend2.SetRange(Attendees, ExpClaimLineAttend.Attendees);
                if ExpClaimLineAttend2.FindFirst()then begin
                    StaffExpenseClaimfromHeade.Get(ExpClaimLineAttend2."EXP Form No.");
                    ERROR('%1 has selected this staff %2 form no %3.', StaffExpenseClaimfromHeade."Created User", ExpClaimLineAttend2."Attendee Name", StaffExpenseClaimfromHeade."EXP Form No.");
                end;
            until ExpClaimLineAttend.Next() = 0;
    end;
    var g_StaffFormNo: Code[20];
    g_LineNo: Integer;
    procedure SetformNo(StaffformNo: Code[20]; LineNo: Integer)
    begin
        g_StaffFormNo:=StaffformNo;
        g_LineNo:=LineNo;
    end;
}
