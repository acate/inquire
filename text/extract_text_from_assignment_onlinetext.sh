#!/usr/bin/bash

# extract_text_from_assignment_onlinetext.sh
#
# 2022-01-28 by adc
#
# USAGE: bash extract_text_from_html_files.sh (use bash, NOT sh)
#          Need to assign input, output file params by modifying script
#
# For getting text from a set of html files downloaded from Canvas for assignments
#   where students answered using a text input box.
#
# modified 2019-01-28 by adc for making CNDM question lists
# modified 2017.11.24 by adc for "words" in-class assignment


# To assign file path that has whitespace to bash variable (other methods exist too):
#DATA_DIR=~/Google\ Drive/teaching/...
#
# Then need to put $Var in quotes when using it, e.g.:
#sed -i.orig 's/^.*questest.*$//g' "$DATA_DIR/$XML_FILE"


#------------
# INPUT FILES
#------------

# ZIP_DIR has been created by unzipping the file downloaded from Inquire
#   It contains directories, one per student
#ZIP_DIR="/home/anthony/Dropbox/work/teaching/Cog/in-class/responses/first_day/anonymous_questionnaire/2022SP PSYC-241-A-First day ANONYMOUS questionnaire-582010/"

echo "Zip dir. is: $ZIP_DIR"

# cd to ZIP_DIR in order to modify the badly-formed names of the directories it contains
cd "$ZIP_DIR"


# Replace whitespace in student dir. names
#   Dir. names always end in "_" for some ridiculous reason
rename 's/ /_/g' *_

# Inquire puts a trailing underscore ("_") at the end of each directory (why??!??).
#   Remove all trailing underscores,
#   because they prevent some bash file handling operations
#
# If dirs already renamed, command will just fail and script will move on; will be OK
rename 's/_$//' *_


#-------------
# OUTPUT FILE
#-------------

# No trailing / 
#OUT_FILE_DIR="/home/anthony/Dropbox/work/teaching/Cog/in-class/responses/first_day/anonymous_questionnaire"

#OUT_FILE_NAME=anonymous_questionnaire_responses.txt

# concatenate the two parts
outFileFull="$OUT_FILE_DIR/$OUT_FILE_NAME"


# Test whether output file already exists
# If so, prompt user whether to delete and continue or quit.

if [ -f "$outFileFull" ]; then

    read -p "Output file already exists.  Press Y to DELETE and OVERWRITE, any other key to QUIT." -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
	# do dangerous stuff
	rm "$outFileFull"
    else
	exit 1
    fi

else 

    echo "Output file is: $outFileFull"

fi

# Create empty output file
#touch "$outFileFull"

#---------
# XSL FILE
#---------

# concatenate the path and filename; use quotes if path includes "\ "
#   MUST write full path (e.g. "/home/anthony") NOT "~" for "home"
xslFileFull="/home/anthony/code/$XSL_FILE"

echo "xsl file is: $xslFileFull"




#--------------------------------------------------------------------------
# Loop through input files, extract all text and append to same output file
#--------------------------------------------------------------------------


for d in $(ls "$ZIP_DIR")

do

    # For monitoring progress in terminal; NOT printed to file
    echo "Current student directory: $d"


    # Print student name or participant number (if anonymous)
    #   Fields could be 1-2 or 1-3 (not sure yet; 2022-01-28)
    #
    #   (If desired; flag variable switches this on/off)
    if $NO_NAMES; then
	echo $d | cut -d_ -f 1-2 >> "$outFileFull"
    fi
    

    # Print a "line" to output file
    echo "-------------------------" >> "$outFileFull"

    
    # Extract the text and concatenate to output file
    xsltproc --html "$xslFileFull" "$ZIP_DIR/$d/onlinetext.html" >> "$outFileFull"


    # Print empty lines to output file
    echo -e "\n\n" >> "$outFileFull"
    

done





