clear;
close all;
% Author: Rizwan Ahmad (ahmad.46@osu.edu)
% Last modified Apr-14-2020
% Publication: https://onlinelibrary.wiley.com/doi/abs/10.1002/mrm.28059


%% Essential paramters
param.n   = 6;   % readouts per frame--can be changed retrospectively
param.FR  = 36;  % Number of frames--can be changed retrospectively
param.PE  = 120;  % Size of PE grid
param.E   = 2;   % Number of encoding, E=1 for cine, E=2 for flow (phase-contrast MRI)
param.ir  = 1;   % ir = 1 or 2 for golden angle, ir > 2 for tiny golden angles; default value: 1
param.k   = 3;   % k>=1. k=1 uniform; k>1 variable density profile; larger k means flatter top (default: 3)
param.s   = 2;   % s>=0; % largers s means higher sampling density in the middle (default: 2, range: 0-10, precision: 0.1)
param.dsp = 1;   % Display patter after reach sample


%% Outputs
% samp: Binary sampling pattern on param.PE x param.FR x param.E grid
% PEInd: Sorted indices of sampled phase-encoding lines on (param.n x param.FR) x param.PE


%% generating sampling mask and indices
disp('For faster computation, turn the display (param.dsp) off');
[samp, PEInd] = cava_fun(param);
disp('For retrospecting downsampling use the binary mask "samp"'); 
disp('To collect the data using the samping pattern, use PEInd. The PEInd can be retrospectively sorted into bins of different sizes');

