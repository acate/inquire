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


# 2023-09-08
# Set default values of these vars:
# PRINT_NAMES needs to come before the flags while loop,
#   not after in a "was this variable defined?" test statement,
#   because I think it gets defined in the while loop even when
#   the flag is not part of the command.

XSL_FILE=getAssignmentText.xsl

PRINT_NAMES=false

# 2023-09-08
# Read input args, including flags (new feature as of 2023-09-08)

while test $# -gt 0; do
    case "$1" in
	-z)
	    shift
	    if test $# -gt 0; then
		export ZIP_FILE=$1
	    else
		echo "No .zip file specified"
		exit 1
	    fi
	    shift
	    ;;
	-o)
	    shift
	    if test $# -gt 0; then
		export OUT_FILE_NAME=$1
	    else
		echo "No output filename specified"
		exit 1
	    fi
	    shift
	    ;;
	-p)
	    export PRINT_NAMES=true
	    shift
	    ;;
	*)
	    break
	    ;;
    esac
done

# Check whether necessary variables have been defined
# Test expression evaluates as true if var. NOT defined

if [ -z ${ZIP_FILE+x} ]; then
    echo "Please add -z zip_file.zip to the command"
    exit 1
fi

if [ -z ${OUT_FILE_NAME+x} ]; then
    echo "Please add -o output_file to the command"
    exit 1
fi


#------------
# INPUT FILES
#------------

########## 2023-09-08: Change this to assume that script will
##################       be run in the dir containing the zip file


# ZIP_DIR has been created by unzipping the file downloaded from Inquire
#   It contains directories, one per student
#ZIP_DIR="/home/anthony/Dropbox/work/teaching/Cog/in-class/responses/first_day/anonymous_questionnaire/2022SP PSYC-241-A-First day ANONYMOUS questionnaire-582010/"

#echo "Zip dir. is: $ZIP_DIR"

# cd to ZIP_DIR in order to modify the badly-formed names of the directories it contains
#cd "$ZIP_DIR"


############## 2023-09-08: Change next section to include unzipping of zip file
#####################        into a subdir named "files"

unzip "$ZIP_FILE" -d files

cd files


# 2023-09-03
# Commented out two lines below after Inquire was changed over the summer
#   The problems they addressed no longer apply

# Replace whitespace in student dir. names
#   Dir. names always end in "_" for some ridiculous reason
#rename 's/ /_/g' *_

# Inquire puts a trailing underscore ("_") at the end of each directory (why??!??).
#   Remove all trailing underscores,
#   because they prevent some bash file handling operations
#
# If dirs already renamed, command will just fail and script will move on; will be OK
#rename 's/_$//' *_

# 2023-09-03
# Added the lines below after Inquire was changed over the summer
#   Each student dir. ends with the string "_assignsubmission_onlinetext"
#   Name has a space between first and last, which needs to be filled with
#   an underscore ("_")
rename 's/ /_/g' *onlinetext


#-------------
# OUTPUT FILE
#-------------

############# 2023-09-08: Change so that it is assumed that OUT_FILE_DIR
##################          is always the CWD


# No trailing /

# The following two vars are supplied in the
#   assignment_onlinetext_INPUT_EXAMPLE.sh file for the assignment in questions
#
# Example:
#OUT_FILE_DIR="/home/anthony/Dropbox/work/teaching/Cog/in-class/responses/first_day/anonymous_questionnaire"
#OUT_FILE_NAME=anonymous_questionnaire_responses.txt

# concatenate the two parts
#outFileFull="$OUT_FILE_DIR/$OUT_FILE_NAME"


# Test whether output file already exists
# If so, prompt user whether to delete and continue or quit.

# Move back to dir. that we started in
cd ..

if [ -f "$OUT_FILE_NAME" ]; then

    read -p "Output file already exists.  Press Y to DELETE and OVERWRITE, any other key to QUIT." -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
	# do dangerous stuff
	rm "$OUT_FILE_NAME"
    else
	exit 1
    fi

else 

    echo "Output file is: $OUT_FILE_NAME"

fi


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

# Only list directories, and don't print first line of results (= ".")

for d in $(ls -p "files" | grep "/" )

do

    # For monitoring progress in terminal; NOT printed to file
    echo "Current student directory: $d"


    # Print student name or participant number (if anonymous)
    #   Fields could be 1-2 or 1-3 (not sure yet; 2022-01-28)
    #
    #   (If desired; flag variable switches this on/off)
    if $PRINT_NAMES; then
	echo $d | cut -d_ -f 1-2 >> "$OUT_FILE_NAME"
    fi
    

    # Print a "line" to output file
    echo "-------------------------" >> "$OUT_FILE_NAME"

    # Concatenate current student directory name
    #   (which ends in "/") and html filename
    htmlFilePath="$( echo "./files/""$d""onlinetext.html")"
    
    # Extract the text and concatenate to output file
    xsltproc --html "$xslFileFull" "$htmlFilePath" >> "$OUT_FILE_NAME"


    # Print empty lines to output file
    echo -e "\n\n" >> "$OUT_FILE_NAME"
    

done





