% 'Sound_Propagation' calculates the attenuation of sound as it propagates
% over a distance. This can change depending on the environment and/or if
% there is a barrier introduced, all of which can be accounted for in the
% function. The sound power level of a source can also be calculated given
% the SPL at a receiver.
% 
% For more information regarding the methods & formulas applied in this
% function, refer to Chapter 6 of Hoover & Keith, and Chapter 5 of
% 'Architectural Acoustics' by Long.
% 
% =========================================================================
% Usage: Copy, paste, & uncomment the following (terminating @ 'INPUTS'):
% 
% % Enter the distance(s) the receiver(s) is from the source & the units.
% UI.r = [100 200 500]; % Distance from source
% UI.dist_type = 'ft'; % Distance units ('ft' or 'm')
% 
% % This variable is used to determine the SPL at a receiver given a source
% % SWL. If this information is not desired, comment out 'UI.Source_Lw'.
% UI.Source_Lw = 120; % Sound power level of source
%                     % Enter either a single number value or oct bands from 31.5Hz-8kHz
% 
% % These variable are used to determine the SWL and SPL of a source
% % dependent on a specified reciver SPL. (Example: A noise ordinance
% % specifies a limit of 50dBA at nearest redsidential property line). If
% % this information is not desired, comment out 'UI.dist_from_source' and
% % 'UI.Lp_lim'.
% UI.Lp_lim = 50; % Maximum A-weighted sound pressure level (dBA) allowable
%                 % at receiver location (ex. Noise ordinance limits)
%                 % Enter either a single number value or oct band values from 31.5Hz-8kHz
% UI.dist_from_source = 10; % Distance from a source to measure SPL (ft)
%                           % (ex. standing 10 ft from source)
% 
% % Barrier Attributes (assume infinitely long barrier).
% % Apply a barrier to the propagation calculations. If there is no barrier,
% % enter 0 for 'UI.Barrier'.
% UI.Barrier = 0; % Enter 1 if barrier exists, enter 0 if it doesn't
% UI.Height_Source = 4; % Source height (ft)
% UI.Height_Receiver = 5; % Receiver height (ft)
% UI.Height_Barrier = 10; % Barrier Height in ft
% UI.D_from_barrier_source = 10; % Source Distance from barrier (ft)
% UI.D_from_barrier_receiver = 10; % Receiver distance from barrier (ft)
% UI.Kb = 5; % Barrier constant (theoretical attenuation when N=0)
%            % Kb=5 for wall, Kb=8 for berm
% 
% % Type of propagation estimation. 2 or 3 are recommended for more realistic
% % attenuation per frequency. Enter one of the following:
% %   1 = No environmental effects (strictly based on distnace principle)
% %   2 = Open field
% %   3 = Medium-dense woods
% %   4 = Tall thick grass or shrubbery
% UI.Estimation_Type = 3;
% 
% % Show or suppress plots.
% % Enter 1 to show plots, 0 to suppress plots
% UI.plotflag = 1;
% 
% % Run Function. Each row of outputs corresponds to each distance, respectively.
% [Lp, Attenuation, Lw_lim, Lp_lim_from_source] = Sound_Propagation(UI);
% 
% =========================================================================
% INPUTS:
% UI = User Input. Struct containing the following fields:
%   UI.Estimation_Type =
%                       1 = Distance Attenuation (no environmental effects)
%                       2 = Distance Attenuation (open field)
%                       3 = Distance Attenuation (medium density woods)
%                       4 = Distance Attenuation (tall thick grass or shrubbery)
%   UI.r = Distance from source.
%   UI.dist_type = Units that distance is measured in ('ft' or 'm').
%   UI.plotflag = Enter 1 to show plots, 0 to suppress plots.
%   UI.dist_from_source = Distance from source SPL is to be determined (ft)
%                         (ex. standing 10 ft from source).
%   UI.Source_Lw = Sound power level of source. Enter either a single number
%                  value or oct bands from 31.5Hz-8kHz.
%   UI.Lp_lim = Maximum A-weighted sound pressure level allowable at receiver
%               location (ex. Noise ordinance limits). Enter either a single
%               number value or oct bands from 31.5Hz-8kHz.
%   UI.Height_Source = Source height for barrier calc (ft).
%   UI.Height_Receiver = Receiver height for barrier calc (ft).
%   UI.Height_Barrier = Barrier Height for barrier calc (ft).
%   UI.D_from_barrier_source = Distance of source to barrier for barrier calc
%                              (ft).
%   UI.D_from_barrier_receiver = Distance of receiver to barrier for barrier
%                                calc (ft).
%   UI.Kb = Barrier constant (theoretical attenuation when N=0).
%           Kb=5 for wall, Kb=8 for berm.
% 
% =========================================================================
% OUTPUTS:
% Lp = Resulting SPL at receiver
% Attenuation = dB attenuated from source to receiver
% Lw_lim = Max allowable SWL for source given a receiver SPL limit (ex. Noise ordinance)
% Lp_lim_from_source = Max allowable SPL at a distance from the source for
%                      source given a receiver SPL limit (ex. Noise ordinance)
% 
% Christopher Landschoot - 2018
function [Lp, Attenuation, Lw_lim, Lp_lim_from_source] = Sound_Propagation(UI)

%% Convert from struct to variables
Estimation_Type = UI.Estimation_Type;
r = UI.r;
dist_type = UI.dist_type;
plotflag = UI.plotflag;
dist_from_source = UI.dist_from_source;
Source_Lw = UI.Source_Lw;
Lp_lim = UI.Lp_lim;
if UI.Barrier == 1
    Height_Source = UI.Height_Source;
    Height_Receiver = UI.Height_Receiver;
    Height_Barrier = UI.Height_Barrier;
    D_from_barrier_source = UI.D_from_barrier_source;
    D_from_barrier_receiver = UI.D_from_barrier_receiver;
    Kb = UI.Kb;
end

%% Definitions
if length(Source_Lw) == 1
    Source_Lw = Source_Lw*ones(1,9) + 10*log10(1/9); % Octave band sound power level of source (Freq: 31.5Hz-8kKz)
end

A_weight_factor = [-39.4  -26.2  -16.1  -8.6  -3.2  0  1.2  1.0  -1.1]; % A-weighting. Freq: 31.5Hz-8kKz
freq = [31.5 63 125 250 500 1000 2000 4000 8000]; % Octave band frequencies
freq_axis = [1 2 3 4 5 6 7 8 9]; % For plotting (9 octave bands from 31.5Hz-8kKz)
freq_axis_ticks = {'31.5', '63', '125', '250', '500', '1k', '2k', '4k', '8k'}; % x-axis labels for plots
line_type = {'--', '-.', '-'}; % varying line types to differentiate on plots
Q = 2*ones(1,9); % Directivity of source (ex. Q=2 for hemisphere)
c = 1125.33; % Speed of sound (ft/s)
delta_Lb = zeros(1,9); % Initialize barrier attenuation (in case barrier doesn't exist)

% Molecular and anamolous environmental attenuation
alpha_m = [0.0  0.1  0.2  0.4  0.7  1.5  3.0  7.6  13.7]; % molecular absorption coefficient (dB/1000 ft) or (dB/300m) - "std day". Freq: 31.5Hz-8kKz
alpha_a = [0.0  0.4  0.6  0.8  1.1  1.5  2.2  3.0  4.0 ]; % anomolous excess attenuation (dB/1000 ft) or (dB/300m). Freq: 31.5Hz-8kKz

% Attenuation through vegetation (dB/100ft). Limit to max attenuation of 20-25dB.
if Estimation_Type == 3
    % Attenuation through medium-dense woods
    Vegetation =           [0.9  1.2  1.5  1.8  2.4  3.1  4.0   4.9   6.1]; % dB/100ft. Freq: 31.5Hz-8kKz
elseif Estimation_Type == 4
    % Attenuation through tall thick grass or shrubbery
    Vegetation = [0.0  0.3  2.1  3.7  5.5  7.0  8.5  10.4  11.9]; % dB/100ft. Freq: 31.5Hz-8kKz
end

% ft to m conversion (if distnaces in ft)
if strcmp(dist_type,'ft') || strcmp(dist_type,'foot') || strcmp(dist_type,'feet')
    r_meter = round(r.*0.3048); % ft to m conversion
elseif strcmp(dist_type,'m') || strcmp(dist_type,'meter') || strcmp(dist_type,'meters')
    r_meter = r; % already in meters
end



%% Barrier Calc

% Based on diagram in long (pg. 162)
% Max Fresnel Number:
% N = +-(2/lambda) * (A+B-r)
% 
% Barrier Attenuation:
% delta_Lb = 20*log10( sqrt(2*pi*N) / tanh(sqrt(2*pi*N)) ) + Kb
% 
% Rule of thumb: Every 0.3 m (1 ft) of barrier provides about one
% additional dB of attenuation at 500 Hz. (Very general - only for estimation)

if exist('Height_Source','var') == 1 && exist('Height_Receiver','var') == 1 ...
    && exist('Height_Barrier','var') == 1 && exist('D_from_barrier_source','var') == 1 ...
    && exist('D_from_barrier_receiver','var') == 1 && exist('Kb','var') == 1
    
    % Equation 5.10 from Long (along with accompanying diagram)
    R = D_from_barrier_source + D_from_barrier_receiver;
    A = sqrt( (R/2).^2 + (Height_Barrier - Height_Source).^2 );
    B = sqrt( (R/2).^2 + (Height_Barrier - Height_Receiver).^2 );
    lambda = c./freq; % Wavelength
    Min_path_length_dif = (A+B-R); % Minimum path length difference between path around barrier vs. path directly from source to receiver
    Max_Fresnel_Number = (2./lambda).*Min_path_length_dif; % Maximum Fresnel Number
    
    % Equation 5.11 from Long (along with accompanying diagram)
    delta_Lb = 20* log10( sqrt(2*pi.*Max_Fresnel_Number) ./ tanh(sqrt(2*pi.*Max_Fresnel_Number)) ) + Kb;
    
    
    if plotflag == 1
        figure; plot(freq_axis,delta_Lb,line_type{3});
        title(strcat('Barrier Attenuation'));
        xlabel('Frequency (Hz)');
        ylabel('Attenuation (dB)');
        % legend('Barrier Attenuation', 'location', 'best');
        xticks(freq_axis);
        xticklabels(freq_axis_ticks);
        axis([-inf  inf  min(min(delta_Lb))-2  max(max(delta_Lb))+2])
    end
end



%% Attenuation & Resulting SPL Calculation
if Estimation_Type == 1
    % Lw to Lp. Strictly based on distance attenuation
    for idx = 1:length(Source_Lw)
        for idk = 1:length(r_meter)
            DT(idk,idx) = 10.*log10(2*pi.*r_meter(idk).^2./Q(idx) );
            Attenuation(idk,idx) = DT(idk,idx);
            Lp(idk,idx) = Source_Lw(idx) - DT(idk,idx);
        end
    end
    
elseif Estimation_Type == 2
    % Combined Distance Effect (Including molecular absorption & anomolous attenuation)
    for idx = 1:length(Source_Lw)
        for idk = 1:length(r_meter)
            DT(idk,idx) = ( 10.*log10(2*pi.*r_meter(idk).^2./Q(idx)) + (r_meter(idk).*(alpha_m(idx) + alpha_a(idx)))/300 );
            Attenuation(idk,idx) = DT(idk,idx);
            Lp(idk,idx) = Source_Lw(idx) - DT(idk,idx);
        end
    end
    
elseif Estimation_Type == 3 || Estimation_Type == 4
    % Combined Distance Effect (Including molecular absorption & anomolous attenuation & Vegetation)
    for idx = 1:length(Source_Lw)
        for idk = 1:length(r_meter)
            DT(idk,idx) = ( 10.*log10(2*pi.*r_meter(idk).^2./Q(idx)) + (r_meter(idk).*(alpha_m(idx) + alpha_a(idx)))/300 );
            Vegetation_TL(idk,idx) = (r_meter(idk)./100.*Vegetation(idx));
            if Vegetation_TL(idk,idx) > 20
                Vegetation_TL(idk,idx) = 20; % cannot exceed 20 dB of attenuation
            end
            Attenuation(idk,idx) = DT(idk,idx) + Vegetation_TL(idk,idx);
            Lp(idk,idx) = Source_Lw(idx) - Attenuation(idk,idx);
        end
    end
end
r_Lp = [0 freq; [r_meter', Lp]]; % Combine frequency & dB levels

for idk = 1:length(r_meter)
    Lp(idk,:) = Lp(idk,:) - delta_Lb;
end

% Attenuation Plot
if plotflag == 1
    figure;
    for idx = 1:length(r_meter)
        plot(freq_axis,Attenuation(idx,:)); hold on
        LEGEND{idx} = strcat(num2str(r(idx)), dist_type);
    end
    xlabel('Frequency (Hz)');
    ylabel('Attenuation (dB)');
    legend(LEGEND, 'location', 'best');
    xticks(freq_axis);
    xticklabels(freq_axis_ticks);
    axis([-inf  inf  min(min(Attenuation))-5  max(max(Attenuation))+5])
    if Estimation_Type == 1
        title('Distance Attenuation');
    elseif Estimation_Type == 2
        title('Distance Attenuation Through Open Field');
    elseif Estimation_Type == 3
        title('Distance Attenuation Through Medium-Dense Woods');
    elseif Estimation_Type == 4
        title('Distance Attenuation Through Tall Thick Grass or Shrubbery');
    end
    
    % Resulting SPL Plot
    figure;
    for idk = 1:length(r_meter)
        plot(freq_axis,Lp(idk,:)); hold on
        LEGEND{idk} = strcat(num2str(r(idk)), dist_type);
    end
    xlabel('Frequency (Hz)');
    ylabel('SPL (dB)');
    legend(LEGEND, 'location', 'best');
    xticks(freq_axis);
    xticklabels(freq_axis_ticks);
    axis([-inf  inf  min(min(Lp))-5  max(max(Lp))+5])
    if Estimation_Type == 1
        title('Resulting SPL After Distance');
    elseif Estimation_Type == 2
        title('Resulting SPL After Open Field');
    elseif Estimation_Type == 3
        title('Distance Attenuation Through Medium-Dense Woods');
    elseif Estimation_Type == 4
        title('Distance Attenuation Through Tall Thick Grass or Shrubbery');
    end
end

%% Source SWL calculation for known SPL limit at receiver

if exist('Lp_lim','var') == 1
    
    if length(Lp_lim) == 1
        Lp_lim_oct = Lp_lim*ones(1,9) + 10*log10(1/9); % expand single number SPL to all octave bands
    else
        Lp_lim_oct = Lp_lim; % Already in octave bands
    end
    Lp_lim_dBa = Lp_lim_oct - A_weight_factor; % A-weighted maximum sound pressure level allowable at receiver location
    
    % SWL limit to achieve a certain SPL @ receiver
    for idk = 1:length(r_meter)
        Lw_lim(idk,:) = Lp_lim_dBa + Attenuation(idk,:) + delta_Lb;
    end
    
    % SWL limit plot - based on required SPL @ receiver location
    if plotflag == 1
        figure;
        for idk = 1:length(r_meter)
            plot(freq_axis,Lw_lim(idk,:)); hold on
            LEGEND{idk} = strcat(num2str(r(idk)), dist_type);
        end
        title(strcat('Source SWL Limit - Based on receiver SPL limit of: ', num2str(Lp_lim), 'dBA'));
        xlabel('Frequency (Hz)');
        ylabel('SWL (dB)');
        legend(LEGEND, 'location', 'best');
        xticks(freq_axis);
        xticklabels(freq_axis_ticks);
        axis([-inf  inf  min(min(Lw_lim))-5  max(max(Lw_lim))+5])
    end
end

%% SPL at a distance from source calculation for known SPL limit at receiver

if exist('dist_from_source','var') == 1 && exist('Lp_lim','var') == 1
        
    if Estimation_Type == 1
        % Lw to Lp. Strictly based on distance attenuation
        for idk = 1:length(r_meter)
            DT_source = 10.*log10(2*pi.*dist_from_source.^2./Q );
            TL12(idk,:) = DT(idk,:) - DT_source + delta_Lb;
            Lp_lim_from_source(idk,:) = Lp_lim_dBa + TL12(idk,:);
        end
    
    elseif Estimation_Type == 2
        % Combined Distance Effect (Including molecular absorption & anomolous attenuation)
        for idk = 1:length(r_meter)
            DT_source = 10.*log10(2*pi.*dist_from_source.^2./Q) + (dist_from_source.*(alpha_m + alpha_a))/300;
            TL12(idk,:) = DT(idk,:) - DT_source;
            Lp_lim_from_source(idk,:) = Lp_lim_dBa + TL12(idk,:) + delta_Lb;
        end
    
    elseif Estimation_Type == 3 || Estimation_Type == 4
        % Combined Distance Effect (Including molecular absorption & anomolous attenuation & vegetation)
        for idk = 1:length(r_meter)
            DT_source = 10.*log10(2*pi.*dist_from_source.^2./Q) + (dist_from_source.*(alpha_m + alpha_a))/300;
            Vegetation_TL_source(idk,:) = (dist_from_source./100.*Vegetation);
            if Vegetation_TL_source(idk,:) > 20
                Vegetation_TL_source(idk,:) = 20; % cannot exceed 20 dB of attenuation
            end
            TL12(idk,:) = DT(idk,:) + Vegetation_TL(idk,:) - DT_source - Vegetation_TL_source(idk,:) + delta_Lb;
            Lp_lim_from_source(idk,:) = Lp_lim_dBa + TL12(idk,:);
        end
    end
    
    % SPL limit @ a distance from source plot - based on required SPL @ receiver location
    if plotflag == 1
        figure;
        for idk = 1:length(r_meter)
            plot(freq_axis,Lp_lim_from_source(idk,:)); hold on
            LEGEND{idk} = strcat(num2str(r(idk)), dist_type);
        end
        title(strcat('SPL Limit (', num2str(dist_from_source),...
            'ft from source) - Based on receiver SPL limit of: ', num2str(Lp_lim), 'dBA'));
        xlabel('Frequency (Hz)');
        ylabel('Source SPL (dB)');
        legend(LEGEND, 'location', 'best');
        xticks(freq_axis);
        xticklabels(freq_axis_ticks);
        axis([-inf  inf  min(min(Lp_lim_from_source))-5  max(max(Lp_lim_from_source))+5])
    end
end

end


