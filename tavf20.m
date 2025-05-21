clear all;
close all;
clc;
% Load the .mat file
load('PIVlab week 2 mat.mat'); 

% Determine the number of frames
numFrames = length(u_original);

% Initialize matrices for averaging
[u_size, v_size] = size(u_original{1}); % Get grid size
u_avg = zeros(u_size, v_size);
v_avg = zeros(u_size, v_size);

% Compute the time-averaged velocity field
for a = 1:numFrames
    u_avg = u_avg + u_original{a};
    v_avg = v_avg + v_original{a};
end
u_avg = u_avg / numFrames;
v_avg = v_avg / numFrames;

% Generate a quiver plot
[xGrid, yGrid] = meshgrid(1:v_size, 1:u_size); % Adjust as per actual grid

figure;
quiver(xGrid, yGrid, u_avg, v_avg, 'AutoScale', 'on'); 
xlabel('X-m');
ylabel('Y-m');
title('Time-Averaged Velocity Field');
grid on;
axis equal;
