import Xmobar

config :: Config
config
  = let fg      = "#EEFFFF"
        fgAlt   = "#BFC7D5"
        bg      = "#191919"
        red     = "#FF7B85"
        green   = "#ABDC88"
        yellow  = "#FFCA41"
        orange  = "#FF996B"
        blue    = "#82AAFF"
        magenta = "#C792EA"
        violet  = "#BB80B3"
        cyan    = "#89DDFF"
        teal    = "#44b9b1"
  in defaultConfig
    { font = "FiraCode Nerd Font 9"
    , bgColor = bg
    , fgColor = fg
    , allDesktops = True
    , commands =
        [ Run XMonadLog
        , Run $ Memory [ "-t", "<fc="++ green ++">\xf493</fc> <used>"
                       , "-d", "2"
                       , "-h", red
                       , "--", "--scale", "1024" ] 10
        , Run $ DiskU [("/", "\xf7c9 <free>")] ["-l", yellow] 20
        , Run $ Cpu [ "-t", "<fc="++ cyan ++">\xe266</fc> <total>"
                    , "-h", red ] 10
        , Run $ Date ("%a %_d %b %Y <fc="++ yellow ++">%H:%M</fc>")
                     "date" 10
        , Run $ ThermalZone 10 [ "-t", "<fc="++ blue ++">\xf2ca</fc> <temp>"
                               , "-h", red] 30
        , Run $ Battery [ "-t", "<fc="++ yellow ++">\xf0e7</fc> <acstatus>"
                        , "-L", "15" ,"-H", "80"
                        , "-l", red, "-h", green
                        , "--"
                        , "-O", "<left> <fc="++yellow++">+<watts></fc>"
                        , "-o", "<left> <fc="++red++"><watts></fc>"
                        , "-i", "<left>"
                        , "-A", "15"
                        , "-a"
                        , "notify-desktop -u critical 'Battery low!'" ] 30
        , Run $ Wireless "wlp2s0" [ "-t", "<fc="++ magenta ++
                                    ">\xfaa8</fc> <ssid> <quality>"
                                  , "-L", "15", "-l", red
                                  , "-H", "80", "-h", green ] 30]
      , template = " %XMonadLog% }{ "++
                 "%cpu% | %thermal10% | "++
                 "%memory% | %disku% | %wlp2s0wi% | %battery% | %date% "
      , alignSep = "}{"
    }

main :: IO ()
main = xmobar config  -- or: configFromArgs config >>= xmobar
