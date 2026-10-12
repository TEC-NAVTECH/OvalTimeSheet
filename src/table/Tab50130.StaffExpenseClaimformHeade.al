table 50130 "Staff Expense Claim form Heade"
{
    LookupPageId = "Staff Expense Claim List";
    DrillDownPageId = "Staff Expense Claim List";

    fields
    {
        field(1; "EXP Form No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Apply Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Staff No."; Code[20])
        {
            DataClassification = ToBeClassified;
            //Editable = false;
            TableRelation = Resource;

            trigger OnValidate();
            var
                l_recResource: Record Resource;
            begin
                l_recResource.Reset();
                l_recResource.SetRange("No.", Rec."Staff No.");
                if l_recResource.FindFirst() then BEGIN
                    l_recResource.CalcFields("Default Currency");
                    Rec."Currency Code" := l_recResource."Default Currency";
                END;
            end;
        }
        field(4; "Created User"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Total Amount (HKD)"; Decimal)
        {

            //DataClassification = ToBeClassified;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Staff Expense Claim form Line"."Amount (HKD)" where("EXP Form No." = field("EXP Form No.")));
        }
        field(6; "No. of Approved Lines"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Staff Expense Claim form Line" where("EXP Form No." = field("EXP Form No."), Status = filter(Approved)));
        }
        field(7; "No. of Lines"; Integer)
        {
            //DataClassification = ToBeClassified;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Staff Expense Claim form Line" where("EXP Form No." = field("EXP Form No.")));
        }
        field(8; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,"Pending Approval","Partial Approved",Approved,Rejected;
            //Editable = false;
        }
        field(9; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
            Editable = false;
        }
        field(10; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Invoice Created"; Boolean)
        {
            Editable = false;
        }
        field(12; "Invoice No."; Code[20])
        {
            Editable = false;
            TableRelation = "Purchase Header"."No." where("Document Type" = filter(Invoice));
        }
        field(13; "Staff Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(resource.Name where("No." = field("Staff No.")));
        }
        //TEC#002 <<
        field(14; "Time Sheet Approver ID"; Code[50])
        {
            FieldClass = Flowfield;
            CalcFormula = lookup(resource."Time Sheet Approver User ID" where("No." = field("Staff No.")));
        }
        //TEC#002 >>
        field(15; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; "Total Amount"; Decimal)
        {
            //DataClassification = ToBeClassified;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Staff Expense Claim form Line"."Staff currency amount" where("EXP Form No." = field("EXP Form No.")));
        }
    }
    keys
    {
        key(Key1; "EXP Form No.")
        {
        }
    }
    fieldgroups
    {
    }
    var
        Resource: Record Resource;

    trigger OnInsert()
    begin
        if "EXP Form No." = '' then begin
            TestNoSeries();
            //NoSeriesMgt.InitSeries(GetNoSeriesCode(), xRec."No. Series", Today, "EXP Form No.", "No. Series");
            // NoSeriesMgt.InitSeries(GetNoSeriesCode(), xRec."No. Series", Today, "EXP Form No.", "No. Series");
            "No. Series" := PurchasesPayablesSetup."Staff Expense Claim Nos";
            if NoSeriesMgt.AreRelated(PurchasesPayablesSetup."Staff Expense Claim Nos", xRec."No. Series") then "No. Series" := xRec."No. Series";
            "EXP Form No." := NoSeriesMgt.GetNextNo("No. Series");
        end;
        CheckStatusOpen();
        "Apply Date" := Today;
        "Created User" := copystr(USERID, 1, MaxStrLen("Created User")); //
        Resource.SetRange("Time Sheet Owner User ID", UserId);
        if Resource.FindFirst() then "Staff No." := Resource."No.";
    end;

    trigger OnModify()
    begin
        CheckStatusOpen();
    end;

    trigger OnDelete()
    var
        staffExpClaimLine: Record "Staff Expense Claim form Line";
        StaffClaimFormAttendee: Record "Staff Expense Claim Line Atten";
    begin
        CheckStatusOpen();
        staffExpClaimLine.SetRange("EXP Form No.", "EXP Form No.");
        if staffExpClaimLine.FindFirst() then staffExpClaimLine.deleteall();
        StaffClaimFormAttendee.SetRange("EXP Form No.", "EXP Form No.");
        if StaffClaimFormAttendee.FindFirst() then StaffClaimFormAttendee.deleteall();
    end;

    var //NoSeriesMgt: Codeunit NoSeriesManagement; SS Replaced by No. Series
        NoSeriesMgt: Codeunit "No. Series";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";

    local procedure TestNoSeries()
    begin
        PurchasesPayablesSetup.Get();
        PurchasesPayablesSetup.TestField("Staff Expense Claim Nos");
    end;

    local procedure GetNoSeriesCode(): Code[20]
    var
        _GetNoSeriesCode: Code[20];
    begin
        exit(PurchasesPayablesSetup."Staff Expense Claim Nos");
    end;

    procedure ApproveStaffExpense(var StaffExpenseClaimfromHeade: Record "Staff Expense Claim form Heade")
    begin
        if StaffExpenseClaimfromHeade.Status = StaffExpenseClaimfromHeade.Status::Approved then exit;
        StaffExpenseClaimfromHeade.Status := StaffExpenseClaimfromHeade.Status::Approved;
        StaffExpenseClaimfromHeade.Modify()
    end;

    procedure OpenStaffExpense(var StaffExpenseClaimfromHeade: Record "Staff Expense Claim form Heade")
    begin
        if StaffExpenseClaimfromHeade.Status = StaffExpenseClaimfromHeade.Status::Open then exit;
        StaffExpenseClaimfromHeade.Status := StaffExpenseClaimfromHeade.Status::Open;
        StaffExpenseClaimfromHeade.Modify();
    end;
    //TEC#002 <<
    procedure CheckStatusOpen()
    begin
        if Status in [Status::Open, Status::Rejected] then
            status := Status //
        else
            ERROR('Status must be Open');
    end;

    procedure StaffExpFilter(var StaffExpHeader: Record "Staff Expense Claim form Heade"; pStatus: Integer): Integer
    var
        _recResource: Record Resource; //
        ResourceFilterText: Text;
        UserSetup: Record "User Setup";
    begin
        //Open,"Pending Approval","Partial Approved",Approved,Rejected
        _recResource.reset();
        _recResource.SetRange("Time Sheet Owner User ID", UserId);
        if _recResource.FindSet() then
            repeat
                if ResourceFilterText = '' then
                    ResourceFilterText := _recResource."No."
                else
                    ResourceFilterText := ResourceFilterText + '|' + _recResource."No.";
            until _recResource.Next() = 0;
        UserSetup.get(UserId);
        case pStatus of
            0, 3, 4: //Open
                begin
                    StaffExpHeader.RESET();
                    StaffExpHeader.SETFILTER("Staff No.", ResourceFilterText);
                    StaffExpHeader.SETRANGE(Status, pStatus); //
                    if UserSetup."Staff Expense Form Admin" then StaffExpHeader.SetRange("Staff No.");
                    exit(StaffExpHeader.Count);
                end;
            1: //Pending Approval
                begin
                    StaffExpHeader.RESET();
                    StaffExpHeader.SETRANGE("Time Sheet Approver ID", USERID);
                    StaffExpHeader.SETRANGE(Status, pStatus); //
                    if UserSetup."Staff Expense Form Admin" then StaffExpHeader.SetRange("Time Sheet Approver ID");
                    if StaffExpHeader.FINDSET() then exit(StaffExpHeader.Count);
                end;
        end;
    end;
    //TEC#002 >>
}
