# jetson-jtop-patch

A patch to resolve the "Jetpack not installed" issue in `jtop` version 4.3.2 on the Jetson Orin when JetPack 6.2.1 or JetPack 5.1.5 is installed. This should be a temporary fix until Jtop gets updated.

## The Problem

When running `jtop` on a Jetson Orin Nano with a specific `jetson-stats` configuration, users may encounter a message that says "Jetpack not installed" on the main dashboard. This is due to a known issue in `jtop` version `4.3.2` where the script that determines the Jetpack version is not compatible with the Orin Nano's system.

This repository provides a simple, automated fix for this problem.

## The Solution

This repository contains two key files:
1.  **`jtop_patch.diff`**: A `diff` file that contains the necessary changes to a core Python script.
2.  **`apply_jtop_fix.sh`**: A shell script that automatically applies the patch, creates a backup of the original file, and verifies the `jtop` version before making any changes.

### How to Run the Fix

1.  **Clone the repository and apply fix**
    ```bash
    git clone https://github.com/jetsonhacks/jtop-jetpack-fix.git
    cd jtop-jetpack-fix
    chmod +x apply_jtop_fix.sh
    ./apply_jtop_fix.sh
    ```

2.  **Reboot your Jetson:** The script will inform you to reboot the system for the changes to take effect.
    ```bash
    sudo reboot
    ```
After the reboot, run `jtop` again, and the "Jetpack not installed" message should no longer appear.

---

## Notes

### How the Diff File was Generated

The `jtop_patch.diff` file was created by comparing the original `jetson_variables.py` script with a new, modified version that correctly identifies the Jetpack installation on the Jetson Orin Nano.

The command used to generate this file is as follows, assuming the new, modified file is saved as `jetson_variables_new.py` in your home directory (`~/`):

```bash
# Locate the original file's path
ORIGINAL_PATH=$(python3 -c "import jtop, os; print(os.path.join(os.path.dirname(jtop.__file__), 'jetson_variables.py'))")

# Run the diff command to create the patch file
diff -u $ORIGINAL_PATH ~/jetson_variables_new.py > jtop_patch.diff
```
## Release Notes
### August 3, 2025
* Initial Release
