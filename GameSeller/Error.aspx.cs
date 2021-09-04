using System;

namespace GameSeller
{
    public partial class Error : System.Web.UI.Page
    {
        private string defaultMsg = "An unexpected error has occurred, please try again later.";
        protected void Page_Load(object sender, EventArgs e)
        {
            string errCode = Request.QueryString["code"];
            if (!string.IsNullOrEmpty(errCode))
            {
                lblErrCode.Text = string.Format("Error {0}", errCode);
            }

            switch (errCode)
            {
                case "404":
                    lblErrMsg.Text = "Looks like the page you are looking for doesn't exist";
                    break;

                default:
                    lblErrMsg.Text = defaultMsg;
                    break;
            }
        }
    }
}