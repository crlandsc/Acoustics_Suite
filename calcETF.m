% 'calcETF()' calculates the Energy Time Function (ETF) from room impulse
% response at reduced resolution. It returns 'etf', the Energy Time
% Function, along with the frequency, 'etfFreq'. Optionally, it also
% returns the Peak-to-Noise Ratio, 'PNR'.
%
% Usage: [ etf, etf_freq, PNR, SNR ] = calcETF( data, f_sample, ms );
%
% 'data' and 'f_sample' are the room impulse information and the sample
% rate, respectively. Both are required. 'ms' is and optional input to
% designate step size in milliseconds. If nothing is inputted, then the
% default stepsize will be 1 ms.
%
% Christopher Landschoot - 2018
% 
function [ etf, etf_freq, PNR, SNR ] = calcETF( data, f_sample, ms )

len = length(data); % length of data input

% If statement to determin if there is an input for the ms resolution. If
% there is not, then the resoltion defaults to 1ms
if nargin == 3
    OneMsBlk = floor(f_sample/(1000/ms));
else
    OneMsBlk = floor(f_sample/1000);
end

etf_freq = floor(f_sample/OneMsBlk); % Redefine the frequency
etf_len = floor(len/OneMsBlk); % Determine length of new time function
etf = zeros( 1, etf_len ); % Initialize array for new time function

idx = 1; % Initialize index

% Calculate ETF: Step through the index length by the defined resolution
% (OneMsBlk), while calculating the ETF => etf(t)=h^2(t). ETF is integrated
% over time, so h^2(t) needs to be added to the previous ETF value for each
% step. This essentially is downsampling the ETF by summing the ETF is on
% ms blocks.
for idx_t = 1 : etf_len
    for idx_b = 1: OneMsBlk
        etf(idx_t) = etf(idx_t) + data(idx) * data(idx); 
        idx = idx + 1;
    end
end

etf = etf / max(etf); % Normlize the ETF

% If there is an input for resolution, then calculate the
% Peak-to-Noise Ratio based on the resoltuion.
if nargout == 3
    if nargin == 3
        blkSize = round(50/ms);
    else
        blkSize = 50;
    end
    noise = mean( etf(end-blkSize+1:end) );
    PNR = - 10*log10(noise); % peak to noise ratio

end

% If there is an input for resolution, then calculate the
% Signal-to-Noise Ratio based on the resoltuion.
if nargout == 4
    if nargin == 3
        blkSize = round(50/ms);
    else
        blkSize = 50;
    end
    sig = mean( etf(1:blkSize) );
    noise = mean( etf(end-blkSize+1:end) );
    SNR = 10*log10(sig/noise); % signal to noise ratio
    PNR = - 10*log10(noise); % peak to noise ratio

end
end