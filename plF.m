% 'plF' transforms a time signal to the frequency spectrum via a fast Fourier
% transform, and plot the result.
% 
% Usage: [ spectrum ] = plF(dataInTime, sample_freq, plot_type, Line_Width)
% 
% INPUTS:
% dataInTime = time signal data
% sample_freq = the sample frequency that corresponds to data
% plot_type = (Optional) Type of plot that is desired. If nothing is
% specified, the magnitude plot is defaulted to.
%   - 'magnitude' plots the magnitude of the frequency spectrum
%   - 'phase' plots the phase of the frequency spectrum
%   - 'both' plots both the magnitude and the phase
% Line_Width = (Optional) Change the weight of the line to be plotted
% 
% OUTPUTS:
% spectrum = The transformed frequency spectrum data
% 
% Christopher Landschoot - 2018
% 
function [ spectrum ] = plF(dataInTime, sample_freq, plot_type, Line_Width)

len = length(dataInTime);
halfLen = floor(len/2);
d_f = sample_freq / len;
freqVct = 0:d_f:(halfLen - 1)*d_f ;
spectrum = fft(dataInTime);
magnitude = abs( spectrum );

% Different Plot Types: magnitude, phase, & both
if nargin == 2
    semilogx ( freqVct, magnitude(1:halfLen) );
elseif nargin == 3
    if strcmp(plot_type,'magnitude')
        semilogx ( freqVct, magnitude(1:halfLen) );
    elseif strcmp(plot_type,'phase')
        semilogx ( freqVct, imag(spectrum(1:halfLen)) );
    elseif strcmp(plot_type,'both')
        semilogx ( freqVct, magnitude(1:halfLen) );
        title('Magnitude');
        figure;
        semilogx ( freqVct, imag(spectrum(1:halfLen)) );
        title('Phase');
    end
    
elseif nargin == 4
    if strcmp(plot_type,'magnitude')
        semilogx ( freqVct, magnitude(1:halfLen), 'linewidth', Line_Width );
    elseif strcmp(plot_type,'phase')
        semilogx ( freqVct, imag(spectrum(1:halfLen)), 'linewidth', Line_Width );
    elseif strcmp(plot_type,'both')
        semilogx ( freqVct, magnitude(1:halfLen), 'linewidth', Line_Width );
        title('Magnitude');
        figure;
        semilogx ( freqVct, imag(spectrum(1:halfLen)), 'linewidth', Line_Width );
        title('Phase');
    end
    
end
end

