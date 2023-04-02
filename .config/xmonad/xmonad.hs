import XMonad
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Ungrab
import XMonad.Util.SpawnOnce
import XMonad.Util.Loggers

import XMonad.Actions.UpdatePointer

import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.Accordion
import XMonad.Layout.Tabbed
import XMonad.Layout.Renamed

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageHelpers

import XMonad.StackSet
import XMonad.Prompt.ConfirmPrompt (confirmPrompt)
import System.Exit (exitWith, exitSuccess)
import Control.Monad
import XMonad.Util.ExclusiveScratchpads (ExclusiveScratchpad(cmd))

import Local.Dmenu
import Local.Color as Color

scrotShot :: String -> String
scrotShot f = "scrot " ++ f ++
  " ~/Pictures/Screenshots/$(date +%Y-%m-%dT%H:%M:%S).png" ++
  " -e 'notify-desktop \"Screenshot: $f\"'"

volume :: String -> String
volume i = "pactl set-sink-volume 0 "++ i ++"%"
mute = "pactl set-sink-mute 0 toggle"

myTerminal :: String
myTerminal = "alacritty"

myLayouts = tiled ||| tiledWide ||| Accordion ||| noBorders Full
  where
    tiled = renamed [Replace "Tall"] . smartSpacing 2 $ Tall nmaster delta ratio
    tiledWide = renamed [Replace "Wide"] $ Mirror tiled
    nmaster = 1
    ratio = 1/2
    delta = 3/100

myStartupHook :: X ()
myStartupHook = do
  spawnOnce "/run/current-system/sw/bin/dunst"
  spawnOnce "picom -b"
  spawnOnce "setxkbmap -option caps:escape"
  spawnOnce "xmobar"
  spawnOnce "dunst"
  spawn "$HOME/.local/share/scripts/autodisplay"
  spawn "feh --bg-scale ~/Pictures/wallpapers/orange-hex-steps.jpg"

myLogHook = updatePointer (0.5, 0.5) (0, 0)

myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = yellow " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Bottom" Color.cyan 2
    , ppVisible         = wrap " " "" . xmobarBorder "Bottom" Color.grey 2
    , ppHidden          = white . wrap " " ""
    -- , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (red "!") (red "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (yellow   "[") (yellow   "]") . cyan . ppWindow
    formatUnfocused = wrap (grey     "[") (grey     "]") . lowWhite . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, cyan, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor Color.magenta ""
    blue     = xmobarColor Color.blue ""
    cyan     = xmobarColor Color.cyan ""
    white    = xmobarColor Color.white ""
    yellow   = xmobarColor Color.yellow ""
    red      = xmobarColor Color.red ""
    lowWhite = xmobarColor Color.lowWhite ""
    grey     = xmobarColor Color.grey ""

myManageHook :: ManageHook
myManageHook = composeAll
  [ className =? "Peek" --> doFloat ]

myConfig = def
  { modMask = mod4Mask
  , terminal = myTerminal
  , normalBorderColor = Color.black
  , focusedBorderColor = Color.darkGrey
  , layoutHook = myLayouts
  , logHook = myLogHook
  , manageHook = myManageHook
  , startupHook = myStartupHook }
  `additionalKeysP`
    [ ("M-S-q", kill)
    , ("M-p q", confirmQuit)
    , ("M-x", spawn "xsecurelock")
    , ("M-S-x", spawn "xsecurelock & systemctl suspend")
    , ("M-s", spawn (scrotShot ""))
    , ("M-S-s", unGrab *> spawn (scrotShot "-s --line mode=edge"))
    , ("M-C-s", spawn (scrotShot "-u"))
    , ("M-p r", spawn dmenuRun)
    , ("M-p p", spawn passmenu)
    , ("M-p b", spawn "firefox")
    , ("<XF86MonBrightnessUp>", spawn "light -A 5")
    , ("<XF86MonBrightnessDown>", spawn  "light -U 5")
    , ("<XF86AudioLowerVolume>", spawn . volume $ "-5")
    , ("<XF86AudioRaiseVolume>", spawn . volume $ "+5")
    , ("<XF86AudioMute>", spawn mute) ]

main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) toggleStruts
     $ myConfig
  where
    toggleStruts :: XConfig Layout -> (KeyMask, KeySym)
    toggleStruts XConfig{ modMask = m } = (m, xK_b)
