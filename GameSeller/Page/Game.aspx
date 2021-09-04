<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Game.aspx.cs" Inherits="GameSeller.Page.Game" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cpHead" runat="server">
    <style type="text/css">
        img.banner{
            position:absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 100%;
        }

        .btn-buy{
            color: white;
            background-color: green;
        }

        .btn-buy:hover{
            color: white;
            background-color:forestgreen;
             box-shadow: 0 0 5px 0.25rem rgb(255, 255, 255, 0.5);
        }

        .game-tag label{
            padding: 0 10px;
            border: 1px solid white;
            border-radius: 5px;
        }

        .btn-media-arrow {
            position: absolute;
            top: 0;
            bottom: 0;
            z-index: 1;
            font-size: 2.5rem;
            color: gray;
            border: 0;
        }

        .media-preview img{
            min-width: 100%;
            min-height: 100%;
            max-height: 100%;
            max-width: 100%;
            object-fit: contain;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cpBody" runat="server">
    <div class="container">
        <div class="row">
            <div class="col-12 text-center" style="overflow:hidden; height: 25vh;">
                <asp:Image runat="server" ID="imgBanner" CssClass="banner" />
            </div>
        </div>

        <div class="row mt-3">
            <div class="col-12">
                <h1><asp:Literal runat="server" ID="ltlTitle"></asp:Literal></h1>
            </div>
        </div>

        <hr style="border-bottom: 1px solid darkgray" />

        <div class="row">
            <div class="col-md-4 order-md-last mb-3">
                <div class="price-tag d-flex">
                    <h2 class="d-inline m-0">
                        <asp:Literal runat="server" ID="ltlPrice"></asp:Literal>
                    </h2>
                    <asp:LinkButton runat="server" ID="btnAddCart" CssClass="btn btn-buy ml-2"><i class="fa fa-shopping-cart"></i> Purchase</asp:LinkButton>
                </div>
                <div class="game-tag mt-4">
                    <h6>Game Tags:</h6>
                    <asp:Repeater runat="server" ID="rptGameTag">
                        <ItemTemplate>
                            <label><%# Eval("TagName") %></label>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
            <div class="col-md-8 order-md-first">
                <div class="position-relative">
                    <button id="btn-prev" type="button" class="bg-transparent btn-media-arrow" style="left: 0;"><i class="fas fa-chevron-left"></i></button>
                    <button id="btn-next" type="button" class="bg-transparent btn-media-arrow" style="right: 0;"><i class="fas fa-chevron-right"></i></button>
        
                <div class="media-preview">
                    <asp:Repeater runat="server" ID="rptMedia">
                        <ItemTemplate>
                            <div class="media-item d-flex justify-content-center">
                                <img src="<%# Eval("MediaPath") %>" />
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                </div>
                <p>
                    <asp:Literal runat="server" ID="ltlDescription"></asp:Literal>
                </p>
            </div>

        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cpJs" runat="server">
    <script type="text/javascript">
        $(function () {
            $('.media-preview').slick({
                infinite: true,
                slidesToShow: 1,
                slidesToScroll: 1,
                prevArrow: $('#btn-prev'),
                nextArrow: $('#btn-next'),
                autoplay: true,
                autoplaySpeed: 3000,
                dots: true
            });
        });
    </script>
</asp:Content>
