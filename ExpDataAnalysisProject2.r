setwd( "~/Documents/School/Coursera/Data Science Specialization/Exploratory Data Analysis/Course Projects/Project 2")

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











