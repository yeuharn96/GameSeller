using GameSeller.App_Code;
using System;
using System.Linq;
using Newtonsoft.Json;
using System.Data;

namespace GameSeller.Page
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InitFilter();
                GetData();
            }
        }

        private void InitFilter()
        {
            string sql = "SELECT DISTINCT TagName FROM GameTag";

            ddlTagFilter.DataSource = Database.Query(sql);
            ddlTagFilter.DataTextField = ddlTagFilter.DataValueField = "TagName";
            ddlTagFilter.DataBind();

            ddlTagFilter.Items.Insert(0, "");
        }

        private void GetData()
        {
            string sql = @"SELECT G.Id, G.Title, G.Price, 
	                        (SELECT TOP 1 MediaPath FROM GameMedia WHERE GameId = G.Id AND Status = 1) AS MediaPath,
	                        (SELECT TagName FROM GameTag WHERE GameId = G.Id FOR JSON PATH) AS GameTags
                        FROM Game G
                        WHERE G.Status = 1";

            var dt = Database.Query(sql, "Id");
            rptBanner.DataSource = dt.AsEnumerable().Take(4).CopyToDataTable();
            rptBanner.DataBind();

            rptGameList.DataSource = dt;
            rptGameList.DataBind();
        }

        protected DataTable FormatGameTags(object gameTags)
        {
            return JsonConvert.DeserializeObject<DataTable>(gameTags.ToString());
        }

    }
}