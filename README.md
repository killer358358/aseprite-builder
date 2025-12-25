# Aseprite Builder 🎨

This project provides an easy, automated way to get your own copy of **Aseprite** by building it directly from the official source code. 

Aseprite is "source-available" software. This means while the pre-made versions are paid, the creators allow you to compile the code yourself for personal use. This repository does all the hard work for you—automatically setting up the environment and creating a ready-to-use installer.

---

## ✨ Features
* **Free & Legal:** Automatically builds your own personal copy from the official code.
* **No Software Needed:** Everything happens in the "cloud" on GitHub. You don't need to install anything on your own computer to start the build.
* **Fixes Common Errors:** Automatically includes the necessary files (Skia and OpenSSL) so the app actually works after installation.
* **Simple Installer:** Creates a standard Windows `.exe` setup file for you to download.

---

## 🚀 How to Get Aseprite

### Step 1: Start the Build
1. **Fork** this repository (click the "Fork" button at the top right).
2. Go to the **Actions** tab in your new repository.
3. Click **"Build Aseprite"** on the left.
4. Click the **Run workflow** button.

### Step 2: Download
1. **Wait about 25 minutes** for the process to finish (the yellow circle will turn into a green checkmark).
2. Go to the **Releases** section on the right side of your project's home page.
3. Download the `aseprite-setup.exe` and run it!

---

## ⚖️ A Quick Legal Note
* **Personal Use Only:** You are allowed to build this for yourself, but you are **not** allowed to sell it or share the `.exe` file publicly.
* **Support the Creators:** If you enjoy the software, please consider [buying it officially](https://www.aseprite.org/) to support the original developers.

---

## 🛠 Troubleshooting
* **Windows Warning:** Because you built this yourself, Windows might say it doesn't recognize the "publisher." Click **"More Info"** and then **"Run anyway."**
* **Build Failed?** If the build stops with a red "X," just try running it again. Sometimes the cloud servers have temporary hiccups.
