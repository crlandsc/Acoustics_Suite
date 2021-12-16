% 'RH_Window' windows an Impulse Response according to a start and end
% point as defined by the user
% 
% Usage: [IR_Windowed, Envelop] = RH_Window(IR,Start,Plateau_End,End)
% 
% INPUTS:
% IR = Impulse response
% Start = Index at the start of the IR (preceeding this index, all values
%         will become zeros
% Plateau_End = Index of IR where the windowing is desired to begin
%               (preceeding this index, after the start of the IR, all
%               values of the IR will remain unchanged)
% End = Index of the IR where the windowing is desired to end (proceeding
%       this, all values will become zeros)
% 
% OUTPUTS:
% IR_Windowed = The windowed impulse response
% Envelop = (optional) The envelop used to window the impulse response
% 
% Christopher Landschoot - 2018
% 
function [IR_Windowed, Envelop] = RH_Window(IR,Start,Plateau_End,End)

% Check to see if IR is a row or column vector. If needed, converts to row vector
row_or_column_vector = size(IR);
if row_or_column_vector(1) > 1
    IR = IR';
end

sigLen = length(IR); % Defines signal length of input IR
BH_len = End - Plateau_End; % Defines length of Blackman-Harris window
BH = blackmanharris(2*BH_len); % Creates Blackman_Harris Window
BH = BH'; % Must be a row vector

Right_Half = BH(BH_len+1:end); % Limits the BH window to just the right half
Before = zeros(1,Start); % Adds the time before the IR
Plateau = ones(1,Plateau_End-Start); % Adds the time after the start of the IR,
                                     % but before the window (to be unchanged)
After = zeros(1,sigLen-End); % Adds the time after the window (to be 0)
Envelop = [Before Plateau Right_Half After]; % Compiles the envelop of the right half window
IR_Windowed = IR .* Envelop; % Windows the IR

end
