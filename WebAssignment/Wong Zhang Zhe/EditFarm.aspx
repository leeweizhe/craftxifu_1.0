<%@ Page Title="Edit Farm" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditFarm.aspx.cs" Inherits="WebAssignment.EditFarm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .edit-container { width: 70%; margin: 40px auto; color: #fff; background: rgba(20,20,20,0.95); padding: 40px; border: 4px solid #68ff00; border-radius: 20px; }
        .form-group { margin-bottom: 25px; }
        .label-text { display: block; color: #68ff00; font-family: 'Minecraft', sans-serif; margin-bottom: 10px; text-transform: uppercase; }
        .pixel-input { width: 100%; background: #000; border: 2px solid #444; color: #fff; padding: 12px; font-family: 'Minecraft', sans-serif; box-sizing: border-box; }
        .pixel-input:focus { border-color: #68ff00; outline: none; }
        .btn-group { display: flex; gap: 20px; margin-top: 30px; }
        .btn-save { background: #68ff00; color: #000; flex: 2; padding: 15px; border: none; font-weight: bold; cursor: pointer; }
        .btn-cancel { background: #444; color: #fff; flex: 1; padding: 15px; border: none; cursor: pointer; text-align: center; text-decoration: none; }
        .preview-img { max-width: 200px; border: 2px solid #333; margin-top: 10px; display: block; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="edit-container">
        <h1 style="color: #68ff00; border-bottom: 2px solid #68ff00; padding-bottom: 10px;">[ EDIT FARM DATA ]</h1>
        
        <asp:Label ID="lblMsg" runat="server" ForeColor="Red" />

        <div class="form-group">
            <span class="label-text">Farm Title</span>
            <asp:TextBox ID="txtTitle" runat="server" CssClass="pixel-input" placeholder="e.g. Enderman XP Farm" />
        </div>

        <div class="form-group">
            <span class="label-text">Efficiency Rank</span>
            <asp:DropDownList ID="ddlEfficiency" runat="server" CssClass="pixel-input">
                <asp:ListItem Text="S - High Efficiency" Value="S" />
                <asp:ListItem Text="A - Moderate" Value="A" />
                <asp:ListItem Text="B - Basic" Value="B" />
            </asp:DropDownList>
        </div>

        <div class="form-group">
            <span class="label-text">Short Description</span>
            <asp:TextBox ID="txtDesc" runat="server" CssClass="pixel-input" TextMode="MultiLine" Rows="2" />
        </div>

        <div class="form-group">
            <span class="label-text">Detailed Tutorial Content (HTML Allowed)</span>
            <asp:TextBox ID="txtFullContent" runat="server" CssClass="pixel-input" TextMode="MultiLine" Rows="8" />
        </div>

        <div class="form-group">
            <span class="label-text">Main Display Image</span>
            <asp:FileUpload ID="fuDetailImg" runat="server" CssClass="pixel-input" />
            <asp:Image ID="imgPreviewDetail" runat="server" CssClass="preview-img" />
        </div>

        <div class="form-group">
            <span class="label-text">Material List Image</span>
            <asp:FileUpload ID="fuMatImg" runat="server" CssClass="pixel-input" />
            <asp:Image ID="imgPreviewMat" runat="server" CssClass="preview-img" />
        </div>

        <div class="form-group">
            <span class="label-text">YouTube Video URL</span>
            <asp:TextBox ID="txtVideoUrl" runat="server" CssClass="pixel-input" placeholder="https://www.youtube.com/watch?v=..." />
        </div>

        <div class="btn-group">
            <asp:Button ID="btnUpdate" runat="server" Text="UPDATE FARM DATABASE" CssClass="btn-save" OnClick="btnUpdate_Click" />
            <a href="AutoFarm.aspx" class="btn-cancel">CANCEL</a>
        </div>
    </div>
</asp:Content>