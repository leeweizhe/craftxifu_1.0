<%-- 1. 页面指令与母版页关联 --%>
<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>

<%-- 2. 导入命名空间 --%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<script runat="server">
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        // 实际开发中，这里应直接使用 Session["UserId"]
        if (Session["UserId"] == null)
        {
            // 如果用户未登录，通常需要重定向到登录页，这里暂定为 ID 5 进行测试
            Session["UserId"] = 5; 
        }

        int userId = Convert.ToInt32(Session["UserId"]);
        string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            // 【核心修复】SQL 语句新增了 Status 字段，并设为 'Submitted'
            // 注意：AdminMessage 允许为 NULL，所以不需要在 INSERT 中体现
            string sql = "INSERT INTO contactTable (UserId, Subject, Message, Status) VALUES (@uid, @sub, @msg, @status)";
            SqlCommand cmd = new SqlCommand(sql, conn);
            
            cmd.Parameters.AddWithValue("@uid", userId);
            cmd.Parameters.AddWithValue("@sub", ddlSubject.SelectedValue);
            cmd.Parameters.AddWithValue("@msg", txtMessage.Text);
            cmd.Parameters.AddWithValue("@status", "Submitted"); // 初始状态设为 Submitted

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
        }

        // 提交成功反馈逻辑
        lblStatus.Text = "TICKET CREATED SUCCESSFULLY!";
        lblStatus.ForeColor = System.Drawing.Color.LimeGreen;
        formPanel.Visible = false; // 隐藏输入表单
        successPanel.Visible = true; // 显示成功面板
    }

    protected void btnBackHome_Click(object sender, EventArgs e)
    {
        Response.Redirect("/Wong Zhang Zhe/Home.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .contact-box { background: rgba(0,0,0,0.9); border: 5px solid #464646; padding: 50px; width: 70%; margin: 40px auto; color: #FFF; box-shadow: 0 0 20px rgba(104, 255, 0, 0.3); }
        .label-text { color: #68ff00; font-size: 1.2rem; text-transform: uppercase; display: block; margin-bottom: 10px; }
        .pixel-input { width: 100%; background: #000; color: #fff; border: 1px solid #444; padding: 15px; font-size: 1.2rem; box-sizing: border-box; margin-bottom: 25px; }
        .pixel-input:focus { border-color: #68ff00; outline: none; }
        
        .btn-send { background: #68ff00; color: #000; font-weight: bold; padding: 15px 40px; border: none; cursor: pointer; font-size: 1.2rem; margin-right: 10px; }
        .btn-home { background: none; color: #999; font-weight: bold; padding: 15px 40px; border: 2px solid #444; cursor: pointer; font-size: 1.2rem; text-decoration: none; display: inline-block; }
        .btn-home:hover { color: #fff; border-color: #68ff00; }
        
        .success-box { text-align: center; padding: 40px; border: 2px dashed #68ff00; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="contact-box">
        <h2 style="color:#68ff00; font-size: 2.5rem; margin-bottom: 30px;">[ CREATE SUPPORT TICKET ]</h2>

        <asp:Panel ID="formPanel" runat="server">
            <span class="label-text">Issue Category</span>
            <asp:DropDownList ID="ddlSubject" runat="server" CssClass="pixel-input">
                <asp:ListItem Value="Upgrade">Account Rank Upgrade</asp:ListItem>
                <asp:ListItem Value="Account">Account Recovery</asp:ListItem>
                <asp:ListItem Value="Feedback">Bug Report / Suggestion</asp:ListItem>
                <asp:ListItem Value="Other">General Inquiry</asp:ListItem>
            </asp:DropDownList>

            <span class="label-text">Detailed Description</span>
            <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="6" CssClass="pixel-input" placeholder="Please provide details..."></asp:TextBox>

            <div style="margin-top: 10px;">
                <asp:Button ID="btnSubmit" runat="server" Text="SUBMIT TICKET" OnClick="btnSubmit_Click" CssClass="btn-send" />
                <asp:Button ID="btnBackHome" runat="server" Text="[ CANCEL ]" OnClick="btnBackHome_Click" CssClass="btn-home" CausesValidation="false" />
            </div>
        </asp:Panel>

        <asp:Panel ID="successPanel" runat="server" Visible="false" CssClass="success-box">
            <h3 style="color:#68ff00;">TICKET #SUCCESSFULLY SENT!</h3>
            <p>Status: <b style="color:#fbbf24;">Submitted</b></p>
            <p>Our admin team will review it and reply within 24 hours.</p>
            <br />
            <asp:HyperLink ID="lnkHome" runat="server" NavigateUrl="/Wong Zhang Zhe/Home.aspx" style="color:#68ff00; text-decoration:none;">[ RETURN TO MAIN PAGE ]</asp:HyperLink>
        </asp:Panel>

        <asp:Label ID="lblStatus" runat="server" style="display:block; margin-top:20px; font-weight:bold;" />
    </div>
</asp:Content>