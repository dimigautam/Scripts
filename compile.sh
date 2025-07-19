#!/bin/bash

# Check if source file is passed
if [ -z "$1" ]; then
    echo "Usage: $0 <source_file.c | source_file.cpp>"
    exit 1
fi

# Input file
SRC="$1"
FILENAME=$(basename -- "$SRC")
EXT="${FILENAME##*.}"
NAME="${FILENAME%.*}"
BUILD_DIR="./build"

# Determine compiler and standard
if [ "$EXT" == "c" ]; then
    COMPILER="gcc"
    STD="-std=c17"
elif [ "$EXT" == "cpp" ]; then
    COMPILER="g++"
    STD="-std=c++17"
else
    echo "❌ Unsupported file extension: .$EXT"
    echo "Supported: .c (C), .cpp (C++)"
    exit 1
fi

# Create build directory if needed
mkdir -p "$BUILD_DIR"

# Compile
echo "🔧 Compiling $SRC using $COMPILER..."
$COMPILER $STD -Wall -g "$SRC" -o "$BUILD_DIR/$NAME"
if [ $? -ne 0 ]; then
    echo "❌ Compilation failed"
    exit 1
fi

# Run
echo "🚀 Running: $BUILD_DIR/$NAME"
"$BUILD_DIR/$NAME"

