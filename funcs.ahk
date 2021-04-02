openDiscord()
{
    IfWinExist ahk_exe Discord.exe
    {
        WinActivate, ahk_exe Discord.exe
    }
    Else
    {
        Run "C:\Users\alefnull\AppData\Local\Discord\app-0.0.309\Discord.exe"
    }
    Return
}

openFirefox()
{
    IfWinExist ahk_class MozillaWindowClass
    {
        WinActivateBottom, ahk_class MozillaWindowClass
    }
    Else
    {
        Run "C:\Program Files\Mozilla Firefox\firefox.exe"
    }
    Return
}

openGuilded()
{
    IfWinExist ahk_exe Guilded.exe
    {
        WinActivate, ahk_exe Guilded.exe
    }
    Else
    {
        Run "C:\Users\alefnull\AppData\Local\Programs\Guilded\Guilded.exe"
    }
    Return
}

openTerminal()
{
    IfWinExist ahk_exe WindowsTerminal.exe
    {
        WinActivate, ahk_exe WindowsTerminal.exe
    }
    Else
    {
        Run, *RunAs wt.exe
    }
    Return
}