close all
clc
clear all

% Read the data from CSV file
data = readmatrix('simulated_annealing_init_temp_results_1.csv');

% Extract columns for cooling rate, energy, and time
temp = data(:,1);
energy = data(:,2);
time = data(:,3);

%coolingRates = flip(coolingRates);
%energy = flip(energy);
%time = flip(time);

% Plot energy vs cooling rate
subplot(2, 1, 1);  % Creates a 2-row, 1-column grid, and selects the first plot
plot(temp, energy, '-o', 'LineWidth', 1.5);
xlabel('Initial Temp');
ylabel('Energy (Solution Quality)');
title('Energy vs Initital Temp');
grid on;
set(gca, 'XDir', 'reverse');  % Reverse the x-axis

% Second subplot: Time vs Cooling Rate
subplot(2, 1, 2);  % Selects the second plot in the 2-row, 1-column grid
plot(temp, time, '-s', 'LineWidth', 1.5);
xlabel('Initial Temp');
ylabel('Time (ms)');
title('Time vs Initial Temp');
grid on;
set(gca, 'XDir', 'reverse');  % Reverse the x-axis
saveas(gcf, "input_1_txt_Initial_Temp.png");