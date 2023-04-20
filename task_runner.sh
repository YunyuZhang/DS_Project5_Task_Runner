#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <task_name>"
    exit 1
fi

task_name="$1"
user_id="student166"

# Set environment variables
if [ "$task_name" == "Task0" ]; then
    jar_file="wordcount.jar"
    java_file="WordCount.java" 
    main_class="org.myorg.WordCount"
    input_file="words.txt"
elif [ "$task_name" == "Task1" ]; then
    jar_file="lettercount.jar"
    java_file="LetterCounter.java" 
    main_class="org.myorg.LetterCounter"
    input_file="words.txt"
     temp_output="Task1Output_temp"
elif [ "$task_name" == "Task2" ]; then
    jar_file="findpattern.jar"
    java_file="FindPattern.java" 
    main_class="org.myorg.FindPattern"
    input_file="words.txt"
    temp_output="Task2Output_temp"
elif [ "$task_name" == "Task3" ]; then
    jar_file="temperature.jar"
    main_class="edu.cmu.andrew.mm6.MaxTemperature"
    input_file="combinedYears.txt"
    java_file1="MaxTemperatureMapper.java"
    java_file2="MaxTemperatureReducer.java"
    java_file3="MaxTemperature.java"
elif [ "$task_name" == "Task4" ]; then
      jar_file="mintemperature.jar"
      main_class="edu.cmu.andrew.mm6.MinTemperature"
      input_file="combinedYears.txt"
      java_file1="MinTemperatureMapper.java"
      java_file2="MinTemperatureReducer.java"
      java_file3="MinTemperature.java"
elif [ "$task_name" == "Task5" ]; then
      jar_file="rapesplusrobberies.jar"
      main_class="edu.cmu.andrew.mm6.RapesPlusRobberies"
      input_file="P1V.txt"
      java_file="RapesPlusRobberies.java"
elif [ "$task_name" == "Task6" ]; then
      jar_file="oaklandcrimestats.jar"
      main_class="edu.cmu.andrew.mm6.OaklandCrimeStats"
      input_file="P1V.txt"
      java_file="OaklandCrimeStats.java"
elif [ "$task_name" == "Task7" ]; then
      jar_file="oaklandcrimestatskml.jar"
      main_class="edu.cmu.andrew.mm6.OaklandCrimeStatsKML"
      input_file="CrimeLatLonXYTabs.txt"
      java_file="OaklandCrimeStatsKML.java"
else
    echo "Invalid task name. Exiting..."
    exit 1
fi

# Copy input files to hadoop
echo ""
echo "+++++ Copy files to hadhoop folder ++++++"
hadoop dfs -copyFromLocal /home/public/$input_file /user/$user_id/input/$input_file
hadoop dfs -ls /user/$user_id/input/

# Build
echo ""
echo "+++++ Build jar file ++++++"
cd /home/$user_id/Project5/Part_1/$task_name
rm -r buildFolder
mkdir buildFolder
if [ "$task_name" == "Task3" ] || [ "$task_name" == "Task4" ]; then
  javac -classpath  /usr/local/hadoop/hadoop-core-1.2.1.jar:./buildFolder -d buildFolder $java_file1
  javac -classpath  /usr/local/hadoop/hadoop-core-1.2.1.jar:./buildFolder -d buildFolder $java_file2
  javac -classpath  /usr/local/hadoop/hadoop-core-1.2.1.jar:./buildFolder -d buildFolder $java_file3
else
    javac -classpath /usr/local/hadoop/hadoop-core-1.2.1.jar $java_file -d buildFolder
fi
jar -cvf $jar_file -C buildFolder/ .

# Deploy
echo ""
echo "+++++ Run jar file ++++++"
hadoop dfs -rmr /user/$user_id/output
hadoop jar /home/$user_id/Project5/Part_1/$task_name/$jar_file $main_class /user/$user_id/input/$input_file /user/$user_id/output

# Merge outputs and display
echo ""
echo "+++++ Remove old output file ++++++"
rm /home/$user_id/Project5/Part_1/$task_name/${task_name}Output
echo "+++++ Merging output ++++++"
hadoop dfs -getmerge /user/$user_id/output /home/$user_id/Project5/Part_1/$task_name/${task_name}Output

# Process the output file
echo ""
echo "+++++ Process output file ++++++"
if [ "$task_name" == "Task1" ]; then
    # sort the output 
    sort -k 2nr ${task_name}Output > $temp_output
    rm ${task_name}Output
    mv $temp_output ${task_name}Output
elif [ "$task_name" == "Task2" ]; then
    # take out value and keep the key. https://www.computerhope.com/unix/ucut.htm
    cut -f1 ${task_name}Output > $temp_output
    rm ${task_name}Output
    mv $temp_output ${task_name}Output
elif [ "$task_name" == "Task7" ]; then
        cp ${task_name}Output ${task_name}Output.kml
else
    echo "Don't need to process output for" "$task_name"
fi

echo ""
echo "+++++ Display output ++++++"
cat "${task_name}"Output
