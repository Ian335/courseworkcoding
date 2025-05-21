import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt 
from scipy.signal import find_peaks  # Import find_peaks function 
 
# Function to handle non-numeric data 
def to_numeric(df): 
    return pd.to_numeric(df, errors='coerce')  # Converts non-numeric values to NaN 
 
# Load the data from the Excel file 
file_path = 'C:\\Users\\ianmu\\Downloads\\og실험C.xlsx'

data_1 = pd.read_excel(file_path, sheet_name='1,2,3,4', usecols="A:AA", skiprows=82, nrows=1601) 
data_2 = pd.read_excel(file_path, sheet_name='5,6,7,8', usecols="A:AA", skiprows=82, nrows=1601) 
data_3 = pd.read_excel(file_path, sheet_name='9,10,11,12', usecols="A:AA", skiprows=82, nrows=1601) 
data_4 = pd.read_excel(file_path, sheet_name='13,14,15,16', usecols="A:AA", skiprows=82, nrows=1601) 
 
# Convert all data to numeric, replacing non-numeric values with NaN 
data_1 = data_1.apply(to_numeric).fillna(0).values 
data_2 = data_2.apply(to_numeric).fillna(0).values 
data_3 = data_3.apply(to_numeric).fillna(0).values 
data_4 = data_4.apply(to_numeric).fillna(0).values 
 
# Save frequency data 
frequency = data_1[:, 1] 
 
# Save magnitude and phase data 
magnitude = np.zeros((len(frequency), 16)) 
phase = np.zeros((len(frequency), 16)) 
 
for index in range(0, 22, 7):  # step by 7 
    magnitude[:, index // 7] = data_1[:, index + 2] 
    phase[:, index // 7] = data_1[:, index + 5] 
    magnitude[:, index // 7 + 4] = data_2[:, index + 2] 
    phase[:, index // 7 + 4] = data_2[:, index + 5] 
    magnitude[:, index // 7 + 8] = data_3[:, index + 2] 
    phase[:, index // 7 + 8] = data_3[:, index + 5] 
    magnitude[:, index // 7 + 12] = data_4[:, index + 2] 
    phase[:, index // 7 + 12] = data_4[:, index + 5] 
 
# Calculate imaginary values 
phase = phase * np.pi / 180  # convert to radians 
imaginary = magnitude * np.sin(phase) 
 
# Duplicate curve 14 and take absolute values for peak detection 
curve_14_abs = np.abs(imaginary[:, 15]) 
 
# Find the peaks on the absolute curve 
peaks, _ = find_peaks(curve_14_abs) 
 
# Filter the peaks where the absolute values are greater than 10 
filtered_peaks = peaks[curve_14_abs[peaks] > 10] 
 
# Update modal_freq using filtered_peaks 
modal_freq = filtered_peaks  # Replace hardcoded modal frequencies with the filtered peaks 
 
# Plot FRF of each point 
plt.figure(figsize=(10, 6)) 
for i in range(16): 
    plt.plot(frequency, imaginary[:, i], label=f'Point {i + 1}') 
 
# Highlight and annotate the filtered peaks for curve 14 on the original curve 
plt.plot(frequency[filtered_peaks], imaginary[filtered_peaks, 15], "x", color="red") 
 
# Annotate the peaks with an annotation box and arrow 
for peak in filtered_peaks: 
    plt.annotate(f'f: {frequency[peak]:.3f}Hz',  
                 xy=(frequency[peak], imaginary[peak, 15]), 
                 xytext=(frequency[peak] + 20, imaginary[peak, 15] + 60), 
                 arrowprops=dict(facecolor='black', arrowstyle='->'), 
                 bbox=dict(facecolor='white', alpha=0.8)) 
 
# Plot the FRF 
plt.xlabel('Frequency [Hz]') 
plt.ylabel('Imaginary part of FRF [1/kg]') 
plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=4, fancybox=True, shadow=True) 
plt.grid(True) 
plt.tight_layout() 
plt.show() 
