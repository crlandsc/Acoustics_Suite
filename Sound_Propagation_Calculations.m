% Sound Propagation Calculations
close all; clear all; clc;

% Enter the distance(s) the receiver(s) is from the source & the units.
UI.r = [850 850 850]; % Distance from source -- [#ft #ft #ft]
UI.dist_type = 'ft'; % Distance units ('ft' or 'm')


% This variable is used to determine the SPL at a receiver given a source
% SWL or SPL. The SWL is the sound power level emitted by a source and the
% SPL is the sound pressure level measured a certain distance from a
% source. SWL or 'Lw' stands on it's own, but SPL or 'Lp' requires a
% distance that it was measured at.
% If this information is not desired, comment out 'UI.Source_Lw_Lp'.
UI.Source_Lw_Lp = 75; % Sound power/pressure level of source
                       % Enter either a single number value or oct bands from 31.5Hz-8kHz
UI.Lw_or_Lp = 'Lp'; % Enter 'Lw' or 'SWL' for sound power level
                 % Enter 'Lp' or 'SPL' for sound pressure level
UI.Source_Lp_dist = 20; % Distance from a source SPL was measured at (ft)
                        % (ex. standing 10 ft from source)


% These variables are used to determine the SWL and SPL of a source
% dependent on a specified reciver SPL. (Example: A noise ordinance
% specifies a limit of 50dBA at nearest redsidential property line). If
% this information is not desired, comment out 'UI.dist_from_source' and
% 'UI.Lp_lim'.
UI.Lp_lim = 55; % Maximum A-weighted sound pressure level (dBA) allowable
                % at receiver location (ex. Noise ordinance limits)
                % Enter either a single number value or oct band values from 31.5Hz-8kHz
UI.dist_from_source = 20; % Distance from a source to measure resulting SPL (ft)
                          % (ex. standing 10 ft from source)

                          
% Barrier Attributes (assume infinitely long barrier).
% Apply a barrier to the propagation calculations. If there is no barrier,
% enter 0 for 'UI.Barrier'.
UI.Barrier = 1; % Enter 1 if barrier exists, enter 0 if it doesn't
UI.Height_Source = [288 288 288]; % Source height relative to 0' elevation (ft)
UI.Height_Receiver = [250 250 250]; % Receiver height relative to 0' elevation (ft)
UI.Height_Barrier = [0 266+20 266+30]; % Barrier Height relative to 0' elevation (ft)
UI.D_from_barrier_source = [50 50 50]; % Source Distance from barrier (ft)
UI.D_from_barrier_receiver = [UI.r-UI.D_from_barrier_source]; % Receiver distance from barrier (ft)
UI.Kb = 5; % Barrier constant (theoretical attenuation when N=0)
           % Kb=5 for wall, Kb=8 for berm

           
% Type of propagation estimation. 2 or 3 are recommended for more realistic
% attenuation per frequency. Enter one of the following:
%   1 = No environmental effects (strictly based on distnace principle)
%   2 = Open field
%   3 = Medium-dense woods
%   4 = Tall thick grass or shrubbery
UI.Estimation_Type = 2;


% Show or suppress plots.
% Enter 1 to show plots, 0 to suppress plots
UI.plotflag = 0;

% Directivity of source. Optional input (default Q=2). Enter either a
% single number or a Q per octave band from 31.5Hz-8kHz.
UI.Q = 2.5;



% Run Function. Each row of outputs corresponds to each distance, respectively.
[Data_Output] = Sound_Propagation(UI);
% [Data_Output, Broadband_Levels, Lp, Lp_dBA, Attenuation, Lw_lim, Lp_lim_from_source] = Sound_Propagation(UI);


