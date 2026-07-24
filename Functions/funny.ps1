function Show-Matrix {
    [CmdletBinding()]
    param(
        [ValidateRange(1, 1000)]
        [int]$DelayMilliseconds = 40,

        [ValidateRange(1, 100)]
        [int]$Density = 20,

        [ConsoleColor]$Color = [ConsoleColor]::Green
    )

    try {
        [Console]::CursorVisible = $false

        while ($true) {
            $width = [Math]::Max(1, [Console]::WindowWidth - 1)

            $line = -join (1..$width | ForEach-Object {
                if ((Get-Random -Minimum 1 -Maximum 101) -le $Density) {
                    [char](Get-Random -Minimum 33 -Maximum 127)
                }
                else {
                    ' '
                }
            })

            Write-Host $line -ForegroundColor $Color
            Start-Sleep -Milliseconds $DelayMilliseconds
        }
    }
    finally {
        [Console]::CursorVisible = $true
        Write-Host
    }
}


function Show-Fireworks {
    [CmdletBinding()]
    param(
        [ValidateRange(10, 1000)]
        [int]$DelayMilliseconds = 70,

        [ValidateRange(1, 20)]
        [int]$ParticleCount = 8
    )

    $colors = @(
        [ConsoleColor]::Red
        [ConsoleColor]::Yellow
        [ConsoleColor]::Green
        [ConsoleColor]::Cyan
        [ConsoleColor]::Blue
        [ConsoleColor]::Magenta
        [ConsoleColor]::White
    )

    $particles = @(
        @{ X =  0; Y = -2; Character = '│' }
        @{ X =  0; Y = -1; Character = '│' }
        @{ X =  0; Y =  1; Character = '│' }
        @{ X =  0; Y =  2; Character = '│' }
        @{ X = -2; Y =  0; Character = '─' }
        @{ X = -1; Y =  0; Character = '─' }
        @{ X =  1; Y =  0; Character = '─' }
        @{ X =  2; Y =  0; Character = '─' }
        @{ X = -2; Y = -1; Character = '\' }
        @{ X = -1; Y = -1; Character = '\' }
        @{ X =  1; Y =  1; Character = '\' }
        @{ X =  2; Y =  1; Character = '\' }
        @{ X =  1; Y = -1; Character = '/' }
        @{ X =  2; Y = -1; Character = '/' }
        @{ X = -1; Y =  1; Character = '/' }
        @{ X = -2; Y =  1; Character = '/' }
    )

    try {
        Clear-Host
        [Console]::CursorVisible = $false

        while ($true) {
            $width  = [Console]::WindowWidth
            $height = [Console]::WindowHeight

            if ($width -lt 12 -or $height -lt 8) {
                throw '콘솔 창 크기를 조금 더 크게 조정해 주세요.'
            }

            $centerX = Get-Random -Minimum 4 -Maximum ($width - 4)
            $centerY = Get-Random -Minimum 3 -Maximum ($height - 3)
            $color   = Get-Random -InputObject $colors

            $selectedParticles = $particles |
                Get-Random -Count ([Math]::Min($ParticleCount, $particles.Count))

            foreach ($particle in $selectedParticles) {
                $x = $centerX + $particle.X
                $y = $centerY + $particle.Y

                if (
                    $x -ge 0 -and $x -lt $width -and
                    $y -ge 0 -and $y -lt $height
                ) {
                    [Console]::SetCursorPosition($x, $y)
                    Write-Host $particle.Character -NoNewline -ForegroundColor $color
                }
            }

            [Console]::SetCursorPosition($centerX, $centerY)
            Write-Host '●' -NoNewline -ForegroundColor White

            Start-Sleep -Milliseconds $DelayMilliseconds

            foreach ($particle in $selectedParticles) {
                $x = $centerX + $particle.X
                $y = $centerY + $particle.Y

                if (
                    $x -ge 0 -and $x -lt $width -and
                    $y -ge 0 -and $y -lt $height
                ) {
                    [Console]::SetCursorPosition($x, $y)
                    Write-Host ' ' -NoNewline
                }
            }

            [Console]::SetCursorPosition($centerX, $centerY)
            Write-Host ' ' -NoNewline
        }
    }
    finally {
        [Console]::CursorVisible = $true
        [Console]::SetCursorPosition(0, [Console]::WindowHeight - 1)
        Write-Host
    }
}

function Show-Snow {
    [CmdletBinding()]
    param(
        [int]$DelayMilliseconds = 80,
        [int]$SnowflakeCount = 25
    )

    $flakes = @('*', '+', '.', '❄')

    try {
        Clear-Host
        [Console]::CursorVisible = $false

        while ($true) {
            $width  = [Math]::Max(10, [Console]::WindowWidth - 1)
            $height = [Math]::Max(5, [Console]::WindowHeight - 1)

            for ($i = 0; $i -lt $SnowflakeCount; $i++) {
                $x = Get-Random -Minimum 0 -Maximum $width
                $y = Get-Random -Minimum 0 -Maximum $height
                $flake = Get-Random -InputObject $flakes

                [Console]::SetCursorPosition($x, $y)
                Write-Host $flake -NoNewline -ForegroundColor White
            }

            Start-Sleep -Milliseconds $DelayMilliseconds
            Clear-Host
        }
    }
    finally {
        [Console]::CursorVisible = $true
        Clear-Host
    }
}

function Show-Stars {
    [CmdletBinding()]
    param(
        [int]$DelayMilliseconds = 100,
        [int]$StarCount = 40
    )

    $symbols = @('.', '*', '+', '·')
    $colors = @(
        [ConsoleColor]::White
        [ConsoleColor]::Gray
        [ConsoleColor]::Cyan
        [ConsoleColor]::Yellow
    )

    try {
        Clear-Host
        [Console]::CursorVisible = $false

        while ($true) {
            $width  = [Math]::Max(10, [Console]::WindowWidth - 1)
            $height = [Math]::Max(5, [Console]::WindowHeight - 1)

            for ($i = 0; $i -lt $StarCount; $i++) {
                $x = Get-Random -Minimum 0 -Maximum $width
                $y = Get-Random -Minimum 0 -Maximum $height

                [Console]::SetCursorPosition($x, $y)

                Write-Host (
                    Get-Random -InputObject $symbols
                ) -NoNewline -ForegroundColor (
                    Get-Random -InputObject $colors
                )
            }

            Start-Sleep -Milliseconds $DelayMilliseconds

            for ($i = 0; $i -lt 10; $i++) {
                $x = Get-Random -Minimum 0 -Maximum $width
                $y = Get-Random -Minimum 0 -Maximum $height

                [Console]::SetCursorPosition($x, $y)
                Write-Host ' ' -NoNewline
            }
        }
    }
    finally {
        [Console]::CursorVisible = $true
        Clear-Host
    }
}

function Write-HackerText {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Text,

        [int]$MinimumDelay = 15,

        [int]$MaximumDelay = 80,

        [ConsoleColor]$Color = [ConsoleColor]::Green
    )

    process {
        foreach ($character in $Text.ToCharArray()) {
            Write-Host $character -NoNewline -ForegroundColor $Color

            $delay = Get-Random `
                -Minimum $MinimumDelay `
                -Maximum ($MaximumDelay + 1)

            Start-Sleep -Milliseconds $delay
        }

        Write-Host
    }
}

function Start-HackerSimulation {
    [CmdletBinding()]
    param(
        [int]$DelayMilliseconds = 80
    )

    $messages = @(
        'Initializing secure channel'
        'Scanning network interfaces'
        'Resolving target hostname'
        'Analyzing encryption keys'
        'Bypassing imaginary firewall'
        'Downloading classified cat photos'
        'Decrypting coffee machine'
        'Access granted'
    )

    Clear-Host

    foreach ($message in $messages) {
        Write-Host '[*] ' -NoNewline -ForegroundColor DarkGray
        Write-HackerText `
            -Text $message `
            -MinimumDelay 10 `
            -MaximumDelay $DelayMilliseconds

        Start-Sleep -Milliseconds 200
    }

    Write-Host
    Write-Host 'SYSTEM COMPROMISED' -ForegroundColor Red
}

function Show-RandomCommands {
    [CmdletBinding()]
    param(
        [int]$DelayMilliseconds = 70
    )

    $commands = @(
        'Get-Process'
        'Get-Service'
        'Get-NetTCPConnection'
        'Invoke-SecretProtocol'
        'Connect-SpaceStation'
        'Remove-BadCoffee'
        'Enable-UltraInstinct'
        'Start-QuantumShell'
    )

    try {
        while ($true) {
            $timestamp = Get-Date -Format 'HH:mm:ss.fff'
            $command = Get-Random -InputObject $commands
            $value = Get-Random -Minimum 1000 -Maximum 99999

            Write-Host "[$timestamp] " -NoNewline -ForegroundColor DarkGray
            Write-Host "$command " -NoNewline -ForegroundColor Cyan
            Write-Host "PID=$value" -ForegroundColor Green

            Start-Sleep -Milliseconds $DelayMilliseconds
        }
    }
    finally {
        Write-Host
    }
}

function Show-Clock {
    [CmdletBinding()]
    param(
        [ValidateSet(
            'TopLeft',
            'TopRight',
            'BottomLeft',
            'BottomRight',
            'Center'
        )]
        [string]$Position = 'TopRight',

        [ConsoleColor]$Color = [ConsoleColor]::Cyan,

        [ValidateRange(50, 5000)]
        [int]$RefreshMilliseconds = 200
    )

    try {
        [Console]::CursorVisible = $false
        Clear-Host

        while ($true) {
            $time = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

            $width  = [Console]::WindowWidth
            $height = [Console]::WindowHeight

            switch ($Position) {
                'TopLeft' {
                    $x = 0
                    $y = 0
                }

                'TopRight' {
                    $x = [Math]::Max(0, $width - $time.Length - 1)
                    $y = 0
                }

                'BottomLeft' {
                    $x = 0
                    $y = [Math]::Max(0, $height - 2)
                }

                'BottomRight' {
                    $x = [Math]::Max(0, $width - $time.Length - 1)
                    $y = [Math]::Max(0, $height - 2)
                }

                'Center' {
                    $x = [Math]::Max(
                        0,
                        [int](($width - $time.Length) / 2)
                    )

                    $y = [Math]::Max(
                        0,
                        [int](($height - 1) / 2)
                    )
                }
            }

            try {
                [Console]::SetCursorPosition($x, $y)
                Write-Host $time -NoNewline -ForegroundColor $Color
            }
            catch {
                # 창 크기를 변경하는 순간 발생할 수 있는 오류 방지
            }

            Start-Sleep -Milliseconds $RefreshMilliseconds
        }
    }
    finally {
        [Console]::CursorVisible = $true

        try {
            [Console]::SetCursorPosition(
                0,
                [Math]::Max(0, [Console]::WindowHeight - 1)
            )
        }
        catch {
        }

        Write-Host
    }
}

function Show-MatrixRain {
    [CmdletBinding()]
    param(
        # 화면 갱신 간격입니다. 작을수록 빠르게 움직입니다.
        [ValidateRange(10, 1000)]
        [int]$DelayMilliseconds = 50,

        # 열 사이 간격입니다. 1이면 촘촘하고 2~3이면 여유롭습니다.
        [ValidateRange(1, 10)]
        [int]$ColumnSpacing = 2,

        # 각 문자 열이 한 프레임에 이동하는 최소 칸 수입니다.
        [ValidateRange(1, 10)]
        [int]$MinimumSpeed = 1,

        # 각 문자 열이 한 프레임에 이동하는 최대 칸 수입니다.
        [ValidateRange(1, 10)]
        [int]$MaximumSpeed = 2,

        # 꼬리의 최소 길이입니다.
        [ValidateRange(2, 100)]
        [int]$MinimumTrailLength = 5,

        # 꼬리의 최대 길이입니다.
        [ValidateRange(3, 200)]
        [int]$MaximumTrailLength = 18
    )

    if ($MaximumSpeed -lt $MinimumSpeed) {
        throw 'MaximumSpeed는 MinimumSpeed보다 크거나 같아야 합니다.'
    }

    if ($MaximumTrailLength -lt $MinimumTrailLength) {
        throw 'MaximumTrailLength는 MinimumTrailLength보다 크거나 같아야 합니다.'
    }

    # ASCII와 반각 카타카나를 혼합합니다.
    $characters = @(
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
        'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
        'U', 'V', 'W', 'X', 'Y', 'Z',
        '@', '#', '$', '%', '&', '*', '+', '-', '=', '?',
        'ｱ', 'ｲ', 'ｳ', 'ｴ', 'ｵ',
        'ｶ', 'ｷ', 'ｸ', 'ｹ', 'ｺ',
        'ｻ', 'ｼ', 'ｽ', 'ｾ', 'ｿ',
        'ﾀ', 'ﾁ', 'ﾂ', 'ﾃ', 'ﾄ',
        'ﾅ', 'ﾆ', 'ﾇ', 'ﾈ', 'ﾉ',
        'ﾊ', 'ﾋ', 'ﾌ', 'ﾍ', 'ﾎ',
        'ﾏ', 'ﾐ', 'ﾑ', 'ﾒ', 'ﾓ'
    )

    function New-MatrixColumn {
        param(
            [int]$X,
            [int]$Height
        )

        $maximumInitialY = [Math]::Max(1, $Height)

        [pscustomobject]@{
            X = $X

            Y = Get-Random `
                -Minimum (-$Height) `
                -Maximum $maximumInitialY

            Length = Get-Random `
                -Minimum $MinimumTrailLength `
                -Maximum ($MaximumTrailLength + 1)

            Speed = Get-Random `
                -Minimum $MinimumSpeed `
                -Maximum ($MaximumSpeed + 1)

            FrameCounter = 0

            # 열마다 움직이는 주기를 다르게 하여 더 자연스럽게 만듭니다.
            FrameInterval = Get-Random -Minimum 1 -Maximum 3
        }
    }

    function New-MatrixColumns {
        param(
            [int]$Width,
            [int]$Height
        )

        $result = @()

        for ($x = 0; $x -lt $Width; $x += $ColumnSpacing) {
            $result += New-MatrixColumn `
                -X $x `
                -Height $Height
        }

        return $result
    }

    try {
        Clear-Host
        [Console]::CursorVisible = $false

        $width = [Math]::Max(
            10,
            ([Console]::WindowWidth - 1)
        )

        $height = [Math]::Max(
            5,
            ([Console]::WindowHeight - 1)
        )

        $columns = New-MatrixColumns `
            -Width $width `
            -Height $height

        while ($true) {
            $newWidth = [Math]::Max(
                10,
                ([Console]::WindowWidth - 1)
            )

            $newHeight = [Math]::Max(
                5,
                ([Console]::WindowHeight - 1)
            )

            # 콘솔 크기가 변경되면 열을 다시 생성합니다.
            if (
                $newWidth -ne $width -or
                $newHeight -ne $height
            ) {
                $width = $newWidth
                $height = $newHeight

                Clear-Host

                $columns = New-MatrixColumns `
                    -Width $width `
                    -Height $height
            }

            foreach ($column in $columns) {
                $column.FrameCounter++

                # 일부 열은 매 프레임 움직이지 않게 하여 속도 차이를 만듭니다.
                if ($column.FrameCounter -lt $column.FrameInterval) {
                    continue
                }

                $column.FrameCounter = 0

                # 이전 꼬리 끝부분을 지웁니다.
                for (
                    $eraseOffset = 0;
                    $eraseOffset -lt $column.Speed;
                    $eraseOffset++
                ) {
                    $eraseY = (
                        $column.Y -
                        $column.Length -
                        $eraseOffset
                    )

                    if (
                        $eraseY -ge 0 -and
                        $eraseY -lt $height
                    ) {
                        try {
                            [Console]::SetCursorPosition(
                                [int]$column.X,
                                [int]$eraseY
                            )

                            Write-Host ' ' -NoNewline
                        }
                        catch {
                        }
                    }
                }

                # 꼬리부터 머리까지 다시 그립니다.
                for (
                    $trailIndex = ($column.Length - 1);
                    $trailIndex -ge 0;
                    $trailIndex--
                ) {
                    $y = $column.Y - $trailIndex

                    if ($y -lt 0 -or $y -ge $height) {
                        continue
                    }

                    $character = Get-Random -InputObject $characters

                    if ($trailIndex -eq 0) {
                        # 맨 앞 문자는 밝은 흰색
                        $color = [ConsoleColor]::White
                    }
                    elseif ($trailIndex -le 2) {
                        # 머리 바로 뒤는 밝은 녹색
                        $color = [ConsoleColor]::Green
                    }
                    else {
                        # 긴 꼬리는 어두운 녹색
                        $color = [ConsoleColor]::DarkGreen
                    }

                    try {
                        [Console]::SetCursorPosition(
                            [int]$column.X,
                            [int]$y
                        )

                        Write-Host $character `
                            -NoNewline `
                            -ForegroundColor $color
                    }
                    catch {
                    }
                }

                $column.Y += $column.Speed

                # 꼬리 전체가 화면 아래로 사라지면 위에서 다시 시작합니다.
                if (
                    ($column.Y - $column.Length) -ge $height
                ) {
                    $column.Y = Get-Random `
                        -Minimum (-$height) `
                        -Maximum 0

                    $column.Length = Get-Random `
                        -Minimum $MinimumTrailLength `
                        -Maximum ($MaximumTrailLength + 1)

                    $column.Speed = Get-Random `
                        -Minimum $MinimumSpeed `
                        -Maximum ($MaximumSpeed + 1)

                    $column.FrameInterval = Get-Random `
                        -Minimum 1 `
                        -Maximum 3
                }
            }

            Start-Sleep -Milliseconds $DelayMilliseconds
        }
    }
    finally {
        [Console]::CursorVisible = $true
        Clear-Host
    }
}

function Show-DigitalClock {
    [CmdletBinding()]
    param(
        [ConsoleColor]$Color = [ConsoleColor]::Cyan,

        [switch]$ShowDate
    )

    $digits = @{
        '0' = @(' ███ ', '█   █', '█   █', '█   █', ' ███ ')
        '1' = @('  █  ', ' ██  ', '  █  ', '  █  ', ' ███ ')
        '2' = @(' ███ ', '    █', ' ███ ', '█    ', '█████')
        '3' = @('████ ', '    █', ' ███ ', '    █', '████ ')
        '4' = @('█  █ ', '█  █ ', '█████', '   █ ', '   █ ')
        '5' = @('█████', '█    ', '████ ', '    █', '████ ')
        '6' = @(' ███ ', '█    ', '████ ', '█   █', ' ███ ')
        '7' = @('█████', '    █', '   █ ', '  █  ', '  █  ')
        '8' = @(' ███ ', '█   █', ' ███ ', '█   █', ' ███ ')
        '9' = @(' ███ ', '█   █', ' ████', '    █', ' ███ ')
        ':' = @('     ', '  █  ', '     ', '  █  ', '     ')
    }

    try {
        [Console]::CursorVisible = $false

        while ($true) {
            $timeText = Get-Date -Format 'HH:mm:ss'
            $width    = [Console]::WindowWidth
            $height   = [Console]::WindowHeight

            $renderWidth = ($timeText.Length * 6) - 1

            Clear-Host

            if ($width -lt ($renderWidth + 2) -or $height -lt 8) {
                Write-Host $timeText -ForegroundColor $Color

                if ($ShowDate) {
                    Write-Host (Get-Date -Format 'yyyy-MM-dd dddd')
                }
            }
            else {
                $startX = [Math]::Max(0, [int](($width - $renderWidth) / 2))
                $startY = if ($ShowDate) {
                    [Math]::Max(0, [int](($height - 7) / 2))
                }
                else {
                    [Math]::Max(0, [int](($height - 5) / 2))
                }

                for ($row = 0; $row -lt 5; $row++) {
                    [Console]::SetCursorPosition($startX, $startY + $row)

                    foreach ($character in $timeText.ToCharArray()) {
                        Write-Host ($digits[[string]$character][$row] + ' ') `
                            -NoNewline `
                            -ForegroundColor $Color
                    }
                }

                if ($ShowDate) {
                    $dateText = Get-Date -Format 'yyyy-MM-dd dddd'
                    $dateX = [Math]::Max(0, [int](($width - $dateText.Length) / 2))

                    [Console]::SetCursorPosition($dateX, $startY + 6)
                    Write-Host $dateText -NoNewline -ForegroundColor Gray
                }
            }

            Start-Sleep -Milliseconds 250
        }
    }
    finally {
        [Console]::CursorVisible = $true
        Clear-Host
    }
}

function Show-LavaLamp {
    [CmdletBinding()]
    param(
        [ValidateRange(20, 1000)]
        [int]$DelayMilliseconds = 100,

        [ValidateRange(2, 20)]
        [int]$BlobCount = 8
    )

    $symbols = @('●', '◉', '⬤', '◆', '■')
    $colors = @(
        [ConsoleColor]::Red
        [ConsoleColor]::Yellow
        [ConsoleColor]::Magenta
        [ConsoleColor]::Cyan
        [ConsoleColor]::Green
    )

    try {
        Clear-Host
        [Console]::CursorVisible = $false

        $width  = [Math]::Max(20, [Console]::WindowWidth - 1)
        $height = [Math]::Max(10, [Console]::WindowHeight - 1)

        $blobs = foreach ($i in 1..$BlobCount) {
            [pscustomobject]@{
                X      = Get-Random -Minimum 1 -Maximum ($width - 2)
                Y      = Get-Random -Minimum 1 -Maximum ($height - 2)
                DX     = Get-Random -InputObject @(-1, 1)
                DY     = Get-Random -InputObject @(-1, 1)
                Symbol = Get-Random -InputObject $symbols
                Color  = Get-Random -InputObject $colors
                Tick   = Get-Random -Minimum 1 -Maximum 4
                Counter = 0
            }
        }

        while ($true) {
            foreach ($blob in $blobs) {
                try {
                    [Console]::SetCursorPosition($blob.X, $blob.Y)
                    Write-Host '  ' -NoNewline
                }
                catch {
                }

                $blob.Counter++

                if ($blob.Counter -ge $blob.Tick) {
                    $blob.X += $blob.DX
                    $blob.Y += $blob.DY
                    $blob.Counter = 0
                }

                if ($blob.X -le 1 -or $blob.X -ge ($width - 3)) {
                    $blob.DX *= -1
                }

                if ($blob.Y -le 1 -or $blob.Y -ge ($height - 3)) {
                    $blob.DY *= -1
                }

                try {
                    [Console]::SetCursorPosition($blob.X, $blob.Y)
                    Write-Host $blob.Symbol -NoNewline -ForegroundColor $blob.Color
                }
                catch {
                }
            }

            Start-Sleep -Milliseconds $DelayMilliseconds
        }
    }
    finally {
        [Console]::CursorVisible = $true
        Clear-Host
    }
}

function Show-PerformanceHUD {
    [CmdletBinding()]
    param(
        [ValidateRange(1, 10)]
        [int]$RefreshSeconds = 1,

        [ValidateRange(10, 60)]
        [int]$BarWidth = 30
    )

    function New-ProgressBar {
        param(
            [double]$Percent,
            [int]$Width
        )

        $Percent = [Math]::Max(0, [Math]::Min(100, $Percent))
        $filled = [int][Math]::Round(($Percent / 100) * $Width)
        $empty  = $Width - $filled

        ('█' * $filled) + ('░' * $empty)
    }

    try {
        [Console]::CursorVisible = $false

        while ($true) {
            $os = Get-CimInstance Win32_OperatingSystem
            $cpu = Get-CimInstance Win32_Processor |
                Measure-Object -Property LoadPercentage -Average

            $totalMemory = [double]$os.TotalVisibleMemorySize
            $freeMemory  = [double]$os.FreePhysicalMemory
            $usedMemory  = $totalMemory - $freeMemory

            $memoryPercent = if ($totalMemory -gt 0) {
                ($usedMemory / $totalMemory) * 100
            }
            else {
                0
            }

            $drives = Get-CimInstance Win32_LogicalDisk `
                -Filter 'DriveType=3' `
                -ErrorAction SilentlyContinue

            Clear-Host

            Write-Host '╔══════════════════════════════════════════════╗' `
                -ForegroundColor Cyan
            Write-Host '║             SYSTEM PERFORMANCE HUD           ║' `
                -ForegroundColor Cyan
            Write-Host '╚══════════════════════════════════════════════╝' `
                -ForegroundColor Cyan

            Write-Host
            Write-Host ('Computer : {0}' -f $env:COMPUTERNAME)
            Write-Host ('Time     : {0}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
            Write-Host

            $cpuPercent = [double]$cpu.Average

            Write-Host 'CPU  ' -NoNewline
            Write-Host (New-ProgressBar $cpuPercent $BarWidth) `
                -NoNewline `
                -ForegroundColor Green
            Write-Host (' {0,5:N1}%' -f $cpuPercent)

            Write-Host 'RAM  ' -NoNewline
            Write-Host (New-ProgressBar $memoryPercent $BarWidth) `
                -NoNewline `
                -ForegroundColor Yellow
            Write-Host (' {0,5:N1}%' -f $memoryPercent)

            Write-Host
            Write-Host (
                'Memory: {0:N1} / {1:N1} GB' -f
                    ($usedMemory / 1MB),
                    ($totalMemory / 1MB)
            )

            Write-Host
            Write-Host 'Disk Usage' -ForegroundColor Yellow

            foreach ($drive in $drives) {
                if (-not $drive.Size) {
                    continue
                }

                $used = $drive.Size - $drive.FreeSpace
                $percent = ($used / $drive.Size) * 100

                Write-Host ('{0,-4} ' -f $drive.DeviceID) -NoNewline
                Write-Host (New-ProgressBar $percent $BarWidth) `
                    -NoNewline `
                    -ForegroundColor Cyan
                Write-Host (' {0,5:N1}%' -f $percent)
            }

            Write-Host
            Write-Host 'Top processes by working memory' -ForegroundColor Yellow

            Get-Process -ErrorAction SilentlyContinue |
                ForEach-Object {
                    try {
                        [pscustomobject]@{
                            Name     = $_.ProcessName
                            PID      = $_.Id
                            MemoryMB = [Math]::Round($_.WorkingSet64 / 1MB, 1)
                        }
                    }
                    catch {
                    }
                } |
                Sort-Object MemoryMB -Descending |
                Select-Object -First 5 |
                Format-Table Name, PID, MemoryMB -AutoSize

            Write-Host 'Ctrl+C: Exit' -ForegroundColor DarkGray

            Start-Sleep -Seconds $RefreshSeconds
        }
    }
    finally {
        [Console]::CursorVisible = $true
        Write-Host
    }
}

function Show-Aquarium {
    [CmdletBinding()]
    param(
        [ValidateRange(20, 1000)]
        [int]$DelayMilliseconds = 100,

        [ValidateRange(1, 20)]
        [int]$FishCount = 6
    )

    $fishShapes = @(
        '><(((°>'
        '><>'
        '<°)))><'
        '><((*>'
        '<><'
    )

    $colors = @(
        [ConsoleColor]::Cyan
        [ConsoleColor]::Yellow
        [ConsoleColor]::Green
        [ConsoleColor]::Magenta
        [ConsoleColor]::White
    )

    try {
        Clear-Host
        [Console]::CursorVisible = $false

        $width = [Math]::Max(
            30,
            [Console]::WindowWidth - 1
        )

        $height = [Math]::Max(
            12,
            [Console]::WindowHeight - 1
        )

        $fish = @()

        for ($i = 0; $i -lt $FishCount; $i++) {
            $shape = Get-Random -InputObject $fishShapes
            $maximumX = [Math]::Max(1, $width - $shape.Length)
            $maximumY = [Math]::Max(2, $height - 4)

            $fish += [pscustomobject]@{
                X     = Get-Random -Minimum 0 -Maximum $maximumX
                Y     = Get-Random -Minimum 1 -Maximum $maximumY
                Speed = Get-Random -Minimum 1 -Maximum 4
                Shape = $shape
                Color = Get-Random -InputObject $colors
            }
        }

        $bubbles = @()

        while ($true) {
            $newWidth = [Math]::Max(
                30,
                [Console]::WindowWidth - 1
            )

            $newHeight = [Math]::Max(
                12,
                [Console]::WindowHeight - 1
            )

            if (
                $newWidth -ne $width -or
                $newHeight -ne $height
            ) {
                $width = $newWidth
                $height = $newHeight
                Clear-Host
            }

            foreach ($item in $fish) {
                try {
                    $oldX = [Math]::Max(
                        0,
                        [Math]::Min($item.X, $width - 1)
                    )

                    $oldY = [Math]::Max(
                        0,
                        [Math]::Min($item.Y, $height - 1)
                    )

                    [Console]::SetCursorPosition($oldX, $oldY)
                    Write-Host (' ' * $item.Shape.Length) -NoNewline
                }
                catch {
                }

                $item.X += $item.Speed

                if ($item.X -ge ($width - $item.Shape.Length)) {
                    $item.X = 0

                    $maximumY = [Math]::Max(
                        2,
                        $height - 4
                    )

                    $item.Y = Get-Random `
                        -Minimum 1 `
                        -Maximum $maximumY

                    $item.Shape = Get-Random -InputObject $fishShapes
                    $item.Color = Get-Random -InputObject $colors
                }

                try {
                    [Console]::SetCursorPosition(
                        [int]$item.X,
                        [int]$item.Y
                    )

                    Write-Host $item.Shape `
                        -NoNewline `
                        -ForegroundColor $item.Color
                }
                catch {
                }
            }

            if ((Get-Random -Minimum 1 -Maximum 5) -eq 1) {
                $maximumBubbleX = [Math]::Max(
                    2,
                    $width - 2
                )

                $bubbles += [pscustomobject]@{
                    X = Get-Random `
                        -Minimum 1 `
                        -Maximum $maximumBubbleX

                    Y = $height - 3
                }
            }

            $nextBubbles = @()

            foreach ($bubble in $bubbles) {
                try {
                    [Console]::SetCursorPosition(
                        [int]$bubble.X,
                        [int]$bubble.Y
                    )

                    Write-Host ' ' -NoNewline
                }
                catch {
                }

                $bubble.Y--

                if ($bubble.Y -gt 0) {
                    try {
                        [Console]::SetCursorPosition(
                            [int]$bubble.X,
                            [int]$bubble.Y
                        )

                        Write-Host 'o' `
                            -NoNewline `
                            -ForegroundColor Cyan
                    }
                    catch {
                    }

                    $nextBubbles += $bubble
                }
            }

            $bubbles = $nextBubbles

            for ($x = 0; $x -lt $width; $x += 6) {
                $weedHeight = Get-Random -Minimum 1 -Maximum 4

                for ($weedIndex = 0; $weedIndex -lt $weedHeight; $weedIndex++) {
                    $y = $height - 2 - $weedIndex

                    if (($weedIndex % 2) -eq 0) {
                        $weedCharacter = '/'
                    }
                    else {
                        $weedCharacter = '\'
                    }

                    try {
                        [Console]::SetCursorPosition($x, $y)

                        Write-Host $weedCharacter `
                            -NoNewline `
                            -ForegroundColor Green
                    }
                    catch {
                    }
                }
            }

            try {
                [Console]::SetCursorPosition(
                    0,
                    $height - 1
                )

                Write-Host ('~' * $width) `
                    -NoNewline `
                    -ForegroundColor DarkYellow
            }
            catch {
            }

            Start-Sleep -Milliseconds $DelayMilliseconds
        }
    }
    finally {
        [Console]::CursorVisible = $true
        Clear-Host
    }
}

function Start-GameOfLife {
    [CmdletBinding()]
    param(
        [ValidateRange(20, 1000)]
        [int]$DelayMilliseconds = 120,

        [ValidateRange(1, 100)]
        [int]$InitialDensity = 30
    )

    try {
        Clear-Host
        [Console]::CursorVisible = $false

        $width = [Math]::Max(
            10,
            [Console]::WindowWidth - 1
        )

        $height = [Math]::Max(
            5,
            [Console]::WindowHeight - 2
        )

        $grid = New-Object `
            -TypeName 'System.Boolean[,]' `
            -ArgumentList $width, $height

        for ($x = 0; $x -lt $width; $x++) {
            for ($y = 0; $y -lt $height; $y++) {
                $randomValue = Get-Random `
                    -Minimum 1 `
                    -Maximum 101

                $grid[$x, $y] = (
                    $randomValue -le $InitialDensity
                )
            }
        }

        while ($true) {
            $builder = New-Object System.Text.StringBuilder

            for ($y = 0; $y -lt $height; $y++) {
                for ($x = 0; $x -lt $width; $x++) {
                    if ($grid[$x, $y]) {
                        $cellCharacter = '█'
                    }
                    else {
                        $cellCharacter = ' '
                    }

                    [void]$builder.Append($cellCharacter)
                }

                if ($y -lt ($height - 1)) {
                    [void]$builder.AppendLine()
                }
            }

            [Console]::SetCursorPosition(0, 0)

            Write-Host $builder.ToString() `
                -NoNewline `
                -ForegroundColor Green

            $nextGrid = New-Object `
                -TypeName 'System.Boolean[,]' `
                -ArgumentList $width, $height

            for ($x = 0; $x -lt $width; $x++) {
                for ($y = 0; $y -lt $height; $y++) {
                    $neighbors = 0

                    for ($dx = -1; $dx -le 1; $dx++) {
                        for ($dy = -1; $dy -le 1; $dy++) {
                            if ($dx -eq 0 -and $dy -eq 0) {
                                continue
                            }

                            $neighborX = (
                                $x + $dx + $width
                            ) % $width

                            $neighborY = (
                                $y + $dy + $height
                            ) % $height

                            if ($grid[$neighborX, $neighborY]) {
                                $neighbors++
                            }
                        }
                    }

                    if ($grid[$x, $y]) {
                        $nextGrid[$x, $y] = (
                            $neighbors -eq 2 -or
                            $neighbors -eq 3
                        )
                    }
                    else {
                        $nextGrid[$x, $y] = (
                            $neighbors -eq 3
                        )
                    }
                }
            }

            $grid = $nextGrid

            Start-Sleep -Milliseconds $DelayMilliseconds
        }
    }
    finally {
        [Console]::CursorVisible = $true
        Clear-Host
    }
}

function Show-DoomFire {
    [CmdletBinding()]
    param(
        [ValidateRange(10, 1000)]
        [int]$DelayMilliseconds = 50
    )

    $characters = @(
        ' '
        '.'
        ':'
        '*'
        'o'
        'O'
        '#'
        '█'
    )

    $colors = @(
        [ConsoleColor]::Black
        [ConsoleColor]::DarkRed
        [ConsoleColor]::Red
        [ConsoleColor]::DarkYellow
        [ConsoleColor]::Yellow
        [ConsoleColor]::White
    )

    try {
        Clear-Host
        [Console]::CursorVisible = $false

        $width = [Math]::Max(
            20,
            [Console]::WindowWidth - 1
        )

        $height = [Math]::Max(
            10,
            [Console]::WindowHeight - 1
        )

        $fire = New-Object `
            -TypeName 'System.Int32[,]' `
            -ArgumentList $width, $height

        $maximumIntensity = $characters.Count - 1
        $bottomRow = $height - 1

        for ($x = 0; $x -lt $width; $x++) {
            $fire[$x, $bottomRow] = $maximumIntensity
        }

        while ($true) {
            for ($x = 0; $x -lt $width; $x++) {
                $fire[$x, $bottomRow] = Get-Random `
                    -Minimum ($maximumIntensity - 2) `
                    -Maximum ($maximumIntensity + 1)
            }

            for ($y = 0; $y -lt $bottomRow; $y++) {
                for ($x = 0; $x -lt $width; $x++) {
                    $sourceY = [Math]::Min(
                        $bottomRow,
                        $y + 1
                    )

                    $offset = Get-Random `
                        -Minimum -1 `
                        -Maximum 2

                    $sourceX = (
                        $x + $offset + $width
                    ) % $width

                    $decay = Get-Random `
                        -Minimum 0 `
                        -Maximum 3

                    $value = (
                        $fire[$sourceX, $sourceY] -
                        $decay
                    )

                    $fire[$x, $y] = [Math]::Max(
                        0,
                        $value
                    )
                }
            }

            for ($y = 0; $y -lt $height; $y++) {
                for ($x = 0; $x -lt $width; $x++) {
                    $intensity = $fire[$x, $y]

                    $characterIndex = [Math]::Min(
                        $characters.Count - 1,
                        $intensity
                    )

                    $colorIndex = [int][Math]::Floor(
                        $intensity *
                        $colors.Count /
                        $characters.Count
                    )

                    $colorIndex = [Math]::Min(
                        $colors.Count - 1,
                        $colorIndex
                    )

                    [Console]::SetCursorPosition($x, $y)

                    Write-Host $characters[$characterIndex] `
                        -NoNewline `
                        -ForegroundColor $colors[$colorIndex]
                }
            }

            Start-Sleep -Milliseconds $DelayMilliseconds
        }
    }
    finally {
        [Console]::CursorVisible = $true
        Clear-Host
    }
}

