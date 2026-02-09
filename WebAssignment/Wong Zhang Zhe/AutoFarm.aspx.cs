using System;
using System.Web.UI;

namespace AutoFarm
{
    public partial class Autofarm : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            [cite_start]// 只有注册会员或管理员可以查看 Hard 难度以上的完整内容或发表评论 [cite: 13, 66, 136]
            if (Session["UserID"] != null)
            {
                [cite_start] pnlFeedback.Visible = true; [cite: 19]
                lblLoginToComment.Visible = false;
            }
            else
            {
                [cite_start] pnlFeedback.Visible = false; [cite: 114]
                lblLoginToComment.Visible = true;
            }
        }
    }
}