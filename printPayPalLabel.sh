#!/bin/bash
# PDF Service script which inspects the arguments for the PDF of the PayPal label
# to print, calls GIMP to cut out the instructions and advertising (to enable
# printing two labels per sheet), and prints it.

# User-configurable options:
GIMP=/opt/local/bin/gimp
LOGFILE=~/test.log
###########################

# Redirect stdout and stderr to the logfile
exec >> $LOGFILE 2>&1

INFILE=$1
INFILE_NAME=${INFILE%.*}
INFILE_EXT=${INFILE##*.}
INFILE_DIR=${INFILE%/*}
## Generate an output filename which doesn't already exist
OUTFILE="$INFILE_DIR/shipping-label-$RANDOM.png"
while [ -f $OUTFILE ]; do
    OUTFILE="$INFILE_DIR/shipping-label-$RANDOM.png"
done

echo -e "\n==== Processing a PayPal label for printing ===="
echo "==== `date` ===="
echo "Document title: $TITLE"
echo "Input filename: $INFILE"
echo "Input extension: $INFILE_EXT"
echo "Input directory: $INFILE_DIR"
echo "Output file: $OUTFILE"
echo "GIMP location: $GIMP"

$GIMP -dfi --verbose -b "(script-fu-process-shipping-label \"$INFILE\" \"$OUTFILE\")" -b "(gimp-quit 0)"

echo "Printing to default printer"
lpr $OUTFILE

