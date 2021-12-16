% 'calcSchroederFct()' calculate Schroeder's integration. It returns the
% Decay Function [d(k)], 'decay_function', the Build-up function [1-d(k)],
% 'build_up_norm', and the optional Schroeder Frequency, 'schroeder_freq',
% if the resolution is changed in the input
% 
% Usage:
% [decay_function, build_up] =...
%     calc_Schroeder(energy_time_function, resolution_freq, upper_limit)
% 
% 'energy_time_function' is the ETF, and 'resolution_freq' is the the frequency
% for the ETF. Both are required. 'upper_limit' is an optional input to
% truncate data if desired. It will end the input data at whatever time, in
% ms, is specified.
% 
% Christopher Landschoot - 2018
% 
function [decay_function, build_up] =...
    calc_Schroeder(energy_time_function, resolution_freq, upper_limit)

% If a resolution (in ms) is input, then the block size for the new
% frequency is calculated.

% If an upper limit is not desired, then the Schroeder integration is run
% on the entire ETF.
if nargin == 1
    len = length( energy_time_function );
elseif nargin == 2
    len = length( energy_time_function );
end

% If an upper limit is desired, then it is entered in milliseconds, divided
% by 1000 to cancel ms to seconds, and then multiplied by the ETF frequency
% to cancel seconds to steps.
if nargin == 3
    full_len = 1000 * length( energy_time_function ) / resolution_freq;
    if upper_limit > full_len
        upper_limit_ms = full_len;
    else
        upper_limit_ms = floor(upper_limit * resolution_freq / 1000);
    end
    len = length( energy_time_function(1:upper_limit_ms) );
end

BU = zeros( 1,len ); % Initializing build_up
sum_energy = 0; % Initializing sum_energy

% Loop to sum the ETF to create the build-up function.
for idx = 1 : len    
    sum_energy = sum_energy + energy_time_function( idx );
    BU( idx ) = sum_energy; 
end

build_up_norm = BU / sum_energy; % Normalize buildup function
decay_function = 1 - build_up_norm; % Schroeder Decay (complementary to 'build_up_norm')

if nargout == 2
    build_up = build_up_norm; % Output Buildup if desired
end

end