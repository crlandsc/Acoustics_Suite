% 'plT' plots a set of data relative to a given sampling frequency.
% 
% Usage: [Time_Vector, Time_Length] = plT(data, Sampling_Frequency)
% 
% INPUTS:
% data = the input data, relative to a sampling frequency
% Sampling_Frequency = the sampling frequency at which the data was taken
% Line_Width = (Optional) Line width value
% 
% OUTPUTS:
% Time_Vectore = the new vector, measured in time, relative to 'data'
% Time_Length = the total length of time for 'data'
%
% Christopher Landschoot - 2018
% 
function [Time_Vector, Time_Length] = plT(data, Sampling_Frequency, Line_Width, sec)

dt = 1000/Sampling_Frequency;
if nargin == 4
    dt = 1/Sampling_Frequency;
end
dataLen = length(data);
Time_Vector = (0:dataLen-1)*dt;
Time_Length = Time_Vector(end);

if nargin == 2
    plot(Time_Vector, data);
end

if nargin >= 3
    plot(Time_Vector, data, 'linewidth', Line_Width);
end

end