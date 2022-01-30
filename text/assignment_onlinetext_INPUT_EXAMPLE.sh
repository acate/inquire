#!/usr/bin/bash

# assignment_onlinetext_INPUT_EXAMPLE.sh
# 2022-01-28 by adc
#
# Input file template for extract_text_from_assignment_onlinetext.sh,
#   which is called at the end of this script

ZIP_DIR="/home/anthony/Dropbox/work/teaching/Cog/in-class/responses/first_day/anonymous_questionnaire/2022SP PSYC-241-A-First day ANONYMOUS questionnaire-582010/"

OUT_FILE_DIR="/home/anthony/Dropbox/work/teaching/Cog/in-class/responses/first_day/anonymous_questionnaire"

OUT_FILE_NAME=anonymous_questionnaire_responses.txt

NO_NAMES=false

XSL_FILE=getAssignmentText.xsl


#---------------------------------#
# Run the text extraction script! #
#---------------------------------#

source /home/anthony/code/inquire/text/extract_text_from_assignment_onlinetext.sh


# ---------------------------------------------------------------------------------


##################################
# EXPLANATION OF INPUT VARIABLES #
##################################

#-------------#
# INPUT FILES #
#-------------#

# ZIP_DIR="/home/anthony/Dropbox/work/teaching/Cog/"
#
#   ZIP_DIR has been created by unzipping the file downloaded from Inquire.
#   It contains directories, one per student.


#-------------#
# OUTPUT FILE #
#-------------#

# OUT_FILE_DIR="/home/anthony/Dropbox/work/teaching/Cog"
#
#   No trailing forward slash ("/")


# OUT_FILE_NAME=anonymous_questionnaire_responses.txt
#
#   (Self-explanatory)


# NO_NAMES=false
#
#   Flag to suppress printing of student names or participant numbers
#     false -> YES, names are printed
#     true -> NO, names aren't printed


#----------#
# XSL FILE #
#----------#

# XSL_FILE=getAssignmentText.xsl
#
#   IMPORTANT: It is assumed that this file (or a link to it)
#     resides in /home/anthony/code/.

