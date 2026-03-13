using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace WebAssignment.Brayden
{
    public partial class Minigame : System.Web.UI.Page
    {
        private string ConnStr
        {
            get { return ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
        }

        private bool IsLoggedIn()
        {
            return Session["userId"] != null;
        }

        private int GetUserId()
        {
            return Convert.ToInt32(Session["userId"]);
        }

        // ─────────────────────────────────────────────
        // Helper: rarity colour
        // ─────────────────────────────────────────────
        public string GetRarityColor(string rarity)
        {
            switch (rarity)
            {
                case "Common":    return "#aaaaaa";
                case "Uncommon":  return "#2ecc71";
                case "Rare":      return "#3498db";
                case "Epic":      return "#9b59b6";
                case "Legendary": return "#f39c12";
                default:          return "#ffffff";
            }
        }

        // ─────────────────────────────────────────────
        // Page Load
        // ─────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Default: show game tab
                gameSection.Visible = true;
                shopSection.Visible = false;
                invSection.Visible  = false;

                // If a ?tab=shop or ?tab=inv was provided, show that tab
                string tab = Request.QueryString["tab"];
                if (!string.IsNullOrEmpty(tab))
                {
                    switch (tab.ToLower())
                    {
                        case "shop":
                            gameSection.Visible = false; shopSection.Visible = true; invSection.Visible = false; break;
                        case "inv":
                        case "inventory":
                            gameSection.Visible = false; shopSection.Visible = false; invSection.Visible = true; break;
                        default:
                            gameSection.Visible = true; shopSection.Visible = false; invSection.Visible = false; break;
                    }
                }
                // default active tab classes will be set in PreRender

                if (IsLoggedIn())
                {
                    pnlPointsTop.Visible = true;
                    LoadUserPoints();
                    LoadShopItems();
                    LoadInventory();
                    pnlWinPoints.Visible = true;
                    pnlWinGuest.Visible  = false;
                    pnlShopGuest.Visible = false;
                    pnlInvGuest.Visible  = false;
                    pnlShopPoints.Visible = true;
                    pnlInvPoints.Visible  = true;
                }
                else
                {
                    pnlPointsTop.Visible  = false;
                    pnlWinPoints.Visible  = false;
                    pnlWinGuest.Visible   = true;
                    pnlShopGuest.Visible  = true;
                    pnlInvGuest.Visible   = true;
                    pnlShopPoints.Visible = false;
                    pnlInvPoints.Visible  = false;
                }
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);

            // Ensure tab visual state matches which section is visible (final render)
            if (gameSection.Visible)
            {
                tabGame.CssClass = "tab-btn active";
                tabShop.CssClass = "tab-btn";
                tabInv.CssClass  = "tab-btn";
            }
            else if (shopSection.Visible)
            {
                tabGame.CssClass = "tab-btn";
                tabShop.CssClass = "tab-btn active";
                tabInv.CssClass  = "tab-btn";
            }
            else if (invSection.Visible)
            {
                tabGame.CssClass = "tab-btn";
                tabShop.CssClass = "tab-btn";
                tabInv.CssClass  = "tab-btn active";
            }
        }

        // ─────────────────────────────────────────────
        // Points: calculate balance
        // ─────────────────────────────────────────────
        private int GetBalance()
        {
            int userId = GetUserId();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();

                SqlCommand earnCmd = new SqlCommand(
                    "SELECT ISNULL(SUM(PointsEarned),0) FROM minigameScoreTable WHERE UserId=@uid", conn);
                earnCmd.Parameters.AddWithValue("@uid", userId);
                int earned = Convert.ToInt32(earnCmd.ExecuteScalar());

                SqlCommand spentCmd = new SqlCommand(
                    @"SELECT ISNULL(SUM(si.Price),0)
                      FROM userInventoryTable ui
                      JOIN shopItemTable si ON ui.ItemId = si.ItemId
                      WHERE ui.UserId = @uid", conn);
                spentCmd.Parameters.AddWithValue("@uid", userId);
                int spent = Convert.ToInt32(spentCmd.ExecuteScalar());

                return earned - spent;
            }
        }

        private void LoadUserPoints()
        {
            int balance = GetBalance();
            lblPoints.Text     = balance.ToString();
            lblPointsShop.Text = balance.ToString();
            lblPointsInv.Text  = balance.ToString();
        }

        // ─────────────────────────────────────────────
        // Award 10 points on game win
        // ─────────────────────────────────────────────
        protected void AwardPoints(object sender, EventArgs e)
        {
            if (!IsLoggedIn()) return;

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string sql = @"INSERT INTO minigameScoreTable (UserId, GameName, PointsEarned)
                               VALUES (@uid, 'Loot Drop Memory Match', 10)";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@uid", GetUserId());
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            LoadUserPoints();
            LoadShopItems();
        }

        // ─────────────────────────────────────────────
        // Tab navigation
        // ─────────────────────────────────────────────
        protected void ShowGame(object sender, EventArgs e)
        {
            gameSection.Visible = true;
            shopSection.Visible = false;
            invSection.Visible  = false;
            tabGame.CssClass = "tab-btn active";
            tabShop.CssClass = "tab-btn";
            tabInv.CssClass  = "tab-btn";
            if (IsLoggedIn()) LoadUserPoints();
        }

        protected void ShowShop(object sender, EventArgs e)
        {
            gameSection.Visible = false;
            shopSection.Visible = true;
            invSection.Visible  = false;
            tabGame.CssClass = "tab-btn";
            tabShop.CssClass = "tab-btn active";
            tabInv.CssClass  = "tab-btn";
            // default to name-tag shop sub-tab
            if (IsLoggedIn()) { LoadUserPoints(); pnlNameTag.Visible = true; pnlFrame.Visible = false; tabNameTag.CssClass = "tab-btn active"; tabFrame.CssClass = "tab-btn"; LoadShopItems(); }
        }

        protected void ShowNameTagShop(object sender, EventArgs e)
        {
            // Show the name-tag subset of the shop
            pnlNameTag.Visible = true;
            pnlFrame.Visible = false;
            tabNameTag.CssClass = "tab-btn active";
            tabFrame.CssClass = "tab-btn";
            if (IsLoggedIn()) { LoadUserPoints(); LoadShopItems(); }
        }

        protected void ShowFrameShop(object sender, EventArgs e)
        {
            // Show the avatar-frame subset of the shop
            pnlNameTag.Visible = false;
            pnlFrame.Visible = true;
            tabNameTag.CssClass = "tab-btn";
            tabFrame.CssClass = "tab-btn active";
            if (IsLoggedIn()) { LoadUserPoints(); LoadFrameItems(); }
        }

        protected void ShowInventory(object sender, EventArgs e)
        {
            gameSection.Visible = false;
            shopSection.Visible = false;
            invSection.Visible  = true;
            tabGame.CssClass = "tab-btn";
            tabShop.CssClass = "tab-btn";
            tabInv.CssClass  = "tab-btn active";
            if (IsLoggedIn()) { LoadUserPoints(); LoadInventory(); }
        }

        // ─────────────────────────────────────────────
        // Shop: load items
        // ─────────────────────────────────────────────
        private void LoadShopItems()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                // Load only name-tag items (those that have an ImagePath)
                string sql = "SELECT * FROM shopItemTable WHERE IsAvailable=1 AND ImagePath IS NOT NULL AND ImagePath <> '' ORDER BY Price";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                shopRepeater.DataSource = dt;
                shopRepeater.DataBind();
            }
        }

        private void LoadFrameItems()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                // Only load items that have a FrameImagePath set
                string sql = "SELECT * FROM shopItemTable WHERE IsAvailable=1 AND FrameImagePath IS NOT NULL AND FrameImagePath <> '' ORDER BY Price";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                frameRepeater.DataSource = dt;
                frameRepeater.DataBind();
            }
        }

        // ─────────────────────────────────────────────
        // Shop: buy item
        // ─────────────────────────────────────────────
        protected void BuyItem(object sender, EventArgs e)
        {
            if (!IsLoggedIn())
            {
                lblShopMsg.Text      = "Please log in to purchase items.";
                lblShopMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }

            // CommandArgument format: "{itemId}|{variant}" where variant is 'name' or 'frame'
            string arg = ((LinkButton)sender).CommandArgument;
            string[] parts = arg.Split('|');
            int itemId = Convert.ToInt32(parts[0]);
            string variant = parts.Length > 1 ? parts[1] : "name";
            int userId = GetUserId();

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();

                // Check already owned for the same variant (allow buying same ItemId with different variant)
                SqlCommand ownCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM userInventoryTable WHERE UserId=@uid AND ItemId=@iid AND Variant = @variant", conn);
                ownCmd.Parameters.AddWithValue("@uid", userId);
                ownCmd.Parameters.AddWithValue("@iid", itemId);
                ownCmd.Parameters.AddWithValue("@variant", variant);
                if (Convert.ToInt32(ownCmd.ExecuteScalar()) > 0)
                {
                    lblShopMsg.Text      = "You already own this item!";
                    lblShopMsg.ForeColor = System.Drawing.Color.Orange;
                    return;
                }

                // Get price
                SqlCommand priceCmd = new SqlCommand(
                    "SELECT Price FROM shopItemTable WHERE ItemId=@iid", conn);
                priceCmd.Parameters.AddWithValue("@iid", itemId);
                int price = Convert.ToInt32(priceCmd.ExecuteScalar());

                // Check balance
                int balance = GetBalance();
                if (balance < price)
                {
                    lblShopMsg.Text      = "Not enough points! Need " + price + " but you have " + balance + ".";
                    lblShopMsg.ForeColor = System.Drawing.Color.Red;
                    LoadUserPoints();
                    LoadShopItems();
                    return;
                }

                // Purchase
                SqlCommand buyCmd = new SqlCommand(
                    "INSERT INTO userInventoryTable (UserId, ItemId, Variant) VALUES (@uid, @iid, @variant)", conn);
                buyCmd.Parameters.AddWithValue("@uid", userId);
                buyCmd.Parameters.AddWithValue("@iid", itemId);
                buyCmd.Parameters.AddWithValue("@variant", variant);
                buyCmd.ExecuteNonQuery();
            }

            lblShopMsg.Text      = "Purchase successful! Check your inventory.";
            lblShopMsg.ForeColor = System.Drawing.Color.FromArgb(104, 255, 0);
            LoadUserPoints();
            LoadShopItems();
        }

        // ─────────────────────────────────────────────
        // Inventory: load owned items
        // ─────────────────────────────────────────────
        private void LoadInventory()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string sql = @"SELECT si.*, ui.InventoryId, ui.IsEquipped, ui.PurchaseDate
                               , ui.Variant
                               FROM userInventoryTable ui
                               JOIN shopItemTable si ON ui.ItemId = si.ItemId
                               WHERE ui.UserId = @uid
                               ORDER BY ui.PurchaseDate DESC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@uid", GetUserId());
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                // Defensive: some DB instances may not have ui.Variant column (schema drift).
                // Add a Variant column with a sensible default to avoid Eval("Variant") failing
                // during databinding in the .aspx markup.
                if (!dt.Columns.Contains("Variant"))
                {
                    dt.Columns.Add("Variant", typeof(string));
                    foreach (DataRow r in dt.Rows)
                    {
                        // Default to 'name' variant. If no ImagePath but FrameImagePath exists, prefer 'frame'.
                        string img = dt.Columns.Contains("ImagePath") && r["ImagePath"] != DBNull.Value ? r["ImagePath"].ToString() : string.Empty;
                        string frame = dt.Columns.Contains("FrameImagePath") && r["FrameImagePath"] != DBNull.Value ? r["FrameImagePath"].ToString() : string.Empty;
                        r["Variant"] = string.IsNullOrEmpty(img) && !string.IsNullOrEmpty(frame) ? "frame" : "name";
                    }
                }

                inventoryRepeater.DataSource = dt;
                inventoryRepeater.DataBind();
                invEmptyMsg.Visible = (dt.Rows.Count == 0);
            }
        }

        // ─────────────────────────────────────────────
        // Inventory: equip a title
        // ─────────────────────────────────────────────
        protected void EquipItem(object sender, EventArgs e)
        {
            if (!IsLoggedIn()) return;

            int invId  = Convert.ToInt32(((LinkButton)sender).CommandArgument);
            int userId = GetUserId();

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();

                // Unequip all first
                SqlCommand unequipCmd = new SqlCommand(
                    "UPDATE userInventoryTable SET IsEquipped=0 WHERE UserId=@uid", conn);
                unequipCmd.Parameters.AddWithValue("@uid", userId);
                unequipCmd.ExecuteNonQuery();

                // Equip selected
                SqlCommand equipCmd = new SqlCommand(
                    "UPDATE userInventoryTable SET IsEquipped=1 WHERE InventoryId=@iid AND UserId=@uid", conn);
                equipCmd.Parameters.AddWithValue("@iid", invId);
                equipCmd.Parameters.AddWithValue("@uid", userId);
                equipCmd.ExecuteNonQuery();

                // Update session based on variant type
                SqlCommand tagCmd = new SqlCommand(
                    @"SELECT ui.Variant, si.Name, si.ImagePath, si.FrameImagePath
                      FROM userInventoryTable ui
                      JOIN shopItemTable si ON ui.ItemId = si.ItemId
                      WHERE ui.InventoryId = @iid", conn);
                tagCmd.Parameters.AddWithValue("@iid", invId);
                using (SqlDataReader dr = tagCmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        string variant = dr["Variant"] != DBNull.Value ? dr["Variant"].ToString() : "";

                        // Update userTable with the appropriate field based on variant
                        string nameTagValue = "";
                        string avatarFrameValue = "";

                        if (variant.ToLower() == "name")
                        {
                            nameTagValue = dr["ImagePath"] != DBNull.Value ? dr["ImagePath"].ToString() : "";
                            Session["nameTag"] = dr["Name"].ToString();
                        }
                        else if (variant.ToLower() == "frame")
                        {
                            avatarFrameValue = dr["FrameImagePath"] != DBNull.Value ? dr["FrameImagePath"].ToString() : "";
                            Session["avatarFrame"] = avatarFrameValue;
                        }
                    }
                }

                // Update userTable to persist the equipped items
                SqlCommand updateUserCmd = new SqlCommand(
                    @"UPDATE userTable 
                      SET NameTag = ISNULL((SELECT si.ImagePath FROM userInventoryTable ui 
                                           JOIN shopItemTable si ON ui.ItemId = si.ItemId 
                                           WHERE ui.UserId = @uid AND ui.IsEquipped = 1 AND ui.Variant = 'name'), ''),
                          AvatarFrame = ISNULL((SELECT si.FrameImagePath FROM userInventoryTable ui 
                                               JOIN shopItemTable si ON ui.ItemId = si.ItemId 
                                               WHERE ui.UserId = @uid AND ui.IsEquipped = 1 AND ui.Variant = 'frame'), '')
                      WHERE UserId = @uid", conn);
                updateUserCmd.Parameters.AddWithValue("@uid", userId);
                updateUserCmd.ExecuteNonQuery();
            }

            lblInvMsg.Text      = "Item equipped! Your profile has been updated.";
            lblInvMsg.ForeColor = System.Drawing.Color.FromArgb(104, 255, 0);
            LoadInventory();
            LoadUserPoints();
        }
    }
}
