page 50119 "General Staff Role Center"
{
    Caption = 'Project Manager', Comment = '{Dependency=Match,"ProfileDescription_PROJECTMANAGER"}';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control77; "Team Member Activities3")
            {
                ApplicationArea = Suite;
            }
            systempart(Control1901377608; MyNotes)
            {
                ApplicationArea = Jobs;
                Visible = false;
            }
        }
    }
}
