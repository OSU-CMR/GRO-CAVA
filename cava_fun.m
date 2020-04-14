function[samp, PEInd] = cava_fun(param)
% Author: Rizwan Ahmad (ahmad.46@osu.edu)


n   = param.n;   % Number of phase encoding (PE) lines per frame
N   = param.FR*n;   % Total number of samples
PE  = param.PE;  % Size of of PE grid
E   = param.E;   % Number of encoding, E=1 for cine, E=2 for flow
ir  = param.ir;
s   = param.s;
k   = param.k;
dsp = param.dsp;


% R  = PE/n; % Initial guess of acceleration
% s  = max(1, s*(R).^(1/3));  % This is to adapt the value of's' based on acceleration.

gr = (1+sqrt(5))/2; % golden ratio F_{PE+1}/F_{PE}
ga = 1/(gr+ir-1); %(1-1/gr); % golden angle 
PES = ceil(PE * 1/s); % Size of shrunk PE grid

%% Size of the smaller pseudo-grid which after stretching gives the true grid size
c = (PE/2-PES/2)/((PES/2)^k); %(1/2*(PE-PES)/max(tmp)); % location specific displacement


%% Let's populate the grid;
samp  = zeros(PE, ceil(N/n), E); % sampling on PE-t grid
PEInd = zeros(N,E); % Final PE index used for MRI

ind = zeros(N,E); % "hidden" index on a uniform grid
for e=1:E
    kk=e;
    for i=1:N
%         if i==1,     ind(i,e) = rem(floor(PES/2) + 1 + (e-1)*PES/(E*1) -1, PES) + 1;
%         if i==1,     ind(i,e) = rem(floor(PES/2) + 1 + (e-1)*ga*PES/(E*1) -1, PES) + 1;
        if i==1,     ind(i,e) = rem(floor(PES/2) + 1 + (e-1)*sqrt(11)*ga*PES/E -1, PES) + 1;
        elseif i>1,  ind(i,e) = rem((ind(i-1,e) + PES*ga)-1, PES) + 1;
        end
        ind(i,e) = ind(i,e) - PES.*(ind(i,e)>=(PES+0.5));

        if rem(PE,2)==0 % if even, shift by 1/2 pixel
            indC = ind(i,e) - c*sign((PES/2+1/2)-ind(i,e))*(abs((PES/2+1/2)-ind(i,e))).^k + (PE-PES)/2 + 1/2;%(ctrn - ctrnS);
            indC = indC - PE.*(indC>=(PE+0.5));
        elseif rem(PE,2)==1 % if odd don't shift
            indC = ind(i,e) - c*sign((PES/2+1/2)-ind(i,e))*(abs((PES/2+1/2)-ind(i,e))).^k + (PE-PES)/2;%(ctrn - ctrnS);
        end 
    %     kk = (-1)^i;
       PEInd(i,e) = round(indC);
       samp(PEInd(i,e), ceil(i/n),e) = samp(PEInd(i,e), ceil(i/n),e)+ kk;
       if dsp ==1
           figure(1)
           subplot(1,E,e); imagesc(samp(:,:,e),[0,E]);xlabel('frames'); ylabel('PE'); axis('image'); colormap(hot); title(['encoding ' num2str(e)]); %axis('image'); 
           pause(1e-3);
       end
    end
end
figure; imagesc(max(samp,[],3)); axis('image'); ylabel('PE'); axis('image'); colormap(hot); title('encodings superimposed');


