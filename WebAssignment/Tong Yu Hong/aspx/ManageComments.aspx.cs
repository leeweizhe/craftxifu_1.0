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
                COALESCE(bc.CommentDate, mc.CommentDate, pc.CommentDate, fc.CommentDate) as CommentDate,
                -- Hardcode 'Beginner Guide' if BeginnerId exists, else grab the other names
                CASE 
                    WHEN r.BeginnerId IS NOT NULL THEN 'Beginner Guide'
                    ELSE COALESCE(mt.MobName, pt.Name, ft.Title) 
                END as SectionName,
                COALESCE(bc.CommentText, mc.CommentText, pc.CommentText, fc.CommentText) as CommentText,
                u.Username as CommentAuthor,
                rep.Username as ReporterName
            FROM reportTable r
            LEFT JOIN BGCommentTable bc ON r.CommentId = bc.CommentId AND r.BeginnerId IS NOT NULL
            LEFT JOIN mobComment      mc ON r.CommentId = mc.CommentId AND r.MobId IS NOT NULL
            LEFT JOIN potionComment   pc ON r.CommentId = pc.CommentId AND r.PotionId IS NOT NULL
            LEFT JOIN commentTable     fc ON r.CommentId = fc.CommentId AND r.FarmId IS NOT NULL
            -- Joined tables for Mobs, Potions, and Farms
            LEFT JOIN mobTable        mt ON r.MobId = mt.MobId
            LEFT JOIN potionTable     pt ON r.PotionId = pt.PotionId
            LEFT JOIN farmTable       ft ON r.FarmId = ft.FarmId
            INNER JOIN userTable      u   ON u.UserId = COALESCE(bc.UserId, mc.UserId, pc.UserId, fc.UserId)
            LEFT JOIN userTable       rep ON r.ReporterId = rep.UserId
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
                    SELECT UserId, CommentText as BadText, (SELECT TOP 1 ReportId FROM reportTable WHERE CommentId = @cid) as ReportId FROM BGCommentTable WHERE CommentId = @cid
                    UNION ALL
                    SELECT UserId, CommentText as BadText, (SELECT TOP 1 ReportId FROM reportTable WHERE CommentId = @cid) FROM mobComment WHERE CommentId = @cid
                    UNION ALL
                    SELECT UserId, CommentText as BadText, (SELECT TOP 1 ReportId FROM reportTable WHERE CommentId = @cid) FROM potionComment WHERE CommentId = @cid
                    UNION ALL
                    SELECT UserId, CommentText as BadText, (SELECT TOP 1 ReportId FROM reportTable WHERE CommentId = @cid) FROM commentTable WHERE CommentId = @cid
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
            DELETE FROM reportTable WHERE CommentId = @cid;";

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
                // Notice I removed WarningId and @wid from the SQL string
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