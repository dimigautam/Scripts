# 🔧 Scripts


# 1. 📜 Build and Run C/C++ Script

This is a simple Bash script to compile and run **C** (`.c`) and **C++** (`.cpp`) source files using `gcc` or `g++`.


> `compile.sh`

- Automatically detects the file type (`.c` or `.cpp`)
- Compiles using:
  - `gcc -std=c17` for `.c` files
  - `g++ -std=c++17` for `.cpp` files
- Places the compiled binary in the `./build/` directory
- Executes the compiled binary after successful compilation

---

## 🧪 Usage

```bash
project/
├── compile.sh
├── main.cpp / hello.c
├── some_directory/
│   └── out.cpp
├── build/
│   └── main / hello / out (executable)
```
### 🔹 1. Make the script executable

```bash
chmod +x compile.sh
```
### 🔹 2. Compile the source files

For a C++ file:
```bash
./compile.sh main.cpp
```
For a C file:
```
./compile.sh hello.c
```
For a C++ file in a directory:
```
./compile.sh some_directory/out.cpp
```

---

# 2. 🚫 Snap Removal Script

This script completely removes **Snap** and all related Snap packages from your Ubuntu system, blocks future reinstallations, and optionally installs a browser of your choice (Firefox or Brave) via APT or external methods.

> `remove_snap.sh`
---

## ⚠️ WARNING

> **This script is irreversible.** It will remove all Snap applications, delete associated system files and directories, and permanently prevent `snapd` from being reinstalled via APT.
>
> Only run this script if you're absolutely sure you no longer want Snap or Snap-based packages on your system.
>
>NOTE: This Script is tested on Ubuntu 24.04 LTS.
---

## 📦 What It Does

1. Prompts user confirmation before proceeding.
2. Iteratively removes all installed Snap packages matching common patterns (e.g., `firefox`, `snap-store`, `gnome-*`, etc.).
3. Disables and masks the `snapd` service.
4. Purges `snapd` from APT and blocks its reinstallation via APT pinning.
5. Deletes all Snap-related directories (`~/snap`, `/snap`, `/var/snap`, `/var/lib/snapd`).
6. Ensures `wget` and `curl` are installed.
7. Prompts the user to optionally install a browser:
   - **Firefox** (official APT repo)
   - **Brave** (official install script)

---

## 🛠️ Prerequisites

- Ubuntu-based system with APT
- Internet connection
- Superuser (`sudo`) privileges

---

## 🚀 Usage

```bash
chmod +x remove_snap.sh
./remove_snap.sh