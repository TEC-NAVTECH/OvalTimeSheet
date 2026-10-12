codeunit 50122 "Extension_Management"
{
    trigger OnRun()
    begin
    end;
    [EventSubscriber(ObjectType::Page, page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', true, true)]
    local procedure SetExpenseClaimTable(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        //TimeSheetHeader: Record "Time Sheet Header";
        //RecJob: Record Job;
        FieldRef: FieldRef;
        RecNo: Code[20];
        LineNo: Integer;
    begin
        case RecRef.NUMBER of DATABASE::"Staff Expense Claim form Heade", DATABASE::"Staff Expense Claim form Line": begin
            FieldRef:=RecRef.FIELD(1);
            RecNo:=FieldRef.VALUE;
            DocumentAttachment.SETRANGE("No.", RecNo);
            FieldRef:=RecRef.FIELD(2);
            LineNo:=FieldRef.VALUE;
            DocumentAttachment.SETRANGE("Line No.", LineNo);
        //FlowFieldsEditable := FALSE;
        end;
        end;
    end;
    [EventSubscriber(ObjectType::Table, database::"Time Sheet Header", 'OnAfterValidateEvent', 'Resource No.', true, true)]
    local procedure OnafterValidateResourceTSHeader(var rec: Record "Time Sheet Header"; var xrec: Record "Time Sheet Header"; CurrFieldNo: Integer)
    var
        resourcevar: Record Resource;
    begin
        if resourcevar.get(rec."Resource No.")then begin
            // if (resourcevar.Blocked) or (resourcevar."Close Date" <= rec."Starting Date") then
            //     Error('You can not select blocked resource');
            if(resourcevar.Blocked)then Error('You can not select blocked resource');
            if(format(resourcevar."Close Date") <> '') and (resourcevar."Close Date" <= rec."Starting Date")then Error('You can not select blocked resource');
        end;
    end;
    [EventSubscriber(ObjectType::Table, database::Resource, 'OnAfterValidateEvent', 'Blocked', true, true)]
    local procedure OnafterValidateResourceBlocked(var rec: Record Resource; var xrec: Record Resource; CurrFieldNo: Integer)
    var
        resourcevar: Record Resource;
    begin
        if resourcevar.get(rec."No.")then if(resourcevar.Blocked)then resourcevar.TestField("Close Date");
    end;
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Time Sheet Approval Management", 'OnAfterSubmit', '', true, true)]
    local procedure OnAfterSubmit_TSMgmt(var TimeSheetLine: Record "Time Sheet Line")
    var
        Resourcevar: Record Resource;
        JobRec: Record Job;
        TimeSheetHeader: Record "Time Sheet Header";
    begin
        if JobRec.get(TimeSheetLine."Job No.")then if JobRec."Non-Project Task" then begin
                TimeSheetHeader.GET(TimeSheetLine."Time Sheet No.");
                Resourcevar.GET(TimeSheetHeader."Resource No.");
                resourcevar.TESTFIELD("Time Sheet Approver User ID");
                TimeSheetLine."Approver ID":=resourcevar."Time Sheet Approver User ID";
                TimeSheetLine.Modify();
            //message('%1...%2', TimeSheetLine."Approver ID", resourcevar."No.");
            end;
    end;
    var
}
