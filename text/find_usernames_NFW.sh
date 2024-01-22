#!/usr/bin/bash

# find_usernames_NFW.sh
#
# Usage: find_usernames_NFW.sh -k [usernames key file] -i [DOCX input file to search] -o [output file name]
#
# For INQ-260PY Neuroscience and Free Will
#
# 2023-09-19 by adc
#
# Dependencies: docx2txt
#
# Format of key file:
#   .csv file with first, last names as first two fields;
#   anonymous handle as last field
#
# Try: -k ~/Dropbox/work/teaching/Students/2023FA/INQ-260PY-NFW/anonymous_handles_Google_Docs.csv
#
# Based on find_usernames.sh 
#   2019-01-30 by adc
#
# Flag input args code borrowed from extract_text_from_assignment_onlinetext.sh

while test $# -gt 0; do
    case "$1" in
	-k)
	    shift
	    if test $# -gt 0; then
		export KEY_FILE=$1
	    else
		echo "No usernames key file specified"
		exit 1
	    fi
	    shift
	    ;;
	-i)
	    shift
	    if test $# -gt 0; then
		export SEARCH_FILE=$1
	    else
		echo "No input file to search specified"
		exit 1
	    fi
	    shift
	    ;;
	-o)
	    shift
	    if test $# -gt 0; then
		export SCORE_OUT_FILE=$1
	    else
		echo "No output file name specified"
		exit 1
	    fi
	    shift
	    ;;
	*)
	    break
	    ;;
    esac
done

# Check whether necessary variables have been defined
# Test expression evaluates as true if var. NOT defined

if [ -z ${KEY_FILE+x} ]; then
    echo "Please add -k key_file the command"
    exit 1
fi

if [ -z ${SEARCH_FILE+x} ]; then
    echo "Please add -i input_file the command"
    exit 1
fi

if [ -z ${SCORE_OUT_FILE+x} ]; then
    echo "Please add -o output_file to the command"
    exit 1
fi



# KEY_FILE=~/Google\ Drive/teaching/CNDM/CNDM_2019_fall/admin/usernames/usernames_key.txt
# SEARCH_FILE=~/Google\ Drive/teaching/CNDM/CNDM_2019_fall/discussions/wk9_executive/article/wk9_executive.txt
# SCORE_OUT_FILE=~/Google\ Drive/teaching/CNDM/CNDM_2019_fall/discussions/wk9_executive/article/username_scores.txt

# Test whether output file already exists
# If so, prompt user whether to delete and continue or quit.

if [ -f "$SCORE_OUT_FILE" ]; then

    read -p "Output file already exists.  Press Y to DELETE and OVERWRITE, any other key to QUIT." -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
	# do dangerous stuff
	rm "$SCORE_OUT_FILE"
    else
	exit 1
    fi

else 

    echo "Output file is: $SCORE_OUT_FILE"

fi


# "l" for "line number"

for l in $(seq $(wc -l "$KEY_FILE" | gawk '{print $1}' ) )
do
    # echo $l
    # print line by number
    # echo $(sed "$l!d" "$KEY_FILE") $(grep -c $n "$SEARCH_FILE")

    # thisVar will be the anon. handle
    # assumes that anon. handle is in final column of key file
    thisVar=$(gawk -v line=$l 'BEGIN {FS= ","}; NR==line {print $NF}' "$KEY_FILE")

    # echo "$thisVar"

    # Print each entire line of the key file.
    # Replace the terminal newline with a comma,
    #   so then can append number of matches after this delimeter
    sed -n "$l"p "$KEY_FILE" | tr '\n' ',' >> "$SCORE_OUT_FILE"

    # Alternative sed method for printing single line:
    #    sed "$l!d" "$KEY_FILE" | tr '\n' ' ' >> "$SCORE_OUT_FILE"

    # Append the number of matches (a newline will automatically
    #   be appended after the number)
    echo $(docx2txt "$SEARCH_FILE" - | grep -i -c "\<$thisVar\>") >> "$SCORE_OUT_FILE"
    
done




###############################################

# test code
# tried it out while developing this script
# might be useful examples for another project

# # make array

# myArr=($(gawk '{print $2}' "$KEY_FILE"))


# # (for testing array syntax)
# for x in ${myArr[@]}
# do
#     echo $x
# done

# # init. empty array
# newArr=()

# for n in ${myArr[@]}
# do
#     newArr+=($(grep -c $n "$SEARCH_FILE"))
# done

# # (for testing array syntax)
# for x in ${newArr[@]}
# do
#     echo $x
# done

# for n in ${myArr[@]}
# do
#     echo $(grep -c $n "$SEARCH_FILE") > "$SCORE_OUT_FILE"
# done


# paste "$KEY_FILE" "$SCORE_OUT_FILE" > merged.txt

###############################################



