# Set the title of the PowerShell window
$Host.UI.RawUI.WindowTitle = "Steamodded EZ Installer"

# Set background color, get console size, and clear the console with background color
[System.Console]::BackgroundColor = [System.ConsoleColor]::Black
[System.Console]::ForegroundColor = [System.ConsoleColor]::White
$width = [System.Console]::WindowWidth
$height = [System.Console]::WindowHeight
for ($i = 0; $i -lt $height; $i++) {
    Write-Host (" " * $width) # Write a line of spaces to cover the entire width
}

# Define variables
$lovelyReleaseUrl = "https://api.github.com/repos/ethangreen-dev/lovely-injector/releases/latest"
$tempDirectory = "$env:TEMP\balaTemp"
$lovelyTemp = "$tempDirectory\lovelyTemp"
$lovelyDLL = "$lovelyTemp\version.dll"
$lovelyReleaseRequest = Invoke-RestMethod -Uri $lovelyReleaseUrl -Headers $headers
$steamoddedURL = "https://github.com/Steamopollys/Steamodded/archive/refs/heads/main.zip"
$modsDirectory = Join-Path -Path $env:APPDATA -ChildPath "Balatro\Mods"
$balatroConfigFile = Join-Path -Path $env:TEMP -ChildPath "balatro_config.txt"
$headers = @{
    "User-Agent" = "PowerShell"
}
$zipNameMac1 = ""
$zipNameMac2 = ""
$zipNameWin = ""
$counter = 1
$7zipURL = 'https://7-zip.org/' + (Invoke-WebRequest -UseBasicParsing -Uri 'https://7-zip.org/' | Select-Object -ExpandProperty Links | Where-Object {($_.outerHTML -match 'Download')-and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe")} | Select-Object -First 1 | Select-Object -ExpandProperty href)
$7zipInstallerPath = Join-Path $env:TEMP (Split-Path $7zipURL -Leaf)
$7ZipPath = "C:\Program Files\7-Zip\7z.exe"
$7ZipInstalled = Test-Path $7ZipPath


# Function to convert bytes to megabytes
function Convert-BytesToMB {
    param (
        [int]$bytes
    )
    return [math]::Round($bytes / 1MB, 2)
}

# Function to download a file with progress reporting
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Download-FileWithProgress {
    param (
        [string]$url,
        [string]$outputPath,
        [string]$fileDescription  # New parameter for file description
    )

    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($url, $outputPath)

    # Get the file size
    $fileInfo = Get-Item -Path $outputPath
    $bytesWritten = $fileInfo.Length
    $mbWritten = Convert-BytesToMB -bytes $bytesWritten

    # Output a customized download complete message
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Download complete: $fileDescription - $mbWritten MB"
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
}


Write-Host "                                 (######.                     "
Write-Host "                             */((///////((*                   "
Write-Host "                           ,#//////////////#*                 "
Write-Host "                         #///////////(#     ,#                "
Write-Host "                       *#////////////(#     ,#                "
Write-Host "                      //(/////////////(#(//,.                 "
Write-Host "          .........  .((///////////////(,. .........          "
Write-Host "       (##*********###//////////////////(##*********(##       "
Write-Host "      #**************/////////////////////*************#*     "
Write-Host "    /#***************/////////////////////**************/#    "
Write-Host "   #/******(#******////////////////////////******/#*******#,  "
Write-Host "   #/***/#    (#/*///////////////////////////*##    /(****#,  "
Write-Host " .**,.****    (#/*/////*,,,.       ,,,,//////*##    ,***,.**, "
Write-Host " ,#     ,#    (#(/////                  */////##    /(     /( "
Write-Host "   #,  (/    #/////********,       ********/////#*   .#   #,  "
Write-Host "             #////..,* *## .*    ,, ### ,,  .///#*            "
Write-Host "             ,((//... .....        .....    ./((,.            "
Write-Host "             ./(,....       ,    ..           ((.             "
Write-Host "             #,....//////            ,/////     #*            "
Write-Host "              (#*.. .////////////////////*    ##              "
Write-Host "                ..(.. ////*,       *////.  /*.                "
Write-Host "                  /*,. ,*////////////**   ,/,                 "
Write-Host "              (####......  .//////*       .######*            "
Write-Host "       (##(((((((((,,,....          ....,,,,,,(((((,(##       "
Write-Host "   #(((((((*,,,,,,,.  ,,,((((,,, ,*((*,,,,,,,,  ,,,,/(((/,#,  "
Write-Host " ,#((((///,,,,,,,..,**((((/*,,,,,..,//((/*,,,,,,,,..,,,//((#( "
Write-Host "#(((((,,,,,,,,. ,,,((((((,,,,,,,,,, ,,,((((,,,,,,,,,..,,,,(((#"
Write-Host "#((((((((/,,,.,,,,(((((*,///(((((//*,,,*/(((/,,,,,,,*/((((///#"
Write-Host "#((((((((((*.,,,/(((((,/(((((((((((((/,,/(((((,,,,*((((((((**("
Write-Host " ,#(((((###, #((((((/,(((((((####(((((((**((((((#* ###((((#,  "
Write-Host "#(////#      #((((((((((((#/      .#((((((((((((#*     #####( "
Write-Host ".*((((.      #(((((((((((#,.       .##((((((((((#*     .*##*. "
Write-Host "             /((((((((((/            ,/(((((((((/,            "
Write-Host "             #####((##                  /##((///#*            "
Write-Host "             #######/                     #/////#*            "

# Check if Balatro path is already saved
$balatroPath = ""
if (Test-Path -Path $balatroConfigFile) {
    $savedPath = Get-Content -Path $balatroConfigFile -Raw
    if ($savedPath -and (Test-Path -Path $savedPath.Trim())) {
        Write-Host "`nFound Balatro install location: $savedPath"
        $useSaved = Read-Host "Use this location? (Y/N)"
        if ($useSaved -eq "Y" -or $useSaved -eq "y") {
            $balatroPath = $savedPath.Trim()
        }
    }
}

# If no saved path or user doesn't want to use it, ask for new path
if (-not $balatroPath) {
    Write-Host "`n(Open steam, right click Balatro. Select Manage > Browse local files. Copy & paste this path) `n`nEnter your Balatro install location:"
    $balatroPath = Read-Host
    
    # Save the path for future use
    $balatroPath | Out-File -FilePath $balatroConfigFile -Encoding UTF8
    Write-Host "`nBalatro install location saved for future use."
} 

# Create temp directory
New-Item -Path $tempDirectory -ItemType Directory *> $null
New-Item -Path $lovelyTemp -ItemType Directory *> $null

# Check if 7zip is installed
Write-Host "`nChecking if 7-Zip is installed..."
if (-not $7ZipInstalled) {
    # Install 7-Zip
    Write-Host "`n7-Zip is not installed. Installing 7-Zip..."
    Invoke-WebRequest -Uri $7zipURL -OutFile $7zipInstallerPath
    Start-Process -FilePath $7zipInstallerPath -ArgumentList "/S" -Verb RunAs -Wait
    Remove-Item $7zipInstallerPath

    # Verify installation after running installer
    $7ZipInstalled = Test-Path $7ZipPath
    if ($7ZipInstalled) {
        [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
        Write-Host "7-Zip installed! Continuing..."
        [System.Console]::ForegroundColor = [System.ConsoleColor]::White
    }
    else {
        Write-Host "7-Zip installation failed. Try again or install manually."
        Pause
        exit
    }
}
else {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "7-Zip is already installed. Continuing..."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
}

# Download lovely
Write-Host "`nDownloading Lovely..."
foreach ($asset in $lovelyReleaseRequest.assets) {
    $downloadUrl = $asset.browser_download_url
    $filename = $asset.name
    $destinationPath = Join-Path -Path $tempDirectory -ChildPath $filename

    # Download release assets
    Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationPath

    # Store filenames in variables
    switch ($counter) {
        1 { $zipNameMac1 = $filename }
        2 { $zipNameMac2 = $filename }
        3 { $zipNameWin = $filename }
    }
    $counter++
}

# Confirm lovely downloads correctly
if (Test-Path -Path "$tempDirectory\$zipNameWin") {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Download complete. Continuing..."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
} else {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::DarkRed
    Write-Host "Lovely did not download correctly. Try again or install manually."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
    Pause
    Exit
}

# Unzip lovely
Write-Host "`nUnzipping Lovely..."
#[System.IO.Compression.ZipFile]::ExtractToDirectory("$tempDirectory\$zipNameWin", "$lovelyTemp")
& "$7ZipPath" x "$tempDirectory\$zipNameWin" -o"$lovelyTemp" -y *> $null

# Confirm lovely unzips correctly
if (Test-Path -Path "$lovelyTemp\version.dll") {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Unzip complete. Continuing..."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
} else {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::DarkRed
    Write-Host "File did not unzip correctly. Try again or install manually."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
    Pause
    Exit
}

# Copy lovely to balatro folder
Write-Host "`nInstalling Lovely..."
Copy-Item -Path $lovelyDLL -Destination "$balatroPath" -Force

# Confirm lovely copies correctly
$versionDllPath = Join-Path -Path "$balatroPath" -ChildPath "version.dll"
if (Test-Path -Path $versionDllPath) {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Lovely injector installed. Continuing..."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
} else {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::DarkRed
    Write-Host "Lovely did not install correctly. Exiting script."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
    Pause
    Exit
}

# Clean up
Remove-Item -Path $tempDirectory -Recurse -Force

# Create temp directory
New-Item -Path $tempDirectory -ItemType Directory *> $null

# Download steamodded
Write-Host "`nDownloading Steamodded..."
Download-FileWithProgress -url $steamoddedURL -outputPath "$tempDirectory\Steamodded-main.zip" -fileDescription "Steamodded-main.zip"

# Unzip and delete steamodded .zip
Write-Host "`nUnzipping Steamodded..."
#[System.IO.Compression.ZipFile]::ExtractToDirectory("$tempDirectory\Steamodded-main.zip", "$tempDirectory\Steamodded-main")
& "$7ZipPath" x "$tempDirectory\Steamodded-main.zip" -o"$tempDirectory\Steamodded-main" -y *> $null

# Confirm steamodded unzips correctly
if (Test-Path -Path "$tempDirectory\Steamodded-main\Steamodded-main\README.md") {
    # Double nested folder structure (GitHub archive)
    Rename-Item -Path "$tempDirectory\Steamodded-main\Steamodded-main" -NewName "$tempDirectory\Steamodded-main\Steamodded" -Force
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Unzip complete. Continuing..."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
} elseif (Test-Path -Path "$tempDirectory\Steamodded-main\smods-main\README.md") {
    # smods-main folder structure (actual GitHub structure)
    Rename-Item -Path "$tempDirectory\Steamodded-main\smods-main" -NewName "$tempDirectory\Steamodded-main\Steamodded" -Force
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Unzip complete. Continuing..."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
} elseif (Test-Path -Path "$tempDirectory\Steamodded-main\README.md") {
    # Single folder structure (direct download)
    Rename-Item -Path "$tempDirectory\Steamodded-main" -NewName "$tempDirectory\Steamodded" -Force
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Unzip complete. Continuing..."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
} elseif (Test-Path -Path "$tempDirectory\Steamodded-main\Steamodded\README.md") {
    # Already correctly named structure
    Rename-Item -Path "$tempDirectory\Steamodded-main\Steamodded" -NewName "$tempDirectory\Steamodded" -Force
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Unzip complete. Continuing..."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
} else {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::DarkRed
    Write-Host "File did not unzip correctly. Try again or install manually."
    Write-Host "Expected README.md file not found in any expected location."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
    Pause
    Exit
}

# Create mods folder
Write-Host "`nCreating mods folder..."
if (-Not (Test-Path -Path $modsDirectory)) {
    New-Item -Path $modsDirectory -ItemType Directory -Force *> $null
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Mods folder created at $modsDirectory."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
} else {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Mods directory already exists at $modsDirectory."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
    Remove-Item -Path "$modsDirectory\Steamodded" -Recurse -Force *> $null
    Remove-Item -Path "$modsDirectory\Steamodded-main" -Recurse -Force *> $null
}

# Install steamodded
Write-Host "`nInstalling Steamodded..."
Copy-Item -Path "$tempDirectory\Steamodded-main\Steamodded" -Destination $modsDirectory -Recurse -Force
Remove-Item -Path $tempDirectory -Recurse -Force

# Define the path for the Steamodded directory
$steamoddedDirectory = Join-Path -Path $modsDirectory -ChildPath "Steamodded"

# Confirm steamodded was installed correctly
if (Test-Path -Path $steamoddedDirectory) {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Steamodded installed!"
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
    Write-Host "`nPlace your mods into %AppData%/Balatro/Mods and launch the game. Have fun!"
} else {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::DarkRed
    Write-Host "`nSteamodded did not install correctly. Exiting script."
    Start-Sleep
    Exit
}