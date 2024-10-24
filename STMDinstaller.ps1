# Set the title of the PowerShell window
$Host.UI.RawUI.WindowTitle = "Steamodded EZ Installer"

# Define a function to convert bytes to megabytes
function Convert-BytesToMB {
    param (
        [int]$bytes
    )
    return [math]::Round($bytes / 1MB, 2)
}

# Set background color, get console size, and clear the console with background color
[System.Console]::BackgroundColor = [System.ConsoleColor]::Black
[System.Console]::ForegroundColor = [System.ConsoleColor]::White
$width = [System.Console]::WindowWidth
$height = [System.Console]::WindowHeight
for ($i = 0; $i -lt $height; $i++) {
    Write-Host (" " * $width) # Write a line of spaces to cover the entire width
}

# Define variables
$installerPath = "$env:USERPROFILE\Downloads\go1.23.2.windows-amd64.msi"
$goUrl = "https://go.dev/dl/go1.23.2.windows-amd64.msi"
$tempGhrel = "$env:USERPROFILE\Downloads\tempGhrel.txt"
$isGoInstalled = $false
$GOexe = "C:\Program Files\Go\bin\go.exe"
$lovelyTemp = "$env:USERPROFILE\Downloads\lovelyTemp"
$lovelyDLL = "$lovelyTemp\version.dll"
$steamoddedURL = "https://github.com/Steamopollys/Steamodded/archive/refs/heads/main.zip"
$modsDirectory = Join-Path -Path $env:APPDATA -ChildPath "Balatro\Mods"

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
    Write-Host "Download complete: $fileDescription - $mbWritten MB"
}

# Function to check if Go is installed via PATH or specific locations
function Is-GoInstalled {
    # Check if 'go' command is available in the PATH
    $goCmd = Get-Command go -ErrorAction SilentlyContinue
    if ($goCmd) {
        return $true
    }

    # Check if Go is installed in the registry (standard Go installation location)
    $goRegistryPath = "HKLM:\SOFTWARE\GoProgrammingLanguage"
    if (Test-Path $goRegistryPath) {
        return $true
    }

    # Check if Go executable exists at the standard installation location
    $goExePath = "C:\Program Files\Go\bin\go.exe"
    if (Test-Path $goExePath) {
        return $true
    }

    return $false
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

#ask user for balatro game folder
Write-Host "`n(Open steam, right click Balatro. Select Manage > Browse local files. Copy & paste this path) `n`nEnter your Balatro install location:"
$balatroPath = Read-Host 

# Check if Go is installed
if (-Not (Is-GoInstalled)) {
    $isGoInstalled = $false
    Write-Host "`nGo is not installed. Running the installation process...`n"

    # Check if the Go installer already exists, download if it doesn't
    if (-Not (Test-Path -Path $installerPath)) {
        Write-Host "Downloading Go 1.23.2..."
        Download-FileWithProgress -url $goUrl -outputPath $installerPath -fileDescription "go1.23.2.windows-amd64.msi"
    } else {
        Write-Host "Go installer already exists at $installerPath"
    }

    # Install Go
    Write-Host "Press any key to run the Go installer..."
    [void][System.Console]::ReadKey($true)
    Start-Process "$installerPath" -Wait

    # Check again if Go is installed after running the installer
    if (Is-GoInstalled) {
        $isGoInstalled = $true
        [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
        Write-Host "`nGo installation complete. Continuing..."
        [System.Console]::ForegroundColor = [System.ConsoleColor]::White
        Remove-Item -Path "$env:USERPROFILE\Downloads\go1.23.2.windows-amd64.msi" -Recurse -Force
    } else {
        [System.Console]::ForegroundColor = [System.ConsoleColor]::DarkRed
        Write-Host "`nGo installation failed. Please check the installer or your system settings."
        [System.Console]::ForegroundColor = [System.ConsoleColor]::White
        Exit
    }
    
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
} else {
    $isGoInstalled = $true
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "`nGo is already installed on your system. Continuing..."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
}

#install ghrel
Write-Host "`nInstalling ghrel..."
& $GOexe install github.com/jreisinger/ghrel@latest
[System.Console]::ForegroundColor = [System.ConsoleColor]::Green
Write-Host "ghrel install complete"
[System.Console]::ForegroundColor = [System.ConsoleColor]::White

#install lovely
ghrel -l ethangreen-dev/lovely-injector >>$tempGhrel
$zipName = Get-Content -Path "$tempGhrel" -Raw

# Create an array from the lines in zipName
$zipNameLines = $zipName -split "`r?`n"  # Split by new lines

# Ensure the array has enough lines to access
if ($zipNameLines.Length -ge 3) {
    # Create new variables for different platforms from the respective lines
    $zipNameMac1 = "$($zipNameLines[0])"
    $zipNameMac2 = "$($zipNameLines[1])"
    $zipNameWin = "$($zipNameLines[2])"
} else {
    Write-Host "Not enough lines in temp.txt to create zip names."
}

#download lovely
Write-Host "`nDownloading lovely injector..."
cd "$env:USERPROFILE\Downloads\"
ghrel ethangreen-dev/lovely-injector *> $null

#unzip lovely
[System.IO.Compression.ZipFile]::ExtractToDirectory("$env:USERPROFILE\Downloads\$zipNameWin", "$lovelyTemp")

#copy lovely to balatro folder
Copy-Item -Path $lovelyDLL -Destination $balatroPath -Force

# Check if version.dll exists in the Balatro path
$versionDllPath = Join-Path -Path $balatroPath -ChildPath "version.dll"
if (Test-Path -Path $versionDllPath) {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "`nLovely injector installed. Continuing..."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
} else {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::DarkRed
    Write-Host "`nLovely did not install correctly. Exiting script."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
    Exit
}

#clean up
Remove-Item -Path $tempGhrel -Force
Remove-Item -Path $zipNameMac1 -Force
Remove-Item -Path $zipNameMac2 -Force
Remove-Item -Path $zipNameWin -Force
Remove-Item -Path $lovelyTemp -Recurse -Force

#download steamodded
Write-Host "`nDownloading Steamodded..."
Download-FileWithProgress -url $steamoddedURL -outputPath "$env:USERPROFILE\Downloads\Steamodded-main.zip" -fileDescription "Steamodded-main.zip"

#unzip and delete steamodded .zip
[System.IO.Compression.ZipFile]::ExtractToDirectory("$env:USERPROFILE\Downloads\Steamodded-main.zip", "$env:USERPROFILE\Downloads\Steamodded-main")
Rename-Item -Path "$env:USERPROFILE\Downloads\Steamodded-main\Steamodded-main" -NewName "$env:USERPROFILE\Downloads\Steamodded-main\Steamodded" -Force

#create mods folder
if (-Not (Test-Path -Path $modsDirectory)) {
    New-Item -Path $modsDirectory -ItemType Directory -Force
    Write-Host "`nMods directory created at $modsDirectory."
} else {
    Write-Host "`nMods directory already exists at $modsDirectory."
}

#copy steamodded to appdata, then delete from downloads
Copy-Item -Path "$env:USERPROFILE\Downloads\Steamodded-main\Steamodded" -Destination $modsDirectory -Recurse -Force
Remove-Item -Path "$env:USERPROFILE\Downloads\Steamodded-main.zip" -Recurse -Force
Remove-Item -Path "$env:USERPROFILE\Downloads\Steamodded-main" -Recurse -Force

# Define the path for the Steamodded directory within Mods
$steamoddedDirectory = Join-Path -Path $modsDirectory -ChildPath "Steamodded"

# Check if the Steamodded directory exists
if (Test-Path -Path $steamoddedDirectory) {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "`nSteamodded installed. Place your mods into %AppData%/Balatro/Mods and launch the game. Have fun!"
} else {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::DarkRed
    Write-Host "`nSteamodded did not install correctly. Exiting script."
    Exit
}