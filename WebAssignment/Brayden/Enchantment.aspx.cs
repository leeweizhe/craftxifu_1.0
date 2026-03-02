using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace WebAssignment.Wong_Zhang_Zhe
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

        public string GetCategoryIcon(string cat)
        {
            switch (cat)
            {
                case "Sword":       return "⚔️";
                case "Armor":       return "🛡️";
                case "Tool":        return "⛏️";
                case "Bow":         return "🏹";
                case "Crossbow":    return "🎯";
                case "Trident":     return "🔱";
                case "Fishing Rod": return "🎣";
                default:            return "✨";
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
                string sql = "SELECT DISTINCT Category FROM enchantmentTable ORDER BY Category";
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
            lblListTitle.Text = category + " Enchantments";
            LoadEnchantmentsByCategory(category);

            categoryPanel.Visible = false;
            listPanel.Visible     = true;
            detailPanel.Visible   = false;
            editPanel.Visible     = false;
            addPanel.Visible      = false;
            btnAddNew.Visible     = IsAdmin();
        }

        private void LoadEnchantmentsByCategory(string category)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string sql = "SELECT * FROM enchantmentTable WHERE Category = @cat ORDER BY Name";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@cat", category);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                enchantRepeater.DataSource = dt;
                enchantRepeater.DataBind();
            }
        }

        // ─────────────────────────────────────────────
        // READ – Detail view (now includes DetailImage)
        // ─────────────────────────────────────────────
        protected void ViewDetail(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(((LinkButton)sender).CommandArgument);
            ViewState["CurrentEnchantId"] = id;
            LoadEnchantmentDetail(id);

            categoryPanel.Visible = false;
            listPanel.Visible     = false;
            detailPanel.Visible   = true;
            editPanel.Visible     = false;
            addPanel.Visible      = false;
        }

        private void LoadEnchantmentDetail(int id)
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

                        lblDetailName.Text      = name;
                        lblDetailName2.Text     = name;
                        lblDetailCategory.Text  = dr["Category"].ToString();
                        lblDetailMaxLevel.Text  = "Max Level: " + dr["MaxLevel"].ToString();
                        lblDetailDesc.Text      = dr["Description"].ToString();
                        litDetailContent.Text   = dr["FullContent"].ToString();
                        lblDetailApplies.Text   = dr["AppliesTo"].ToString();
                        lblDetailConflicts.Text = string.IsNullOrEmpty(dr["ConflictsWith"].ToString())
                                                  ? "None" : dr["ConflictsWith"].ToString();
                        lblDetailTreasure.Text  = dr["TreasureOnly"].ToString() == "True" ? "Yes" : "No";

                        // Small thumbnail in header
                        string thumb = dr["Thumbnail"].ToString();
                        if (!string.IsNullOrEmpty(thumb))
                            imgDetailThumb.ImageUrl = ResolveUrl(thumb);

                        // Large detail image below header
                        string detailImg = dr["DetailImage"].ToString();
                        if (!string.IsNullOrEmpty(detailImg))
                        {
                            imgDetailLarge.ImageUrl = ResolveUrl(detailImg);
                            pnlDetailImage.Visible  = true;
                        }
                        else
                        {
                            pnlDetailImage.Visible = false;
                        }

                        // Level pips
                        int maxLvl = Convert.ToInt32(dr["MaxLevel"]);
                        string[] roman = { "I", "II", "III", "IV", "V" };
                        string pips = "";
                        for (int i = 0; i < maxLvl; i++)
                            pips += "<span class='level-pip'>" + roman[i] + "</span>";
                        litLevelPips.Text = pips;

                        btnEditEnchant.Visible           = IsAdmin();
                        btnDeleteEnchant.Visible         = IsAdmin();
                        btnDeleteEnchant.CommandArgument = id.ToString();
                    }
                }
            }
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
                              ? ViewState["CurrentCategory"].ToString() : "Sword";
            lblListTitle.Text = category + " Enchantments";
            LoadEnchantmentsByCategory(category);

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

            LoadEnchantmentDetail(id);
            categoryPanel.Visible = false; listPanel.Visible  = false;
            detailPanel.Visible   = true;  editPanel.Visible  = false;
            addPanel.Visible      = false;
        }

        // ─────────────────────────────────────────────
        // DELETE
        // ─────────────────────────────────────────────
        protected void DeleteEnchantment(object sender, EventArgs e)
        {
            if (!IsAdmin()) return;

            int id = Convert.ToInt32(((LinkButton)sender).CommandArgument);
            string category = ViewState["CurrentCategory"] != null
                              ? ViewState["CurrentCategory"].ToString() : "Sword";

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "DELETE FROM enchantmentTable WHERE EnchantmentId = @id", conn);
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblListTitle.Text = category + " Enchantments";
            LoadEnchantmentsByCategory(category);
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

            txtAddName.Text = ""; txtAddMaxLevel.Text = ""; txtAddDesc.Text = "";
            txtAddContent.Text = ""; txtAddApplies.Text = ""; txtAddConflicts.Text = "";
            txtAddThumbnail.Text = ""; txtAddDetailImage.Text = "";
            chkAddTreasure.Checked = false; lblAddError.Text = "";

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

            string category = ddlAddCategory.SelectedValue;
            ViewState["CurrentCategory"] = category;
            lblListTitle.Text = category + " Enchantments";
            LoadEnchantmentsByCategory(category);
            categoryPanel.Visible = false; listPanel.Visible  = true;
            detailPanel.Visible   = false; editPanel.Visible  = false;
            addPanel.Visible      = false;
            btnAddNew.Visible     = IsAdmin();
        }
    }
}
