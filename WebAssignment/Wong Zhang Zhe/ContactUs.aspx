<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ContactUs.aspx.cs" Inherits="WebAssignment.ContactUs" %>

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
        <h2 style="color:#68ff00; font-size: 2.5rem; margin-bottom: 30px;">[ CONTACT US ]</h2>

        <asp:Panel ID="formPanel" runat="server">
            <span class="label-text">Issue Category</span>
            <asp:DropDownList ID="ddlSubject" runat="server" CssClass="pixel-input">
                <asp:ListItem Value="Upgrade Account">Account Rank Upgrade</asp:ListItem>
                <asp:ListItem Value="Account Issue">Account Recovery</asp:ListItem>
                <asp:ListItem Value="Feedback/Suggestion">Bug Report / Suggestion</asp:ListItem>
                <asp:ListItem Value="Other">General Inquiry</asp:ListItem>
            </asp:DropDownList>

            <span class="label-text">Detailed Description</span>
            <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="6" CssClass="pixel-input" placeholder="Please provide details..."></asp:TextBox>

            <span class="label-text">Attachment (Photo, PDF, etc.)</span>
            <asp:FileUpload ID="fuAttachment" runat="server" CssClass="pixel-input" />
            <p style="color:#888; font-size:0.8rem; margin-top:-20px; margin-bottom:20px;">* Max 5MB (Optional)</p>

            <span class="label-text">Reference YouTube Link</span>
            <asp:TextBox ID="txtYoutubeLink" runat="server" CssClass="pixel-input" placeholder="https://www.youtube.com/watch?v=... (Optional)"></asp:TextBox>

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