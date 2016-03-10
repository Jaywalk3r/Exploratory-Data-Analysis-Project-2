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


# 3

# Of the four types of sources indicated by the 𝚝𝚢𝚙𝚎 (point, nonpoint,
#	onroad, nonroad) variable, which of these four sources have seen decreases
#	in emissions from 1999–2008 for Baltimore City? Which have seen increases in
#	emissions from 1999–2008?

nei.bal.type.year = NEI[ NEI$fips == "24510",]

nei.bal.type.year$type = as.factor( nei.bal.type.year$type)

nei.bal.type.year = group_by( nei.bal.type.year, type, year)

nei.bal.type.year.sum = summarize( nei.bal.type.year, Total.Emissions = sum( Emissions))

nei.bal.type.year.sum


#  Use the ggplot2 plotting system to make a plot answer this question.

png( "plot3.png")

g = ggplot( data = nei.bal.type.year.sum, aes(x = year, y = Total.Emissions, group = type, colour = type))

g = g + geom_line()

g = g + geom_point()

g = g + scale_x_continuous( name = "Year", breaks = unique( NEI$year), minor_breaks = c( 2000, 2001, 2003, 2004, 2006, 2007))
	# Changes X axis label and tick mark locations

g = g + scale_y_continuous( name = "Total Emissions (in tons)")

g = g + ggtitle( "Change in total Baltimore emissions, by type")

print( g)

dev.off()