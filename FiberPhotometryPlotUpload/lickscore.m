function [base_stim,pre_stim,post_stim,lick_matrix]=lickscore(touchlevel,SampleFrequency,TIMEarg,BOUT_TIME_THRESHOLD,MIN_LICK_THRESH)

if nargin<1
    error('did not get any data');
end
if nargin<2;
    SampleFrequency=100;
end

if nargin<3;
    TIMEarg=[2.5,2.5,10];
end
if nargin<4;
    BOUT_TIME_THRESHOLD=10;% example bout time threshold, in seconds 10s
end

if nargin<5;
    MIN_LICK_THRESH=4;% % four licks or more make a bout
end



cyan=[0.3010, 0.7450, 0.9330];

FigurePosition1=[100,100,500,500];
FigurePosition2=[700,100,500,500];

%% Sample info
SampleInterval=1/SampleFrequency;
SampleTotaltime=length(touchlevel)/SampleFrequency;
xtime=0:SampleInterval:SampleTotaltime-SampleInterval;
%% lick time
lickleveldiff=diff(touchlevel);
lickon=xtime(find(lickleveldiff==1)+1);
lickoff=xtime(find(lickleveldiff==-1)+1);
trialtotalnum=length(lickon);

figure('name','lick_level','Position',FigurePosition1);
subplot(3,1,1)
plot(xtime,touchlevel,'color',cyan);
xlim([0,xtime(end)]);

LICK_on = lickon;
LICK_off = lickoff;
LICK_x = reshape(kron([LICK_on, LICK_off], [1, 1])', [], 1);
sz = length(LICK_on);
lickdata=ones(sz,1);
d = lickdata';
LICK_y = reshape([zeros(1, sz); d; d; zeros(1, sz)], 1, []);

%% Find differences in onsets and threshold for major difference indices
lick_on_diff = diff(lickon);
%BOUT_TIME_THRESHOLD = 10; % example bout time threshold, in seconds
lick_diff_ind = find(lick_on_diff >= BOUT_TIME_THRESHOLD);

% Make an onset/ offset array based on threshold indices

diff_ind_i = 1;
for i = 1:length(lick_diff_ind)
    % BOUT onset is thresholded onset index of lick epoc event
    lick_boutson(i) = lickon(diff_ind_i);    
    % BOUT offset is thresholded offset of lick event before next onset
    lick_boutsoff(i) = lickoff(lick_diff_ind(i));    
    lick_boutsdata(i) = 1; % set the data value, arbitrary 1
    diff_ind_i = lick_diff_ind(i) + 1; % increment the index
end

% Special case for last event to handle lick event offset indexing
lick_boutson = [lick_boutson,lickon(lick_diff_ind(end)+1)];
lick_boutsoff = [lick_boutsoff,lickoff(end)];
lick_boutsdata = [lick_boutsdata, 1];

% Transpose the arrays to make them column vectors like other epocs
lick_boutson = lick_boutson';
lick_boutsoff = lick_boutsoff';
lick_boutsdata = lick_boutsdata';

%%
% Now determine if it was a 'real' bout or not by thresholding by some
% user-set number of licks in a row
%MIN_LICK_THRESH = 4; % four licks or more make a bout
licks_array = zeros(length(lick_boutson),1);
for i = 1:length(lick_boutson)
    % Find number of licks in licks_array between onset ond offset of
    % Our new lick BOUT (LICK_EVENT)
    licks_array(i) = numel(find(lickon >=lick_boutson(i) & lickon <=lick_boutsoff(i)));
end

%%
% Remove onsets, offsets, and data of thrown out events. Matlab can use
% booleans for indexing. Cool!
lick_boutson((licks_array < MIN_LICK_THRESH)) = [];
lick_boutsoff((licks_array < MIN_LICK_THRESH)) = [];
lick_boutsdata((licks_array < MIN_LICK_THRESH)) = [];
LICK_EVENT_on = lick_boutson;
LICK_EVENT_off = lick_boutsoff;
LICK_EVENT_x = reshape(kron([LICK_EVENT_on,LICK_EVENT_off],[1, 1])',[],1);
sz = length(LICK_EVENT_on);
d = lick_boutsdata';
LICK_EVENT_y = reshape([zeros(1, sz); d; d; zeros(1, sz)], 1, []);

%%
% Next step: dFF with newly defined lick bouts
% figure('name','green&lick_bounts')
subplot(3,1,2)

p1 = plot(xtime,touchlevel,'k');
hold on;
title('lick vs bouts','fontsize',8);
p2=plot(LICK_EVENT_x,LICK_EVENT_y+1,'color',cyan);
xlim([0,xtime(end)]);
legend([p1 p2],'lick-ori', 'Lick Bout');
axis tight

%%
% Making nice area fills instead of epocs for asthetics. Newer versions of
% Matlab can use alpha on area fills, which could be desirable
% figure('name','lick_bount_patch')
subplot(3,1,3)
hold on;
d_min = 1;
d_max = 2;
for i = 1:numel(lick_boutson)
    h1(i) = area([lick_boutson(i) ...
        lick_boutsoff(i)], [d_max d_max], ...
        d_min, 'FaceColor',cyan,'edgecolor', 'none');
end
p1 = plot(xtime,touchlevel,'k');
title('lick_bounts','fontsize',8);
legend([p1 h1(1)],'Lick-ori', 'Lick Bout');
ylabel('uV','fontsize',16)
xlabel('Seconds','fontsize',16);
axis tight

%% Time Filter Around Lick Bout Epocs
% Note that we are using dFF of the full time-series, not peri-event dFF
% where f0 is taken from a pre-event baseline period. That is done in
% another fiber photometry data analysis example.
BASE_TIME=TIMEarg(1);
PRE_TIME=TIMEarg(2);
POST_TIME=TIMEarg(3);
% time span for peri-event filtering, PRE and POST
TRANGE = [-1*(PRE_TIME+BASE_TIME)*floor(SampleFrequency),-1*PRE_TIME*floor(SampleFrequency),POST_TIME*floor(SampleFrequency)];

%%
% Pre-allocate memory
trials = numel(lick_boutson);
lick_snips = cell(trials,1);
Base_snips=cell(trials,1);
array_ind = zeros(trials,1);
pre_stim = zeros(trials,1);
post_stim = zeros(trials,1);
%%
% Make stream snips based on trigger onset
for i = 1:trials
    % If the bout cannot include pre-time seconds before event, make zero
    if lick_boutson(i) < (PRE_TIME+BASE_TIME)
        lick_snips{i} = single(zeros(1,(TRANGE(3)-TRANGE(1))));
        continue
    else
        % Find first time index after bout onset
        array_ind(i) = find(xtime > lick_boutson(i),1);
        
        % Find index corresponding to pre and post stim durations
        base_stim(i)=array_ind(i) + TRANGE(1);
        pre_stim(i) = array_ind(i) + TRANGE(2);
        post_stim(i) = array_ind(i) + TRANGE(3);
        lick_snips{i} = touchlevel(base_stim(i):post_stim(i))';
        Base_snips{i}=touchlevel(base_stim(i):pre_stim(i))';               
    end
end

%%
% Make all snippet cells the same size based on minimum snippet length
minLength = min(cellfun('prodofsize', lick_snips));
lick_snips = cellfun(@(x) x(1:minLength), lick_snips, 'UniformOutput',false);
% Convert to a matrix and get mean
lick_matrix = cell2mat(lick_snips);
mean_lick = mean(lick_matrix);

% Make a time vector snippet for peri-events
peri_time = (1:length(mean_lick))/SampleFrequency - (PRE_TIME+BASE_TIME);

%% Make a Peri-Event Stimulus Plot and Heat Map

% Make a standard deviation fill for mean signal
figure('name','Peri-Event','Position',FigurePosition2)

% Plot the line next
subplot(2,1,1)
p1 = plot(peri_time, lick_matrix','color',[0.7, 0.7, 0.7],'LineWidth', 1);
hold on;
p2 = plot(peri_time, mean_lick, 'color', cyan, 'LineWidth', 3);
hold off;
% Make a legend and do other plot things
legend([p1(1), p2],...
    {'Lick Traces','Mean Lick'},'Location','northeast');
title('Peri-Event Lick','fontsize',8);
ylabel('level','fontsize',8);
axis tight;
% Make an invisible colorbar so this plot aligns with one below it

% Heat map
subplot(2,1,2)
imagesc(peri_time, 1, lick_matrix); % this is the heatmap
set(gca,'YDir','normal') % put the trial numbers in better order on y-axis
colormap(1-gray) % colormap otherwise defaults to perula
title('Lick Bout Heat Map','fontsize',8)
ylabel('Trial Number','fontsize',8)
xlabel('Seconds from lick onset','fontsize',16)
axis tight;