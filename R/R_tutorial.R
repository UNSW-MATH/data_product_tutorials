# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# 
# % R_tutorial.R
# 
# % Tutorial created 27/07/2021 by Michael Hemming, NSW-IMOS Sydney
# % using R version 3.6.1 (2019-07-05), RStudio interface
# 
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# 

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Import packages (These should be available on your system) --------------

library(ncdf4)
library(ggplot2)
library(reshape2)

# If you do not currently have these packages installed, please use 'install.packages("package Name")'.

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Demonstration: Downloading files and citation ---------------------------

# %####################################################################################################
# 
# % The netCDF files are available for download here: http://thredds.aodn.org.au/thredds/catalog/IMOS/catalog.html and 
# % the catalogue record is available here: https://catalogue-rc.aodn.org.au/
#   
# % For more information on the files and methodology, please see Roughan, M., et al. "Multi-decadal ocean temperature time-series and 
# % climatologies from Australia's National Reference Stations." Scientific Data 8.1 (2021): 1-23. (TO UPDATED)
# 
# %####################################################################################################
# 
# %----------%----------
# % Citation:
# %----------%----------
#   
# % Any and all use of the data products and code provided here must include:
#   
# % (a) a citation to the above paper,
# % (b) a reference to the data citation as written in the netCDF file attributes
# % (c) the following acknowledgement statement: Data was sourced from Australia's Integrated Marine Observing System (IMOS) - IMOS is enabled by
# %     the NationalCollaborative Research Infrastructure Strategy (NCRIS).
# 
# %####################################################################################################

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Demonstration: loading the netCDF files ---------------------------------

# define file path
file_path <- 'C:\\Users\\mphem\\Documents\\Work\\UNSW\\climatology\\Revamped_scripts\\Climatology\\Scripts\\Provided_scripts_paper\\data_product_tutorials\\Example_files\\';
file_agg <- paste(file_path,'PH100_TEMP_1953-2020_aggregated_v1.nc', sep="");
file_grid <- paste(file_path,'PH100_TEMP_1953-2020_gridded_v1.nc', sep="");
file_clim <- paste(file_path,'PH100_TEMP_1953-2020_BottleCTDMooringSatellite_climatology_v1.nc', sep="");

data_agg <- nc_open(file_agg)
data_grid <- nc_open(file_grid)
data_clim <- nc_open(file_clim)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Demonstration: scatter aggregated data over time and depth, -------------
# colored by platform type

# get required data
TIME <- ncvar_get(data_agg, "TIME") # IMOS time (days since 1950-01-01)
TIME_R <- as.POSIXct((TIME - 7305)*86400, origin = "1970-01-01", tz = "UTC"); # conversion to R time format
DEPTH <- ncvar_get(data_agg, "DEPTH_AGG")
TEMP <- ncvar_get(data_agg, "TEMP_AGG")
PLAT <- ncvar_get(data_agg, "TEMP_DATA_PLATFORM_AGG")

# Create figure
df <- data.frame(TIME_R,DEPTH,TEMP)
ggplot(df,aes(x = TIME_R,y = DEPTH, color = as.character(PLAT))) +
  geom_point() + scale_y_reverse() + labs(title = "Demonstration: Port Hacking Aggregated Data") +
  xlab('Year') + ylab('Depth [m]')  

# Please note: This script was written in RStudio - plots show up in a window.
# If this is not the case for you, you can use the following code to save
# the figure: ggsave('filename.png',plot = last_plot())

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Demonstration: Compare gridded temperature data at the surface, ---------
# 20 m, 50 m, 75 m and 90 m over the last 10 years

# create data frame
TEMP <- ncvar_get(data_grid, "TEMP_GRID")
TIME <- ncvar_get(data_grid, "TIME_GRID") # IMOS time (days since 1950-01-01)
TIME_R <- as.POSIXct((TIME - 7305)*86400, origin = "1970-01-01", tz = "UTC"); # conversion to R time format
DEPTH <- ncvar_get(data_grid, "DEPTH_GRID")
# selecting data at certain depths and after 2010-01-01
tt <- c(TIME_R[DEPTH == 0 & as.Date(TIME_R) > as.Date('2010-01-01')],
        TIME_R[DEPTH == 20 & as.Date(TIME_R) > as.Date('2010-01-01')],
        TIME_R[DEPTH == 50 & as.Date(TIME_R) > as.Date('2010-01-01')],
        TIME_R[DEPTH == 75 & as.Date(TIME_R) > as.Date('2010-01-01')],
        TIME_R[DEPTH == 90 & as.Date(TIME_R) > as.Date('2010-01-01')])
DD <- c(DEPTH[DEPTH == 0 & as.Date(TIME_R) > as.Date('2010-01-01')],
        DEPTH[DEPTH == 20 & as.Date(TIME_R) > as.Date('2010-01-01')],
        DEPTH[DEPTH == 50 & as.Date(TIME_R) > as.Date('2010-01-01')],
        DEPTH[DEPTH == 75 & as.Date(TIME_R) > as.Date('2010-01-01')],
        DEPTH[DEPTH == 90 & as.Date(TIME_R) > as.Date('2010-01-01')])
TT <- c(TEMP[DEPTH == 0 & as.Date(TIME_R) > as.Date('2010-01-01')],
        TEMP[DEPTH == 20 & as.Date(TIME_R) > as.Date('2010-01-01')],
        TEMP[DEPTH == 50 & as.Date(TIME_R) > as.Date('2010-01-01')],
        TEMP[DEPTH == 75 & as.Date(TIME_R) > as.Date('2010-01-01')],
        TEMP[DEPTH == 90 & as.Date(TIME_R) > as.Date('2010-01-01')])
df <- data.frame(tt,TT,DD)

# Create figure
ggplot(df,aes(x = tt,y = TT, color = as.character(DD))) +
  geom_point() + labs(title = "Demonstration: Port Hacking Gridded Data") +
  xlab('Year') + ylab('Temperature [\u00B0C]') + scale_color_discrete(name = "Depth [m]") + 
  scale_color_jcolors(palette = "pal2")


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Demonstration: plot mean climatologies over depth -----------------------

# get data
TEMP <- ncvar_get(data_clim, "TEMP_AVE")
TIME <- ncvar_get(data_clim, "TIME")
# create data frame
df <- data.frame(TIME,TEMP)
colnames(df) <- c("YearDay", "2m", "10m", "20m", "30m", "40m", "50m", "60m", "75m","99m")
# convert from 'wide' to 'long' for plotting
df <- melt(df, id.vars=c("YearDay"))

# Create figure
ggplot(df,aes(x=YearDay, y = value, color = variable)) +
  geom_point() + labs(title = "Demonstration: Port Hacking Mean climatology") +
  xlab('Year Day') + ylab('Temperature [\u00B0C]') + scale_color_discrete(name = "Depth") 


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Demonstration: export data as CSV files ---------------------------------

# create data frame
clim <- data.frame(TIME, ncvar_get(data_clim, "TEMP_AVE"), ncvar_get(data_clim, "TEMP_PER10"), ncvar_get(data_clim, "TEMP_PER90"))
colnames(clim) <- c("YearDay", "AVE 2m", "AVE 10m", "AVE 20m", "AVE 30m", "AVE 40m", "AVE 50m", "AVE 60m", "AVE 75m","AVE 99m",
                  "PER10 2m", "PER10 10m", "PER10 20m", "PER10 30m", "PER10 40m", "PER10 50m", "PER10 60m", "PER10 75m","PER10 99m",
                  "PER90 2m", "PER90 10m", "PER90 20m", "PER90 30m", "PER90 40m", "PER90 50m", "PER90 60m", "PER90 75m","PER90 99m")

# Export data as .csv
write.csv(clim, 
"C:\\Users\\mphem\\Documents\\Work\\UNSW\\climatology\\Revamped_scripts\\Climatology\\Scripts\\Provided_scripts_paper\\data_product_tutorials\\R\\climatology.csv") 

