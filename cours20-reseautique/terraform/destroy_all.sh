#!/bin/bash

# Use the current folder as the Terraform folder
TERRAFORM_FOLDER=$(dirname "$(realpath "$BASH_SOURCE")")
echo "Terraform folder : $TERRAFORM_FOLDER"

# Create a temporary folder for modified files
TEMP_FOLDER=$(mktemp -d)
echo "1/7 Creating temporary folder in /tmp..."
if [ ! -d "$TEMP_FOLDER" ]; then
  echo "Error: Failed to create a temporary folder."
  exit 1
fi

# Copy all Terraform files to the temporary folder in /tmp
echo "2/7 Copying Terraform files to the temporary folder ${TEMP_FOLDER}..."
cp -r "$TERRAFORM_FOLDER"/* "$TEMP_FOLDER"
if [ $? -ne 0 ]; then
  echo "Error: Failed to copy Terraform files to the temporary folder."
  rm -rf "$TEMP_FOLDER"
  exit 1
fi

# Comment out all prevent_destroy lines in the temporary files
echo "3/7 Commenting out 'prevent_destroy' lines in all Terraform files..."
find "$TEMP_FOLDER" -type f -name "*.tf" -exec sed -i 's/^\(\s*prevent_destroy\s*=\s*true\s*\)/# \1/' {} \;
if [ $? -ne 0 ]; then
  echo "Error: Failed to comment out 'prevent_destroy' lines in the Terraform files."
  rm -rf "$TEMP_FOLDER"
  exit 1
fi

# Change directory to 
echo "4/7 Changing directory to $TERRAFORM_FOLDE..."
cd $TERRAFORM_FOLDER

# Destroy all resources
echo "5/7 Initializing the new Terraform temporary folder..."
terraform init
if [ $? -ne 0 ]; then
  echo "Error: Terraform init failed."
  rm -rf "$TEMP_FOLDER"
  exit 1
fi

ls -la "$TEMP_FOLDER"

# Destroy all resources
echo "6/7 Destroying all Terraform resources..."
terraform destroy
if [ $? -ne 0 ]; then
  echo "Error: Terraform destroy failed."
  rm -rf "$TEMP_FOLDER"
  exit 1
fi

# Clean up the temporary folder
rm -rf "$TEMP_FOLDER"
echo "7/7 Destroying temporary folder ${TEMP_FOLDER}..."
if [ $? -ne 0 ]; then
  echo "Warning: Failed to clean up the temporary folder."
fi

echo "DONE. Terraform destroy all resources compled, original files remain unchanged."