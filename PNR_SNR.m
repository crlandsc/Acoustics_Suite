% 'PNR_SNR' calculates the 'Peak-to-Noise Ratio' (PNR) and
% 'Signal-to-Noise Ratio' (SNR) of a given impulse response (IR).
% 
% Usage: [PNR, SNR] = PNR_SNR(IR,fs)
% 
% INPUTS:
% IR = The desired impulse response
% fs = the sampling frequency at which the data was taken
% 
% OUTPUTS:
% PNR = The Peak-to-Noise Ratio of the IR. This compares the highest level
%       to the noise of the signal.
% SNR = The Peak-to-Noise Ratio of the IR. This compares a more general
%       level of the signal to the noise of the signal.
% 
% The higher the PNR & SNR are, the better quality the measurement. To
% ensure that measurement is correct, PNR & SNR should be similar, with the
% SNR slightly below the PNR.
% 
% Christopher Landschoot - 2018
% 
function [PNR, SNR] = PNR_SNR(IR,fs)

% Define the number of samples in 1ms.
OneMsBlk = floor(fs/1000);

%% Calculate ETF to determine PNR & SNR
ETF_len = floor(length(IR)/OneMsBlk); % Determine length of new time function
ETF = zeros( 1, ETF_len ); % Initialize array for new time function

% Calculate ETF: Step through the index length by the defined resolution
% (OneMsBlk), while calculating the ETF => etf(t)=h^2(t). ETF is integrated
% over time, so h^2(t) needs to be added to the previous ETF value for each
% step.
%
idx = 1; % Initialize index
for idx_t = 1 : ETF_len
    for idx_b = 1: OneMsBlk
        ETF(idx_t) = ETF(idx_t) + (IR(idx) * IR(idx)); 
        idx = idx + 1;
    end
end
%
ETF_a = IR.*IR;
[max_ETF_a, max_ETF_idx_a] = max(ETF_a);
ETF_a = ETF_a / max_ETF_a; % Normlize the ETF
% figure; plot(10*log10(ETF));
% figure; plot(10*log10(IR.*IR));
[max_ETF, max_ETF_idx] = max(ETF);
ETF = ETF / max_ETF; % Normlize the ETF

%% Calculate PNR & SNR
Signal_ms_size = 50; % Defines how many ms will be used in the SNR calculation
Signal_Level = max(ETF_a); %mean( ETF( max_ETF_idx:(max_ETF_idx+Signal_ms_size) ) ); % Captures the first ___ms of the signal
Noise = mean( ETF(end-(5*Signal_ms_size):end-1) ); % averaged noise level of last 5ms of signal
SNR = 10*log10(Signal_Level/Noise); % signal to noise ratio
PNR = -10*log10(Noise); % peak to noise ratio


end