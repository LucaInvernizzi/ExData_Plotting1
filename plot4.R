### NB: THIS IS A BIG FILE -----------------------------------
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
              destfile = "data/1st_project_electric_power_consumption.zip",
              method = "curl")
# variables explanation
# https://www.coursera.org/learn/exploratory-data-analysis/peer/ylVFo/course-project-1

# unzip the data in the folder

# load the data
pw_con <- read.csv("data/1st_project_electric_power_consumption/household_power_consumption.txt",
                   sep = ";")

### paste Darte and Time into 1 coloumn and change it to class POSIXct
# assign to test dataframe to keep pw_con as reference
test_pw_con <- pw_con
# paste with apply. use strprtime
test_pw_con$DateTime <- apply(test_pw_con[, c("Date", "Time")], 1, paste, collapse = " ")
test_pw_con$DateTime <- as.POSIXct(test_pw_con$DateTime, format = "%d/%m/%Y %H:%M:%S")
test_pw_con[, c("Date", "Time")] <- NULL # remove useless col
class(test_pw_con$DateTime)
# reorder coloumns
test_reord <- test_pw_con[, c(8, 1:7)]

# now subset for date (a bit iffy... it creates a lot of empty ROW, I dropped them with complete cases)
test_date <- test_reord[test_reord$DateTime >= "2007-02-01" & test_reord$DateTime < "2007-02-03",]
test_date2 <- test_date[test_date$DateTime < "2007-02-03",]
test_date3 <- test_date[complete.cases(test_date),]

# assign the modified dataframe to a work df
work_pw <- test_date3

# the coloumns are characters
lapply(work_pw, class)
test_numeric <- work_pw
# change to numeric, doing them together gives problem with lists
test_numeric[, 2] <- as.numeric(test_numeric[, 2])
test_numeric[, 3] <- as.numeric(test_numeric[, 3])
test_numeric[, 4] <- as.numeric(test_numeric[, 4])
test_numeric[, 5] <- as.numeric(test_numeric[, 5])
test_numeric[, 6] <- as.numeric(test_numeric[, 6])
test_numeric[, 7] <- as.numeric(test_numeric[, 7])
test_numeric[, 8] <- as.numeric(test_numeric[, 8])

lapply(test_numeric, class)
# this could have been done more cleanly with an apply function, but it's good enough

# return to working dataframe
work_pw <- test_numeric

# plot 4
par(mfrow = c(2, 2))

plot(work_pw$DateTime, work_pw$Global_active_power, 
     type = "l", 
     ylab = "Global Active Power (kilowatts)",
     xlab = "")

plot(work_pw$DateTime, work_pw$Voltage, 
     type = "l", 
     ylab = "Voltage",
     xlab = "datetime")

plot(work_pw$DateTime, work_pw$Sub_metering_1, 
     type = "l", 
     ylab = "Energy sub metering",
     xlab = "")
lines(work_pw$DateTime, work_pw$Sub_metering_2, type = "l", col = "red")
lines(work_pw$DateTime, work_pw$Sub_metering_3, type = "l", col = "blue")
legend("topright",legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lty = 1, bty = "n")

plot(work_pw$DateTime, work_pw$Global_reactive_power, 
     type = "l", 
     ylab = "Global Reactive Power",
     xlab = "datetime")

dev.copy(png, file = "plot4.png", width = 480, height = 480)
dev.off()
