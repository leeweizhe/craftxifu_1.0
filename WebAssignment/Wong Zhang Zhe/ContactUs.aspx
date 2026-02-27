<%-- 1. 页面指令与母版页关联 --%>
<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>

<%-- 2. 导入命名空间 --%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<script runat="server">
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        // 模拟登录 ID 以便测试，实际应从 Session 获取
        if (Session["UserId"] == null)
        {
            Session["UserId"] = 5; 
        }

        int userId = Convert.ToInt32(Session["UserId"]);
        string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            // 将留言存入 contactTable [cite: 2026-02-09]
            string sql = "INSERT INTO contactTable (UserId, Subject, Message) VALUES (@uid, @sub, @msg)";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@uid", userId);
            cmd.Parameters.AddWithValue("@sub", ddlSubject.SelectedValue);
            cmd.Parameters.AddWithValue("@msg", txtMessage.Text);

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
        }

        // 提交成功反馈逻辑
        lblStatus.Text = "REQUEST SENT SUCCESSFULLY!";
        lblStatus.ForeColor = System.Drawing.Color.LimeGreen;
        formPanel.Visible = false; // 隐藏输入表单
        successPanel.Visible = true; // 显示成功面板
    }

    // 【核心修复】处理返回主页的跳转逻辑
    protected void btnBackHome_Click(object sender, EventArgs e)
    {
        // 使用绝对路径解决跨文件夹跳转 404 问题
        Response.Redirect("/Wong Zhang Zhe/Home.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .contact-box { background: rgba(0,0,0,0.9); border: 5px solid #464646; padding: 50px; width: 70%; margin: 40px auto; color: #FFF; box-shadow: 0 0 20px rgba(104, 255, 0, 0.3); }
        .label-text { color: #68ff00; font-size: 1.2rem; text-transform: uppercase; display: block; margin-bottom: 10px; }
        .pixel-input { width: 100%; background: #000; color: #fff; border: 1px solid #444; padding: 15px; font-size: 1.2rem; box-sizing: border-box; margin-bottom: 25px; }
        .pixel-input:focus { border-color: #68ff00; outline: none; }
        
        /* 按钮样式设计 */
        .btn-send { background: #68ff00; color: #000; font-weight: bold; padding: 15px 40px; border: none; cursor: pointer; font-size: 1.2rem; margin-right: 10px; }
        .btn-home { background: none; color: #999; font-weight: bold; padding: 15px 40px; border: 2px solid #444; cursor: pointer; font-size: 1.2rem; text-decoration: none; display: inline-block; }
        .btn-home:hover { color: #fff; border-color: #68ff00; }
        
        .success-box { text-align: center; padding: 40px; border: 2px dashed #68ff00; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="contact-box">
        <h2 style="color:#68ff00; font-size: 2.5rem; margin-bottom: 30px;">[ SERVER SUPPORT TICKET ]</h2>

        <%-- 输入表单面板 --%>
        <asp:Panel ID="formPanel" runat="server">
            <span class="label-text">Select Subject</span>
            <asp:DropDownList ID="ddlSubject" runat="server" CssClass="pixel-input">
                <asp:ListItem Value="Upgrade">Require Upgrade Account</asp:ListItem>
                <asp:ListItem Value="Account">Account Issue</asp:ListItem>
                <asp:ListItem Value="Feedback">Feedback / Suggestion</asp:ListItem>
                <asp:ListItem Value="Other">Other</asp:ListItem>
            </asp:DropDownList>

            <span class="label-text">Your Message</span>
            <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="6" CssClass="pixel-input" placeholder="Describe your request..."></asp:TextBox>

            <div style="margin-top: 10px;">
                <asp:Button ID="btnSubmit" runat="server" Text="SUBMIT TICKET" OnClick="btnSubmit_Click" CssClass="btn-send" />
                
                <%-- 修复：改为 OnClick 事件进行跳转 --%>
                <asp:Button ID="btnBackHome" runat="server" Text="[ RETURN TO HOME ]" OnClick="btnBackHome_Click" CssClass="btn-home" CausesValidation="false" />
            </div>
        </asp:Panel>

        <%-- 提交成功显示面板 --%>
        <asp:Panel ID="successPanel" runat="server" Visible="false" CssClass="success-box">
            <h3 style="color:#68ff00;">TICKET SUBMITTED!</h3>
            <p>Our admins will review your request shortly.</p>
            <br />
            <%-- 修复链接路径 --%>
            <asp:HyperLink ID="lnkHome" runat="server" NavigateUrl="/Wong Zhang Zhe/Home.aspx" style="color:#68ff00; text-decoration:none;">[ CLICK HERE TO GO HOME ]</asp:HyperLink>
        </asp:Panel>

        <asp:Label ID="lblStatus" runat="server" style="display:block; margin-top:20px; font-weight:bold;" />
    </div>
</asp:Content>