# 🔧 Scripts


## 📜 Build and Run C/C++ Script

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


