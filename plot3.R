#Load libraries
library(dplyr)
library(ggplot2)
library(tidyr)

# Get data
# Ensure the file is located in a subdirectory "data" in the working directory
NEI <- readRDS("data/summarySCC_PM25.rds")

#Create a dataframe of the totals for each year for Baltimore City
E_BaltimoreCity <- NEI %>% 
  filter(NEI$fips == "24510") %>%
  mutate(type_year = paste(type, year, sep = "_")) %>%
  group_by(type_year) %>% 
  summarise(Emissions_total = sum(Emissions)) %>%
  separate(type_year, c("type", "year"), sep = "_")

E_BaltimoreCity$year <- as.numeric(E_BaltimoreCity$year)

#Generate a plot of the annual Emissions totals

#Create a file device for plotting
png(file = "plot3.png")

#Plot the line chart
with(E_BaltimoreCity, 
     qplot(year, 
          Emissions_total, 
          data = E_BaltimoreCity,
          geom = "line",
          facets = .~type,
          main = "Annual PM25 Emissions in Baltimore City by Source Type",
          xlab = "Year",
          ylab = "Total Emissions (tons)"))

#Close the device
dev.off()