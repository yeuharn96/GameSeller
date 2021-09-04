<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="GameSeller.Error" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cpHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cpBody" runat="server">
     <div class="container">
        <div class="row">
            <div class="col-12 text-center mb-4">
                <h1 class="display-1">
                    <i class="far fa-frown"></i> <b style="font-family: 'Comic Sans MS'">Oops!</b>
                    <br />
                    <asp:Label runat="server" ID="lblErrCode"></asp:Label>
                </h1>
            </div>
            <div class="col-12 text-center">
                <asp:Label runat="server" ID="lblErrMsg" CssClass="h2 d-block"></asp:Label>
                <a href="/Page/Home.aspx" class="btn btn-black mt-2">Back to Home page</a>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cpJs" runat="server">
</asp:Content>
