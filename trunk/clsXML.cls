VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsXML"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' clsXML.cls
' Copyright (C) 2008 Eric Evans
' ...

Private m_fso  As FileSystemObject
Private m_fs   As Object
Private m_path As String

' ...
Public Property Let Path(str As String)

    ' ...
    m_path = str

End Property

' ...
Public Property Get Path() As String

    ' ...
    Path = m_path

End Property

' ...
Private Sub Class_Terminate()

    ' ...
    CloseFSO

End Sub

' ...
Private Sub OpenFSO()

    ' ...
    Set m_fso = New FileSystemObject
    
    ' ...
    Set m_fs = _
        m_fso.OpenTextFile(m_path, ForWriting, True)
        
End Sub

Private Sub CloseFSO()

    ' ...
    Set m_fs = Nothing
    Set m_fso = Nothing

End Sub

' ...
Public Sub WriteNode(ByRef temp As IXMLDOMNode, Optional ByVal Spaces As Integer = 0)

    Dim xml_doc  As DOMDocument
    Dim tempList As IXMLDOMNodeList
    Dim Count    As Integer

    ' ...
    If (temp Is Nothing) Then
        Exit Sub
    End If
    
    ' ...
    If (m_fso Is Nothing) Then
        OpenFSO
    End If

    ' ...
    If (temp.nodeType = NODE_DOCUMENT) Then
        ' ..
        Set xml_doc = temp

        ' ...
        WriteNode xml_doc.documentElement, Spaces
        
        ' ...
        Exit Sub
    End If
    
    ' ...
    If (temp.nodeType = NODE_ELEMENT) Then
        ' ...
        m_fs.Write Space$(Spaces)
        m_fs.Write "<" & temp.nodeName
        
        ' ...
        WriteAttrs temp
    
        ' ...
        If (temp.hasChildNodes) Then
            ' ...
            m_fs.WriteLine ">"
        
            ' ...
            Set tempList = temp.childNodes
            
            ' ...
            For Count = 0 To tempList.length
                WriteNode tempList(Count), (Spaces + 2)
            Next
            
            ' ...
            m_fs.Write Space$(Spaces)
            m_fs.WriteLine "</" & temp.nodeName & ">"
        Else
            m_fs.WriteLine " />"
        End If
        
        ' ...
        If ((temp.nextSibling Is Nothing) = False) Then
            m_fs.WriteLine vbNullString
        End If
    Else
        ' ...
        If (temp.nodeType = NODE_TEXT) Then
            WriteData temp, Spaces
        End If
    End If
End Sub

' ...
Private Sub WriteAttrs(ByRef temp As IXMLDOMNode)

    Dim tempAttr As IXMLDOMAttribute
    
    ' ...
    If (temp Is Nothing) Then
        Exit Sub
    End If
    
    ' ...
    If (temp.Attributes Is Nothing) Then
        Exit Sub
    End If
    
    ' ...
    For Each tempAttr In temp.Attributes
        m_fs.Write Space$(1)
        m_fs.Write tempAttr.nodeName & "="
        m_fs.Write Chr$(34) & tempAttr.nodeValue & Chr$(34)
    Next
End Sub

' ...
Private Sub WriteData(ByRef temp As IXMLDOMNode, Optional ByVal Spaces As Integer = 0)

    Dim tempNode As IXMLDOMNode

    ' ...
    If (temp Is Nothing) Then
        Exit Sub
    End If
    
    ' ...
    If (temp.nodeType = NODE_TEXT) Then
        m_fs.WriteLine Space$(Spaces) & temp.text
    End If
End Sub