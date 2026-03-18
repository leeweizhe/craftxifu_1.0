<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" 
         CodeBehind="BeginnerGuide.aspx.cs" Inherits="WebAssignment.Lee_Wei_Zhe.aspx.BeginnerGuide" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/Lee Wei Zhe/css/BeginnerGuide.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300..800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <%-- defer means the JS loads AFTER the HTML is ready --%>
    <script src="/Lee Wei Zhe/js/BeginnerGuide.js" defer></script>
    <script src="/Lee Wei Zhe/js/CraftingRecipe.js" defer></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <%-- ═══════════════════════════════════════════════════════════════════
         ADD PART OVERLAY FORM
         This is hidden by default and floats over the whole page.
         It appears when any "＋ Add Part Here" button is clicked.
         Placed OUTSIDE the repeater so it exists once on the page.
         pnlAddPartOverlay.Visible is set to false for non-instructors
         in Page_Load — so non-instructors don't even get this HTML.
    ═══════════════════════════════════════════════════════════════════ --%>
    <asp:Panel ID="pnlAddPartOverlay" runat="server" Visible="false">
        <div id="addPartFormOverlay" class="add-part-overlay" style="display:none">
            <div class="add-part-form-inner">
                <h3 class="add-part-form-title">＋ Add New Section</h3>

                <label class="edit-label label-white">Section Title</label>
                <asp:TextBox ID="txtNewPartTitle" runat="server" CssClass="edit-input"
                    placeholder="e.g. Advanced Techniques" MaxLength="100"
                    ValidationGroup="AddPart" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNewPartTitle"
                    ErrorMessage="Please enter a title." CssClass="form-error"
                    Display="Dynamic" ValidationGroup="AddPart" />

                <label class="edit-label label-white" style="margin-top:14px">Insert Position</label>
                <%-- This dropdown is populated in Page_Load via LoadPartPositionDropdown() --%>
                <asp:DropDownList ID="ddlPartPosition" runat="server" CssClass="edit-input edit-select" />

                <div class="inline-form-actions" style="margin-top:16px">
                    <asp:LinkButton ID="btnSaveNewPart" runat="server"
                        CssClass="btn-instructor btn-save"
                        OnClick="btnSaveNewPart_Click"
                        ValidationGroup="AddPart"
                        CausesValidation="true">💾 Save Section</asp:LinkButton>
                    <%-- return false stops the form from submitting via the browser --%>
                    <button class="btn-instructor btn-cancel"
                        onclick="hideAddPartForm(); return false;">✖ Cancel</button>
                </div>
            </div>
        </div>
    </asp:Panel>
    <%-- ═══════════════════════════════════════════════════════════════════
         RECIPE ADD / EDIT OVERLAY  (instructor-only, Visible set in Page_Load)
         ClientIDMode="Static" on every input so JS can find them by their
         declared ID regardless of the MasterPage naming container.
    ═══════════════════════════════════════════════════════════════════ --%>
    <asp:Panel ID="pnlRecipeFormOverlay" runat="server" Visible="false">
        <div id="recipeFormOverlay" class="add-part-overlay" style="display:none">
            <div class="add-part-form-inner recipe-form-inner">

                <h3 class="add-part-form-title" id="recipeFormTitle">➕ Add Recipe</h3>

                <%-- Hidden fields: track add/edit mode + current image paths --%>
                <asp:HiddenField ID="hfRecipeFormMode"    runat="server" Value="add" ClientIDMode="Static" />
                <asp:HiddenField ID="hfEditRecipeId"      runat="server" Value="0"   ClientIDMode="Static" />
                <asp:HiddenField ID="hfCurrentThumbPath"  runat="server" Value=""    ClientIDMode="Static" />
                <asp:HiddenField ID="hfCurrentRecipePath" runat="server" Value=""    ClientIDMode="Static" />

                <div class="recipe-form-cols">

                    <%-- LEFT: text fields --%>
                    <div class="recipe-form-col">
                        <label class="edit-label label-white">Category</label>
                        <asp:DropDownList ID="ddlRecipeCategory" runat="server"
                            CssClass="edit-input edit-select" ClientIDMode="Static" />

                        <label class="edit-label label-white" style="margin-top:10px">Recipe Name</label>
                        <asp:TextBox ID="txtRecipeName" runat="server"
                            CssClass="edit-input" MaxLength="100"
                            placeholder="e.g. Wooden Sword" ClientIDMode="Static" />

                        <label class="edit-label label-white" style="margin-top:10px">Description</label>
                        <asp:TextBox ID="txtRecipeDescription" runat="server"
                            CssClass="edit-input edit-textarea" TextMode="MultiLine" Rows="3"
                            placeholder="Short tooltip description..." ClientIDMode="Static" />
                    </div>

                    <%-- RIGHT: image uploads with live preview --%>
                    <div class="recipe-form-col">
                        <label class="edit-label label-white">
                            Thumbnail <span class="edit-hint">(card icon)</span>
                        </label>
                        <img id="imgThumbPreview" src="" alt="Thumbnail preview"
                             class="recipe-upload-preview" style="display:none" />
                        <asp:FileUpload ID="fileUploadThumb" runat="server"
                            CssClass="recipe-file-input" ClientIDMode="Static" />

                        <label class="edit-label label-white" style="margin-top:14px">
                            Recipe Image <span class="edit-hint">(tooltip grid)</span>
                        </label>
                        <img id="imgRecipePreview" src="" alt="Recipe image preview"
                             class="recipe-upload-preview" style="display:none" />
                        <asp:FileUpload ID="fileUploadRecipeImg" runat="server"
                            CssClass="recipe-file-input" ClientIDMode="Static" />
                    </div>

                </div><%-- end .recipe-form-cols --%>

                <asp:Label ID="lblRecipeError" runat="server"
                    CssClass="form-error" Visible="false" EnableViewState="false" />

                <div class="inline-form-actions" style="margin-top:18px">
                    <asp:Button ID="btnSaveRecipe" runat="server"
                        CssClass="btn-instructor btn-save"
                        Text="💾 Save Recipe"
                        OnClick="btnSaveRecipe_Click"
                        CausesValidation="false" />
                    <button class="btn-instructor btn-cancel"
                        onclick="hideRecipeForm(); return false;">✖ Cancel</button>
                </div>

            </div>
        </div>
    </asp:Panel>

    <div id="imgLightbox" class="lightbox-overlay" onclick="closeLightbox()" style="display:none">
        <button class="lightbox-close" onclick="closeLightbox(); return false;">✕</button>
        <img id="lightboxImg" src="" alt="" class="lightbox-img" onclick="event.stopPropagation()" />
    </div>

    <div class="top-bar">
        <a href="/Wong Zhang Zhe/Guide.aspx" class="btn-back">Back</a>
    </div>
    <div class="page-layout">

        <%-- ═══════════════════════════════════════════════════════════════════
             SIDEBAR TABLE OF CONTENTS
        ═══════════════════════════════════════════════════════════════════ --%>
        <aside class="toc-sidebar">
            <h3>Contents</h3>
            <ul>
                <asp:Repeater ID="rptMenu" runat="server">
                    <ItemTemplate>
                        <li>
                            <a href='#part-<%# Eval("PartId") %>'>
                                ▶ <%# Eval("PartTitle") %>
                            </a>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>

                <li style="border-top: 2px solid #555; margin-top: 10px; padding-top: 10px;">
                    <a href="#crafting-recipes">Crafting Recipes</a>
                </li>
                <li style="margin-top=10px;">
                    <a href="#discussion-section">Comment Section</a>
                </li>
            </ul>


            <%-- Shortcut "Add Section" in sidebar — only for instructors --%>
            <asp:Panel ID="pnlSidebarAddPart" runat="server" Visible="false">
                <div style="margin-top:15px; border-top:2px solid #555; padding-top:15px;">
                    <button class="btn-instructor btn-add" style="width:100%"
                        onclick="showAddPartForm(); return false;">＋ Add New Section</button>
                </div>

            </asp:Panel>
        </aside>

        <div class="all-guides-wrapper">

            <%-- ═══════════════════════════════════════════════════════════════
                 MAIN GUIDE REPEATER
                 OnItemDataBound → fires for EACH row as it's being built.
                                   We use this to load steps from DB.
                 OnItemCommand   → fires when any Button/LinkButton inside
                                   the repeater is clicked.
            ═══════════════════════════════════════════════════════════════ --%>
            <asp:Repeater ID="rptGuideParts" runat="server"
                OnItemDataBound="rptGuideParts_ItemDataBound"
                OnItemCommand="rptGuideParts_ItemCommand">

                <%-- ─────────────────────────────────────────────────────────
                     SEPARATOR TEMPLATE
                     Renders between every two parts — this is where we put
                     the "＋ Add Part Here" button.
                     We use a plain <div> (not runat=server) because there's
                     no ItemDataBound for separators.
                     JS shows/hides this based on window.isInstructor.
                ───────────────────────────────────────────────────────── --%>
                <SeparatorTemplate>
                    <div class="add-part-separator-wrapper">
                        <button class="add-part-separator-btn"
                            onclick="showAddPartForm(); return false;">
                            ＋ Add Part Here
                        </button>
                    </div>
                </SeparatorTemplate>

                <ItemTemplate>
                    <div class="guide-container" id='part-<%# Eval("PartId") %>'>

                        <%-- ─────────────────────────────────────────────────
                             PART TITLE — VIEW MODE
                             Shows title + instructor edit/delete buttons.
                             pnlPartControls.Visible is set in ItemDataBound.
                        ───────────────────────────────────────────────────── --%>
                        <asp:Panel ID="pnlPartTitleView" runat="server" CssClass="guide-title-row part-title-view">
                            <h1 class="guide-title"><%# Eval("PartTitle") %></h1>

                            <asp:Panel ID="pnlPartControls" runat="server" Visible="false" CssClass="instructor-controls">
                                <button class="btn-instructor btn-edit"
                                    onclick="togglePartEdit(this); return false;">✏️ Edit Title</button>

                                <asp:Button CommandName="DeletePart"
                                    CommandArgument='<%# Eval("PartId") %>'
                                    CssClass="btn-instructor btn-delete"
                                    CausesValidation="false"
                                    Text="🗑️ Delete Section"
                                    OnClientClick="return confirm('Delete this ENTIRE section and ALL its steps?');"
                                    runat="server" />
                            </asp:Panel>
                        </asp:Panel>

                        <%-- ─────────────────────────────────────────────────
                             PART TITLE — EDIT MODE
                             Hidden by default (style="display:none").
                             JS toggles between this and the view panel above.
                             Visible="false" is set in Page_Load for non-instructors
                             so this HTML block doesn't even render for them.
                        ───────────────────────────────────────────────────── --%>
                        <asp:Panel ID="pnlPartTitleEdit" runat="server" Visible="false"
                            CssClass="guide-title-row part-title-edit" style="display:none">

                            <asp:TextBox ID="txtEditPartTitle" runat="server"
                                CssClass="edit-input edit-title-input"
                                Text='<%# Eval("PartTitle") %>'
                                MaxLength="100" />

                            <div class="inline-form-actions">
                                <asp:Button CommandName="SavePart"
                                    CommandArgument='<%# Eval("PartId") %>'
                                    CssClass="btn-instructor btn-save"
                                    CausesValidation="false"
                                    Text="💾 Save"
                                    runat="server" />
                                <button class="btn-instructor btn-cancel"
                                    onclick="togglePartEdit(this); return false;">✖ Cancel</button>
                            </div>
                        </asp:Panel>

                        <%-- Carries the PartId through postback events --%>
                        <asp:HiddenField ID="hfPartId" runat="server" Value='<%# Eval("PartId") %>' />

                        <%-- ═════════════════════════════════════════════════
                             INNER REPEATER — STEPS
                             OnItemDataBound → toggle instructor panels per step
                             OnItemCommand   → Save / Delete per step
                        ═════════════════════════════════════════════════ --%>
                        <asp:Repeater ID="rptSteps" runat="server"
                            OnItemDataBound="rptSteps_ItemDataBound"
                            OnItemCommand="rptSteps_ItemCommand">
                            <ItemTemplate>
                                <div class="step-card">
                                    <div class="step-badge">Step <%# Container.ItemIndex + 1 %></div>

                                    <%-- ─────────────────────────────────────
                                         STEP — VIEW MODE
                                         The normal read-only card.
                                    ───────────────────────────────────────── --%>
                                    <asp:Panel ID="pnlStepView" runat="server" CssClass="step-view-panel">
                                        <div class="step-content">
                                            <h2><%# Eval("StepTitle") %></h2>
                                            <p><%# Eval("StepDescription") %></p>
                                        </div>

                                        <div class="step-image-box">
                                            <img src='<%# Eval("ImagePath") %>'
                                                alt='<%# Eval("StepTitle") %>'
                                                class="guide-img" />
                                        </div>

                                        <%-- Only visible to instructors (set in rptSteps_ItemDataBound) --%>
                                        <asp:Panel ID="pnlEditControls" runat="server" Visible="false"
                                            CssClass="step-instructor-overlay">
                                            <button class="recipe-edit-btn"
                                                onclick="toggleStepEdit(this); return false;">✏️ Edit</button>

                                        <asp:Button CommandName="DeleteStep"
                                            CommandArgument='<%# Eval("StepId") %>'
                                            CssClass="recipe-delete-btn"
                                            CausesValidation="false"
                                            Text="🗑️ Delete"
                                            OnClientClick="return confirm('Delete this step?');"
                                            runat="server" />

                                        </asp:Panel>
                                    </asp:Panel>

                                    <%-- ─────────────────────────────────────
                                         STEP — EDIT MODE
                                         Hidden by default (style="display:none").
                                         JS swaps this in when Edit is clicked.
                                         Only rendered for instructors (Visible set
                                         in rptSteps_ItemDataBound).
                                    ───────────────────────────────────────── --%>
                                    <asp:Panel ID="pnlStepEdit" runat="server" Visible="false"
                                        CssClass="step-edit-panel" style="display:none">

                                        <div class="step-edit-fields">
                                            <label class="edit-label">Title</label>
                                            <asp:TextBox ID="txtEditTitle" runat="server"
                                                CssClass="edit-input"
                                                Text='<%# Eval("StepTitle") %>'
                                                MaxLength="100" />

                                            <label class="edit-label">Description</label>
                                            <asp:TextBox ID="txtEditDescription" runat="server"
                                                CssClass="edit-input edit-textarea"
                                                TextMode="MultiLine" Rows="4"
                                                Text='<%# Eval("StepDescription") %>' />

                                            <label class="edit-label">
                                                Image Path <span class="edit-hint">(optional)</span>
                                            </label>
                                            <img id="imgStepEditPreview" src="" class="step-img-upload-preview" style="display:none;" />
                                            <asp:FileUpload ID="fuEditStepImg" runat="server" CssClass="edit-input" onchange="previewStepImage(this, 'imgStepEditPreview')" />
                                            <asp:HiddenField ID="hfCurrentStepImg" runat="server" Value='<%# Eval("ImagePath") %>' />
                                        </div>

                                        <div class="inline-form-actions">
                                            <asp:Button CommandName="SaveStep"
                                                CommandArgument='<%# Eval("StepId") %>'
                                                CssClass="btn-instructor btn-save"
                                                CausesValidation="false"
                                                Text="💾 Save"
                                                runat="server" />
                                            <button class="btn-instructor btn-cancel"
                                                onclick="toggleStepEdit(this); return false;">✖ Cancel</button>
                                        </div>
                                    </asp:Panel>

                                </div><%-- end .step-card --%>
                            </ItemTemplate>
                        </asp:Repeater>

                        <%-- ─────────────────────────────────────────────────
                             ADD STEP ROW
                             Shows a "＋ Add Step" button at the bottom of each part.
                             Clicking it reveals an inline form.
                             pnlAddStep.Visible is set in ItemDataBound.
                        ───────────────────────────────────────────────────── --%>
                        <asp:Panel ID="pnlAddStep" runat="server" Visible="false" CssClass="add-step-row">

                            <button class="btn-instructor btn-add add-step-toggle"
                                onclick="toggleAddStepForm(this); return false;">
                                ＋ Add Step
                            </button>

                            <%-- Hidden until + is clicked --%>
                            <div class="add-step-form" style="display:none">
                                <h3 class="add-step-form-title">New Step</h3>

                                <label class="edit-label">Title</label>
                                <asp:TextBox ID="txtNewStepTitle" runat="server"
                                    CssClass="edit-input" MaxLength="100"
                                    placeholder="e.g. Mine Stone" />

                                <label class="edit-label">Description</label>
                                <asp:TextBox ID="txtNewStepDesc" runat="server"
                                    CssClass="edit-input edit-textarea"
                                    TextMode="MultiLine" Rows="3"
                                    placeholder="Explain what the player needs to do..." />

                                <label class="edit-label">
                                    Image Path <span class="edit-hint">(optional)</span>
                                </label>
                                <img id="imgStepAddPreview" src="" class="step-img-upload-preview" style="display:none;" />

                                <asp:FileUpload ID="fuNewStepImg" runat="server" CssClass="edit-input" onchange="previewStepImage(this, 'imgStepAddPreview')" />
                                <div class="inline-form-actions" style="margin-top:12px">
                                    <%-- CommandArgument = PartId so the server knows which part to add to --%>
                                    <asp:Button ID="btnSaveNewStep" runat="server"
                                        CommandName="SaveNewStep"
                                        CommandArgument='<%# Eval("PartId") %>'
                                        CssClass="btn-instructor btn-save"
                                        CausesValidation="false"
                                        Text="💾 Save Step" />
                                    <button class="btn-instructor btn-cancel"
                                        onclick="toggleAddStepForm(this); return false;">✖ Cancel</button>
                                </div>
                            </div>
                        </asp:Panel>

                    </div><%-- end .guide-container --%>
                </ItemTemplate>

            </asp:Repeater>

            <%-- "Add Section" button after ALL parts (instructor only) --%>
            <asp:Panel ID="pnlEndAddPart" runat="server" Visible="false" CssClass="end-add-part-row">
                <button class="btn-instructor btn-add"
                    onclick="showAddPartForm(); return false;">＋ Add New Section</button>
            </asp:Panel>

            <%-- ═══════════════════════════════════════════════════════════════════
                 CRAFTING RECIPES SECTION  (data-driven, instructor-editable)
            ═══════════════════════════════════════════════════════════════════ --%>
            <div class="guide-container crafting-section" id="crafting-recipes">

                <%-- Header row: title | search box | [instructor ＋ button] --%>
                <div class="crafting-header-row">
                    <h2 class="section-title" style="border-bottom:none;padding-bottom:0;margin:0;font-size:2rem;">
                        Essential Crafting Recipes
                    </h2>

                    <div class="crafting-header-controls">
                        <div class="crafting-search-wrap">
                            <span class="search-icon">🔍</span>
                            <input type="text" id="craftingSearch"
                                   class="crafting-search-input"
                                   placeholder="Search recipes..."
                                   oninput="filterRecipes(this.value)" />
                        </div>

                        <%-- ＋ Add Recipe button — instructors only --%>
                        <asp:Panel ID="pnlAddRecipeBtn" runat="server" Visible="false">
                            <button class="btn-instructor btn-add"
                                onclick="showAddRecipeForm(); return false;">＋ Add Recipe</button>
                        </asp:Panel>
                    </div>
                </div>

                <%-- Mouse-following tooltip (one shared div, repositioned by JS) --%>
                <div id="recipeTooltip" class="recipe-tooltip" style="display:none;">
                    <img id="tooltipImg" src="" alt="" class="tooltip-big-img" />
                    <p id="tooltipName" class="tooltip-name"></p>
                    <p id="tooltipDesc" class="tooltip-desc"></p>
                </div>

                <p id="noRecipesMsg" class="no-recipes-msg" style="display:none;">
                    No recipes found matching your search.
                </p>

                <%-- Outer repeater — one block per category --%>
                <asp:Repeater ID="rptCraftingCategories" runat="server"
                    OnItemDataBound="rptCraftingCategories_ItemDataBound">
                    <ItemTemplate>
                        <div class="crafting-category"
                             data-category='<%# Eval("CategoryName") %>'>

                            <h3 class="crafting-category-title"><%# Eval("CategoryName") %></h3>

                            <div class="recipe-grid">
                                <%-- Inner repeater — one card per recipe --%>
                                <asp:Repeater ID="rptRecipes" runat="server"
                                    OnItemDataBound="rptRecipes_ItemDataBound"
                                    OnItemCommand="rptRecipes_ItemCommand">
                                    <ItemTemplate>

                                        <div class="recipe-card"
                                             data-name='<%# Eval("RecipeName") %>'
                                             data-img='<%# ResolveUrl(Eval("RecipeImagePath").ToString()) %>'
                                             data-desc='<%# Eval("Description") %>'
                                             onmouseenter="showRecipeTooltip(event, this)"
                                             onmousemove="moveRecipeTooltip(event)"
                                             onmouseleave="hideRecipeTooltip()">

                                            <%-- Pencil + delete overlay — instructors only,
                                                 fades in on card hover via CSS.
                                                 data-* attrs carry all info JS needs to
                                                 pre-fill the edit form. --%>
                                            <asp:Panel ID="pnlRecipeControls" runat="server"
                                                Visible="false" CssClass="recipe-instructor-overlay">
                                                <button class="recipe-edit-btn"
                                                    data-recipeid='<%# Eval("RecipeId") %>'
                                                    data-categoryid='<%# Eval("CategoryId") %>'
                                                    data-name='<%# Eval("RecipeName") %>'
                                                    data-desc='<%# Eval("Description") %>'
                                                    data-thumbpath='<%# Eval("ThumbnailPath") %>'
                                                    data-recipepath='<%# Eval("RecipeImagePath") %>'
                                                    data-thumburl='<%# ResolveUrl(Eval("ThumbnailPath").ToString()) %>'
                                                    data-recipeurl='<%# ResolveUrl(Eval("RecipeImagePath").ToString()) %>'
                                                    onclick="showEditRecipeForm(this); return false;"
                                                    title="Edit recipe">✏️</button>
                                                <asp:Button CommandName="DeleteRecipe"
                                                    CommandArgument='<%# Eval("RecipeId") %>'
                                                    CssClass="recipe-delete-btn"
                                                    CausesValidation="false" Text="🗑️"
                                                    OnClientClick="return confirm('Delete this recipe?');"
                                                    runat="server" />
                                            </asp:Panel>

                                            <div class="recipe-thumb-wrap">
                                                <img src='<%# ResolveUrl(Eval("ThumbnailPath").ToString()) %>'
                                                     alt='<%# Eval("RecipeName") %>'
                                                     class="recipe-thumb" />
                                            </div>
                                            <span class="recipe-name"><%# Eval("RecipeName") %></span>

                                        </div><%-- end .recipe-card --%>

                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>

                        </div><%-- end .crafting-category --%>
                    </ItemTemplate>
                </asp:Repeater>

            </div><%-- end .crafting-section --%>

            <section class="discussion-section" id="discussion-section">
                <span class="section-label">Player Discussions</span>
                <div class="content-box">
            
                    <%-- Comment list --%>
                    <asp:Repeater ID="rptComments" runat="server">
                        <ItemTemplate>
                            <div class="comment-item">
                                <div class="comment-header">
                                    <div class="comment-meta">
                                        <strong class="comment-user"><%# Eval("Username") %></strong> 
                                        <span class="comment-date">- <%# Eval("CommentDate", "{0:yyyy-MM-dd HH:mm}") %></span>
                                    </div>
                            
                                    <asp:LinkButton ID="lnkReport" runat="server" 
                                        CssClass="btn-report"
                                        Text="[ REPORT ]" 
                                        CommandArgument='<%# String.Format("{0}|{1}", Eval("CommentId"), Request.QueryString["id"]) %>' 
                                        OnCommand="lnkReport_Command"
                                        OnClientClick="return confirm('Are you sure you want to report this comment?');"
                                        Visible='<%# Session["userId"] != null %>' />
                                </div>
                                <p class="comment-text"><%# Eval("CommentText") %></p>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <%-- Post a comment --%>
                    <asp:Panel ID="pnlAddComment" runat="server" Visible="false" CssClass="add-comment-panel">
                        <h4>ADD YOUR THOUGHTS</h4>
                        <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Rows="4" 
                            CssClass="comment-input" placeholder="Type your comment here..." />
                
                        <asp:Button ID="btnSubmitComment" runat="server" Text="POST COMMENT" 
                            OnClick="btnSubmitComment_Click" CssClass="btn-submit-comment" href="#txtComment"/>
                    </asp:Panel>

                    <asp:Literal ID="litVisitorMsg" runat="server" />
                </div>
            </section>

        </div><%-- end .all-guides-wrapper --%>
    </div><%-- end .page-layout --%>

</asp:Content>