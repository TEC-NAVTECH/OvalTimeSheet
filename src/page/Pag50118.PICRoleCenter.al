page 50118 "PIC Role Center"
{
    Caption = 'Project Manager', Comment = '{Dependency=Match,"ProfileDescription_PROJECTMANAGER"}';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control77; "Team Member Activities2")
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
    actions
    {
        area(Processing)
        {
            action(Resources)
            {
                ApplicationArea = All;
                RunObject = page "Resource List";
                Image = Resource;
            }
            action(Jobs)
            {
                ApplicationArea = All;
                RunObject = page "Job List";
                Image = Job;
            }
        }
    }
}
