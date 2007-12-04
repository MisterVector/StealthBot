VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form frmDBManager 
   Caption         =   "Database Manager"
   ClientHeight    =   5640
   ClientLeft      =   60
   ClientTop       =   750
   ClientWidth     =   6750
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "frmDBManager"
   MaxButton       =   0   'False
   ScaleHeight     =   5640
   ScaleWidth      =   6750
   StartUpPosition =   1  'CenterOwner
   Begin MSComctlLib.TreeView trvUsers 
      Height          =   5055
      Left            =   120
      TabIndex        =   16
      Top             =   105
      Width           =   3375
      _ExtentX        =   5953
      _ExtentY        =   8916
      _Version        =   393217
      Indentation     =   575
      LabelEdit       =   1
      LineStyle       =   1
      Sorted          =   -1  'True
      Style           =   6
      Appearance      =   1
      OLEDragMode     =   1
      OLEDropMode     =   1
   End
   Begin VB.TextBox txtFlags 
      BackColor       =   &H00993300&
      ForeColor       =   &H00FFFFFF&
      Height          =   285
      Left            =   5160
      MaxLength       =   25
      TabIndex        =   7
      Top             =   2280
      Width           =   1215
   End
   Begin VB.TextBox txtRank 
      BackColor       =   &H00993300&
      ForeColor       =   &H00FFFFFF&
      Height          =   285
      Left            =   3840
      MaxLength       =   25
      TabIndex        =   5
      Top             =   2280
      Width           =   1215
   End
   Begin VB.TextBox txtName 
      BackColor       =   &H00993300&
      ForeColor       =   &H00FFFFFF&
      Height          =   285
      Left            =   3840
      MaxLength       =   25
      TabIndex        =   3
      Top             =   1560
      Width           =   2535
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancel"
      Height          =   255
      Index           =   0
      Left            =   4440
      TabIndex        =   2
      Top             =   5280
      Width           =   855
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "Apply and Cl&ose"
      Height          =   255
      Index           =   0
      Left            =   5280
      TabIndex        =   1
      Top             =   5280
      Width           =   1335
   End
   Begin VB.Frame Frame1 
      Caption         =   "Database Record"
      Height          =   5160
      Left            =   3600
      TabIndex        =   0
      Top             =   10
      Width           =   3025
      Begin VB.OptionButton recType 
         Caption         =   "Clan"
         Height          =   255
         Index           =   1
         Left            =   1200
         TabIndex        =   18
         Top             =   620
         Width           =   735
      End
      Begin VB.ListBox lstGroups 
         Height          =   1620
         Left            =   240
         MultiSelect     =   1  'Simple
         TabIndex        =   17
         Top             =   3000
         Width           =   2535
      End
      Begin VB.CommandButton cmdCancel 
         Caption         =   "Delete"
         Enabled         =   0   'False
         Height          =   255
         Index           =   1
         Left            =   1080
         TabIndex        =   15
         Top             =   4750
         Width           =   855
      End
      Begin VB.CommandButton cmdSave 
         Caption         =   "Save"
         Height          =   255
         Index           =   1
         Left            =   1930
         TabIndex        =   14
         Top             =   4750
         Width           =   855
      End
      Begin VB.OptionButton recType 
         Caption         =   "Group"
         Height          =   255
         Index           =   3
         Left            =   1200
         TabIndex        =   12
         Top             =   870
         Width           =   735
      End
      Begin VB.OptionButton recType 
         Caption         =   "Game"
         Height          =   255
         Index           =   2
         Left            =   360
         TabIndex        =   11
         Top             =   870
         Width           =   735
      End
      Begin VB.OptionButton recType 
         Caption         =   "User"
         Height          =   255
         Index           =   0
         Left            =   360
         TabIndex        =   10
         Top             =   620
         Value           =   -1  'True
         Width           =   735
      End
      Begin VB.Label Label1 
         Caption         =   "Record Type:"
         Height          =   255
         Index           =   4
         Left            =   240
         TabIndex        =   13
         Top             =   360
         Width           =   1815
      End
      Begin VB.Label Label1 
         Caption         =   "Group(s):"
         Height          =   255
         Index           =   3
         Left            =   240
         TabIndex        =   9
         Top             =   2760
         Width           =   1215
      End
      Begin VB.Label Label1 
         Caption         =   "Flags:"
         Height          =   255
         Index           =   2
         Left            =   1560
         TabIndex        =   8
         Top             =   2040
         Width           =   1215
      End
      Begin VB.Label Label1 
         Caption         =   "Rank (1 - 200):"
         Height          =   255
         Index           =   1
         Left            =   240
         TabIndex        =   6
         Top             =   2040
         Width           =   1215
      End
      Begin VB.Label Label1 
         Caption         =   "Username / Clan / Game / Group:"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   4
         Top             =   1320
         Width           =   2535
      End
   End
   Begin VB.Menu mnuFile 
      Caption         =   "File"
      Begin VB.Menu mnuOpenDB 
         Caption         =   "Open Database"
      End
   End
End
Attribute VB_Name = "frmDBManager"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_dragging As Boolean ' ...
Private m_selnode  As Node    ' ...

Private Sub Form_Load()
    Dim i      As Integer ' ...
    Dim splt() As String  ' ...
    Dim j      As Integer ' ...
    Dim pos    As Integer ' ...
    
    Call trvUsers.Nodes.Clear

    If (DB(0).Username = vbNullString) Then
        Call LoadDatabase
    End If
    
    Call trvUsers.Nodes.Add(, , "Database", "Database")
    
    For i = LBound(DB) To UBound(DB)
        If (StrComp(DB(i).Type, "GROUP", vbBinaryCompare) = 0) Then
            If (Len(DB(i).Groups) And (DB(i).Groups <> "%")) Then
                If (InStr(1, DB(i).Groups, ",", vbBinaryCompare) <> 0) Then
                    splt() = Split(DB(i).Groups, ",")
                Else
                    ReDim Preserve splt(0)
                    
                    splt(0) = DB(i).Groups
                End If
                
                For j = LBound(splt) To UBound(splt)
                    pos = Exists(splt(j))
                    
                    If (pos) Then
                        Call trvUsers.Nodes.Add(trvUsers.Nodes(pos).Key, _
                            tvwChild, DB(i).Username, DB(i).Username)
                    End If
                Next j
            Else
                If (Not (Exists(DB(i).Username))) Then
                    Call trvUsers.Nodes.Add("Database", tvwChild, DB(i).Username, _
                        DB(i).Username)
                End If
            End If
        End If
    Next i
    
    If (trvUsers.Nodes.Count > 1) Then
        For i = 2 To trvUsers.Nodes.Count
            Call lstGroups.AddItem(trvUsers.Nodes(i).text)
        Next i
    End If
    
    For i = LBound(DB) To UBound(DB)
        If ((StrComp(DB(i).Type, "USER", vbBinaryCompare) = 0) Or _
            (StrComp(DB(i).Type, "CLAN", vbBinaryCompare) = 0) Or _
            (StrComp(DB(i).Type, "GAME", vbBinaryCompare) = 0)) Then

            If (Len(DB(i).Groups) And (DB(i).Groups <> "%")) Then
                If (InStr(1, DB(i).Groups, ",", vbBinaryCompare) <> 0) Then
                    splt() = Split(DB(i).Groups, ",")
                Else
                    ReDim Preserve splt(0)
                    
                    splt(0) = DB(i).Groups
                End If
                
                For j = LBound(splt) To UBound(splt)
                    pos = Exists(splt(j))
                    
                    If (pos) Then
                        Call trvUsers.Nodes.Add(trvUsers.Nodes(pos).Key, _
                            tvwChild, DB(i).Username, DB(i).Username)
                    End If
                Next j
            Else
                Call trvUsers.Nodes.Add("Database", tvwChild, , DB(i).Username)
            End If
        End If
    Next i
    
    trvUsers.Nodes(1).Expanded = True
End Sub

Private Sub trvUsers_MouseDown(Button As Integer, Shift As Integer, x As Single, _
    y As Single)
    
    Set m_selnode = trvUsers.SelectedItem
End Sub

Private Sub trvUsers_NodeClick(ByVal Node As MSComctlLib.Node)
    Set m_selnode = Node
End Sub

Private Sub trvUsers_MouseMove(Button As Integer, Shift As Integer, x As Single, _
    y As Single)

    If (Button = vbLeftButton) Then
        m_dragging = True
        
        Call trvUsers.Drag(vbBeginDrag)
    End If
End Sub

Private Sub trvUsers_DragOver(ByRef Source As Control, ByRef x As Single, _
    ByRef y As Single, ByRef State As Integer)
    
    If (m_dragging) Then
        If (Source.Name = "trvUsers") Then
            Set trvUsers.DropHighlight = trvUsers.HitTest(x, y)
        End If
    End If
End Sub

Private Sub trvUsers_DragDrop(ByRef Source As Control, ByRef x As Single, _
    ByRef y As Single)
    
    If (m_dragging) Then
        If (Source.Name = "trvUsers") Then
            Dim selnow  As udtGetAccessResponse ' ...
            Dim selprev As udtGetAccessResponse ' ...
            
            If (Not (trvUsers.DropHighlight Is Nothing)) Then
                selnow = GetAccess(trvUsers.DropHighlight.text)
                selprev = GetAccess(trvUsers.SelectedItem.text)
                
                If (StrComp(selnow.Type, "GROUP", vbBinaryCompare) = 0) Then
                    Dim res As Integer ' ...
                
                    'res = MsgBox("Are you sure you wish to move " & Chr$(34) & _
                    '    selprev.Username & Chr$(34) & " into the group " & Chr$(34) & _
                    '        selnow.Username & "?" & Chr$(34), vbYesNo + vbInformation, _
                    '            "Move User")
                    '
                    'If (res = vbYes) Then
                        Dim i As Integer ' ...
                        
                        For i = LBound(DB) To UBound(DB)
                            If (StrComp(selprev.Username, DB(i).Username, vbBinaryCompare) = 0) Then
                                DB(i).Groups = trvUsers.DropHighlight.text
                            End If
                        Next i
                        
                        Call WriteDatabase(GetFilePath("users.txt"))
                        
                        ReDim DB(0)
                        
                        Call Form_Load
                    'End If
                End If
            End If
            
            Set m_selnode = Nothing
            
            Set trvUsers.DropHighlight = Nothing
            
            m_dragging = False
        End If
    End If
End Sub

Private Function Exists(ByVal nodeName As String) As Integer
    Dim i As Integer ' ...
    
    For i = 1 To trvUsers.Nodes.Count
        If (StrComp(trvUsers.Nodes(i).text, nodeName, vbTextCompare) = 0) Then
            Exists = i
        
            Exit Function
        End If
    Next i
    
    Exists = False
End Function

Private Sub trvUsers_Click()
    Dim tmp As udtGetAccessResponse ' ...
    
    Dim i   As Integer ' ...
    
    ' deselect groups
    For i = 0 To (lstGroups.ListCount - 1)
        lstGroups.Selected(i) = False
    Next i
    
    ' disable changing of record type
    For i = 0 To 3
        recType(i).Enabled = False
    Next i
    
    ' disable changing of record name
    txtName.Enabled = False
    
    ' grab entry from database
    tmp = GetAccess(trvUsers.SelectedItem.text)
    
    Select Case (UCase$(tmp.Type))
        Case "USER":  recType(0).Value = True
        Case "CLAN":  recType(1).Value = True
        Case "GAME":  recType(2).Value = True
        Case "GROUP": recType(3).Value = True
    End Select
    
    txtName.text = tmp.Username
    
    If (tmp.access > 0) Then
        txtRank.text = tmp.access
    End If
    
    txtFlags.text = tmp.Flags
    
    If (Len(tmp.Groups) And (tmp.Groups <> "%")) Then
        Dim splt() As String  ' ...
        Dim j      As Integer ' ...
    
        If (InStr(1, tmp.Groups, ",", vbBinaryCompare) <> 0) Then
            splt() = Split(DB(i).Groups, ",")
        Else
            ReDim Preserve splt(0)
            
            splt(0) = tmp.Groups
        End If
        
        For i = LBound(splt) To UBound(splt)
            For j = 0 To (lstGroups.ListCount - 1)
                If (StrComp(splt(i), lstGroups.List(j), vbTextCompare) = 0) Then
                    lstGroups.Selected(j) = True
                End If
            Next j
        Next i
    End If
End Sub