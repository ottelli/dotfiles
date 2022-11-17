-- XMonad Configuration used by ottelli

import System.IO
import System.Exit

import XMonad
import XMonad.Config.Desktop

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, PP(..))
import XMonad.Hooks.ManageDocks
--import XMonad.Hooks.StatusBar
--import XMonad.Hooks.StatusBar.PP

import XMonad.Layout.ThreeColumns
import XMonad.Layout.Grid
import XMonad.Layout.Spiral

import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.Run(spawnPipe)

import qualified XMonad.StackSet as W
import qualified Data.Map as M


------------------------------------------------------------------------------
-- Basics
--

-- Font
myFont                = "Source Code Pro Semibold"
mySize                = 10

-- Default Programs
--myTerminal            = "xterm-256color -fa ${myFont} -fs ${mySize}"
myTerminal            = "xterm"
myLauncher            = "dmenu_run -fn ${myFont}-${$mySize}"

-- Workspaces
--myWorkspaces          = [ "main", "www", "code", "term" ]
myWorkspaces          = [ " 1 ", " 2 ", " 3 ", " 4 " ]

-- Colors
primary   = "#7e26e7"
secondary = "#1974d2"
warning   = "#fd6c6c"
fgColor   = "#fefef2"
bgColor   = "#000000"
grey      = "#161616"

-- Aesthetics
myBorderWidth         = 2
myNormalBorderColour  = grey
myFocusedBorderColour = primary
myBackgroundColour    = bgColor
myForegroundColour    = fgColor

------------------------------------------------------------------------------
-- Main
--
main = do
    xmproc <- spawnPipe "xmobar $HOME/.config/xmobar/xmobarrc"

    xmonad . ewmhFullscreen
           . ewmh
           . docks
           $ def
           { terminal           = myTerminal
           , modMask            = mod4Mask 
           --, keys               = myKeys
           , layoutHook         = avoidStruts $ myLayout
           , manageHook         = manageDocks <+> manageHook def 
           , workspaces         = myWorkspaces
           , normalBorderColor  = myNormalBorderColour
           , focusedBorderColor = myFocusedBorderColour
           , borderWidth        = myBorderWidth
           , logHook            = dynamicLogWithPP $ xmobarPP
                { ppOutput          = hPutStrLn xmproc
                , ppSep             = "<fc="++secondary++"> // </fc>"
                , ppCurrent         = xmobarColor primary    "" . wrap "" ""
                --, ppHidden          = xmobarColor fgColor "" . wrap "<box type=Bottom width=2 mb=2 color=#1974d2>" "</box>"
                , ppHidden          = xmobarColor secondary  ""
                , ppHiddenNoWindows = xmobarColor fgColor    "" . wrap "" ""
                , ppUrgent          = xmobarColor warning    "" . wrap "<box type=Bottom width=2 mb=2 color=#ff5555>" "</box>"
                , ppTitle           = xmobarColor primary    ""
                , ppOrder           = \(ws:l:t:_) -> [l,ws,t]
                }
           }    
         `additionalKeysP`
           [ ("M-f" , spawn "firefox"  )
           , ("M-t" , spawn myTerminal )
           -- Media keys
           , ("<XF86AudioMute>", spawn "pamixer --toggle-mute" )
           , ("<XF86AudioLowerVolume", spawn "pamixer --increase 2" )
           , ("<XF86AudioRaiseVolume", spawn "pamixer --decrease 2" )     
           ]


------------------------------------------------------------------------------
-- Key Bindings
--
myModMask = mod4Mask
altMask   = mod1Mask

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  --------------------------------------------------------------------------
  -- Custom key bindings
  --

  -- Start a terminal
  [ ((modMask .|. shiftMask, xK_Return), spawn myTerminal)
  
  -- Start the launcher
  , ((modMask              , xK_p)     , spawn myLauncher)

  -- Start the browser
  , ((modMask              , xK_f)     , spawn "firefox")

  --------------------------------------------------------------------------
  -- Standard XMonad key bindings
  --

  -- Close focused window
  , ((modMask .|. shiftMask, xK_c)     , kill)

  -- Cycle layouts
  , ((modMask              , xK_space) , sendMessage NextLayout)

  -- Resize viewed windows to the correct size
  , ((modMask              , xK_n)     , refresh)
  
  -- Move focus to next window
  , ((modMask              , xK_j)     , windows W.focusDown)

  -- Move focus to previous window 
  , ((modMask              , xK_k)     , windows W.focusUp)

  -- Move focus to master window
  , ((modMask              , xK_m)     , windows W.focusMaster)

  -- Swap the focused window with master
  , ((modMask              , xK_Return), windows W.swapMaster)
  
  -- Swap the focused window with the next
  , ((modMask .|. shiftMask, xK_j)     , windows W.swapDown)

  -- Swap the focused window with the previous
  , ((modMask .|. shiftMask, xK_k)     , windows W.swapUp)

  -- Shrink the master area
  , ((modMask              , xK_h)     , sendMessage Shrink)

  -- Expand the master area 
  , ((modMask              , xK_l)     , sendMessage Expand)

  -- Sink window back into tiling
  , ((modMask              , xK_t)     , withFocused $ windows . W.sink)

  -- Quit xmonad 
  --, ((modMask .|. shiftMask, xK_q)     , io (exitWith ExitSuccess)

  -- Restart xmonad
  , ((modMask              , xK_q)     , restart "xmonad" True)
  ]

------------------------------------------------------------------------------
-- Custom Layouts
--
myLayout = tiled ||| Mirror tiled ||| spiral (6/7) ||| Grid ||| Full ||| threeCol
  where
    threeCol = ThreeCol nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1     -- Max windows inside master
    ratio    = 1/2   -- Master width on screen
    delta    = 3/100 -- Increment(%) when resizing

