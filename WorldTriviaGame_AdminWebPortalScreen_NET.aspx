<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="TitanbaseTrivia.aspx.vb" Inherits="DataEntryPortal._TitanbaseTrivia" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<meta name="viewport" content="initial-scale=.7, maximum-scale=.7">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Titanbase Online Trivia - World Trivia Champion</title>
    <style type="text/css">
        .style4
        {
            font-family: "Times New Roman", Times, serif;
            font-size: large;
        }
        .style5
        {
            font-family: Arial, Helvetica, sans-serif;
            width: 418px;
            text-align: center;
        }
        .GridViewStyle
        {
            font-family: Arial, Sans-Serif;
            font-size:small;
            table-layout: auto;
            border-collapse: collapse;
            border: #231D4D 5px solid;
        }

        .HeaderStyle, .PagerStyle 
        {
            background-image: url(http://localhost:8022/HeaderGlassBlack.jpg);
            background-position:center;
            background-repeat:repeat-x;
            background-color:#231D4D;
            color:White;
        }
        .HeaderStyle th
        {
            padding: 5px;
            color: #ffffff;
        }
        .HeaderStyle a
        {
            text-decoration:none;
            color:#ffffff;
            display:block;
            text-align:left;
            font-weight:normal;
        }
        .PagerStyle table
        {
            text-align:center;
            margin:auto;
        }
        .PagerStyle table td
        {
            border:0px;
            padding:5px;
        }
        .PagerStyle td
        {
            border-top: #231D4D 3px solid;
        }
        .PagerStyle a
        {
            color:#ffffff;
            text-decoration:none;
            padding:2px 10px 2px 10px;
            border-top:solid 1px #6459B7;
            border-right:solid 1px #231D4D;
            border-bottom:solid 1px #231D4D;
            border-left:solid 1px #6459B7;
        }
        .PagerStyle span
        {
            font-weight:bold;
            color:#FFFFFF;
            text-decoration:none;
            padding:2px 10px 2px 10px;
        }
        .RowStyle td, .AltRowStyle td, .SelectedRowStyle td, .EmptyRowStyle td, .EditRowStyle td
        {
            padding: 5px;
            padding-left: 17px;
            border-right: solid 1px #231D4D;
        }
        .RowStyle td
        {
            background-color: #c9c9c9;
            color:#250861;
        }
        .AltRowStyle td
        {
            background-color: #f0f0f0;
            color:#250861;
        }
        .SelectedRowStyle td
        {
            background-color: #ffff66;
            color:#250861;
        }
        .RankVal
        {
        	background-image: url(http://localhost:8022/numero.png);
            font-weight: bold;
        }
    </style>
</head>
<body style="font-family: Andalus; font-size: large; background-color: #000000;" 
    background="http://localhost:8022/bgimage.jpg" bgcolor="#000000">
    <form id="form1" runat="server">
    <div style="font-family: 'Lucida Grande'; font-size: large; font-weight: bolder; font-style: normal; color: #FFFFFF; text-align: center;">
        <asp:Image ID="Image1" runat="server" 
            ImageUrl="http://localhost:8022/topBar002.png" Height="68px" 
            Width="415px" />
        <br />
    
        <table align="center" 
            
            style="font-family: 'Lucida Grande'; font-size: medium; font-weight: bolder; font-style: normal; font-variant: normal; text-transform: none; color: #FFFFFF">
            <tr class="style4">
                <td class="style5">
                    <asp:TextBox ID="Ques" runat="server" Font-Names="Arial" 
                        Font-Size="medium" Height="87px" Rows="5" Width="400px" 
                        TextMode="MultiLine"></asp:TextBox>
                </td>
            </tr>
            <tr class="style4">
                <td class="style5">
                    Enter New Trivia Question</td>
            </tr>
            <tr class="style4">
                <td class="style5">
                    &nbsp;</td>
            </tr>
            <tr class="style4">
                <td class="style5">
                    <asp:TextBox ID="CA" runat="server" Font-Names="Arial" 
                        Font-Size="medium" Height="50px" Rows="3" Width="400px"></asp:TextBox>
                </td>
            </tr>
            <tr class="style4">
                <td class="style5">
                    Enter the Correct Answer</td>
            </tr>
            <tr class="style4">
                <td class="style5">
                    &nbsp;</td>
            </tr>
            <tr class="style4">
                <td class="style5">
                    <asp:TextBox ID="IC1" runat="server" Font-Names="Arial" 
                        Font-Size="medium" Height="50px" Rows="3" Width="400px"></asp:TextBox>
                </td>
            </tr>
            <tr class="style4">
                <td class="style5">
                    Enter an Incorrect Answer #1</td>
            </tr>
            <tr class="style4">
                <td class="style5">
                    &nbsp;</td>
            </tr>
            <tr class="style4">
                <td class="style5">
                    <asp:TextBox ID="IC2" runat="server" Font-Names="Arial" 
                        Font-Size="medium" Height="50px" Rows="3" Width="400px"></asp:TextBox>
                </td>
            </tr>
            <tr class="style4">
                <td class="style5">
                    Enter an Incorrect Answer #2</td>
            </tr>
            <tr class="style4">
                <td class="style5">
                    &nbsp;</td>
            </tr>
            <tr class="style4">
                <td class="style5">
                    <asp:TextBox ID="IC3" runat="server" Font-Names="Arial" 
                        Font-Size="medium" Height="50px" Rows="3" Width="400px"></asp:TextBox>
                </td>
            </tr>
            <tr class="style4">
                <td class="style5">
                    Enter an Incorrect Answer #3</td>
            </tr>
            <tr class="style4">
                <td class="style5">
                    &nbsp;</td>
            </tr>
            <tr class="style4">
                <td class="style5">
                    <asp:Button ID="SaveButton" runat="server" Font-Names="Arial" Font-Size="large" 
                        Text="Save My Question" />
                </td>
            </tr>
            <tr class="style4">
                <td class="style5" align="center">
                    &nbsp;</td>
            </tr>
            <tr class="style4">
                <td class="style5" align="center">
                    <a href="http://itunes.apple.com/app/world-trivia-champion-lite/id516331685?mt=8">
                    <img src="http://localhost:8022/midBar002.jpg" border="0" height="112px" width="384px" /></a></td>
            </tr>
            <tr class="style4">
                <td class="style5" align="center">
                    &nbsp;</td>
            </tr>
            <tr class="style4">
                <td class="style5" align="center">
                    <center><iframe src="https://www.facebook.com/plugins/like.php?href=http://apps.facebook.com/titanbasetrivia/"
        scrolling="no" frameborder="0"
        style="border:none; width:370px; height:80px"></iframe></center>
</td>
            </tr>
            <tr class="style4">
                <td class="style5" align="center">
                    <br />
                    <a href="http://localhost:8022/TitanbaseTriviawwr.aspx"><asp:Image ID="Image2" runat="server" ImageUrl="http://localhost:8022/bottomBar001.jpg" 
                        border="0" Height="37px" Width="396px" /></a>
                    <center>
                        <asp:GridView ID="GridView3" runat="server" AllowPaging="True" 
            AllowSorting="True" 
            DataSourceID="SqlDataSource3" Font-Bold="False" 
                            Width="390px"  CssClass="GridViewStyle" GridLines="None" PageSize="8">
                            <PagerSettings PageButtonCount="6" />
                <RowStyle CssClass="RowStyle" />
    <EmptyDataRowStyle CssClass="EmptyRowStyle" />
    <PagerStyle CssClass="PagerStyle" />
    <SelectedRowStyle CssClass="SelectedRowStyle" />
    <HeaderStyle CssClass="HeaderStyle" />
    <EditRowStyle CssClass="EditRowStyle" />
    <AlternatingRowStyle CssClass="AltRowStyle" />
        </asp:GridView></center>
        <asp:SqlDataSource ID="SqlDataSource3" runat="server" 
            ConnectionString="<%$ ConnectionStrings:DDXB144_TriviaConnectionString %>" 
            
            
            SelectCommand="SELECT RANK() OVER (ORDER BY correctAnswers DESC) AS [RANK], CompPlayerName as PLAYER, correctAnswers as SCORE FROM playerProfiles">
        </asp:SqlDataSource>  <a id="mainGrid" name="mainGrid"></a>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
