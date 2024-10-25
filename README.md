# steamoddedEZinstaller
Easy window installer for steamodded alpha (https://github.com/Steamopollys/Steamodded) for use with Balatro mods. this script automatically grabs the latest version of Lovely injector & Steamodded, so it should always be up to date.

if Steamodded or Lovely injector are already installed, this script will update them to the latest version(s)

# How to Install
1. Open Windows Powershell or Powershell 7 as administrator
2. Copy the following then paste by right clicking the Powershell window. Press enter, A, then enter again
   
   `Set-ExecutionPolicy Unrestricted`
4. Copy the following then paste by right clicking the Powershell window. Press enter
   
   `iex (irm https://is.gd/steamodEZinstaller)`
5. Open steam, right click Balatro. Select Manage > Browse local files. Copy & paste this path into Powershell and press enter
6. Wait for script to run and complete. That's it!

After the install is done, consider setting your powershell execution policy back to restricted:

   `Set-ExecutionPolicy Restricted`
