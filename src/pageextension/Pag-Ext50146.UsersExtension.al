pageextension 50146 "Users Extension" extends Users
{
    layout
    {
        modify("Authentication Email")
        {
            Visible = true;
        }
    }
    trigger OnAfterGetRecord()
    begin
    // >> Table 'User Group Member' is marked for removal. Reason: Replaced by the Security Group Member Buffer table and Security Group codeunit in the security groups system.. Tag: 22.0.
    // UserGroupMember.Reset();
    // UserGroupMember.SetRange("User Security ID", Rec."User Security ID");
    // if UserGroupMember.FindFirst() then
    //     UserGroupCode := UserGroupMember."User Group Code"
    // else
    //     UserGroupCode := '';
    // << Table 'User Group Member' is marked for removal. Reason: Replaced by the Security Group Member Buffer table and Security Group codeunit in the security groups system.. Tag: 22.0.
    end;
    var //UserGroupMember: Record "User Group Member";//Table 'User Group Member' is marked for removal. Reason: Replaced by the Security Group Member Buffer table and Security Group codeunit in the security groups system.. Tag: 22.0.
 UserGroupCode: Code[20];
}
