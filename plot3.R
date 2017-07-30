# plot3.R

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


##  NOTE:  on this one, they threw us another curve ball, the third EXAMPLE plot shows
##  basically a continuous plot of all three of the data points of the "SUB METERING"
##  so the plot needs to plot all of the data points as a continuous stream of
##  the "DATE" column smushed together with the "TIME" column
##  https://stackoverflow.com/questions/11609252/r-tick-data-merging-date-and-time-into-a-single-object
##  **  BUT **   since we already solved this for PLOT#2,we can employ the same technique here


#summary(dt_pwrconsume)
#Date               Time           Global_active_power Global_reactive_power    Voltage     
#Length:2075259     Length:2075259     Min.   : 0.076      Min.   :0.000         Min.   :223.2  
#Class :character   Class :character   1st Qu.: 0.308      1st Qu.:0.048         1st Qu.:239.0  
#Mode  :character   Mode  :character   Median : 0.602      Median :0.100         Median :241.0 


# NOTE:  "DATE" is a character vector - we need to convert that to a DATE type ...
# convert "DATE" from "character" to "DATE" Type
# https://stackoverflow.com/questions/32940580/convert-some-column-classes-in-data-table

##  AFTER MUCH EXPERIMENTATION !!!!!!!!!  ......
##  I proved that you can't do the same "process flow" as PLOT #1, where I converted the
##  date column into a date format, and first filtered the rows on the date.
##  ONCE AGAIN -- JUST LIKE PLOT #2 -- WE NEED THAT CONTINNUOUS STREAM OF DATA

# *** Don't simply REPLACE *** the date column string values with "date format" values.
# We need the original character dates later when we smush together the DATE/TIME into
# a DATETIME string for the continuous line plot
# CREATE A NEW COLUMN  "REALDATE"

dt_pwrconsume[, RealDate := lapply(.SD, as.Date, "%d/%m/%Y"), .SDcols = c("Date")]

# *NOW* we can strip out only the date data we need from:  2007-02-01 and 2007-02-02
dt_pwrconsume <- dt_pwrconsume[(RealDate >= "2007-02-01") & (RealDate <= "2007-02-02")]


# We *really* only need the data from the columns: "Date" and "TIME" and ..........
# * THIS TIME * we need  -->>  Sub_metering_1/Sub_metering_2/Sub_metering_3
# This time, we need both data and time to later "smush" them together into one column
# to plot the line graph as a continuous stream of data
dt_pwrconsume <- dt_pwrconsume[   , c("Date", "Time", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")     ]


#str(dt_pwrconsume)
#head(dt_pwrconsume)
#Date     Time Sub_metering_1 Sub_metering_2 Sub_metering_3
#1: 1/2/2007 00:00:00              0              0              0
#2: 1/2/2007 00:01:00              0              0              0
#3: 1/2/2007 00:02:00              0              0              0
#4: 1/2/2007 00:03:00              0              0              0
#5: 1/2/2007 00:04:00              0              0              0
#6: 1/2/2007 00:05:00              0              0              0
# CHECKIT:
#summary(dt_pwrconsume)
#Date               Time           Sub_metering_1    Sub_metering_2   Sub_metering_3  
#Length:2880        Length:2880        Min.   : 0.0000   Min.   :0.0000   Min.   : 0.000  
#Class :character   Class :character   1st Qu.: 0.0000   1st Qu.:0.0000   1st Qu.: 0.000  
#Mode  :character   Mode  :character   Median : 0.0000   Median :0.0000   Median : 0.000  
#Mean   : 0.4062   Mean   :0.2576   Mean   : 8.501  
#3rd Qu.: 0.0000   3rd Qu.:0.0000   3rd Qu.:17.000  
#Max.   :38.0000   Max.   :2.0000   Max.   :19.000  


# NOTE: that the date column is still in "character/string" format



# *** NOW *** we can make a POSIXct date that has DATE and TIME smushed together
# for plotting those continuous lines of all the data values


#?as.POSIXct
#  DADBURNIT !!!  this format does not plot right ...
#dt_pwrconsume[, DateTime := as.POSIXct(paste(Date, Time), format = "%Y/%m/%d %H:%M:%S")]
#  DADBURNIT !!!  this format does not plot right either ... 
#dt_pwrconsume[, DateTime := as.POSIXct(paste(Date, Time), format = "%m/%d/%Y %H:%M:%S")]

# this format does, however, work....
dt_pwrconsume[, DateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]


# setup the PNG graphics device to receive the upcoming plot
png("plot3.png", width=480, height=480)


# Plot #3
# NOTE:  when testing, run these commands first to make sure it looks "purdy" B4
# sending it to the PNG file

#?plot
#?lines
#?legend
#?pch    (i don't see a horiz line for the legend listed, so i'm just going to use a filled box)

# we start with a base plot... 
with(dt_pwrconsume, 
    plot(x = DateTime                   # the continuous stream of date data to plot
         , y = Sub_metering_1           # the continuous stream of meter data to plot
         , type="l"                     # line plot
         , xlab=""                      # let the plot engine auto-derive the X label
         , ylab="Energy Sub-Metering")  # the Y-axis label
)                                       # the default color is black, so don't need to specify

# and then tack on and superimpose the SUBMTR_#2 data, in RED...
lines(x = dt_pwrconsume[, DateTime]          # the continuous stream of date data to plot
     , y = dt_pwrconsume[, Sub_metering_2]   # the continuous stream of power data to plot
     , type="l"                              # line plot
     , col = "red"                           # set color to RED
)

# and then tack on and superimpose the SUBMTR_#3 data, in RED...
lines(x = dt_pwrconsume[, DateTime]          # the continuous stream of date data to plot
      , y = dt_pwrconsume[, Sub_metering_3]  # the continuous stream of power data to plot
      , type="l"                             # line plot
      , col = "blue"                         # set color to BLUE
)

legend("topright"
       , pch=15
       , col = c("black", "red", "blue")
       , legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
)


# close the PNG device graphics context so that the file is saved
dev.off()
