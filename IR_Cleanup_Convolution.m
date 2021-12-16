% General Convolution & Cleanup
% This file was created for the convenience of cleaning up IRs and then
% convolving them with anechoic audio. Not as well documented as other 
% code and functions, so use at your own risk.

clear all; close all; clc;

% Add paths for functions and audio
addpath('C:\Users\[NAME]\Documents\Audio\');
addpath('C:\Users\[NAME]\Documents\Matlab\FUNCTIONS\')


Active_Folder = 'C:\Users\[NAME]\Documents\ACTIVE_FOLDER\';
Save_Folder_Name = 'Trimmed Audio\';
Save_Location = strcat(Active_Folder,Save_Folder_Name);
mkdir(Save_Location)
Save_File = 'SAVE_FILENAME.wav';


% Load IR to clean up
Load_filename = 'IR_AUDIO.wav';
[IR,fs] = audioread(Load_filename);
IR = IR'; % Transpose IR for calculations

% Rename Impulse Response for convenience
% IR = data;

[PNR, SNR] = PNR_SNR(IR,fs);

Start = 11880;
Plateau_End = 60000;
End = 100000;
[IR_Windowed, Envelop] = RH_Window(IR,Start,Plateau_End,End);


%% Plot
figure;
subplot(3,1,1)
plT(IR,fs,1,1);
axis([0 4 -inf inf]);
title('Untrimmed')

subplot(3,1,2)
plT(Envelop,fs,1,1);
axis([0 4 -inf 1.1]);
title('Envelop')

subplot(3,1,3)
plT(IR_Windowed,fs,1,1);
axis([0 4 -inf inf]);
title('Trimmed')


%% Convolve

% Load IR to clean up
Load_Anechoic = 'ANECHOIC_AUDIO.wav';
[Anechoic,fs] = audioread(Load_Anechoic);
Anechoic = Anechoic';

Zero_Pad = size(Anechoic,2);% + size(IR_Windowed,2);
IR_len = size(IR_Windowed,2);
Anechoic = [Anechoic zeros(1,IR_len)];

IR_freq = fft([IR_Windowed zeros(1,Zero_Pad)]);
Anechoic_freq = fft(Anechoic);

freq_multiply = IR_freq.*Anechoic_freq;


Convolved_Audio_Matlab = conv(IR_Windowed,Anechoic);
Convolved_Audio_Manual = ifft(freq_multiply);

figure;
subplot(3,1,1)
plT(Anechoic,fs,1,1);
xlim([0 35]);
title('Anechoic Audio')

subplot(3,1,2)
plT(Convolved_Audio_Matlab,fs,1,1);
xlim([0 35]);
title('Matlab Convolution')

subplot(3,1,3)
plT(Convolved_Audio_Manual,fs,1,1);
xlim([0 35]);
title('Manual Convolution')

%{
% Save audio for convenience & testing
Active_Folder = 'C:\Users\[NAME]\Documents\[SAVE_FOLDER]';
Save_Folder_Name = '180927 - Convolution Test';
Save_Location = strcat(Active_Folder,Save_Folder_Name);
mkdir(Save_Location)

Convolved_Audio_Matlab = Convolved_Audio_Matlab / max(Convolved_Audio_Matlab);
Convolved_Audio_Manual = Convolved_Audio_Manual / max(Convolved_Audio_Manual);

audiowrite(strcat(Save_Location,'\','Anechoic.wav'),Anechoic,fs);
audiowrite(strcat(Save_Location,'\','Matlab Convolution.wav'),Convolved_Audio_Matlab,fs);
audiowrite(strcat(Save_Location,'\','Manual Convolution.wav'),Convolved_Audio_Manual,fs);
%}



