#!/usr/bin/env bash

echo -e '\e[1mbold\e[22m'
echo -e '\e[2mdim\e[22m'
echo -e '\e[3mitalic\e[23m'
echo -e '\e[4munderline\e[24m'
echo -e '\e[4:1mthis is also underline (new in 0.52)\e[4:0m'
echo -e '\e[21mdouble underline (new in 0.52)\e[24m'
echo -e '\e[4:2mthis is also double underline (new in 0.52)\e[4:0m'
echo -e '\e[4:3mcurly underline (new in 0.52)\e[4:0m'
echo -e '\e[5mblink (new in 0.52)\e[25m'
echo -e '\e[7mreverse\e[27m'
echo -e '\e[8minvisible\e[28m <- invisible (but copy-pasteable)'
echo -e '\e[9mstrikethrough\e[29m'
echo -e '\e[53moverline (new in 0.52)\e[55m'

echo -e '\e[31mred\e[39m'
echo -e '\e[91mbright red\e[39m'
echo -e '\e[38:5:30m256-color, de jure standard (ITU-T T.416)\e[39m'
echo -e '\e[38;5;47m256-color, de facto standard (commonly used)\e[39m'
echo -e '\e[38:2::255:225:12mtruecolor, de jure standard (ITU-T T.416) (new in 0.52)\e[39m'
# echo -e '\e[38:2:240:143:104mtruecolor, rarely used incorrect format (might be removed at some point)\e[39m'
echo -e '\e[38;2;255;120;50mtruecolor, de facto standard (commonly used)\e[39m'

echo -e '\e[46mcyan background\e[49m'
echo -e '\e[106mbright cyan background\e[49m'
echo -e '\e[48:5:132m256-color background, de jure standard (ITU-T T.416)\e[49m'
echo -e '\e[48;5;130m256-color background, de facto standard (commonly used)\e[49m'
echo -e '\e[48:2::95:10:135mtruecolor background, de jure standard (ITU-T T.416) (new in 0.52)\e[49m'
# echo -e '\e[48:2:95:10:135mtruecolor background, rarely used incorrect format (might be removed at some point)\e[49m'
echo -e '\e[48;2;95;135;10mtruecolor background, de facto standard (commonly used)\e[49m'

echo -e '\e[4m\e[58:5:190m256-color underline (new in 0.52)\e[59m\e[24m'
echo -e '\e[21m\e[58:5:202m256-color double underline (new in 0.52)\e[59m\e[24m'
echo -e '\e[4:3m\e[58:2::5:190:255mtruecolor underline (new in 0.52)\e[59m\e[4:0m'
echo -n -e '\e[0m'