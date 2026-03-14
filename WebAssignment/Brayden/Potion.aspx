<%@ Page Title="Potion Guide" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Potion.aspx.cs" Inherits="WebAssignment.Brayden.Potion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .pot-container { width: 90%; margin: 30px auto; color: #fff; }
        .page-title { font-size: 2.5rem; color: #3498db; text-transform: uppercase; border-bottom: 4px solid #3498db; padding-bottom: 10px; margin-bottom: 30px; }
        .section-label { color: #3498db; text-transform: uppercase; margin: 30px 0 12px; display: block; font-size: 1.3rem; border-left: 5px solid #3498db; padding-left: 15px; }

        /* Category cards */
        .pot-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 20px; }
        .positive-card { background: rgba(0,80,0,0.6);  border: 3px solid #2ecc71; }
        .negative-card { background: rgba(80,0,0,0.6);  border: 3px solid #e74c3c; }
        .neutral-card  { background: rgba(80,60,0,0.6); border: 3px solid #f39c12; }
        .pot-cat-card  { padding: 30px; cursor: pointer; text-decoration: none; display: block; transition: 0.3s; text-align: center; }
        .pot-cat-card:hover { transform: translateY(-5px); box-shadow: 0 5px 20px rgba(0,0,0,0.5); }
        .pot-cat-card h2 { font-size: 1.5rem; text-transform: uppercase; margin-top: 10px; }
        .pot-cat-card p  { font-size: 0.9rem; color: #ccc; margin-top: 5px; }
        .cat-icon-big { font-size: 3.5rem; display: block; }

        /* List rows */
        .type-badge     { padding: 2px 10px; font-size: 0.75rem; margin-left: 8px; }
        .type-Brewed    { background: #2980b9; color: #fff; }
        .type-Splash    { background: #8e44ad; color: #fff; }
        .type-Lingering { background: #d35400; color: #fff; }
        .type-Beacon    { background: #f1c40f; color: #000; }
        .pot-row { background: #1a1a1a; padding: 15px 20px; margin-bottom: 12px; display: flex; align-items: center; gap: 20px; transition: 0.2s; }
        .pot-row:hover { background: #242424; }
        .positive-row { border-left: 5px solid #2ecc71; }
        .negative-row { border-left: 5px solid #e74c3c; }
        .neutral-row  { border-left: 5px solid #f39c12; }
        .pot-row-thumb { width: 65px; height: 65px; object-fit: contain; image-rendering: pixelated; border: 2px solid #333; background: #0d0d0d; flex-shrink: 0; }
        .pot-row-info { flex: 1; }
        .pot-row-info h3 { font-size: 1.2rem; margin-bottom: 4px; }
        .pot-row-info p  { color: #aaa; font-size: 0.9rem; }
        .duration-badge { background: #34495e; color: #ecf0f1; padding: 3px 12px; font-size: 0.8rem; white-space: nowrap; }

        /* Detail page */
        .detail-box { background: rgba(0,0,0,0.9); border: 4px solid #555; padding: 35px; }
        .detail-header { display: flex; gap: 25px; align-items: flex-start; border-bottom: 3px solid #3498db; padding-bottom: 20px; margin-bottom: 25px; }
        .detail-thumb { width: 90px; height: 90px; image-rendering: pixelated; object-fit: contain; border: 3px solid #3498db; background: #0d0d0d; padding: 4px; flex-shrink: 0; }
        .detail-title { font-size: 2.4rem; color: #74b9ff; }
        .detail-sub   { color: #888; font-size: 1rem; margin-top: 5px; }

        /* Two-column image section */
        .img-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 25px; }
        .img-card { background: #0d0d0d; border: 2px solid #333; padding: 12px; text-align: center; }
        .img-card img { width: 100%; max-height: 200px; object-fit: contain; image-rendering: pixelated; }
        .img-card p { color: #666; font-size: 0.8rem; margin-top: 8px; }

        .brewing-chain { display: flex; align-items: center; gap: 10px; background: #111; border: 1px solid #333; padding: 15px 20px; margin-bottom: 20px; flex-wrap: wrap; }
        .chain-step  { background: #2c3e50; color: #ecf0f1; padding: 6px 15px; font-size: 0.9rem; }
        .chain-arrow { color: #3498db; font-size: 1.2rem; }
        .meta-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 15px; margin-bottom: 20px; }
        .meta-cell { background: #111; border: 1px solid #333; padding: 12px 15px; }
        .meta-cell label { color: #666; font-size: 0.75rem; text-transform: uppercase; display: block; margin-bottom: 4px; }
        .meta-cell span  { color: #fff; font-size: 0.95rem; }
        .content-box { background: #111; border: 1px solid #333; padding: 20px; color: #ccc; line-height: 1.8; font-size: 1rem; }

        /* Buttons */
        .btn-edit   { background: #2980b9; color: #fff; border: none; padding: 8px 20px; cursor: pointer; font-size: 0.9rem; margin-right: 10px; font-family: inherit; }
        .btn-delete { background: #c0392b; color: #fff; border: none; padding: 8px 20px; cursor: pointer; font-size: 0.9rem; font-family: inherit; }
        .btn-add    { background: #27ae60; color: #fff; border: none; padding: 8px 20px; cursor: pointer; font-size: 0.9rem; font-family: inherit; margin-bottom: 20px; }
        .btn-save   { background: #27ae60; color: #fff; border: none; padding: 10px 25px; cursor: pointer; font-size: 1rem; font-family: inherit; }
        .btn-cancel { background: #555; color: #fff; border: none; padding: 10px 25px; cursor: pointer; font-size: 1rem; font-family: inherit; margin-left: 10px; }
        .back-btn   { color: #f39c12; cursor: pointer; text-decoration: none; margin-bottom: 20px; display: inline-block; font-size: 1rem; }
        .back-btn:hover { color: #fbbf24; }
        .view-btn   { background: #3498db; color: #fff; padding: 8px 18px; font-size: 0.85rem; border: none; cursor: pointer; font-family: inherit; }

        /* Form */
        .form-panel { background: rgba(0,0,0,0.9); border: 4px solid #555; padding: 35px; max-width: 800px; margin: 0 auto; }
        .form-panel h2 { color: #3498db; font-size: 1.8rem; border-bottom: 2px solid #3498db; padding-bottom: 10px; margin-bottom: 25px; }
        .form-row { margin-bottom: 18px; }
        .form-row label { color: #aaa; font-size: 0.9rem; display: block; margin-bottom: 6px; text-transform: uppercase; }
        .form-input, .form-textarea, .form-select { width: 100%; background: #1a1a1a; border: 2px solid #555; color: #fff; padding: 10px; font-family: inherit; font-size: 0.95rem; }
        .form-textarea { height: 120px; resize: vertical; }
        .form-row-half { display: flex; gap: 20px; }
        .form-row-half .form-row { flex: 1; }
        .error-msg { color: #e74c3c; font-size: 0.9rem; margin-bottom: 15px; display: block; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="pot-container">

    <%-- PANEL 1: CATEGORIES --%>
    <asp:Panel ID="categoryPanel" runat="server">
        <h1 class="page-title">🧪 Potion Guide</h1>
        <p style="color:#aaa; margin-bottom:25px; font-size:1rem;">Brew powerful concoctions to aid your adventures. Explore all 20 potions across 3 categories.</p>
        <div class="pot-grid">
            <asp:Repeater ID="categoryRepeater" runat="server">
                <ItemTemplate>
                    <asp:LinkButton runat="server"
                        CssClass='<%# "pot-cat-card " + Eval("Category").ToString().ToLower() + "-card" %>'
                        CommandArgument='<%# Eval("Category") %>' OnClick="SelectCategory">
                        <span class="cat-icon-big"><%# ((WebAssignment.Brayden.Potion)Page).GetCategoryIcon(Eval("Category").ToString()) %></span>
                        <h2 style='color:<%# ((WebAssignment.Brayden.Potion)Page).GetCategoryColor(Eval("Category").ToString()) %>'>
                            <%# Eval("Category") %> Potions
                        </h2>
                        <p>Explore <%# Eval("Category").ToString().ToLower() %> effect brews</p>
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div style="margin-top:40px; background:rgba(0,0,0,0.7); border:3px solid #555; padding:25px;">
            <h2 style="color:#3498db; font-size:1.4rem; margin-bottom:15px;">🍶 How Brewing Works</h2>
            <div class="brewing-chain">
                <span class="chain-step">Water Bottle</span>
                <span class="chain-arrow">➜</span>
                <span class="chain-step">+ Nether Wart</span>
                <span class="chain-arrow">➜</span>
                <span class="chain-step">Awkward Potion</span>
                <span class="chain-arrow">➜</span>
                <span class="chain-step">+ Ingredient</span>
                <span class="chain-arrow">➜</span>
                <span class="chain-step">Potion!</span>
            </div>
            <p style="color:#aaa; font-size:0.9rem; margin-top:10px;">
                <b style="color:#e67e22;">Gunpowder</b> → Splash &nbsp;|&nbsp;
                <b style="color:#9b59b6;">Dragon's Breath</b> → Lingering &nbsp;|&nbsp;
                <b style="color:#3498db;">Redstone</b> extends duration &nbsp;|&nbsp;
                <b style="color:#f1c40f;">Glowstone</b> increases level
            </p>
        </div>
    </asp:Panel>

    <%-- PANEL 2: LIST --%>
    <asp:Panel ID="listPanel" runat="server" Visible="false">
        <asp:LinkButton runat="server" CssClass="back-btn" OnClick="BackToCategories">« BACK TO CATEGORIES</asp:LinkButton>
        <asp:Button ID="btnAddNew" runat="server" CssClass="btn-add" Text="+ ADD POTION" OnClick="ShowAddForm" Style="float:right;" Visible="false" />
        <h1 class="page-title"><asp:Label ID="lblListTitle" runat="server" /></h1>

        <asp:Repeater ID="potionRepeater" runat="server">
            <ItemTemplate>
                <div class='pot-row <%# Eval("Category").ToString().ToLower() %>-row'>
                    <%-- Thumbnail on list --%>
                    <img src='<%# ResolveUrl(Eval("Thumbnail").ToString()) %>'
                         class="pot-row-thumb"
                         onerror="this.style.display='none'" alt='<%# Eval("Name") %>' />
                    <div class="pot-row-info">
                        <h3 style='color:<%# ((WebAssignment.Brayden.Potion)Page).GetCategoryColor(Eval("Category").ToString()) %>'>
                            <%# Eval("Name") %>
                            <span class='type-badge type-<%# Eval("PotionType").ToString().Replace(" ","") %>'><%# Eval("PotionType") %></span>
                        </h3>
                        <p><%# Eval("Description") %></p>
                    </div>
                    <span class="duration-badge">⏱ <%# Eval("Duration") %></span>
                    <asp:LinkButton runat="server" CssClass="view-btn"
                        CommandArgument='<%# Eval("PotionId") %>' OnClick="ViewDetail">VIEW »</asp:LinkButton>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </asp:Panel>

    <%-- PANEL 3: DETAIL --%>
    <asp:Panel ID="detailPanel" runat="server" Visible="false">
        <asp:LinkButton runat="server" CssClass="back-btn" OnClick="BackToList">« BACK TO LIST</asp:LinkButton>
        <div class="detail-box">

            <div class="detail-header">
                <asp:Image ID="imgDetailThumb" runat="server" CssClass="detail-thumb" />
                <div>
                    <div class="detail-title"><asp:Label ID="lblDetailName" runat="server" /></div>
                    <div class="detail-sub">
                        <asp:Label ID="lblDetailCategory" runat="server" /> &nbsp;|&nbsp;
                        <asp:Label ID="lblDetailType" runat="server" />
                    </div>
                    <p style="color:#ccc; font-size:1rem; margin-top:8px;"><asp:Label ID="lblDetailDesc" runat="server" /></p>
                </div>
            </div>

            <%-- Two-column visual: potion bottle + ingredient image --%>
            <asp:Panel ID="pnlImages" runat="server" Visible="false">
                <div class="img-row">
                    <div class="img-card">
                        <asp:Image ID="imgDetailLarge" runat="server" onerror="this.parentElement.style.display='none'" />
                        <p>Potion bottle / in-game appearance</p>
                    </div>
                    <div class="img-card">
                        <asp:Image ID="imgIngredient" runat="server" onerror="this.parentElement.style.display='none'" />
                        <p>Key ingredient / brewing recipe</p>
                    </div>
                </div>
            </asp:Panel>

            <span class="section-label">Effect</span>
            <p style="color:#ecf0f1; font-size:1.05rem; margin-bottom:20px;"><asp:Label ID="lblDetailEffect" runat="server" /></p>

            <div class="meta-grid">
                <div class="meta-cell"><label>Duration</label><span><asp:Label ID="lblDetailDuration" runat="server" /></span></div>
                <div class="meta-cell"><label>Brewing Base</label><span><asp:Label ID="lblDetailBase" runat="server" /></span></div>
                <div class="meta-cell"><label>Key Ingredient</label><span><asp:Label ID="lblDetailIngredient" runat="server" /></span></div>
            </div>

            <span class="section-label">Brewing Instructions</span>
            <div class="content-box"><asp:Literal ID="litDetailContent" runat="server" /></div>

            <div style="margin-top:25px;">
                <asp:Button ID="btnEditPotion" runat="server" CssClass="btn-edit" Text="✎ EDIT" OnClick="ShowEditForm" Visible="false" />
                <asp:LinkButton ID="btnDeletePotion" runat="server" CssClass="btn-delete" Text="✖ DELETE"
                    OnClick="DeletePotion" OnClientClick="return confirm('Delete this potion?');" Visible="false" />
            </div>

            <%-- COMMENT SECTION --%>
            <div style="margin-top:40px; border-top:3px solid #555; padding-top:30px;">
                <h3 style="color:#2ecc71; font-size:1.5rem; margin-bottom:20px;">💬 COMMUNITY COMMENTS</h3>
                <asp:Repeater ID="rptComments" runat="server">
                    <ItemTemplate>
                        <div style="border-bottom:1px dashed #444; padding:15px 0; margin-bottom:10px;">
                            <span style="color:#2ecc71;"><%# Eval("Username") %></span>
                            <span style="color:#888; font-size:0.8rem;">- <%# Eval("CommentDate", "{0:yyyy-MM-dd HH:mm}") %></span>
                            <asp:LinkButton ID="lnkReport" runat="server"
                                Text="[ REPORT ]"
                                CommandArgument='<%# String.Format("{0}|{1}", Eval("CommentId"), Request.QueryString["PotionId"]) %>'
                                OnCommand="lnkReport_Command"
                                OnClientClick="return confirm('Are you sure you want to report this comment?');"
                                Visible='<%# Session["userId"] != null %>'
                                style="color:#ff4444; font-size:0.7rem; text-decoration:none; float:right;" />
                            <p style="margin-top:8px; color:#ddd; line-height:1.4;"><%# Eval("CommentText") %></p>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <%-- Add Comment Panel --%>
                <asp:Panel ID="pnlAddComment" runat="server" Visible="false" style="margin-top:20px;">
                    <h4 style="color:#fbbf24; margin-bottom:10px; font-size:1rem;">ADD YOUR THOUGHTS</h4>
                    <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Rows="4"
                        style="width:100%; background:#000; color:#fff; border:1px solid#2ecc71; padding:10px; font-family:inherit; resize:none;"
                        placeholder="Share your experience with this potion..." />
                    <br />
                    <asp:Button ID="btnSubmitComment" runat="server" Text="[ POST COMMENT ]"
                        OnClick="btnSubmitComment_Click"
                        style="margin-top:15px; background:#2ecc71; color:#000; border:none; padding:10px 25px; font-weight:bold; cursor:pointer; font-family:inherit;" />
                </asp:Panel>

                <%-- Visitor Message --%>
                <asp:Literal ID="litVisitorMsg" runat="server" />
            </div>
        </div>
    </asp:Panel>

    <%-- PANEL 4: EDIT --%>
    <asp:Panel ID="editPanel" runat="server" Visible="false">
        <asp:LinkButton runat="server" CssClass="back-btn" OnClick="BackToList">« CANCEL & BACK</asp:LinkButton>
        <div class="form-panel">
            <h2>✎ Edit Potion</h2>
            <asp:Label ID="lblEditError" runat="server" CssClass="error-msg" />
            <div class="form-row-half">
                <div class="form-row"><label>Name</label><asp:TextBox ID="txtEditName" runat="server" CssClass="form-input" /></div>
                <div class="form-row">
                    <label>Category</label>
                    <asp:DropDownList ID="ddlEditCategory" runat="server" CssClass="form-select">
                        <asp:ListItem>Positive</asp:ListItem><asp:ListItem>Negative</asp:ListItem><asp:ListItem>Neutral</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="form-row-half">
                <div class="form-row">
                    <label>Potion Type</label>
                    <asp:DropDownList ID="ddlEditType" runat="server" CssClass="form-select">
                        <asp:ListItem>Brewed</asp:ListItem><asp:ListItem>Splash</asp:ListItem>
                        <asp:ListItem>Lingering</asp:ListItem><asp:ListItem>Beacon Effect</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-row"><label>Duration</label><asp:TextBox ID="txtEditDuration" runat="server" CssClass="form-input" /></div>
            </div>
            <div class="form-row"><label>Effect</label><asp:TextBox ID="txtEditEffect" runat="server" CssClass="form-input" /></div>
            <div class="form-row-half">
                <div class="form-row"><label>Brewing Base</label><asp:TextBox ID="txtEditBase" runat="server" CssClass="form-input" /></div>
                <div class="form-row"><label>Key Ingredient</label><asp:TextBox ID="txtEditIngredient" runat="server" CssClass="form-input" /></div>
            </div>
            <div class="form-row"><label>Short Description</label><asp:TextBox ID="txtEditDesc" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Thumbnail Path (list small image)</label><asp:TextBox ID="txtEditThumbnail" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Detail Image Path (potion bottle)</label><asp:TextBox ID="txtEditDetailImage" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Ingredient Image Path (recipe/ingredient)</label><asp:TextBox ID="txtEditIngredientImage" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Brewing Instructions (Detail)</label><asp:TextBox ID="txtEditContent" runat="server" CssClass="form-textarea" TextMode="MultiLine" /></div>
            <div style="margin-top:20px;">
                <asp:Button runat="server" CssClass="btn-save" Text="SAVE CHANGES" OnClick="SaveEdit" />
                <asp:Button runat="server" CssClass="btn-cancel" Text="CANCEL" OnClick="BackToList" />
            </div>
        </div>
    </asp:Panel>

    <%-- PANEL 5: ADD --%>
    <asp:Panel ID="addPanel" runat="server" Visible="false">
        <asp:LinkButton runat="server" CssClass="back-btn" OnClick="BackToList">« CANCEL & BACK</asp:LinkButton>
        <div class="form-panel">
            <h2>+ Add New Potion</h2>
            <asp:Label ID="lblAddError" runat="server" CssClass="error-msg" />
            <div class="form-row-half">
                <div class="form-row"><label>Name</label><asp:TextBox ID="txtAddName" runat="server" CssClass="form-input" /></div>
                <div class="form-row">
                    <label>Category</label>
                    <asp:DropDownList ID="ddlAddCategory" runat="server" CssClass="form-select">
                        <asp:ListItem>Positive</asp:ListItem><asp:ListItem>Negative</asp:ListItem><asp:ListItem>Neutral</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="form-row-half">
                <div class="form-row">
                    <label>Potion Type</label>
                    <asp:DropDownList ID="ddlAddType" runat="server" CssClass="form-select">
                        <asp:ListItem>Brewed</asp:ListItem><asp:ListItem>Splash</asp:ListItem>
                        <asp:ListItem>Lingering</asp:ListItem><asp:ListItem>Beacon Effect</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-row"><label>Duration</label><asp:TextBox ID="txtAddDuration" runat="server" CssClass="form-input" /></div>
            </div>
            <div class="form-row"><label>Effect</label><asp:TextBox ID="txtAddEffect" runat="server" CssClass="form-input" /></div>
            <div class="form-row-half">
                <div class="form-row"><label>Brewing Base</label><asp:TextBox ID="txtAddBase" runat="server" CssClass="form-input" /></div>
                <div class="form-row"><label>Key Ingredient</label><asp:TextBox ID="txtAddIngredient" runat="server" CssClass="form-input" /></div>
            </div>
            <div class="form-row"><label>Short Description</label><asp:TextBox ID="txtAddDesc" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Thumbnail Path (list small image)</label><asp:TextBox ID="txtAddThumbnail" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Detail Image Path (potion bottle)</label><asp:TextBox ID="txtAddDetailImage" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Ingredient Image Path (recipe/ingredient)</label><asp:TextBox ID="txtAddIngredientImage" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Brewing Instructions (Detail)</label><asp:TextBox ID="txtAddContent" runat="server" CssClass="form-textarea" TextMode="MultiLine" /></div>
            <div style="margin-top:20px;">
                <asp:Button runat="server" CssClass="btn-save" Text="ADD POTION" OnClick="SaveAdd" />
                <asp:Button runat="server" CssClass="btn-cancel" Text="CANCEL" OnClick="BackToList" />
            </div>
        </div>
    </asp:Panel>

</div>
</asp:Content>
