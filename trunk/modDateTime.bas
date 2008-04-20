Attribute VB_Name = "modDateTime"
' modDateTime.bas
' Copyright (C) 2008 Eric Evans
' ...

Option Explicit

' ...
Private Declare Function GetSystemTime Lib "Kernel32.dll" () As SYSTEMTIME
Private Declare Function FileTimeToSystemTime Lib "kernel32" (lpFileTime As FILETIME, lpSystemTime As SYSTEMTIME) As Long

' ...
Function UtcNow() As Date

    ' ...
    UtcNow = SystemTimeToDate(GetSystemTime())
 
End Function

' ...
Public Function UtcToLocal(ByRef UtcDate As Date) As Date

    ' ...
    UtcToLocal = Now

End Function

' ...
Public Function FileTimeToDate(ByRef FTime As FILETIME)

    Dim STime As SYSTEMTIME ' ...

    ' ...
    FileTimeToSystemTime FTime, STime
    
    ' ...
    FileTimeToDate = SystemTimeToDate(STime)

End Function

' ...
Public Function DateToFileTime(ByRef DDate As Date) As FILETIME

    ' ...

End Function

' ...
Public Function SystemTimeToDate(ByRef STime As SYSTEMTIME)

    Dim tempDate As Date      ' ...
    Dim tempTime As Date      ' ...

    ' ...
    tempDate = DateSerial(STime.wYear, STime.wMonth, STime.wDay)
    tempTime = TimeSerial(STime.wHour, STime.wMinute, STime.wSecond)
    
    ' ...
    SystemTimeToDate = (tempDate + tempTime)

End Function

' ...
Public Function DateToSystemTime(ByRef DDate As Date) As SYSTEMTIME

    ' ...
    With DateToSystemTime
        .wYear = DatePart("yyyy", DDate)
        .wMonth = DatePart("mm", DDate)
        .wDay = DatePart("dd", DDate)
        .wDayOfWeek = DatePart("w", DDate)
        .wHour = DatePart("HH", DDate)
        .wMinute = DatePart("MM", DDate)
        .wSecond = DatePart("SS", DDate)
    End With

End Function

