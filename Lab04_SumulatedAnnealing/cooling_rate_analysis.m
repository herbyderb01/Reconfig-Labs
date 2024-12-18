close all
clc
clear all

% Read the data from CSV file
data = readmatrix('simulated_annealing_cooling_rate_results_3.csv');

% Extract columns for cooling rate, energy, and time
coolingRates = data(:,1);
energy = data(:,2);
time = data(:,3);

%coolingRates = flip(coolingRates);
%energy = flip(energy);
%time = flip(time);

% Plot energy vs cooling rate
% First subplot: Energy vs Cooling Rate
subplot(2, 1, 1);  % Creates a 2-row, 1-column grid, and selects the first plot
plot(coolingRates, energy, '-o', 'LineWidth', 1.5);
xlabel('Cooling Rate');
ylabel('Energy (Solution Quality)');
title('Energy vs Cooling Rate');
grid on;
set(gca, 'XDir', 'reverse');  % Reverse the x-axis

% Second subplot: Time vs Cooling Rate
subplot(2, 1, 2);  % Selects the second plot in the 2-row, 1-column grid
plot(coolingRates, time, '-s', 'LineWidth', 1.5);
xlabel('Cooling Rate');
ylabel('Time (ms)');
title('Time vs Cooling Rate');
grid on;
set(gca, 'XDir', 'reverse');  % Reverse the x-axis
saveas(gcf, "input_3_txt_cooling_rate.png");