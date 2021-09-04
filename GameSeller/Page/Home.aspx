<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="GameSeller.Page.Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cpHead" runat="server">
    <title>Welcome to Game Seller</title>
   
    <style type="text/css">
        .carousel-banner .banner-item {
            height: 50vh;
            display: flex;
            justify-content: center;
        }

            .carousel-banner .banner-item img {
                object-fit: contain;
                min-height: 100%;
                max-height: 100%;
                min-width: 100%;
                max-width: 100%;
            }

        .btn-banner-arrow {
            position: absolute;
            top: 0;
            bottom: 0;
            z-index: 1;
            font-size: 2.5rem;
            color: gray;
            border: 0;
        }

        .carousel-banner .banner-item .game-title {
            font-family: 'Comic Sans MS';
        }

        .carousel-banner .banner-item .game-desc {
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .tags label {
            border: 1px solid gray;
            border-radius: 5px;
            padding: 0 10px;
        }

        .dataTables_paginate.paging_simple_numbers span .paginate_button {
            color: white;
            opacity: 0.5;
            cursor: pointer;
        }

            .dataTables_paginate.paging_simple_numbers span .paginate_button.current {
                opacity: 1;
            }

        .tags.tag-clickable label {
            cursor: pointer;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cpBody" runat="server">

    <!-- carousel banner -->
    <div class="container-fluid position-relative mb-5">
        <button id="btn-prev" type="button" class="bg-transparent btn-banner-arrow" style="left: 0;"><i class="fas fa-chevron-left"></i></button>
        <button id="btn-next" type="button" class="bg-transparent btn-banner-arrow" style="right: 0;"><i class="fas fa-chevron-right"></i></button>
        <div class="carousel-banner">
            <asp:Repeater runat="server" ID="rptBanner">
                <ItemTemplate>
                    <div class="banner-item">
                        <div class="row">
                            <div class="col-6 h-100">
                                <img src='<%# Eval("MediaPath") %>' class="cursor-pointer"
                                    onclick="<%# "redirectDetailPage('" + Eval("Id") + "')" %>" />
                            </div>
                            <div class="col-6 h-100 game-desc">
                                <h2 class="game-title my-4 cursor-pointer"
                                    onclick="<%# "redirectDetailPage('" + Eval("Id") + "')" %>"><%# Eval("Title") %></h2>
                                <div class="price mb-4">
                                    <h3>RM <%# Eval("Price") %></h3>
                                </div>
                                <div class="tags">
                                    <asp:Repeater runat="server" DataSource='<%# FormatGameTags(Eval("GameTags")) %>'>
                                        <ItemTemplate>
                                            <label><%# Eval("TagName") %></label>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
    <!-- carousel banner END -->


    <!-- game list -->
    <div class="container my-2">
        <h1 class="my-2">Trending Games</h1>

        <!-- game list filter -->
        <div class="row my-2">
            <div class="col-md-6">
                <div class="form-inline">
                    <label>
                        Tag Filter:
                        <asp:DropDownList runat="server" ID="ddlTagFilter" CssClass="form-control ml-2"></asp:DropDownList>
                    </label>
                </div>
            </div>
            <div class="col-md-6">
                <div class="float-md-right float-none form-inline">
                    <label>
                        Search:
                        <input id="txt-tb-search" type="text" class="form-control ml-2" onkeyup="Table.searchText()" />
                    </label>
                </div>
            </div>
            <div class="col-12 my-2 tags tag-clickable tag-filter">
            </div>
        </div>
        <!-- game list filter END -->

        <table id="tb-list" class="table text-white">
            <thead>
                <tr class="row">
                    <th class="col-3"></th>
                    <th class="col-6">Title</th>
                    <th class="col-3">Price</th>
                </tr>
            </thead>
            <tbody>
                <asp:Repeater runat="server" ID="rptGameList">
                    <ItemTemplate>
                        <tr class="row">
                            <td class="col-3">
                                <img class="cursor-pointer" src='<%# Eval("MediaPath") %>'
                                    onclick="<%# "redirectDetailPage('" + Eval("Id") + "')" %>"
                                    style="max-width: 100%; max-height: 100%; overflow: hidden" />
                            </td>
                            <td class="col-6">
                                <h3 class="cursor-pointer" onclick="<%# "redirectDetailPage('" + Eval("Id") + "')" %>">
                                    <%# Eval("Title") %>
                                </h3>
                                <div class="tags tag-clickable">
                                    <asp:Repeater runat="server" DataSource='<%# FormatGameTags(Eval("GameTags")) %>'>
                                        <ItemTemplate>
                                            <label onclick="<%# string.Format("TagFilter.apply('{0}')", Eval("TagName")) %>">
                                                <%# Eval("TagName") %>
                                            </label>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </td>
                            <td class="col-3 h4">RM <%# Eval("Price") %></td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>
    </div>
    <!-- game list END -->
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cpJs" runat="server">
    <script type="text/javascript" src="//cdn.datatables.net/1.11.0/js/jquery.dataTables.min.js"></script>

    <script type="text/javascript">
        $(function () {
            $('.carousel-banner').slick({
                infinite: true,
                slidesToShow: 1,
                slidesToScroll: 1,
                prevArrow: $('#btn-prev'),
                nextArrow: $('#btn-next'),
                autoplay: true,
                autoplaySpeed: 3000,
                dots: true
            });

            $('#<%=ddlTagFilter.ClientID%>').change(function () {
                TagFilter.apply($(this).val());
                $(this).val('');
            });

            Table.init();
        });

        function redirectDetailPage(id) {
            Util.redirect('/Page/Game.aspx', { id: id });
        }

        const TagFilter = {
            tags: [],
            apply: function (tag) {
                if ($(`div.tag-filter label[data-value="${tag}"]`).length > 0)
                    return;

                TagFilter.tags.push(tag);
                $('div.tag-filter').append(`<label data-value="${tag}" onclick="TagFilter.remove('${tag}')">${tag}</label>`);

                Table.refresh();
            },
            remove: function (tag) {
                TagFilter.tags = TagFilter.tags.filter(t => t != tag);
                $(`div.tag-filter label[data-value="${tag}"]`).remove();

                Table.refresh();
            }
        }


        const Table = {
            dom: null,
            init: function () {
                // for paging buttons
                $.fn.dataTable.ext.classes.sPageButton = 'paginate_button btn btn-black mx-1';

                // custom tags filter
                $.fn.dataTable.ext.search.push(function (settings, data, dataIndex) {
                    return TagFilter.tags.every(t => data[1].includes(t));
                });

                Table.dom = $('#tb-list').DataTable({
                    dom: 't<"row"<"col text-white-50"i><"col text-center text-md-right"p>>',
                    pageLength: 20
                });
            },
            refresh: function () {
                Table.dom.draw();
            },
            searchText: function () {
                Table.dom.search($('#txt-tb-search').val()).draw();
            }
        }
    </script>
</asp:Content>
