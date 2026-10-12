page 50154 "Document Attachment_Oval2"
{
    DelayedInsert = true;
    Editable = true;
    PageType = List;
    SourceTable = "Document Attachment";
    SourceTableView = sorting("Table ID", "No.", "Document Type", "Line No.", ID);
    ApplicationArea = All;
    UsageCategory = None; // 

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec."File Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the filename of the attachment.';

                    trigger OnDrillDown()
                    var
                        //TempBlob: Record TempBlob;
                        TempBlob: Codeunit "Temp Blob";
                        FileManagement: Codeunit "File Management";
                        FileName: Text;
                        _InStream: InStream; //
                    begin
                        if Rec."Document Reference ID".HASVALUE then Rec.Export(true)
                        else
                        begin
                            FileName:=FileManagement.BLOBImportWithFilter(TempBlob, ImportTxt, FileName, STRSUBSTNO(FileDialogTxt, FilterTxt), FilterTxt);
                            //FromRecRef.GETTABLE(50129);
                            CLEAR(FromRecRef);
                            FromRecRef.OPEN(50129);
                            TempBlob.CreateInStream(_InStream); //OP Upgrade Fixed
                            if FileName <> '' then DownloadFromStream(_InStream, '', '', '', FileName); //OP Upgrade Fixed
                            //SaveAttachment(FromRecRef, FileName, TempBlob);
                            FromRecRef.CLOSE();
                            CurrPage.UPDATE(false);
                        end;
                    end;
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the file extension of the attachment.';
                }
                field("File Name"; Rec."File Name")
                {
                    Caption = 'Description';
                }
                field("File Type"; Rec."File Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the type of document that the attachment is.';
                }
                field(User; Rec.User)
                {
                    ApplicationArea = All;
                    Caption = 'Created By User';
                    Editable = false;
                    ToolTip = 'Specifies the user who attached the document.';
                }
                field("Attached Date"; Rec."Attached Date")
                {
                    ApplicationArea = All;
                    Caption = 'Created Date Time';
                    ToolTip = 'Specifies the date when the document was attached.';
                }
                field("Line No."; Rec."Line No.")
                {
                    Caption = 'Exp Form Line No.';
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    Caption = 'Exp Form No.';
                    ApplicationArea = All;
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(Preview)
            {
                ApplicationArea = All;
                Caption = 'Preview';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'Get a preview of the attachment.';
                PromotedOnly = true; //

                trigger OnAction()
                begin
                    //IF "File Name" <> '' THEN
                    //  Export(TRUE);
                    if Rec."Document Reference ID".HASVALUE then Rec.Export(true);
                end;
            }
            action("Take Picture")
            {
                Image = Camera;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Repeater;
                Visible = CameraAvailable;
                ApplicationArea = All;
                PromotedOnly = true; //

                trigger OnAction()
                var
                    Camera: Codeunit Camera;
                    Ins: InStream;
                    FileName: Text;
                    MimeTypeTok: Label 'image/jpeg', Locked = true;
                    _cuFileManagement: Codeunit "File Management"; //
                begin
                    Rec.INIT();
                    Rec."Table ID":=50129;
                    Rec."Document Type":="Attachment Document Type".FromInteger(0); //changed from value 0
                    Rec."No.":=copystr(g_codDocNo, 1, MaxStrLen(Rec."No."));
                    Rec."Line No.":=g_intDocLine;
                    Rec.ID:=0;
                    Rec.TestField("No.");
                    if Camera.IsAvailable()then if Camera.GetPicture(Ins, FileName)then begin
                            Rec."Document Reference ID".ImportStream(Ins, FileName, MimeTypeTok);
                            Rec.Validate("File Name", CopyStr(_cuFileManagement.GetFileNameWithoutExtension(FileName), 1, MaxStrLen(Rec."File Name")));
                            Rec."File Type":=Rec."File Type"::Image;
                            Rec."File Extension":=_cuFileManagement.GetExtension(FileName);
                            Rec.Insert(true);
                            MESSAGE('%1', Rec."File Name");
                        end;
                    CurrPage.UPDATE(false);
                end;
            // trigger OnAction()
            // begin
            //     Camera.RequestPictureAsync;
            // end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."File Name":=SelectFileTxt;
    end;
    trigger OnOpenPage()
    var
        cuCamera: Codeunit Camera;
    begin
        CameraAvailable:=cuCamera.IsAvailable(); //
        // IF Camera.IsAvailable THEN BEGIN
        //     Camera := Camera.Create;
        //     CameraAvailable := TRUE;
        // END;
        //EVALUATE(g_intTableNo, GETFILTER("Table ID"));
        g_intTableNo:=50129;
        //IF g_intTableNo IN [DATABASE::"Transfer Line"] THEN BEGIN
        g_codDocNo:=Rec.GETFILTER("No.");
        EVALUATE(g_intDocLine, Rec.GETFILTER("Line No."));
    //END;
    end;
    var g_intTableNo: Integer;
    g_codDocNo: Text; //Code[20];
    g_intDocLine: Integer;
    // [RunOnClient]
    // [WithEvents]
    // Camera: DotNet CameraProvider;
    CameraAvailable: Boolean;
    ChangeFontSupportingCat: Boolean;
    FromRecRef: RecordRef;
    SalesDocumentFlow: Boolean;
    PurchaseDocumentFlow: Boolean;
    FlowFieldsEditable: Boolean;
    FileDialogTxt: Label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
    FilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
    ImportTxt: Label 'Attach a document.';
    SelectFileTxt: Label 'Select File...';
    FlowToPurchTxt: Label 'Flow to Purch. Trx';
    FlowToSalesTxt: Label 'Flow to Sales Trx';
    local procedure GetCaptionClass(FieldNo: Integer): Text begin
        if SalesDocumentFlow and PurchaseDocumentFlow then case FieldNo of 9: exit(FlowToPurchTxt);
            11: exit(FlowToSalesTxt);
            end;
    end;
    // [Scope('Personalization')]
    procedure OpenForRecRef(RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option Quote, "Order", Invoice, "Credit Memo", "Blanket Order", "Return Order";
        LineNo: Integer;
    begin
        Rec.RESET();
        FromRecRef:=RecRef;
        Rec.SETRANGE("Table ID", RecRef.NUMBER);
        if RecRef.NUMBER = DATABASE::Item then begin
            SalesDocumentFlow:=true;
            PurchaseDocumentFlow:=true;
        end;
        case RecRef.NUMBER of DATABASE::Customer, DATABASE::"Sales Header", DATABASE::"Sales Line", DATABASE::"Sales Invoice Header", DATABASE::"Sales Invoice Line", DATABASE::"Sales Cr.Memo Header", DATABASE::"Sales Cr.Memo Line": SalesDocumentFlow:=true;
        DATABASE::Vendor, DATABASE::"Purchase Header", DATABASE::"Purchase Line", DATABASE::"Purch. Inv. Header", DATABASE::"Purch. Inv. Line", DATABASE::"Purch. Cr. Memo Hdr.", DATABASE::"Purch. Cr. Memo Line": PurchaseDocumentFlow:=true;
        end;
        case RecRef.NUMBER of DATABASE::Customer, DATABASE::Vendor, DATABASE::Item, DATABASE::Employee, DATABASE::"Fixed Asset", DATABASE::Job, DATABASE::Resource: begin
            FieldRef:=RecRef.FIELD(1);
            RecNo:=FieldRef.VALUE;
            Rec.SETRANGE("No.", RecNo);
        end;
        end;
        case RecRef.NUMBER of DATABASE::"Sales Header", DATABASE::"Sales Line", DATABASE::"Purchase Header", DATABASE::"Purchase Line": begin
            FieldRef:=RecRef.FIELD(1);
            DocType:=FieldRef.VALUE;
            Rec.SETRANGE("Document Type", DocType);
            FieldRef:=RecRef.FIELD(3);
            RecNo:=FieldRef.VALUE;
            Rec.SETRANGE("No.", RecNo);
            FlowFieldsEditable:=false;
        end;
        end;
        case RecRef.NUMBER of DATABASE::"Sales Line", DATABASE::"Purchase Line": begin
            FieldRef:=RecRef.FIELD(4);
            LineNo:=FieldRef.VALUE;
            rec.SETRANGE("Line No.", LineNo);
        end;
        end;
        case RecRef.NUMBER of DATABASE::"Sales Invoice Header", DATABASE::"Sales Cr.Memo Header", DATABASE::"Purch. Inv. Header", DATABASE::"Purch. Cr. Memo Hdr.": begin
            FieldRef:=RecRef.FIELD(3);
            RecNo:=FieldRef.VALUE;
            Rec.SETRANGE("No.", RecNo);
            FlowFieldsEditable:=false;
        end;
        end;
        case RecRef.NUMBER of DATABASE::"Sales Invoice Line", DATABASE::"Sales Cr.Memo Line", DATABASE::"Purch. Inv. Line", DATABASE::"Purch. Cr. Memo Line": begin
            FieldRef:=RecRef.FIELD(3);
            RecNo:=FieldRef.VALUE;
            Rec.SETRANGE("No.", RecNo);
            FieldRef:=RecRef.FIELD(4);
            LineNo:=FieldRef.VALUE;
            Rec.SETRANGE("Line No.", LineNo);
            FlowFieldsEditable:=false;
        end;
        end;
        case RecRef.NUMBER of 50130, 50129: begin
            FieldRef:=RecRef.FIELD(1);
            RecNo:=FieldRef.VALUE;
            Rec.SETRANGE("No.", RecNo);
            FieldRef:=RecRef.FIELD(2);
            LineNo:=FieldRef.VALUE;
            Rec.SETRANGE("Line No.", LineNo);
        //FlowFieldsEditable := FALSE;
        end;
        end;
        OnAfterOpenForRecRef(Rec, RecRef);
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    begin
    end;
// trigger Camera::PictureAvailable(PictureName: Text; PictureFilePath: Text)
// var
//     File: File;
//     Instream: InStream;
//     DocumentAttachment: Record "Document Attachment";
//     LastID: Integer;
// begin
//     IF g_intTableNo = 50129 THEN BEGIN
//         //lrecPRLine.GET(g_codDocNo,g_intDocLine);
//         //Fn_ImportImagePRLine(lrecPRLine,PictureFilePath);
//         //  FileName := FileManagement.BLOBImportWithFilter(TempBlob,ImportTxt,FileName,STRSUBSTNO(FileDialogTxt,FilterTxt),FilterTxt);
//         IF PictureName <> '' THEN BEGIN
//             //CLEAR(Rec);
//             //SaveAttachment(FromRecRef,PictureName,TempBlob);
//             //Table ID,No.,Document Type,Line No.,ID  //PK
//             Rec.INIT();
//             Rec."Table ID" := 50129;
//             //"Table Name" := p_recPRLine.TABLENAME;
//             Rec."Document Type" := "Attachment Document Type".FromInteger(0);  //changed from value 0
//             Rec."No." := g_codDocNo;
//             Rec."Line No." := g_intDocLine;
//             Rec.ID := 0;
//             DocumentAttachment.RESET();
//             IF DocumentAttachment.FINDLAST() THEN
//                 LastID := DocumentAttachment.ID + 1;
//             File.OPEN(PictureFilePath);
//             File.CREATEINSTREAM(Instream);
//             Rec."File Name" := PictureName;
//             Rec."File Type" := Rec."File Type"::Image;
//             CLEAR(Rec."Document Reference ID");
//             Rec."Document Reference ID".IMPORTSTREAM(Instream, PictureName);
//             //IF NOT MODIFY(TRUE) THEN
//             MESSAGE('%1', Rec."File Name");
//             Rec.INSERT(TRUE);
//             //IF NOT INSERT(TRUE) THEN
//             //  MODIFY(TRUE);
//         END;
//     END;
//     CurrPage.UPDATE(FALSE);
// end;
}
