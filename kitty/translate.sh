#!/bin/bash

cat $1 | sed -E 's/catnip/dogchow/g; s/cat/dog/g; s/meow|meowzer/woof/g'  







#originally sed 's/catnip/dogchow/' but you can replace many patterns using sed 's/<pattern_1>/<replacement_1>/; s/<pattern_2>/<replacement_2>/'
#the g at the end means that it'll replace all things starting with the word (global regex flag)
#when you use ./translate.sh kitty_ipsum_1.txt | grep --color 'dog[a-z]*|woof[a-z]*'
#it won't work because the pipe between dog and woof isnt recognized so use a flag
#diff <file_1> <file_2> to find the difference between two files
#diff --color <file_1> <file_2>  The red lines are lines that aren't in the second file, and the green lines are what they were replaced with. The line numbers that were changed are above each section.

#ways to input a textfile into a shell script
#./file.sh file.txt
#./file.sh < file.txt
#cat file.txt | ./file.sh