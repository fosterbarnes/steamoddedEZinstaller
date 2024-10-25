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
$headers = @{
    "User-Agent" = "PowerShell"
}
$zipNameMac1 = ""
$zipNameMac2 = ""
$zipNameWin = ""
$counter = 1


# Define a function to convert bytes to megabytes
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

#ask user for balatro game folder
Write-Host "`n(Open steam, right click Balatro. Select Manage > Browse local files. Copy & paste this path) `n`nEnter your Balatro install location:"
$balatroPath = Read-Host 

#create temp directory
New-Item -Path $tempDirectory -ItemType Directory *> $null
New-Item -Path $lovelyTemp -ItemType Directory *> $null

#download lovely
Write-Host "`nDownloading Lovely..."
foreach ($asset in $lovelyReleaseRequest.assets) {
    $downloadUrl = $asset.browser_download_url
    $filename = $asset.name
    $destinationPath = Join-Path -Path $tempDirectory -ChildPath $filename

    #download release assets
    Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationPath

    #store filenames in variables
    switch ($counter) {
        1 { $zipNameMac1 = $filename }
        2 { $zipNameMac2 = $filename }
        3 { $zipNameWin = $filename }
    }
    $counter++
}

#confirm lovely downloads correctly
if (Test-Path -Path "$tempDirectory\$winZip") {
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

#unzip lovely
Write-Host "`nUnzipping Lovely..."
[System.IO.Compression.ZipFile]::ExtractToDirectory("$tempDirectory\$zipNameWin", "$lovelyTemp")

#confirm lovely unzips correctly
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

#copy lovely to balatro folder
Write-Host "`nInstalling Lovely..."
Copy-Item -Path $lovelyDLL -Destination "$balatroPath" -Force

#confirm lovely copies correctly
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

#clean up
Remove-Item -Path $tempDirectory -Recurse -Force

#create temp directory
New-Item -Path $tempDirectory -ItemType Directory *> $null

#download steamodded
Write-Host "`nDownloading Steamodded..."
Download-FileWithProgress -url $steamoddedURL -outputPath "$tempDirectory\Steamodded-main.zip" -fileDescription "Steamodded-main.zip"

#unzip and delete steamodded .zip
Write-Host "`nUnzipping Steamodded..."
[System.IO.Compression.ZipFile]::ExtractToDirectory("$tempDirectory\Steamodded-main.zip", "$tempDirectory\Steamodded-main")


#confirm steamodded unzips correctly
if (Test-Path -Path "$tempDirectory\Steamodded-main\Steamodded-main\README.md") {
    Rename-Item -Path "$tempDirectory\Steamodded-main\Steamodded-main" -NewName "$tempDirectory\Steamodded-main\Steamodded" -Force
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

#create mods folder
Write-Host "`nCreating mods folder..."
if (-Not (Test-Path -Path $modsDirectory)) {
    New-Item -Path $modsDirectory -ItemType Directory -Force *> $null
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Mods folder created at $modsDirectory."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
} else {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::DarkRed
    Write-Host "Mods directory already exists at $modsDirectory."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
}

#install steamodded
Write-Host "`nInstalling Steamodded..."
Copy-Item -Path "$tempDirectory\Steamodded-main\Steamodded" -Destination $modsDirectory -Recurse -Force
Remove-Item -Path $tempDirectory -Recurse -Force

#define the path for the Steamodded directory
$steamoddedDirectory = Join-Path -Path $modsDirectory -ChildPath "Steamodded"

#confirm steamodded was installed correctly
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