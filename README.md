# Aseprite Builder

An automated, "one-click" batch script designed to fetch, compile, and package the latest version of **Aseprite** from source on Windows. 

This script handles the heavy lifting: environment configuration, dependency management (Skia), compilation (CMake/Ninja), and even generates a professional Windows Installer (.exe) for you.

---

## ✨ Features

* **Auto-Version Fetching:** Automatically queries the GitHub API to find the latest stable Aseprite release.
* **Dependency Management:** Downloads and extracts the correct version of the Skia graphics engine automatically.
* **Smart Clean Builds:** Wipes previous build artifacts to ensure no "leftover" bugs, featuring a safety confirmation prompt.
* **MSVC Integration:** Automatically locates your Visual Studio installation and initializes the x64 build environment.
* **Installer Generation:** Integrates with Inno Setup to create a professional installer for easy distribution.
* **Robust Error Handling:** Uses path sanitization and TLS 1.2 enforcement for reliable downloads.

---

## 📋 Why use this vs. the official scripts?

While Aseprite provides a `build.sh` and `build.cmd` in their repository, they are "build helpers" rather than "automation pipelines." Here is why you might prefer this tool:

| Feature | Official Scripts | Aseprite Builder Pro |
| :--- | :--- | :--- |
| **Download Source** | ❌ Manual (requires Git clone) | ✅ Automatic (fetches latest ZIP) |
| **Download Skia** | ❌ Manual (separate download) | ✅ Automatic (automatic fetch/extract) |
| **Windows Installer** | ❌ No (binary only) | ✅ Yes (generates .exe via Inno Setup) |
| **Windows Native** | ⚠️ Limited (needs Bash/Git Bash) | ✅ Yes (Native Batch/CMD) |
| **Setup Complexity** | High (many manual steps) | Low (one-click configuration) |

---

## 📋 Prerequisites

Before running the script, ensure you have the following installed and added to your **System PATH**:

1.  **Visual Studio 2022 (Community or Pro):** Install the **"Desktop development with C++"** workload.
2.  **[CMake](https://cmake.org/download/):** Used for build configuration.
3.  **[Ninja](https://ninja-build.org/):** A high-speed build system.
4.  **[Inno Setup](https://jrsoftware.org/isdl.php):** (Optional) Required if you want to generate the `.exe` installer.

---

## 🚀 Usage

1.  **Clone this repository** or download the `.bat` script.
2.  **Configure the path:** Right-click the `.bat` file, select **Edit**, and update the `ROOT_DIR` variable to your project folder:
    ```batch
    set "ROOT_DIR=D:\Path\To\Your\Aseprite_Build"
    ```
3.  **Run the script:** Double-click the batch file.
4.  **Confirm:** Type `Y` when prompted to start the clean build process.
5.  **Relax:** The script will download the source, compile it, and notify you when the installer is ready.

---

## 📂 Project Structure

After a successful run, your directory will look like this:

| Folder/File | Description |
| :--- | :--- |
| `aseprite/` | Fresh source code downloaded from GitHub |
| `build/` | Compiled binaries and build artifacts |
| `installer/` | The final setup .exe installer |
| `skia/` | Extracted Skia binaries for the graphics engine |
| `aseprite_installer.iss` | The generated Inno Setup script |

---

## ⚖️ Legal & Licensing

* **Script License:** This build script is licensed under the **MIT License**.
* **Aseprite License:** Aseprite is a registered trademark of Igara Studio S.A. While the source code is available, the compiled binaries are subject to the **Aseprite EULA**. 
* **Important:** Redistribution of the compiled binaries/installers produced by this script is **prohibited** by the Aseprite license. Use this for personal use or for your own contributions to the project.

---

## 🛠️ Troubleshooting

* **SSL/TLS Errors:** If downloads fail, ensure your Windows installation supports TLS 1.2.
* **vcvars64.bat not found:** Ensure you installed the "Desktop development with C++" workload in the Visual Studio Installer.
* **Ninja/CMake Errors:** Double-check that these tools are correctly added to your Windows Environment Variables (PATH).
