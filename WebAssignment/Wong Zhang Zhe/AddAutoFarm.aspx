<%@ Page Title="Add New Auto Farm" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddAutoFarm.aspx.cs" Inherits="WebAssignment.AddAutoFarm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .add-container { width: 70%; margin: 30px auto; color: #fff; background: rgba(0,0,0,0.9); padding: 40px; border: 4px solid #68ff00; }
        .form-group { margin-bottom: 20px; }
        .label-text { color: #68ff00; display: block; margin-bottom: 8px; text-transform: uppercase; }
        .pixel-input { width: 100%; background: #000; color: #fff; border: 1px solid #444; padding: 10px; font-family: 'Minecraft', sans-serif; }
        .pixel-input:focus { border-color: #68ff00; outline: none; }
        .btn-submit { background: #68ff00; color: #000; font-weight: bold; padding: 15px 30px; border: none; cursor: pointer; }
        .btn-cancel { background: none; color: #ff4444; border: 1px solid #ff4444; padding: 15px 30px; cursor: pointer; text-decoration: none; margin-left: 10px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="add-container">
        <h1 style="color:#68ff00; border-bottom: 2px solid #68ff00; padding-bottom: 10px;">[ ADD NEW FARM DESIGN ]</h1>
        <asp:Label ID="lblMsg" runat="server" style="display:block; margin: 10px 0; font-weight:bold;" />

        <div class="form-group">
            <span class="label-text">Farm Title</span>
            <asp:TextBox ID="txtTitle" runat="server" CssClass="pixel-input" placeholder="e.g. Iron Golem Farm v2" required="required"></asp:TextBox>
        </div>

        <div class="form-group">
            <span class="label-text">Category</span>
            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="pixel-input">
                <asp:ListItem Value="Iron">Iron</asp:ListItem>
                <asp:ListItem Value="Gold">Gold</asp:ListItem>
                <asp:ListItem Value="XP">XP</asp:ListItem>
                <asp:ListItem Value="Food">Food</asp:ListItem>
                <asp:ListItem Value="Stone">Stone</asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="form-group">
            <span class="label-text">Efficiency Rank</span>
            <asp:TextBox ID="txtEfficiency" runat="server" CssClass="pixel-input" placeholder="e.g. S-Rank (400 items/hr)"></asp:TextBox>
        </div>

        <div class="form-group">
            <span class="label-text">Short Description</span>
            <asp:TextBox ID="txtDesc" runat="server" CssClass="pixel-input" TextMode="MultiLine" Rows="2"></asp:TextBox>
        </div>

        <div class="form-group">
            <span class="label-text">Thumbnail Image (Grid Preview)</span>
            <asp:FileUpload ID="fuThumbnail" runat="server" CssClass="pixel-input" />
        </div>

        <div class="form-group">
            <span class="label-text">Detailed Tutorial Image</span>
            <asp:FileUpload ID="fuDetailImg" runat="server" CssClass="pixel-input" />
        </div>

        <div class="form-group">
            <span class="label-text">YouTube Video URL (Optional)</span>
            <asp:TextBox ID="txtVideoUrl" runat="server" CssClass="pixel-input" placeholder="https://www.youtube.com/watch?v=..."></asp:TextBox>
        </div>

        <div class="form-group">
            <span class="label-text">Full Content / Guide Steps</span>
            <asp:TextBox ID="txtFullContent" runat="server" CssClass="pixel-input" TextMode="MultiLine" Rows="6"></asp:TextBox>
        </div>

        <div style="margin-top: 30px;">
            <asp:Button ID="btnSave" runat="server" Text="UPLOAD DESIGN" OnClick="btnSave_Click" CssClass="btn-submit" />
            <a href="AutoFarm.aspx" class="btn-cancel">[ CANCEL ]</a>
        </div>
    </div>
</asp:Content>