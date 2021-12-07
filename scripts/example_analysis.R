# Thermal gradients drive errors in gas exchange measurements
# Garen et al. 2021
# AGU 2021
# example_analysis.R

# Install LICOR6400 package for helper functions if necessary
if(!require(LICOR6400)){
  devtools::install_github("Plant-Functional-Trait-Course/LICOR6400")
  library(LICOR6400)
}

# Load tidyverse
library(tidyverse)

# Load script with functions for correcting LI-6400 files
source("correct_licor6400.R")

# Read in raw LI-6400XT file
licor_uncorrected = read_licor6400("data_example")

# Average measurements taken at each temperature level
licor_averaged = licor_uncorrected %>% group_by(level) %>% summarize_all(mean)

# Set total.leaf.area. If leaf area < 6 cm^2, leaf area may be entered here
licor_averaged$total.leaf.area = licor_averaged$Area

# Correct temperature errors and derived quantities with script
licor_corrected = correct_licor6400(licor_averaged)

# Remove unneeded variables
rm("licor_uncorrected", "licor_averaged")

# Perform analyses of interest with corrected data
plot(licor_corrected$Tleaf, licor_corrected$Photo)




