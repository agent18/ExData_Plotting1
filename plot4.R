## Memory the data set requires

memory  <-  2075259*9*8/10^6
cat(memory,"mb   \n\n")

## Reading data from 2007-02-01 and 2007-02-02 and saving in a file
library(reader)

file.name <- "../household_power_consumption.txt"
nrows=100
for (val in 1:(2075259/nrows)){
    a <- n.readLines(file.name,n=nrows,skip=(val-1)*nrows)
    
    if (length(grep("^(.*)1/(.*)2/2007",a))!=0){
        break
    }
    }

lin.num <- grep("^(.*)1/(.*)2/2007",a)[[1]]+(val-1)*nrows

csv.data <- n.readLines(file.name,n=60*24*2+1,skip=lin.num-1)


write(csv.data, file="./two-day-data.txt")

## Read the two-day-data into a table and change the header appropriately
df0<- read.csv(file=file.name,nrow=3,header=TRUE,sep=";")

df <- read.csv(file="./two-day-data.txt",header=FALSE,sep=";")

colnames(df)=colnames(df0)

df.copy=df #backup

## Cleaning the data (remove NA or ? if required)
table(is.na(df))# returns False, so no further action required
table(df=="?")# returns False, so no further action required

## Combining date and time and adding it as a new column
df$Date <- as.character(df$Date)
df$Time <- as.character(df$Time)

df$DateTime <- as.POSIXct(paste(df$Date, df$Time),
                          format="%d/%m/%Y %H:%M:%S")

## Another method to add date and time
## library(lubridate)
## df$Date.Time <- dmy_hms(paste(df$Date, df$Time))

## plot $4
png(filename="plot4.png",width=480, height=480)
par(mfrow=c(2,2))
plot(df$DateTime,df$Global_active_power,type='l',
     ylab="Global Active Power",xlab="")
plot(df$DateTime,df$Voltage,type='l',
     ylab="Voltage",xlab="datetime")
plot(df$DateTime, df$Sub_metering_1, type="l", col="black", ylab="Energy sub metering",xlab="")
lines(df$DateTime, df$Sub_metering_2, type="l", col="red")
lines(df$DateTime, df$Sub_metering_3, type="l", col="blue")
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red","blue"),lty=1:3, cex=0.8)
plot(df$DateTime,df$Global_reactive_power,type='l',
     ylab="Global_reactive_power",xlab="datetime")
dev.off()
