## Create Plot3.png

if (!file.exists("data")) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    dir.create("data")
    download.file(fileUrl, destfile="./data/electric_power_consumption.zip", 
                  method = "curl")
    unzip("./data/electric_power_consumption.zip")
}

print("Reading data from file...")
dat <- read.table("household_power_consumption.txt", header = TRUE, 
                  sep = ";", na.strings = "?")

print("Converting date and time strings dateTime...")
dateTimeString <- paste(dat$Date, dat$Time)
dat$dateTime <- strptime(dateTimeString, "%d/%m/%Y %H:%M:%S")

print("Subseting data to 2007-02-01 : 2007-02-02...")
datSubset <- subset(dat, 
                    dateTime >= as.POSIXct("2007-02-01 00:00:00") & 
                        dateTime <= as.POSIXct("2007-02-02 23:59:00"), 
                    select=c(Global_active_power,
                             Global_reactive_power, 
                             Voltage,
                             Global_intensity, 
                             Sub_metering_1, 
                             Sub_metering_2, 
                             Sub_metering_3, 
                             dateTime))

print("Generating the plot...")
png(file = "plot3.png")
plot(datSubset$dateTime,
     datSubset$Sub_metering_1,
     type="l", ylab="Energy sub metering", xlab="")
lines(datSubset$dateTime, datSubset$Sub_metering_2, type="l", col="red")
lines(datSubset$dateTime, datSubset$Sub_metering_3, type="l", col="blue")
legend("topright", lty=c(1,1), col=c("black", "red", "blue"),
       legend=c("Sub_metering_1", "Sub_metering_2",
                "Sub_metering_3"))
dev.off()