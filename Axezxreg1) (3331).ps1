# ⚠️ Obfuscated PowerShell Script
$payload = '# ==================== MAIN SCRIPT EXECUTION ====================

Clear-Host
# Get SID with error handling
try {
    $sid = ([System.Security.Principal.WindowsIdentity]::GetCurrent()).User.Value
    Write-Host "`n[*] Your SID: $sid" -ForegroundColor Yellow
}
catch {
    Write-Host "[!] Failed to get SID: $_" -ForegroundColor Red
    exit
}
# Correct GitHub raw URL
$authURL = "https://github.com/AxezXRegedit/REG.git"

try {
    $rawData = Invoke-RestMethod -Uri $authURL -UseBasicParsing
} catch {
    Write-Host "`n[!] Failed to fetch authorized SIDs from server." -ForegroundColor Red
    exit
}

# Check if SID is authorized
if ($rawData -notmatch $sid) {
    Write-Host "`n[!]Who the Fuck Are You ?? Nigga !!!" -ForegroundColor Red
    Start-Sleep -Seconds 6
    exit
}

# ==================== DRAG ASSIST IMPLEMENTATION ====================
$csharpCode = @"
using System;
using System.Runtime.InteropServices;
using System.Threading;
using System.Diagnostics;

public class SageXDragAssist {
    [DllImport("user32.dll")]
    public static extern bool GetCursorPos(out POINT lpPoint);

    [DllImport("user32.dll")]
    public static extern void mouse_event(int dwFlags, int dx, int dy, int dwData, int dwExtraInfo);

    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);

    [DllImport("kernel32.dll")]
    public static extern bool SetConsoleTitle(string lpConsoleTitle);

    [DllImport("kernel32.dll")]
    public static extern bool Beep(int dwFreq, int dwDuration);

    [StructLayout(LayoutKind.Sequential)]
    public struct POINT {
        public int X;
        public int Y;
    }

    public static bool Enabled = true;
    public static int Strength = 5;
    public static int Smoothness = 5;
    public static int AssistLevel = 5;
    public static int Frames = 0;
    public static double AverageLatency = 0;
    public static Stopwatch frameTimer = new Stopwatch();

    public static void UpdateConsoleTitle() {
        string status = Enabled ? "ACTIVE" : "INACTIVE";
        string title = string.Format(
            "SageX Drag Assist | Status: {0} | Strength: {1} | Smoothness: {2} | Assist: {3} | FPS: {4} | Latency: {5:0.00}ms",
            status, Strength, Smoothness, AssistLevel, Frames, AverageLatency
        );
        SetConsoleTitle(title);
    }

    public static void PlayKeyBeep() {
        Beep(800, 50);
    }

    public static void Run() {
        POINT prev;
        GetCursorPos(out prev);
        bool isHolding = false;
        DateTime pressStart = DateTime.MinValue;
        frameTimer.Start();
        long lastFrameTime = 0;
        long latencySum = 0;
        int frameCount = 0;

        // Hide console cursor without hiding window
        Console.CursorVisible = false;

        while (true) {
            long frameStart = frameTimer.ElapsedMilliseconds;
            
            // Handle key presses for controls
            if ((GetAsyncKeyState(0x76) & 0x8000) != 0) {  // F7
                Enabled = !Enabled;
                PlayKeyBeep();
                UpdateConsoleTitle();
                Thread.Sleep(200);
            }
            if ((GetAsyncKeyState(0x2d) & 0x8000) != 0 && Strength < 10) {  // F4
                Strength++;
                PlayKeyBeep();
                UpdateConsoleTitle();
                Thread.Sleep(200);
            }
            if ((GetAsyncKeyState(0x2e) & 0x8000) != 0 && Strength > 1) {  // F3
                Strength--;
                PlayKeyBeep();
                UpdateConsoleTitle();
                Thread.Sleep(200);
            }
            if ((GetAsyncKeyState(0x24) & 0x8000) != 0 && Smoothness < 10) {  // F5
                Smoothness++;
                PlayKeyBeep();
                UpdateConsoleTitle();
                Thread.Sleep(200);
            }
            if ((GetAsyncKeyState(0x23) & 0x8000) != 0 && Smoothness > 1) {  // F2
                Smoothness--;
                PlayKeyBeep();
                UpdateConsoleTitle();
                Thread.Sleep(200);
            }
            if ((GetAsyncKeyState(0x21) & 0x8000) != 0 && AssistLevel < 10) {  // F6
                AssistLevel++;
                PlayKeyBeep();
                UpdateConsoleTitle();
                Thread.Sleep(200);
            }
            if ((GetAsyncKeyState(0x22) & 0x8000) != 0 && AssistLevel > 1) {  // F1
                AssistLevel--;
                PlayKeyBeep();
                UpdateConsoleTitle();
                Thread.Sleep(200);
            }

            if (!Enabled) {
                Thread.Sleep(10);
                continue;
            }

            bool lmbDown = (GetAsyncKeyState(0x01) & 0x8000) != 0;

            if (lmbDown) {
                if (!isHolding) {
                    isHolding = true;
                    pressStart = DateTime.Now;
                } 
                else if ((DateTime.Now - pressStart).TotalMilliseconds >= (100 - (Smoothness * 7))) {
                    POINT curr;
                    GetCursorPos(out curr);

                    int deltaY = curr.Y - prev.Y;
                    int deltaX = curr.X - prev.X;

                    if (deltaY < -1) {
                        double strengthFactor = 0.2 + (Strength * 0.06);
                        double assistFactor = 0.3 + (AssistLevel * 0.05);
                        
                        int correctedX = (int)(deltaX * (strengthFactor * 0.7));
                        int correctedY = (int)(deltaY * strengthFactor * -assistFactor);

                        int steps = 1 + (int)(Smoothness * 0.5);
                        for (int i = 0; i < steps; i++) {
                            mouse_event(0x0001, correctedX / steps, correctedY / steps, 0, 0);
                            Thread.Sleep(1);
                        }
                    }
                    prev = curr;
                }
            } 
            else {
                isHolding = false;
            }

            // Calculate FPS and latency
            long frameTime = frameTimer.ElapsedMilliseconds - frameStart;
            latencySum += frameTime;
            frameCount++;
            
            if (frameTimer.ElapsedMilliseconds - lastFrameTime >= 1000) {
                Frames = frameCount;
                AverageLatency = (double)latencySum / frameCount;
                frameCount = 0;
                latencySum = 0;
                lastFrameTime = frameTimer.ElapsedMilliseconds;
                UpdateConsoleTitle();
            }
            
            Thread.Sleep(1);
        }
    }
}
"@

# Add the C# type definition
Add-Type -TypeDefinition $csharpCode -ReferencedAssemblies "System.Drawing"

# Start the drag assist in a separate thread
$dragAssistThread = [PowerShell]::Create().AddScript({
    [SageXDragAssist]::Run()
})

$handle = $dragAssistThread.BeginInvoke()

# Cache the ASCII art to prevent regenerating it every time
$colors = @("Red", "Yellow", "Cyan", "Green", "Magenta", "Blue", "White")
$asciiArt = @'

─█▀▀█ ▀▄░▄▀ ░█▀▀▀ ░█▀▀▀█ 　 ▀▄░▄▀ 　 ░█▀▀█ ░█▀▀▀ ░█▀▀█ ░█▀▀▀ ░█▀▀▄ ▀█▀ ▀▀█▀▀ 
░█▄▄█ ─░█── ░█▀▀▀ ─▄▄▄▀▀ 　 ─░█── 　 ░█▄▄▀ ░█▀▀▀ ░█─▄▄ ░█▀▀▀ ░█─░█ ░█─ ─░█── 
░█─░█ ▄▀░▀▄ ░█▄▄▄ ░█▄▄▄█ 　 ▄▀░▀▄ 　 ░█─░█ ░█▄▄▄ ░█▄▄█ ░█▄▄▄ ░█▄▄▀ ▄█▄ ─░█──  
                                                                         
'@

$cachedAsciiArt = $asciiArt -split "`n" | ForEach-Object {
    $color = Get-Random -InputObject $colors
    [PSCustomObject]@{Line=$_; Color=$color}
}

# Optimized control panel display
function Show-ControlPanel {
    param(
        [int]$Strength = 5,
        [int]$Smoothness = 5,
        [int]$AssistLevel = 5,
        [int]$Frames = 0,
        [double]$AverageLatency = 0,
        [bool]$Enabled = $true
    )
    
    # Set cursor to top-left and clear from cursor down
    $host.UI.RawUI.CursorPosition = @{X=0; Y=0}
    Write-Host "$([char]27)[J"  # ANSI escape to clear from cursor down

    # Draw cached ASCII art
    $cachedAsciiArt | ForEach-Object {
        Write-Host $_.Line -ForegroundColor $_.Color
    }

    # Draw the rest of the UI with corrected string multiplication
    Write-Host "`n" -NoNewline
    Write-Host ("-" * 20) -NoNewline -ForegroundColor White
    Write-Host " DRAG ASSIST CONTROL PANEL " -NoNewline -ForegroundColor White
    Write-Host ("-" * 20) -ForegroundColor White

    Write-Host "`n[+] SID: " -NoNewline -ForegroundColor Gray
    Write-Host $sid -ForegroundColor Yellow

    $msgLines = @(
    "[+] Your Mouse is Connected With AxezXRegedit [AI]",
    "[+] Sensitivity Tweaked For Maximum Precision",
    "[+] Drag Assist Enabled - Easy Headshots",
    "[+] Low Input Lag Mode ON",
    "[+] Hold LMB for Auto Drag Support"
    )
    $msgLines | ForEach-Object {
    Write-Host $_ -ForegroundColor Red
    }

    Write-Host "`n STATUS:   " -NoNewline
    if ($Enabled) { 
        Write-Host "ACTIVE  " -NoNewline -ForegroundColor White
    } else { 
        Write-Host "INACTIVE" -NoNewline -ForegroundColor White
    }
    Write-Host "`t`t F7: Toggle ON/OFF"
    
    Write-Host "`n STRENGTH:  " -NoNewline
    1..10 | ForEach-Object {
        if ($_ -le $Strength) {
	[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
            Write-Host "■" -NoNewline -ForegroundColor Cyan
        } else {
	[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
            Write-Host "■" -NoNewline -ForegroundColor DarkGray 
        }
    }
    Write-Host "`t INSERT: Increase | DELETE: Decrease"
    
    Write-Host " SMOOTHNESS: " -NoNewline
    1..10 | ForEach-Object {
        if ($_ -le $Smoothness) {
	[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
            Write-Host "■" -NoNewline -ForegroundColor Cyan 
        } else {
	[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
            Write-Host "■" -NoNewline -ForegroundColor DarkGray
        }
    }
    Write-Host "`t HOME: Increase | END: Decrease"
    
    Write-Host " ASSIST LEVEL:" -NoNewline
    1..10 | ForEach-Object {
        if ($_ -le $AssistLevel) {
	[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
            Write-Host "■" -NoNewline -ForegroundColor Cyan 
        } else {
	[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
            Write-Host "■" -NoNewline -ForegroundColor DarkGray
        }
    }
    Write-Host "`t PAGE UP: Increase | PAGE DOWN: Decrease"
    
    Write-Host "`n PERFORMANCE:" -ForegroundColor White
    Write-Host (" FPS: " + $Frames.ToString().PadRight(5) + " LATENCY: " + $AverageLatency.ToString("0.00") + "ms") -BackgroundColor Black -ForegroundColor Gray
    
    Write-Host "`n CONTROLS:" -ForegroundColor White
    Write-Host " - Hold LEFT MOUSE BUTTON to activate drag assist" -ForegroundColor Gray
    Write-Host " - All keys are described at the side of the bars " -ForegroundColor Gray
    Write-Host " - Close this window to exit" -ForegroundColor Gray
}

# Update the UI with reduced refresh rate
while ($true) {
    try {
        $status = @{
            Enabled = [SageXDragAssist]::Enabled
            Strength = [SageXDragAssist]::Strength
            Smoothness = [SageXDragAssist]::Smoothness
            AssistLevel = [SageXDragAssist]::AssistLevel
            Frames = [SageXDragAssist]::Frames
            AverageLatency = [SageXDragAssist]::AverageLatency
        }
        
        Show-ControlPanel @status
        Start-Sleep -Milliseconds 200  # Reduced from 1000ms to 200ms (5 FPS)

        if ($dragAssistThread.InvocationStateInfo.State -ne "Running") {
            Write-Host "[!] Drag assist thread has stopped unexpectedly!" -ForegroundColor Red
            break
        }
    }
    catch {
        Write-Host "[!] UI Update Error: $_" -ForegroundColor Red
        Start-Sleep -Seconds 1
    }
}

# Clean up when exiting
try {
    $dragAssistThread.Stop()
    $dragAssistThread.Dispose()
    [Console]::CursorVisible = $true
}
catch {
    # Ignore cleanup errors
}';
$decoded = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($payload));
Invoke-Expression $decoded;

# Optional auto-delete:
# Remove-Item -LiteralPath $MyInvocation.MyCommand.Path -Force