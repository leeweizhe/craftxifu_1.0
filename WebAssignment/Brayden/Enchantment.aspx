<%@ Page Title="Enchantment Guide" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Enchantment.aspx.cs" Inherits="WebAssignment.Brayden.Enchantment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .enc-container { width: 95%; margin: 30px auto; color: #fff; }
        .page-title { font-size: 2.5rem; color: #9b59b6; text-transform: uppercase; border-bottom: 4px solid #9b59b6; padding-bottom: 10px; margin-bottom: 25px; }

        /* Layout */
        .guide-layout { display: grid; grid-template-columns: 190px 1fr; gap: 25px; }
        @media (max-width: 768px) { .guide-layout { grid-template-columns: 1fr; } .guide-sidebar { flex-direction: row; flex-wrap: wrap; } }

        /* Sidebar */
        .guide-sidebar { display: flex; flex-direction: column; gap: 6px; }
        .cat-btn { display: flex; align-items: center; gap: 10px; background: rgba(0,0,0,0.8); border: 2px solid #444; color: #aaa; padding: 12px 14px; cursor: pointer; text-decoration: none; font-family: inherit; font-size: 0.85rem; text-transform: uppercase; transition: 0.2s; }
        .cat-btn:hover { border-color: #9b59b6; color: #e0a0ff; }
        .cat-btn.active { border-color: #9b59b6; color: #e0a0ff; background: rgba(155,89,182,0.15); box-shadow: inset 3px 0 0 #9b59b6; }
        .cat-icon-sm { font-size: 1.2rem; }

        /* Frame */
        .guide-frame { background: rgba(0,0,0,0.85); border: 4px solid #9b59b6; border-radius: 8px; padding: 30px; margin-bottom: 25px; }

        /* Flip Card */
        .flip-card-wrap { perspective: 1200px; max-width: 520px; margin: 0 auto 20px; }
        .flip-card { width: 100%; height: 460px; position: relative; transform-style: preserve-3d; transition: transform 0.7s ease; cursor: pointer; }
        .flip-card.flipped { transform: rotateY(180deg); }
        .flip-face { position: absolute; width: 100%; height: 100%; backface-visibility: hidden; border: 3px solid #555; box-sizing: border-box; }
        .flip-front { background: linear-gradient(180deg, #1a1a2e, #0d0d0d); display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 25px; text-align: center; }
        .flip-front .card-img { width: 160px; height: 160px; object-fit: contain; image-rendering: pixelated; border: 3px solid #9b59b6; background: #000; padding: 8px; margin-bottom: 15px; }
        .flip-front .card-name { font-size: 1.7rem; color: #e0a0ff; margin-bottom: 6px; }
        .flip-front .card-sub { color: #9b59b6; font-size: 0.85rem; text-transform: uppercase; margin-bottom: 8px; }
        .flip-front .card-hint { color: #555; font-size: 0.8rem; margin-top: 12px; }
        .flip-back { background: #0d0d0d; transform: rotateY(180deg); padding: 20px 22px; overflow-y: auto; }
        .flip-back .back-title { font-size: 1.3rem; color: #e0a0ff; border-bottom: 2px solid #9b59b6; padding-bottom: 6px; margin-bottom: 12px; }
        .flip-back .back-lbl { color: #9b59b6; text-transform: uppercase; font-size: 0.7rem; margin: 12px 0 4px; display: block; }
        .flip-back .back-txt { color: #ccc; font-size: 0.9rem; line-height: 1.5; }
        .flip-back .meta-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-bottom: 12px; }
        .flip-back .meta-cell { background: #111; border: 1px solid #333; padding: 6px 10px; }
        .flip-back .meta-cell label { color: #666; font-size: 0.65rem; text-transform: uppercase; display: block; }
        .flip-back .meta-cell span { color: #fff; font-size: 0.85rem; }
        .flip-back .content-box { background: #111; border: 1px solid #333; padding: 12px; color: #ccc; line-height: 1.6; font-size: 0.85rem; max-height: 120px; overflow-y: auto; }
        .level-pip { background: #9b59b6; color: #fff; padding: 2px 8px; margin-right: 3px; font-size: 0.75rem; display: inline-block; }
        .back-actions { margin-top: 10px; padding-top: 8px; border-top: 1px solid #333; text-align: center; }

        /* Pagination */
        .pagination-bar { display: flex; flex-wrap: wrap; justify-content: center; gap: 8px; padding: 15px 0; border-top: 2px solid #333; }
        .pg-btn { background: none; border: none; padding: 0; cursor: pointer; position: relative; display: inline-block; text-decoration: none; }
        .pg-icon { width: 46px; height: 46px; object-fit: contain; image-rendering: pixelated; border: 2px solid #444; background: #111; padding: 3px; transition: 0.2s; display: block; }
        .pg-icon:hover { border-color: #9b59b6; transform: scale(1.12); }
        .pg-icon.active { border-color: #9b59b6; box-shadow: 0 0 10px rgba(155,89,182,0.5); }
        .pg-btn .pg-tip { display: none; position: absolute; bottom: -24px; left: 50%; transform: translateX(-50%); background: #9b59b6; color: #fff; padding: 2px 8px; font-size: 0.65rem; white-space: nowrap; z-index: 10; pointer-events: none; }
        .pg-btn:hover .pg-tip { display: block; }

        /* Comment */
        .comment-section { background: rgba(0,0,0,0.7); border: 3px solid #333; padding: 25px; }
        .comment-section h3 { color: #9b59b6; font-size: 1.3rem; margin-bottom: 15px; }

        /* Empty */
        .empty-state { text-align: center; padding: 80px 20px; color: #555; }
        .empty-state .empty-icon { font-size: 4rem; display: block; margin-bottom: 15px; }

        /* Buttons */
        .btn-edit { background: #2980b9; color: #fff; border: none; padding: 6px 16px; cursor: pointer; font-size: 0.85rem; margin-right: 8px; font-family: inherit; }
        .btn-delete { background: #c0392b; color: #fff; border: none; padding: 6px 16px; cursor: pointer; font-size: 0.85rem; font-family: inherit; }
        .btn-add { background: #27ae60; color: #fff; border: none; padding: 8px 16px; cursor: pointer; font-size: 0.85rem; font-family: inherit; }
        .btn-save { background: #27ae60; color: #fff; border: none; padding: 10px 25px; cursor: pointer; font-size: 1rem; font-family: inherit; }
        .btn-cancel { background: #555; color: #fff; border: none; padding: 10px 25px; cursor: pointer; font-size: 1rem; font-family: inherit; margin-left: 10px; }
        .back-btn { color: #f39c12; cursor: pointer; text-decoration: none; margin-bottom: 20px; display: inline-block; font-size: 1rem; }
        .back-btn:hover { color: #fbbf24; }

        /* Form */
        .form-panel { background: rgba(0,0,0,0.9); border: 4px solid #555; padding: 35px; max-width: 800px; margin: 0 auto; }
        .form-panel h2 { color: #9b59b6; font-size: 1.8rem; border-bottom: 2px solid #9b59b6; padding-bottom: 10px; margin-bottom: 25px; }
        .form-row { margin-bottom: 18px; }
        .form-row label { color: #aaa; font-size: 0.9rem; display: block; margin-bottom: 6px; text-transform: uppercase; }
        .form-input, .form-textarea, .form-select { width: 100%; background: #1a1a1a; border: 2px solid #555; color: #fff; padding: 10px; font-family: inherit; font-size: 0.95rem; box-sizing: border-box; }
        .form-textarea { height: 120px; resize: vertical; }
        .form-row-half { display: flex; gap: 20px; }
        .form-row-half .form-row { flex: 1; }
        .error-msg { color: #e74c3c; font-size: 0.9rem; margin-bottom: 15px; display: block; }
        .chk-row { display: flex; align-items: center; gap: 10px; color: #ccc; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="enc-container">

    <%-- ===== MAIN VIEW ===== --%>
    <asp:Panel ID="mainPanel" runat="server">
        <h1 class="page-title">&#10022; Enchantment Guide</h1>
        <p style="color:#aaa; margin-bottom:20px; font-size:0.95rem;">Master the art of enchanting. Select a category, then click the card to flip and reveal details.</p>

        <div class="guide-layout">
            <%-- SIDEBAR --%>
            <div class="guide-sidebar">
                <asp:Repeater ID="categoryRepeater" runat="server">
                    <ItemTemplate>
                        <asp:LinkButton runat="server"
                            CssClass='<%# "cat-btn" + ((WebAssignment.Brayden.Enchantment)Page).GetCategoryActiveClass(Eval("Category").ToString()) %>'
                            CommandArgument='<%# Eval("Category") %>' OnClick="SelectCategory">
                            <span class="cat-icon-sm"><%# ((WebAssignment.Brayden.Enchantment)Page).GetCategoryIcon(Eval("Category").ToString()) %></span>
                            <%# Eval("Category") %>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:Repeater>
                <div style="margin-top:12px;">
                    <asp:Button ID="btnAddNew" runat="server" CssClass="btn-add" Text="+ ADD" OnClick="ShowAddForm" Visible="false" style="width:100%;" />
                </div>
            </div>

            <%-- CENTER --%>
            <div>
                <asp:Panel ID="contentPanel" runat="server" Visible="false">
                    <div class="guide-frame">
                        <%-- Flip Card --%>
                        <div class="flip-card-wrap">
                            <div class="flip-card" id="flipCard" onclick="handleFlip(event)">
                                <div class="flip-face flip-front">
                                    <asp:Image ID="imgDetailLarge" runat="server" CssClass="card-img" onerror="this.style.display='none'" />
                                    <div class="card-name"><asp:Label ID="lblDetailName" runat="server" /></div>
                                    <div class="card-sub">
                                        <asp:Label ID="lblDetailCategory" runat="server" /> &bull;
                                        <asp:Label ID="lblDetailMaxLevel" runat="server" />
                                    </div>
                                    <div style="margin-top:6px;"><asp:Literal ID="litLevelPips" runat="server" /></div>
                                    <div class="card-hint">&#128260; Click to reveal details</div>
                                </div>
                                <div class="flip-face flip-back">
                                    <div class="back-title"><asp:Label ID="lblDetailName2" runat="server" /></div>
                                    <span class="back-lbl">Effect</span>
                                    <p class="back-txt"><asp:Label ID="lblDetailDesc" runat="server" /></p>
                                    <div class="meta-grid">
                                        <div class="meta-cell"><label>Applies To</label><span><asp:Label ID="lblDetailApplies" runat="server" /></span></div>
                                        <div class="meta-cell"><label>Conflicts</label><span><asp:Label ID="lblDetailConflicts" runat="server" /></span></div>
                                        <div class="meta-cell"><label>Treasure Only</label><span><asp:Label ID="lblDetailTreasure" runat="server" /></span></div>
                                        <div class="meta-cell"><label>Max Level</label><span><asp:Label ID="lblBackMaxLevel" runat="server" /></span></div>
                                    </div>
                                    <span class="back-lbl">Detailed Guide</span>
                                    <div class="content-box"><asp:Literal ID="litDetailContent" runat="server" /></div>
                                    <asp:Panel ID="pnlAdminActions" runat="server" Visible="false" CssClass="back-actions">
                                        <asp:Button ID="btnEditEnchant" runat="server" CssClass="btn-edit" Text="&#9998; EDIT" OnClick="ShowEditForm" />
                                        <asp:LinkButton ID="btnDeleteEnchant" runat="server" CssClass="btn-delete" Text="&#10006; DELETE"
                                            OnClick="DeleteEnchantment" OnClientClick="return confirm('Delete this enchantment?');" />
                                    </asp:Panel>
                                    <div style="color:#555; font-size:0.75rem; text-align:center; margin-top:8px;">&#128260; Click to flip back</div>
                                </div>
                            </div>
                        </div>

                        <%-- Pagination Icons --%>
                        <div class="pagination-bar">
                            <asp:Repeater ID="paginationRepeater" runat="server">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" CssClass="pg-btn"
                                        CommandArgument='<%# Eval("EnchantmentId") %>'
                                        OnClick="SelectPaginationItem">
                                        <img src='<%# ResolveUrl(Eval("Thumbnail").ToString()) %>'
                                             class='<%# "pg-icon" + ((WebAssignment.Brayden.Enchantment)Page).GetPaginationActiveClass(Eval("EnchantmentId")) %>'
                                             onerror="this.style.display='none'" alt='<%# Eval("Name") %>' />
                                        <span class="pg-tip"><%# Eval("Name") %></span>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>

                    <%-- Comment Section --%>
                    <div class="comment-section">
                        <h3>&#128172; COMMUNITY COMMENTS</h3>
                        <asp:Repeater ID="rptComments" runat="server">
                            <ItemTemplate>
                                <div style="border-bottom:1px dashed #444; padding:12px 0;">
                                    <span style="color:#9b59b6;"><%# Eval("Username") %></span>
                                    <span style="color:#888; font-size:0.8rem;">- <%# Eval("CommentDate", "{0:yyyy-MM-dd HH:mm}") %></span>
                                    <asp:LinkButton ID="lnkReport" runat="server"
                                        Text="[ REPORT ]"
                                        CommandArgument='<%# Eval("CommentId") + "|" + ((WebAssignment.Brayden.Enchantment)Page).CurrentEnchantId %>'
                                        OnCommand="lnkReport_Command"
                                        OnClientClick="return confirm('Report this comment?');"
                                        Visible='<%# Session["userId"] != null %>'
                                        style="color:#ff4444; font-size:0.7rem; text-decoration:none; float:right;" />
                                    <p style="margin-top:6px; color:#ddd; line-height:1.4;"><%# Eval("CommentText") %></p>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Panel ID="pnlAddComment" runat="server" Visible="false" style="margin-top:15px;">
                            <h4 style="color:#fbbf24; margin-bottom:8px; font-size:0.95rem;">ADD YOUR THOUGHTS</h4>
                            <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Rows="3"
                                style="width:100%; background:#000; color:#fff; border:1px solid #9b59b6; padding:10px; font-family:inherit; resize:none; box-sizing:border-box;"
                                placeholder="Share your experience with this enchantment..." />
                            <br />
                            <asp:Button ID="btnSubmitComment" runat="server" Text="[ POST COMMENT ]"
                                OnClick="btnSubmitComment_Click"
                                style="margin-top:10px; background:#9b59b6; color:#fff; border:none; padding:8px 20px; font-weight:bold; cursor:pointer; font-family:inherit;" />
                        </asp:Panel>
                        <asp:Literal ID="litVisitorMsg" runat="server" />
                    </div>
                </asp:Panel>

                <asp:Panel ID="emptyPanel" runat="server">
                    <div class="empty-state">
                        <span class="empty-icon">&#128214;</span>
                        <h2 style="color:#555; font-size:1.4rem;">Select a Category</h2>
                        <p style="color:#444;">Choose from the sidebar to explore enchantments</p>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </asp:Panel>

    <%-- EDIT PANEL --%>
    <asp:Panel ID="editPanel" runat="server" Visible="false">
        <asp:LinkButton runat="server" CssClass="back-btn" OnClick="BackToMain">&laquo; CANCEL &amp; BACK</asp:LinkButton>
        <div class="form-panel">
            <h2>&#9998; Edit Enchantment</h2>
            <asp:Label ID="lblEditError" runat="server" CssClass="error-msg" />
            <div class="form-row-half">
                <div class="form-row"><label>Name</label><asp:TextBox ID="txtEditName" runat="server" CssClass="form-input" /></div>
                <div class="form-row">
                    <label>Category</label>
                    <asp:DropDownList ID="ddlEditCategory" runat="server" CssClass="form-select">
                        <asp:ListItem>Sword</asp:ListItem><asp:ListItem>Armor</asp:ListItem><asp:ListItem>Tool</asp:ListItem>
                        <asp:ListItem>Bow</asp:ListItem><asp:ListItem>Crossbow</asp:ListItem><asp:ListItem>Trident</asp:ListItem>
                        <asp:ListItem>Fishing Rod</asp:ListItem><asp:ListItem>Other</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="form-row-half">
                <div class="form-row"><label>Max Level (1-5)</label><asp:TextBox ID="txtEditMaxLevel" runat="server" CssClass="form-input" /></div>
                <div class="form-row"><label>Thumbnail Path</label><asp:TextBox ID="txtEditThumbnail" runat="server" CssClass="form-input" /></div>
            </div>
            <div class="form-row"><label>Detail Image Path</label><asp:TextBox ID="txtEditDetailImage" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Short Description</label><asp:TextBox ID="txtEditDesc" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Applies To</label><asp:TextBox ID="txtEditApplies" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Conflicts With</label><asp:TextBox ID="txtEditConflicts" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Detailed Content</label><asp:TextBox ID="txtEditContent" runat="server" CssClass="form-textarea" TextMode="MultiLine" /></div>
            <div class="form-row chk-row">
                <asp:CheckBox ID="chkEditTreasure" runat="server" />
                <label style="margin:0;">Treasure Only</label>
            </div>
            <div style="margin-top:20px;">
                <asp:Button runat="server" CssClass="btn-save" Text="SAVE CHANGES" OnClick="SaveEdit" />
                <asp:Button runat="server" CssClass="btn-cancel" Text="CANCEL" OnClick="BackToMain" />
            </div>
        </div>
    </asp:Panel>

    <%-- ADD PANEL --%>
    <asp:Panel ID="addPanel" runat="server" Visible="false">
        <asp:LinkButton runat="server" CssClass="back-btn" OnClick="BackToMain">&laquo; CANCEL &amp; BACK</asp:LinkButton>
        <div class="form-panel">
            <h2>+ Add New Enchantment</h2>
            <asp:Label ID="lblAddError" runat="server" CssClass="error-msg" />
            <div class="form-row-half">
                <div class="form-row"><label>Name</label><asp:TextBox ID="txtAddName" runat="server" CssClass="form-input" /></div>
                <div class="form-row">
                    <label>Category</label>
                    <asp:DropDownList ID="ddlAddCategory" runat="server" CssClass="form-select">
                        <asp:ListItem>Sword</asp:ListItem><asp:ListItem>Armor</asp:ListItem><asp:ListItem>Tool</asp:ListItem>
                        <asp:ListItem>Bow</asp:ListItem><asp:ListItem>Crossbow</asp:ListItem><asp:ListItem>Trident</asp:ListItem>
                        <asp:ListItem>Fishing Rod</asp:ListItem><asp:ListItem>Other</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="form-row-half">
                <div class="form-row"><label>Max Level (1-5)</label><asp:TextBox ID="txtAddMaxLevel" runat="server" CssClass="form-input" /></div>
                <div class="form-row"><label>Thumbnail Path</label><asp:TextBox ID="txtAddThumbnail" runat="server" CssClass="form-input" /></div>
            </div>
            <div class="form-row"><label>Detail Image Path</label><asp:TextBox ID="txtAddDetailImage" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Short Description</label><asp:TextBox ID="txtAddDesc" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Applies To</label><asp:TextBox ID="txtAddApplies" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Conflicts With</label><asp:TextBox ID="txtAddConflicts" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Detailed Content</label><asp:TextBox ID="txtAddContent" runat="server" CssClass="form-textarea" TextMode="MultiLine" /></div>
            <div class="form-row chk-row">
                <asp:CheckBox ID="chkAddTreasure" runat="server" />
                <label style="margin:0;">Treasure Only</label>
            </div>
            <div style="margin-top:20px;">
                <asp:Button runat="server" CssClass="btn-save" Text="ADD ENCHANTMENT" OnClick="SaveAdd" />
                <asp:Button runat="server" CssClass="btn-cancel" Text="CANCEL" OnClick="BackToMain" />
            </div>
        </div>
    </asp:Panel>

</div>

<script type="text/javascript">
    function handleFlip(e) {
        if (e.target.closest('a, input, button, textarea')) return;
        document.getElementById('flipCard').classList.toggle('flipped');
    }
</script>
</asp:Content>
