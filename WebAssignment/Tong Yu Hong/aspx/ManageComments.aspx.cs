using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAssignment.Tong_Yu_Hong.aspx
{
    public partial class ManageComments : System.Web.UI.Page
    {
        private string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            string currentRole = Session["UserRole"] as string;
            if (string.IsNullOrEmpty(currentRole) || currentRole != "Admin")
            {
                Response.Redirect("~/Wong Zhang Zhe//Home.aspx");
                return;
            }
            if (!IsPostBack)
            {
                LoadReports();
            }
        }

        private void LoadReports()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = @"
            SELECT 
                r.ReportId, 
                r.CommentId, 
                r.ReportDate,
                COALESCE(bc.CommentDate, mc.CommentDate, pc.CommentDate, fc.CommentDate, lc.CommentDate) as CommentDate,
                -- Hardcode 'Beginner Guide' if BeginnerId exists, else grab the other names
                CASE 
                    WHEN r.BeginnerId IS NOT NULL THEN 'Beginner Guide'
                    ELSE COALESCE(mt.MobName, pt.Name, ft.Title, ls.StreamTitle) 
                END as SectionName,
                COALESCE(bc.CommentText, mc.CommentText, pc.CommentText, fc.CommentText, lc.CommentText) as CommentText,
                u.Username as CommentAuthor,
                rep.Username as ReporterName
            FROM reportTable r
            LEFT JOIN BGCommentTable bc ON r.CommentId = bc.CommentId AND r.BeginnerId IS NOT NULL
            LEFT JOIN mobComment      mc ON r.CommentId = mc.CommentId AND r.MobId IS NOT NULL
            LEFT JOIN potionComment   pc ON r.CommentId = pc.CommentId AND r.PotionId IS NOT NULL
            LEFT JOIN commentTable     fc ON r.CommentId = fc.CommentId AND r.FarmId IS NOT NULL
            LEFT JOIN LSCommentTable   lc ON r.CommentId = lc.CommentId AND r.StreamId IS NOT NULL
            -- Joined tables for Mobs, Potions, and Farms
            LEFT JOIN mobTable        mt ON r.MobId = mt.MobId
            LEFT JOIN potionTable     pt ON r.PotionId = pt.PotionId
            LEFT JOIN farmTable       ft ON r.FarmId = ft.FarmId
            LEFT JOIN LiveStreams     ls ON r.StreamId = lc.StreamID
            INNER JOIN userTable      u   ON u.UserId = COALESCE(bc.UserId, mc.UserId, pc.UserId, fc.UserId, lc.UserId)
            LEFT JOIN userTable       rep ON r.ReporterId = rep.UserId
            WHERE r.Status = 'Pending'
            ORDER BY r.ReportDate DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptReports.DataSource = dt;
                rptReports.DataBind();
                litReportCount.Text = dt.Rows.Count.ToString();
            }
        }

        protected void rptReports_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string commentId = e.CommandArgument.ToString();

            if (e.CommandName == "Delete") // This acts as "Hide and Warn"
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    // 1. Fetch data for the warning
                    string fetchSql = @"
                        SELECT TOP 1 UserId, BadText, ReportId FROM (
                            -- 1. Beginner Guide
                            SELECT bc.UserId, bc.CommentText as BadText, r.ReportId 
                            FROM BGCommentTable bc 
                            INNER JOIN reportTable r ON bc.CommentId = r.CommentId 
                            WHERE bc.CommentId = @cid AND r.BeginnerId IS NOT NULL

                            UNION ALL
                            -- 2. Mob Guide
                            SELECT mc.UserId, mc.CommentText as BadText, r.ReportId 
                            FROM mobComment mc 
                            INNER JOIN reportTable r ON mc.CommentId = r.CommentId 
                            WHERE mc.CommentId = @cid AND r.MobId IS NOT NULL

                            UNION ALL
                            -- 3. Potion Guide
                            SELECT pc.UserId, pc.CommentText as BadText, r.ReportId 
                            FROM potionComment pc 
                            INNER JOIN reportTable r ON pc.CommentId = r.CommentId 
                            WHERE pc.CommentId = @cid AND r.PotionId IS NOT NULL

                            UNION ALL
                            -- 4. Farm Guide
                            SELECT fc.UserId, fc.CommentText as BadText, r.ReportId 
                            FROM commentTable fc 
                            INNER JOIN reportTable r ON fc.CommentId = r.CommentId 
                            WHERE fc.CommentId = @cid AND r.FarmId IS NOT NULL

                            UNION ALL
                            -- 5. Livestream
                            SELECT lc.UserId, lc.CommentText as BadText, r.ReportId 
                            FROM LSCommentTable lc 
                            INNER JOIN reportTable r ON lc.CommentId = r.CommentId 
                            WHERE lc.CommentId = @cid AND r.StreamId IS NOT NULL
                        ) as CombinedComments";

                    SqlCommand cmdFetch = new SqlCommand(fetchSql, conn);
                    cmdFetch.Parameters.AddWithValue("@cid", commentId);
                    conn.Open();

                    using (SqlDataReader reader = cmdFetch.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            int userId = Convert.ToInt32(reader["UserId"]);
                            string badText = reader["BadText"].ToString();
                            int reportId = Convert.ToInt32(reader["ReportId"]);

                            // 2. Insert the Warning
                            InsertWarning(userId, badText, reportId);
                        }
                    }
                }

                // 3. Hide the comment and Clear the report
                HideComment(commentId);
            }
            else if (e.CommandName == "Clear")
            {
                // If you have a 'Clear' button that just ignores the report
                // You would pass the ReportId here
            }

            LoadReports();
        }

        private void HideComment(string commentId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // 1. Update Status to 'Hidden' in all potential tables
                // 2. Delete the record from reportTable ONLY
                string sql = @"
            UPDATE BGCommentTable SET Status = 'Hidden' WHERE CommentId = @cid;
            UPDATE mobComment      SET Status = 'Hidden' WHERE CommentId = @cid;
            UPDATE potionComment   SET Status = 'Hidden' WHERE CommentId = @cid;
            UPDATE commentTable    SET Status = 'Hidden' WHERE CommentId = @cid;
            UPDATE LSCommentTable  SET Status = 'Hidden' WHERE CommentId = @cid;
            UPDATE reportTable SET Status = 'Resolved' WHERE CommentId = @cid;";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@cid", commentId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void InsertWarning(int userId, string text, int reportId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = @"INSERT INTO warningTable (ReportId, UserId, WarningMessage, ReportedCommentText, WarningDate) 
                       VALUES (@rid, @uid, @msg, @text, GETDATE())";

                SqlCommand cmd = new SqlCommand(sql, conn);

                // Remove the line: cmd.Parameters.AddWithValue("@wid", nextId);

                cmd.Parameters.AddWithValue("@rid", reportId);
                cmd.Parameters.AddWithValue("@uid", userId);
                cmd.Parameters.AddWithValue("@msg", "Your comment was removed for violating community guidelines.");
                cmd.Parameters.AddWithValue("@text", text);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
}