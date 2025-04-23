# 🧠 Bash & Linux Cheatsheet

## 📁 File & Directory Operations
```bash
ls -l       # Long listing
cd <dir>    # Change directory
mkdir <dir> # Create a directory
touch <file> # Create empty file
cp <src> <dest> # Copy files or dirs
mv <src> <dest> # Move or rename files
rm <file>   # Delete file
rm -r <dir> # Delete directory
pwd         # Print working directory
clear       # Clear terminal
```

---

## 🔒 Permissions & Ownership
```bash
chmod +x <file>        # Make script executable
chmod 755 <file>       # rwxr-xr-x
chown user:group <file> # Change ownership
ls -lah                # List all with sizes and hidden
umask                  # View default permission mask
```

---

## 📦 Bash Script Basics
```bash
#!/bin/bash

# Variables
name="Abhinav"
echo "Hello, $name!"

# User input
read -p "Enter your age: " age
echo "You are $age years old."

# Arguments
script_name=$0
arg1=$1
arg2=$2
echo "Script: $script_name | Arg1: $arg1 | Arg2: $arg2"

# Exit codes
if [ $? -eq 0 ]; then
  echo "Previous command was successful."
fi
```

---

## 🔁 Conditions & Loops
```bash
# If-else
if [ $age -ge 18 ]; then
  echo "Adult"
else
  echo "Minor"
fi

# For loop
for i in {1..5}; do
  echo "Number: $i"
done

# While loop
count=0
while [ $count -lt 3 ]; do
  echo "Count: $count"
  ((count++))
done
```

---

## 🧠 Functions & Execution
```bash
# Function
greet() {
  echo "Hello, $1!"
}

greet "World"

# Make a script executable and run it
chmod +x myscript.sh
./myscript.sh
```

---

## 🛠️ Useful Shortcuts & Tips
```bash
alias ll='ls -lah'
export PATH=$PATH:/custom/bin
history   # Show command history
ctrl + r  # Reverse search command
```

---

📌 Save this file as: `tools/bash-cheatsheet.md`
Use it daily while practicing to build muscle memory 💪
