module Local.Dmenu (dmenuRun, passmenu, confirmQuit) where

import Control.Monad
import Local.Color
import System.Exit (exitSuccess)
import XMonad
import XMonad.Util.Dmenu

wrapDmenuCliColor :: String -> String
wrapDmenuCliColor c = do
  h <- take 1 c
  if h == '#'
    then "'" ++ c ++ "'"
    else c

baseMenuFlags :: [String]
baseMenuFlags =
  [ "-fn", "'FiraCode Mono Nerd Font-10'",
    "-nb", black,
    "-nf", white,
    "-sf", black ]

menuSelectBg :: String -> [String]
menuSelectBg bg = ["-sb", bg]

verticalMenu :: String -> [String]
verticalMenu lines = ["-l " ++ lines]

dmenuRun :: String
dmenuRun =
  unwords $
    map wrapDmenuCliColor $
      ["dmenu_run"] ++ baseMenuFlags ++ menuSelectBg green ++ verticalMenu "10"

passmenu :: String
passmenu =
  unwords $
    map wrapDmenuCliColor $
      ["passmenu"] ++ baseMenuFlags ++ menuSelectBg magenta ++ verticalMenu "10"

confirmQuit :: MonadIO m => m ()
confirmQuit = do
  selected <- menuArgs "dmenu" (baseMenuFlags ++ menuSelectBg red) ["exit"]
  when (selected == "exit") $ io exitSuccess
