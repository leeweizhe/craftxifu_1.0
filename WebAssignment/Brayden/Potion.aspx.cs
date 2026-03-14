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
                case "Positive": return "🟢";
                case "Negative": return "🔴";
                default:         return "🟡";
            }
        }

        // ─────────────────────────────────────────────
        // Page Load
        // ─────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                categoryPanel.Visible = true;
                listPanel.Visible     = false;
                detailPanel.Visible   = false;
                editPanel.Visible     = false;
                addPanel.Visible      = false;
                LoadCategories();
            }
        }

        // ─────────────────────────────────────────────
        // READ – Categories
        // ─────────────────────────────────────────────
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

        // ─────────────────────────────────────────────
        // READ – List by category
        // ─────────────────────────────────────────────
        protected void SelectCategory(object sender, EventArgs e)
        {
            string category = ((LinkButton)sender).CommandArgument;
            ViewState["CurrentCategory"] = category;
            lblListTitle.Text = category + " Potions";
            LoadPotionsByCategory(category);

            categoryPanel.Visible = false;
            listPanel.Visible     = true;
            detailPanel.Visible   = false;
            editPanel.Visible     = false;
            addPanel.Visible      = false;
            btnAddNew.Visible     = IsAdmin();
        }

        private void LoadPotionsByCategory(string category)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string sql = "SELECT * FROM potionTable WHERE Category = @cat ORDER BY Name";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@cat", category);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                potionRepeater.DataSource = dt;
                potionRepeater.DataBind();
            }
        }

        // ─────────────────────────────────────────────
        // READ – Detail (now loads 3 images)
        // ─────────────────────────────────────────────
        protected void ViewDetail(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(((LinkButton)sender).CommandArgument);
            ViewState["CurrentPotionId"] = id;
            LoadPotionDetail(id);

            categoryPanel.Visible = false;
            listPanel.Visible     = false;
            detailPanel.Visible   = true;
            editPanel.Visible     = false;
            addPanel.Visible      = false;
        }

        private void LoadPotionDetail(int id)
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
                        lblDetailName.Text       = dr["Name"].ToString();
                        lblDetailCategory.Text   = dr["Category"].ToString();
                        lblDetailType.Text       = dr["PotionType"].ToString();
                        lblDetailDuration.Text   = dr["Duration"].ToString();
                        lblDetailEffect.Text     = dr["Effect"].ToString();
                        lblDetailBase.Text       = dr["BrewingBase"].ToString();
                        lblDetailIngredient.Text = dr["Ingredient"].ToString();
                        lblDetailDesc.Text       = dr["Description"].ToString();
                        litDetailContent.Text    = dr["FullContent"].ToString();

                        // ── 1. Small thumbnail in header ──
                        string thumb = dr["Thumbnail"].ToString();
                        if (!string.IsNullOrEmpty(thumb))
                            imgDetailThumb.ImageUrl = ResolveUrl(thumb);

                        // ── 2. Large potion bottle + ingredient image ──
                        string detailImg      = dr["DetailImage"].ToString();
                        string ingredientImg  = dr["IngredientImage"].ToString();

                        bool hasDetail     = !string.IsNullOrEmpty(detailImg);
                        bool hasIngredient = !string.IsNullOrEmpty(ingredientImg);

                        if (hasDetail || hasIngredient)
                        {
                            if (hasDetail)     imgDetailLarge.ImageUrl = ResolveUrl(detailImg);
                            if (hasIngredient) imgIngredient.ImageUrl  = ResolveUrl(ingredientImg);
                            pnlImages.Visible = true;
                        }
                        else
                        {
                            pnlImages.Visible = false;
                        }

                        // Show edit/delete for Admin or Instructor
                        btnEditPotion.Visible           = IsAdmin() || IsInstructor();
                        btnDeletePotion.Visible         = IsAdmin() || IsInstructor();
                        btnDeletePotion.CommandArgument = id.ToString();
                    }
                }
            }

            // Load comments after loading detail
            LoadComments(id);
            CheckCommentPermission();
        }

        // ─────────────────────────────────────────────
        // Back navigation
        // ─────────────────────────────────────────────
        protected void BackToCategories(object sender, EventArgs e)
        {
            categoryPanel.Visible = true;
            listPanel.Visible = false; detailPanel.Visible = false;
            editPanel.Visible = false; addPanel.Visible    = false;
        }

        protected void BackToList(object sender, EventArgs e)
        {
            string category = ViewState["CurrentCategory"] != null
                              ? ViewState["CurrentCategory"].ToString() : "Positive";
            lblListTitle.Text = category + " Potions";
            LoadPotionsByCategory(category);

            categoryPanel.Visible = false; listPanel.Visible  = true;
            detailPanel.Visible   = false; editPanel.Visible  = false;
            addPanel.Visible      = false;
            btnAddNew.Visible     = IsAdmin();
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

            categoryPanel.Visible = false; listPanel.Visible    = false;
            detailPanel.Visible   = false; editPanel.Visible    = true;
            addPanel.Visible      = false;
            lblEditError.Text     = "";
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

            LoadPotionDetail(id);
            categoryPanel.Visible = false; listPanel.Visible  = false;
            detailPanel.Visible   = true;  editPanel.Visible  = false;
            addPanel.Visible      = false;
        }

        // ─────────────────────────────────────────────
        // DELETE
        // ─────────────────────────────────────────────
        protected void DeletePotion(object sender, EventArgs e)
        {
            if (!IsAdmin()) return;

            int id = Convert.ToInt32(((LinkButton)sender).CommandArgument);
            string category = ViewState["CurrentCategory"] != null
                              ? ViewState["CurrentCategory"].ToString() : "Positive";

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "DELETE FROM potionTable WHERE PotionId = @id", conn);
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblListTitle.Text = category + " Potions";
            LoadPotionsByCategory(category);
            categoryPanel.Visible = false; listPanel.Visible  = true;
            detailPanel.Visible   = false; editPanel.Visible  = false;
            addPanel.Visible      = false;
            btnAddNew.Visible     = IsAdmin();
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

            categoryPanel.Visible = false; listPanel.Visible  = false;
            detailPanel.Visible   = false; editPanel.Visible  = false;
            addPanel.Visible      = true;
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

            string category = ddlAddCategory.SelectedValue;
            ViewState["CurrentCategory"] = category;
            lblListTitle.Text = category + " Potions";
            LoadPotionsByCategory(category);
            categoryPanel.Visible = false; listPanel.Visible  = true;
            detailPanel.Visible   = false; editPanel.Visible  = false;
            addPanel.Visible      = false;
            btnAddNew.Visible     = IsAdmin();
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
