#!/bin/sh

POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -y|--year)
            YEAR="$2"
            shift 2 # shift to next parameter
            ;;
        -m|--month)
            MONTH="$2"
            shift 2 # shift to next parameter
            ;;
        -p|--pdfviewer)
            PDFVIEWER="$2"
            shift 2 # shift to next parameter
            ;;
        -t|--target) 
            TARGET="$2"
            shift 2 # shift to next parameter
            ;;
    esac
done
set -- "$POSITIONAL[@]"

if [ -z "$TARGET" ]; then
    # get latest year 
    TARGET="$HOME/ix"
fi

if [ -z "$YEAR" ]; then
    # get latest year 
    YEAR=`ls $TARGET/ix.* -1 | tail -n 1 | awk -F "." '{ print \$2 }'`
fi

if [ -z "$MONTH" ]; then
    # get latest month
    MONTH=`ls $TARGET/ix.* -1 | tail -n 1 | awk -F "." '{ print \$3 }'`
fi

if [ -z "$PDFVIEWER" ]; then
    PDFVIEWER="evince"
fi

$PDFVIEWER "$TARGET/ix.$YEAR.$MONTH.pdf"
