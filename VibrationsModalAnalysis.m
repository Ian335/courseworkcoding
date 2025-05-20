clc
clear all
close all 

%% Upload and read Data files

filePath = "C:\Users\ianmu\Downloads\og실험C.xlsx";  

sheetNames = ["1,2,3,4", "5,6,7,8", "9,10,11,12", "13,14,15,16"];
range_Mag = ["C83:C1683", "J83:J1683", "Q83:Q1683", "X83:X1683"];
range_Phs = ["F83:F1683", "M83:M1683", "T83:T1683", "AA83:AA1683"];

% Frequency data (same range across all sheets)
freq = cell2mat(readcell(filePath, "Sheet", sheetNames(1), "Range", "B83:B1683"));

% Initialize magnitude and phase arrays
magnitudeData = zeros(16, length(freq));
phaseData = zeros(16, length(freq));

% Loop through 4x4 grid points (16 total)
for row = 1:4
    for col = 1:4
        idx = 4*(row-1) + col;
        magnitudeData(idx, :) = readmatrix(filePath, 'Sheet', sheetNames(row), 'Range', range_Mag(col));
        phaseData(idx, :) = readmatrix(filePath, 'Sheet', sheetNames(row), 'Range', range_Phs(col));
    end
end

%% Peak detection to find modal frequencies

modeFreq = zeros(16, 6);
modeLoc = zeros(16, 6);
numModes = 6;

for pt = 1:16
    localPeaks = islocalmax(magnitudeData(pt, :));
    peakVals = magnitudeData(pt, localPeaks);
    [sortedVals, sortIdx] = sort(peakVals, 'descend');

    actualIdx = find(localPeaks);
    sortedActualIdx = actualIdx(sortIdx);

    keep = min(numModes, length(sortedVals));
    topIdx = sortedActualIdx(1:keep);
    topFreqs = sort(freq(topIdx));

    disp(['Point ', num2str(pt), ': ', mat2str(topFreqs)]);

    modeFreq(pt, :) = topFreqs;
    modeLoc(pt, :) = sort(topIdx);
end

avgModeFreq = mean(modeFreq);

%% Mode Shape

[X, Y] = meshgrid(1:4, 1:4);
dispField = zeros(4, 4, 6);

for mode = 1:6
    for row = 1:4
        for col = 1:4
            idx = 4*(row-1) + col;
            a = magnitudeData(idx, modeLoc(idx, mode));
            p = phaseData(idx, modeLoc(idx, mode));
            f = modeFreq(idx, mode);

            dispField(row, col, mode) = a * sind(p) / (2*pi*f)^2;
        end
    end

    figure(mode + 4);
    surf(X, Y, dispField(:,:,mode));
    title(['Mode Shape ', num2str(mode)]);
    colormap(jet);                             
    colorbar;
    xlabel('X Coordinate');
    ylabel('Y Coordinate');
    zlabel("Displacement [m]");
    grid on;
end
