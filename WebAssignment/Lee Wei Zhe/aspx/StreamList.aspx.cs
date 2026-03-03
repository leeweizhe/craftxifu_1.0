using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAssignment.Lee_Wei_Zhe.aspx
{
    public partial class StreamList : System.Web.UI.Page
    {
        public int MyStreamID { get; set; }

        private string connStr = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadMyStream();       // Check if logged-in user is an instructor
                LoadAllStreams();     // Load everyone else
            }
        }

        // -------------------------------------------------------
        // Check if the logged-in user has their own stream
        // If yes, show it pinned at the top
        // -------------------------------------------------------
        private void LoadMyStream()
        {
            // If no one is logged in, skip
            if (Session["userId"] == null) return;

            int userId = Convert.ToInt32(Session["userId"]);
            string roleSql = "SELECT Role FROM userTable WHERE UserId = @userId";

            DataTable roleDt = GetData(roleSql, new SqlParameter("@userId", userId));
            if (roleDt.Rows[0]["Role"].ToString() != "Instructor") return;

            string sql = @"
                SELECT ls.StreamID, ls.StreamTitle, ls.ViewerCount, ls.IsLive,
                       u.Username, u.ProfilePicture
                FROM LiveStreams ls
                INNER JOIN userTable u ON ls.UserId = u.UserId
                WHERE ls.UserId = @userId";

            DataTable dt = GetData(sql, new SqlParameter("@userId", userId));

            // User has no stream — hide the "Your Stream" panel
            if (dt.Rows.Count == 0)
            {
                pnlCreateStream.Visible = true; // No stream yet, show + button
                return;
            }

            DataRow row = dt.Rows[0];
            MyStreamID = Convert.ToInt32(row["StreamID"]);

            // Fill in the "Your Stream" card
            litMyAvatar.Text = "<img src='" + row["ProfilePicture"].ToString() + "' class='avatar-img' />";
            litMyName.Text = row["Username"].ToString();
            litMyStreamTitle.Text = row["StreamTitle"].ToString();

            bool isLive = Convert.ToBoolean(row["IsLive"]);
            litMyStatus.Text = isLive
                ? "<span class='badge-live'>LIVE</span> " + row["ViewerCount"] + " viewers"
                : "<span class='badge-offline'>OFFLINE</span>";

            pnlMyStream.Visible = true; // Show the panel

        }
        // -------------------------------------------------------
        // Load all streams EXCEPT the logged-in user's own stream
        // Live streams appear first, then sorted by viewer count
        // -------------------------------------------------------
        private void LoadAllStreams()
        {
            // If logged in, exclude their own stream (already shown on top)
            int myUserId = Session["userId"] != null ? Convert.ToInt32(Session["userId"]) : -1;

            string sql = @"
                SELECT ls.StreamID, ls.StreamTitle, ls.ViewerCount, ls.IsLive,
                       u.Username, u.ProfilePicture
                FROM LiveStreams ls
                INNER JOIN userTable u ON ls.UserId = u.UserId
                WHERE ls.UserId <> @myUserId
                ORDER BY ls.IsLive DESC, ls.ViewerCount DESC";

            DataTable dt = GetData(sql, new SqlParameter("@myUserId", myUserId));

            if (dt.Rows.Count == 0 && !pnlMyStream.Visible)
                lblEmpty.Visible = true; // Show empty message only if nothing at all

            rptInstructors.DataSource = dt;
            rptInstructors.DataBind();
        }

        protected void btnCreateStream_Click(object sender, EventArgs e)
        {
            if (Session["userId"] == null) return;

            int userId = Convert.ToInt32(Session["userId"]);
            string defaultTitle = "Welcome to " + Session["username"] + "'s live stream";

            // Insert a default row into LiveStreams
            string sql = @"INSERT INTO LiveStreams (UserId, StreamTitle, ViewerCount, IsLive, YouTubeVideoID)
                   VALUES (@userId, @title, 0, 0, NULL)";

            ExecuteSQL(sql,
                new SqlParameter("@userId", userId),
                new SqlParameter("@title", defaultTitle));

            // Get the newly created StreamID and redirect to LiveStream.aspx
            DataTable newStream = GetData(
                "SELECT StreamID FROM LiveStreams WHERE UserId = @userId",
                new SqlParameter("@userId", userId));

            int newStreamId = Convert.ToInt32(newStream.Rows[0]["StreamID"]);
            Response.Redirect("LiveStream.aspx?id=" + newStreamId);
        }

        // Helper: INSERT / UPDATE / DELETE
        private void ExecuteSQL(string sql, params SqlParameter[] parameters)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                if (parameters != null) cmd.Parameters.AddRange(parameters);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        // Helper: run SQL and return a DataTable
        private DataTable GetData(string sql, params SqlParameter[] parameters)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                if (parameters != null) cmd.Parameters.AddRange(parameters);
                conn.Open();
                new SqlDataAdapter(cmd).Fill(dt);
            }
            return dt;
        }
    }
    
}