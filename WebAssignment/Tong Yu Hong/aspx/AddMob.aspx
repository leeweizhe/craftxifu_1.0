<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddMob.aspx.cs" Inherits="WebAssignment.Tong_Yu_Hong.aspx.AddMob" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .add-container { width: 70%; margin: 30px auto; color: #fff; background: rgba(0,0,0,0.9); padding: 40px; border: 4px solid #68ff00; font-family: 'Minecraft', sans-serif; }
        .form-group { margin-bottom: 20px; }
        .label-text { color: #68ff00; display: block; margin-bottom: 8px; text-transform: uppercase; font-size: 0.9rem; }
        .pixel-input { width: 100%; background: #000; color: #fff; border: 1px solid #444; padding: 12px; font-family: 'Minecraft', sans-serif; box-sizing: border-box; }
        .pixel-input:focus { border-color: #68ff00; outline: none; }
        .btn-submit { background: #68ff00; color: #000; font-weight: normal; padding: 15px 30px; border: none; cursor: pointer; font-family: 'Minecraft', sans-serif; text-transform: uppercase; }
        .btn-cancel { background: none; color: #ff4444; border: 1px solid #ff4444; padding: 15px 30px; cursor: pointer; text-decoration: none; margin-left: 10px; font-family: 'Minecraft', sans-serif; display: inline-block; }
        .btn-submit:hover { background: #56d400; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="add-container">
        <h1 style="color:#68ff00; border-bottom: 2px solid #68ff00; padding-bottom: 10px; text-transform: uppercase;">[ Register New Mob Entry ]</h1>
        <asp:Label ID="lblMsg" runat="server" style="display:block; margin: 10px 0; color: #ffcc00;" />

        <div class="form-group">
            <span class="label-text">Mob Name</span>
            <asp:TextBox ID="txtMobName" runat="server" CssClass="pixel-input" placeholder="e.g. Ender Dragon" required="required"></asp:TextBox>
        </div>

        <div style="display: flex; gap: 20px;">
            <div class="form-group" style="flex: 1;">
                <span class="label-text">Behavior Category</span>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="pixel-input">
                    <asp:ListItem Value="Hostile">Hostile</asp:ListItem>
                    <asp:ListItem Value="Neutral">Neutral</asp:ListItem>
                    <asp:ListItem Value="Passive">Passive</asp:ListItem>
                    <asp:ListItem Value="Boss">Boss</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="form-group" style="flex: 1;">
                <span class="label-text">Health Points</span>
                <asp:TextBox ID="txtHealth" runat="server" CssClass="pixel-input" placeholder="e.g. 20 (10 hearts)"></asp:TextBox>
            </div>
        </div>

        <div class="form-group">
            <span class="label-text">Short Description (Hover Info)</span>
            <asp:TextBox ID="txtDescription" runat="server" CssClass="pixel-input" TextMode="MultiLine" Rows="2" placeholder="Brief overview of the mob..."></asp:TextBox>
        </div>

        <div class="form-group">
            <span class="label-text">Spawn Conditions</span>
            <asp:TextBox ID="txtSpawn" runat="server" CssClass="pixel-input" placeholder="e.g. Light level 0 in Overworld"></asp:TextBox>
        </div>

        <div class="form-group">
            <span class="label-text">Item Drops</span>
            <asp:TextBox ID="txtDrops" runat="server" CssClass="pixel-input" placeholder="e.g. Rotten Flesh, Carrot (Rare)"></asp:TextBox>
        </div>

        <div class="form-group">
            <span class="label-text">Mob Image Upload</span>
            <asp:FileUpload ID="fuMobPicture" runat="server" CssClass="pixel-input" />
        </div>

        <div class="form-group">
            <span class="label-text">Combat Guide: How to Defeat</span>
            <asp:TextBox ID="txtHowToDefeat" runat="server" CssClass="pixel-input" TextMode="MultiLine" Rows="4" placeholder="Best strategies to slay this mob..."></asp:TextBox>
        </div>

        <div class="form-group">
            <span class="label-text">Full Content / Encyclopedia Details</span>
            <asp:TextBox ID="txtFullContent" runat="server" CssClass="pixel-input" TextMode="MultiLine" Rows="8" placeholder="Detailed lore and mechanics..."></asp:TextBox>
        </div>

        <div style="margin-top: 30px; border-top: 1px solid #333; padding-top: 20px;">
            <asp:Button ID="btnSave" runat="server" Text="Save Mob to Database" OnClick="btnSave_Click" CssClass="btn-submit" />
            <a href="Mob.aspx" class="btn-cancel">[ CANCEL ]</a>
        </div>
    </div>
</asp:Content>
