using GameSeller.App_Code;
using Newtonsoft.Json;
using System;
using System.Data;

namespace GameSeller.Page
{
    public partial class Game : System.Web.UI.Page
    {
        protected string GameId
        {
            get { return (ViewState["GameId"] ?? string.Empty).ToString(); }
            set { ViewState["GameId"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (string.IsNullOrWhiteSpace(Request.QueryString["id"]))
                {
                    Response.Redirect("/Page/Home.aspx");
                }
                else
                {
                    GameId = Request.QueryString["id"];
                    GetData();
                }
            }
        }

        private void GetData()
        {
            string sql = @"SELECT G.Title, G.Price, G.Description,
	                            ISNULL((SELECT MediaPath FROM GameMedia WHERE GameId = G.Id AND Status = 1 FOR JSON PATH), '[]') AS MediaPath,
	                            ISNULL((SELECT TagName FROM GameTag WHERE GameId = G.Id FOR JSON PATH), '[]') AS GameTag
                            FROM Game G
                            WHERE G.Status = 1 AND G.Id = @Id";

            DataTable dt = new DataTable();
            Database.Connect(Database.ConnectionType.Read)
                .Cmd(sql)
                .AddCmdParam("@Id", SqlDbType.BigInt, Crypt.Decrypt(GameId))
                .ExecReader(ref dt)
                .Close();

            if (dt.Rows.Count > 0)
            {
                DataRow dr = dt.Rows[0];
                ltlTitle.Text = dr["Title"].ToString();
                ltlPrice.Text = "RM" + dr["Price"].ToString();
                ltlDescription.Text = dr["Description"].ToString();

                DataTable media = JsonConvert.DeserializeObject<DataTable>(dr["MediaPath"].ToString());
                imgBanner.ImageUrl = media.Rows[0]["MediaPath"].ToString();
                rptMedia.DataSource = media;
                rptMedia.DataBind();

                DataTable tag = JsonConvert.DeserializeObject<DataTable>(dr["GameTag"].ToString());
                rptGameTag.DataSource = tag;
                rptGameTag.DataBind();
            }
        }
    }
}