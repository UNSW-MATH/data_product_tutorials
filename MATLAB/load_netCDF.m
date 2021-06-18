function [data] = load_netCDF(filename,imos_time)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load_netCDF.m

% Function created 18/06/2021 by Michael Hemming, NSW-IMOS Sydney
% using MATLAB version 9.8.0.1323502 (R2020a)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Input: 
%
% filename     |     string input including path and netCDF filename (including extension)
% imos_time   |     0/1 => no/yes to convert netCDF IMOS convention time (days since 1950-01-01) to MATLAB datenum 
%
% Output:
%
% data      |     structure file containing variables included in netCDF, plus file attributes and information

%% get information
data.file_info = ncinfo(filename);

%% obtain all variables in file

for n_var = 1:numel(data.file_info.Variables)
    % is datatype supported?
    if isempty(strmatch(data.file_info.Variables(n_var).Datatype,'UNSUPPORTED DATATYPE'))  
        eval(['data.',data.file_info.Variables(n_var).Name,' = ncread(filename,data.file_info.Variables(n_var).Name);']);
    else
        display(['UNSUPPORTED VARIABLE, n = ',num2str(n_var)])
        continue
    end
end

%% convert from IMOS time to MATLAB datenum if required

if imos_time == 1
    data.TIME = datenum(1950,01,01) + data.TIME;
end

end
