#Load libraries
library(dplyr)

# Get data
# Ensure the file is located in a subdirectory "data" in the working directory
NEI <- readRDS("data/summarySCC_PM25.rds")

#Create a dataframe of the totals for each year
E_Total <- NEI %>% 
  group_by(year) %>% 
  summarise(Emissions_total = sum(Emissions)) %>%
  mutate(Emissions_Millions = Emissions_total / 1000000)

#Generate a plot of the annual Emissions totals

#Create a file device for plotting
png(file = "plot1.png")

#Plot the line chart
with(E_Total, 
     plot(year, 
          Emissions_Millions, 
          type = "l", 
          main = "Annual PM25 Emissions in USA",
          xlab = "Year",
          ylab = "Total Emissions (Millions of tons)"))

#Close the device
dev.off()