Dim WshShell
Set WshShell = CreateObject("WScript.Shell")

' Get the current time in 24-hour format
Dim currentTime
currentTime = FormatDateTime(Now, vbLongTime)

' Extract the hour part from the current time (string manipulation)
Dim hour
hour = CInt(Split(currentTime, ":")(0))

' Determine the time of day and set the greeting
Dim greeting
If hour >= 0 And hour < 12 Then
    greeting = "Good morning!"
ElseIf hour >= 12 And hour < 18 Then
    greeting = "Good afternoon!"
Else
    greeting = "Good evening!"
End If

' Define additional welcome message
Dim speaks
speaks = "Welcome to the extraordinary CodeSenSeiX World."

' Use speech to greet the user
Set Speech = CreateObject("SAPI.SpVoice")

' Check available voices and select the female voice
Dim voices, voice
Set voices = Speech.GetVoices()
For Each voice In voices
    ' Look for a female voice (e.g., "Zira" is often a female voice)
    If InStr(voice.GetDescription(), "Zira") > 0 Then
        Set Speech.Voice = voice
        Exit For
    End If
Next

' If no female voice is found, you can set a default voice (optional)
If Speech.Voice Is Nothing Then
    MsgBox "No female voice found. Using default voice."
End If

' Speak the greeting and welcome message
Speech.Speak greeting & " Welcome to the realme OTA Zip Downloader."
Speech.Speak speaks

' Log or perform any other actions (like running commands)
WshShell.Run "cmd /c echo Running script...", 0, True

' Clean up and close the shell object
Set WshShell = Nothing
Set Speech = Nothing
