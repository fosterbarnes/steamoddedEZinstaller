# steamoddedEZinstaller
Easy window installer for steamodded alpha (https://github.com/Steamopollys/Steamodded) for use with Balatro mods. this script automatically grabs the latest version of lovely & steamodded, so it should always be up to date.

# How to Install
1. Open Windows Powershell or Powershell 7 as administrator
2. Copy the following then paste by right clicking the Powershell window. Press enter, A, then enter again
   
   `Set-ExecutionPolicy Unrestricted`
4. Copy the following then paste by right clicking the Powershell window. Press enter
   
   `iex (irm https://is.gd/steamodEZinstaller)`
5. Open steam, right click Balatro. Select Manage > Browse local files. Copy & paste this path into Powershell and press enter
6. Follow the on screen instructions to install [go](https://go.dev/doc/install), [ghrel](https://github.com/jreisinger/ghrel), [lovely](https://github.com/jreisinger/ghrel), then finally [steamodded](https://github.com/Steamopollys/Steamodded?tab=readme-ov-file). The whole process should just take a couple minutes.

After the install is done, consider setting your powershell execution policy back to restricted:

   `Set-ExecutionPolicy Restricted`

# What are go, ghrel & lovely and why do I need them?
ghrel is used to grab the latest release of lovely from github without me having to constantly update the link in this script, go is required to install ghrel. lovely is required for steamodded to function.
