library( dplyr)




# Check to see if data files exist in compressed or uncompressed formats, and
#	downloads and/or uncompresses as necessary.

# First check to see if both uncompressed files exist
if (! identical( c( TRUE, TRUE), file.exists( c( "./exdata-data-NEI_data/Source_Classification_Code.rds", "./exdata-data-NEI_data/summarySCC_PM25.rds")))) {
	
	# If either uncompressed file does not exist, check for compressed file and
	#	download, if it doesn't exist
	if (! file.exists( "exdata-data-NEI_data.zip")) {
		
		fileUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
		
		filePath = "./exdata-data-NEI_data.zip"
		
		download.file( fileUrl, filePath, method = "curl")
		
	}
	
	unzip( "./exdata-data-NEI_data.zip")
		# default overwrite = TRUE argument prevents error if exactly one of the
		#	.rds files already exists

}

NEI = readRDS( "summarySCC_PM25.rds")

SCC = readRDS( "Source_Classification_Code.rds")




# 2

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
#	(fips == "24510") from 1999 to 2008?

nei.bal.year = NEI[ NEI$fips == "24510",]

nei.bal.year = group_by( nei.bal.year, year)

nei.bal.year.sum = summarize( nei.bal.year, sum( Emissions))

nei.bal.year.sum


# Use the base plotting system to make a plot answering this question.

png( "plot2.png")

plot( nei.bal.year.sum, type = "o", xaxt = "n", xlab = "", ylab = "", pch = 20)
	# xaxt = "n" indicates no x-axis ticks/values

axis( 1, at = nei.bal.year.sum$year)
	# adds desired x-axis ticks

title( "Total Baltimore Emissions", xlab = "Year", ylab = "Amount of PM2.5 emitted (in tons)")
	# add title and axis labels

dev.off() 