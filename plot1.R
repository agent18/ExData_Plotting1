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

## Plot $1
png(filename="plot1.png", width=480, height=480)
hist(df$Global_active_power,col="red",main="Global Active Power",
     xlab="Global Active Power (kilowatts)")
dev.off()



