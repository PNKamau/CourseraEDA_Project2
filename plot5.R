#Load libraries
library(dplyr)
library(ggplot2)
library(tidyr)

# Get data
# Ensure the file is located in a subdirectory "data" in the working directory
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

#Create a dataframe of the classification list for motor vehicle sources
SCC_mv <- SCC %>%
  filter(grepl("Light Duty Vehicles", EI.Sector, ignore.case = T))

#Merge SCC_mv with NEI
NEI_mv <- merge(NEI, SCC_mv)

#Create a dataframe of the totals for each year for motor vehicle sources
#in Baltimore city
E_mv_BaltimoreCity <- NEI_mv %>% 
  filter(fips == "24510") %>%
  group_by(year) %>% 
  summarise(Emissions_total = sum(Emissions))

#Generate a plot of the annual Emissions totals for coal combustion related sources

#Create a file device for plotting
png(file = "plot5.png")

#Plot the line chart
qplot(year,
      Emissions_total,
      data = E_mv_BaltimoreCity,
      geom = "line",
      main = "Annual PM25 Emissions from Motor Vehicles in Baltimore City",
      xlab = "Year",
      ylab = "Total Emissions (tons)")

#Close the device
dev.off()