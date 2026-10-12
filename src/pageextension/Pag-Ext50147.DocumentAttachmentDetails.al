pageextension 50147 "Document_AttachmentDetails" extends "Document Attachment Details"
{
    actions
    {
        addafter(Preview)
        {
            action("Take Picture")
            {
                ApplicationArea = All;
                Caption = 'Take';
                Image = Camera;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Activate the camera on the device.';
                Visible = CameraAvailable and (HideActions = false);

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
        // Add changes to page actions here
        }
    }
    trigger OnOpenPage()
    var
        Camera: Codeunit Camera;
    begin
        CameraAvailable:=Camera.IsAvailable();
        // if CameraAvailable then
        //     CameraProvider := CameraProvider.Create;
        EVALUATE(g_intTableNo, Rec.GETFILTER("Table ID"));
        if g_intTableNo in[DATABASE::"Staff Expense Claim form Line"]then begin
            g_codDocNo:=Rec.GETFILTER("No.");
            EVALUATE(g_intDocLine, Rec.GETFILTER("Line No."));
        end;
    end;
    var //CameraProvider: DotNet CameraProvider;
 CameraAvailable: Boolean;
    HideActions: Boolean;
    g_intTableNo: Integer;
    g_codDocNo: Text; //Code[20];
    g_intDocLine: Integer;
    // ExpClaimFormFline: Record "Staff Expense Claim form Line";
    // OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
    // DeleteImageQst: Label 'Are you sure you want to delete the picture?';
    // SelectPictureTxt: Label 'Select a picture to upload';
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
    //[Scope('Personalization')]
    // procedure IsCameraAvailable(): Boolean
    // begin
    //     exit(CameraProvider.IsAvailable);
    // end;
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
/*
        trigger CameraProvider::PictureAvailable(PictureName: Text; PictureFilePath: Text)
        var
            File: File;
            Instream: InStream;
        begin
            if (PictureName = '') or (PictureFilePath = '') then
                exit;

            if Rec.Picture.Count > 0 then
                if not Confirm(OverrideImageQst) then begin
                    if Erase(PictureFilePath) then;
                    exit;
                end;

            IF g_intTableNo = DATABASE::"Staff Expense Claim form Line" THEN BEGIN
                ExpClaimFormFline.GET(g_codDocNo, g_intDocLine);
                Fn_ImportImagePRLine(ExpClaimFormFline, PictureFilePath);
            END;

            File.Open(PictureFilePath);
            File.CreateInStream(Instream);

            Clear(Rec.Picture);
            Rec.Picture.ImportStream(Instream, PictureName);
            if not Rec.Modify(true) then
                Rec.Insert(true);

            File.Close;
            if Erase(PictureFilePath) then;
        end;
    */
}
