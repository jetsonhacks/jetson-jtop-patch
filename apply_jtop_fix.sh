#!/bin/bash

# Define the required jtop version and the patch file name
REQUIRED_VERSION="4.3.2"
JTOP_FILENAME="jetson_variables.py"
PATCH_FILE="jtop_patch.diff"

# --- Main script logic ---

# Check if the diff file exists
if [ ! -f "$PATCH_FILE" ]; then
    echo "Error: The patch file '$PATCH_FILE' was not found."
    echo "Please ensure 'jtop_patch.diff' is in the same directory as this script."
    exit 1
fi

# Get the current jtop version
CURRENT_VERSION=$(jtop --version 2>/dev/null | cut -d ' ' -f 2)

if [ "$CURRENT_VERSION" != "$REQUIRED_VERSION" ]; then
    echo "Error: Incorrect jtop version. Expected '$REQUIRED_VERSION', but found '$CURRENT_VERSION'."
    echo "This patch is specific to version $REQUIRED_VERSION and may not work with other versions."
    exit 1
else
    echo "Verified jtop version: $CURRENT_VERSION. Applying patch..."
fi

# Dynamically find the path to the jtop Python script
# This handles different Python versions (e.g., python3.8, python3.10)
echo "Searching for '$JTOP_FILENAME' in the Python installation directories..."
JTOP_SCRIPT_PATH=$(python3 -c "import jtop, os; print(os.path.join(os.path.dirname(jtop.__file__), '$JTOP_FILENAME'))")

if [ -f "$JTOP_SCRIPT_PATH" ]; then
    echo "Found jtop script at: $JTOP_SCRIPT_PATH"
else
    echo "Error: The jtop script '$JTOP_FILENAME' was not found."
    echo "Script could not be located at the expected path."
    exit 1
fi

# Create a backup of the original script
echo "Creating backup of original script at $JTOP_SCRIPT_PATH.bak"
sudo cp "$JTOP_SCRIPT_PATH" "$JTOP_SCRIPT_PATH.bak"

# Apply the patch
sudo patch "$JTOP_SCRIPT_PATH" < "$PATCH_FILE"

# Check if the patch was applied successfully
if [ $? -eq 0 ]; then
    echo "Patch applied successfully!"
    echo "--------------------------------------------------------"
    echo "IMPORTANT: Please reboot your Jetson Orin for the changes to take effect."
    echo "You can do this by running: 'sudo reboot'"
else
    echo "Error: Failed to apply the patch."
    echo "The original file has been backed up to '$JTOP_SCRIPT_PATH.bak'."
    echo "You may need to manually inspect the error or restore the backup."
fi

exit 0
