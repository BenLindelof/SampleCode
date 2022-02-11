Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.ComponentModel
Imports System.Data.OleDb
Imports System.Data.SqlClient
Imports System.Data.Sql
Imports System.Web

Imports System.Text
Imports System.IO
Imports System.Data
Imports System.Xml

''required only if MySQL is enabled... line 44
'Imports MySql.Data
'Imports MySql.Web
'Imports MySql.Data.MySqlClient


' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<System.Web.Services.WebService(Namespace:="http://localhost/tbtss/")> _
<System.Web.Services.WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<ToolboxItem(False)> _
Public Class TBTriviaService
    Inherits System.Web.Services.WebService

    'Friend WithEvents Label1 As System.Windows.Forms.Label

    Private Sub InitializeComponent()
        'Me.Label1 = New System.Windows.Forms.Label
        ''
        ''Label1
        ''
        'Me.Label1.AutoSize = True
        'Me.Label1.Location = New System.Drawing.Point(0, 0)
        'Me.Label1.Name = "Label1"
        'Me.Label1.Size = New System.Drawing.Size(100, 23)
        'Me.Label1.TabIndex = 0
        'Me.Label1.Text = "Label1"

    End Sub

    Dim strDatabaseType = "SQL"
    'Dim strDatabaseType = "MrSQL"

    Dim intNumberofDatabaseQuestions = 5     'no longer used

    Dim intValuetoTrackGlobally = 0
    Dim debugVals As String
    Dim serverTimeRemainingMin = 0
    Dim serverTimeRemainingSec = 0
    Dim dateServerTimeQuestion As Date
    Dim intQuestionMode = 0
    Dim intQuestionisOutofTime = 0

    Dim dateCurrentServerTime As Date
    Dim tsServerQuestionSpan As TimeSpan
    Dim intSecondsSinceLastQuestion As Integer = 0
    Dim intMaxServerSecondsforQuestion As Integer = 11

    Dim strReplace As String = "***"

    Dim newDateCurrentServerTime As Date 'for next question to pop

    <WebMethod()> _
Public Function GetDataforXML_000005_login(ByVal loginText As String) As XmlDataDocument

        'GetDataforXML_000009_getRankingData
        'GetDataforXML_000010_getChatData
        'GetDataforXML_000011_sendChatData



        '   0»Zeliard»0

        ' status: 5 for login is 100% 
        ' client: must check to see if the profileNum is available, and send that if it is.
        ' if not send 0.
        'checked against multiple users. 

        Dim rawData As String = ""

        Dim rawLiveValues As String = ""

        'profileNum = 0
        'playerName = Zeliard
        'loggedinOK = 0

        'data=     
        '   0»Zeliard»0
        '  1»Zeliard»0

        'Dim strCurrentWWPlayers As String = "1"
        'Dim strCurrentWWRank As String = "1"

        Dim strPlayerName As String = "Unauthorized access"
        Dim strCompPlayer As String = "random"
        Dim intPlayerProfile As Integer = 0
        Dim intPlayerLoggedIn As Integer = 0
        Dim intRandomNum As Integer = 0

        Dim intRandomNumGenDBValue As Integer = 0  'check against for matches

        Dim dataValues() As String
        Dim intDataListSize As Integer = 0

        Try

            If loginText <> "" Then
                dataValues = Split(loginText, "»")
                intDataListSize = dataValues.Count - 1
                strPlayerName = Trim(dataValues(1).ToString)

                If strPlayerName.Count >= 75 Then
                    strPlayerName = strPlayerName.Substring(0, 74)
                End If


                'Encode the string input
                Dim strBuilder As New StringBuilder

                strBuilder = strBuilder.Append(strPlayerName)
                ' Selectively allow  and <i>
                strBuilder.Replace(">", "")
                strBuilder.Replace("<", "")
                strBuilder.Replace("#", "")
                strBuilder.Replace("&", "")
                strBuilder.Replace("!", "")
                strBuilder.Replace("@", "")
                strBuilder.Replace("$", "")
                strBuilder.Replace("%", "")
                strBuilder.Replace("^", "")
                strBuilder.Replace(";", "")
                strBuilder.Replace(":", "")
                strBuilder.Replace("""", "")
                strBuilder.Replace("'", "")
                strBuilder.Replace(".", "")
                strBuilder.Replace(",", "")
                strBuilder.Replace("?", "")
                strBuilder.Replace("/", "")
                strBuilder.Replace("\", "")
                strBuilder.Replace("|", "")
                strBuilder.Replace("{", "")
                strBuilder.Replace("}", "")
                strBuilder.Replace("(", "")
                strBuilder.Replace(")", "")
                strBuilder.Replace("_", "")
                strBuilder.Replace("~", "")
                strBuilder.Replace("`", "")
                strBuilder.Replace("*", "")
                strBuilder.Replace("+", "")
                strBuilder.Replace("=", "")
                strBuilder.Replace("[", "")
                strBuilder.Replace("]", "")
                strBuilder.Replace("\0", "")
                strBuilder.Replace("\n", "")
                strBuilder.Replace("\lfcr", "")
                strPlayerName = strBuilder.ToString()

                'NO NEW newrandom needed:  player ID:
                Randomize()
                intRandomNum = CInt(Math.Ceiling(Rnd() * 31000))
                'intIncomingRandomNum = 0
                'strPlayerName = strPlayerName.Substring(0, 74)
                intPlayerProfile = CInt(dataValues(0).ToString)
                intPlayerLoggedIn = CInt(dataValues(2).ToString)
                'intRandomNum = CInt(Math.Ceiling(Rnd() * 100000))

                'not used yet:
                strCompPlayer = strPlayerName & intRandomNum.ToString

            End If

        Catch exIORange As IndexOutOfRangeException
            strPlayerName = "Unauthorized access Your Request was Denied.[1]"

        Catch ex As Exception
            'System.IndexOutOfRangeException
            strPlayerName = "Unauthorized access Your Request was Denied.[2] " & ex.Message.ToString

        End Try

        'use with db: 'data=0»Zeliard»0

        '______________________________________________________________________________________________________
        If intPlayerProfile = 0 Then
            'not registered. they dont claim to be.

            If InStr(strPlayerName, "Unauthorized access") > 0 Then
                'do nothing
                strPlayerName = "Error"

            Else

                Dim timeZ As DateTime = DateTime.Now
                Dim formatZ As String = "yyyy/MM/dd HH:mm:ss"
                Dim CommandString As String = ""

                Dim dSet As New DataSet("game_room_01")

                Try

                    ''PART 1: CONN STRING


                    Dim conn As String = "Provider=SQLOLEDB;Data Source=RemovedForDemo;Initial Catalog=DDXB144_Trivia;User Id=ddxb144_Trivia;Password=PWhere;"
                    Dim Connection As New OleDb.OleDbConnection(conn)
                    Connection.Open()

                    CommandString = "INSERT INTO playerprofiles (CompPlayerName, timeIndex1, correctAnswers, incorrectAnswers, randomGen) VALUES ('" & strPlayerName & "', '" & timeZ.ToString(formatZ) & "', 0, 0, " & intRandomNum & ")"
                    Dim cmdZ As New OleDbCommand(CommandString, Connection)
                    cmdZ.ExecuteNonQuery()
                    cmdZ.Connection.Close()

                    Dim cmd As String = "SELECT * FROM playerprofiles WHERE CompPlayerName = '" & strPlayerName & "' AND randomGen = " & intRandomNum
                    Dim adapter As New OleDbDataAdapter(cmd, conn)

                    adapter.Fill(dSet, "node")
                    dSet.DataSetName = "game_room_01"





                    'dataset variables:
                    'Dim intNumCols As Integer = Table.Columns.Count
                    Dim intFirst As Integer = 0
                    Dim intColNumber As Integer = 0

                    'order by category variables:
                    Dim strCurrentCatName As String = ""
                    Dim strConcatCategoryList As String = ""
                    Dim intServiceTypeColNum As Integer = 0
                    Dim strSortByColName As String = "None"
                    Dim intCurrentRowNum As Integer = 0
                    Dim intCurrentRowTest As Integer = 0

                    '1.) BEGIN PARSING:
                    ''IF THERE IS A DATETIME = 00/00/00 something will complain in this code...

                    '2.) IDENTIFY CATEGORIES: (by strSortByColName specified above, or in database for this widget)
                    For Each table As DataTable In dSet.Tables

                        Dim intNumCols As Integer = table.Columns.Count

                        'Response.Write("TABLE '" & table.TableName & "'")      ' equalto: "node"
                        'Response.Write("Total # of rows: " & table.Rows.Count)

                        ' row-based:
                        For Each row As DataRow In table.Rows

                            rawLiveValues = rawLiveValues & "4{" & row(0).ToString & "}4" & row(1).ToString & row(2).ToString & row(3).ToString

                            'LIVE VALUES!
                            intPlayerProfile = CInt(row(0).ToString)
                            intRandomNum = CInt(row(6).ToString)

                            'TEST VALUES!
                            'strPlayerName = strPlayerName & "--" & row(1).ToString & "--" & row(2).ToString & "--" & row(3).ToString & "--"



                            ' CAT REORDER VERSION:
                            ' displays table as an HTML table:______________________________________________________StART
                            ' get all cells, column names, etc:
                            If intFirst = 0 Then
                                'Response.Write("<tr>")
                                For Each column As DataColumn In table.Columns
                                    'Response.Write("<td>" & column.ColumnName & "[" & intColNumber & "]<BR>" & column.DataType.ToString() & "</td>")

                                    'identify the ServiceType column number:
                                    If column.ColumnName.ToString = strSortByColName Then
                                        ' serviceType located. ID:
                                        intServiceTypeColNum = intColNumber
                                        'Exit For

                                    End If

                                    intColNumber = intColNumber + 1

                                Next  ' For Each column 

                                'Response.Write("</tr>")
                                intFirst = intFirst + 1   ' done with column headings

                            End If

                        Next

                    Next



                    For Each table As DataTable In dSet.Tables

                        Dim intNumCols As Integer = table.Columns.Count

                        For Each row As DataRow In table.Rows

                            ' 1. check if it matches the current cat:
                            'If strCurrentCategoryName = row(intServiceTypeColNum).ToString Then
                            ' 2. if it does, display it:
                            '          format of below is: currentrow(col #).tostring

                            'Response.Write("matched ID: " & row(0).ToString & ", " & row(3).ToString & ", " & row(2).ToString & "<BR>")

                            ' 2. correction: cycle through all columns and add to table:
                            ' (replace this with the XML generation code when completed)


                            ' normal data:
                            'Response.Write(vbTab & vbTab & "<node label=""" & row(3).ToString & """ data=""" & row(2).ToString & """ />" & vbCrLf)
                            'rawData = rawData & vbTab & vbTab & "<node label=""" & row(3).ToString & """ data=""" & row(2).ToString & """ />" & vbCrLf

                            ' description data:
                            'Response.Write(vbTab & vbTab & "<node label=""" & row(3).ToString & """ data=""" & row(6).ToString & """ />" & vbCrLf)
                            'rawData = rawData & vbTab & vbTab & "<node label=""" & row(3).ToString & """ data=""" & row(6).ToString & """ />" & vbCrLf
                            ' error above with RawData using column 6...
                            'this works:
                            'rawData = rawData & vbTab & vbTab & "<node label=""" & row(3).ToString & """ data=""" & row(2).ToString & """ />" & vbCrLf
                            'testing:
                            'OK tests:
                            'rawData = rawData & vbTab & vbTab & "<node label=""" & row(3).ToString & """ data=""" & Trim(row(5).ToString) & """ />" & vbCrLf
                            'rawData = rawData & vbTab & vbTab & "<node label=""" & row(3).ToString & """ data=""" & Trim(row(4).ToString) & """ />" & vbCrLf

                            rawLiveValues = rawLiveValues & "--[" & row(0).ToString & "]--"

                            'not OK tests:  invalid characters need encoding:
                            'Dim strReplacer As String = ""
                            'strReplacer = row(6).ToString.Replace("""", "")
                            'strReplacer = strReplacer.Replace("?", "")
                            'strReplacer = strReplacer.Replace("&", "and")
                            'rawData = rawData & vbTab & vbTab & "<node label=""" & row(3).ToString & """ data=""" & Trim(strReplacer) & """ />" & vbCrLf


                            'End If

                        Next

                    Next

                    '    'Response.Write(vbTab & "</node>" & vbCrLf)
                    '    rawData = rawData & vbTab & "</node>" & vbCrLf

                    'Next    ' next category.

                    ''5.) END PARSING:

                    ''Response.Write("</node>" & vbCrLf)
                    'rawData = rawData & "</node>" & vbCrLf


                    ''Response.Write(vbCrLf & vbCrLf & vbCrLf & vbCrLf & vbCrLf)


                    'adapter.Dispose()

                Catch ex As Exception
                    'Response.Write(
                    'ignore any exceptions, or add specific exceptions
                    'Console.Write(rawData)

                    'rawLiveValues = rawLiveValues & ex.Message
                    ' strPlayerName = ex.Message & ex.InnerException.ToString & "(" & timeZ.ToString(formatZ) & ")"

                    strPlayerName = ex.Message & "(" & CommandString & ")"

                End Try


            End If

        Else
            '______________________________________________________________________________________________________
            ' they 'claim' to be registered...

            'check for profile...


            If InStr(strPlayerName, "Unauthorized access") > 0 Then
                'do nothing
                strPlayerName = "Error"

            Else

                Dim timeZ As DateTime = DateTime.Now
                Dim formatZ As String = "yyyy/MM/dd HH:mm:ss"
                Dim CommandString As String = ""

                Dim dSet As New DataSet("game_room_01")

                Try

                    ''PART 1: CONN STRING


                    Dim conn As String = "Provider=SQLOLEDB;Data Source=RemovedForDemo;Initial Catalog=DDXB144_Trivia;User Id=ddxb144_Trivia;Password=PWhere;"
                    Dim Connection As New OleDb.OleDbConnection(conn)
                    Connection.Open()

                    'CommandString = "INSERT INTO playerprofiles (CompPlayerName, timeIndex1, correctAnswers, incorrectAnswers, randomGen) VALUES ('" & strPlayerName & "', '" & timeZ.ToString(formatZ) & "', 0, 0, " & intRandomNum & ")"
                    'Dim cmdZ As New OleDbCommand(CommandString, Connection)
                    'cmdZ.ExecuteNonQuery()
                    'cmdZ.Connection.Close()

                    Dim cmd As String = "SELECT * FROM playerprofiles WHERE CompPlayerName = '" & strPlayerName & "' AND idplayerProfiles = " & intPlayerProfile
                    Dim adapter As New OleDbDataAdapter(cmd, conn)

                    adapter.Fill(dSet, "node")
                    dSet.DataSetName = "game_room_01"






                    'dataset variables:
                    'Dim intNumCols As Integer = Table.Columns.Count
                    Dim intFirst As Integer = 0
                    Dim intColNumber As Integer = 0

                    'order by category variables:
                    Dim strCurrentCatName As String = ""
                    Dim strConcatCategoryList As String = ""
                    Dim intServiceTypeColNum As Integer = 0
                    Dim strSortByColName As String = "None"
                    Dim intCurrentRowNum As Integer = 0
                    Dim intCurrentRowTest As Integer = 0

                    'Dim intRandomNumGen As Integer

                    'intRandomNumGen = intRandomNum

                    '1.) BEGIN PARSING:
                    ''IF THERE IS A DATETIME = 00/00/00 something will complain in this code...

                    '2.) IDENTIFY CATEGORIES: (by strSortByColName specified above, or in database for this widget)
                    For Each table As DataTable In dSet.Tables

                        Dim intNumCols As Integer = table.Columns.Count

                        'Response.Write("TABLE '" & table.TableName & "'")      ' equalto: "node"
                        'Response.Write("Total # of rows: " & table.Rows.Count)

                        If table.Rows.Count = 0 Then

                            ' there is no profile with that match!
                            'strPlayerName = "No Player Found with that Info."
                            strPlayerName = "Error!"
                            intPlayerProfile = 0


                        End If

                        'For Each row As DataRow In Table.Rows

                        ' row-based:
                        For Each row As DataRow In table.Rows

                            rawLiveValues = rawLiveValues & "4{" & row(0).ToString & "}4" & row(1).ToString & row(2).ToString & row(3).ToString

                            'LIVE VALUES!
                            'intPlayerProfile = CInt(row(0).ToString)
                            'intRandomNumGen = intRandomNum
                            intRandomNumGenDBValue = CInt(row(6).ToString)
                            intRandomNum = CInt(row(6).ToString)


                            'TEST VALUES!
                            'strPlayerName = strPlayerName & "--" & row(1).ToString & "--" & row(2).ToString & "--" & row(3).ToString & "--"



                            ' CAT REORDER VERSION:
                            ' displays table as an HTML table:______________________________________________________StART
                            ' get all cells, column names, etc:
                            If intFirst = 0 Then
                                'Response.Write("<tr>")
                                For Each column As DataColumn In table.Columns
                                    'Response.Write("<td>" & column.ColumnName & "[" & intColNumber & "]<BR>" & column.DataType.ToString() & "</td>")

                                    'identify the ServiceType column number:
                                    If column.ColumnName.ToString = strSortByColName Then
                                        ' serviceType located. ID:
                                        intServiceTypeColNum = intColNumber
                                        'Exit For

                                    End If

                                    intColNumber = intColNumber + 1

                                Next  ' For Each column 

                                'Response.Write("</tr>")
                                intFirst = intFirst + 1   ' done with column headings

                            End If

                        Next

                    Next



                    For Each table As DataTable In dSet.Tables

                        Dim intNumCols As Integer = table.Columns.Count

                        For Each row As DataRow In table.Rows

                            ' 1. check if it matches the current cat:
                            'If strCurrentCategoryName = row(intServiceTypeColNum).ToString Then
                            ' 2. if it does, display it:
                            '          format of below is: currentrow(col #).tostring

                            'Response.Write("matched ID: " & row(0).ToString & ", " & row(3).ToString & ", " & row(2).ToString & "<BR>")

                            ' 2. correction: cycle through all columns and add to table:
                            ' (replace this with the XML generation code when completed)


                            ' normal data:
                            'Response.Write(vbTab & vbTab & "<node label=""" & row(3).ToString & """ data=""" & row(2).ToString & """ />" & vbCrLf)
                            'rawData = rawData & vbTab & vbTab & "<node label=""" & row(3).ToString & """ data=""" & row(2).ToString & """ />" & vbCrLf

                            ' description data:
                            'Response.Write(vbTab & vbTab & "<node label=""" & row(3).ToString & """ data=""" & row(6).ToString & """ />" & vbCrLf)
                            'rawData = rawData & vbTab & vbTab & "<node label=""" & row(3).ToString & """ data=""" & row(6).ToString & """ />" & vbCrLf
                            ' error above with RawData using column 6...
                            'this works:
                            'rawData = rawData & vbTab & vbTab & "<node label=""" & row(3).ToString & """ data=""" & row(2).ToString & """ />" & vbCrLf
                            'testing:
                            'OK tests:
                            'rawData = rawData & vbTab & vbTab & "<node label=""" & row(3).ToString & """ data=""" & Trim(row(5).ToString) & """ />" & vbCrLf
                            'rawData = rawData & vbTab & vbTab & "<node label=""" & row(3).ToString & """ data=""" & Trim(row(4).ToString) & """ />" & vbCrLf

                            rawLiveValues = rawLiveValues & "--[" & row(0).ToString & "]--"

                            'not OK tests:  invalid characters need encoding:
                            'Dim strReplacer As String = ""
                            'strReplacer = row(6).ToString.Replace("""", "")
                            'strReplacer = strReplacer.Replace("?", "")
                            'strReplacer = strReplacer.Replace("&", "and")
                            'rawData = rawData & vbTab & vbTab & "<node label=""" & row(3).ToString & """ data=""" & Trim(strReplacer) & """ />" & vbCrLf


                            'End If

                        Next

                    Next

                    'SHOW THE NO MATCH PROCESS:
                    If intRandomNumGenDBValue <> intRandomNum Then

                        'intPlayerProfile = 0
                        'strPlayerName = strPlayerName & intRandomNum.ToString & "-!noMatch!-" & intRandomNumGenDBValue.ToString

                    End If

                    '    'Response.Write(vbTab & "</node>" & vbCrLf)
                    '    rawData = rawData & vbTab & "</node>" & vbCrLf

                    'Next    ' next category.

                    ''5.) END PARSING:

                    ''Response.Write("</node>" & vbCrLf)
                    'rawData = rawData & "</node>" & vbCrLf


                    ''Response.Write(vbCrLf & vbCrLf & vbCrLf & vbCrLf & vbCrLf)


                    'adapter.Dispose()

                Catch ex As Exception
                    'Response.Write(
                    'ignore any exceptions, or add specific exceptions
                    'Console.Write(rawData)

                    'rawLiveValues = rawLiveValues & ex.Message
                    ' strPlayerName = ex.Message & ex.InnerException.ToString & "(" & timeZ.ToString(formatZ) & ")"

                    strPlayerName = ex.Message & "(" & CommandString & ")"

                End Try


            End If



        End If





        'PROCESS RESULT: check if intPlayerProfile = 0 that means it failed.


        'rawData is ready to go:
        'rawData & vbTab & vbTab & 

        'rawData = "<?xml version=""1.0"" encoding=""UTF-8"" ?>" & vbCrLf
        'rawData = rawData & vbTab & "<root>" & vbCrLf
        'rawData = rawData & vbTab & vbTab & "<node>" & rawLiveValues & "</node>" & vbCrLf
        'rawData = rawData & vbTab & "</root>" & vbCrLf

        'Dim byt As Byte() = System.Text.Encoding.UTF8.GetBytes(body)

        '' convert the byte array to a Base64 string

        'body = Convert.ToBase64String(byt)




        rawData = "<?xml version=""1.0"" encoding=""UTF-8"" ?>" & vbCrLf
        rawData = rawData & vbTab & "<root>" & vbCrLf

        If intPlayerProfile = 0 Then

            '[No profile found: «Unable to connect to any of the specified MySQL hosts.()«! Your Profile ID: «0« Your RandomGen: «0«]

            rawData = rawData & vbTab & " <TBMobile type=""gameData"">"
            'strPlayerName
            rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[No profile found: «" & strPlayerName & "«!" & " Your Profile ID: «" & intPlayerProfile & "« Your RandomGen: «0«]" & "]]></content>"
            'rawLiveValues
            'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[Welcome " & strPlayerName & "! (" & rawLiveValues & ") Your Profile ID: " & intPlayerProfile & " Your RandomGen: " & intRandomNum & "]" & "]]></content>"
            'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[" & loginText & "]" & "]]></content>"
            rawData = rawData & vbTab & " </TBMobile>"
            rawData = rawData & vbTab & "</root>" & vbCrLf


        Else

            rawData = rawData & vbTab & " <TBMobile type=""gameData"">"
            'strPlayerName
            rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[Welcome «" & strPlayerName & "«!" & " Your Profile ID: «" & intPlayerProfile & "« Your RandomGen: «" & intRandomNum & "«]" & "]]></content>"
            'rawLiveValues
            'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[Welcome " & strPlayerName & "! (" & rawLiveValues & ") Your Profile ID: " & intPlayerProfile & " Your RandomGen: " & intRandomNum & "]" & "]]></content>"
            'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[" & loginText & "]" & "]]></content>"
            rawData = rawData & vbTab & " </TBMobile>"
            rawData = rawData & vbTab & "</root>" & vbCrLf


        End If


        'IF PROFILENUM IS STILL ZERO AFTER THIS, THE RECORD WAS NOT CREATED SUCCESSFULLY!!!

        'E:\Users\benlindelof\Documents\SierraPubClub\WelcomeViewController.m

        'rawData = "<xml><root><node>vary</node></root>" & vbCrLf


        Dim xmlDoc As New XmlDataDocument
        xmlDoc.LoadXml(rawData)


        'Return lobjXMLDataSet
        Return xmlDoc


    End Function


    <WebMethod()>
    Public Function GetDataforXML_000007_goRoundStart(ByVal startRound As String) As XmlDataDocument

        'CURRENT TEST: 1»Ben»24»1379»0

        '           0»Zeliard»5»26176»0         ' live sql
        '           1»Zeliard»5»26176»0 

        Dim strCurrentWWPlayers As String = "1"
        Dim strCurrentWWRank As String = "1"

        ' status: 7 for askForQuestion is NOT 100% 
        ' client: only allow access to this if ProfileNum has been confirmed as set from #5 above.
        '
        ' score is 0 to start the game, set by the client.
        '
        ' server: get the CurrentQuestion #, the Current Question, and the times involved.
        ' client shows results:


        'GetDataforXML_000007_goRoundStart   startRound=
        'GetDataforXML_000008_selectionMade  selectionIs=


        'send:
        '        startGame = 1
        '        playerName = Zeliard
        '        profileNum = 1
        '        randomGen = 10256
        '        profileScore = 0
        '   1»Zeliard»1020»9939»0
        '   2»Zeliard»1020»9939»0    'continueGame

        'response:
        '        questionInProgress = No
        '        questionToAsk = "blahblah?"
        '        answerA = "yes"
        '        answerB = "no"
        '        answerC = "maybe"
        '        answerD = "I am"
        'timeToWaitForQuestion=000300  (3.00 seconds)
        'yourRank=300of300*
        'profileScore=500
        'profileNum = 1020
        'ranQuestionID = 1      ' auto-increment to 30000 then reset.
        'betweenQuestions = 0      '*
        '
        '    0»"Are you?"»"yes"»"no"»"maybe"»"I am"»500»300of300»500»1020»1»0
        ' 
        'OR YesinProgress, noTimeBonus, lucky if you make it...
        '
        '    1»"Are you?"»"yes"»"no"»"maybe"»"I am"»100»300of300»500»1020»1»0
        'OR
        '    0»"Are you?"»"yes"»"no"»"maybe"»"I am"»100»300of300»500»1020»1»250   '*youCaughtUsWhenaQuestionIsSwitchingTime,waitXseconds for nextQuestion.





        'GetDataforXML_000008_selectionMade
        '        When selected:
        'Send:
        '        SelectedAnswer = A
        '        TimeLeft = 300
        '
        '   1»Zeliard»1020»300»0    'continueGame   'A =1, B = 2, etc   0 is .. nothing atm


        '        No(Selection)
        '        SelectedAnswer = None
        '        TimeLeft = 0
        '
        '   0»Zeliard»1020»300»0    'continueGame   '0 is no response... A =1, B = 2, etc   0 is .. nothing atm

        '(Gives fastest score Best of)

        '        You() 've missed 3 questions! You’re out!


        Dim strIncomingRandomNum = ""
        Dim intIncomingRandomNum = 0

        Dim rawData As String = ""

        Dim rawLiveValues As String = ""

        Dim testLiveValues As String = ""

        'profileNum = 0
        'playerName = Zeliard
        'loggedinOK = 0

        '        startGame = 1                 intGameStatus
        '        playerName = Zeliard           strPlayerName
        '        profileNum = 1020              intPlayerProfile
        '        randomGen = 9939               intRandomGen
        '        profileScore = 0               intPlayerScore

        'data=     
        '   0»Zeliard»0 
        '   1»Zeliard»1020»9939»0    'startGame, user is new and would like to start...
        '   2»Zeliard»1020»9939»0    'continueGame, user is not new and would like to continue.

        Dim intGameStatus As Integer = 0
        Dim strPlayerName As String = "000."
        Dim strCompPlayer As String = "random"
        Dim intPlayerProfile As Integer = 0
        Dim intPlayerLoggedIn As Integer = 0
        Dim intRandomGen As Integer = 0
        Dim intPlayerScore As Integer = 0
        Dim intPlayerPlace As Integer = 0
        Dim intTotalPlaters As Integer = 0

        Dim intRandomQuestionNumber As Integer = 0
        Dim strCurrentQuestion As String = ""
        Dim strCurrentAnswerA As String = ""
        Dim strCurrentAnswerB As String = ""
        Dim strCurrentAnswerC As String = ""
        Dim strCurrentAnswerD As String = ""
        Dim intRandomQuestionNumberIsNew As Integer = 0

        'GLOBALS
        'Dim debugVals As String
        'Dim serverTimeRemainingMin = 0
        'Dim serverTimeRemainingSec = 0
        'Dim dateServerTimeQuestion As Date
        'Dim intQuestionMode = 0
        ' Dim intQuestionisOutofTime = 0

        Dim intNoAccessAllowed As Integer = 0


        Dim intQuestionIDNumberRCVD = 0

        Dim dataValues() As String
        Dim intDataListSize As Integer = 0

        Try

            If startRound <> "" Then
                dataValues = Split(startRound, "»")
                intDataListSize = dataValues.Count - 1

                If intDataListSize < 4 Then
                    'error!
                    intNoAccessAllowed = 1
                Else

                    'send:  ' SCORE IS ZERO...
                    '        startGame = 1                 intGameStatus
                    '        playerName = Zeliard           strPlayerName
                    '        profileNum = 1020              intPlayerProfile
                    '        randomGen = 9939               intRandomGen
                    '        profileScore = 0               intPlayerScore

                    '       1»Ben»24»1379»0

                    intGameStatus = dataValues(0).ToString
                    strPlayerName = Trim(dataValues(1).ToString)
                    intPlayerProfile = dataValues(2).ToString
                    intRandomGen = dataValues(3).ToString
                    intPlayerScore = dataValues(4).ToString


                End If


            Else
                'blanke!  set no access:
                intNoAccessAllowed = 1

            End If

        Catch exIORange As IndexOutOfRangeException
            strPlayerName = "Unauthorized access Your Request was Denied.[1]"

        Catch ex As Exception
            'System.IndexOutOfRangeException
            strPlayerName = "Unauthorized access Your Request was Denied.[2] " & ex.Message.ToString

        End Try

        'use with db: 'data=0»Zeliard»0


        'If InStr(strPlayerName, "Unauthorized access") > 0 Then
        '    'do nothing
        '    strPlayerName = "Error"

        'Else



        'CHECK IF THERE IS A CURRENT QUESTION!_________________________________________________

        If intNoAccessAllowed = 1 Then
            'blank you cant has:
            strPlayerName = "Unauthorized access Your Request was Denied.[3]"
        Else

            Dim timeZ As DateTime = DateTime.Now
            Dim formatZ As String = "yyyy/MM/dd HH:mm:ss"
            Dim CommandString As String = ""
            Dim conn As String = "Provider=SQLOLEDB;Data Source=RemovedForDemo;Initial Catalog=DDXB144_Trivia;User Id=ddxb144_Trivia;Password=PWhere;"

            Dim dSet As New DataSet("trivia_db001")
            Dim dSetZ As New DataSet("trivia_db001Z")

            'FIRST: set random question numebr and stop...
            Try

                ' load the randomnumber from a database selection:
                'Another for the Count....
                ' Select COUNT(Supplier_ID) from suppliers;
                'Dim cmdQ As String = "SELECT * FROM trivia_db001 WHERE idtrivia_db001 = '" & strQuesID & "'"
                'Dim cmdQZ As String = "Select COUNT(idtrivia_db001) from trivia_db001"
                'Dim cmdQZ As String = "SELECT TOP 1 idtrivia_db001 FROM trivia_db001 ORDER BY NEWID()"
                Dim cmdQZ As String = "SELECT TOP 1 idtrivia_db001 FROM trivia_db001 where InvisibleQues is null or InvisibleQues = 0 ORDER BY NEWID()"

                Dim adapterQZ As New OleDbDataAdapter(cmdQZ, conn)

                adapterQZ.Fill(dSetZ, "node2Z")
                dSetZ.DataSetName = "trivia_db002Z"



                '1.) BEGIN PARSING:
                ''IF THERE IS A DATETIME = 00/00/00 something will complain in this code...

                '2.) IDENTIFY CATEGORIES: (by strSortByColName specified above, or in database for this widget)
                For Each table2 As DataTable In dSetZ.Tables

                    Dim intNumColsZ As Integer = table2.Columns.Count

                    'Response.Write("TABLE '" & table.TableName & "'")      ' equalto: "node"
                    'Response.Write("Total # of rows: " & table.Rows.Count)

                    ' row-based:
                    For Each row As DataRow In table2.Rows

                        ' rawLiveValues = rawLiveValues & "ID # {" & row(0).ToString & "}" & row(1).ToString & row(2).ToString & row(3).ToString & row(4).ToString & row(5).ToString
                        'rawLiveValues = rawLiveValues & "OK! ID # {" & row(0).ToString & "} string: " & CommandString
                        rawLiveValues = rawLiveValues & "RANDOM! {" & row(0).ToString & "}<BR>"

                        strIncomingRandomNum = row(0).ToString
                        intIncomingRandomNum = CInt(strIncomingRandomNum)

                        'Response.Write(cmdQ)
                        'Response.Write(rawLiveValues)
                        'Label7.Text = row(0).ToString
                        'Label1.Text = row(1).ToString
                        'Label2.Text = strQuesID
                        'Label3.Text = row(2).ToString
                        'Label4.Text = row(3).ToString
                        'Label5.Text = row(4).ToString
                        'Label6.Text = row(5).ToString

                        'LIVE VALUES!
                        'intPlayerProfile = CInt(row(0).ToString)
                        'intRandomNum = CInt(row(6).ToString)

                    Next
                Next

            Catch ex As Exception
                rawLiveValues = ex.Message.ToString
            End Try


            're-uncomment:

            Try

                ''PART 1: CONN STRING
                If strDatabaseType = "MySQL" Then

                    'Dim conn As String = "server=localhost;user=root;database=ddxb144_trivia;port=3306;password=cylindro;"
                    'Dim Connection As New MySqlConnection(conn)
                    'Connection.Open()

                    ''CommandString = "INSERT INTO playerprofiles (CompPlayerName, timeIndex1, correctAnswers, incorrectAnswers, randomGen) VALUES (""" & strPlayerName & """, """ & timeZ.ToString(formatZ) & """, 0, 0, " & intRandomNum & ")"
                    ''Dim cmdZ As New MySqlCommand(CommandString, Connection)
                    ''cmdZ.ExecuteNonQuery()
                    ''cmdZ.Connection.Close()

                    ''Dim cmd As String = "SELECT * FROM playerprofiles WHERE CompPlayerName = """ & strPlayerName & """ AND randomGen = " & intRandomNum
                    'Dim cmd As String = "SELECT * FROM live_game_01"
                    'Dim adapter As New MySqlDataAdapter(cmd, conn)

                    'adapter.Fill(dSet, "node")
                    'dSet.DataSetName = "trivia_db001"

                Else

                    'Dim conn As String = "Provider=SQLOLEDB;Data Source=RemovedForDemo;Initial Catalog=DDXB144_Trivia;User Id=ddxb144_Trivia;Password=PWhere;"
                    Dim Connection As New OleDb.OleDbConnection(conn)
                    Connection.Open()

                    'CommandString = "INSERT INTO playerprofiles (CompPlayerName, timeIndex1, correctAnswers, incorrectAnswers, randomGen) VALUES ('" & strPlayerName & "', '" & timeZ.ToString(formatZ) & "', 0, 0, " & intRandomNum & ")"
                    'Dim cmdZ As New OleDbCommand(CommandString, Connection)
                    'cmdZ.ExecuteNonQuery()
                    'cmdZ.Connection.Close()

                    'Dim cmd As String = "SELECT * FROM trivia_db001 WHERE CompPlayerName = '" & strPlayerName & "' AND randomGen = " & intRandomNum
                    Dim cmd As String = "SELECT * FROM live_game_01"
                    Dim adapter As New OleDbDataAdapter(cmd, conn)

                    adapter.Fill(dSet, "node")
                    dSet.DataSetName = "trivia_db001"

                End If





                'dataset variables:
                'Dim intNumCols As Integer = Table.Columns.Count
                Dim intFirst As Integer = 0
                Dim intColNumber As Integer = 0

                'order by category variables:
                Dim strCurrentCatName As String = ""
                Dim strConcatCategoryList As String = ""
                Dim intServiceTypeColNum As Integer = 0
                Dim strSortByColName As String = "None"
                Dim intCurrentRowNum As Integer = 0
                Dim intCurrentRowTest As Integer = 0

                '1.) BEGIN PARSING:
                ''IF THERE IS A DATETIME = 00/00/00 something will complain in this code...

                '2.) IDENTIFY CATEGORIES: (by strSortByColName specified above, or in database for this widget)
                For Each table As DataTable In dSet.Tables

                    Dim intNumCols As Integer = table.Columns.Count

                    'Response.Write("TABLE '" & table.TableName & "'")      ' equalto: "node"
                    'Response.Write("Total # of rows: " & table.Rows.Count)

                    If table.Rows.Count = 0 Then
                        ' there is no current question!  pick one:

                        testLiveValues = "NO CURRENT QUESTION"

                        'newrandom needed:  not YET...
                        Randomize()
                        'intRandomQuestionNumber = CInt(Math.Ceiling(Rnd() * intNumberofDatabaseQuestions))
                        intRandomQuestionNumber = intIncomingRandomNum
                        intRandomQuestionNumberIsNew = 1
                        'testLiveValues = intRandomQuestionNumber

                        'load the question number:

                        ' IN THE NEXT SECTION... intRandomQuestionNumber is set.



                    Else
                        ' get the current question data..
                        'SEE IF THE QUESTION IS TIMELY...
                        ' set the intRandomQuestionNumber so we can load that question...


                        If strDatabaseType = "MySQL" Then

                            'Dim conn As String = "server=localhost;user=root;database=ddxb144_trivia;port=3306;password=cylindro;"
                            'Dim Connection As New MySqlConnection(conn)
                            'Connection.Open()

                            ''CommandString = "INSERT INTO playerprofiles (CompPlayerName, timeIndex1, correctAnswers, incorrectAnswers, randomGen) VALUES (""" & strPlayerName & """, """ & timeZ.ToString(formatZ) & """, 0, 0, " & intRandomNum & ")"
                            ''Dim cmdZ As New MySqlCommand(CommandString, Connection)
                            ''cmdZ.ExecuteNonQuery()
                            ''cmdZ.Connection.Close()

                            ''Dim cmd As String = "SELECT * FROM playerprofiles WHERE CompPlayerName = """ & strPlayerName & """ AND randomGen = " & intRandomNum
                            'Dim cmd As String = "SELECT * FROM live_game_01"
                            'Dim adapter As New MySqlDataAdapter(cmd, conn)

                            'adapter.Fill(dSet, "node")
                            'dSet.DataSetName = "trivia_db001"

                        Else

                            'Dim conn As String = "Provider=SQLOLEDB;Data Source=RemovedForDemo;Initial Catalog=DDXB144_Trivia;User Id=ddxb144_Trivia;Password=PWhere;"
                            Dim Connection As New OleDb.OleDbConnection(conn)
                            Connection.Open()

                            'CommandString = "INSERT INTO playerprofiles (CompPlayerName, timeIndex1, correctAnswers, incorrectAnswers, randomGen) VALUES ('" & strPlayerName & "', '" & timeZ.ToString(formatZ) & "', 0, 0, " & intRandomNum & ")"
                            'Dim cmdZ As New OleDbCommand(CommandString, Connection)
                            'cmdZ.ExecuteNonQuery()
                            'cmdZ.Connection.Close()

                            'Dim cmd As String = "SELECT * FROM trivia_db001 WHERE CompPlayerName = '" & strPlayerName & "' AND randomGen = " & intRandomNum
                            Dim cmd As String = "SELECT * FROM live_game_01"
                            Dim adapter As New OleDbDataAdapter(cmd, conn)

                            adapter.Fill(dSet, "node")
                            dSet.DataSetName = "trivia_db001"

                        End If

                        ' 
                        'load intRandomQuestionNumber with
                        'ALSO LOAD THE TIME REMAINING...
                        ' ALSO IF THE QUESTION IS OLD AND NO LONGER 'TIMELY' IT NEEDS TO BE DELETED AND REPLACED, and a new one set.



                        For Each table2 As DataTable In dSet.Tables
                            If table2.Rows.Count = 0 Then
                                ' there is no current question??

                            Else
                                For Each row As DataRow In table2.Rows

                                    'rawLiveValues = rawLiveValues & "4{" & row(0).ToString & "}4" & row(1).ToString & row(2).ToString & row(3).ToString

                                    testLiveValues = row(0).ToString
                                    'intRandomQuestionNumber = CInt(row(0).ToString)    ' this is correct for MySQL
                                    intRandomQuestionNumber = CInt(row(1).ToString)



                                    ' 6 and 7 are: serverTimeMinand Sec left (500 default)
                                    'TIME REMAINING IS...   8  
                                    'questionMode is 9

                                    serverTimeRemainingMin = row(6).ToString
                                    serverTimeRemainingSec = row(7).ToString

                                    dateServerTimeQuestion = DateTime.Parse(row(8).ToString)
                                    'now is:
                                    dateCurrentServerTime = DateTime.Now

                                    'output Differnce
                                    tsServerQuestionSpan = dateCurrentServerTime.Subtract(dateServerTimeQuestion)

                                    intSecondsSinceLastQuestion = tsServerQuestionSpan.TotalSeconds

                                    'debugVals = "Timespan since last question: [" & tsServerQuestionSpan.ToString & "] "
                                    debugVals = "seconds since last question: [" & intSecondsSinceLastQuestion.ToString & "] "
                                    '[Timespan since last question: [16.03:40:34.3974000]

                                    If ((intSecondsSinceLastQuestion > intMaxServerSecondsforQuestion)) Then
                                        ' out of time
                                        debugVals = debugVals & "*outoftime*"
                                        intQuestionisOutofTime = 1

                                    Else
                                        debugVals = debugVals & "*withinMaxTime*"

                                    End If

                                    ' if out of time, set question status to 4 which means we need a new question.
                                    ' return "NO QUESTION AVAIL, CHECK BACK IN 1 SECOND FOR QUESTiON"
                                    ' 


                                    '                                349.14:32:44.1937760
                                    'Here are the components of the output:

                                    '349:                            days()
                                    '14:                             hours()
                                    '32:                             minutes()
                                    '44:                             seconds()
                                    '1937760:                        milliseconds()
                                    '("Seconds: " + ts.Seconds);


                                    intQuestionMode = CInt(row(9).ToString)


                                    'GLOBALS
                                    'Dim debugVals As String
                                    'Dim serverTimeRemainingMin = 0
                                    'Dim serverTimeRemainingSec = 0
                                    'Dim dateServerTimeQuestion As Date
                                    'Dim intQuestionMode = 0
                                    ' Dim intQuestionisOutofTime = 0       'calculated

                                    'If (intQuestionMode > intMaxServerSecondsforQuestion) Then
                                    '    'debugVals = debugVals & 
                                    '    intQuestionisOutofTime = 1


                                    '    'Dim conn As String = "Provider=SQLOLEDB;Data Source=RemovedForDemo;Initial Catalog=DDXB144_Trivia;User Id=ddxb144_Trivia;Password=PWhere;"
                                    '    'Dim Connection As New OleDb.OleDbConnection(conn)
                                    '    'Connection.Open()

                                    '    'CommandString = "UPDATE live_game_01 SET questionMode=4 WHERE serverTimeLeft_sec=500"
                                    '    'Dim cmdZ As New OleDbCommand(CommandString, Connection)
                                    '    'cmdZ.ExecuteNonQuery()
                                    '    'cmdZ.Connection.Close()

                                    '    ''Dim cmd As String = "SELECT * FROM trivia_db001 WHERE CompPlayerName = '" & strPlayerName & "' AND randomGen = " & intRandomNum
                                    '    'Dim cmd As String = "SELECT * FROM trivia_db001 WHERE quesCat = 1 AND quesSubCat = 1"
                                    '    'Dim adapter As New OleDbDataAdapter(cmd, conn)

                                    '    'adapter.Fill(dSet, "node")
                                    '    'dSet.DataSetName = "trivia_db001"


                                    'End If









                                    'CHECK IF WE'RE TIMED OUT ON THIs QUESTION, IF WE ARE, SET A NEW QUESTION #:;
                                    'ALSO SET THAT WE HAS A NEW RANDOM... AND LOAD IT... AGAIN

                                    '1»Zeliard»1»10256»0    0-9 has row(x) values.  




                                Next


                            End If



                        Next


                    End If


                    If (intQuestionMode = 4) Then
                        ' we are already out of time... wait for next question
                        intQuestionisOutofTime = 1

                        ' set a new question on records that match =4 (so it is only done once)
                        ' and set back to 0 with new time.

                        'new random Question # from Maxnumber of ques
                        'Randomize()
                        'intRandomNum = CInt(Math.Ceiling(Rnd() * 31000))

                        'newrandom needed:







                        Randomize()
                        'intRandomQuestionNumber = CInt(Math.Ceiling(Rnd() * intNumberofDatabaseQuestions))
                        'intRandomQuestionNumberIsNew = 1  no not used here

                        intRandomQuestionNumber = intIncomingRandomNum

                        'save new question number and new status ID of question to 1:.   add 1 second to max Time:
                        'intMaxServerSecondsforQuestion + 1     (=11duringtest)
                        intMaxServerSecondsforQuestion = intMaxServerSecondsforQuestion + 1

                        'dateServerTimeQuestion = DateTime.Parse(row(8).ToString)
                        ''now is:
                        newDateCurrentServerTime = DateTime.Now


                        'newDateCurrentServerTime = dateCurrentServerTime.AddSeconds(intMaxServerSecondsforQuestion)
                        ' new quesetion pops in 1 sec!
                        newDateCurrentServerTime = dateCurrentServerTime.AddSeconds(1)

                        ''output Differnce
                        'tsServerQuestionSpan = dateCurrentServerTime.Subtract(dateServerTimeQuestion)

                        'intSecondsSinceLastQuestion = tsServerQuestionSpan.TotalSeconds

                        'Dim timeZ As DateTime = DateTime.Now
                        'Dim formatZ As String = "yyyy/MM/dd HH:mm:ss"
                        'Dim CommandString As String = ""


                        'Dim conn As String = "Provider=SQLOLEDB;Data Source=RemovedForDemo;Initial Catalog=DDXB144_Trivia;User Id=ddxb144_Trivia;Password=PWhere;"
                        Dim Connection As New OleDb.OleDbConnection(conn)
                        Connection.Open()

                        CommandString = "UPDATE live_game_01 SET serverTimeStarted ='" & newDateCurrentServerTime & "', trivia_id_num = " & intRandomQuestionNumber & ", questionMode=2 WHERE serverTimeLeft_sec=500 AND questionMode=4"
                        Dim cmdZ As New OleDbCommand(CommandString, Connection)
                        cmdZ.ExecuteNonQuery()
                        cmdZ.Connection.Close()


                    Else

                        If (intQuestionisOutofTime = 1) Then
                            'debugVals = debugVals & 
                            'intQuestionisOutofTime = 1


                            ' Dim conn As String = "Provider=SQLOLEDB;Data Source=RemovedForDemo;Initial Catalog=DDXB144_Trivia;User Id=ddxb144_Trivia;Password=PWhere;"
                            Dim Connection As New OleDb.OleDbConnection(conn)
                            Connection.Open()

                            CommandString = "UPDATE live_game_01 SET questionMode=4 WHERE serverTimeLeft_sec=500"
                            Dim cmdZ As New OleDbCommand(CommandString, Connection)
                            cmdZ.ExecuteNonQuery()
                            cmdZ.Connection.Close()

                            ''Dim cmd As String = "SELECT * FROM trivia_db001 WHERE CompPlayerName = '" & strPlayerName & "' AND randomGen = " & intRandomNum
                            'Dim cmd As String = "SELECT * FROM trivia_db001 WHERE quesCat = 1 AND quesSubCat = 1"
                            'Dim adapter As New OleDbDataAdapter(cmd, conn)

                            'adapter.Fill(dSet, "node")
                            'dSet.DataSetName = "trivia_db001"


                        End If


                    End If






                    ' row-based:
                    'For Each row As DataRow In table.Rows

                    '    rawLiveValues = rawLiveValues & "4{" & row(0).ToString & "}4" & row(1).ToString & row(2).ToString & row(3).ToString

                    '    'LIVE VALUES!
                    '    'intPlayerProfile = CInt(row(0).ToString)


                    '    'TEST VALUES!
                    '    strPlayerName = strPlayerName & "»" & row(1).ToString & "»" & row(2).ToString & "»" & row(3).ToString & "»" & row(4).ToString & "»" & row(5).ToString & "»"



                    '    ' CAT REORDER VERSION:
                    '    ' displays table as an HTML table:______________________________________________________StART
                    '    ' get all cells, column names, etc:
                    '    If intFirst = 0 Then
                    '        'Response.Write("<tr>")
                    '        For Each column As DataColumn In table.Columns
                    '            'Response.Write("<td>" & column.ColumnName & "[" & intColNumber & "]<BR>" & column.DataType.ToString() & "</td>")

                    '            'identify the ServiceType column number:
                    '            If column.ColumnName.ToString = strSortByColName Then
                    '                ' serviceType located. ID:
                    '                intServiceTypeColNum = intColNumber
                    '                'Exit For

                    '            End If

                    '            intColNumber = intColNumber + 1

                    '        Next  ' For Each column 

                    '        'Response.Write("</tr>")
                    '        intFirst = intFirst + 1   ' done with column headings

                    '    End If

                    'Next

                Next





            Catch ex As Exception
                'Response.Write(
                'ignore any exceptions, or add specific exceptions
                'Console.Write(rawData)

                'rawLiveValues = rawLiveValues & ex.Message
                ' strPlayerName = ex.Message & ex.InnerException.ToString & "(" & timeZ.ToString(formatZ) & ")"

                strPlayerName = ex.Message & "(" & CommandString & ")"

            End Try

            '________________________________________________________________________________________
            'save question # selected if it isn't.
            If intRandomQuestionNumberIsNew = 1 Then
                'save Current Question!


                If strDatabaseType = "MySQL" Then

                    'Dim conn As String = "server=localhost;user=root;database=ddxb144_trivia;port=3306;password=cylindro;"
                    'Dim Connection As New MySqlConnection(conn)
                    'Connection.Open()

                    ''CommandString = "INSERT INTO playerprofiles (CompPlayerName, timeIndex1, correctAnswers, incorrectAnswers, randomGen) VALUES (""" & strPlayerName & """, """ & timeZ.ToString(formatZ) & """, 0, 0, " & intRandomNum & ")"
                    ''INSERT INTO `ddxb144_trivia`.`live_game_01` (`trivia_id_num`, `serverTimeLeft_min`, `serverTimeLeft_sec`, `serverTimeStarted`) VALUES (2, 0, 500, '2012-01-12 12:12:12');
                    'CommandString = "INSERT INTO live_game_01 (trivia_id_num, serverTimeLeft_min, serverTimeLeft_sec, serverTimeStarted) VALUES (" & intRandomQuestionNumber & ", 500, 500, '2012-01-12 12:12:12')"
                    'Dim cmdZ As New MySqlCommand(CommandString, Connection)
                    'cmdZ.ExecuteNonQuery()
                    'cmdZ.Connection.Close()

                    ''Dim cmd As String = "SELECT * FROM playerprofiles WHERE CompPlayerName = """ & strPlayerName & """ AND randomGen = " & intRandomNum
                    ''Dim adapter As New MySqlDataAdapter(cmd, conn)

                    ''adapter.Fill(dSet, "node")
                    ''dSet.DataSetName = "game_room_01"

                Else

                    'Dim conn As String = "Provider=SQLOLEDB;Data Source=RemovedForDemo;Initial Catalog=DDXB144_Trivia;User Id=ddxb144_Trivia;Password=PWhere;"
                    Dim Connection As New OleDb.OleDbConnection(conn)
                    Connection.Open()

                    'CommandString = "INSERT INTO playerprofiles (CompPlayerName, timeIndex1, correctAnswers, incorrectAnswers, randomGen) VALUES ('" & strPlayerName & "', '" & timeZ.ToString(formatZ) & "', 0, 0, " & intRandomNum & ")"
                    CommandString = "INSERT INTO live_game_01 (trivia_id_num, serverTimeLeft_min, serverTimeLeft_sec, serverTimeStarted, questionMode) VALUES (" & intRandomQuestionNumber & ", 500, 500, '2012-01-12 12:12:12', 1)"

                    Dim cmdZ As New OleDbCommand(CommandString, Connection)
                    cmdZ.ExecuteNonQuery()
                    cmdZ.Connection.Close()

                    'Dim cmd As String = "SELECT * FROM playerprofiles WHERE CompPlayerName = '" & strPlayerName & "' AND randomGen = " & intRandomNum
                    'Dim adapter As New OleDbDataAdapter(cmd, conn)

                    'adapter.Fill(dSet, "node")
                    'dSet.DataSetName = "game_room_01"

                End If





            End If



            ' 500 until question begins by default!




            'RUN:
            strCurrentAnswerA = "GO!"

            ''intRandomQuestionNumber is set.. load the question.
            'testLiveValues = testLiveValues & "[load this one:" & intRandomQuestionNumber & "]now..."
            'strCurrentAnswerA = "HEY!"
            'testLiveValues = testLiveValues & "[TESTload this one:" & intRandomQuestionNumber & "]now..."
            'strCurrentAnswerA = "HEY!"


            '' SET 1-4 randomly
            Dim str1stAnswerDrawn = ""
            Dim str2ndAnswerDrawn = ""
            Dim str3rdAnswerDrawn = ""
            Dim str4thAnswerDrawn = ""


            If strDatabaseType = "MySQL" Then
                'strCurrentAnswerA = "MYSQL"

                'strCurrentAnswerA = "Load values.."

                'Dim conn As String = "server=localhost;user=root;database=ddxb144_trivia;port=3306;password=cylindro;"
                'Dim Connection As New MySqlConnection(conn)
                'Connection.Open()

                ''CommandString = "INSERT INTO playerprofiles (CompPlayerName, timeIndex1, correctAnswers, incorrectAnswers, randomGen) VALUES (""" & strPlayerName & """, """ & timeZ.ToString(formatZ) & """, 0, 0, " & intRandomNum & ")"
                ''Dim cmdZ As New MySqlCommand(CommandString, Connection)
                ''cmdZ.ExecuteNonQuery()
                ''cmdZ.Connection.Close()

                ''Dim cmd As String = "SELECT * FROM playerprofiles WHERE CompPlayerName = """ & strPlayerName & """ AND randomGen = " & intRandomNum
                ''SELECT * FROM trivia_db001 WHERE idtrivia_db001 = 3
                'Dim cmd As String = "SELECT * FROM trivia_db001 WHERE idtrivia_db001 = " & intRandomQuestionNumber.ToString
                'Dim adapter As New MySqlDataAdapter(cmd, conn)

                'strCurrentAnswerB = "Fill values"

                'adapter.Fill(dSet, "node")
                'dSet.DataSetName = "trivia_db002"

                ''strCurrentAnswerC = cmd


            Else
                ' run SQL
                strCurrentAnswerA = "SQL"

                'Dim conn As String = "Provider=SQLOLEDB;Data Source=RemovedForDemo;Initial Catalog=DDXB144_Trivia;User Id=ddxb144_Trivia;Password=PWhere;"
                Dim Connection As New OleDb.OleDbConnection(conn)
                Connection.Open()

                'CommandString = "INSERT INTO playerprofiles (CompPlayerName, timeIndex1, correctAnswers, incorrectAnswers, randomGen) VALUES ('" & strPlayerName & "', '" & timeZ.ToString(formatZ) & "', 0, 0, " & intRandomNum & ")"
                'Dim cmdZ As New OleDbCommand(CommandString, Connection)
                'cmdZ.ExecuteNonQuery()
                'cmdZ.Connection.Close()

                'Dim cmd As String = "SELECT * FROM trivia_db001 WHERE CompPlayerName = '" & strPlayerName & "' AND randomGen = " & intRandomNum
                Dim cmd As String = "SELECT * FROM trivia_db001 WHERE idtrivia_db001 = " & intRandomQuestionNumber.ToString
                Dim adapter As New OleDbDataAdapter(cmd, conn)

                adapter.Fill(dSet, "node")
                dSet.DataSetName = "trivia_db002"

                'str1stAnswerDrawn = cmd

            End If



            strCurrentQuestion = "going into table: "
            ''load intRandomQuestionNumber with


            'THIS BREAKS IT:

            For Each table3 As DataTable In dSet.Tables

                strCurrentQuestion = "going into table 3"

                If table3.Rows.Count = 0 Then
                    ' there is no current question??
                    strCurrentQuestion = "No QUestion found at id#"

                Else

                    'For Each row As DataRow In table.Rows
                    '   rawLiveValues = rawLiveValues & "4{" & row(0).ToString & "}4" & row(1).ToString & 



                    'no data is here:  START DEBUG HERE IF TRACKING VALUES...
                    For Each row As DataRow In table3.Rows

                        'rawLiveValues = rawLiveValues & "4{" & row(0).ToString & "}4" & row(1).ToString & row(2).ToString & row(3).ToString

                        ' testLiveValues = row(2).ToString
                        'If row(9).ToString = "" Then
                        If row(10).ToString = "" Then
                            ' this is 10 now not 9, since w eadded a column...

                            strCurrentQuestion = "blank"
                            strCurrentAnswerA = "blank"
                            strCurrentAnswerB = "blank"
                            strCurrentAnswerC = "blank"
                            strCurrentAnswerD = "blank"

                        Else

                            '' shift these too:
                            'strCurrentQuestion = row(10).ToString
                            'strCurrentAnswerA = row(11).ToString
                            'strCurrentAnswerB = row(12).ToString
                            'strCurrentAnswerC = row(13).ToString
                            'strCurrentAnswerD = row(14).ToString

                            ' new values:
                            intQuestionIDNumberRCVD = row(10).ToString
                            strCurrentQuestion = row(11).ToString
                            strCurrentAnswerA = row(12).ToString
                            strCurrentAnswerB = row(13).ToString
                            strCurrentAnswerC = row(14).ToString
                            strCurrentAnswerD = row(15).ToString

                        End If



                        'intRandomQuestionNumber = CInt(row(0).ToString)

                    Next


                End If



            Next

            'QUESTION DATA OK... NOW SAVE CURRENT QUESTION INFO FOR THE NEXT PLAYER.

            ' CLIENT RANDOMIZES.

            '1»Zeliard»1»26176»0


            'GET NEW DATA HERE:
            'need »President of Poland»500»300of300»500»1020»1»0«!«]]]></content>
            'rank data is invalid… use new
            '#1: change 300of300 to a total number of players registered.  say 34  
            '   Select COUNT(idplayerprofiles) from playerprofiles              (result  row0)
            '#2: change 500 after that to your current rank from here: 000009_getRankingData  (2)  with 53 points
            'SELECT * FROM (SELECT RANK() OVER (ORDER BY correctAnswers DESC) AS [Rank by correctAnswers], idplayerProfiles, CompPlayerName, correctAnswers, incorrectAnswers, randomGen, timeIndex1 FROM playerProfiles) As TempView WHERE idplayerProfiles=5
            'or id = 24
            'which gives us:  worldwide rank 2 of 34



            'Dim strCurrentWWRank As String = "1"
            Dim dSetZQ1 As New DataSet("trivia_db001ZQ1")
            Try

                Dim cmdQZQ1 As String = ""
                cmdQZQ1 = "SELECT * FROM (SELECT RANK() OVER (ORDER BY correctAnswers DESC) AS [Rank by correctAnswers], idplayerProfiles, CompPlayerName, correctAnswers, incorrectAnswers, randomGen, timeIndex1 FROM playerProfiles) As TempView WHERE idplayerProfiles = " & intPlayerProfile.ToString

                Dim adapterQZQ1 As New OleDbDataAdapter(cmdQZQ1, conn)

                adapterQZQ1.Fill(dSetZQ1, "node2ZQ1")
                dSetZQ1.DataSetName = "trivia_db002ZQ1"


                For Each table2Q1 As DataTable In dSetZQ1.Tables

                    Dim intNumColsZQ1 As Integer = table2Q1.Columns.Count

                    For Each row As DataRow In table2Q1.Rows

                        strCurrentWWRank = row(0).ToString
                        'strCurrentWWRank = strTop10Rank & row(2).ToString & "»" & row(3).ToString & "«"


                    Next

                    'strTop10Rank = strTop10Rank & "»»»"

                Next

            Catch ex As Exception
                rawLiveValues = ex.Message.ToString
            End Try




            'Dim strCurrentWWPlayers As String = "1"
            Dim dSetZQ2 As New DataSet("trivia_db001ZQ2")
            Try

                Dim cmdQZQ2 As String = ""
                cmdQZQ2 = "Select COUNT(idplayerprofiles) from playerprofiles"

                Dim adapterQZQ2 As New OleDbDataAdapter(cmdQZQ2, conn)

                adapterQZQ2.Fill(dSetZQ2, "node2ZQ2")
                dSetZQ2.DataSetName = "trivia_db002ZQ2"


                For Each table2Q2 As DataTable In dSetZQ2.Tables

                    Dim intNumColsZQ2 As Integer = table2Q2.Columns.Count

                    For Each row As DataRow In table2Q2.Rows

                        strCurrentWWPlayers = row(0).ToString
                        'strTop10Rank = strTop10Rank & row(2).ToString & "»" & row(3).ToString & "«"


                    Next

                    'strTop10Rank = strTop10Rank & "»»»"

                Next

            Catch ex As Exception
                rawLiveValues = ex.Message.ToString
            End Try







        End If


        If intNoAccessAllowed = 1 Then
            'blank you cant has:
            strPlayerName = "Unauthorized access Your Request was Denied.[3]"

        End If




        'response:
        '        questionInProgress = No
        '        questionToAsk = "blahblah?"
        '        answerA = "yes"
        '        answerB = "no"
        '        answerC = "maybe"
        '        answerD = "I am"
        'timeToWaitForQuestion=000300  (3.00 seconds)
        'yourRank=300of300*
        'profileScore=500
        'profileNum = 1020
        'ranQuestionID = 1      ' auto-increment to 30000 then reset.
        'betweenQuestions = 0      '*
        '
        '    0»"Are you?"»"yes"»"no"»"maybe"»"I am"»500»300of300»500»1020»1»0
        ' 
        'OR YesinProgress, noTimeBonus, lucky if you make it...
        '
        '    1»"Are you?"»"yes"»"no"»"maybe"»"I am"»100»300of300»500»1020»1»0
        'OR
        '    0»"Are you?"»"yes"»"no"»"maybe"»"I am"»100»300of300»500»1020»1»250   '*youCaughtUsWhenaQuestionIsSwitchingTime,waitXseconds for nextQuestion.




        'PROCESS RESULT: check if intPlayerProfile = 0 that means it failed.


        'rawData is ready to go:
        'rawData & vbTab & vbTab & 

        'rawData = "<?xml version=""1.0"" encoding=""UTF-8"" ?>" & vbCrLf
        'rawData = rawData & vbTab & "<root>" & vbCrLf
        'rawData = rawData & vbTab & vbTab & "<node>" & rawLiveValues & "</node>" & vbCrLf
        'rawData = rawData & vbTab & "</root>" & vbCrLf

        'Dim byt As Byte() = System.Text.Encoding.UTF8.GetBytes(body)

        '' convert the byte array to a Base64 string

        'body = Convert.ToBase64String(byt)

        rawData = "<?xml version=""1.0"" encoding=""UTF-8"" ?>" & vbCrLf
        rawData = rawData & vbTab & "<root>" & vbCrLf

        '        If intPlayerProfile = 0 Then

        'DEFAULT = 0 for this, and 555

        '[No profile found: «Unable to connect to any of the specified MySQL hosts.()«! Your Profile ID: «0« Your RandomGen: «0«]

        rawData = rawData & vbTab & " <TBMobile type=""gameData"">"
        'strPlayerName
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[555: «" & strPlayerName & "«!" & " Your Profile ID: «" & intPlayerProfile & "« Your RandomGen: «0«]" & "]]></content>"
        'tEST:
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[555" & testLiveValues & "]: «" & "0»""Are you?""»""yes""»""no""»""maybe""»""I am""»500»300of300»500»1020»1»0" & "«!" & "«]" & "]]></content>"

        'LIVE'                          strCurrentQuestion = row(1).ToString
        'strCurrentAnswerA = row(2).ToString
        'strCurrentAnswerB = row(3).ToString
        'strCurrentAnswerC = row(4).ToString
        'strCurrentAnswerD = row(5).ToString
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[444" & testLiveValues & "]: [[" & debugVals & "]] «[" & strPlayerName & "]»»0»" & strCurrentQuestion & "»[" & strCurrentAnswerA & "]»" & strCurrentAnswerB & "»" & strCurrentAnswerC & "»" & strCurrentAnswerD & "»500»" & strCurrentWWRank & "»" & strCurrentWWPlayers & "»1020»1»0" & "«!" & "«]" & "]]></content>"

        rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[444" & testLiveValues & "]: [[" & debugVals & "]] «[" & strPlayerName & "]»»0»" & strCurrentQuestion & "»" & strCurrentAnswerA & "»" & strCurrentAnswerB & "»" & strCurrentAnswerC & "»" & strCurrentAnswerD & "»500»" & strCurrentWWRank & "»" & strCurrentWWPlayers & "»1020»1»0" & "«!" & "«]" & "]]></content>"


        'rawLiveValues
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[444" & rawLiveValues & "]: [[" & debugVals & "]] «[" & strPlayerName & "]»»0»" & strCurrentQuestion & "»[" & strCurrentAnswerA & "]»" & strCurrentAnswerB & "»" & strCurrentAnswerC & "»" & strCurrentAnswerD & "»500»300of300»500»1020»1»0" & "«!" & "«]" & "]]></content>"


        'rawLiveValues
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[Welcome " & strPlayerName & "! (" & rawLiveValues & ") Your Profile ID: " & intPlayerProfile & " Your RandomGen: " & intRandomNum & "]" & "]]></content>"
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[" & loginText & "]" & "]]></content>"
        rawData = rawData & vbTab & " </TBMobile>"
        rawData = rawData & vbTab & "</root>" & vbCrLf


        'Else

        '    rawData = rawData & vbTab & " <TBMobile type=""gameData"">"
        '    'strPlayerName
        '    'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[556 «" & strPlayerName & "«!" & " Your Profile ID: «" & intPlayerProfile & "« Your RandomGen: «" & intRandomNum & "«]" & "]]></content>"
        '    rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[756]: «" & strPlayerName & "«!" & "«]" & "]]></content>"

        '    'rawLiveValues
        '    'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[Welcome " & strPlayerName & "! (" & rawLiveValues & ") Your Profile ID: " & intPlayerProfile & " Your RandomGen: " & intRandomNum & "]" & "]]></content>"
        '    'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[" & loginText & "]" & "]]></content>"
        '    rawData = rawData & vbTab & " </TBMobile>"
        '    rawData = rawData & vbTab & "</root>" & vbCrLf


        'End If

        '<content>
        '<![CDATA[
        '[556 «444.»What famous document begins: "When in the course of human events...”»The Declaration of Independence»The Bill of Rights»The US Constitution»The Gettysburg address»«! Your Profile ID: «1« Your RandomGen: «0«]
        ']]>
        '</content>


        'IF PROFILENUM IS STILL ZERO AFTER THIS, THE RECORD WAS NOT CREATED SUCCESSFULLY!!!

        'E:\Users\benlindelof\Documents\SierraPubClub\WelcomeViewController.m

        'rawData = "<xml><root><node>vary</node></root>" & vbCrLf


        Dim xmlDoc As New XmlDataDocument
        xmlDoc.LoadXml(rawData)


        'Return lobjXMLDataSet
        Return xmlDoc


    End Function


    <WebMethod()>
    Public Function GetDataforXML_000008_selectionMade(ByVal selectionIs As String) As XmlDataDocument

        'new selection code:
        '1»Zeliard»5»26176»1          'correct answer
        '1»Zeliard»5»26176»0        '   incorrect
        '1»Zeliard»5»26176»2           'ran outta time...

        'NEW!
        '1»Ben»24»1379»1»53     // score is last...


        'RESPOND BACK:
        '1.) acknowledged: with new score
        '2.) same question?  can't answer again... check again in 1 sec, if it is, client must not be stupid
        '3.) 


        ' just respond with new total, or something.  then ask for new question in a second.





        'GetDataforXML_000008_selectionMade    selectionIs=


        'response:
        '        questionInProgress = No
        '        questionToAsk = "blahblah?"
        '        answerA = "yes"
        '        answerB = "no"
        '        answerC = "maybe"
        '        answerD = "I am"
        'timeToWaitForQuestion=000300  (3.00 seconds)
        'yourRank=300of300*
        'profileScore=500
        'profileNum = 1020
        'ranQuestionID = 1      ' auto-increment to 30000 then reset.
        'betweenQuestions = 0      '*
        '
        '    0»"Are you?"»"yes"»"no"»"maybe"»"I am"»500»300of300»500»1020»1»0
        ' 
        'OR YesinProgress, noTimeBonus, lucky if you make it...
        '
        '    1»"Are you?"»"yes"»"no"»"maybe"»"I am"»100»300of300»500»1020»1»0
        'OR
        '    0»"Are you?"»"yes"»"no"»"maybe"»"I am"»100»300of300»500»1020»1»250   '*youCaughtUsWhenaQuestionIsSwitchingTime,waitXseconds for nextQuestion.



        'GetDataforXML_000008_selectionMade
        '        When selected:
        'Send:
        '        SelectedAnswer = A
        '        TimeLeft = 300
        '
        '   1»Zeliard»1020»300»0    'continueGame   'A =1, B = 2, etc   0 is .. nothing atm


        '        No(Selection)
        '        SelectedAnswer = None
        '        TimeLeft = 0
        '
        '   0»Zeliard»1020»300»0    'continueGame   '0 is no response... A =1, B = 2, etc   0 is .. nothing atm

        '(Gives fastest score Best of)

        '        You() 've missed 3 questions! You’re out!


        Dim rawData As String = ""

        Dim rawLiveValues As String = ""

        'profileNum = 0
        'playerName = Zeliard
        'loggedinOK = 0

        'data=     
        '   0»Zeliard»0

        Dim strPlayerName As String = "000."
        Dim strCompPlayer As String = "random"
        Dim intPlayerProfile As Integer = 0
        Dim intPlayerLoggedIn As Integer = 0
        Dim intRandomGen As Integer = 0
        Dim intPlayerScore As Integer = 0
        Dim intPlayerPlace As Integer = 0
        Dim intTotalPlaters As Integer = 0
        Dim intGameStatus As Integer = 0

        Dim intTimeLeft As Integer = 0

        Dim dataValues() As String
        Dim intDataListSize As Integer = 0

        '//just assume true
        Dim intPlayerAnswer = 1

        Dim strCurrentNowRank As String = "1"
        Dim strCurrentNowTotal As String = "1"

        Try

            If selectionIs <> "" Then
                dataValues = Split(selectionIs, "»")
                intDataListSize = dataValues.Count - 1

                'new selection code:
                '1»Zeliard»1»26176»1          'correct answer
                '1»Zeliard»1»26176»0        '   incorrect
                '1»Zeliard»1»26176»2           'ran outta time...

                'load score, add new points, save score, return XML
                ' rank is checked when question is checked 1 second later.

                intGameStatus = dataValues(0).ToString
                strPlayerName = Trim(dataValues(1).ToString)
                intPlayerProfile = dataValues(2).ToString

                intRandomGen = dataValues(3).ToString

                intPlayerAnswer = dataValues(4).ToString


                'intTimeLeft = dataValues(4).ToString
                intPlayerScore = dataValues(5).ToString



                'send:  ' SCORE IS ZERO...
                '        startGame = 1
                '        playerName = Zeliard
                '        profileNum = 1020
                '        randomGen = 9939
                '        profileScore = 0

                '   1»Zeliard»1020»9939»0

                'Send:
                '        SelectedAnswer = A
                '        TimeLeft = 300
                '
                '   1»Zeliard»1020»9939»300»0    'continueGame   'A =1, B = 2, etc   0 is .. nothing atm


                '        No(Selection)
                '        SelectedAnswer = None
                '        TimeLeft = 0
                '
                '   0»Zeliard»1020»9939»300»0    'continueGame   '0 is no response... A =1, B = 2, etc   0 is .. nothing atm


                'intGameStatus = dataValues(0).ToString
                'strPlayerName = Trim(dataValues(1).ToString)
                'intPlayerProfile = dataValues(2).ToString
                'intRandomGen = dataValues(3).ToString
                'intTimeLeft = dataValues(4).ToString
                'intPlayerScore = dataValues(5).ToString


            End If

        Catch exIORange As IndexOutOfRangeException
            strPlayerName = "Unauthorized access Your Request was Denied.[1]"

        Catch ex As Exception
            'System.IndexOutOfRangeException
            strPlayerName = "Unauthorized access Your Request was Denied.[2] " & ex.Message.ToString

        End Try

        'use with db: 'data=0»Zeliard»0


        'If InStr(strPlayerName, "Unauthorized access") > 0 Then
        '    'do nothing
        '    strPlayerName = "Error"

        'Else


        Dim timeZ As DateTime = DateTime.Now
        Dim formatZ As String = "yyyy/MM/dd HH:mm:ss"
        Dim CommandString As String = ""

        Dim dSet As New DataSet("trivia_db001")

        Try

            ''PART 1: CONN STRING



            Dim conn As String = "Provider=SQLOLEDB;Data Source=RemovedForDemo;Initial Catalog=DDXB144_Trivia;User Id=ddxb144_Trivia;Password=PWhere;"
            Dim Connection As New OleDb.OleDbConnection(conn)
            Connection.Open()

            'CommandString = "INSERT INTO playerprofiles (CompPlayerName, timeIndex1, correctAnswers, incorrectAnswers, randomGen) VALUES ('" & strPlayerName & "', '" & timeZ.ToString(formatZ) & "', 0, 0, " & intRandomNum & ")"
            'Dim cmdZ As New OleDbCommand(CommandString, Connection)
            'cmdZ.ExecuteNonQuery()
            'cmdZ.Connection.Close()

            Dim cmd As String = "SELECT * FROM playerprofiles WHERE CompPlayerName = '" & strPlayerName & "' AND randomGen = " & intRandomGen
            Dim adapter As New OleDbDataAdapter(cmd, conn)

            adapter.Fill(dSet, "node")
            dSet.DataSetName = "game_room_01"





            'dataset variables:
            'Dim intNumCols As Integer = Table.Columns.Count
            Dim intFirst As Integer = 0
            Dim intColNumber As Integer = 0

            'order by category variables:
            Dim strCurrentCatName As String = ""
            Dim strConcatCategoryList As String = ""
            Dim intServiceTypeColNum As Integer = 0
            Dim strSortByColName As String = "None"
            Dim intCurrentRowNum As Integer = 0
            Dim intCurrentRowTest As Integer = 0

            '1.) BEGIN PARSING:
            ''IF THERE IS A DATETIME = 00/00/00 something will complain in this code...

            '2.) IDENTIFY CATEGORIES: (by strSortByColName specified above, or in database for this widget)
            For Each table As DataTable In dSet.Tables

                Dim intNumCols As Integer = table.Columns.Count

                'Response.Write("TABLE '" & table.TableName & "'")      ' equalto: "node"
                'Response.Write("Total # of rows: " & table.Rows.Count)

                ' row-based:
                For Each row As DataRow In table.Rows

                    rawLiveValues = rawLiveValues & "4{" & row(0).ToString & "}4" & row(1).ToString & row(2).ToString & row(3).ToString

                    'intPlayerScore = CInt(row(2).ToString)
                    'current Score before adding if there is one to add...

                    'LIVE VALUES!
                    'intPlayerProfile = CInt(row(0).ToString)


                    'TEST VALUES!
                    'strPlayerName = strPlayerName & "»" & row(1).ToString & "»" & row(2).ToString & "»" & row(3).ToString & "»" & row(4).ToString & "»" & row(5).ToString & "»"


                Next

            Next


        Catch ex As Exception
            'Response.Write(
            'ignore any exceptions, or add specific exceptions
            'Console.Write(rawData)

            'rawLiveValues = rawLiveValues & ex.Message
            ' strPlayerName = ex.Message & ex.InnerException.ToString & "(" & timeZ.ToString(formatZ) & ")"

            strPlayerName = "Unauthorized Access"

        End Try


        'if there was a point added, update the record!
        ' and intPlayerScore
        Try


            If (intPlayerAnswer = 1) Then
                'add to the score

                'intPlayerScore = intPlayerScore + 1

                'update the player record

                Dim conn As String = "Provider=SQLOLEDB;Data Source=RemovedForDemo;Initial Catalog=DDXB144_Trivia;User Id=ddxb144_Trivia;Password=PWhere;"
                Dim Connection As New OleDb.OleDbConnection(conn)
                Connection.Open()

                'playerprofiles WHERE CompPlayerName = '" & strPlayerName & "' AND randomGen = " & intRandomGen
                'CommandString = "UPDATE live_game_01 SET questionMode=4 WHERE serverTimeLeft_sec=500"
                'CommandString = "UPDATE playerprofiles SET correctAnswers=" & intPlayerScore & " WHERE CompPlayerName = '" & strPlayerName & "' AND randomGen = " & intRandomGen
                'ADDING TIME!  UPDATE playerprofiles SET correctAnswers=56, timeIndex1='2012/2/12 9:00:00 AM' WHERE CompPlayerName = 'LiveChar' 
                CommandString = "UPDATE playerprofiles SET correctAnswers=" & intPlayerScore & ", timeIndex1='" & timeZ.ToString(formatZ) & "' WHERE CompPlayerName = '" & strPlayerName & "' AND randomGen = " & intRandomGen

                Dim cmdZ As New OleDbCommand(CommandString, Connection)
                cmdZ.ExecuteNonQuery()
                cmdZ.Connection.Close()


            End If


            '//NEW

            Dim dSetZQ1 As New DataSet("trivia_db001ZQ1")

            Dim connQ1 As String = "Provider=SQLOLEDB;Data Source=RemovedForDemo;Initial Catalog=DDXB144_Trivia;User Id=ddxb144_Trivia;Password=PWhere;"

            Dim cmdQZQ1 As String = ""

            cmdQZQ1 = "SELECT * FROM (SELECT RANK() OVER (ORDER BY correctAnswers DESC) AS [Rank by correctAnswers],  idplayerProfiles, CompPlayerName, correctAnswers, incorrectAnswers, randomGen, timeIndex1 FROM playerProfiles WHERE timeIndex1 >= DATEADD(minute, -90, GETDATE())) As TempView Where idplayerProfiles = " & intPlayerProfile.ToString
            'cmdQZQ1 = "SELECT COUNT(idplayerProfiles) FROM (SELECT RANK() OVER (ORDER BY correctAnswers DESC) AS [Rank by correctAnswers],  idplayerProfiles, CompPlayerName, correctAnswers, incorrectAnswers, randomGen, timeIndex1 FROM playerProfiles WHERE timeIndex1 >= DATEADD(minute, -90, GETDATE())) As TempView"

            Dim adapterQZQ1 As New OleDbDataAdapter(cmdQZQ1, connQ1)

            adapterQZQ1.Fill(dSetZQ1, "node2ZQ1")
            dSetZQ1.DataSetName = "trivia_db002ZQ1"


            For Each table2Q1 As DataTable In dSetZQ1.Tables

                Dim intNumColsZQ1 As Integer = table2Q1.Columns.Count

                For Each row As DataRow In table2Q1.Rows

                    strCurrentNowRank = row(0).ToString
                    'strCurrentWWRank = strTop10Rank & row(2).ToString & "»" & row(3).ToString & "«"


                Next

                'strTop10Rank = strTop10Rank & "»»»"

            Next



            If strCurrentNowRank = "0" Then
                strCurrentNowRank = "1"
            End If


            'If strCurrentNowRank <> "1" Then

            'Dim strCurrentWWPlayers as string = ""
            Dim dSetZQ2 As New DataSet("trivia_db001ZQ2")


            Dim cmdQZQ2 As String = ""
            cmdQZQ2 = "SELECT COUNT(idplayerProfiles) FROM (SELECT RANK() OVER (ORDER BY correctAnswers DESC) AS [Rank by correctAnswers],  idplayerProfiles, CompPlayerName, correctAnswers, incorrectAnswers, randomGen, timeIndex1 FROM playerProfiles WHERE timeIndex1 >= DATEADD(minute, -90, GETDATE())) As TempView"

            Dim adapterQZQ2 As New OleDbDataAdapter(cmdQZQ2, connQ1)

            adapterQZQ2.Fill(dSetZQ2, "node2ZQ2")
            dSetZQ2.DataSetName = "trivia_db002ZQ2"


            For Each table2Q2 As DataTable In dSetZQ2.Tables

                Dim intNumColsZQ2 As Integer = table2Q2.Columns.Count

                For Each row As DataRow In table2Q2.Rows

                    strCurrentNowTotal = row(0).ToString
                    'strTop10Rank = strTop10Rank & row(2).ToString & "»" & row(3).ToString & "«"


                Next

                'strTop10Rank = strTop10Rank & "»»»"

            Next

            'Else

            'strCurrentNowTotal = "1"

            ' End If




        Catch ex As Exception
            'strPlayerName = ex.Message & "(" & CommandString & ")"
            strPlayerName = "Unauthorized Access"
        End Try

        'finall RESPOND BACK WITH ALL INFO!!



        'End If

        'response:
        '        questionInProgress = No
        '        questionToAsk = "blahblah?"
        '        answerA = "yes"
        '        answerB = "no"
        '        answerC = "maybe"
        '        answerD = "I am"
        'timeToWaitForQuestion=000300  (3.00 seconds)
        'yourRank=300of300*
        'profileScore=500
        'profileNum = 1020
        'ranQuestionID = 1      ' auto-increment to 30000 then reset.
        'betweenQuestions = 0      '*
        '
        '    0»"Are you?"»"yes"»"no"»"maybe"»"I am"»500»300of300»500»1020»1»0
        ' 
        'OR YesinProgress, noTimeBonus, lucky if you make it...
        '
        '    1»"Are you?"»"yes"»"no"»"maybe"»"I am"»100»300of300»500»1020»1»0
        'OR
        '    0»"Are you?"»"yes"»"no"»"maybe"»"I am"»100»300of300»500»1020»1»250   '*youCaughtUsWhenaQuestionIsSwitchingTime,waitXseconds for nextQuestion.


        'PROCESS RESULT: check if intPlayerProfile = 0 that means it failed.


        'rawData is ready to go:
        'rawData & vbTab & vbTab & 

        'rawData = "<?xml version=""1.0"" encoding=""UTF-8"" ?>" & vbCrLf
        'rawData = rawData & vbTab & "<root>" & vbCrLf
        'rawData = rawData & vbTab & vbTab & "<node>" & rawLiveValues & "</node>" & vbCrLf
        'rawData = rawData & vbTab & "</root>" & vbCrLf

        'Dim byt As Byte() = System.Text.Encoding.UTF8.GetBytes(body)

        '' convert the byte array to a Base64 string


        'body = Convert.ToBase64String(byt)

        ' CommandString = "UPDATE playerprofiles SET correctAnswers=" & intPlayerScore & " WHERE CompPlayerName = '" & strPlayerName & "' AND randomGen = " & intRandomGen


        rawData = "<?xml version=""1.0"" encoding=""UTF-8"" ?>" & vbCrLf
        rawData = rawData & vbTab & "<root>" & vbCrLf

        '        If intPlayerProfile = 0 Then

        'DEFAULT = 0 for this, and 555

        '[No profile found: «Unable to connect to any of the specified MySQL hosts.()«! Your Profile ID: «0« Your RandomGen: «0«]

        rawData = rawData & vbTab & " <TBMobile type=""gameData"">"
        'strPlayerName
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[555: «" & strPlayerName & "«!" & " Your Profile ID: «" & intPlayerProfile & "« Your RandomGen: «0«]" & "]]></content>"
        rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[555]: «" & "»»1»" & strPlayerName & "»" & intPlayerScore & "»" & intRandomGen & "»" & strCurrentNowRank & "»" & strCurrentNowTotal & "«!" & "«]" & "]]></content>"


        'rawLiveValues
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[Welcome " & strPlayerName & "! (" & rawLiveValues & ") Your Profile ID: " & intPlayerProfile & " Your RandomGen: " & intRandomNum & "]" & "]]></content>"
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[" & loginText & "]" & "]]></content>"
        rawData = rawData & vbTab & " </TBMobile>"
        rawData = rawData & vbTab & "</root>" & vbCrLf


        'Else

        '    rawData = rawData & vbTab & " <TBMobile type=""gameData"">"
        '    'strPlayerName
        '    'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[556 «" & strPlayerName & "«!" & " Your Profile ID: «" & intPlayerProfile & "« Your RandomGen: «" & intRandomNum & "«]" & "]]></content>"
        '    rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[756]: «" & strPlayerName & "«!" & "«]" & "]]></content>"

        '    'rawLiveValues
        '    'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[Welcome " & strPlayerName & "! (" & rawLiveValues & ") Your Profile ID: " & intPlayerProfile & " Your RandomGen: " & intRandomNum & "]" & "]]></content>"
        '    'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[" & loginText & "]" & "]]></content>"
        '    rawData = rawData & vbTab & " </TBMobile>"
        '    rawData = rawData & vbTab & "</root>" & vbCrLf


        'End If

        '<content>
        '<![CDATA[
        '[556 «444.»What famous document begins: "When in the course of human events...”»The Declaration of Independence»The Bill of Rights»The US Constitution»The Gettysburg address»«! Your Profile ID: «1« Your RandomGen: «0«]
        ']]>
        '</content>


        'IF PROFILENUM IS STILL ZERO AFTER THIS, THE RECORD WAS NOT CREATED SUCCESSFULLY!!!

        'E:\Users\benlindelof\Documents\SierraPubClub\WelcomeViewController.m

        'rawData = "<xml><root><node>vary</node></root>" & vbCrLf


        Dim xmlDoc As New XmlDataDocument
        xmlDoc.LoadXml(rawData)


        'Return lobjXMLDataSet
        Return xmlDoc


    End Function

    <WebMethod()>
    Public Function GetDataforXML_000009_getRankingData(ByVal requestRank As String) As XmlDataDocument

        '           0»Zeliard»5»26176»0         '  live sql
        '           1»Zeliard»5»26176»0 

        '       0»Ben»24»1379»TTCA»0
        '       0»Ben»24»1379»TTPC»0
        ' ?
        ' CompPlayerName
        ' idplayerProfiles
        ' randomGen
        ' TopTen Correct Answers or Percent Correct
        ' ?

        ' Percent Correct/CA rankings could have Names!

        'TOP 10 by Correct Answers:
        '  SELECT TOP 10 DENSE_RANK() OVER (ORDER BY correctAnswers DESC) AS [Dense Rank by correctAnswers], 
        '     idplayerProfiles,
        '     CompPlayerName,
        '     correctAnswers,
        '     incorrectAnswers,
        '     randomGen,
        '     timeIndex1
        'FROM playerProfiles

        'Get Personal Rank #:
        'SELECT * FROM 
        '(SELECT DENSE_RANK() OVER (ORDER BY correctAnswers DESC) AS [Dense Rank by correctAnswers], 
        '       idplayerProfiles,
        '       CompPlayerName,
        '       correctAnswers,
        '       incorrectAnswers,
        '       randomGen,
        '       timeIndex1
        '  FROM playerProfiles) As TempView
        'WHERE idplayerProfiles=24

        'TOP 10 by Percent Correct:
        'SELECT * FROM 
        '(SELECT DENSE_RANK() OVER (ORDER BY correctAnswers-incorrectAnswers DESC) AS [Dense Rank by correctAnswers-incorrectAnswers], 
        '       idplayerProfiles,
        '       CompPlayerName,
        '       correctAnswers,
        '       incorrectAnswers,
        '       randomGen,
        '       timeIndex1
        '  FROM playerProfiles) As TempView
        ''''WHERE idplayerProfiles=24
        ''''Personal Rank


        'load and output based on inc:
        '1 incoming text:

        Dim strIncomingRandomNum = ""
        Dim intIncomingRandomNum = 0

        Dim rawData As String = ""

        Dim rawLiveValues As String = ""

        Dim testLiveValues As String = ""

        'profileNum = 0
        'playerName = Zeliard
        'loggedinOK = 0

        '        startGame = 1                 intGameStatus
        '        playerName = Zeliard           strPlayerName
        '        profileNum = 1020              intPlayerProfile
        '        randomGen = 9939               intRandomGen
        '        profileScore = 0               intPlayerScore

        'data=     
        '   0»Zeliard»0 
        '   1»Zeliard»1020»9939»0    'startGame, user is new and would like to start...
        '   2»Zeliard»1020»9939»0    'continueGame, user is not new and would like to continue.

        Dim intGameStatus As Integer = 0
        Dim strPlayerName As String = "000."
        Dim strCompPlayer As String = "random"
        Dim intPlayerProfile As Integer = 0
        Dim intPlayerLoggedIn As Integer = 0
        Dim intRandomGen As Integer = 0
        Dim intPlayerScore As Integer = 0
        Dim intPlayerPlace As Integer = 0
        Dim intTotalPlaters As Integer = 0

        Dim intRandomQuestionNumber As Integer = 0
        Dim strCurrentQuestion As String = ""
        Dim strCurrentAnswerA As String = ""
        Dim strCurrentAnswerB As String = ""
        Dim strCurrentAnswerC As String = ""
        Dim strCurrentAnswerD As String = ""
        Dim intRandomQuestionNumberIsNew As Integer = 0

        'GLOBALS
        'Dim debugVals As String
        'Dim serverTimeRemainingMin = 0
        'Dim serverTimeRemainingSec = 0
        'Dim dateServerTimeQuestion As Date
        'Dim intQuestionMode = 0
        ' Dim intQuestionisOutofTime = 0

        Dim intNoAccessAllowed As Integer = 0


        Dim intQuestionIDNumberRCVD = 0

        Dim dataValues() As String
        Dim intDataListSize As Integer = 0
        Dim strTypeofData As String = ""
        Dim strTop10Rank As String = ""
        Dim strYourRank As String = ""

        Try

            If requestRank <> "" Then
                dataValues = Split(requestRank, "»")
                intDataListSize = dataValues.Count - 1

                If intDataListSize < 4 Then
                    'error!
                    intNoAccessAllowed = 1
                Else

                    'send:  ' SCORE IS ZERO...
                    '        startGame = 1                 intGameStatus
                    '        playerName = Zeliard           strPlayerName
                    '        profileNum = 1020              intPlayerProfile
                    '        randomGen = 9939               intRandomGen
                    '        profileScore = 0               intPlayerScore

                    '   1»Zeliard»1020»9939»0

                    'get data grids:
                    '       0»Ben»24»1379»TTCA»0        «
                    '       0»Ben»24»1379»TTPC»0

                    intGameStatus = dataValues(0).ToString
                    strPlayerName = Trim(dataValues(1).ToString)
                    intPlayerProfile = dataValues(2).ToString
                    intRandomGen = dataValues(3).ToString
                    'intPlayerScore = dataValues(4).ToString
                    strTypeofData = dataValues(4).ToString


                End If


            Else
                'blanke!  set no access:
                intNoAccessAllowed = 1

            End If

        Catch exIORange As IndexOutOfRangeException
            strPlayerName = "Unauthorized access Your Request was Denied.[1]"

        Catch ex As Exception
            'System.IndexOutOfRangeException
            strPlayerName = "Unauthorized access Your Request was Denied.[2] " & ex.Message.ToString

        End Try

        'use with db: 'data=0»Zeliard»0


        If InStr(strPlayerName, "Unauthorized access") > 0 Then
            'do nothing
            strPlayerName = "Unauthorized access Your Request was Denied.[3]"

        Else
            Dim timeZ As DateTime = DateTime.Now
            Dim formatZ As String = "yyyy/MM/dd HH:mm:ss"
            Dim CommandString As String = ""
            Dim conn As String = "Provider=SQLOLEDB;Data Source=RemovedForDemo;Initial Catalog=DDXB144_Trivia;User Id=ddxb144_Trivia;Password=PWhere;"

            Dim dSet As New DataSet("trivia_db001")
            Dim dSetZ As New DataSet("trivia_db001Z")
            Dim dSetZ2 As New DataSet("trivia_db001Z2")

            'FIRST: set random question numebr and stop...
            Try

                ' load the randomnumber from a database selection:
                'Another for the Count....
                ' Select COUNT(Supplier_ID) from suppliers;
                'Dim cmdQ As String = "SELECT * FROM trivia_db001 WHERE idtrivia_db001 = '" & strQuesID & "'"
                'Dim cmdQZ As String = "Select COUNT(idtrivia_db001) from trivia_db001"

                Dim cmdQZ As String = ""

                If strTypeofData = "TTCA" Then
                    '  SELECT TOP 10 DENSE_RANK() OVER (ORDER BY correctAnswers DESC) AS [Dense Rank by correctAnswers], 
                    '     idplayerProfiles,
                    '     CompPlayerName,
                    '     correctAnswers,
                    '     incorrectAnswers,
                    '     randomGen,
                    '     timeIndex1
                    'FROM playerProfiles
                    ''WHERE idplayerProfiles=24   ' check for match on row data, dont requery  (no need your rank too)

                    cmdQZ = "SELECT TOP 10 RANK() OVER (ORDER BY correctAnswers DESC) AS [Rank by correctAnswers], idplayerProfiles, CompPlayerName, correctAnswers, incorrectAnswers, randomGen, timeIndex1 FROM playerProfiles"

                Else
                    strTypeofData = "TTPC"
                    'TOP 10 by Percent Correct:
                    'SELECT * FROM 
                    '(SELECT DENSE_RANK() OVER (ORDER BY correctAnswers-incorrectAnswers DESC) AS [Dense Rank by correctAnswers-incorrectAnswers], 
                    '       idplayerProfiles,
                    '       CompPlayerName,
                    '       correctAnswers,
                    '       incorrectAnswers,
                    '       randomGen,
                    '       timeIndex1
                    '  FROM playerProfiles) As TempView
                    ''''WHERE idplayerProfiles=24          ' check for match on row data, dont requery   (no need your rank too)
                    ''''Personal Rank

                    cmdQZ = "SELECT TOP 10 RANK() OVER (ORDER BY correctAnswers-incorrectAnswers DESC) AS [Rank by correctAnswers-incorrectAnswers], idplayerProfiles, CompPlayerName, correctAnswers, incorrectAnswers, randomGen, timeIndex1 FROM playerProfiles"

                End If



                Dim adapterQZ As New OleDbDataAdapter(cmdQZ, conn)

                adapterQZ.Fill(dSetZ, "node2Z")
                dSetZ.DataSetName = "trivia_db002Z"



                '1.) BEGIN PARSING:
                ''IF THERE IS A DATETIME = 00/00/00 something will complain in this code...

                '2.) IDENTIFY CATEGORIES: (by strSortByColName specified above, or in database for this widget)
                For Each table2 As DataTable In dSetZ.Tables

                    Dim intNumColsZ As Integer = table2.Columns.Count

                    'Response.Write("TABLE '" & table.TableName & "'")      ' equalto: "node"
                    'Response.Write("Total # of rows: " & table.Rows.Count)

                    ' row-based:
                    For Each row As DataRow In table2.Rows

                        'rawLiveValues = rawLiveValues & " # {" & row(0).ToString & "} {" & row(1).ToString & "}" & row(2).ToString & row(3).ToString
                        'rawLiveValues = rawLiveValues & "OK! ID # {" & row(0).ToString & "} string: " & CommandString
                        'rawLiveValues = rawLiveValues & "RANDOM! {" & row(0).ToString & "}<BR>"     »0        «

                        strTop10Rank = strTop10Rank & row(0).ToString & "»" & row(1).ToString & "»" & row(2).ToString & "»" & row(3).ToString & "«"

                        'strIncomingRandomNum = row(0).ToString
                        'intIncomingRandomNum = CInt(strIncomingRandomNum)

                        'Response.Write(cmdQ)
                        'Response.Write(rawLiveValues)
                        'Label7.Text = row(0).ToString
                        'Label1.Text = row(1).ToString
                        'Label2.Text = strQuesID
                        'Label3.Text = row(2).ToString
                        'Label4.Text = row(3).ToString
                        'Label5.Text = row(4).ToString
                        'Label6.Text = row(5).ToString

                        'LIVE VALUES!
                        'intPlayerProfile = CInt(row(0).ToString)
                        'intRandomNum = CInt(row(6).ToString)

                    Next

                    strTop10Rank = strTop10Rank & "»»»"

                Next

                'get personal ranking:     ******************************
                If strTypeofData = "TTCA" Then
                    '  SELECT TOP 10 DENSE_RANK() OVER (ORDER BY correctAnswers DESC) AS [Dense Rank by correctAnswers], 
                    '     idplayerProfiles,
                    '     CompPlayerName,
                    '     correctAnswers,
                    '     incorrectAnswers,
                    '     randomGen,
                    '     timeIndex1
                    'FROM playerProfiles
                    ''WHERE idplayerProfiles=24   ' check for match on row data, dont requery  (no need your rank too)

                    cmdQZ = "SELECT * FROM (SELECT RANK() OVER (ORDER BY correctAnswers DESC) AS [Rank by correctAnswers], idplayerProfiles, CompPlayerName, correctAnswers, incorrectAnswers, randomGen, timeIndex1 FROM playerProfiles) As TempView WHERE idplayerProfiles= " & intPlayerProfile.ToString
                Else
                    'strTypeofData = "TTPC"
                    'TOP 10 by Percent Correct:
                    'SELECT * FROM 
                    '(SELECT DENSE_RANK() OVER (ORDER BY correctAnswers-incorrectAnswers DESC) AS [Dense Rank by correctAnswers-incorrectAnswers], 
                    '       idplayerProfiles,
                    '       CompPlayerName,
                    '       correctAnswers,
                    '       incorrectAnswers,
                    '       randomGen,
                    '       timeIndex1
                    '  FROM playerProfiles) As TempView
                    ''''WHERE idplayerProfiles=24          ' check for match on row data, dont requery   (no need your rank too)
                    ''''Personal Rank

                    cmdQZ = "SELECT * FROM (SELECT RANK() OVER (ORDER BY correctAnswers-incorrectAnswers DESC) AS [Rank by correctAnswers-incorrectAnswers],  idplayerProfiles, CompPlayerName, correctAnswers, incorrectAnswers, randomGen, timeIndex1 FROM playerProfiles) As TempView WHERE idplayerProfiles= " & intPlayerProfile.ToString

                End If



                Dim adapterQZ2 As New OleDbDataAdapter(cmdQZ, conn)

                adapterQZ2.Fill(dSetZ2, "node2Z2")
                dSetZ2.DataSetName = "trivia_db002Z"



                '1.) BEGIN PARSING:
                ''IF THERE IS A DATETIME = 00/00/00 something will complain in this code...

                '2.) IDENTIFY CATEGORIES: (by strSortByColName specified above, or in database for this widget)
                For Each table22 As DataTable In dSetZ2.Tables

                    Dim intNumColsZ2 As Integer = table22.Columns.Count

                    'Response.Write("TABLE '" & table.TableName & "'")      ' equalto: "node"
                    'Response.Write("Total # of rows: " & table.Rows.Count)

                    ' row-based:
                    For Each row As DataRow In table22.Rows

                        'rawLiveValues = rawLiveValues & " # {" & row(0).ToString & "} {" & row(1).ToString & "}" & row(2).ToString & row(3).ToString
                        'rawLiveValues = rawLiveValues & "OK! ID # {" & row(0).ToString & "} string: " & CommandString
                        'rawLiveValues = rawLiveValues & "RANDOM! {" & row(0).ToString & "}<BR>"     »0        «

                        strTop10Rank = strTop10Rank & row(0).ToString & "»" & row(1).ToString & "»" & row(2).ToString & "»" & row(3).ToString & "«"

                        'strIncomingRandomNum = row(0).ToString
                        'intIncomingRandomNum = CInt(strIncomingRandomNum)

                        'Response.Write(cmdQ)
                        'Response.Write(rawLiveValues)
                        'Label7.Text = row(0).ToString
                        'Label1.Text = row(1).ToString
                        'Label2.Text = strQuesID
                        'Label3.Text = row(2).ToString
                        'Label4.Text = row(3).ToString
                        'Label5.Text = row(4).ToString
                        'Label6.Text = row(5).ToString

                        'LIVE VALUES!
                        'intPlayerProfile = CInt(row(0).ToString)
                        'intRandomNum = CInt(row(6).ToString)

                    Next

                    strTop10Rank = strTop10Rank & "»»»"

                Next


            Catch ex As Exception
                rawLiveValues = ex.Message.ToString
            End Try


        End If

        '2 rank data by CA:

        '3 rank data by PC:

        '4 set to rawData:

        If intNoAccessAllowed = 1 Then
            'blank you cant has:
            strTop10Rank = "Unauthorized access Your Request was Denied.[3]"

        End If




        rawData = "<?xml version=""1.0"" encoding=""UTF-8"" ?>" & vbCrLf
        rawData = rawData & vbTab & "<root>" & vbCrLf

        '        If intPlayerProfile = 0 Then

        'DEFAULT = 0 for this, and 555

        '[No profile found: «Unable to connect to any of the specified MySQL hosts.()«! Your Profile ID: «0« Your RandomGen: «0«]

        rawData = rawData & vbTab & " <TBMobile type=""gameData"">"
        'strPlayerName
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[555: «" & strPlayerName & "«!" & " Your Profile ID: «" & intPlayerProfile & "« Your RandomGen: «0«]" & "]]></content>"
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[555]: «" & "»»1»" & strPlayerName & "»" & intPlayerScore & "»" & intRandomGen & "»0" & "«!" & "«]" & "]]></content>"
        rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[555]: «" & "»»»" & strTop10Rank & "»0" & "«!" & "«]" & "]]></content>"


        'rawLiveValues
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[Welcome " & strPlayerName & "! (" & rawLiveValues & ") Your Profile ID: " & intPlayerProfile & " Your RandomGen: " & intRandomNum & "]" & "]]></content>"
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[" & loginText & "]" & "]]></content>"
        rawData = rawData & vbTab & " </TBMobile>"
        rawData = rawData & vbTab & "</root>" & vbCrLf


        'Dim rawData As String = "<xml><root><node>vary</node></root>" & vbCrLf


        Dim xmlDoc As New XmlDataDocument
        xmlDoc.LoadXml(rawData)


        'Return lobjXMLDataSet
        Return xmlDoc


    End Function

    <WebMethod()>
    Public Function GetDataforXML_000010_getChatData(ByVal getChat As String) As XmlDataDocument

        '           0»Zeliard»5»26176»0         ' live sql
        '           1»Zeliard»5»26176»0 
        '       0»Ben»24»1379»0

        'DO AN INNER JOIN ON THE DATA SO WE HAVE THE PROFILE ID INFO:

        'Get name with Chat data: (OLD)
        'select TOP 10 game_room_01.*, playerprofiles.CompPlayerName from game_room_01
        'INNER JOIN playerprofiles
        'ON game_room_01.profile_num01=playerprofiles.idplayerProfiles
        ' order by dateOfPost DESC

        'Get latest 6 with Names (Latest!)  ********
        'select * FROM (select TOP 6 game_room_01.*, playerprofiles.CompPlayerName from game_room_01
        'INNER JOIN playerprofiles
        'ON game_room_01.profile_num01=playerprofiles.idplayerProfiles
        'order by dateOfPost DESC) as TempView2
        'Order By dateOfPost ASC

        'load and output based on inc:
        '1 incoming text:
        Dim strIncomingRandomNum = ""
        Dim intIncomingRandomNum = 0

        Dim rawData As String = ""

        Dim rawLiveValues As String = ""

        Dim testLiveValues As String = ""

        'profileNum = 0
        'playerName = Zeliard
        'loggedinOK = 0

        '        startGame = 1                 intGameStatus
        '        playerName = Zeliard           strPlayerName
        '        profileNum = 1020              intPlayerProfile
        '        randomGen = 9939               intRandomGen
        '        profileScore = 0               intPlayerScore

        'data=     
        '   0»Zeliard»0 
        '   1»Zeliard»1020»9939»0    'startGame, user is new and would like to start...
        '   2»Zeliard»1020»9939»0    'continueGame, user is not new and would like to continue.

        Dim intGameStatus As Integer = 0
        Dim strPlayerName As String = "000."
        Dim strCompPlayer As String = "random"
        Dim intPlayerProfile As Integer = 0
        Dim intPlayerLoggedIn As Integer = 0
        Dim intRandomGen As Integer = 0
        Dim intPlayerScore As Integer = 0
        Dim intPlayerPlace As Integer = 0
        Dim intTotalPlaters As Integer = 0

        Dim intRandomQuestionNumber As Integer = 0
        Dim strCurrentQuestion As String = ""
        Dim strCurrentAnswerA As String = ""
        Dim strCurrentAnswerB As String = ""
        Dim strCurrentAnswerC As String = ""
        Dim strCurrentAnswerD As String = ""
        Dim intRandomQuestionNumberIsNew As Integer = 0

        'GLOBALS
        'Dim debugVals As String
        'Dim serverTimeRemainingMin = 0
        'Dim serverTimeRemainingSec = 0
        'Dim dateServerTimeQuestion As Date
        'Dim intQuestionMode = 0
        ' Dim intQuestionisOutofTime = 0

        Dim intNoAccessAllowed As Integer = 0


        Dim intQuestionIDNumberRCVD = 0

        Dim dataValues() As String
        Dim intDataListSize As Integer = 0
        Dim strChatData As String = ""


        Try

            If getChat <> "" Then
                dataValues = Split(getChat, "»")
                intDataListSize = dataValues.Count - 1

                If intDataListSize < 3 Then
                    'error!
                    intNoAccessAllowed = 1
                Else

                    'send:  ' SCORE IS ZERO...
                    '        startGame = 1                 intGameStatus
                    '        playerName = Zeliard           strPlayerName
                    '        profileNum = 1020              intPlayerProfile
                    '        randomGen = 9939               intRandomGen
                    '        profileScore = 0               intPlayerScore

                    '   1»Zeliard»1020»9939»0

                    ' 0»Ben»24»1379»0    get chat grid!
                    intGameStatus = dataValues(0).ToString
                    strPlayerName = Trim(dataValues(1).ToString)
                    intPlayerProfile = dataValues(2).ToString
                    intRandomGen = dataValues(3).ToString
                    intPlayerScore = dataValues(4).ToString


                End If


            Else
                'blanke!  set no access:
                intNoAccessAllowed = 1

            End If

        Catch exIORange As IndexOutOfRangeException
            strPlayerName = "Unauthorized access Your Request was Denied.[1]"

        Catch ex As Exception
            'System.IndexOutOfRangeException
            strPlayerName = "Unauthorized access Your Request was Denied.[2] " & ex.Message.ToString

        End Try

        'use with db: 'data=0»Zeliard»0


        If InStr(strPlayerName, "Unauthorized access") > 0 Then
            'do nothing
            strPlayerName = "Unauthorized access Your Request was Denied.[3]"

        Else

            Dim timeZ As DateTime = DateTime.Now
            Dim formatZ As String = "yyyy/MM/dd HH:mm:ss"
            Dim CommandString As String = ""
            Dim conn As String = "Provider=SQLOLEDB;Data Source=RemovedForDemo;Initial Catalog=DDXB144_Trivia;User Id=ddxb144_Trivia;Password=PWhere;"

            Dim dSet As New DataSet("trivia_db001")
            Dim dSetZ As New DataSet("trivia_db001Z")
            Dim dSetZ2 As New DataSet("trivia_db001Z2")

            'FIRST: set random question numebr and stop...
            Try

                ' load the randomnumber from a database selection:
                'Another for the Count....
                ' Select COUNT(Supplier_ID) from suppliers;
                'Dim cmdQ As String = "SELECT * FROM trivia_db001 WHERE idtrivia_db001 = '" & strQuesID & "'"
                'Dim cmdQZ As String = "Select COUNT(idtrivia_db001) from trivia_db001"

                Dim cmdQZ As String = ""

                cmdQZ = "select * FROM (select TOP 10 game_room_01.*, playerprofiles.CompPlayerName from game_room_01 INNER JOIN playerprofiles ON game_room_01.profile_num01=playerprofiles.idplayerProfiles order by dateOfPost DESC) as TempView2 Order By dateOfPost ASC"


                Dim adapterQZ As New OleDbDataAdapter(cmdQZ, conn)

                adapterQZ.Fill(dSetZ, "node2Z")
                dSetZ.DataSetName = "trivia_db002Z"



                '1.) BEGIN PARSING:
                ''IF THERE IS A DATETIME = 00/00/00 something will complain in this code...

                '2.) IDENTIFY CATEGORIES: (by strSortByColName specified above, or in database for this widget)
                For Each table2 As DataTable In dSetZ.Tables

                    Dim intNumColsZ As Integer = table2.Columns.Count

                    'Response.Write("TABLE '" & table.TableName & "'")      ' equalto: "node"
                    'Response.Write("Total # of rows: " & table.Rows.Count)

                    ' row-based:
                    For Each row As DataRow In table2.Rows

                        'rawLiveValues = rawLiveValues & " # {" & row(0).ToString & "} {" & row(1).ToString & "}" & row(2).ToString & row(3).ToString
                        'rawLiveValues = rawLiveValues & "OK! ID # {" & row(0).ToString & "} string: " & CommandString
                        'rawLiveValues = rawLiveValues & "RANDOM! {" & row(0).ToString & "}<BR>"     »0        «

                        strChatData = strChatData & row(7).ToString & "»" & row(8).ToString & "»" & row(6).ToString & "«"

                        'strIncomingRandomNum = row(0).ToString
                        'intIncomingRandomNum = CInt(strIncomingRandomNum)

                        'Response.Write(cmdQ)
                        'Response.Write(rawLiveValues)
                        'Label7.Text = row(0).ToString
                        'Label1.Text = row(1).ToString
                        'Label2.Text = strQuesID
                        'Label3.Text = row(2).ToString
                        'Label4.Text = row(3).ToString
                        'Label5.Text = row(4).ToString
                        'Label6.Text = row(5).ToString

                        'LIVE VALUES!
                        'intPlayerProfile = CInt(row(0).ToString)
                        'intRandomNum = CInt(row(6).ToString)

                    Next

                    strChatData = strChatData & "»»»"

                Next


            Catch ex As Exception
                rawLiveValues = ex.Message.ToString
            End Try


        End If



        '2 chat data for last 6:

        '3 set to rawData:








        If intNoAccessAllowed = 1 Then
            'blank you cant has:
            strChatData = "Unauthorized access Your Request was Denied.[3]"

        End If


        rawData = "<?xml version=""1.0"" encoding=""UTF-8"" ?>" & vbCrLf
        rawData = rawData & vbTab & "<root>" & vbCrLf

        '        If intPlayerProfile = 0 Then

        'DEFAULT = 0 for this, and 555

        '[No profile found: «Unable to connect to any of the specified MySQL hosts.()«! Your Profile ID: «0« Your RandomGen: «0«]

        rawData = rawData & vbTab & " <TBMobile type=""gameData"">"
        'strPlayerName
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[555: «" & strPlayerName & "«!" & " Your Profile ID: «" & intPlayerProfile & "« Your RandomGen: «0«]" & "]]></content>"
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[555]: «" & "»»1»" & strPlayerName & "»" & intPlayerScore & "»" & intRandomGen & "»0" & "«!" & "«]" & "]]></content>"
        rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[555]: «" & "»»»" & strChatData & "»0" & "«!" & "«]" & "]]></content>"


        'rawLiveValues
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[Welcome " & strPlayerName & "! (" & rawLiveValues & ") Your Profile ID: " & intPlayerProfile & " Your RandomGen: " & intRandomNum & "]" & "]]></content>"
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[" & loginText & "]" & "]]></content>"
        rawData = rawData & vbTab & " </TBMobile>"
        rawData = rawData & vbTab & "</root>" & vbCrLf


        'Dim rawData As String = "<xml><root><node>vary</node></root>" & vbCrLf

        'rawData = "<xml><root><node>vary</node></root>" & vbCrLf
        'Dim rawData As String = "<xml><root><node>vary</node></root>" & vbCrLf

        Dim xmlDoc As New XmlDataDocument
        xmlDoc.LoadXml(rawData)


        'Return lobjXMLDataSet
        Return xmlDoc


    End Function

    <WebMethod()>
    Public Function GetDataforXML_000011_sendChatData(ByVal sendChat As String) As XmlDataDocument

        '           0»Zeliard»5»26176»0         ' live sql
        '           1»Zeliard»5»26176»0 
        '
        '       0»Ben»24»1379»Chat Text goes here!»0


        'INSERT INTO game_room_01 (profile_num01, game_chat, dateOfPost) 
        'VALUES (24, 'Looks like I''m the only one online!', '2/15/2012 12:30:01 AM')


        '******JUST INSERT FOR NOW.  ROLL CODE FOLLOWS:
        '(Insert directly as a new record, or do this chat process to roll them in 6 slots)

        '1.
        'SELECT COUNT(idgame_room_01) FROM game_room_01

        '2.
        'based on count, 1 LESS THAN MAX. If 6 lines, delete all but 5  (delete oldest one)

        'select TOP 1 * from game_room_01
        'order by dateOfPost ASC
        '-- for 6, and delete idgame_room_01  number. add new.  get recordset

        'select TOP 2 * from game_room_02
        'order by dateOfPost ASC
        '-- for 7, and delete both idgame_room_01  numbers. add new.  get recordset

        '3.
        'Insert the new chat values.

        '4. DO NOT DO THIS ON SEND, only on GetChat data:  
        'select * FROM (select TOP 6 * from game_room_01 order by dateOfPost DESC) as TempView2
        'Order By dateOfPost ASC



        'FOR NOW JUST DO ADD RECORD TO DATABASE.  DO NOT ROLL THEM.  WE CAN DELETE DAILY IF NEEDED FOR NOW.

        '1.) GET CHAT DATA from XML and save it.  Respond with 'OK'.


        'load and output based on inc:
        '1 incoming text:
        Dim strIncomingRandomNum = ""
        Dim intIncomingRandomNum = 0

        Dim rawData As String = ""

        Dim rawLiveValues As String = ""

        Dim testLiveValues As String = ""

        'profileNum = 0
        'playerName = Zeliard
        'loggedinOK = 0

        '        startGame = 1                 intGameStatus
        '        playerName = Zeliard           strPlayerName
        '        profileNum = 1020              intPlayerProfile
        '        randomGen = 9939               intRandomGen
        '        profileScore = 0               intPlayerScore

        'data=     
        '   0»Zeliard»0 
        '   1»Zeliard»1020»9939»0    'startGame, user is new and would like to start...
        '   2»Zeliard»1020»9939»0    'continueGame, user is not new and would like to continue.

        Dim intGameStatus As Integer = 0
        Dim strPlayerName As String = "000."
        Dim strCompPlayer As String = "random"
        Dim intPlayerProfile As Integer = 0
        Dim intPlayerLoggedIn As Integer = 0
        Dim intRandomGen As Integer = 0
        Dim intPlayerScore As Integer = 0
        Dim intPlayerPlace As Integer = 0
        Dim intTotalPlaters As Integer = 0

        Dim intRandomQuestionNumber As Integer = 0
        Dim strCurrentQuestion As String = ""
        Dim strCurrentAnswerA As String = ""
        Dim strCurrentAnswerB As String = ""
        Dim strCurrentAnswerC As String = ""
        Dim strCurrentAnswerD As String = ""
        Dim intRandomQuestionNumberIsNew As Integer = 0

        'GLOBALS
        'Dim debugVals As String
        'Dim serverTimeRemainingMin = 0
        'Dim serverTimeRemainingSec = 0
        'Dim dateServerTimeQuestion As Date
        'Dim intQuestionMode = 0
        ' Dim intQuestionisOutofTime = 0

        Dim intNoAccessAllowed As Integer = 0


        Dim intQuestionIDNumberRCVD = 0

        Dim dataValues() As String
        Dim intDataListSize As Integer = 0
        Dim strIncomingChatText As String = ""

        Try

            If sendChat <> "" Then
                dataValues = Split(sendChat, "»")
                intDataListSize = dataValues.Count - 1

                If intDataListSize < 4 Then
                    'error!
                    intNoAccessAllowed = 1
                Else

                    'send:  ' SCORE IS ZERO...
                    '        startGame = 1                 intGameStatus
                    '        playerName = Zeliard           strPlayerName
                    '        profileNum = 1020              intPlayerProfile
                    '        randomGen = 9939               intRandomGen
                    '        profileScore = 0               intPlayerScore

                    '   1»Zeliard»1020»9939»0

                    'do this:
                    ' 0»Ben»24»1379»Chat Text goes here!»0

                    intGameStatus = dataValues(0).ToString
                    strPlayerName = Trim(dataValues(1).ToString)
                    intPlayerProfile = dataValues(2).ToString
                    intRandomGen = dataValues(3).ToString
                    strIncomingChatText = dataValues(4).ToString

                    If strIncomingChatText.Count >= 75 Then
                        strIncomingChatText = strPlayerName.Substring(0, 74)
                    End If


                    'Encode the string input
                    Dim strBuilder As New StringBuilder

                    strBuilder = strBuilder.Append(strIncomingChatText)
                    ' Selectively allow  and <i>
                    strBuilder.Replace(">", "")
                    strBuilder.Replace("<", "")
                    strBuilder.Replace("#", "")
                    strBuilder.Replace("&", "")
                    strBuilder.Replace("!", "")
                    strBuilder.Replace("@", "")
                    strBuilder.Replace("$", "")
                    strBuilder.Replace("%", "")
                    strBuilder.Replace("^", "")
                    strBuilder.Replace(";", "")
                    strBuilder.Replace(":", "")
                    strBuilder.Replace("""", "")
                    strBuilder.Replace("'", "")
                    strBuilder.Replace(".", "")
                    strBuilder.Replace(",", "")
                    strBuilder.Replace("?", "")
                    strBuilder.Replace("/", "")
                    strBuilder.Replace("\", "")
                    strBuilder.Replace("|", "")
                    strBuilder.Replace("{", "")
                    strBuilder.Replace("}", "")
                    strBuilder.Replace("(", "")
                    strBuilder.Replace(")", "")
                    strBuilder.Replace("_", "")
                    strBuilder.Replace("~", "")
                    strBuilder.Replace("`", "")
                    strBuilder.Replace("*", "")
                    strBuilder.Replace("+", "")
                    strBuilder.Replace("=", "")
                    strBuilder.Replace("[", "")
                    strBuilder.Replace("]", "")
                    strBuilder.Replace("\0", "")
                    strBuilder.Replace("\n", "")
                    strBuilder.Replace("\lfcr", "")
                    strIncomingChatText = strBuilder.ToString()

                End If


            Else
                'blanke!  set no access:
                intNoAccessAllowed = 1

            End If

        Catch exIORange As IndexOutOfRangeException
            strPlayerName = "Unauthorized access Your Request was Denied.[1]"

        Catch ex As Exception
            'System.IndexOutOfRangeException
            strPlayerName = "Unauthorized access Your Request was Denied.[2] " & ex.Message.ToString

        End Try

        'use with db: 'data=0»Zeliard»0


        If InStr(strPlayerName, "Unauthorized access") > 0 Then
            'do nothing
            strPlayerName = "Unauthorized access Your Request was Denied.[3]"

        Else
            'strIncomingChatText   ' clean and ready!


            Dim timeZ As DateTime = DateTime.Now
            Dim formatZ As String = "yyyy/MM/dd HH:mm:ss"
            Dim CommandString As String = ""

            Dim dSet As New DataSet("game_room_01")

            Try

                ''PART 1: CONN STRING



                'Response.Write("result: " & myString)


                Dim conn As String = "Provider=SQLOLEDB;Data Source=RemovedForDemo;Initial Catalog=DDXB144_Trivia;User Id=ddxb144_Trivia;Password=PWhere;"
                Dim Connection As New OleDb.OleDbConnection(conn)
                Connection.Open()

                CommandString = "INSERT INTO game_room_01 (profile_num01, game_chat, dateOfPost) VALUES (" & intPlayerProfile.ToString & ", '" & strIncomingChatText & "', '" & timeZ.ToString(formatZ) & "')"
                Dim cmdZ As New OleDbCommand(CommandString, Connection)
                cmdZ.ExecuteNonQuery()
                cmdZ.Connection.Close()

                'Dim cmd As String = "SELECT * FROM playerprofiles WHERE CompPlayerName = '" & strPlayerName & "' AND randomGen = " & intRandomNum
                'Dim adapter As New OleDbDataAdapter(cmd, conn)

                'adapter.Fill(dSet, "node")
                'dSet.DataSetName = "game_room_01"


                'dataset variables:
                'Dim intNumCols As Integer = Table.Columns.Count
                Dim intFirst As Integer = 0
                Dim intColNumber As Integer = 0

                'order by category variables:
                Dim strCurrentCatName As String = ""
                Dim strConcatCategoryList As String = ""
                Dim intServiceTypeColNum As Integer = 0
                Dim strSortByColName As String = "None"
                Dim intCurrentRowNum As Integer = 0
                Dim intCurrentRowTest As Integer = 0

                '1.) BEGIN PARSING:
                ''IF THERE IS A DATETIME = 00/00/00 something will complain in this code...


                'adapter.Dispose()

            Catch ex As Exception
                'Response.Write(
                'ignore any exceptions, or add specific exceptions
                'Console.Write(rawData)

                'rawLiveValues = rawLiveValues & ex.Message
                ' strPlayerName = ex.Message & ex.InnerException.ToString & "(" & timeZ.ToString(formatZ) & ")"

                strPlayerName = ex.Message & "(" & CommandString & ")"

            End Try



        End If

        '2 insert data for new chat with time stamp:


        '3 set to rawData with OK or Error.


        If intNoAccessAllowed = 1 Then
            'blank you cant has:
            strPlayerName = "Unauthorized access Your Request was Denied.[3]"

        End If

        rawData = "<?xml version=""1.0"" encoding=""UTF-8"" ?>" & vbCrLf
        rawData = rawData & vbTab & "<root>" & vbCrLf

        '        If intPlayerProfile = 0 Then

        'DEFAULT = 0 for this, and 555

        '[No profile found: «Unable to connect to any of the specified MySQL hosts.()«! Your Profile ID: «0« Your RandomGen: «0«]

        rawData = rawData & vbTab & " <TBMobile type=""gameData"">"
        'strPlayerName
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[555: «" & strPlayerName & "«!" & " Your Profile ID: «" & intPlayerProfile & "« Your RandomGen: «0«]" & "]]></content>"
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[555]: «" & "»»1»" & strPlayerName & "»" & intPlayerScore & "»" & intRandomGen & "»0" & "«!" & "«]" & "]]></content>"
        rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[555]: «" & "»»»" & "ChatTextSavedOK" & "»0" & "«!" & "«]" & "]]></content>"


        'rawLiveValues
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[Welcome " & strPlayerName & "! (" & rawLiveValues & ") Your Profile ID: " & intPlayerProfile & " Your RandomGen: " & intRandomNum & "]" & "]]></content>"
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[" & loginText & "]" & "]]></content>"
        rawData = rawData & vbTab & " </TBMobile>"
        rawData = rawData & vbTab & "</root>" & vbCrLf


        'rawData = "<xml><root><node>vary</node></root>" & vbCrLf
        'Dim rawData As String = "<xml><root><node>vary</node></root>" & vbCrLf

        Dim xmlDoc As New XmlDataDocument
        xmlDoc.LoadXml(rawData)


        'Return lobjXMLDataSet
        Return xmlDoc


    End Function

    '//SELECT * FROM (SELECT RANK() OVER (ORDER BY correctAnswers-incorrectAnswers DESC) AS [Rank by correctAnswers-incorrectAnswers],  idplayerProfiles, CompPlayerName, correctAnswers, incorrectAnswers, randomGen, timeIndex1 FROM playerProfiles) As TempView WHERE timeIndex1 >= DATEADD(minute, -30, GETDATE())
    'this is fine, just make sure to use a counter to order them.

    <WebMethod()>
    Public Function GetDataforXML_000012_getCurrentPlayersData(ByVal requestData As String) As XmlDataDocument

        '0»Ben»24»1379»TTPC»0  defaults/only
        'shows Rank of Players who have done something in last 30 min!
        ' populate first column of results with 1-10



        '           0»Zeliard»5»26176»0         '  live sql
        '           1»Zeliard»5»26176»0 

        '       0»Ben»24»1379»TTCA»0
        '       0»Ben»24»1379»TTPC»0
        ' ?
        ' CompPlayerName
        ' idplayerProfiles
        ' randomGen
        ' TopTen Correct Answers or Percent Correct
        ' ?

        ' Percent Correct/CA rankings could have Names!

        'TOP 10 by Correct Answers:
        '  SELECT TOP 10 DENSE_RANK() OVER (ORDER BY correctAnswers DESC) AS [Dense Rank by correctAnswers], 
        '     idplayerProfiles,
        '     CompPlayerName,
        '     correctAnswers,
        '     incorrectAnswers,
        '     randomGen,
        '     timeIndex1
        'FROM playerProfiles

        'Get Personal Rank #:
        'SELECT * FROM 
        '(SELECT DENSE_RANK() OVER (ORDER BY correctAnswers DESC) AS [Dense Rank by correctAnswers], 
        '       idplayerProfiles,
        '       CompPlayerName,
        '       correctAnswers,
        '       incorrectAnswers,
        '       randomGen,
        '       timeIndex1
        '  FROM playerProfiles) As TempView
        'WHERE idplayerProfiles=24

        'TOP 10 by Percent Correct:
        'SELECT * FROM 
        '(SELECT DENSE_RANK() OVER (ORDER BY correctAnswers-incorrectAnswers DESC) AS [Dense Rank by correctAnswers-incorrectAnswers], 
        '       idplayerProfiles,
        '       CompPlayerName,
        '       correctAnswers,
        '       incorrectAnswers,
        '       randomGen,
        '       timeIndex1
        '  FROM playerProfiles) As TempView
        ''''WHERE idplayerProfiles=24
        ''''Personal Rank


        'load and output based on inc:
        '1 incoming text:

        Dim strIncomingRandomNum = ""
        Dim intIncomingRandomNum = 0

        Dim rawData As String = ""

        Dim rawLiveValues As String = ""

        Dim testLiveValues As String = ""

        'profileNum = 0
        'playerName = Zeliard
        'loggedinOK = 0

        '        startGame = 1                 intGameStatus
        '        playerName = Zeliard           strPlayerName
        '        profileNum = 1020              intPlayerProfile
        '        randomGen = 9939               intRandomGen
        '        profileScore = 0               intPlayerScore

        'data=     
        '   0»Zeliard»0 
        '   1»Zeliard»1020»9939»0    'startGame, user is new and would like to start...
        '   2»Zeliard»1020»9939»0    'continueGame, user is not new and would like to continue.

        Dim intGameStatus As Integer = 0
        Dim strPlayerName As String = "000."
        Dim strCompPlayer As String = "random"
        Dim intPlayerProfile As Integer = 0
        Dim intPlayerLoggedIn As Integer = 0
        Dim intRandomGen As Integer = 0
        Dim intPlayerScore As Integer = 0
        Dim intPlayerPlace As Integer = 0
        Dim intTotalPlaters As Integer = 0

        Dim intRandomQuestionNumber As Integer = 0
        Dim strCurrentQuestion As String = ""
        Dim strCurrentAnswerA As String = ""
        Dim strCurrentAnswerB As String = ""
        Dim strCurrentAnswerC As String = ""
        Dim strCurrentAnswerD As String = ""
        Dim intRandomQuestionNumberIsNew As Integer = 0

        'GLOBALS
        'Dim debugVals As String
        'Dim serverTimeRemainingMin = 0
        'Dim serverTimeRemainingSec = 0
        'Dim dateServerTimeQuestion As Date
        'Dim intQuestionMode = 0
        ' Dim intQuestionisOutofTime = 0

        Dim intNoAccessAllowed As Integer = 0


        Dim intQuestionIDNumberRCVD = 0

        Dim dataValues() As String
        Dim intDataListSize As Integer = 0
        Dim strTypeofData As String = ""
        Dim strTop10Rank As String = ""
        Dim strYourRank As String = ""

        Try

            If requestData <> "" Then
                dataValues = Split(requestData, "»")
                intDataListSize = dataValues.Count - 1

                If intDataListSize < 4 Then
                    'error!
                    intNoAccessAllowed = 1
                Else

                    'send:  ' SCORE IS ZERO...
                    '        startGame = 1                 intGameStatus
                    '        playerName = Zeliard           strPlayerName
                    '        profileNum = 1020              intPlayerProfile
                    '        randomGen = 9939               intRandomGen
                    '        profileScore = 0               intPlayerScore

                    '   1»Zeliard»1020»9939»0

                    'get data grids:
                    '       0»Ben»24»1379»TTCA»0        «
                    '       0»Ben»24»1379»TTPC»0

                    intGameStatus = dataValues(0).ToString
                    strPlayerName = Trim(dataValues(1).ToString)
                    intPlayerProfile = dataValues(2).ToString
                    intRandomGen = dataValues(3).ToString
                    'intPlayerScore = dataValues(4).ToString
                    strTypeofData = dataValues(4).ToString


                End If


            Else
                'blanke!  set no access:
                intNoAccessAllowed = 1

            End If

        Catch exIORange As IndexOutOfRangeException
            strPlayerName = "Unauthorized access Your Request was Denied.[1]"

        Catch ex As Exception
            'System.IndexOutOfRangeException
            strPlayerName = "Unauthorized access Your Request was Denied.[2] " & ex.Message.ToString

        End Try

        'use with db: 'data=0»Zeliard»0


        If InStr(strPlayerName, "Unauthorized access") > 0 Then
            'do nothing
            strPlayerName = "Unauthorized access Your Request was Denied.[3]"

        Else
            Dim timeZ As DateTime = DateTime.Now
            Dim formatZ As String = "yyyy/MM/dd HH:mm:ss"
            Dim CommandString As String = ""
            Dim conn As String = "Provider=SQLOLEDB;Data Source=RemovedForDemo;Initial Catalog=DDXB144_Trivia;User Id=ddxb144_Trivia;Password=PWhere;"

            Dim dSet As New DataSet("trivia_db001")
            Dim dSetZ As New DataSet("trivia_db001Z")
            'Dim dSetZ2 As New DataSet("trivia_db001Z2")

            'FIRST: set random question numebr and stop...
            Try

                ' load the randomnumber from a database selection:
                'Another for the Count....
                ' Select COUNT(Supplier_ID) from suppliers;
                'Dim cmdQ As String = "SELECT * FROM trivia_db001 WHERE idtrivia_db001 = '" & strQuesID & "'"
                'Dim cmdQZ As String = "Select COUNT(idtrivia_db001) from trivia_db001"

                Dim cmdQZ As String = ""

                'If strTypeofData = "TTCA" Then
                '    '  SELECT TOP 10 DENSE_RANK() OVER (ORDER BY correctAnswers DESC) AS [Dense Rank by correctAnswers], 
                '    '     idplayerProfiles,
                '    '     CompPlayerName,
                '    '     correctAnswers,
                '    '     incorrectAnswers,
                '    '     randomGen,
                '    '     timeIndex1
                '    'FROM playerProfiles
                '    ''WHERE idplayerProfiles=24   ' check for match on row data, dont requery  (no need your rank too)

                '    cmdQZ = "SELECT TOP 10 RANK() OVER (ORDER BY correctAnswers DESC) AS [Rank by correctAnswers], idplayerProfiles, CompPlayerName, correctAnswers, incorrectAnswers, randomGen, timeIndex1 FROM playerProfiles"

                'Else
                strTypeofData = "TTPC"
                'TOP 10 by Percent Correct:
                'SELECT * FROM 
                '(SELECT DENSE_RANK() OVER (ORDER BY correctAnswers-incorrectAnswers DESC) AS [Dense Rank by correctAnswers-incorrectAnswers], 
                '       idplayerProfiles,
                '       CompPlayerName,
                '       correctAnswers,
                '       incorrectAnswers,
                '       randomGen,
                '       timeIndex1
                '  FROM playerProfiles) As TempView
                ''''WHERE idplayerProfiles=24          ' check for match on row data, dont requery   (no need your rank too)
                ''''Personal Rank

                ' from 30 minutes ago
                cmdQZ = "SELECT TOP 10 * FROM (SELECT RANK() OVER (ORDER BY correctAnswers DESC) AS [Rank by correctAnswers],  idplayerProfiles, CompPlayerName, correctAnswers, incorrectAnswers, randomGen, timeIndex1 FROM playerProfiles) As TempView WHERE timeIndex1 >= DATEADD(minute, -90, GETDATE())"


                'End If



                Dim adapterQZ As New OleDbDataAdapter(cmdQZ, conn)

                adapterQZ.Fill(dSetZ, "node2Z")
                dSetZ.DataSetName = "trivia_db002Z"



                '1.) BEGIN PARSING:
                ''IF THERE IS A DATETIME = 00/00/00 something will complain in this code...

                '2.) IDENTIFY CATEGORIES: (by strSortByColName specified above, or in database for this widget)
                For Each table2 As DataTable In dSetZ.Tables

                    strTop10Rank = strTop10Rank & "»eachTable««««"

                    Dim intNumColsZ As Integer = table2.Columns.Count

                    'Response.Write("TABLE '" & table.TableName & "'")      ' equalto: "node"
                    'Response.Write("Total # of rows: " & table.Rows.Count)

                    ' row-based:
                    For Each row As DataRow In table2.Rows

                        'strTop10Rank = strTop10Rank & "»eachRow«"

                        'rawLiveValues = rawLiveValues & " # {" & row(0).ToString & "} {" & row(1).ToString & "}" & row(2).ToString & row(3).ToString
                        'rawLiveValues = rawLiveValues & "OK! ID # {" & row(0).ToString & "} string: " & CommandString
                        'rawLiveValues = rawLiveValues & "RANDOM! {" & row(0).ToString & "}<BR>"     »0        «

                        'strTop10Rank = strTop10Rank & row(2).ToString & "»" & row(3).ToString & "»" & row(2).ToString & "»" & row(3).ToString & "«"
                        strTop10Rank = strTop10Rank & row(2).ToString & "»" & row(3).ToString & "«"

                        'strIncomingRandomNum = row(0).ToString
                        'intIncomingRandomNum = CInt(strIncomingRandomNum)

                        'Response.Write(cmdQ)
                        'Response.Write(rawLiveValues)
                        'Label7.Text = row(0).ToString
                        'Label1.Text = row(1).ToString
                        'Label2.Text = strQuesID
                        'Label3.Text = row(2).ToString
                        'Label4.Text = row(3).ToString
                        'Label5.Text = row(4).ToString
                        'Label6.Text = row(5).ToString

                        'LIVE VALUES!
                        'intPlayerProfile = CInt(row(0).ToString)
                        'intRandomNum = CInt(row(6).ToString)

                    Next

                    strTop10Rank = strTop10Rank & "»»»"

                Next

                ''get personal ranking:     ******************************
                'If strTypeofData = "TTCA" Then
                '    '  SELECT TOP 10 DENSE_RANK() OVER (ORDER BY correctAnswers DESC) AS [Dense Rank by correctAnswers], 
                '    '     idplayerProfiles,
                '    '     CompPlayerName,
                '    '     correctAnswers,
                '    '     incorrectAnswers,
                '    '     randomGen,
                '    '     timeIndex1
                '    'FROM playerProfiles
                '    ''WHERE idplayerProfiles=24   ' check for match on row data, dont requery  (no need your rank too)

                '    cmdQZ = "SELECT * FROM (SELECT RANK() OVER (ORDER BY correctAnswers DESC) AS [Rank by correctAnswers], idplayerProfiles, CompPlayerName, correctAnswers, incorrectAnswers, randomGen, timeIndex1 FROM playerProfiles) As TempView WHERE idplayerProfiles= " & intPlayerProfile.ToString
                'Else
                '    'strTypeofData = "TTPC"
                '    'TOP 10 by Percent Correct:
                '    'SELECT * FROM 
                '    '(SELECT DENSE_RANK() OVER (ORDER BY correctAnswers-incorrectAnswers DESC) AS [Dense Rank by correctAnswers-incorrectAnswers], 
                '    '       idplayerProfiles,
                '    '       CompPlayerName,
                '    '       correctAnswers,
                '    '       incorrectAnswers,
                '    '       randomGen,
                '    '       timeIndex1
                '    '  FROM playerProfiles) As TempView
                '    ''''WHERE idplayerProfiles=24          ' check for match on row data, dont requery   (no need your rank too)
                '    ''''Personal Rank

                '    cmdQZ = "SELECT * FROM (SELECT RANK() OVER (ORDER BY correctAnswers-incorrectAnswers DESC) AS [Rank by correctAnswers-incorrectAnswers],  idplayerProfiles, CompPlayerName, correctAnswers, incorrectAnswers, randomGen, timeIndex1 FROM playerProfiles) As TempView WHERE idplayerProfiles= " & intPlayerProfile.ToString

                'End If



                'Dim adapterQZ2 As New OleDbDataAdapter(cmdQZ, conn)

                'adapterQZ2.Fill(dSetZ2, "node2Z2")
                'dSetZ2.DataSetName = "trivia_db002Z"



                ''1.) BEGIN PARSING:
                ' ''IF THERE IS A DATETIME = 00/00/00 something will complain in this code...

                ''2.) IDENTIFY CATEGORIES: (by strSortByColName specified above, or in database for this widget)
                'For Each table22 As DataTable In dSetZ2.Tables

                '    Dim intNumColsZ2 As Integer = table22.Columns.Count

                '    'Response.Write("TABLE '" & table.TableName & "'")      ' equalto: "node"
                '    'Response.Write("Total # of rows: " & table.Rows.Count)

                '    ' row-based:
                '    For Each row As DataRow In table22.Rows

                '        'rawLiveValues = rawLiveValues & " # {" & row(0).ToString & "} {" & row(1).ToString & "}" & row(2).ToString & row(3).ToString
                '        'rawLiveValues = rawLiveValues & "OK! ID # {" & row(0).ToString & "} string: " & CommandString
                '        'rawLiveValues = rawLiveValues & "RANDOM! {" & row(0).ToString & "}<BR>"     »0        «

                '        strTop10Rank = strTop10Rank & row(0).ToString & "»" & row(1).ToString & "»" & row(2).ToString & "»" & row(3).ToString & "«"

                '        'strIncomingRandomNum = row(0).ToString
                '        'intIncomingRandomNum = CInt(strIncomingRandomNum)

                '        'Response.Write(cmdQ)
                '        'Response.Write(rawLiveValues)
                '        'Label7.Text = row(0).ToString
                '        'Label1.Text = row(1).ToString
                '        'Label2.Text = strQuesID
                '        'Label3.Text = row(2).ToString
                '        'Label4.Text = row(3).ToString
                '        'Label5.Text = row(4).ToString
                '        'Label6.Text = row(5).ToString

                '        'LIVE VALUES!
                '        'intPlayerProfile = CInt(row(0).ToString)
                '        'intRandomNum = CInt(row(6).ToString)

                '    Next

                '    strTop10Rank = strTop10Rank & "»»»"

                'Next


            Catch ex As Exception
                rawLiveValues = ex.Message.ToString
            End Try


        End If

        '2 rank data by CA:

        '3 rank data by PC:

        '4 set to rawData:

        If intNoAccessAllowed = 1 Then
            'blank you cant has:
            strTop10Rank = "Unauthorized access Your Request was Denied.[3]"

        End If




        rawData = "<?xml version=""1.0"" encoding=""UTF-8"" ?>" & vbCrLf
        rawData = rawData & vbTab & "<root>" & vbCrLf

        '        If intPlayerProfile = 0 Then

        'DEFAULT = 0 for this, and 555

        '[No profile found: «Unable to connect to any of the specified MySQL hosts.()«! Your Profile ID: «0« Your RandomGen: «0«]

        rawData = rawData & vbTab & " <TBMobile type=""gameData"">"
        'strPlayerName
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[555: «" & strPlayerName & "«!" & " Your Profile ID: «" & intPlayerProfile & "« Your RandomGen: «0«]" & "]]></content>"
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[555]: «" & "»»1»" & strPlayerName & "»" & intPlayerScore & "»" & intRandomGen & "»0" & "«!" & "«]" & "]]></content>"
        rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[555]: «" & "»»»" & strTop10Rank & "»0" & "«!" & "«]" & "]]></content>"


        'rawLiveValues
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[Welcome " & strPlayerName & "! (" & rawLiveValues & ") Your Profile ID: " & intPlayerProfile & " Your RandomGen: " & intRandomNum & "]" & "]]></content>"
        'rawData = rawData & vbTab & vbTab & " <content><![CDATA[" & "[" & loginText & "]" & "]]></content>"
        rawData = rawData & vbTab & " </TBMobile>"
        rawData = rawData & vbTab & "</root>" & vbCrLf


        'Dim rawData As String = "<xml><root><node>vary</node></root>" & vbCrLf


        Dim xmlDoc As New XmlDataDocument
        xmlDoc.LoadXml(rawData)


        'Return lobjXMLDataSet
        Return xmlDoc


    End Function




    Protected Overrides Sub Finalize()
        MyBase.Finalize()
    End Sub

    Public Sub New()
        ' check on execution order
    End Sub

End Class
