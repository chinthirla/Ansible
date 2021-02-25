#!/bin/bash

## In order to print text we can use two commands
# 1. printf
# 2. echo

# Printf has a lot of syntax and it is a complex way. But the same job will be done by echo command in a simple way. So we choose echo command


echo Hello World

## Print multiple lines with echo
echo Hello World
echo Bye World

# To print multiple line we can use \n as a new line print
# Rules, \n will be considered only with -e option
# Rules, \n or any escape seq works only with quotes, either single or double quotes, But preferred one is Double Quotes.

echo -e "Hello World\nBye World"

# We also need tab spaces some times , Then use \t

echo -e "Hello\tWorld"
# to print multiple new lines we have to use \n\n\n , \3n might not work. Same with tab space \t\t
echo -e "Hello\t\t\tWorld"


# Color printing is possible, Colors are two ways.
# 1. Foreground (Font Color)
# 2. Background Color

# Only Six colors are available + 2 colors which is black and white.

# Color           #FG Color code    #BG Color Code
# Red             31                  41
# Green           32                  42
# Yellow          33                  43
# Blue            34                  44
# Magenta         35                  45
# Cyan            36                  46

# Syntax :  echo -e "\e[COLOR-CODEmMESSAGE"
#           echo -e "\e[BG;FGmMESSAGE"

echo -e "\e[33mMessage on Yellow Color"
echo -e "No colored Content Message"
echo -e "\e[43;31mMessage of Red on Yellow"
echo -e "No colored Content Message"

# Observation: Color always follows to next lines, So we need to disable the color all the time when you enable the color.

# Syntax:   echo -e "\e[COLmMessage\e[0m"
# 0 color code will reset the color

echo -e "\e[33mMessage on Yellow Color\e[0m"
echo -e "No colored Content Message"
echo -e "\e[43;31mMessage of Red on Yellow\e[0m"
echo -e "No colored Content Message"

## Reference Link : https://misc.flogisoft.com/bash/tip_colors_and_formatting

echo "🎸"
