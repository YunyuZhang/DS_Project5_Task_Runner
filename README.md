
# Project 5 Part 1 Task Runner 

As I continue working on Project 5, I have put together a bash script that automates the running of all tasks in Part I.

This script will:
- Copy and paste necessary input files to Hadoop.
- Build and run jar files.
- Process, generate and display output files.

 # How to run the script
 1. Cd to `/home/userID/Project5/Part_1` on the remote server. Copy and paste `task_runner.sh` here. The directory should look like this:
 ```
  [student166@heinz-jumbo Part_1]$ ls
  Task0  Task1  Task2  Task3  Task4  Task5  Task6  Task7  task_runner.sh
 ```
 2. Make sure all necessary folders and Java files are created. For example, to run Task0, you need to have a `Task0` folder created and `WordCount.java` pasted into the `Task0` folder before running the script. The directory structure should look like this for `Task0` 
 ```
    [student166@heinz-jumbo Part_1]$ pwd
    /home/student166/Project5/Part_1
    [student166@heinz-jumbo Part_1]$ ls Task0
    WordCount.java
    [student166@heinz-jumbo Part_1]$
 ```
 3. Change `user_id` in `task_runner.sh` to match your user ID.
 4. Modify the environment varibles in `Set environment variables` section in in `task_runner.sh` to match your own file names, package names, etc.
 5. Build the scipt by running `chmod +x task_runner.sh`. You only need to do it once.
 6. Run the script by running `./task_runner.sh Task[0-7]`. For example, `./task_runner.sh Task0`

 # Notes
 Feel free to copy and modify this file for your peronal use.
 Feel free to make comments or put up a PR to improve this script.
 