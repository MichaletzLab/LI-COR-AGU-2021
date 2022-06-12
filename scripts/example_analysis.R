# Thermal gradients drive errors in gas exchange measurements
# Garen et al. 2021
# AGU 2021
# example_analysis.R
#
# This file illustrates the use of the correct_licor6400 function defined
# in the associated file correct_licor6400.R.
#
# The parameter values used in the correction functions defined in the associated
# file correct_lifor6400.R are likely to vary in a manner that is specific 
# to an individual instrument and set of environmental conditions. We urge
# potential users of this code to independently measure leaf and air temperatures
# in their LI-COR instruments and environmental conditions to parameterize these
# correction functions prior to use.
#
# For more details see associated forthcoming article, Garen et al., New
# Phytologist (in press).


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
