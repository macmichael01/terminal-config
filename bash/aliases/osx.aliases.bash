#!/usr/bin/env bash

# MAC OSX
alias fireworks="open -a '/Applications/Adobe Fireworks CS3/Adobe Fireworks CS3.app'"
alias photoshop="open -a '/Applications/Adobe Photoshop CS3/Adobe Photoshop.app'"
alias preview="open -a '$PREVIEW'"
alias xcode="open -a '/Developer/Applications/Xcode.app'"
alias filemerge="open -a '/Developer/Applications/Utilities/FileMerge.app'"
alias safari="open -a safari"
alias firefox="open -a firefox"
alias chrome="open -a google\ chrome"
alias chromium="open -a chromium"
alias dashcode="open -a dashcode"
alias f='open -a Finder '
alias textedit='open -a TextEdit'
alias hex='open -a "Hex Fiend"'
alias empty="rm -fr ~/.Trash/"
alias safaridebug="defaults write NSGlobalDomain WebKitDeveloperExtras -bool true; defaults write com.apple.safari IncludeDebugMenu -bool true"

if [ -s /usr/bin/firefox ] ; then
  unalias firefox
fi
