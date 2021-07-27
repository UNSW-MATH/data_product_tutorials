##########################################################################
##########################################################################

# PYTHON_tutorial.py

# Tutorial created 18/06/2021 by Michael Hemming, NSW-IMOS Sydney
# using Python version 3.8.5, Spyder (managed using Anaconda)

##########################################################################
##########################################################################

# %% ------ Import packages (These should be available on your system already)

# load in the netCDF files
import xarray as xr
# for data selection
import numpy as np
# for saving as .csv
import pandas as pd
# for creating plots
import matplotlib.pyplot as plt

# If you do not currently have these packages installed, please use either
# 'conda install <package>' or 'pip install <package>'


# %% --------- Demonstration: Downloading files -----------------------------

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

# %% --------- Demonstration: loading the netCDF files ----------------------

# define file path
data_path = ('C:\\Users\\mphem\\Documents\\Work\\UNSW\\' + 
             'climatology\\Revamped_scripts\\Climatology\\' +
             'Scripts\\Provided_scripts_paper\\data_product' + 
             '_tutorials\\Example_files')
# define filenames 
file_agg = 'PH100_TEMP_1953-2020_aggregated_v1.nc'
file_grid = 'PH100_TEMP_1953-2020_gridded_v1.nc'
file_clim = 'PH100_TEMP_1953-2020_BottleCTDMooringSatellite_climatology_v1.nc'
# load files
data_agg = xr.open_dataset(data_path + '\\' + file_agg) # aggregated file
data_grid = xr.open_dataset(data_path + '\\' + file_grid) # gridded file
data_clim = xr.open_dataset(data_path + '\\' + file_clim) # climatology file

# %% Demonstration: scatter aggregated data over time and depth, colored by platform type

fig = plt.figure()
# bottle
c = data_agg.TEMP_DATA_PLATFORM_AGG == 1
plt.scatter(x=data_agg.TIME[c], y=data_agg.DEPTH_AGG[c],s=1,marker='o')
# CTD
c = data_agg.TEMP_DATA_PLATFORM_AGG == 2
plt.scatter(x=data_agg.TIME[c], y=data_agg.DEPTH_AGG[c],s=1,marker='o')
# Mooring
c = data_agg.TEMP_DATA_PLATFORM_AGG == 3
plt.scatter(x=data_agg.TIME[c], y=data_agg.DEPTH_AGG[c],s=1,marker='o')
# Satellite
c = data_agg.TEMP_DATA_PLATFORM_AGG == 4
plt.scatter(x=data_agg.TIME[c], y=data_agg.DEPTH_AGG[c],s=1,marker='o')
# plot properties and legend
plt.gca().invert_yaxis()
plt.ylabel('Depth [m]')
plt.title('Demonstration: Port Hacking Aggregated Data')
plt.legend(['Bottle','CTD','Mooring','Satellite'],loc='lower left',
           fontsize=8,ncol=2)


# Please note: This script was written in Spyder - plots show up in a window.
# If this is not the case for you, you can use the following code to save
# the figure: plt.savefig(fname,dpi=300)
# If you want to explore the data more closely, use %matplotlib qt. Use
# %matplotlib inline to revert back

# %% Demonstration: Compare gridded temperature data at the surface, 20 m, 50 m, 75 m and 90 m over the last 10 years

ax = plt.plot()
ctime = data_grid.TIME >= np.datetime64('2010-01-01')
plt.scatter(data_grid.TIME[ctime],data_grid.TEMP_GRID[1,ctime],s=2) # surface
plt.scatter(data_grid.TIME[ctime],data_grid.TEMP_GRID[21,ctime],s=2) # 20 m
plt.scatter(data_grid.TIME[ctime],data_grid.TEMP_GRID[51,ctime],s=2) # 50 m
plt.scatter(data_grid.TIME[ctime],data_grid.TEMP_GRID[76,ctime],s=2) # 75 m
plt.scatter(data_grid.TIME[ctime],data_grid.TEMP_GRID[91,ctime],s=2) # 90 m
# plot properties and legend
plt.ylabel('Temperature [deg C]')
plt.title('Demonstration: Port Hacking Gridded Data')
plt.ylim(top=29)
plt.legend(['surf','20 m','50 m','75 m','90 m'],loc='upper left',
           ncol = 5,fontsize=8)

# Please note: This script was written in Spyder - plots show up in a window.
# If this is not the case for you, you can use the following code to save
# the figure: plt.savefig(fname,dpi=300)
# If you want to explore the data more closely, use %matplotlib qt. Use
# %matplotlib inline to revert back

# %% ----- Demonstration: plot mean climatologies over depth -----------------

fig, ax = plt.subplots()
# loop through depths to plot climatology means
for depth in range(0,len(data_clim.TEMP_AVE)):
    depth_lab = str(np.int32(data_clim.DEPTH[depth])) + ' m'
    plt.plot(data_clim.TIME,data_clim.TEMP_AVE[depth,:],label=depth_lab)
# plot properties and legend
plt.ylabel('Temperature [deg C]')
plt.title('Demonstration: Port Hacking Mean climatology')
plt.legend(loc='upper left', ncol = 5,fontsize=8, 
           bbox_to_anchor=(0, 1.0), borderpad=.5)
plt.ylim(top=25)
plt.grid(axis='x'); 
plt.xlim(left=np.datetime64('1953-01-01'),
                             right=np.datetime64('1954-01-01'))
# convert xticks to month strings
# define xticks and labels
xticks = [np.datetime64('1953-01-01'),np.datetime64('1953-02-01'),
          np.datetime64('1953-03-01'),np.datetime64('1953-04-01'),
          np.datetime64('1953-05-01'),np.datetime64('1953-06-01'),
          np.datetime64('1953-07-01'),np.datetime64('1953-08-01'),
          np.datetime64('1953-09-01'),np.datetime64('1953-10-01'),
          np.datetime64('1953-11-01'),np.datetime64('1953-12-01'),
          np.datetime64('1954-01-01')]
xticklabels = ['Jan','Feb','Mar','Apr','May','Jun','Jul',
            'Aug','Sep','Oct','Nov','Dec','Jan']
# set xticks and labels
ax.set_xticks(xticks)
ax.set_xticklabels(xticklabels)

# Please note: This script was written in Spyder - plots show up in a window.
# If this is not the case for you, you can use the following code to save
# the figure: plt.savefig(fname,dpi=300)
# If you want to explore the data more closely, use %matplotlib qt. Use
# %matplotlib inline to revert back

# %% ----- Demonstration: export data as CSV files -----------------

# exporting the climatology mean, 10th and 90th percentiles
# creating Pandas dataframe for saving
clim = np.transpose(np.vstack((data_clim.TEMP_AVE,
                               data_clim.TEMP_PER10,
                               data_clim.TEMP_PER90)))
column_names =  ['AVE 2m','AVE 10m','AVE 20m','AVE 30m','AVE 40m',
                'AVE 50m','AVE 60m','AVE 75m','AVE 99m',
                'PER10 2m','PER10 10m','PER10 20m','PER10 30m','PER10 40m',
                'PER10 50m','PER10 60m','PER10 75m','PER10 99m',
                'PER90 2m','PER90 10m','PER90 20m','PER90 30m','PER90 40m',
                'PER90 50m','PER90 60m','PER90 75m','PER90 99m',]
clim = pd.DataFrame(clim, columns = column_names)

# define saving location
saving_path = ('C:\\Users\\mphem\\Documents\\Work\\UNSW\\' + 
             'climatology\\Revamped_scripts\\Climatology\\' +
             'Scripts\\Provided_scripts_paper\\data_product' + 
             '_tutorials\\PYTHON\\')
# export data as .csv
clim.to_csv(saving_path + 'climatology.csv')





