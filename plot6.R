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
  filter(fips == "24510" | fips == "06037") %>%
  mutate(fips_year = paste(fips, year, sep = "_")) %>%
  group_by(fips_year) %>% 
  summarise(Emissions_total = sum(Emissions)) %>%
  separate(fips_year, c("fips", "year"), sep = "_")

E_mv_BaltimoreCity$year <- as.numeric(E_mv_BaltimoreCity$year)

fips_desc <- data.frame(
  fips = c("24510", "06037"),
  county = c("Baltimore City", "Los Angeles County")
)

E_mv_BaltimoreCity <- merge(E_mv_BaltimoreCity, fips_desc)

#Generate a plot of the annual Emissions totals for coal combustion related sources

#Create a file device for plotting
png(file = "plot6.png")

#Plot the line chart
qplot(year,
      Emissions_total,
      data = E_mv_BaltimoreCity,
      geom = "line",
      facets = .~county,
      main = "PM25 Emissions from Motor Vehicles in Baltimore City and LA County",
      xlab = "Year",
      ylab = "Total Emissions (tons)")

#Close the device
dev.off()