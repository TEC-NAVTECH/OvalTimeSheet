page 50139 "Document Attachment Details2"
{
    Caption = 'Attached Documents';
    DelayedInsert = true;
    Editable = true;
    PageType = List;
    SourceTable = "Document Attachment";
    SourceTableView = sorting(ID, "Table ID");
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
                        _InStream: InStream;
                    begin
                        if Rec."Document Reference ID".HasValue then Rec.Export(true)
                        else
                        begin
                            FileName:=FileManagement.BLOBImportWithFilter(TempBlob, ImportTxt, FileName, StrSubstNo(FileDialogTxt, FilterTxt), FilterTxt);
                            TempBlob.CreateInStream(_InStream); //OP Upgrade Fixed
                            if FileName <> '' then DownloadFromStream(_InStream, '', '', '', FileName); //OP Upgrade Fixed
                            // SaveAttachment(FromRecRef, FileName, TempBlob);
                            CurrPage.Update(false);
                        end;
                    end;
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the file extension of the attachment.';
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
                    Editable = false;
                    ToolTip = 'Specifies the user who attached the document.';
                }
                field("Attached Date"; Rec."Attached Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the document was attached.';
                }
                field("Document Flow Purchase"; Rec."Document Flow Purchase")
                {
                    ApplicationArea = All;
                    CaptionClass = GetCaptionClass(9);
                    Editable = FlowFieldsEditable;
                    ToolTip = 'Specifies if the attachment must flow to transactions.';
                    Visible = PurchaseDocumentFlow;
                }
                field("Document Flow Sales"; Rec."Document Flow Sales")
                {
                    ApplicationArea = All;
                    CaptionClass = GetCaptionClass(11);
                    Editable = FlowFieldsEditable;
                    ToolTip = 'Specifies if the attachment must flow to transactions.';
                    Visible = SalesDocumentFlow;
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
                    if Rec."File Name" <> '' then Rec.Export(true);
                end;
            }
            action("Take Picture")
            {
                ApplicationArea = All;
                Caption = 'Take';
                Image = Camera;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'Activate the camera on the device.';
                Visible = CameraAvailable;
                PromotedOnly = true; //

                trigger OnAction()
                var
                    Camera: Codeunit Camera;
                    Ins: InStream;
                    FileName: Text;
                    _Found: Boolean;
                begin
                    _Found:=false;
                    if not IsNullGuid(Rec.SystemId)then begin
                        Rec.Find();
                        Rec.TestField("No.");
                        _Found:=true;
                    end;
                    if Camera.IsAvailable()then if Camera.GetPicture(Ins, FileName)then begin
                            if _Found then Rec.FindLast();
                            Rec.Init();
                            Rec.ID:=Rec.ID + 1;
                            Rec.SaveAttachmentFromStream(Ins, FromRecRef, FileName);
                        end end;
            // trigger OnAction()
            // begin
            //     TakeNewPicture;
            // end;
            }
        }
    }
    trigger OnInit()
    begin
        FlowFieldsEditable:=true;
    end;
    trigger OnOpenPage()
    var
        //CameraProvider: DotNet CameraProvider;
        cuCamera: Codeunit Camera;
    begin
        CameraAvailable:=cuCamera.IsAvailable();
        // CameraAvailable := true;
        //Message('%1', CameraProvider.IsAvailable);
        // if CameraProvider.IsAvailable then begin
        //     CameraAvailable := true;
        //     CameraProvider := CameraProvider.Create;
        // end;
        EVALUATE(g_intTableNo, Rec.GETFILTER("Table ID"));
        if g_intTableNo in[DATABASE::"Staff Expense Claim form Line"]then begin
            g_codDocNo:=Rec.GETFILTER("No.");
            EVALUATE(g_intDocLine, Rec.GETFILTER("Line No."));
        end;
    end;
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."File Name":=SelectFileTxt;
    end;
    var // [RunOnClient]
 // [WithEvents]
    // CameraProvider: DotNet CameraProvider;
    // CameraOptions: DotNet CameraOptions;
    CameraAvailable: Boolean;
    HideActions: Boolean;
    g_intTableNo: Integer;
    g_codDocNo: Text; // code[20];
    g_intDocLine: Integer;
    FromRecRef: RecordRef;
    SalesDocumentFlow: Boolean;
    ExpClaimFormFline: Record "Staff Expense Claim form Line";
    FileDialogTxt: Label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
    FilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
    ImportTxt: Label 'Attach a document.';
    SelectFileTxt: Label 'Select File...';
    PurchaseDocumentFlow: Boolean;
    FlowToPurchTxt: Label 'Flow to Purch. Trx';
    FlowToSalesTxt: Label 'Flow to Sales Trx';
    FlowFieldsEditable: Boolean;
    DocumentAttach: Record "Document Attachment";
    OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
    DeleteImageQst: Label 'Are you sure you want to delete the picture?';
    // procedure TakeNewPicture()
    // var
    //     CameraOptions: DotNet CameraOptions;
    // begin
    //     Rec.Find;
    //     Rec.TestField("No.");
    //     //TestField(Description);
    //     if not CameraAvailable then
    //         exit;
    //     CameraOptions := CameraOptions.CameraOptions;
    //     CameraOptions.Quality := 50;
    //     CameraProvider.RequestPictureAsync(CameraOptions);
    // end;
    // procedure IsCameraAvailable(): Boolean
    // begin
    //     exit(CameraProvider.IsAvailable);
    // end;
    local procedure GetCaptionClass(FieldNo: Integer): Text begin
        if SalesDocumentFlow and PurchaseDocumentFlow then case FieldNo of 9: exit(FlowToPurchTxt);
            11: exit(FlowToSalesTxt);
            end;
    end;
    procedure Fn_ImportImagePRLine(ExpclaimformLine2: Record "Staff Expense Claim form Line"; p_ImagePath: Text)
    var
        l_recDocAttach: Record "Document Attachment";
        l_intEntryNo: Integer;
    begin
        l_intEntryNo:=1;
        if l_recDocAttach.FINDLAST()then l_intEntryNo:=l_recDocAttach.ID + 1;
        Rec.INIT();
        Rec.ID:=l_intEntryNo;
        Rec."Table ID":=DATABASE::"Staff Expense Claim form Line";
        //"Table Name" := ExpclaimformLine2.TABLENAME;
        Rec."No.":=ExpclaimformLine2."EXP Form No.";
        Rec."Line No.":=ExpclaimformLine2."Line No.";
        if not Rec.INSERT(true)then Rec.Modify(true);
    //IF Attachment.ImportAttachmentFromServerFile(p_ImagePath,FALSE,FALSE) THEN BEGIN
    //MESSAGE(p_ImagePath);
    //#001 <<
    end;
    //    [Scope('Personalization')]
    procedure OpenForRecRef(RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option Quote, "Order", Invoice, "Credit Memo", "Blanket Order", "Return Order";
        LineNo: Integer;
    begin
        Rec.Reset();
        FromRecRef:=RecRef;
        Rec.SetRange("Table ID", RecRef.Number);
        if RecRef.Number = DATABASE::Item then begin
            SalesDocumentFlow:=true;
            PurchaseDocumentFlow:=true;
        end;
        case RecRef.Number of DATABASE::Customer, DATABASE::"Sales Header", DATABASE::"Sales Line", DATABASE::"Sales Invoice Header", DATABASE::"Sales Invoice Line", DATABASE::"Sales Cr.Memo Header", DATABASE::"Sales Cr.Memo Line": SalesDocumentFlow:=true;
        DATABASE::Vendor, DATABASE::"Purchase Header", DATABASE::"Purchase Line", DATABASE::"Purch. Inv. Header", DATABASE::"Purch. Inv. Line", DATABASE::"Purch. Cr. Memo Hdr.", DATABASE::"Purch. Cr. Memo Line": PurchaseDocumentFlow:=true;
        end;
        case RecRef.Number of DATABASE::Customer, DATABASE::Vendor, DATABASE::Item, DATABASE::Employee, DATABASE::"Fixed Asset", DATABASE::Job, DATABASE::Resource: begin
            FieldRef:=RecRef.Field(1);
            RecNo:=FieldRef.Value;
            Rec.SetRange("No.", RecNo);
        end;
        end;
        case RecRef.Number of DATABASE::"Sales Header", DATABASE::"Sales Line", DATABASE::"Purchase Header", DATABASE::"Purchase Line": begin
            FieldRef:=RecRef.Field(1);
            DocType:=FieldRef.Value;
            Rec.SetRange("Document Type", DocType);
            FieldRef:=RecRef.Field(3);
            RecNo:=FieldRef.Value;
            Rec.SetRange("No.", RecNo);
            FlowFieldsEditable:=false;
        end;
        end;
        case RecRef.Number of DATABASE::"Sales Line", DATABASE::"Purchase Line": begin
            FieldRef:=RecRef.Field(4);
            LineNo:=FieldRef.Value;
            Rec.SetRange("Line No.", LineNo);
        end;
        end;
        case RecRef.Number of DATABASE::"Sales Invoice Header", DATABASE::"Sales Cr.Memo Header", DATABASE::"Purch. Inv. Header", DATABASE::"Purch. Cr. Memo Hdr.": begin
            FieldRef:=RecRef.Field(3);
            RecNo:=FieldRef.Value;
            Rec.SetRange("No.", RecNo);
            FlowFieldsEditable:=false;
        end;
        end;
        case RecRef.Number of DATABASE::"Sales Invoice Line", DATABASE::"Sales Cr.Memo Line", DATABASE::"Purch. Inv. Line", DATABASE::"Purch. Cr. Memo Line": begin
            FieldRef:=RecRef.Field(3);
            RecNo:=FieldRef.Value;
            Rec.SetRange("No.", RecNo);
            FieldRef:=RecRef.Field(4);
            LineNo:=FieldRef.Value;
            Rec.SetRange("Line No.", LineNo);
            FlowFieldsEditable:=false;
        end;
        end;
        //Expense Claim attachment
        case RecRef.Number of DATABASE::"Staff Expense Claim form Heade", DATABASE::"Staff Expense Claim form Line": begin
            FieldRef:=RecRef.Field(1);
            RecNo:=FieldRef.Value;
            Rec.SetRange("No.", RecNo);
            FieldRef:=RecRef.Field(2);
            LineNo:=FieldRef.Value;
            Rec.SetRange("Line No.", LineNo);
            FlowFieldsEditable:=false;
        end;
        end;
        OnAfterOpenForRecRef(Rec, RecRef);
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    begin
    end;
// trigger CameraProvider::PictureAvailable(PictureName: Text; PictureFilePath: Text)
// var
//     File: File;
//     Instream: InStream;
// begin
//     if (PictureName = '') or (PictureFilePath = '') then
//         exit;
//     if Rec.Picture.Count > 0 then
//         if not Confirm(OverrideImageQst) then begin
//             if Erase(PictureFilePath) then;
//             exit;
//         end;
//     IF g_intTableNo = DATABASE::"Staff Expense Claim form Line" THEN BEGIN
//         ExpClaimFormFline.GET(g_codDocNo, g_intDocLine);
//         Fn_ImportImagePRLine(ExpClaimFormFline, PictureFilePath);
//     END;
//     File.Open(PictureFilePath);
//     File.CreateInStream(Instream);
//     Clear(Rec.Picture);
//     Rec.Picture.ImportStream(Instream, PictureName);
//     if not Rec.Modify(true) then
//         Rec.Insert(true);
//     File.Close;
//     if Erase(PictureFilePath) then;
// end;
}
