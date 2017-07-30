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

# SINCE WE'VE ALREADY DONE THE FOLLOWING STEP IN THE PREVIOUS SCRIPTS, I'LL JUST COMMENT THIS OUT HERE...

#url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
#download.file(url, file.path(local_path, "dataFiles.zip"))
#unzip(zipfile = "dataFiles.zip")

# Since I listed all my nitty-gritty comments in the previous three script files, I'll eliminate
# most of those comments from this script.....

# From the project instructions, this is important:
# Note that in this dataset missing values are coded as ?
# we need to convert these to "NA"

dt_pwrconsume <-fread("household_power_consumption.txt", na.strings = "?")


# Viewing the TXT file, or loading in the data and doing "head()" shows the columns are:
#Date/Time/Global_active_power/Global_reactive_power/Voltage/......
#Global_intensity/Sub_metering_1/Sub_metering_2/Sub_metering_3


dt_pwrconsume[, RealDate := lapply(.SD, as.Date, "%d/%m/%Y"), .SDcols = c("Date")]

dt_pwrconsume <- dt_pwrconsume[(RealDate >= "2007-02-01") & (RealDate <= "2007-02-02")]


# This time, we need almost all the columns...
dt_pwrconsume <- dt_pwrconsume[   , c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage"
                                      , "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")     ]

# this format works....
dt_pwrconsume[, DateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]


# setup the PNG graphics device to receive the upcoming plot
png("plot4.png", width=480, height=480)


# Plot #4
# NOTE:  when testing, run these commands first to make sure it looks "purdy" B4
# sending it to the PNG file

# setup the rows/columns and margins for the 4 upcoming graphs
par(mfrow=c(2, 2), mar=c(4, 4, 2, 1), oma=c(0, 0, 2, 0) )

# do all the plots at once, and from basically the two previous projects,
# and all two new ones that are extremely similar to the GLOBAL_ACTIVE_POWER one...

with(dt_pwrconsume, 
     {
     plot(x = dt_pwrconsume[, DateTime]               # the continuous stream of date data to plot
          , y = dt_pwrconsume[, Global_active_power]  # the continuous stream of power data to plot
          , type="l"                                  # line plot
          , xlab=""                                   # let the plot engine auto-derive the X label
          , ylab="Global Active Power (kilowatts)")   # the Y-axis label
     
    plot(x = DateTime                   # the continuous stream of date data to plot
         , y = Voltage           # the continuous stream of meter data to plot
         , type="l"                     # line plot
         , xlab=""                      # let the plot engine auto-derive the X label
         , ylab="Voltage")  # the Y-axis label

    # start with the base plot...
    plot(x = DateTime                   # the continuous stream of date data to plot
         , y = Sub_metering_1           # the continuous stream of meter data to plot
         , type="l"                     # line plot
         , xlab=""                      # let the plot engine auto-derive the X label
         , ylab="Energy Sub-Metering")  # the Y-axis label
    
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

    plot(x = DateTime                     # the continuous stream of date data to plot
         , y = Global_reactive_power      # the continuous stream of meter data to plot
         , type="l"                       # line plot
         , xlab=""                        # let the plot engine auto-derive the X label
         , ylab="Global_reactive_power")  # the Y-axis label
     
    }
)

# close the PNG device graphics context so that the file is saved
dev.off()
