% 'White_Noise' generates a white noise signal of a specified length.
% 
% INPUTS:
% sigLen = desired signal length
% magnitude = (optional) magnitude of signal
% 
% OUTPUTS:
% WhiteNoise = the generated white noise signal
% 
% Christopher Landschoot - 2018
% 
function [WhiteNoise] = White_Noise(sigLen, magnitude)
if nargin == 1
    magnitude = 1;
end
phase = random('Normal', 0 , 3 , [1, sigLen]); % create random phase for signal
sigSpec = magnitude * exp( -1i*phase ); % xe^(-j*phase) = signal in freq domain
WhiteNoise = ifft(sigSpec, 'symmetric'); % signal in time domain (true white noise)
end

