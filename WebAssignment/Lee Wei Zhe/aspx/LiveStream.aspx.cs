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
    public partial class LiveStream : System.Web.UI.Page
    {
        private string connStr = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        private int streamId = 0;

        // Exposed to .aspx so JavaScript can read it
        public string YouTubeVideoID { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["id"], out streamId))
            {
                Response.Redirect("StreamList.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStream();
                LoadChat();
                CountViewer(increment: true);
            }
        }

        protected void Page_Unload(object sender, EventArgs e)
        {
            if (!IsPostBack && streamId > 0)
                CountViewer(increment: false);
        }

        private void LoadStream()
        {
            string sql = @"
                SELECT ls.StreamID, ls.StreamTitle, ls.ViewerCount,
                       ls.IsLive, ls.UserId, ls.YouTubeVideoID,
                       u.Username AS UserName
                FROM LiveStreams ls
                INNER JOIN userTable u ON ls.UserId = u.UserId
                WHERE ls.StreamID = @streamId";

            DataTable dt = GetData(sql, new SqlParameter("@streamId", streamId));

            if (dt.Rows.Count == 0) { Response.Redirect("InstructorList.aspx"); return; }

            DataRow row = dt.Rows[0];
            bool isLive = Convert.ToBoolean(row["IsLive"]);
            int ownerUserId = Convert.ToInt32(row["UserId"]);
            string ytID = row["YouTubeVideoID"] == DBNull.Value ? "" : row["YouTubeVideoID"].ToString().Trim();

            YouTubeVideoID = ytID;

            lblStatus.Text = isLive ? "LIVE" : "OFFLINE";
            lblStatus.CssClass = isLive ? "status-badge live" : "status-badge";

            lblStreamTitle.Text = row["UserName"] + " — " + row["StreamTitle"];
            lblViewerCount.Text = row["ViewerCount"] + " viewers";

            if (!string.IsNullOrEmpty(ytID))
            {
                pnlVideo.Visible = true;
                pnlNoVideo.Visible = false;
                pnlYouTubeChat.Visible = true;
                pnlOwnChat.Visible = false;
            }
            else
            {
                pnlVideo.Visible = false;
                pnlNoVideo.Visible = true;
                pnlYouTubeChat.Visible = false;
                pnlOwnChat.Visible = true;
            }

            bool isOwner = Session["userId"] != null &&
                           Convert.ToInt32(Session["userId"]) == ownerUserId;

            if (isOwner)
            {
                pnlInstructorControls.Visible = true;
                txtStreamTitle.Text = row["StreamTitle"].ToString();
                txtYouTubeID.Text = ytID;
                litViewerCount.Text = row["ViewerCount"].ToString();
                btnStartStream.Visible = !isLive;
                btnEndStream.Visible = isLive;
            }
        }

        private void CountViewer(bool increment)
        {
            string sql = increment
                ? "UPDATE LiveStreams SET ViewerCount = ViewerCount + 1 WHERE StreamID = @id"
                : "UPDATE LiveStreams SET ViewerCount = CASE WHEN ViewerCount > 0 THEN ViewerCount - 1 ELSE 0 END WHERE StreamID = @id";

            ExecuteSQL(sql, new SqlParameter("@id", streamId));
        }

        protected void btnSaveTitle_Click(object sender, EventArgs e)
        {
            string newTitle = txtStreamTitle.Text.Trim();
            if (string.IsNullOrEmpty(newTitle)) { ShowFeedback("Title cannot be empty.", false); return; }
            ExecuteSQL("UPDATE LiveStreams SET StreamTitle = @title WHERE StreamID = @id",
                new SqlParameter("@title", newTitle),
                new SqlParameter("@id", streamId));
            ShowFeedback("Title updated!", true);
        }

        protected void btnSaveYouTubeID_Click(object sender, EventArgs e)
        {
            string ytID = txtYouTubeID.Text.Trim();
            ExecuteSQL("UPDATE LiveStreams SET YouTubeVideoID = @ytID WHERE StreamID = @id",
                new SqlParameter("@ytID", ytID),
                new SqlParameter("@id", streamId));
            ShowFeedback("YouTube ID saved! Reload to see the stream.", true);
        }

        protected void btnStartStream_Click(object sender, EventArgs e)
        {
            ExecuteSQL("UPDATE LiveStreams SET IsLive = 1 WHERE StreamID = @id",
                new SqlParameter("@id", streamId));
            ShowFeedback("You are now LIVE!", true);
        }

        protected void btnEndStream_Click(object sender, EventArgs e)
        {
            ExecuteSQL("UPDATE LiveStreams SET IsLive = 0, ViewerCount = 0 WHERE StreamID = @id",
                new SqlParameter("@id", streamId));
            ShowFeedback("Stream ended.", false);
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            if (Session["userId"] == null || Session["username"] == null)
            {
                lblFeedback.Text = "You must be logged in to chat.";
                lblFeedback.CssClass = "chat-feedback error";
                LoadStream(); LoadChat();
                return;
            }

            int userId = Convert.ToInt32(Session["userId"]);
            string msg = txtMessage.Text.Trim();

            if (string.IsNullOrEmpty(msg))
            {
                lblFeedback.Text = "Please enter a message.";
                lblFeedback.CssClass = "chat-feedback error";
                LoadStream(); LoadChat();
                return;
            }

            string sql = @"INSERT INTO LSCommentTable (FarmId, UserId, CommentText, CommentDate)
                           VALUES (@streamId, @userId, @commentText, GETDATE())";

            ExecuteSQL(sql,
                new SqlParameter("@streamId", streamId),
                new SqlParameter("@userId", userId),
                new SqlParameter("@commentText", Server.HtmlEncode(msg)));

            txtMessage.Text = "";
            lblFeedback.Text = "Message sent!";
            lblFeedback.CssClass = "chat-feedback success";
            LoadStream(); LoadChat();
        }

        // -------------------------------------------------------
        // Chat: report a message
        // -------------------------------------------------------
        protected void lnkReport_Command(object sender, CommandEventArgs e)
        {
            if (Session["userId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            string[] args = e.CommandArgument.ToString().Split('|');
            if (args.Length < 2) return;

            string commentId = args[0];
            string reportStreamId = args[1];
            string reporterId = Session["userId"].ToString();

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "INSERT INTO reportTable (CommentId, ReporterId, StreamId) VALUES (@cid, @rid, @sid)";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@cid", commentId);
                    cmd.Parameters.AddWithValue("@rid", reporterId);
                    cmd.Parameters.AddWithValue("@sid", reportStreamId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Report submitted successfully.');", true);
            }
            catch (Exception ex)
            {
                // Optional: log error
            }

            LoadStream(); LoadChat();
        }

        // -------------------------------------------------------
        // Chat: bind messages from LSCommentTable to Repeater
        // -------------------------------------------------------
        private void LoadChat()
        {
            string sql = @"
                SELECT TOP 50
                       c.CommentId,
                       c.FarmId,
                       c.CommentText,
                       c.CommentDate,
                       u.Username
                FROM LSCommentTable c
                INNER JOIN userTable u ON c.UserId = u.UserId
                WHERE c.FarmId = @streamId
                ORDER BY c.CommentDate ASC";

            DataTable dt = GetData(sql, new SqlParameter("@streamId", streamId));

            rptChat.DataSource = dt;
            rptChat.DataBind();

            // Show "no messages" label only when there are no rows
            lblNoMessages.Visible = (dt.Rows.Count == 0);
        }

        private void ShowFeedback(string msg, bool success)
        {
            lblPanelFeedback.Text = msg;
            lblPanelFeedback.CssClass = success ? "chat-feedback success" : "chat-feedback error";
            LoadStream(); LoadChat();
        }

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
    }
}