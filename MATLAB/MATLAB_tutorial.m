%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% MATLAB_tutorial.m

% Tutorial created 18/06/2021 by Michael Hemming, NSW-IMOS Sydney
% using MATLAB version 9.8.0.1323502 (R2020a)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------------------------------

%% Demonstration: Downloading files and citation

%####################################################################################################

% The netCDF files are available for download here: 
% http://thredds.aodn.org.au/thredds/catalog/UNSW/NRS_climatology/Temperature_DataProducts/catalog.html

% For more information on the files and methodology, please see Roughan, M., et al. "Multi-decadal ocean temperature time-series and 
% climatologies from Australia's long-term National Reference Stations." Scientific Data (2022)

%####################################################################################################

%----------%----------
% Citation:
%----------%----------

% Any and all use of the data products and code provided here must include:

% (a) a citation to the above paper,
% (b) a reference to the data citation as written in the netCDF file attributes
% (c) the following acknowledgement statement: Data was sourced from Australia's Integrated Marine Observing System (IMOS) - IMOS is enabled by
%     the NationalCollaborative Research Infrastructure Strategy (NCRIS).

%####################################################################################################

%% Demonstration: loading the netCDF files

% define file path
file_path = % TO UPDATE
addpath(genpath(file_path));
% define filenames 
file_agg = 'PH100_TEMP_1953-2020_aggregated_v1.nc';
file_grid = 'PH100_TEMP_1953-2020_gridded_v1.nc';
file_clim = 'PH100_TEMP_1953-2020_BottleCTDMooringSatellite_climatology_v1.nc';
% load files
data_agg = load_netCDF(file_agg,1); % aggregated file
data_grid = load_netCDF(file_grid,1); % gridded file
data_clim = load_netCDF(file_clim,1); % climatology file

% Please Note: Attributes are saved in data_<file_type>.file_info

%% Demonstration: scatter aggregated data over time and depth, colored by platform type

figure('units','normalized','position',[.1 .1 .6 .6])

hold on;
% Bottle
c = data_agg.TEMP_DATA_PLATFORM_AGG == 1;
scatter(data_agg.TIME(c),data_agg.DEPTH_AGG(c),10,'filled')
% CTD
c = data_agg.TEMP_DATA_PLATFORM_AGG == 2;
scatter(data_agg.TIME(c),data_agg.DEPTH_AGG(c),10,'filled')
% Mooring
c = data_agg.TEMP_DATA_PLATFORM_AGG == 3;
scatter(data_agg.TIME(c),data_agg.DEPTH_AGG(c),10,'filled')
% Satellite
c = data_agg.TEMP_DATA_PLATFORM_AGG == 4;
scatter(data_agg.TIME(c),data_agg.DEPTH_AGG(c),10,'filled')
% plot properties and legend
set(gca,'YDir','Reverse','LineWidth',2,'Box','On','FontSize',16,'XGrid','On');
datetick; xlim([datenum(1950,01,01) datenum(2023,01,01)]);
ylabel('Depth [m]'); title('Demonstration: Port Hacking Aggregated Data');
leg = legend('Bottle','CTD','Mooring','Satellite');
set(leg,'Position',[0.88 0.35 0.13 0.20],'FontSize',12,'Box','Off');

clear c leg

%% Demonstration: Compare gridded temperature data at the surface, 20 m, 50 m, 75 m and 90 m over the last 10 years

% create figure
figure('units','normalized','position',[.1 .1 .8 .6])
% select data over the last 10 years
ctime = data_grid.TIME > datenum(2010,01,01);
% scatter data
hold on;
scatter(data_grid.TIME(ctime),data_grid.TEMP_GRID(ctime,1),10,'filled'); % surface
scatter(data_grid.TIME(ctime),data_grid.TEMP_GRID(ctime,21),10,'filled'); % 20 m
scatter(data_grid.TIME(ctime),data_grid.TEMP_GRID(ctime,51),10,'filled'); % 50 m
scatter(data_grid.TIME(ctime),data_grid.TEMP_GRID(ctime,76),10,'filled'); % 75 m
scatter(data_grid.TIME(ctime),data_grid.TEMP_GRID(ctime,91),10,'filled'); % 90 m
% plot properties and legend
set(gca,'LineWidth',2,'Box','On','FontSize',16,'XGrid','On');
datetick;
ylabel('Temperature [^\circC]'); title('Demonstration: Port Hacking Gridded Data');
leg = legend('surf','20 m','50 m','75 m','90 m');
set(leg,'Location','NorthWest','FontSize',12,'Box','Off','Orientation','Horizontal');

%% Demonstration: plot mean climatologies over depth

% load cmocean 'thermal' colormap prepared earlier
% The cmocean package is available here: 
% https://au.mathworks.com/matlabcentral/fileexchange/57773-cmocean-perceptually-uniform-colormaps
load('cmap');

% Create figure
figure('units','normalized','position',[.2 .1 .6 .6])

hold on;
% loop through depths to plot climatology means
for depth = 1:size(data_clim.TEMP_AVE,2)
    plot(data_clim.TEMP_AVE(:,depth),'k','LineWidth',3);
    p(depth).p = plot(data_clim.TEMP_AVE(:,depth),'LineWidth',2,'Color',cmap(depth,:));
end
% plot properties and legend
set(gca,'LineWidth',2,'Box','On','FontSize',16,'XGrid','On');
datetick;
ylabel('Temperature [^\circC]'); title('Demonstration: Port Hacking Mean climatology');
legendCell = strcat(string(num2cell(data_clim.DEPTH)))';
leg = legend([p(1).p p(2).p p(3).p p(4).p p(5).p p(6).p p(7).p p(8).p p(9).p],legendCell);
set(leg,'Location','NorthWest','FontSize',12,'Box','Off','Orientation','Horizontal');


%% Demonstration: export data as CSV files

% exporting the climatology mean, 10th and 90th percentiles
% create structure 
clim.day = (1:365)';
clim.mean = data_clim.TEMP_AVE;
clim.PER10 = data_clim.TEMP_PER10;
clim.PER90 = data_clim.TEMP_PER90;
% convert structure to table and save as a .csv
writetable(struct2table(clim), 'climatology.csv')
disp(['climatology.csv saved in: ',pwd])

