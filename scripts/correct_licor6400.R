# Thermal gradients drive errors in gas exchange measurements
# Garen et al. 2021
# AGU 2021
# correct_licor6400.R
#
# This script provides functions for correcting leaf and air temperatures and
# derived "downstream" quantities, such as g_sw and C_i, in the LI-COR LI-6400 
# and LI-6400XT portable photosynthesis systems.
#
# The specific parameter values used in the correction functions shown below 
# (i.e. slope and intercept) are likely to vary in a manner that is specific 
# to an individual instrument and set of environmental conditions. We urge
# potential users of this code to independently measure leaf and air temperatures
# in their LI-COR instruments and environmental conditions to parameterize these
# correction functions prior to use.
#
# For more details see associated forthcoming article, Garen et al., New
# Phytologist (in press).


# Function to correct Tleaf based on the difference between Tair and Tleaf
correct_Tleaf6400 = function(Tleaf, Tair, slope = 0.7838, intercept = 0.8092) {
  return(Tleaf - (slope*(Tair-Tleaf)+intercept))
}

# Function to correct Tair based on the difference between Tblock and Tair
correct_Tair6400 = function(Tblock, Tair, slope = 1.7790, intercept = -0.2557) {
  return(Tair - (slope*(Tblock-Tair)+intercept))
}

# Function to correct Tleaf, Tair, and derived quantities in raw LI-6400XT data
correct_licor6400 = function(licor_uncorrected) {
  
  # Correct air and leaf temperatures
  licor_uncorrected %>% 
    
    # Preserve uncorrected values
    mutate(
      CTleaf_uncorrected = CTleaf,
      Tleaf_uncorrected = Tleaf,
      Tair_uncorrected = Tair,
      #total.leaf.area = Area
    ) %>% 
    
    # Correct air and leaf temperatures 
    mutate(
      CTleaf = correct_Tleaf6400(CTleaf_uncorrected, Tair_uncorrected),
      Tleaf = correct_Tleaf6400(Tleaf_uncorrected, Tair_uncorrected),
      Tair = correct_Tair6400(TBlk, Tair_uncorrected)
    ) %>% 
    
    # Correct other quantities based on revised leaf and air temperatures
    calc_licor()
  
}

