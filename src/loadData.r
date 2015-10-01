
#Working directory
trainingFile <- "/Users/shashankm/Documents/KaggleCompetition/SpringleafMarketingResponse/train.csv"

#Load the csv data
data <- read.csv(trainingFile)

#Write a function to make the data clean. Clean all NA columns. Make all the categorical columns as integers or boolean
#as per the number of categories available.
numRows <- as.matrix(dim(data))[1,1]
numColumns <- as.matrix(dim(data))[2,1]
colsNum <- numColumns

#Remove constant columns
col_ct = sapply(data, function(x) length(unique(x)))
data = data[, !names(data) %in% names(col_ct[col_ct==1])]

data_numr = data[, sapply(data, is.numeric)]
data_char = data[, sapply(data, is.character)]

data_char[data_char==-1] = NA
data_char[data_char==""] = NA
data_char[data_char=="[]"] = NA

data_date = data_char[,grep("JAN1|FEB1|MAR1", data_char),]
data_char = data_char[, !colnames(data_char) %in% colnames(data_date)]
data_date = sapply(data_date, function(x) strptime(x, "%d%B%y:%H:%M:%S"))
data_date = do.call(cbind.data.frame, data_date)

data_time = data_date[,colnames(data_date) %in% c("VAR_0204","VAR_0217")]
data_time = data.frame(sapply(train_time, function(x) strftime(x, "%H:%M:%S")))
data_hour = as.data.frame(sapply(data_time, function(x) as.numeric(as.character(substr( x ,1, 2)))))

##Loop over all the columns in the data matrix
#for(i in 2:numColumns){
#    #Clean the data in the column. Find if NA's are present. Change categorical data to binary vectors with elements
#    #equal to the number of categories
#
#    numDims <- dim(table(levels(factor(data[,i]))))
#    dimNames <- dimnames(table(levels(factor(data[,i]))))[[1]]
#    if(numDims <= 10){ # Why 10. No Actual reason for 10??
#        for(k in 1:numDims){
#            dimName <- dimnames(table(levels(factor(data[,i]))))[[1]][k]
#            newDimName <- paste(dimName,'in',i,sep = "_")
#            #This makes the categorical column into column vectors of different categories
#
#            colsNum <- colsNum + 1
#            data[,colsNum] <- as.numeric(data[,i] == dimName)
#
#            colnames(data)[colsNum] <- paste(newDimName)
#            #Add the column vectors to the data
#        }
#        #Remove the actual categorical column from the data
#        data <- data[,-i]
#    }
#}