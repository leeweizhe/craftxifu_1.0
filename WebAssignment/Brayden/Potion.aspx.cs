using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace WebAssignment.Brayden
{
    public partial class Potion : System.Web.UI.Page
    {
        private string ConnStr
        {
            get { return ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
        }

        private bool IsAdmin()
        {
            return Session["role"] != null && Session["role"].ToString().ToLower() == "admin";
        }

        private bool IsInstructor()
        {
            string userRole = Session["UserRole"] as string;
            return !string.IsNullOrEmpty(userRole) && userRole == "Instructor";
        }

        // ─────────────────────────────────────────────
        // Helpers
        // ─────────────────────────────────────────────
        public string GetCategoryColor(string cat)
        {
            switch (cat)
            {
                case "Positive": return "#2ecc71";
                case "Negative": return "#e74c3c";
                default:         return "#f39c12";
            }
        }

        public string GetCategoryIcon(string cat)
        {
            switch (cat)
            {
                case "Positive": return "\uD83D\uDFE2";
                case "Negative": return "\uD83D\uDD34";
                default:         return "\uD83D\uDFE1";
            }
        }

        public string GetCategoryActiveClass(string category)
        {
            return ViewState["CurrentCategory"] != null && ViewState["CurrentCategory"].ToString() == category ? " active" : "";
        }

        public string GetCategorySidebarStyle(string category)
        {
            bool isActive = ViewState["CurrentCategory"] != null && ViewState["CurrentCategory"].ToString() == category;
            string color = GetCategoryColor(category);
            if (isActive)
                return "border-color:" + color + "; color:" + color + "; box-shadow:inset 3px 0 0 " + color + ";";
            return "";
        }

        public string GetPaginationActiveClass(object itemId)
        {
            return ViewState["CurrentPotionId"] != null && ViewState["CurrentPotionId"].ToString() == itemId.ToString() ? " active" : "";
        }

        public int CurrentPotionId
        {
            get { return ViewState["CurrentPotionId"] != null ? Convert.ToInt32(ViewState["CurrentPotionId"]) : 0; }
        }

        // ─────────────────────────────────────────────
        // Page Load
        // ─────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                mainPanel.Visible = true;
                editPanel.Visible = false;
                addPanel.Visible  = false;
                LoadCategories();
                AutoSelectFirst();
            }
        }

        private void LoadCategories()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string sql = "SELECT DISTINCT Category FROM potionTable ORDER BY Category";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                categoryRepeater.DataSource = dt;
                categoryRepeater.DataBind();
            }
        }

        private void AutoSelectFirst()
        {
            string firstCategory = null;
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                SqlCommand catCmd = new SqlCommand(
                    "SELECT TOP 1 Category FROM potionTable ORDER BY Category", conn);
                conn.Open();
                object catObj = catCmd.ExecuteScalar();
                if (catObj != null)
                    firstCategory = catObj.ToString();
            }

            if (firstCategory != null)
            {
                ViewState["CurrentCategory"] = firstCategory;
                LoadCategoryContent(firstCategory);
            }
            else
            {
                contentPanel.Visible = false;
                emptyPanel.Visible = true;
            }
        }

        // ─────────────────────────────────────────────
        // Load all items for a category
        // ─────────────────────────────────────────────
        private void LoadCategoryContent(string category)
        {
            DataTable dt;
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string sql = "SELECT PotionId, Name, Thumbnail FROM potionTable WHERE Category = @cat ORDER BY Name";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@cat", category);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                dt = new DataTable();
                da.Fill(dt);
            }

            if (dt.Rows.Count > 0)
            {
                paginationRepeater.DataSource = dt;
                paginationRepeater.DataBind();

                int currentId = ViewState["CurrentPotionId"] != null ? Convert.ToInt32(ViewState["CurrentPotionId"]) : 0;
                bool found = false;
                foreach (DataRow row in dt.Rows)
                {
                    if (Convert.ToInt32(row["PotionId"]) == currentId) { found = true; break; }
                }
                if (!found)
                {
                    currentId = Convert.ToInt32(dt.Rows[0]["PotionId"]);
                    ViewState["CurrentPotionId"] = currentId;
                }

                LoadFlipCard(currentId);
                contentPanel.Visible = true;
                emptyPanel.Visible = false;
            }
            else
            {
                contentPanel.Visible = false;
                emptyPanel.Visible = true;
            }

            LoadCategories();
            btnAddNew.Visible = IsAdmin();
        }

        // ─────────────────────────────────────────────
        // Load flip card content
        // ─────────────────────────────────────────────
        private void LoadFlipCard(int id)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string sql = "SELECT * FROM potionTable WHERE PotionId = @id";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        string name = dr["Name"].ToString();

                        // Front
                        lblDetailName.Text     = name;
                        lblDetailCategory.Text = dr["Category"].ToString();
                        lblDetailType.Text     = dr["PotionType"].ToString();
                        lblFrontDuration.Text  = dr["Duration"].ToString();

                        string detailImg = dr["DetailImage"].ToString();
                        string thumb = dr["Thumbnail"].ToString();
                        if (!string.IsNullOrEmpty(detailImg))
                            imgDetailLarge.ImageUrl = ResolveUrl(detailImg);
                        else if (!string.IsNullOrEmpty(thumb))
                            imgDetailLarge.ImageUrl = ResolveUrl(thumb);

                        // Back
                        lblBackName.Text         = name;
                        lblDetailDesc.Text       = dr["Description"].ToString();
                        lblDetailEffect.Text     = dr["Effect"].ToString();
                        lblDetailDuration.Text   = dr["Duration"].ToString();
                        lblBackType.Text         = dr["PotionType"].ToString();
                        lblDetailBase.Text       = dr["BrewingBase"].ToString();
                        lblDetailIngredient.Text = dr["Ingredient"].ToString();
                        litDetailContent.Text    = dr["FullContent"].ToString();

                        string ingredientImg = dr["IngredientImage"].ToString();
                        if (!string.IsNullOrEmpty(ingredientImg))
                            imgIngredient.ImageUrl = ResolveUrl(ingredientImg);

                        bool canEdit = IsAdmin() || IsInstructor();
                        pnlAdminActions.Visible = canEdit;
                        btnDeletePotion.CommandArgument = id.ToString();
                    }
                }
            }

            LoadComments(id);
            CheckCommentPermission();
        }

        // ─────────────────────────────────────────────
        // Navigation
        // ─────────────────────────────────────────────
        protected void SelectCategory(object sender, EventArgs e)
        {
            string category = ((LinkButton)sender).CommandArgument;
            ViewState["CurrentCategory"] = category;
            ViewState["CurrentPotionId"] = null;
            LoadCategoryContent(category);
        }

        protected void SelectPaginationItem(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(((LinkButton)sender).CommandArgument);
            ViewState["CurrentPotionId"] = id;
            LoadFlipCard(id);

            string category = ViewState["CurrentCategory"] != null ? ViewState["CurrentCategory"].ToString() : "";
            if (!string.IsNullOrEmpty(category))
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string sql = "SELECT PotionId, Name, Thumbnail FROM potionTable WHERE Category = @cat ORDER BY Name";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@cat", category);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    paginationRepeater.DataSource = dt;
                    paginationRepeater.DataBind();
                }
            }
        }

        protected void BackToMain(object sender, EventArgs e)
        {
            mainPanel.Visible = true;
            editPanel.Visible = false;
            addPanel.Visible  = false;
            string category = ViewState["CurrentCategory"] != null ? ViewState["CurrentCategory"].ToString() : "";
            if (!string.IsNullOrEmpty(category))
                LoadCategoryContent(category);
            else
                AutoSelectFirst();
        }

        // ─────────────────────────────────────────────
        // UPDATE – Show edit form
        // ─────────────────────────────────────────────
        protected void ShowEditForm(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(ViewState["CurrentPotionId"]);

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT * FROM potionTable WHERE PotionId = @id", conn);
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        txtEditName.Text              = dr["Name"].ToString();
                        ddlEditCategory.SelectedValue = dr["Category"].ToString();
                        ddlEditType.SelectedValue     = dr["PotionType"].ToString();
                        txtEditDuration.Text          = dr["Duration"].ToString();
                        txtEditEffect.Text            = dr["Effect"].ToString();
                        txtEditBase.Text              = dr["BrewingBase"].ToString();
                        txtEditIngredient.Text        = dr["Ingredient"].ToString();
                        txtEditDesc.Text              = dr["Description"].ToString();
                        txtEditContent.Text           = dr["FullContent"].ToString();
                        txtEditThumbnail.Text         = dr["Thumbnail"].ToString();
                        txtEditDetailImage.Text       = dr["DetailImage"].ToString();
                        txtEditIngredientImage.Text   = dr["IngredientImage"].ToString();
                    }
                }
            }

            mainPanel.Visible = false;
            editPanel.Visible = true;
            addPanel.Visible  = false;
            lblEditError.Text = "";
        }

        // ─────────────────────────────────────────────
        // UPDATE – Save
        // ─────────────────────────────────────────────
        protected void SaveEdit(object sender, EventArgs e)
        {
            if (!IsAdmin()) return;

            int id = Convert.ToInt32(ViewState["CurrentPotionId"]);

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string sql = @"UPDATE potionTable
                               SET Name=@n, Category=@c, PotionType=@pt, Duration=@du,
                                   Effect=@ef, BrewingBase=@bb, Ingredient=@ing,
                                   Description=@d, FullContent=@fc,
                                   Thumbnail=@th, DetailImage=@di, IngredientImage=@ii
                               WHERE PotionId=@id";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@n",   txtEditName.Text.Trim());
                cmd.Parameters.AddWithValue("@c",   ddlEditCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@pt",  ddlEditType.SelectedValue);
                cmd.Parameters.AddWithValue("@du",  txtEditDuration.Text.Trim());
                cmd.Parameters.AddWithValue("@ef",  txtEditEffect.Text.Trim());
                cmd.Parameters.AddWithValue("@bb",  txtEditBase.Text.Trim());
                cmd.Parameters.AddWithValue("@ing", txtEditIngredient.Text.Trim());
                cmd.Parameters.AddWithValue("@d",   txtEditDesc.Text.Trim());
                cmd.Parameters.AddWithValue("@fc",  txtEditContent.Text.Trim());
                cmd.Parameters.AddWithValue("@th",  txtEditThumbnail.Text.Trim());
                cmd.Parameters.AddWithValue("@di",  txtEditDetailImage.Text.Trim());
                cmd.Parameters.AddWithValue("@ii",  txtEditIngredientImage.Text.Trim());
                cmd.Parameters.AddWithValue("@id",  id);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            mainPanel.Visible = true;
            editPanel.Visible = false;
            addPanel.Visible  = false;
            ViewState["CurrentCategory"] = ddlEditCategory.SelectedValue;
            LoadCategoryContent(ddlEditCategory.SelectedValue);
        }

        // ─────────────────────────────────────────────
        // DELETE
        // ─────────────────────────────────────────────
        protected void DeletePotion(object sender, EventArgs e)
        {
            if (!IsAdmin()) return;

            int id = Convert.ToInt32(((LinkButton)sender).CommandArgument);

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "DELETE FROM potionTable WHERE PotionId = @id", conn);
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            ViewState["CurrentPotionId"] = null;
            string category = ViewState["CurrentCategory"] != null ? ViewState["CurrentCategory"].ToString() : "";
            if (!string.IsNullOrEmpty(category))
                LoadCategoryContent(category);
            else
                AutoSelectFirst();
        }

        // ─────────────────────────────────────────────
        // CREATE – Show add form
        // ─────────────────────────────────────────────
        protected void ShowAddForm(object sender, EventArgs e)
        {
            if (!IsAdmin()) return;

            txtAddName.Text = ""; txtAddDuration.Text = ""; txtAddEffect.Text = "";
            txtAddBase.Text = ""; txtAddIngredient.Text = ""; txtAddDesc.Text = "";
            txtAddContent.Text = ""; txtAddThumbnail.Text = "";
            txtAddDetailImage.Text = ""; txtAddIngredientImage.Text = "";
            lblAddError.Text = "";

            mainPanel.Visible = false;
            editPanel.Visible = false;
            addPanel.Visible  = true;
        }

        // ─────────────────────────────────────────────
        // CREATE – Save
        // ─────────────────────────────────────────────
        protected void SaveAdd(object sender, EventArgs e)
        {
            if (!IsAdmin()) return;

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string sql = @"INSERT INTO potionTable
                               (Name,Category,PotionType,Duration,Effect,BrewingBase,Ingredient,
                                Description,FullContent,Thumbnail,DetailImage,IngredientImage)
                               VALUES (@n,@c,@pt,@du,@ef,@bb,@ing,@d,@fc,@th,@di,@ii)";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@n",   txtAddName.Text.Trim());
                cmd.Parameters.AddWithValue("@c",   ddlAddCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@pt",  ddlAddType.SelectedValue);
                cmd.Parameters.AddWithValue("@du",  txtAddDuration.Text.Trim());
                cmd.Parameters.AddWithValue("@ef",  txtAddEffect.Text.Trim());
                cmd.Parameters.AddWithValue("@bb",  txtAddBase.Text.Trim());
                cmd.Parameters.AddWithValue("@ing", txtAddIngredient.Text.Trim());
                cmd.Parameters.AddWithValue("@d",   txtAddDesc.Text.Trim());
                cmd.Parameters.AddWithValue("@fc",  txtAddContent.Text.Trim());
                cmd.Parameters.AddWithValue("@th",  txtAddThumbnail.Text.Trim());
                cmd.Parameters.AddWithValue("@di",  txtAddDetailImage.Text.Trim());
                cmd.Parameters.AddWithValue("@ii",  txtAddIngredientImage.Text.Trim());
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            mainPanel.Visible = true;
            editPanel.Visible = false;
            addPanel.Visible  = false;
            ViewState["CurrentCategory"] = ddlAddCategory.SelectedValue;
            ViewState["CurrentPotionId"] = null;
            LoadCategoryContent(ddlAddCategory.SelectedValue);
        }

        // ─────────────────────────────────────────────
        // COMMENT SECTION
        // ─────────────────────────────────────────────
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
                litVisitorMsg.Text = "<p style='color:#fbbf24; text-align:center; margin-top:20px;'>[ <a href='/Lee Wei Zhe/aspx/Login.aspx' style='color:#2ecc71;'>Login</a> to join the discussion ]</p>";
            }
        }

        private void LoadComments(int potionId)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string sql = @"SELECT c.*, u.Username FROM potionComment c
                               JOIN userTable u ON c.UserId = u.UserId
                               WHERE c.PotionId = @pid
                               AND c.Status = 'Visible'
                               ORDER BY c.CommentDate DESC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@pid", potionId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptComments.DataSource = dt;
                rptComments.DataBind();
            }
        }

        protected void btnSubmitComment_Click(object sender, EventArgs e)
        {
            int potionId = Convert.ToInt32(ViewState["CurrentPotionId"]);
            string commentText = txtComment.Text.Trim();

            if (!string.IsNullOrEmpty(commentText) && Session["userId"] != null)
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string sql = "INSERT INTO potionComment (PotionId, UserId, CommentText) VALUES (@pid, @uid, @text)";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@pid", potionId);
                    cmd.Parameters.AddWithValue("@uid", Session["userId"]);
                    cmd.Parameters.AddWithValue("@text", commentText);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                txtComment.Text = "";
                LoadComments(potionId);
            }
        }

        protected void lnkReport_Command(object sender, CommandEventArgs e)
        {
            if (Session["userId"] == null)
            {
                Response.Redirect("/Lee Wei Zhe/aspx/Login.aspx");
                return;
            }

            string[] args = e.CommandArgument.ToString().Split('|');
            if (args.Length < 2) return;

            string commentId = e.CommandArgument.ToString().Split('|')[0];
            string potionId = ViewState["CurrentPotionId"]?.ToString();
            string reporterId = Session["userId"].ToString();

            if (string.IsNullOrEmpty(potionId))
            {
                Response.Write("<script>alert('Error: Potion ID not found in session.');</script>");
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string sql = "INSERT INTO reportTable (CommentId, ReporterId, PotionId) VALUES (@cid, @rid, @pid)";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@cid", commentId);
                    cmd.Parameters.AddWithValue("@rid", reporterId);
                    cmd.Parameters.AddWithValue("@pid", potionId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                Response.Write("<script>alert('Comment reported successfully. Admins will review it.');</script>");
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error reporting comment: " + ex.Message.Replace("'", "\\'") + "');</script>");
            }
        }
    }
}
