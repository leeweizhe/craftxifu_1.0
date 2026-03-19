using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;
using System.Web.UI;

namespace WebAssignment.Tong_Yu_Hong.aspx
{
    public partial class AdminStatistics : System.Web.UI.Page
    {
        // ══════════════════════════════════════════════════════════════════
        // PAGE LOAD — Admin guard
        // ══════════════════════════════════════════════════════════════════
        protected void Page_Load(object sender, EventArgs e)
        {
            string currentRole = Session["UserRole"] as string;
            if (string.IsNullOrEmpty(currentRole) || currentRole != "Admin")
            {
                Response.Redirect("~/Wong Zhang Zhe/Home.aspx");
                return;
            }   
        }

        // ══════════════════════════════════════════════════════════════════
        // HELPER — shared connection string
        // ══════════════════════════════════════════════════════════════════
        private static string GetConn()
        {
            return ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        }

        // ══════════════════════════════════════════════════════════════════
        // WEBMETHOD — User Statistics
        // Returns: role split, gender split, top 10 by currency, top 10 countries
        // ══════════════════════════════════════════════════════════════════
        [WebMethod(EnableSession = true)]
        public static object GetUserStats(int days)
        {
            var roleLabels = new List<string>();
            var roleCounts = new List<int>();
            var genderLabels = new List<string>();
            var genderCounts = new List<int>();
            var currNames = new List<string>();
            var currValues = new List<int>();
            var countryLabels = new List<string>();
            var countryCounts = new List<int>();

            try
            {
                using (var conn = new SqlConnection(GetConn()))
                {
                    conn.Open();

                    // Users by role
                    using (var cmd = new SqlCommand(
                        "SELECT ISNULL(Role,'Unknown') AS Role, COUNT(*) AS Cnt " +
                        "FROM userTable GROUP BY Role ORDER BY Cnt DESC", conn))
                    using (var dr = cmd.ExecuteReader())
                        while (dr.Read())
                        {
                            roleLabels.Add(dr["Role"].ToString());
                            roleCounts.Add(Convert.ToInt32(dr["Cnt"]));
                        }

                    // Users by gender — map single-char codes to display names
                    using (var cmd = new SqlCommand(
                        "SELECT ISNULL(Gender,'?') AS Gender, COUNT(*) AS Cnt " +
                        "FROM userTable GROUP BY Gender ORDER BY Cnt DESC", conn))
                    using (var dr = cmd.ExecuteReader())
                        while (dr.Read())
                        {
                            string raw = dr["Gender"].ToString();
                            string label = raw == "M" ? "Male"
                                         : raw == "F" ? "Female"
                                         : "Unknown";
                            genderLabels.Add(label);
                            genderCounts.Add(Convert.ToInt32(dr["Cnt"]));
                        }

                    // Top 10 users by currency
                    using (var cmd = new SqlCommand(
                        "SELECT TOP 10 ISNULL(Username,'(no name)') AS Username, " +
                        "ISNULL(Currency,0) AS Currency " +
                        "FROM userTable ORDER BY Currency DESC", conn))
                    using (var dr = cmd.ExecuteReader())
                        while (dr.Read())
                        {
                            currNames.Add(dr["Username"].ToString());
                            currValues.Add(Convert.ToInt32(dr["Currency"]));
                        }

                    // Top 10 countries by user count
                    using (var cmd = new SqlCommand(
                        "SELECT TOP 10 ISNULL(Country,'Unknown') AS Country, COUNT(*) AS Cnt " +
                        "FROM userTable GROUP BY Country ORDER BY Cnt DESC", conn))
                    using (var dr = cmd.ExecuteReader())
                        while (dr.Read())
                        {
                            countryLabels.Add(dr["Country"].ToString());
                            countryCounts.Add(Convert.ToInt32(dr["Cnt"]));
                        }
                }
            }
            catch (Exception ex)
            {
                return new { error = ex.Message };
            }

            return new
            {
                role = new { labels = roleLabels, data = roleCounts },
                gender = new { labels = genderLabels, data = genderCounts },
                currency = new { labels = currNames, data = currValues },
                country = new { labels = countryLabels, data = countryCounts }
            };
        }

        // ══════════════════════════════════════════════════════════════════
        // WEBMETHOD — Minigame Statistics
        // Returns: plays per game, avg/max score per game, top 10 players
        // ══════════════════════════════════════════════════════════════════
        [WebMethod(EnableSession = true)]
        public static object GetMinigameStats(int days)
        {
            var playsLabels = new List<string>();
            var playsCounts = new List<int>();
            var scoreLabels = new List<string>();
            var avgScores = new List<double>();
            var maxScores = new List<int>();
            var lbNames = new List<string>();
            var lbPoints = new List<int>();

            try
            {
                string df = days > 0
                    ? "WHERE PlayedAt >= DATEADD(DAY, -" + days + ", GETDATE())"
                    : "";

                using (var conn = new SqlConnection(GetConn()))
                {
                    conn.Open();

                    // Plays per game
                    using (var cmd = new SqlCommand(
                        "SELECT GameName, COUNT(*) AS Plays FROM minigameScoreTable " +
                        df + " GROUP BY GameName ORDER BY Plays DESC", conn))
                    using (var dr = cmd.ExecuteReader())
                        while (dr.Read())
                        {
                            playsLabels.Add(dr["GameName"].ToString());
                            playsCounts.Add(Convert.ToInt32(dr["Plays"]));
                        }

                    // Avg and max score per game
                    using (var cmd = new SqlCommand(
                        "SELECT GameName, AVG(CAST(PointsEarned AS FLOAT)) AS Avg, " +
                        "MAX(PointsEarned) AS MaxP FROM minigameScoreTable " +
                        df + " GROUP BY GameName ORDER BY Avg DESC", conn))
                    using (var dr = cmd.ExecuteReader())
                        while (dr.Read())
                        {
                            scoreLabels.Add(dr["GameName"].ToString());
                            avgScores.Add(Math.Round(Convert.ToDouble(dr["Avg"]), 1));
                            maxScores.Add(Convert.ToInt32(dr["MaxP"]));
                        }

                    // Top 10 players by total points
                    string joinWhere = days > 0
                        ? "WHERE m.PlayedAt >= DATEADD(DAY, -" + days + ", GETDATE())"
                        : "";
                    using (var cmd = new SqlCommand(
                        "SELECT TOP 10 ISNULL(u.Username,'Unknown') AS Username, " +
                        "SUM(m.PointsEarned) AS Total " +
                        "FROM minigameScoreTable m " +
                        "JOIN userTable u ON m.UserId = u.UserId " +
                        joinWhere + " GROUP BY u.Username ORDER BY Total DESC", conn))
                    using (var dr = cmd.ExecuteReader())
                        while (dr.Read())
                        {
                            lbNames.Add(dr["Username"].ToString());
                            lbPoints.Add(Convert.ToInt32(dr["Total"]));
                        }
                }
            }
            catch (Exception ex)
            {
                return new { error = ex.Message };
            }

            return new
            {
                plays = new { labels = playsLabels, data = playsCounts },
                scores = new { labels = scoreLabels, avgData = avgScores, maxData = maxScores },
                leaderboard = new { labels = lbNames, data = lbPoints }
            };
        }

        // ══════════════════════════════════════════════════════════════════
        // WEBMETHOD — Shop & Economy Statistics
        // Returns: most purchased, revenue per item, rarity split, equipped rate
        // ══════════════════════════════════════════════════════════════════
        [WebMethod(EnableSession = true)]
        public static object GetShopStats(int days)
        {
            var purchaseNames = new List<string>();
            var purchaseCounts = new List<int>();
            var revenueNames = new List<string>();
            var revenueValues = new List<int>();
            var rarityLabels = new List<string>();
            var rarityCounts = new List<int>();
            var equippedData = new List<int>();

            try
            {
                string invFilter = days > 0
                    ? "WHERE i.PurchaseDate >= DATEADD(DAY, -" + days + ", GETDATE())"
                    : "";
                string invWhere = days > 0
                    ? "WHERE PurchaseDate >= DATEADD(DAY, -" + days + ", GETDATE())"
                    : "";

                using (var conn = new SqlConnection(GetConn()))
                {
                    conn.Open();

                    // Most purchased items (top 10)
                    using (var cmd = new SqlCommand(
                        "SELECT TOP 10 s.Name, COUNT(*) AS Cnt " +
                        "FROM userInventoryTable i " +
                        "JOIN shopItemTable s ON i.ItemId = s.ItemId " +
                        invFilter + " GROUP BY s.Name ORDER BY Cnt DESC", conn))
                    using (var dr = cmd.ExecuteReader())
                        while (dr.Read())
                        {
                            purchaseNames.Add(dr["Name"].ToString());
                            purchaseCounts.Add(Convert.ToInt32(dr["Cnt"]));
                        }

                    // Revenue per item — Price * purchase count
                    using (var cmd = new SqlCommand(
                        "SELECT TOP 10 s.Name, ISNULL(SUM(s.Price), 0) AS Rev " +
                        "FROM userInventoryTable i " +
                        "JOIN shopItemTable s ON i.ItemId = s.ItemId " +
                        invFilter + " GROUP BY s.Name ORDER BY Rev DESC", conn))
                    using (var dr = cmd.ExecuteReader())
                        while (dr.Read())
                        {
                            revenueNames.Add(dr["Name"].ToString());
                            revenueValues.Add(dr["Rev"] == DBNull.Value ? 0 : Convert.ToInt32(dr["Rev"]));
                        }

                    // Items by rarity (catalogue view — no date filter)
                    using (var cmd = new SqlCommand(
                        "SELECT ISNULL(Rarity,'Unknown') AS Rarity, COUNT(*) AS Cnt " +
                        "FROM shopItemTable GROUP BY Rarity ORDER BY Cnt DESC", conn))
                    using (var dr = cmd.ExecuteReader())
                        while (dr.Read())
                        {
                            rarityLabels.Add(dr["Rarity"].ToString());
                            rarityCounts.Add(Convert.ToInt32(dr["Cnt"]));
                        }

                    // Equipped vs not equipped
                    using (var cmd = new SqlCommand(
                        "SELECT " +
                        "ISNULL(SUM(CASE WHEN IsEquipped = 1 THEN 1 ELSE 0 END), 0) AS Equipped, " +
                        "ISNULL(SUM(CASE WHEN IsEquipped = 0 THEN 1 ELSE 0 END), 0) AS NotEquipped " +
                        "FROM userInventoryTable " + invWhere, conn))
                    using (var dr = cmd.ExecuteReader())
                        if (dr.Read())
                        {
                            equippedData.Add(dr["Equipped"] == DBNull.Value ? 0 : Convert.ToInt32(dr["Equipped"]));
                            equippedData.Add(dr["NotEquipped"] == DBNull.Value ? 0 : Convert.ToInt32(dr["NotEquipped"]));
                        }
                }
            }
            catch (Exception ex)
            {
                return new { error = ex.Message };
            }

            return new
            {
                purchases = new { labels = purchaseNames, data = purchaseCounts },
                revenue = new { labels = revenueNames, data = revenueValues },
                rarity = new { labels = rarityLabels, data = rarityCounts },
                equipped = new
                {
                    labels = new[] { "Equipped", "Not Equipped" },
                    data = equippedData
                }
            };
        }

        // ══════════════════════════════════════════════════════════════════
        // WEBMETHOD — Content Engagement Statistics
        // Returns: guide clicks, stream viewers vs clicks, comments by type
        // ══════════════════════════════════════════════════════════════════
        [WebMethod(EnableSession = true)]
        public static object GetContentStats(int days)
        {
            var guideLabels = new List<string>();
            var guideCounts = new List<int>();
            var streamTitles = new List<string>();
            var viewerCounts = new List<int>();
            var clickCounts = new List<int>();
            var commentCounts = new List<int>();

            try
            {
                // date filter applies to comment tables only
                string commentFilter = days > 0
                    ? "WHERE CommentDate >= DATEADD(DAY, -" + days + ", GETDATE())"
                    : "";

                using (var conn = new SqlConnection(GetConn()))
                {
                    conn.Open();

                    // Guide click counts
                    using (var cmd = new SqlCommand(
                        "SELECT GuideName, ClickCount FROM guideStatsTable " +
                        "ORDER BY ClickCount DESC", conn))
                    using (var dr = cmd.ExecuteReader())
                        while (dr.Read())
                        {
                            guideLabels.Add(dr["GuideName"].ToString());
                            guideCounts.Add(Convert.ToInt32(dr["ClickCount"]));
                        }

                    // Top 10 streams — ViewerCount and ClickCount
                    using (var cmd = new SqlCommand(
                        "SELECT TOP 10 ISNULL(StreamTitle,'(untitled)') AS StreamTitle, " +
                        "ISNULL(ViewerCount,0) AS ViewerCount, " +
                        "ISNULL(ClickCount,0) AS ClickCount " +
                        "FROM LiveStreams ORDER BY ViewerCount DESC", conn))
                    using (var dr = cmd.ExecuteReader())
                        while (dr.Read())
                        {
                            streamTitles.Add(dr["StreamTitle"].ToString());
                            viewerCounts.Add(Convert.ToInt32(dr["ViewerCount"]));
                            clickCounts.Add(Convert.ToInt32(dr["ClickCount"]));
                        }

                    // Comments per content type (union all four tables)
                    string[] tables = new[]
                    {
                        "commentTable",
                        "mobComment",
                        "LSCommentTable",
                        "BGCommentTable",
                        "enchantmentComment",
                        "potionComment"
                    };
                    string[] labels = new[] { "Farm Guides", "Mob Guides", "Live Streams", "Beginner Guides", "Enchantment Guide", "Potion Guide" };
                    for (int i = 0; i < tables.Length; i++)
                    {
                        string sql = "SELECT COUNT(*) FROM " + tables[i] + " " + commentFilter;
                        using (var cmd = new SqlCommand(sql, conn))
                            commentCounts.Add(Convert.ToInt32(cmd.ExecuteScalar()));
                    }
                }
            }
            catch (Exception ex)
            {
                return new { error = ex.Message };
            }

            return new
            {
                guides = new { labels = guideLabels, data = guideCounts },
                streams = new
                {
                    labels = streamTitles,
                    viewerData = viewerCounts,
                    clickData = clickCounts
                },
                commentTypes = new
                {
                    labels = new[] { "Farm Guides", "Mob Guides", "Live Streams", "Beginner Guides", "Enchantment Guide", "Potion Guide" },
                    data = commentCounts
                }
            };
        }

        // ══════════════════════════════════════════════════════════════════
        // WEBMETHOD — Moderation Statistics
        // Returns: reports by status, reports by content type, 
        //          warnings over time, comment status breakdown
        // ══════════════════════════════════════════════════════════════════
        [WebMethod(EnableSession = true)]
        public static object GetModerationStats(int days)
        {
            var statusLabels = new List<string>();
            var statusCounts = new List<int>();
            var warnPeriods = new List<string>();
            var warnCounts = new List<int>();
            var commentStatusData = new List<int>(); // Will hold [VisibleCount, HiddenCount]

            try
            {
                string rptFilter = days > 0
                    ? "WHERE ReportDate >= DATEADD(DAY, -" + days + ", GETDATE())"
                    : "";
                string warnFilter = days > 0
                    ? "WHERE WarningDate >= DATEADD(DAY, -" + days + ", GETDATE())"
                    : "";
                string cmtFilter = days > 0
                    ? "WHERE CommentDate >= DATEADD(DAY, -" + days + ", GETDATE())"
                    : "";

                using (var conn = new SqlConnection(GetConn()))
                {
                    conn.Open();

                    // 1. Reports by status
                    using (var cmd = new SqlCommand(
                        "SELECT ISNULL(Status,'Unknown') AS Status, COUNT(*) AS Cnt " +
                        "FROM reportTable " + rptFilter +
                        " GROUP BY Status ORDER BY Cnt DESC", conn))
                    using (var dr = cmd.ExecuteReader())
                        while (dr.Read())
                        {
                            statusLabels.Add(dr["Status"].ToString());
                            statusCounts.Add(Convert.ToInt32(dr["Cnt"]));
                        }

                    // 2. Warnings over time (daily)
                    using (var cmd = new SqlCommand(
                        "SELECT FORMAT(WarningDate,'yyyy-MM-dd') AS WDay, COUNT(*) AS Cnt " +
                        "FROM warningTable " + warnFilter +
                        " GROUP BY FORMAT(WarningDate,'yyyy-MM-dd') ORDER BY WDay ASC", conn))
                    using (var dr = cmd.ExecuteReader())
                        while (dr.Read())
                        {
                            warnPeriods.Add(dr["WDay"].ToString());
                            warnCounts.Add(Convert.ToInt32(dr["Cnt"]));
                        }

                    // 3. Comment status breakdown (Visible vs Hidden)
                    string unionSql =
                        "SELECT Status, CommentDate FROM commentTable " +
                        "UNION ALL SELECT Status, CommentDate FROM mobComment " +
                        "UNION ALL SELECT Status, CommentDate FROM LSCommentTable " +
                        "UNION ALL SELECT Status, CommentDate FROM BGCommentTable";

                    string commentWhere = string.IsNullOrEmpty(cmtFilter) ? "" : cmtFilter;

                    using (var cmd = new SqlCommand(
                        "SELECT ISNULL(Status,'Visible') AS Status, COUNT(*) AS Cnt " +
                        "FROM (" + unionSql + ") AS AllCmts " +
                        commentWhere +
                        " GROUP BY Status", conn))
                    using (var dr = cmd.ExecuteReader())
                    {
                        var statusMap = new System.Collections.Generic.Dictionary<string, int>(
                            StringComparer.OrdinalIgnoreCase);
                        while (dr.Read())
                            statusMap[dr["Status"].ToString()] = Convert.ToInt32(dr["Cnt"]);

                        // Map specifically to your two statuses
                        commentStatusData.Add(statusMap.ContainsKey("Visible") ? statusMap["Visible"] : 0);
                        commentStatusData.Add(statusMap.ContainsKey("Hidden") ? statusMap["Hidden"] : 0);
                    }

                    // 4. Reports by Content Type
                    var ctCounts = new List<int>();
                    using (var cmd = new SqlCommand(
                        "SELECT " +
                        "SUM(CASE WHEN FarmId      IS NOT NULL THEN 1 ELSE 0 END) AS Farm, " +
                        "SUM(CASE WHEN MobId       IS NOT NULL THEN 1 ELSE 0 END) AS Mob, " +
                        "SUM(CASE WHEN PotionId    IS NOT NULL THEN 1 ELSE 0 END) AS Potion, " +
                        "SUM(CASE WHEN StreamId    IS NOT NULL THEN 1 ELSE 0 END) AS Stream, " +
                        "SUM(CASE WHEN CommentId   IS NOT NULL THEN 1 ELSE 0 END) AS Comment, " +
                        "SUM(CASE WHEN BeginnerId  IS NOT NULL THEN 1 ELSE 0 END) AS Beginner " +
                        "FROM reportTable " + rptFilter, conn))
                    using (var dr = cmd.ExecuteReader())
                        if (dr.Read())
                        {
                            ctCounts.Add(Convert.ToInt32(dr["Farm"]));
                            ctCounts.Add(Convert.ToInt32(dr["Mob"]));
                            ctCounts.Add(Convert.ToInt32(dr["Potion"]));
                            ctCounts.Add(Convert.ToInt32(dr["Stream"]));
                            ctCounts.Add(Convert.ToInt32(dr["Comment"]));
                            ctCounts.Add(Convert.ToInt32(dr["Beginner"]));
                        }

                    // Return the cleaned up data
                    return new
                    {
                        reportStatus = new { labels = statusLabels, data = statusCounts },
                        reportTypes = new
                        {
                            labels = new[] { "Farm", "Mob", "Potion", "Stream", "Comment", "Beginner" },
                            data = ctCounts
                        },
                        warnings = new { labels = warnPeriods, data = warnCounts },
                        commentStatus = new
                        {
                            // FIXED: Changed labels to match your database
                            labels = new[] { "Visible", "Hidden" },
                            data = commentStatusData
                        }
                    };
                }
            }
            catch (Exception ex)
            {
                return new { error = ex.Message };
            }
        }
    }
}