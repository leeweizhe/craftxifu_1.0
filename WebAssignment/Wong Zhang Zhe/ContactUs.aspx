<%@ Page Language="C#" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Contact Us - CraftXiFu</title>
    <link href="CSS/Style.css" rel="stylesheet" />
    <style>
        .contact-container {
            background: #C6C6C6;
            border: 5px solid #373737;
            padding: 30px;
            color: #373737;
            max-width: 600px;
            margin: 40px auto;
        }
        .info-box {
            background: #8B8B8B;
            border: 3px solid #555;
            padding: 15px;
            margin-bottom: 20px;
            color: white;
        }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 5px; }
        .mc-select { width: 100%; border: 2px solid #373737; padding: 8px; background: #EEE; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="contact-container">
                <h1 style="text-align:center;">Contact Admin </h1>
                
                <div class="info-box">
                    <p><strong>Note:</strong> Instructors who need an account must email the admin directly with their information. </p>
                </div>

                <div class="form-group">
                    <label>Issue Category:</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="mc-select">
                        <asp:ListItem Text="Wiki Errors " Value="WikiError" />
                        <asp:ListItem Text="Account Recovery " Value="Account" />
                        <asp:ListItem Text="Technical Problems " Value="Technical" />
                        <asp:ListItem Text="Report User Misbehavior " Value="Report" />
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <label>Your Email :</label>
                    <asp:TextBox ID="txtContactEmail" runat="server" CssClass="mc-input" Width="100%" placeholder="Enter your email..."></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Message :</label>
                    <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="5" CssClass="mc-input" Width="100%"></asp:TextBox>
                </div>

                <div style="text-align:center;">
                    <asp:Button ID="btnSubmitReport" runat="server" Text="Send Report " CssClass="mc-button" OnClientClick="alert('Report Sent Successfully!'); return false;" />
                </div>
            </div>

            <div style="text-align:center; margin-top: 20px;">
                <p>Or email us at: <a href="mailto:support@craftxifu.com" style="color:#3c8527">support@craftxifu.com</a></p>
            </div>
        </div>
    </form>
</body>
</html>