# Load required packages.
require ("sqldf")

library(utils)
library(data.table)
library(sqldf) 

# Get file from file location
url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Set working directory to Assignment 1-4 folder
if (!file.exists("Assignment 1-4")) {
  dir.create("Assignment 1-4")
}
setwd("./Assignment 1-4")

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

# Generate datetime adn convert it to date 
PowerConsumption$DateTime <- as.POSIXlt( paste(PowerConsumption$Date, PowerConsumption$Time), format="%d/%m/%Y %H:%M")

# Create numeric
PowerConsumption$globalActivePower <- as.numeric(PowerConsumption$globalActivePower)
PowerConsumption$Voltage <- as.numeric(PowerConsumption$Voltage)
PowerConsumption$Global_reactive_power <- as.numeric(PowerConsumption$Global_reactive_power)

# set four plots
par(mfrow = c(2,2))
# Set a smaller font size
par(cex=.75)  

#  ******

# Plot 1: Global Active Power by Dat

# create the plot structure
plot(PowerConsumption$DateTime, PowerConsumption$Global_active_power, type="l", 
     ylab = "Global Active Power", xlab ="")


# Plot 2 : Voltage by Day
plot(PowerConsumption$DateTime, PowerConsumption$Voltage, type="l", 
     ylab = "Voltage", xlab ="datetime")

# Make plot 3 - SubMetering
plot (PowerConsumption$DateTime, PowerConsumption$Sub_metering_1, type="l", 
      xlab= "", ylab="Energy Sub Metering")

# add lines for the remaining submeters
lines(PowerConsumption$DateTime, PowerConsumption$Sub_metering_2, col = "red") 
lines(PowerConsumption$DateTime, PowerConsumption$Sub_metering_3, col = "blue") 

# add legend
legend("topright", pch="_", col = c("black", "red", "blue"), 
       legend = c("Sub_metering 1", "Sub_metering 2", "Sub_metering 3"))


# Make plot 4 - Global Reactive Power
plot(PowerConsumption$DateTime, PowerConsumption$Global_reactive_power, type="l", 
     xlab ="datetime", ylab = "Global_reactive_power")


# Save the plot to a .png file 
# the default size for a .png is 480 x 480 pixels
dev.copy(png, file="plot4.png", bg="transparent")
dev.off()
setwd("..") # go back to original working directory