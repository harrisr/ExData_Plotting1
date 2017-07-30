# plot1.R

# (Slides for this and other Data Science courses may be found at github:
# https://github.com/DataScienceSpecialization/courses/
  
# Loading the data

# When loading the dataset into R, please consider the following:
  
# The dataset has 2,075,259 rows and 9 columns.

# First calculate a rough estimate of how much memory the dataset will require in memory before reading into R. 

# Make sure your computer has enough memory (most modern computers should be fine).

# We will only be using data from the dates 2007-02-01 and 2007-02-02. 

# One alternative is to read the data from just those dates rather than 
# reading in the entire dataset and subsetting to those dates.

# You may find it useful to convert the Date and Time variables to 
# Date/Time classes in R using the strptime()  and as.Date() functions.

# Note that in this dataset missing values are coded as ?.

#Making Plots

# Our overall goal here is simply to examine how household energy usage 
# varies over a 2-day period in February, 2007. 

# Your task is to reconstruct the following plots below, all of which were constructed 
# using the base plotting system.

# First you will need to fork and clone the following GitHub repository: 
# https://github.com/rdpeng/ExData_Plotting1

# For each plot you should:

# Construct the plot and save it to a PNG file with a width of 480 pixels and a height of 480 pixels.

# Name each of the plot files as plot1.png, plot2.png, etc.

# Create a separate R code file (plot1.R, plot2.R, etc.) that constructs the corresponding plot, 

# i.e. code in plot1.R constructs the plot1.png plot. 

# Your code file should include code for reading the data so that the plot 
# can be fully reproduced. You must also include the code that creates the PNG file.

# Add the PNG file and R code file to the top-level folder of your git repository (no need for separate sub-folders)
# ---------------------------------------------------------------------------


library("data.table")
rm(list = ls())


# I received a comment in the previous "getting and cleaning data" project that
# I should not manually download the zip, and unzip that, and place the resultant
# file directly inside this project directory.  So I figured out how to programmatically
# do this....

# You would of course, necessarily have to change this subdirectory to be your own
# correct local path ....

setwd("C:\\myfiles\\coursera_datasci\\ExData_Plotting1")
local_path = getwd()
#local_path    #checkit

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, file.path(local_path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")

#list.files()
#?fread
#?data.table

# From the project instructions, this is important:
# Note that in this dataset missing values are coded as ?
# we need to convert these to "NA"

dt_pwrconsume <-fread("household_power_consumption.txt", na.strings = "?")

#is.data.table(dt_pwrconsume)
#tables()
#head(dt_pwrconsume)
#dim(dt_pwrconsume)
#summary(dt_pwrconsume)
#typeof(dt_pwrconsume)

# Viewing the TXT file, or loading in the data and doing "head()" shows the columns are:
#Date/Time/Global_active_power/Global_reactive_power/Voltage/......
#Global_intensity/Sub_metering_1/Sub_metering_2/Sub_metering_3



# NOTE HERE ...  the "weird format" for the DATE which is a character string: "16/12/2006"
#head(dt_pwrconsume)
#         Date     Time Global_active_power Global_reactive_power Voltage Global_intensity Sub_metering_1
#1: 16/12/2006 17:24:00               4.216                 0.418  234.84             18.4              0
#2: 16/12/2006 17:25:00               5.360                 0.436  233.63             23.0              0
#
#Sub_metering_2 Sub_metering_3
#1:              1             17
#2:              1             16


#summary(dt_pwrconsume)
#Date               Time           Global_active_power Global_reactive_power    Voltage     
#Length:2075259     Length:2075259     Min.   : 0.076      Min.   :0.000         Min.   :223.2  
#Class :character   Class :character   1st Qu.: 0.308      1st Qu.:0.048         1st Qu.:239.0  
#Mode  :character   Mode  :character   Median : 0.602      Median :0.100         Median :241.0 


# NOTE:  "DATE" is a character vector - we need to convert that to a DATE type ...
# convert "DATE" from "character" to "DATE" Type
# https://stackoverflow.com/questions/32940580/convert-some-column-classes-in-data-table

dt_pwrconsume[, Date := lapply(.SD, as.Date, "%d/%m/%Y"), .SDcols = c("Date")]


# CHECK IT:  (and we see that this is better...)
#summary(dt_pwrconsume)
#Date                Time           Global_active_power Global_reactive_power    Voltage     
#Min.   :2006-12-16   Length:2075259     Min.   : 0.076      Min.   :0.000         Min.   :223.2 


# *NOW* we can strip out only the date data we need from:  2007-02-01 and 2007-02-02
dt_pwrconsume <- dt_pwrconsume[(Date >= "2007-02-01") & (Date <= "2007-02-02")]


# CHECKIT:
#summary(dt_pwrconsume)
#Date                Time           Global_active_power Global_reactive_power    Voltage     
#Min.   :2007-02-01   Length:2880        Min.   :0.220       Min.   :0.0000        Min.   :233.1  
#1st Qu.:2007-02-01   Class :character   1st Qu.:0.320       1st Qu.:0.0000        1st Qu.:238.4  
#Median :2007-02-01   Mode  :character   Median :1.060       Median :0.1040        Median :240.6  
#Mean   :2007-02-01                      Mean   :1.213       Mean   :0.1006        Mean   :240.4  
#3rd Qu.:2007-02-02                      3rd Qu.:1.688       3rd Qu.:0.1440        3rd Qu.:242.4  
#Max.   :2007-02-02                      Max.   :7.482       Max.   :0.5000        Max.   :246.6  
#Global_intensity Sub_metering_1    Sub_metering_2   Sub_metering_3  
#Min.   : 1.000   Min.   : 0.0000   Min.   :0.0000   Min.   : 0.000  
#1st Qu.: 1.400   1st Qu.: 0.0000   1st Qu.:0.0000   1st Qu.: 0.000  
#Median : 4.600   Median : 0.0000   Median :0.0000   Median : 0.000  
#Mean   : 5.102   Mean   : 0.4062   Mean   :0.2576   Mean   : 8.501  
#3rd Qu.: 7.000   3rd Qu.: 0.0000   3rd Qu.:0.0000   3rd Qu.:17.000  
#Max.   :32.000   Max.   :38.0000   Max.   :2.0000   Max.   :19.000 


#We *really* only need the data from the columns: "Date" and "Global_active_power"
dt_pwrconsume <- dt_pwrconsume[   , c("Date", "Global_active_power")     ]

#head(dt_pwrconsume)
# CHECKIT:
#summary(dt_pwrconsume)
#Date            Global_active_power
#Min.   :2007-02-01   Min.   :0.220      
#1st Qu.:2007-02-01   1st Qu.:0.320      
#Median :2007-02-01   Median :1.060      
#Mean   :2007-02-01   Mean   :1.213      
#3rd Qu.:2007-02-02   3rd Qu.:1.688      
#Max.   :2007-02-02   Max.   :7.482




# setup the PNG graphics device to receive the upcoming plot
png("plot1.png", width=480, height=480)


# Plot #1
# NOTE:  when testing, run this command first to make sure it looks "purdy" B4
# sending it to the PNG file
#            all rows      only the column "Global active power"
#                 \/       \/
hist(dt_pwrconsume[, Global_active_power]
     , main="Global Active Power"               # Title of graph
     , xlab="Global Active Power (kilowatts)"   # X-axis label
     , ylab="Frequency"                         # Y-axis label
     , col="Red")                               # color of the bars

# close the PNG device graphics context so that the file is saved
dev.off()
