using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace WebAssignment.Brayden
{
    public partial class Enchantment : System.Web.UI.Page
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

        public string GetCategoryIcon(string cat)
        {
            switch (cat)
            {
                case "Sword":       return "\u2694\uFE0F";
                case "Armor":       return "\uD83D\uDEE1\uFE0F";
                case "Tool":        return "\u26CF\uFE0F";
                case "Bow":         return "\uD83C\uDFF9";
                case "Crossbow":    return "\uD83C\uDFAF";
                case "Trident":     return "\uD83D\uDD31";
                case "Fishing Rod": return "\uD83C\uDFA3";
                default:            return "\u2728";
            }
        }

        public string GetCategoryActiveClass(string category)
        {
            return ViewState["CurrentCategory"] != null && ViewState["CurrentCategory"].ToString() == category ? " active" : "";
        }

        public string GetPaginationActiveClass(object itemId)
        {
            return ViewState["CurrentEnchantId"] != null && ViewState["CurrentEnchantId"].ToString() == itemId.ToString() ? " active" : "";
        }

        public int CurrentEnchantId
        {
            get { return ViewState["CurrentEnchantId"] != null ? Convert.ToInt32(ViewState["CurrentEnchantId"]) : 0; }
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
                string sql = "SELECT DISTINCT Category FROM enchantmentTable ORDER BY Category";
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
                    "SELECT TOP 1 Category FROM enchantmentTable ORDER BY Category", conn);
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
                string sql = "SELECT EnchantmentId, Name, Thumbnail FROM enchantmentTable WHERE Category = @cat ORDER BY Name";
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

                int currentId = ViewState["CurrentEnchantId"] != null ? Convert.ToInt32(ViewState["CurrentEnchantId"]) : 0;
                bool found = false;
                foreach (DataRow row in dt.Rows)
                {
                    if (Convert.ToInt32(row["EnchantmentId"]) == currentId) { found = true; break; }
                }
                if (!found)
                {
                    currentId = Convert.ToInt32(dt.Rows[0]["EnchantmentId"]);
                    ViewState["CurrentEnchantId"] = currentId;
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
                string sql = "SELECT * FROM enchantmentTable WHERE EnchantmentId = @id";
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
                        lblDetailMaxLevel.Text = "Max Level: " + dr["MaxLevel"].ToString();

                        string detailImg = dr["DetailImage"].ToString();
                        string thumb = dr["Thumbnail"].ToString();
                        if (!string.IsNullOrEmpty(detailImg))
                            imgDetailLarge.ImageUrl = ResolveUrl(detailImg);
                        else if (!string.IsNullOrEmpty(thumb))
                            imgDetailLarge.ImageUrl = ResolveUrl(thumb);

                        int maxLvl = Convert.ToInt32(dr["MaxLevel"]);
                        string[] roman = { "I", "II", "III", "IV", "V" };
                        string pips = "";
                        for (int i = 0; i < maxLvl; i++)
                            pips += "<span class='level-pip'>" + roman[i] + "</span>";
                        litLevelPips.Text = pips;

                        // Back
                        lblDetailName2.Text     = name;
                        lblDetailDesc.Text      = dr["Description"].ToString();
                        litDetailContent.Text   = dr["FullContent"].ToString();
                        lblDetailApplies.Text   = dr["AppliesTo"].ToString();
                        lblDetailConflicts.Text = string.IsNullOrEmpty(dr["ConflictsWith"].ToString())
                                                  ? "None" : dr["ConflictsWith"].ToString();
                        lblDetailTreasure.Text  = dr["TreasureOnly"].ToString() == "True" ? "Yes" : "No";
                        lblBackMaxLevel.Text    = dr["MaxLevel"].ToString();

                        bool canEdit = IsAdmin() || IsInstructor();
                        pnlAdminActions.Visible = canEdit;
                        btnDeleteEnchant.CommandArgument = id.ToString();
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
            ViewState["CurrentEnchantId"] = null;
            LoadCategoryContent(category);
        }

        protected void SelectPaginationItem(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(((LinkButton)sender).CommandArgument);
            ViewState["CurrentEnchantId"] = id;
            LoadFlipCard(id);

            string category = ViewState["CurrentCategory"] != null ? ViewState["CurrentCategory"].ToString() : "";
            if (!string.IsNullOrEmpty(category))
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string sql = "SELECT EnchantmentId, Name, Thumbnail FROM enchantmentTable WHERE Category = @cat ORDER BY Name";
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
            int id = Convert.ToInt32(ViewState["CurrentEnchantId"]);

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT * FROM enchantmentTable WHERE EnchantmentId = @id", conn);
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        txtEditName.Text              = dr["Name"].ToString();
                        ddlEditCategory.SelectedValue = dr["Category"].ToString();
                        txtEditMaxLevel.Text          = dr["MaxLevel"].ToString();
                        txtEditThumbnail.Text         = dr["Thumbnail"].ToString();
                        txtEditDetailImage.Text       = dr["DetailImage"].ToString();
                        txtEditDesc.Text              = dr["Description"].ToString();
                        txtEditApplies.Text           = dr["AppliesTo"].ToString();
                        txtEditConflicts.Text         = dr["ConflictsWith"].ToString();
                        txtEditContent.Text           = dr["FullContent"].ToString();
                        chkEditTreasure.Checked       = dr["TreasureOnly"].ToString() == "True";
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

            int lvl;
            if (!int.TryParse(txtEditMaxLevel.Text.Trim(), out lvl) || lvl < 1 || lvl > 5)
            {
                lblEditError.Text = "Max Level must be between 1 and 5.";
                return;
            }

            int id = Convert.ToInt32(ViewState["CurrentEnchantId"]);

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string sql = @"UPDATE enchantmentTable
                               SET Name=@n, Category=@c, MaxLevel=@ml, Description=@d,
                                   FullContent=@fc, AppliesTo=@at, ConflictsWith=@cw,
                                   Thumbnail=@th, DetailImage=@di, TreasureOnly=@tr
                               WHERE EnchantmentId=@id";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@n",  txtEditName.Text.Trim());
                cmd.Parameters.AddWithValue("@c",  ddlEditCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@ml", lvl);
                cmd.Parameters.AddWithValue("@d",  txtEditDesc.Text.Trim());
                cmd.Parameters.AddWithValue("@fc", txtEditContent.Text.Trim());
                cmd.Parameters.AddWithValue("@at", txtEditApplies.Text.Trim());
                cmd.Parameters.AddWithValue("@cw", txtEditConflicts.Text.Trim());
                cmd.Parameters.AddWithValue("@th", txtEditThumbnail.Text.Trim());
                cmd.Parameters.AddWithValue("@di", txtEditDetailImage.Text.Trim());
                cmd.Parameters.AddWithValue("@tr", chkEditTreasure.Checked ? 1 : 0);
                cmd.Parameters.AddWithValue("@id", id);
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
        protected void DeleteEnchantment(object sender, EventArgs e)
        {
            if (!IsAdmin()) return;

            int id = Convert.ToInt32(((LinkButton)sender).CommandArgument);

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "DELETE FROM enchantmentTable WHERE EnchantmentId = @id", conn);
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            ViewState["CurrentEnchantId"] = null;
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

            txtAddName.Text = ""; txtAddMaxLevel.Text = ""; txtAddDesc.Text = "";
            txtAddContent.Text = ""; txtAddApplies.Text = ""; txtAddConflicts.Text = "";
            txtAddThumbnail.Text = ""; txtAddDetailImage.Text = "";
            chkAddTreasure.Checked = false; lblAddError.Text = "";

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

            int lvl;
            if (!int.TryParse(txtAddMaxLevel.Text.Trim(), out lvl) || lvl < 1 || lvl > 5)
            {
                lblAddError.Text = "Max Level must be between 1 and 5.";
                return;
            }

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string sql = @"INSERT INTO enchantmentTable
                               (Name,Category,MaxLevel,Description,FullContent,
                                AppliesTo,ConflictsWith,Thumbnail,DetailImage,TreasureOnly)
                               VALUES (@n,@c,@ml,@d,@fc,@at,@cw,@th,@di,@tr)";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@n",  txtAddName.Text.Trim());
                cmd.Parameters.AddWithValue("@c",  ddlAddCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@ml", lvl);
                cmd.Parameters.AddWithValue("@d",  txtAddDesc.Text.Trim());
                cmd.Parameters.AddWithValue("@fc", txtAddContent.Text.Trim());
                cmd.Parameters.AddWithValue("@at", txtAddApplies.Text.Trim());
                cmd.Parameters.AddWithValue("@cw", txtAddConflicts.Text.Trim());
                cmd.Parameters.AddWithValue("@th", txtAddThumbnail.Text.Trim());
                cmd.Parameters.AddWithValue("@di", txtAddDetailImage.Text.Trim());
                cmd.Parameters.AddWithValue("@tr", chkAddTreasure.Checked ? 1 : 0);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            mainPanel.Visible = true;
            editPanel.Visible = false;
            addPanel.Visible  = false;
            ViewState["CurrentCategory"] = ddlAddCategory.SelectedValue;
            ViewState["CurrentEnchantId"] = null;
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
                litVisitorMsg.Text = "<p style='color:#fbbf24; text-align:center; margin-top:20px;'>[ <a href='/Lee Wei Zhe/aspx/Login.aspx' style='color:#9b59b6;'>Login</a> to join the discussion ]</p>";
            }
        }

        private void LoadComments(int enchantId)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string sql = @"SELECT c.*, u.Username FROM enchantmentComment c
                               JOIN userTable u ON c.UserId = u.UserId
                               WHERE c.EnchantmentId = @eid
                               AND c.Status = 'Visible'
                               ORDER BY c.CommentDate DESC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@eid", enchantId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptComments.DataSource = dt;
                rptComments.DataBind();
            }
        }

        protected void btnSubmitComment_Click(object sender, EventArgs e)
        {
            int enchantId = Convert.ToInt32(ViewState["CurrentEnchantId"]);
            string commentText = txtComment.Text.Trim();

            if (!string.IsNullOrEmpty(commentText) && Session["userId"] != null)
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string sql = "INSERT INTO enchantmentComment (EnchantmentId, UserId, CommentText) VALUES (@eid, @uid, @text)";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@eid", enchantId);
                    cmd.Parameters.AddWithValue("@uid", Session["userId"]);
                    cmd.Parameters.AddWithValue("@text", commentText);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                txtComment.Text = "";
                LoadComments(enchantId);
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
            string enchantId = ViewState["CurrentEnchantId"]?.ToString();
            string reporterId = Session["userId"].ToString();

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string sql = "INSERT INTO reportTable (CommentId, ReporterId, EnchantmentId) VALUES (@cid, @rid, @eid)";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@cid", commentId);
                    cmd.Parameters.AddWithValue("@rid", reporterId);
                    cmd.Parameters.AddWithValue("@eid", enchantId);

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
