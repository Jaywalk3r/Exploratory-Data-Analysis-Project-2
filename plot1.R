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




# 1

# Have total emissions from PM2.5 decreased in the United States from 1999 to
#	2008?

nei.year = NEI

#nei.year$year = factor( nei.year$year)

nei.year = group_by( nei.year, year)

nei.year.sum = summarize( nei.year, sum( Emissions))


# Using the base plotting system, make a plot showing the total PM2.5 emission
#	from all sources for each of the years 1999, 2002, 2005, and 2008.

png( "plot1.png")

plot( nei.year.sum, type = "o", xaxt = "n", xlab = "", ylab = "", pch = 20)
	# xaxt = "n" indicates no x-axis ticks/values

axis( 1, at = nei.year.sum$year)
	# adds desired x-axis ticks

title( "Total U.S.A. Emissions", xlab = "Year", ylab = "Amount of PM2.5 emitted (in tons)")
	# add title and axis labels

dev.off() 