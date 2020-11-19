#Load libraries
library(dplyr)

# Get data
# Ensure the file is located in a subdirectory "data" in the working directory
NEI <- readRDS("data/summarySCC_PM25.rds")

#Create a dataframe of the totals for each year for Baltimore City
E_Total_BaltimoreCity <- NEI %>% 
  filter(NEI$fips == "24510") %>%
  group_by(year) %>% 
  summarise(Emissions_total = sum(Emissions))

#Generate a plot of the annual Emissions totals

#Create a file device for plotting
png(file = "plot2.png")

#Plot the line chart
with(E_Total_BaltimoreCity, 
     plot(year, 
          Emissions_total, 
          type = "l", 
          main = "Annual PM25 Emissions in Baltimore City",
          xlab = "Year",
          ylab = "Total Emissions (tons)"))

#Close the device
dev.off()