table 50132 "Staff Expense Claim Line Atten"
{
    fields
    {
        field(1; "EXP Form No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Staff Expense Claim form Heade"."EXP Form No." where("EXP Form No."=field("EXP Form No."));
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Apply Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(18; Attendees; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Resource;

            trigger OnValidate()
            var
                ExpClaimAttndee: Record "Staff Expense Claim Line Atten";
                ExpClaimAttndee2: Record "Staff Expense Claim Line Atten";
                ExpClaimLine: Record "Staff Expense Claim form Line";
                DocDate: Date;
                Resource: Record Resource;
            begin
                if ExpClaimLine.Get("EXP Form No.", "Line No.")then begin
                    DocDate:=ExpClaimLine."Invoice Date";
                    "Document Date":=DocDate;
                end;
                if Resource.Get(Attendees)then "Attendee Name":=copystr(Resource.Name, 1, MaxStrLen("Attendee Name")) //
                else
                    "Attendee Name":='';
            end;
        }
        field(19; "Attendee Name"; Text[50])
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup (Resource.Name where ("No." = field (Attendees)));
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    keys
    {
        key(Key1; "EXP Form No.", "Line No.", Attendees)
        {
        }
    }
    fieldgroups
    {
    }
    trigger OnInsert()
    begin
        CheckStatusOpen();
        ;
    end;
    trigger OnModify()
    begin
        CheckStatusOpen();
        ;
    end;
    trigger OnDelete()
    begin
        CheckStatusOpen();
        ;
    end;
    trigger OnRename()
    begin
    end;
    var ExpClaimHeader: Record "Staff Expense Claim form Heade";
    Resource: Record Resource;
    procedure CheckStatusOpen()
    begin
        GetExpClaimHeader();
        ExpClaimHeader.TestField(Status, ExpClaimHeader.Status::Open);
    end;
    procedure GetExpClaimHeader()
    begin
        ExpClaimHeader.Get("EXP Form No.");
    end;
    procedure FindResource()
    begin
        Resource.SetRange("Time Sheet Owner User ID", UserId);
        if Resource.FindFirst()then;
    end;
}
