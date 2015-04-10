## Exploratory Data Analysis, Programming Assignment1, louise.mateos@sbcglobal.net

## plot4.R

## Purpose
## This script reproduces "Plot 4" shown in the ExData_Plotting1 github repository (forked
## here: https://github.com/lmmateos/ExData_Plotting1). 


## This script plots data from the UC Irvine Machine Learning Repository 
## (http://archive.ics.uci.edu/ml/), a repository for machine learning datasets. 
## In particular, it uses the "Individual household electric power consumption Data Set" 
## which was have made available on the course web site:

## Dataset: Electric power consumption [20Mb] 
## (https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip)

## Description: Measurements of electric power consumption in one household with a 
## one-minute sampling rate over a period of almost 4 years. Different electrical 
## quantities and some sub-metering values are available. 

## download zipped data from internet link provided in assignment (and listed above) and 
## unzip

if (!file.exists("ElectricPowerConsumption.zip")) {
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileUrl, 
                      destfile = "ElectricPowerConsumption.zip", 
                      method = "curl")
        dateDownloaded <- date()
        write.csv(dateDownloaded, "download_date.txt")
        unzip("ElectricPowerConsumption.zip", exdir = ".")
} else {
        dateDownloaded <- read.csv("download_date.txt", stringsAsFactors = FALSE)[[2]]
}

## read data for 2/1/2007 through 2/2/2007 from resulting text file

mydata <- read.table("household_power_consumption.txt",
                     sep = ";",
                     na.strings = "?",
                     nrows = 2880,
                     skip = 66637,
                     stringsAsFactors = FALSE)

## read variable names and use to set column names for mydata

variable_names <- read.table("household_power_consumption.txt",
                             header = TRUE,
                             sep = ";",
                             nrows = 1)

colnames(mydata) <- colnames(variable_names)

## convert Date and Time variables into a single DateTime variable for plotting across days

mydata$DateTime <- paste(mydata$Date, mydata$Time, sep = " ")
mydata$DateTime <- strptime(mydata$DateTime,"%d/%m/%Y %H:%M:%S",tz="GMT")

## set up png graphics device (file)

png(filename = "plot4.png",
    width = 480,
    height = 480)

## create four xy plots for Plot 4

par(mfrow = c(2,2))

plot(mydata$DateTime, mydata$Global_active_power,
     type = "l", xlab = "", ylab = "Global Active Power")
plot(mydata$DateTime, mydata$Voltage,
     type = "l", xlab = "datetime", ylab = "Voltage")
plot(mydata$DateTime, mydata$Sub_metering_1,
     type = "l", xlab = "", ylab = "Energy sub metering")
lines(mydata$DateTime, mydata$Sub_metering_2, col = "red")
lines(mydata$DateTime, mydata$Sub_metering_3, col = "blue")
legend("topright",
       legend = colnames(mydata[c(7:9)]),
       lty = c(1,1,1),
       col = c("black","red","blue"),
       box.lwd = 0)
box()
plot(mydata$DateTime, mydata$Global_reactive_power,
     type = "l", xlab = "datetime", ylab = "Global_reactive_power")

## close file

dev.off()
