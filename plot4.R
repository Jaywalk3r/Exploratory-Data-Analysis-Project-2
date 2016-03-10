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



# 4

# Across the United States, how have emissions from coal combustion-related
#	sources changed from 1999–2008?

scc.coal.index = grep( "[Cc][Oo][Aa][Ll]", SCC$EI.Sector)
	# identify row indices of SSC identifiers associated with coal

scc.coal = SCC$SCC[ scc.coal.index]
	# create character vector of SCC identifiers associated with coal

nei.coal = NEI[ NEI$SCC %in% scc.coal,]
	# subset NEI data frame, including coal related activities

nei.coal = group_by( nei.coal, year)

nei.coal.sum = summarize( nei.coal, Emissions.Total = sum( Emissions))


png( "plot4.png")

plot( nei.coal.sum, type = "o", xaxt = "n", xlab = "", ylab = "", pch = 20)
	# xaxt = "n" indicates no x-axis ticks/values

axis( 1, at = nei.coal.sum$year)
	# adds desired x-axis ticks

title( "Total U.S.A. Coal Related Emissions", xlab = "Year", ylab = "Amount of PM2.5 emitted (in tons)")
	# add title and axis labels

dev.off() 
