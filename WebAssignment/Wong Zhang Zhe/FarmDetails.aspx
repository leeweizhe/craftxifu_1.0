<%@ Page Title="Farm Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="FarmDetails.aspx.cs" Inherits="WebAssignment.FarmDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .detail-container { width: 85%; margin: 30px auto; color: #fff; background: rgba(0,0,0,0.92); padding: 40px; border: 4px solid #444; }
        .back-link { color: #68ff00; text-decoration: none; font-weight: bold; margin-bottom: 25px; display: inline-block; }
        .farm-header { border-bottom: 3px solid #68ff00; padding-bottom: 15px; margin-bottom: 30px; }
        .efficiency-badge { background: #fbbf24; color: #000; padding: 5px 15px; font-weight: bold; float: right; }
        
        /* 图片通用样式 */
        .pixel-img { width: 100%; border: 4px solid #68ff00; margin-bottom: 30px; image-rendering: pixelated; object-fit: cover; }
        .mat-img { max-width: 600px; border: 2px dashed #fbbf24; display: block; margin: 0 auto; }
        
        /* 视频容器 */
        .video-wrapper { position: relative; padding-bottom: 56.25%; height: 0; margin: 20px 0; border: 3px solid #333; background: #000; }
        .video-wrapper iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        
        .content-box { line-height: 1.8; font-size: 1.1rem; color: #ddd; background: #1a1a1a; padding: 25px; border: 1px solid #333; }
        .section-label { color: #68ff00; text-transform: uppercase; margin-top: 40px; display: block; font-size: 1.4rem; border-left: 5px solid #68ff00; padding-left: 15px; margin-bottom: 15px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="detail-container">
        <a href="AutoFarm.aspx" class="back-link"><< BACK TO DATABASE</a>
        
        <div class="farm-header">
            <span class="efficiency-badge">RANK: <asp:Label ID="lblEfficiency" runat="server" /></span>
            <h1 style="font-size: 2.8rem; color: #68ff00; margin: 0;"><asp:Label ID="lblTitle" runat="server" /></h1>
        </div>

        <p style="font-size: 1.4rem; color: #fbbf24; margin-bottom: 30px;"><asp:Label ID="lblDesc" runat="server" /></p>

        <%-- 1. 预览大图 --%>
        <span class="section-label">Gallery / Preview</span>
        <asp:Image ID="imgFarmDisplay" runat="server" CssClass="pixel-img" />

        <%-- 2. 视频教程 --%>
        <asp:Panel ID="videoPanel" runat="server" Visible="false">
            <span class="section-label">Video Tutorial</span>
            <div class="video-wrapper">
                <iframe id="videoFrame" runat="server" frameborder="0" allowfullscreen></iframe>
            </div>
        </asp:Panel>

        <%-- 3. 材料清单 --%>
        <asp:Panel ID="materialPanel" runat="server" Visible="false">
            <span class="section-label">Required Materials</span>
            <div style="text-align:center; padding: 20px; background: rgba(0,0,0,0.5); margin-bottom: 30px;">
                <asp:Image ID="imgMaterial" runat="server" CssClass="mat-img" />
            </div>
        </asp:Panel>

        <%-- 4. 详细步骤 --%>
        <span class="section-label"> Description </span>
        <div class="content-box">
            <asp:Literal ID="litContent" runat="server" />
        </div>

        <%-- 5. 评论区 --%>
        <span class="section-label">Player Discussions</span>
        <div class="content-box">
            <%-- 评论列表 --%>
            <asp:Repeater ID="rptComments" runat="server">
                <ItemTemplate>
                    <div style="border-bottom: 1px dashed #333; padding: 15px 0; margin-bottom: 10px;">
                        <strong style="color: #68ff00;"><%# Eval("Username") %></strong> 
                        <span style="color: #666; font-size: 0.8rem;">- <%# Eval("CommentDate", "{0:yyyy-MM-dd HH:mm}") %></span>
                        <p style="margin-top: 8px; color: #ccc;"><%# Eval("CommentText") %></p>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <%-- 发表评论 (仅对 Member 可见) --%>
            <asp:Panel ID="pnlAddComment" runat="server" Visible="false" style="margin-top: 30px; border-top: 2px solid #333; padding-top: 20px;">
                <h4 style="color: #fbbf24; margin-bottom: 10px;">ADD YOUR THOUGHTS</h4>
                <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Rows="4" 
                    style="width: 100%; background: #000; color: #fff; border: 1px solid #68ff00; padding: 10px; font-family: 'Minecraft', sans-serif;" 
                    placeholder="Type your comment here..." />
                <br />
                <asp:Button ID="btnSubmitComment" runat="server" Text="[ POST COMMENT ]" 
                    OnClick="btnSubmitComment_Click" 
                    style="margin-top: 15px; background: #68ff00; color: #000; border: none; padding: 10px 25px; font-weight: bold; cursor: pointer;" />
            </asp:Panel>

            <%-- 对 Visitor 的提示 --%>
            <asp:Literal ID="litVisitorMsg" runat="server" />
        </div>
    </div>
</asp:Content>