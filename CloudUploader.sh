#!/bin/bash

# Parse command-line arguments
FILE_PATH=$1
CLOUD_PROVIDER=$2
TARGET_DIR=$3

# Check if file path is provided
if [ -z "$FILE_PATH" ]; then
    echo "Error: No file path provided."
    exit 1
fi

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File not found."
    exit 1
fi

# Handle different cloud providers
case $CLOUD_PROVIDER in
    aws)
        aws s3 cp "$FILE_PATH" "s3://$TARGET_DIR/"
        ;;
    gcp)
        gsutil cp "$FILE_PATH" "gs://$TARGET_DIR/"
        ;;
    azure)
        az storage blob upload --file "$FILE_PATH" --container-name "$TARGET_DIR" --name "$(basename $FILE_PATH)"
        ;;
    *)
        echo "Error: Unsupported cloud provider."
        exit 1
        ;;
esac

# Provide upload feedback
if [ $? -eq 0 ]; then
    echo "File uploaded successfully."
else
    echo "File upload failed."
fi

