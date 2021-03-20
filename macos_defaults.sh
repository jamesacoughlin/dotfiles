#!/usr/bin/env bash

## This script changes a bunch of default os config settings to my preferred values

# this applescript will close any open prefs windows to ensure they
# don't negate our intended changes
osascript -e 'tell application "System Preferences" to quit'

# prompt for sudo passwd upfront
sudo -v 
# loop in background to keep sudo alive until script has exited
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# show control characters by default
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# ---------  TEXT / KEYBOARD STUFF ----------------
# disable automatic capitalization, auto-correct, smart dashes and period insertion 
# because they are wicked annoying for programmers / competent typists
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# enable full kb access in all ui modes (so you can always tab through menus and such)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# use wicked fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# prevent itunes from hijacking all media key presses
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

# ---------- TRACKPAD STUFF ------------------------
#enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# --------- POWER / BATTERY STUFF -------------------
# set display sleep timer to 15m
sudo pmset -a displaysleep 15

#never machine sleep while connected to power
sudo pmset -c sleep 0

# ---------- SCREEN / DISPLAY SHIT ------------------
# save screenshots to desktop and as PNG files
defaults write com.apple.screencapture location -string "${HOME}/Desktop/Screenshots"
defaults write com.apple.screencapture type -string "png"

#---------- FINDER / FILESTYSTEM --------------------
# show hidden files, and all file extensions
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true 

# show path path in finder
defaults write com.apple.finder ShowPathbar -bool true
# dont warn about changing file extensions
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# dont create DS_Store indexes on network or external volumes 
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# skip disc image verification, i've never seen it fail in 10 years of using macs
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# use list view by default because tiles are stupid 
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

#show ~/Library and /Volumes dirs
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library
sudo chflags nohidden /Volumes

# --------------- DOCK / MISSION CONTROL / EXPOSE ---------
# show only open apps in dock, because who uses the dock anyway
defaults write com.apple.dock static-only -bool true
# speed up mission ctrl animations
defaults write com.apple.dock expose-animation-duration -float 0
# dont re-arrange spaces automatically
defaults write com.apple.dock mru-spaces -bool false
# get rid of the auto-hiding delay
defaults write com.apple.dock autohide-delay -float 0
# get rid of the show/hide animation
defaults write com.apple.dock autohide-time-modifier -float 0
# autohide dock
defaults write com.apple.dock autohide -bool true

# HOT CORNERS
# top left -> mission control
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
# bottom left -> desktop
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 0

# ----------------- SARARI / WEB --------------------
# allow tabbing through all elements
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true
# show full url 
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
# enable  dev menu and inspector 
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
# dont fuckin track me 
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# ----------------- ITERM -----------------------
# dont ask me if i want to quit
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

# ---------------- ACTIVITY MONITOR ------------
# show all processes
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# ---------------- APP STORE ---------------------
# check for updates automatically and once per day
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# download  updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
# auto install system and sec updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
# download all purchased apps
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1
# enable  auto-update
defaults write com.apple.commerce AutoUpdate -bool true
# reboot on os updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

# -------------- PHOTOS ------------------------
# dont open photos on hotplugged devices 
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# --------- KILL ALL AFFECTED APPS TO MAKE CHANGES TAKE EFFECT ----------
for app in "Activity Monitor" \
	"Calendar" \
	"cfprefsd" \
	"Contacts" \
	"Dock" \
	"Finder" \
	"Mail" \
	"Messages" \
	"Photos" \
	"Safari" \
	"SystemUIServer" \
	"Terminal"; do
	killall "${app}" &> /dev/null
done
echo "Done. Some changes may require a reboot" 

