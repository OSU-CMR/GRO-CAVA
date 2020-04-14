clear;
close all;
% Author: Rizwan Ahmad (ahmad.46@osu.edu)
% Last modified Apr-14-2020
% For more information, visit https://cmr.engineering.osu.edu/software/data-acquisition 


%% Input paramters
param.n   = 18;   % Number of phase encoding (PE) lines per frame
param.FR  = 64;   % Frames
param.PE  = 160;  % Size of of PE grid
param.E   = 1;    % Number of encoding, E=1 for cine, E=2 for flow (phase-contrast MRI)
param.PF  = 0;   % for partial fourier; discards PF samples from one side (default: 0, range: 0-floor(n/2), precision: 1);
param.ir  = 1;   % ir = 1 or 2 for golden angle, ir > 2 for tiny golden angles; default value: 1
param.k   = 3;   % k>=1. k=1 uniform; k>1 variable density profile; larger k means flatter top (default: 3)
param.s   = 2;   % s>=0; % largers s means higher sampling density in the middle (default: 2, range: 0-10, precision: 0.1)
param.dsp = 1;   % Display pattern after reach frame, '0' for no, and '1' for yes

%% Outputs
% samp: Binary sampling pattern on param.PE x param.FR x param.E grid
% PEInd: Sorted indices of sampled phase-encoding lines on (param.n x param.FR) x param.PE


%% generating sampling mask and indices
disp('For faster computation, turn the display (param.dsp) off');
[samp, PEInd] = gro_fun(param);
disp('For retrospecting downsampling use the binary mask "samp"'); 
disp('To collect the data using the samping pattern, use PEInd. The entries in PEInd are sorted to minimize k-space jumps');
