# Load required packages.
#install.packages("sqldf")

library(utils)
library(data.table)
library(sqldf) 

# Get file from file location
url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Set working directory to Assignment 1 folder
if (!file.exists("Assignment 1")) {
  dir.create("Assignment 1")
}
setwd("./Assignment 1")

# unzip file
if (!file.exists("household_power_consumption.txt")) {
  download.file(url, destfile="./exdata_data_household_power_consumption.zip")
  file<-unzip(zipfile="./exdata_data_household_power_consumption.zip") 
}

# define wp as a file with indicated format 
wp <- file("household_power_consumption.txt") 
attr(wp, "file.format") <- list(sep = ";", header = TRUE) 

# use sqldf to read it in keeping only rows between '1/2/2007' and '2/2/2007'
PowerConsumption <- sqldf("select * from wp where Date = '1/2/2007' or Date = '2/2/2007' ") 

hist(PowerConsumption$Global_active_power, col="red",
     xlab="Global Active Power (kilowatts)", ylab="Frequency",
     main="Global Active Power")

# Save the plot to a .png file and restore previous working directory.
# the default size for a .png is 480 x 480 pixels
dev.copy(png, file="plot1.png")
dev.off()

setwd("..") # go back to original working directory
