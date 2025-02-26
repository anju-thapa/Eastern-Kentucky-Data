clc; clearvars;

% Import Data with Headers
opts = detectImportOptions("Updated_Data.xlsx", 'PreserveVariableNames', true);
opts.VariableNamesRange = "A1";  % Read headers from the first row
opts.DataRange = "A2";  % Start reading data from the second row
data = readtable("Updated_Data.xlsx", opts);

% Display column names to verify correct import
disp("Full Column Names in the Dataset:");
disp(data.Properties.VariableNames);

% Assign correct column names (Use exactly as detected)
time_col = "Time";
pressure_col = "Pressure(psi)";
conductivity_col = "Conductivity(uS/cm)";

disp("Using Columns:");
disp(["Time -> " + time_col, "Pressure -> " + pressure_col, "Conductivity -> " + conductivity_col]);

% Convert 'Time' column to datetime format
data.(time_col) = datetime(data.(time_col), 'InputFormat', 'MM/dd/yyyy HH:mm:ss');

% Convert 'Conductivity' column from cell to numeric (if necessary)
if iscell(data.(conductivity_col))
    data.(conductivity_col) = str2double(data.(conductivity_col));
end

% Convert 'Pressure' column from cell to numeric (if necessary)
if iscell(data.(pressure_col))
    data.(pressure_col) = str2double(data.(pressure_col));
end

% Extract year from the date
data.Year = year(data.(time_col));

% Filter: Keep only data from 2024 and 2025
data = data(data.Year == 2024 | data.Year == 2025, :);

% Remove rows where Conductivity is zero or negative
data = data(data.(conductivity_col) > 0, :);

% Remove rows where Pressure is negative
data = data(data.(pressure_col) > 0, :);

% ✅ Save cleaned data (optional)
writetable(data, 'cleaned_data.xlsx');

disp('✅ Data cleaned successfully (Negative values removed).');


