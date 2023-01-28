#!/bin/bash

read NAME
echo Hello $NAME
bad_command


#grep allows you to find something from a line in a file
#grep --color -n '<text>' <file_name> colors whatever the text is and -n tells you what line it is in
#doing <text>[a-z]* shows all the words that start with the text (doesn't just show words with the text itself but includes things that has suffixes
#doing grep -c '<text>' <file> shows you the number of number lines the pattern occured in, but that doesn't count the multiple words in a single line
#doing grep -o '<text>' <file> shows you the exact word that matches the expression
#doing grep -n '<text>' <file> includes the line numbers the regex appears in
#grep -o '<text>' <file> | wc -l this shows you the number of matches

#there is no way to get just the line numbers when doing the -n flago

