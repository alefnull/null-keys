; CTRL + WIN + T == tea timer
^#t::
RAlt & t::
    totalSeconds := 180
    endTime := A_TickCount + (totalSeconds*1000)
    CornerNotify("tea timer", "starting tea timer: " . Round(totalSeconds / 60) . " min", "b r", 3)
    Loop
    {
        Sleep 1000
        If (A_TickCount >= endTime)
        {
            Break
        }
    }
    CornerNotify("tea timer", "your tea is (probably) ready", "b r", 3)
return
