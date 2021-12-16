# Acoustics_Suite
A suite of functions to perform acoustic calculations

# calc_Schroeder.m
'calcSchroeder()' calculate Schroeder's integration. It returns the
Decay Function [d(k)], 'decay_function', the Build-up function [1-d(k)],
'build_up_norm', and the optional Schroeder Frequency, 'schroeder_freq',
if the resolution is changed in the input.

# calcETF.m
'calcETF()' calculates the Energy Time Function (ETF) from room impulse
response at reduced resolution. It returns 'etf', the Energy Time
Function, along with the frequency, 'etfFreq'. Optionally, it also
returns the Peak-to-Noise Ratio, 'PNR'.

# image2binary.m
Function to convert image file to a binary map that is dependent on the
binary step size that is inputted. To perform this process, the function
converts the image to a grayscale format and then converts said file to
binary by the process of thresholding. The output results in values of 1
for empty (white) points and values of 0 for filled (black) points
organized into a matrix with resampled dimensions.

# plF.m
'plF' transforms a time signal to the frequency spectrum via a fast Fourier
transform, and plot the result.

# plT.m
'plT' plots a set of data relative to a given sampling frequency.

# PNR_SNR.m
'PNR_SNR' calculates the 'Peak-to-Noise Ratio' (PNR) and
'Signal-to-Noise Ratio' (SNR) of a given impulse response (IR).

# RH_Window.m
'RH_Window' windows an Impulse Response according to a start and end
point as defined by the user

# White_Noise.m
'White_Noise' generates a white noise signal of a specified length.

# Sound_Propagation.m
'Sound_Propagation' calculates the attenuation of sound as it propagates
over a distance. This can change depending on the environment and/or if
there is a barrier introduced, all of which can be accounted for in the
function. The sound power level of a source can also be calculated given
the SPL at a receiver.
 
For more information regarding the methods & formulas applied in this
function, refer to Chapter 6 of Hoover & Keith, and Chapter 5 of
'Architectural Acoustics' by Long.

NOTE: Use 'Sound_Propagation_Calculations.m' in combination with
'Sound_Propagation.m' so you do not have to type out all of the inputs
every time.

# IR_Cleanup_Convolution.m
General Convolution & Cleanup
This file was created for the convenience of cleaning up IRs and then
convolving them with anechoic audio. Not as well documented as other 
code and functions, so use at your own risk.
