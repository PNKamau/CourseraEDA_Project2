#Load libraries
library(dplyr)
library(ggplot2)
library(tidyr)

# Get data
# Ensure the file is located in a subdirectory "data" in the working directory
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

#Create a dataframe of the classification list for coal combustion-related sources
SCC_Coal_Comb <- SCC %>% 
  filter(grepl("Coal", EI.Sector, ignore.case = T)) %>% 
  filter(grepl("Comb", EI.Sector, ignore.case = T))

#Merge SCC_Coal_Comb with NEI
NEI_Coal_Comb <- merge(NEI, SCC_Coal_Comb)

#Create a dataframe of the totals for each year for coal combustion related sources
E_Coal_Comb_Total <- NEI_Coal_Comb %>% 
  group_by(year) %>% 
  summarise(Emissions_total = sum(Emissions)) %>%
  mutate(Emissions_Thousands = Emissions_total / 1000)

#Generate a plot of the annual Emissions totals for coal combustion related sources

#Create a file device for plotting
png(file = "plot4.png")

#Plot the line chart
qplot(year,
      Emissions_Thousands,
      data = E_Coal_Comb_Total,
      geom = "line",
      main = "Annual PM25 Emissions for Coal Combustion related Sources",
      xlab = "Year",
      ylab = "Total Emissions ('000 tons)")

#Close the device
dev.off()