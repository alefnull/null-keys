; CTRL + WIN + T == tea timer
^#t::
RAlt & t::
    totalSeconds := 5
    endTime := A_TickCount + (totalSeconds*1000)
    
    Loop
    {
        Sleep 1000
        remainingTime := (endTime - A_TickCount)/1000
        elapsedSeconds := Round(Mod(remainingTime,60))
        If (A_TickCount >= endTime)
        {
            Break
        }
    }
    
    MsgBox, 4096, Tea Timer, your tea is (probably) ready!
return