function[samp, PEInd] = gro_fun(param)
% Author: Rizwan Ahmad (ahmad.46@osu.edu)


n   = param.n;   % Number of phase encoding (PE) lines per frame
FR  = param.FR;   % Frames
PE  = param.PE;  % Size of of PE grid
E   = param.E;    % Number of encoding, E=1 for cine, E=2 for flow
ir  = param.ir;
PF  = param.PF;
s   = param.s;
k   = param.k;
dsp = param.dsp;

gr = (1+sqrt(5))/2; % golden ratio
ga = 1/(gr+ir-1); % golden angle, sqrt(2) works equally well
% R  = PE/(n+PF); % Acceleration
% s  = max(1, s*(R).^(1/3)); % This is to adapt the value of's' based on acceleration. This line can be commented out.


%% Size of the smaller pseudo-grid which after stretching gives the true grid size
PES = ceil(PE * 1/s); % Size of shrunk PE grid
vd = (PE/2-PES/2)/((PES/2)^k); %(1/2*(n-PES)/max(tmp)); % location specific displacement

samp  = zeros(PE, FR, E); % sampling on PE-t grid
PEInd = zeros((n-PF)*FR,E); % The ordered sequence of PE indices


% figure;
v0 = (1/2+1e-10:PES/(n+PF):PES+1/2-1e-10); % Start with uniform sampling for each frame
for e=1:E
    v0 = v0 + 1/E*PES/(n+PF); % Start with uniform sampling for each frame
    kk=E+1-e;
    for j=1:FR
        v = rem((v0 + (j-1)*PES/(n+PF)*ga)-1, PES) + 1; % In each frame, shift by golden shift of PES/TR*ga
        v = v - PES.*(v>=(PES+0.5));

        if rem(PE,2)==0 % if even, shift by 1/2 pixel
            vC = v - vd*sign((PES/2+1/2)-v).*(abs((PES/2+1/2)-v)).^k + (PE-PES)/2 + 1/2;%(ctrn - ctrnS);
            vC = vC - PE.*(vC>=(PE+0.5));
        elseif rem(PE,2)==1 % if odd don't shift
            vC = v - vd*sign((PES/2+1/2)-v).*(abs((PES/2+1/2)-v)).^k + (PE-PES)/2;%(ctrn - ctrnS);
        end
        vC = round(sort(vC));
        vC(1:PF) = [];

        if rem(j,2) == 1
            PEInd((j-1)*n + 1 : j*n, e) = vC;
        else
            PEInd((j-1)*n + 1 : j*n, e) = flip(vC);
        end

        samp(vC, j, e) = samp(vC, j, e)+ kk;
        if dsp ==1
            figure(1);
            subplot(1,E,e); imagesc(samp(:,:,e),[0,E]); xlabel('frames'); ylabel('PE'); axis('image'); colormap(hot); title(['encoding ' num2str(e)]); %axis('image'); 
            pause(1e-3);
        end
        
    end
end
figure; imagesc(max(samp,[],3)); axis('image'); ylabel('PE'); axis('image'); colormap(hot); title('encodings superimposed');

