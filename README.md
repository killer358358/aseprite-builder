# Aseprite Builder Pro 🎨

An automated, "one-click" build pipeline for Windows. This tool fetches the latest **Aseprite** source code, manages complex dependencies like **Skia**, compiles the binary using **MSVC**, and packages everything into a professional **Windows Installer**.



---

## ✨ Features

* **Smart Version Detection:** Queries the GitHub API to find the exact `Source.zip` asset URL, preventing "404 Not Found" errors.
* **Automated Workspace:** Creates a self-contained `workspace` folder; no manual path configuration required.
* **Dependency Management:** Automatically downloads and extracts the specific Skia graphics engine binaries required by Aseprite.
* **Visual Studio Integration:** Detects your MSVC installation and initializes the x64 build environment silently.
* **One-Click Installer:** Generates a standard `.exe` setup file using Inno Setup for easy installation and uninstallation.

---

## 📋 Why use this vs. the official scripts?

The official `build.cmd` provided by Aseprite is a helper for developers, whereas this script is a full pipeline for users.

| Feature | Official Scripts | Aseprite Builder Pro |
| :--- | :--- | :--- |
| **Download Source** | ❌ Manual (requires Git) | ✅ Automatic (API Fetch) |
| **Download Skia** | ❌ Manual | ✅ Automatic |
| **Windows Installer** | ❌ No | ✅ Yes (via Inno Setup) |
| **Workspace Setup** | ❌ Manual | ✅ Automatic |

---

## 📋 Prerequisites

Ensure these are installed and added to your **System PATH**:

1.  **Visual Studio 2022:** Install the **"Desktop development with C++"** workload.
2.  **[CMake](https://cmake.org/download/):** For build configuration.
3.  **[Ninja](https://ninja-build.org/):** For high-speed compilation.
4.  **[Inno Setup](https://jrsoftware.org/isdl.php):** (Optional) Required to create the `.exe` installer.

---
## ☁️ Cloud Build (GitHub Actions)

Don't want to install Visual Studio or CMake? You can build Aseprite directly on GitHub's servers:

1. **Fork** this repository.
2. Go to the **Actions** tab in your fork.
3. Select the **Build Aseprite** workflow.
4. Click **Run workflow**.
5. Once finished, download the installer from the **Artifacts** section of the run.

## 🚀 Usage

1.  **Download** the `build_aseprite.bat` file from this repository.
2.  **Place** it in the folder where you want your build workspace to live.
3.  **Run** the script.



4.  **Confirm** the clean build by typing `Y`.
5.  **Wait** 5–15 minutes. The script will notify you once the installer is generated in the `workspace/installer` folder.

---

## 📂 Project Structure

After the build, your directory will be organized as follows:

| Folder | Content |
| :--- | :--- |
| `workspace/aseprite` | The processed source code. |
| `workspace/build` | Compiled binaries (`aseprite.exe` is in `bin/`). |
| `workspace/installer` | The final `.exe` setup file. |
| `workspace/skia` | The graphics engine dependencies. |



---

## ⚖️ Legal & Licensing

* **Script License:** This build script is licensed under the **MIT License**.
* **Aseprite License:** Aseprite is a registered trademark of Igara Studio S.A. Compiled binaries are subject to the **Aseprite EULA**. 
* **Important:** Redistribution of compiled binaries/installers is **prohibited** by the Aseprite license. This tool is for personal use and individual contributions.

---

## 🛠️ Troubleshooting

* **404 Not Found:** Ensure you are using the latest version of this script, which uses dynamic API lookups for the download URL.
* **vcvars64.bat missing:** You likely haven't installed the C++ workload in Visual Studio. Open the VS Installer and check "Desktop development with C++".
* **Ninja/CMake Errors:** Ensure these tools are in your System PATH. You can check this by typing `cmake --version` in a fresh CMD window.
