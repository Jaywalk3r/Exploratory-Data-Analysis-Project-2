library( dplyr)
library( ggplot2)




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




# 6

# Compare emissions from motor vehicle sources in Baltimore City with emissions
#	from motor vehicle sources in Los Angeles County, California
#	(fips == "06037"). Which city has seen greater changes over time in
#	motor vehicle emissions?


nei.bal.la = NEI[ NEI$fips %in% c( "24510", "06037"),]

nei.bal.la.mv = nei.bal.la[ nei.bal.la$type == "ON-ROAD",]

nei.bal.la.mv$location = "city"

nei.bal.la.mv$location[ nei.bal.la.mv$fips == "24510"] = "Baltimore"

nei.bal.la.mv$location[ nei.bal.la.mv$fips == "06037"] = "Los Angeles"

nei.bal.la.mv = group_by( nei.bal.la.mv, location, year)

nei.bal.la.mv.sum = summarize( nei.bal.la.mv, Emissions.Total = sum( Emissions))




png( "plot6.png")

g = ggplot( data = nei.bal.la.mv.sum, aes(x = year, y = Emissions.Total, group = location, colour = location))

g = g + geom_line()

g = g + geom_point()

g = g + scale_x_continuous( name = "Year", breaks = unique( NEI$year), minor_breaks = c( 2000, 2001, 2003, 2004, 2006, 2007))
	# Changes X axis label and tick mark locations

g = g + scale_y_continuous( name = "Total Emissions (in tons)")

g = g + ggtitle( "Change in total on road motor vehicle emissions\nin Los Angeles County and Baltimore, MD")

print( g)

dev.off()

