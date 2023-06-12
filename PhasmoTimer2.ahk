#Requires AutoHotkey v2.0

time := 0
startingtime := 0
countDirection := 1
stopTime := 300

; Add these functions to handle the button clicks
CountDown(*) {
    global countDirection
    countDirection := -1
}

CountUp(*) {
    global countDirection
    countDirection := 1
}

myGui := Gui()
myGui.SetFont("s450 c393939", "Arial")
myGui.Add("Picture", "x0 y0 w1500 h600", "D:\Pictures\PhasmoBackground.png")
myText := myGui.Add("Text", "x" (1000 / 2 - 180) " y" (500 / 2 - 270) " BackgroundTrans", FormatTime(time))
myGui.Add("Picture", "x300 y0 w25 h600", "D:\Pictures\Test.png")

myGui.SetFont("s30 c393939", "October Crow")
myGui.Add("Text", "x66 y51 w200 h50 BackgroundTrans", "Information")

; Add these lines to create the buttons
myGui.SetFont("s20 c393939", "October Crow")
myGui.Add("Button", "vCountDown x55 y90 w150 h30 Backgroundd5b98a", "Count Down") .OnEvent("Click", CountDown)
myGui.Add("Button", "vCountUp x55 y130 w150 h30 Backgroundd5b98a", "Count Up") .OnEvent("Click", CountUp)

myGui.SetFont("s20 c393939", "October Crow")
myGui.Add("Text", "x81 y170 w150 h30 BackgroundTrans", "Starting Time")
myGui.Add("Edit", "vedit1 x55 y200 w150 h30 Backgroundd5b98a -E0x200")
myGui.Add("Text", "x210 y200 w37 h30 Backgroundd5b98a", " OK") .OnEvent("Click", ChangeStartingTime)

; Add these lines to create the Stop Time field
myGui.SetFont("s20 c393939", "October Crow")
myGui.Add("Text", "x81 y240 w150 h30 BackgroundTrans", "Stop Time")
myGui.Add("Edit", "vedit2 x55 y270 w150 h30 Backgroundd5b98a -E0x200 vstopTimeEdit")
myGui["Edit2"].Value := FormatTime(stopTime)
myGui.Add("Text", "x210 y270 w37 h30 Backgroundd5b98a", " OK") .OnEvent("Click", ChangeStopTime)

ChangeStartingTime(*) 
{
    global startingtime
    startingtime := myGui["Edit1"].Value
}

ChangeStopTime(*)
{
    global stopTime
    stopTime := ParseTime(myGui["stopTimeEdit"].Value)
    if (stopTime > 599) {
        stopTime := 599
        myGui["Edit2"].Value := FormatTime(stopTime)
    }
}

myGui.Show("w1500 h600")

WinSetStyle(-0xC00000, "ahk_id " myGui.Hwnd)
myGui.Move(1920, 0, 1500, 600)

^LButton::StartTimer()

StartTimer() {
    global startingtime
    global time
    time := startingtime
    SetTimer(UpdateTimer, 1000)
}

F1::ResetTimer()

ResetTimer() {
    global startingtime
    global time
    time := startingtime
    SetTimer(UpdateTimer, 0)
    myText.Value := FormatTime(time)
}

^!s::ChangeTime()

ChangeTime() {
    global startingtime
userInput := InputBox("Change Time", "Enter new time in seconds:")
if userInput.Result = "Cancel" {
    MsgBox "You pressed cancel you absolute bafoon!"
} else {
    startingtime := userInput.value
}
}

; Modify the UpdateTimer function to use the countDirection variable and display time in minutes and seconds
UpdateTimer() {
    global time
    global startingtime
    global countDirection
    global stopTime

    if (countDirection = -1 && time > 0) {
        time += countDirection
        myText.Value := FormatTime(time)
    } else if (countDirection = 1 && time < stopTime) {
        time += countDirection
        myText.Value := FormatTime(time)
        if (time = 60 || time = 90) {
            SoundPlay "D:\Audio\Tick Sound Effect.wav"
            ; Add code here to display a visual indicator
        }
    } else if (time = 0 || time = stopTime) {
        SoundPlay "D:\Audio\Alarm Sound Effect.wav"
        SetTimer(UpdateTimer, 0)
        myText.Value := FormatTime(time)
    }
}

^!e::ChangeWindowPosition()

ChangeWindowPosition() {
    userInput := InputBox("Change Window Position", "Enter new window position in format x,y:")
    if (userInput.Result != "Cancel") {
        values := StrSplit(userInput.Value, ",")
        myGui.Move(values[1], values[2], 1200, 600)
    }
}

; Add this function to format the time in minutes and seconds
FormatTime(time) {
    minutes := Floor(time / 60)
    seconds := Mod(time, 60)
    return Format("{1:01}:{2:02}", minutes, seconds)
}

; Add this function to parse a time string in the format mm:ss
ParseTime(timeString) {
    parts := StrSplit(timeString, ":")
    minutes := parts[1]
    seconds := parts[2]
    return minutes * 60 + seconds
}
