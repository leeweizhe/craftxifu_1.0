<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MobDetail.aspx.cs" Inherits="WebAssignment.Tong_Yu_Hong.aspx.MobDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        /* Main Container: align-items set to flex-start to align Name and Picture at the top */
        .detail-container { background-color: #1e1e1e; border-radius: 12px; padding: 60px; width: 90%; max-width: 1300px; margin: 40px auto; color: white; font-family: 'Minecraft', sans-serif; border: 4px solid #333; display: flex; gap: 60px; align-items: flex-start; }
        .detail-info { flex: 1.6; display: flex; flex-direction: column; gap: 35px; }
        
        /* New Wrapper: Creates space for the absolute button so it doesn't push the name down */
        .title-button-wrapper { position: relative; padding-top: 60px; width: 100%; }
        .detail-name { font-size: 4rem; color: #00b63b; text-shadow: 4px 4px 0px #000; margin: 0; }
        
        .detail-desc { font-size: 1.4rem; color: #aaa; font-style: italic; border-left: 5px solid #00b63b; padding-left: 25px; margin-bottom: 10px; }
        
        /* Content Sections */
        .content-section { display: flex; flex-direction: column; gap: 15px; }
        .detail-content { font-size: 1.15rem; line-height: 1.9; color: #eee; background: rgba(255,255,255,0.03); padding: 30px; border-radius: 10px; border: 1px solid rgba(255,255,255,0.1); }
        
        /* Guide Boxes */
        .guide-box { background: rgba(0, 182, 59, 0.03); border: 2px solid #00b63b; padding: 35px; border-radius: 12px; }
        .guide-title { font-size: 1.6rem; color: #00b63b; margin-bottom: 25px; display: block; text-transform: uppercase; text-shadow: 2px 2px 0px #000; }
        .guide-text { line-height: 2; color: #ddd; font-size: 1.1rem; }

        /* Right Column */
        .detail-right-column { flex: 1; display: flex; flex-direction: column; gap: 20px; }
        .detail-image-box { background-color: #d5d5d5; border: 6px solid #808080; border-radius: 12px; padding: 30px; display: flex; justify-content: center; align-items: center; min-height: 400px; }
        .detail-img { width: 100%; height: auto; object-fit: contain; image-rendering: pixelated; }
        
        /* Stats */
        .info-item { display: flex; flex-direction: column; gap: 10px; background: rgba(255, 255, 255, 0.07); padding: 20px; border-radius: 8px; border-left: 5px solid #00b63b; }
        .info-value { font-size: 1.1rem; color: #fff; line-height: 1.6; word-wrap: break-word; }
        .health-value { color: #ff5555; text-shadow: 0px 0px 8px rgba(255, 85, 85, 0.4); }

        /* Back Button: Positioned at the very top left of the wrapper */
        .btn-back { position: absolute; top: 0; left: 0; display: inline-block; padding: 10px 25px; background: #333; color: #fff; text-decoration: none; border-radius: 6px; border: 2px solid #00b63b; font-size: 0.9rem; transition: 0.3s; }
        .btn-back:hover { background: #444; border-color: #00ff55; box-shadow: 0 0 10px rgba(0, 182, 59, 0.5); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="detail-container">
        <div class="detail-info">
            <div class="title-button-wrapper">
                <a href="Mob.aspx" class="btn-back">← Back to Mobs</a>
                <asp:Label ID="lblMobName" runat="server" CssClass="detail-name" />
            </div>
            <asp:Label ID="lblDescription" runat="server" CssClass="detail-desc" />
            
            <div class="content-section">
                <span class="section-header">📜 General Information</span>
                <div class="detail-content">
                    <asp:Literal ID="litFullContent" runat="server" />
                </div>
            </div>

            <asp:Panel ID="pnlCombatGuide" runat="server">
                <div class="content-section">
                    <div class="guide-box">
                        <span class="guide-title">⚔️ Combat Guide: How to Defeat</span>
                        <div class="guide-text">
                            <asp:Literal ID="litHowToDefeat" runat="server" />
                        </div>
                    </div>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlPassiveGuide" runat="server" Visible="false">
                <div class="content-section">
                    <div class="guide-box" style="border-color: #00b63b; background: rgba(0, 182, 59, 0.05);">
                        <span class="guide-title" style="color: #00b63b;">🌿 Utility & Interaction Guide</span>
                        <div class="guide-text">
                            <asp:Literal ID="litPassiveGuide" runat="server" />
                        </div>
                    </div>
                </div>
            </asp:Panel>

            <div class="content-section" style="margin-top: 40px;">
                <span class="section-header">💬 Player Discussions</span>
                <div class="guide-box" style="border-color: #333; background: rgba(0,0,0,0.2);">
                    
                    <%-- Comment List --%>
                    <asp:Repeater ID="rptComments" runat="server">
                        <ItemTemplate>
                            <div style="border-bottom: 1px dashed #444; padding: 15px 0; margin-bottom: 10px;">
                                <strong style="color: #68ff00;"><%# Eval("Username") %></strong> 
                                <span style="color: #888; font-size: 0.8rem;">- <%# Eval("CommentDate", "{0:yyyy-MM-dd HH:mm}") %></span>
                                <p style="margin-top: 8px; color: #ddd; line-height: 1.4;"><%# Eval("CommentText") %></p>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <%-- Add Comment (Visible to Members/Admins) --%>
                    <asp:Panel ID="pnlAddComment" runat="server" Visible="false" style="margin-top: 20px;">
                        <h4 style="color: #fbbf24; margin-bottom: 10px; font-size: 1rem;">ADD YOUR THOUGHTS</h4>
                        <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Rows="4" 
                            style="width: 100%; background: #000; color: #fff; border: 1px solid #444; padding: 10px; font-family: 'Minecraft', sans-serif; resize: none;" 
                            placeholder="Share your tips about this mob..." />
                        <br />
                        <asp:Button ID="btnSubmitComment" runat="server" Text="[ POST COMMENT ]" 
                            OnClick="btnSubmitComment_Click" 
                            style="margin-top: 15px; background: #68ff00; color: #000; border: none; padding: 10px 25px; font-weight: bold; cursor: pointer; font-family: 'Minecraft', sans-serif;" />
                    </asp:Panel>

                    <%-- Visitor Message --%>
                    <asp:Literal ID="litVisitorMsg" runat="server" />
                </div>
            </div>
            </div>

        <div class="detail-right-column">
            <div class="detail-image-box">
                <asp:Image ID="imgMob" runat="server" CssClass="detail-img" />
            </div>
            
            <div class="info-item">
                <span class="info-label">Health</span>
                <span class="info-value">
                    <asp:Label ID="lblHealth" runat="server" CssClass="health-value" /> 
                    <span class="heart-icon"> (❤️</span> 
                    <span class="health-multiplier">
                        <asp:Literal ID="litHeartMultiplier" runat="server" />)
                    </span>
                </span>
            </div>
            <div class="info-item">
                <span class="info-label">Behavior</span>
                <span class="info-value"><asp:Label ID="lblCategory" runat="server" /></span>
            </div>
            <div class="info-item">
                <span class="info-label">Spawn</span>
                <span class="info-value"><asp:Label ID="lblSpawn" runat="server" /></span>
            </div>
            <div class="info-item">
                <span class="info-label">Drops</span>
                <span class="info-value"><asp:Label ID="lblDrops" runat="server" /></span>
            </div>
        </div>
    </div>
</asp:Content>
