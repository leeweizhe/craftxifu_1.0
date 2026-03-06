using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAssignment.Lee_Wei_Zhe.aspx
{
    public partial class BeginnerGuide : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        // ══════════════════════════════════════════════════════════════════
        // PAGE LOAD
        // ══════════════════════════════════════════════════════════════════
        protected void Page_Load(object sender, EventArgs e)
        {
            // !IsPostBack means "only run this on the FIRST load, not after button clicks"
            if (!IsPostBack)
            {
                LoadGuideParts();
                LoadPartPositionDropdown(); // fill the "Insert Position" dropdown in Add Part form
                LoadCraftingRecipes();      // fill the crafting recipes section
                LoadComments("1");
                CheckCommentPermission();

                bool instructor = IsInstructor();

                // Show/hide instructor-only panels
                pnlAddPartOverlay.Visible = instructor;
                pnlSidebarAddPart.Visible = instructor;
                pnlEndAddPart.Visible = instructor;
                pnlRecipeFormOverlay.Visible = instructor;   // recipe add/edit overlay
                pnlAddRecipeBtn.Visible = instructor;   // ＋ Add Recipe button

                // Inject a JS variable so the client-side script knows the user is an instructor.
                // RegisterStartupScript adds a <script> block that runs after the page loads.
                if (instructor)
                {
                    ClientScript.RegisterStartupScript(
                        GetType(), "instructorMode", "window.isInstructor = true;", true);
                    LoadRecipeCategoryDropdown(); // populate the <select> in the recipe overlay
                }
            }
        }

        // ══════════════════════════════════════════════════════════════════
        // HELPER: Is the logged-in user an Instructor?
        // ══════════════════════════════════════════════════════════════════
        private bool IsInstructor()
        {
            // Session always returns object, so we must .ToString() before comparing
            return Session["userRole"] != null &&
                   Session["userRole"].ToString() == "Instructor";
        }

        // ══════════════════════════════════════════════════════════════════
        // LOAD: Fetch all parts and bind to the repeaters
        // ══════════════════════════════════════════════════════════════════
        private void LoadGuideParts()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT PartId, PartTitle FROM BGuidePart ORDER BY PartOrder ASC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);

                    // DataBind() triggers ItemDataBound for each row
                    rptGuideParts.DataSource = dt;
                    rptGuideParts.DataBind();

                    rptMenu.DataSource = dt;
                    rptMenu.DataBind();
                }
            }
        }

        // ══════════════════════════════════════════════════════════════════
        // LOAD: Fill the "Insert Position" dropdown in the Add Part overlay
        // ══════════════════════════════════════════════════════════════════
        private void LoadPartPositionDropdown()
        {
            ddlPartPosition.Items.Clear();
            ddlPartPosition.Items.Add(new ListItem("At the very beginning", "0"));

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT PartTitle, PartOrder FROM BGuidePart ORDER BY PartOrder ASC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        int index = 1;
                        while (reader.Read())
                        {
                            ddlPartPosition.Items.Add(new ListItem(
                                "After Part " + index + ": " + reader["PartTitle"],
                                reader["PartOrder"].ToString()
                            ));
                            index++;
                        }
                    }
                }
            }
        }

        // ══════════════════════════════════════════════════════════════════
        // ITEMDATABOUND (outer repeater)
        // Fires once per part row while the repeater is being built.
        // This is where we load steps from DB and toggle instructor panels.
        // ══════════════════════════════════════════════════════════════════
        protected void rptGuideParts_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            // Skip Header/Footer/Separator — only process actual data rows
            if (e.Item.ItemType != ListItemType.Item &&
                e.Item.ItemType != ListItemType.AlternatingItem) return;

            // FindControl looks inside THIS repeater row only
            HiddenField hfPartId = (HiddenField)e.Item.FindControl("hfPartId");
            Repeater rptSteps = (Repeater)e.Item.FindControl("rptSteps");
            Panel pnlPartControls = (Panel)e.Item.FindControl("pnlPartControls");
            Panel pnlPartTitleEdit = (Panel)e.Item.FindControl("pnlPartTitleEdit");
            Panel pnlAddStep = (Panel)e.Item.FindControl("pnlAddStep");

            int currentPartId = Convert.ToInt32(hfPartId.Value);
            bool instructor = IsInstructor();

            // Toggle instructor-only panels for this part
            if (pnlPartControls != null) pnlPartControls.Visible = instructor;
            if (pnlPartTitleEdit != null) pnlPartTitleEdit.Visible = instructor;
            if (pnlAddStep != null) pnlAddStep.Visible = instructor;

            // Load steps for this specific part from DB
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"SELECT StepId, StepTitle, StepDescription, ImagePath
                                 FROM BGuideStep
                                 WHERE PartId = @PartId
                                 ORDER BY StepOrder ASC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@PartId", currentPartId);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dtSteps = new DataTable();
                        sda.Fill(dtSteps);

                        // DataBind() here triggers rptSteps_ItemDataBound for each step
                        rptSteps.DataSource = dtSteps;
                        rptSteps.DataBind();
                    }
                }
            }
        }

        // ══════════════════════════════════════════════════════════════════
        // ITEMDATABOUND (inner repeater)
        // Fires once per step row. We use it to toggle the edit panels.
        // ══════════════════════════════════════════════════════════════════
        protected void rptSteps_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item &&
                e.Item.ItemType != ListItemType.AlternatingItem) return;

            Panel pnlEditControls = (Panel)e.Item.FindControl("pnlEditControls");
            Panel pnlStepEdit = (Panel)e.Item.FindControl("pnlStepEdit");

            bool instructor = IsInstructor();

            // Show edit/delete buttons only for instructors
            if (pnlEditControls != null) pnlEditControls.Visible = instructor;

            // Render the edit form only for instructors (keeps HTML cleaner for members)
            if (pnlStepEdit != null) pnlStepEdit.Visible = instructor;
        }

        // ══════════════════════════════════════════════════════════════════
        // ITEMCOMMAND (outer repeater)
        // Fires when a button inside the OUTER repeater is clicked.
        // Handles: SavePart, DeletePart, SaveNewStep
        // ══════════════════════════════════════════════════════════════════
        protected void rptGuideParts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // Always verify on the server — never trust the UI alone
            if (!IsInstructor()) return;

            // Get the PartId from the HiddenField inside this repeater row
            int partId = Convert.ToInt32(
                ((HiddenField)e.Item.FindControl("hfPartId")).Value);

            switch (e.CommandName)
            {
                case "SavePart":
                    // Instructor edited the part title inline — save it
                    TextBox txtEditPartTitle = (TextBox)e.Item.FindControl("txtEditPartTitle");
                    if (txtEditPartTitle != null && !string.IsNullOrWhiteSpace(txtEditPartTitle.Text))
                    {
                        UpdatePartTitle(partId, txtEditPartTitle.Text.Trim());
                    }
                    // Redirect back, scrolling to this part's section
                    Response.Redirect("BeginnerGuide.aspx#part-" + partId);
                    break;

                case "DeletePart":
                    DeletePart(partId);
                    Response.Redirect("BeginnerGuide.aspx");
                    break;

                case "SaveNewStep":
                    // Inline "Add Step" form was submitted — add step at bottom of this part
                    TextBox txtTitle = (TextBox)e.Item.FindControl("txtNewStepTitle");
                    TextBox txtDesc = (TextBox)e.Item.FindControl("txtNewStepDesc");
                    FileUpload fuNewImg = (FileUpload)e.Item.FindControl("fuNewStepImg");

                    // Upload image if one was chosen; otherwise leave path null
                    string newImgPath = null;
                    if (fuNewImg != null && fuNewImg.HasFile)
                        newImgPath = SaveStepImage(fuNewImg);

                    if (txtTitle != null && !string.IsNullOrWhiteSpace(txtTitle.Text))
                    {
                        InsertStepAtEnd(
                            partId,
                            txtTitle.Text.Trim(),
                            txtDesc?.Text.Trim() ?? "",
                            newImgPath
                        );
                    }
                    Response.Redirect("BeginnerGuide.aspx#part-" + partId);
                    break;
            }
        }

        // ══════════════════════════════════════════════════════════════════
        // ITEMCOMMAND (inner repeater)
        // Fires when a button inside the INNER repeater (steps) is clicked.
        // Handles: SaveStep, DeleteStep
        // ══════════════════════════════════════════════════════════════════
        protected void rptSteps_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (!IsInstructor()) return;

            int stepId = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "SaveStep":
                    // Find the textboxes and new controls inside this specific step card
                    TextBox txtTitle = (TextBox)e.Item.FindControl("txtEditTitle");
                    TextBox txtDesc = (TextBox)e.Item.FindControl("txtEditDescription");
                    HiddenField hfCurrentImg = (HiddenField)e.Item.FindControl("hfCurrentStepImg");
                    FileUpload fuEditImg = (FileUpload)e.Item.FindControl("fuEditStepImg");

                    // Keep the existing image path unless a new file was uploaded
                    string editImgPath = hfCurrentImg?.Value;
                    if (fuEditImg != null && fuEditImg.HasFile)
                        editImgPath = SaveStepImage(fuEditImg);

                    if (txtTitle != null && !string.IsNullOrWhiteSpace(txtTitle.Text))
                    {
                        int partId = GetPartIdByStepId(stepId);
                        UpdateStep(stepId, txtTitle.Text.Trim(), txtDesc?.Text.Trim() ?? "", editImgPath);
                        Response.Redirect("BeginnerGuide.aspx#part-" + partId);
                    }
                    break;

                case "DeleteStep":
                    int pId = GetPartIdByStepId(stepId); // get partId BEFORE deleting
                    DeleteStep(stepId, pId);
                    Response.Redirect("BeginnerGuide.aspx#part-" + pId);
                    break;
            }
        }

        // ══════════════════════════════════════════════════════════════════
        // BUTTON CLICK: Save new part from the overlay form
        // This button is outside the repeater so it's a regular event handler
        // ══════════════════════════════════════════════════════════════════
        protected void btnSaveNewPart_Click(object sender, EventArgs e)
        {
            if (!IsInstructor()) return;
            if (!Page.IsValid) return;

            int insertAfterOrder = Convert.ToInt32(ddlPartPosition.SelectedValue);
            int newOrder = insertAfterOrder + 1;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                // Push existing parts down by 1 to make room
                using (SqlCommand cmd = new SqlCommand(
                    "UPDATE BGuidePart SET PartOrder = PartOrder + 1 WHERE PartOrder >= @NewOrder", conn))
                {
                    cmd.Parameters.AddWithValue("@NewOrder", newOrder);
                    cmd.ExecuteNonQuery();
                }

                // Insert new part at the chosen position
                using (SqlCommand cmd = new SqlCommand(
                    "INSERT INTO BGuidePart (PartTitle, PartOrder) VALUES (@PartTitle, @PartOrder)", conn))
                {
                    cmd.Parameters.AddWithValue("@PartTitle", txtNewPartTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@PartOrder", newOrder);
                    cmd.ExecuteNonQuery();
                }

                // Clean up the order numbers (removes any gaps)
                ReorderParts(conn);
            }

            Response.Redirect("BeginnerGuide.aspx");
        }

        // ══════════════════════════════════════════════════════════════════
        // DB HELPERS
        // ══════════════════════════════════════════════════════════════════

        // ══════════════════════════════════════════════════════════════════
        // HELPER: Save an uploaded step image to disk, return the URL path
        // Saves to /Lee Wei Zhe/images/guide/ so the src works directly
        // in an <img> tag without needing ResolveUrl.
        // Returns null on bad extension (caller can treat null as no change).
        // ══════════════════════════════════════════════════════════════════
        private string SaveStepImage(FileUpload fu)
        {
            string ext = Path.GetExtension(fu.FileName).ToLower();
            string[] allowed = { ".png", ".jpg", ".jpeg", ".gif", ".webp" };
            bool ok = false;
            foreach (string a in allowed) if (ext == a) { ok = true; break; }
            if (!ok) return null;

            // Build the physical folder path; create it if it doesn't exist yet
            string virtualFolder = "/Lee Wei Zhe/images/guide/";
            string physicalFolder = Server.MapPath("~" + virtualFolder);
            if (!Directory.Exists(physicalFolder))
                Directory.CreateDirectory(physicalFolder);

            // GUID filename avoids collisions and keeps filenames safe
            string fileName = Guid.NewGuid().ToString("N") + ext;
            fu.SaveAs(Path.Combine(physicalFolder, fileName));

            return virtualFolder + fileName; // root-relative URL, usable directly as img src
        }

        private void UpdateStep(int stepId, string title, string desc, string imagePath)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            using (SqlCommand cmd = new SqlCommand(
                @"UPDATE BGuideStep 
                  SET StepTitle = @Title, StepDescription = @Desc, ImagePath = @Img 
                  WHERE StepId = @StepId", conn))
            {
                cmd.Parameters.AddWithValue("@Title", title);
                cmd.Parameters.AddWithValue("@Desc", desc);
                // If image path is empty, store NULL in DB instead of empty string
                cmd.Parameters.AddWithValue("@Img",
                    string.IsNullOrEmpty(imagePath) ? (object)DBNull.Value : imagePath);
                cmd.Parameters.AddWithValue("@StepId", stepId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void UpdatePartTitle(int partId, string title)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            using (SqlCommand cmd = new SqlCommand(
                "UPDATE BGuidePart SET PartTitle = @Title WHERE PartId = @PartId", conn))
            {
                cmd.Parameters.AddWithValue("@Title", title);
                cmd.Parameters.AddWithValue("@PartId", partId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void InsertStepAtEnd(int partId, string title, string desc, string imagePath)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                // Find the current highest step number in this part
                int maxOrder = 0;
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT ISNULL(MAX(StepOrder), 0) FROM BGuideStep WHERE PartId = @PartId", conn))
                {
                    cmd.Parameters.AddWithValue("@PartId", partId);
                    maxOrder = Convert.ToInt32(cmd.ExecuteScalar());
                }

                // Insert after the last step
                using (SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO BGuideStep (PartId, StepTitle, StepDescription, ImagePath, StepOrder)
                    VALUES (@PartId, @Title, @Desc, @Img, @Order)", conn))
                {
                    cmd.Parameters.AddWithValue("@PartId", partId);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Desc", desc);
                    cmd.Parameters.AddWithValue("@Img",
                        string.IsNullOrEmpty(imagePath) ? (object)DBNull.Value : imagePath);
                    cmd.Parameters.AddWithValue("@Order", maxOrder + 1);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void DeleteStep(int stepId, int partId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(
                    "DELETE FROM BGuideStep WHERE StepId = @StepId", conn))
                {
                    cmd.Parameters.AddWithValue("@StepId", stepId);
                    cmd.ExecuteNonQuery();
                }
                ReorderSteps(conn, partId); // renumber remaining steps
            }
        }

        private void DeletePart(int partId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                // Must delete child steps FIRST due to the foreign key constraint
                using (SqlCommand cmd = new SqlCommand(
                    "DELETE FROM BGuideStep WHERE PartId = @PartId", conn))
                {
                    cmd.Parameters.AddWithValue("@PartId", partId);
                    cmd.ExecuteNonQuery();
                }
                using (SqlCommand cmd = new SqlCommand(
                    "DELETE FROM BGuidePart WHERE PartId = @PartId", conn))
                {
                    cmd.Parameters.AddWithValue("@PartId", partId);
                    cmd.ExecuteNonQuery();
                }
                ReorderParts(conn);
            }
        }

        // Needed to get the PartId when a step command fires (for redirect anchor)
        private int GetPartIdByStepId(int stepId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT PartId FROM BGuideStep WHERE StepId = @StepId", conn))
            {
                cmd.Parameters.AddWithValue("@StepId", stepId);
                conn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        // Renumber steps within a part: 1, 2, 3... (no gaps after deletion)
        private void ReorderSteps(SqlConnection conn, int partId)
        {
            string query = @"
                WITH Reordered AS (
                    SELECT StepId, ROW_NUMBER() OVER (ORDER BY StepOrder) AS NewOrder
                    FROM BGuideStep WHERE PartId = @PartId
                )
                UPDATE BGuideStep
                SET StepOrder = Reordered.NewOrder
                FROM BGuideStep JOIN Reordered ON BGuideStep.StepId = Reordered.StepId";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@PartId", partId);
                cmd.ExecuteNonQuery();
            }
        }

        // ══════════════════════════════════════════════════════════════════
        // LOAD: Fetch crafting categories and bind to rptCraftingCategories
        // ══════════════════════════════════════════════════════════════════
        private void LoadCraftingRecipes()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT CategoryId, CategoryName FROM CraftingCategory ORDER BY CategoryOrder ASC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    rptCraftingCategories.DataSource = dt;
                    rptCraftingCategories.DataBind();
                }
            }
        }

        // ══════════════════════════════════════════════════════════════════
        // ITEMDATABOUND: Load recipes for each category row
        // ══════════════════════════════════════════════════════════════════
        protected void rptCraftingCategories_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item &&
                e.Item.ItemType != ListItemType.AlternatingItem) return;

            DataRowView row = (DataRowView)e.Item.DataItem;
            int categoryId = Convert.ToInt32(row["CategoryId"]);

            Repeater rptRecipes = (Repeater)e.Item.FindControl("rptRecipes");
            if (rptRecipes == null) return;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                // CategoryId is included so the edit button's data-* attrs can carry it
                string query = @"SELECT RecipeId, CategoryId, RecipeName,
                                        ThumbnailPath, RecipeImagePath, Description
                                 FROM CraftingRecipe
                                 WHERE CategoryId = @CategoryId
                                 ORDER BY RecipeOrder ASC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        rptRecipes.DataSource = dt;
                        rptRecipes.DataBind();
                    }
                }
            }
        }

        // ══════════════════════════════════════════════════════════════════
        // ITEMDATABOUND (inner recipe repeater)
        // Toggles the pencil/delete overlay per card for instructors.
        // ══════════════════════════════════════════════════════════════════
        protected void rptRecipes_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item &&
                e.Item.ItemType != ListItemType.AlternatingItem) return;

            Panel pnlRecipeControls = (Panel)e.Item.FindControl("pnlRecipeControls");
            if (pnlRecipeControls != null)
                pnlRecipeControls.Visible = IsInstructor();
        }

        // ══════════════════════════════════════════════════════════════════
        // ITEMCOMMAND (inner recipe repeater) — handles DeleteRecipe
        // ══════════════════════════════════════════════════════════════════
        protected void rptRecipes_ItemCommand(object sender, RepeaterCommandEventArgs e)
        {
            if (!IsInstructor()) return;

            if (e.CommandName == "DeleteRecipe")
            {
                int recipeId = Convert.ToInt32(e.CommandArgument);
                using (SqlConnection conn = new SqlConnection(connString))
                using (SqlCommand cmd = new SqlCommand(
                    "DELETE FROM CraftingRecipe WHERE RecipeId = @Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", recipeId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                Response.Redirect("BeginnerGuide.aspx#crafting-recipes");
            }
        }

        // ══════════════════════════════════════════════════════════════════
        // BUTTON CLICK: Save recipe (Add OR Edit)
        // Mode is carried by hfRecipeFormMode hidden field set by JS.
        // ══════════════════════════════════════════════════════════════════
        protected void btnSaveRecipe_Click(object sender, EventArgs e)
        {
            if (!IsInstructor()) return;

            string mode = hfRecipeFormMode.Value.Trim();
            int recipeId = Convert.ToInt32(hfEditRecipeId.Value);
            string name = txtRecipeName.Text.Trim();
            string desc = txtRecipeDescription.Text.Trim();
            int catId = Convert.ToInt32(ddlRecipeCategory.SelectedValue);

            if (string.IsNullOrEmpty(name))
            {
                ShowRecipeError("Recipe name is required."); return;
            }

            // ── Thumbnail ─────────────────────────────────────────────────
            // Keep existing path unless a new file was uploaded
            string thumbPath = hfCurrentThumbPath.Value;
            if (fileUploadThumb.HasFile)
            {
                string saved = SaveRecipeImage(fileUploadThumb, "thumb");
                if (saved == null) { ShowRecipeError("Thumbnail must be .png, .jpg, .jpeg, .gif or .webp."); return; }
                thumbPath = saved;
            }

            // ── Recipe image ──────────────────────────────────────────────
            string recipePath = hfCurrentRecipePath.Value;
            if (fileUploadRecipeImg.HasFile)
            {
                string saved = SaveRecipeImage(fileUploadRecipeImg, "full");
                if (saved == null) { ShowRecipeError("Recipe image must be .png, .jpg, .jpeg, .gif or .webp."); return; }
                recipePath = saved;
            }

            // Both images required on new insert
            if (mode == "add" && (string.IsNullOrEmpty(thumbPath) || string.IsNullOrEmpty(recipePath)))
            {
                ShowRecipeError("Please upload both the thumbnail and the recipe image."); return;
            }

            if (mode == "add")
                InsertRecipeDB(catId, name, thumbPath, recipePath, desc);
            else
                UpdateRecipeDB(recipeId, catId, name, thumbPath, recipePath, desc);

            // Reload and close the overlay
            LoadCraftingRecipes();
            LoadRecipeCategoryDropdown();
            ClientScript.RegisterStartupScript(GetType(), "closeRecipeForm", "hideRecipeForm();", true);
        }

        // ── Recipe helpers ────────────────────────────────────────────────

        private void ShowRecipeError(string msg)
        {
            lblRecipeError.Text = msg;
            lblRecipeError.Visible = true;
            // Re-open the overlay after postback so the user can fix the error
            ClientScript.RegisterStartupScript(GetType(), "reopenRecipeForm",
                "document.getElementById('recipeFormOverlay').style.display='flex';", true);
            LoadCraftingRecipes();
            LoadRecipeCategoryDropdown();
        }

        /// <summary>
        /// Saves an uploaded recipe image to ~/Lee Wei Zhe/images/recipes/{subfolder}/
        /// Returns the tilde-path stored in the DB, or null on a bad extension.
        /// </summary>
        private string SaveRecipeImage(FileUpload fu, string subfolder)
        {
            string ext = Path.GetExtension(fu.FileName).ToLower();
            string[] allowed = { ".png", ".jpg", ".jpeg", ".gif", ".webp" };
            bool ok = false;
            foreach (string a in allowed) if (ext == a) { ok = true; break; }
            if (!ok) return null;

            string virtualFolder = "~/Lee Wei Zhe/images/recipes/" + subfolder + "/";
            string physicalFolder = Server.MapPath(virtualFolder);
            if (!Directory.Exists(physicalFolder))
                Directory.CreateDirectory(physicalFolder);

            string fileName = Guid.NewGuid().ToString("N") + ext;
            fu.SaveAs(Path.Combine(physicalFolder, fileName));
            return virtualFolder + fileName;
        }

        private void InsertRecipeDB(int catId, string name, string thumb, string recipe, string desc)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                int maxOrder = 0;
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT ISNULL(MAX(RecipeOrder), 0) FROM CraftingRecipe WHERE CategoryId = @CatId", conn))
                {
                    cmd.Parameters.AddWithValue("@CatId", catId);
                    maxOrder = Convert.ToInt32(cmd.ExecuteScalar());
                }
                using (SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO CraftingRecipe
                        (CategoryId, RecipeName, ThumbnailPath, RecipeImagePath, Description, RecipeOrder)
                    VALUES (@CatId, @Name, @Thumb, @Recipe, @Desc, @Order)", conn))
                {
                    cmd.Parameters.AddWithValue("@CatId", catId);
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Thumb", thumb);
                    cmd.Parameters.AddWithValue("@Recipe", recipe);
                    cmd.Parameters.AddWithValue("@Desc", desc);
                    cmd.Parameters.AddWithValue("@Order", maxOrder + 1);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void UpdateRecipeDB(int id, int catId, string name, string thumb, string recipe, string desc)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            using (SqlCommand cmd = new SqlCommand(@"
                UPDATE CraftingRecipe
                SET CategoryId = @CatId, RecipeName = @Name,
                    ThumbnailPath = @Thumb, RecipeImagePath = @Recipe, Description = @Desc
                WHERE RecipeId = @Id", conn))
            {
                cmd.Parameters.AddWithValue("@CatId", catId);
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@Thumb", thumb);
                cmd.Parameters.AddWithValue("@Recipe", recipe);
                cmd.Parameters.AddWithValue("@Desc", desc);
                cmd.Parameters.AddWithValue("@Id", id);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        /// <summary>
        /// Populates ddlRecipeCategory inside the recipe add/edit overlay.
        /// </summary>
        private void LoadRecipeCategoryDropdown()
        {
            ddlRecipeCategory.Items.Clear();
            using (SqlConnection conn = new SqlConnection(connString))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT CategoryId, CategoryName FROM CraftingCategory ORDER BY CategoryOrder ASC", conn))
            {
                conn.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                    while (r.Read())
                        ddlRecipeCategory.Items.Add(
                            new ListItem(r["CategoryName"].ToString(), r["CategoryId"].ToString()));
            }
        }

        // Renumber all parts: 1, 2, 3... (no gaps after deletion/insertion)
        private void ReorderParts(SqlConnection conn)
        {
            string query = @"
                WITH Reordered AS (
                    SELECT PartId, ROW_NUMBER() OVER (ORDER BY PartOrder) AS NewOrder
                    FROM BGuidePart
                )
                UPDATE BGuidePart
                SET PartOrder = Reordered.NewOrder
                FROM BGuidePart JOIN Reordered ON BGuidePart.PartId = Reordered.PartId";

            using (SqlCommand cmd = new SqlCommand(query, conn))
                cmd.ExecuteNonQuery();
        }

        private void CheckCommentPermission()
        {
            if (Session["userId"] != null)
            {
                pnlAddComment.Visible = true;
                litVisitorMsg.Text = "";
            }
            else
            {
                pnlAddComment.Visible = false;
                litVisitorMsg.Text = "<p style='color: #fbbf24; text-align: center;'>[ <a href='Login.aspx' style='color: #68ff00;'>Login</a> to join the discussion ]</p>";
            }
        }
        private void LoadComments(string farmId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = @"SELECT c.*, u.Username FROM BGCommentTable c 
                               JOIN userTable u ON c.UserId = u.UserId 
                               WHERE c.FarmId = @fid ORDER BY c.CommentDate DESC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@fid", farmId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptComments.DataSource = dt;
                rptComments.DataBind();
            }
        }

        protected void btnSubmitComment_Click(object sender, EventArgs e)
        {
            string farmId = "1";
            string commentText = txtComment.Text.Trim();

            if (!string.IsNullOrEmpty(commentText) && Session["userId"] != null)
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string sql = "INSERT INTO BGCommentTable (FarmId, UserId, CommentText) VALUES (@fid, @uid, @text)";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@fid", farmId);
                    cmd.Parameters.AddWithValue("@uid", Session["userId"]);
                    cmd.Parameters.AddWithValue("@text", commentText);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
                txtComment.Text = "";
                LoadComments(farmId);
            }
        }

        protected void lnkReport_Command(object sender, CommandEventArgs e)
        {
            if (Session["userId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // Split the combined argument (CommentId|FarmID)
            string[] args = e.CommandArgument.ToString().Split('|');

            if (args.Length < 2) return; // Safety check

            string commentId = args[0];
            string farmId = args[1];
            string reporterId = Session["userId"].ToString();

            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    // Make sure your table has a FarmID column!
                    string sql = "INSERT INTO reportTable (CommentId, ReporterId, FarmID) VALUES (@cid, @rid, @fid)";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@cid", commentId);
                    cmd.Parameters.AddWithValue("@rid", reporterId);
                    cmd.Parameters.AddWithValue("@fid", farmId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Report submitted successfully.');", true);
            }
            catch (Exception ex)
            {
                // Optional: Log error
            }

        }
    }
}