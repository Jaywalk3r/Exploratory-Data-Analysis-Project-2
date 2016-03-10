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





# 5

# How have emissions from motor vehicle sources changed from 1999–2008 in
#	Baltimore City?


nei.bal = NEI[ NEI$fips == "24510",]
	# Baltimore subset

nei.bal.mv = nei.bal[ nei.bal$type == "ON-ROAD",]
	# Interpreting motor vehicle to mean on-road
	# An alternate interpretation might include aircraft, trains, ships

nei.bal.mv = group_by( nei.bal.mv, year)

nei.bal.mv.sum = summarize( nei.bal.mv, Emissions.Total = sum( Emissions))

png( "plot5.png")

plot( nei.bal.mv.sum, type = "o", xaxt = "n", xlab = "", ylab = "", pch = 20)
	# xaxt = "n" indicates no x-axis ticks/values

axis( 1, at = nei.bal.mv.sum$year)
	# adds desired x-axis ticks

title( "Baltimore Motor Vehicle Emissions (on road)", xlab = "Year", ylab = "Amount of PM2.5 emitted (in tons)")
	# add title and axis labels

dev.off()