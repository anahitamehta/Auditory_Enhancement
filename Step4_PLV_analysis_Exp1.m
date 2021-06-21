%% PLV_ContinuousFFR
%  This script calculates the PLV values AFTER preprocessing.
% The calculation is according to the Zhu et al 2013
% The preprocessing script will save the data into a mat file with two
% matrices: Merged_Data (which is in the format of channels x data x
% trials) and trigger which is the trigger value for each trial.
clc
clear all
close all

%%%%%%%%%%% Modified by Anahita Mehta 4/2/2021

currentpath=cd;
conditions = {'MSK','ENH'};
TMR ={'0' '-5' '-10'};

fmod = [43.43 98.28; 34.28 91.42];

for num_sub = [1:18] %7:17
    
    filepath = [cd '\Sub' num2str(num_sub) '\'];
    for n_cond = 1:2
        for n_level = 1:3
            
            filename = ['Sub' num2str(num_sub) '_TMR' num2str(TMR{n_level}) '_' conditions{n_cond} '_cleaned.mat'];
            
            load([filepath filename]);%load file
            
            dummy_ind = strfind(filename,'_');
            
            condition = conditions{n_cond};%filename(dummy_ind(2)+1:dummy_ind(2)+3);
            
            target_ind = 1; %%%%%%%%%%%%%%% 1: response to target; 0: response to masker
            record_ch = 64; %number of channels
            
            savefilename = [filename(1:end-4) '_PLV_64Ch_exactduration_nopad.mat'];% make saving file name if you want to save file
            
            Fs = 1024;% sampling frequency
            
            PosList_allCh = [];% initiate matrix for all positive polarity data
            NegList_allCh = [];% initiate matrix for all negative polarity data
            
            PosTrig = find(trigger == 1); % find all the indices for trigger 1
            NegTrig = find(trigger == 2);% find all the indices for trigger 2
            
            n_epoch = size(Merged_Data,3);
            
            n_pos = length(PosTrig);
            n_neg = length(NegTrig);
            
            duration = 437.52;% tone duration
            switch lower(condition)
                case 'msk'%%% change the  start time
                    signal_start = round((100)/1000*Fs);%1;
                     signal_end = round(signal_start+(duration/1000*Fs));%size(Merged_Data,2);
%                       
                    PosMatrix_Low = Merged_Data(1:record_ch,signal_start:signal_end,PosTrig); % Should be (32*channels *data * trials )
                    NegMatrix_Low = Merged_Data(1:record_ch,signal_start:signal_end,NegTrig); %
                case 'enh'
                    signal_start = round((100 + duration + 10)/1000*Fs);
                     signal_end = round(signal_start+(duration/1000*Fs));%size(Merged_Data,2);
                    
                    
                    PosMatrix_Low = Merged_Data(1:record_ch,signal_start:signal_end,PosTrig); % Should be (32*channels *data * trials )
                    NegMatrix_Low = Merged_Data(1:record_ch,signal_start:signal_end,NegTrig); %
                    
                    
            end
           
            %%%%%%%%%%%%%%%%%%%%% Compute PLV for each channel %%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            goodchannels=[1:64];%I
            
            for n_Ch = 1:length(goodchannels)
                
                Ch = goodchannels(n_Ch);
                fprintf(1,'/n Computing channel %d !',Ch);
                
                Pos_list_Low = PosMatrix_Low(Ch,:,:);
                Neg_list_Low = NegMatrix_Low(Ch,:,:);
                
                %%%%%%%%%%%%%%%%%%%
                %%% Compute PLV %%%
                %%%%%% LOW %%%%%%%%
                %%%%%%%%%%%%%%%%%%%
                L = size(PosMatrix_Low, 2);
                Nfft = 2^nextpow2(L);
                
                N = (Nfft/2);
                % this is just to get the value of frequencies within 1-120
                fpass = [1 100]; %%%%%%%%%%%%% Hz for high freq
                
                f = (0:(N-1))*Fs/(2*N);
                Npass = ceil(N*fpass(1)/(Fs/2)):ceil(N*fpass(2)/(Fs/2));
                f_Low = f(Npass);
                
                %% Compute Sleppian Window
                K = 2;  % Sleppian order
                [Sleps, conc] = dpss(L,1,K);
                Sleps2=Sleps/max(Sleps);
                           
                %% Create bootstrapping variables
                
                Poslist_Low = 1:size(PosMatrix_Low,3); % Number of trials avaialable in positive polarity
                Neglist_Low = 1:size(NegMatrix_Low,3); % Number of trials avaialable in negative polarity
                
                
                NtrialsPLV = 200;% 200 trials at a time
                Ndraw = 100;%100 draws with 200 trials each time
                
                for n = 1: Ndraw
                    bootdraw_pos(n, :) = randsample(Poslist_Low, NtrialsPLV,true); %indexing which trials per draw you are going to take
                    bootdraw_neg(n, :) = randsample(Neglist_Low, NtrialsPLV,true);
                end
                
                PLV_pos_Low = zeros(Ndraw,numel(Npass));%just to fill the matrix
                PLV_neg_Low = zeros(Ndraw,numel(Npass));
                
                %% For each of 100 draws, process 400 random trials (200 per polarity)
                for k = 1:Ndraw
                    
                    
                    x = squeeze(Pos_list_Low);
                    xx = squeeze(Neg_list_Low);
                    
                    % next three lines are for creating a 200 trial matrix and
                    % windowing it
                    w = permute(repmat(Sleps2(:,K),1,NtrialsPLV),[2 1]);
                    wx = x(:,bootdraw_pos(k,:))'.*w;% indexing the 200 trials randomly chosen
                    wxx = xx(:,bootdraw_neg(k,:))'.*w;
                                    
                    clear w;
                    
                    Sx = fft(wx,Nfft,2);% for positive
                    %                     size(Sx)
                    Sxx = fft(wxx,Nfft,2);% for negative
                    pmtm(Sx(1,:),2,Nfft)
                    clear wx; clear wxx;
                    clear wy; clear wyy;
                    
                    Sx = Sx(:,Npass); % positive
                    Sxx = Sxx(:,Npass); % negative %% Npass is the frequencies in the pass band defined earlier
                    
                    Senv = [Sx; Sxx];  % one big group
                    %                     size(Senv)
                    PLV_env(k,:) = squeeze(abs(mean(exp(1i*unwrap(angle(Senv))),1)));% Here we calculate the PLV averaging across positive and negative polarities
                    
                    fprintf(1,'\n Done with %d Draws in LOW computation!',k);
                    
                end
                
                PLVenv_Low(n_Ch, :) = mean(PLV_env,1);
                %                 figure(1)
                %                 plot(f_Low, PLVenv_Low(n_Ch,:)); hold on
                %
                
                clear Sx Sxx Senv PLV_env
                
                
                % plot(f_High, PLVenv_High(chan,:)); hold on
                
                clear Sx Sxx Senv PLV_env
                
            end %% Channel
            
            figure
            env_ave = mean(PLVenv_Low,1);%mean across all channels
            
            plot(f_Low,env_ave);
            
            hold on
            line([f_Low(1);f_Low(end)],[0.05;0.05],'LineStyle',':','LineWidth',2) %% this is for the noise floor
            
            fmod = [43.43 98.28; 34.28 91.42];
            
            PeakPLV = searchpeaks(env_ave,f_Low,fmod);
            
            PLVenv_Target = PLVenv_Low;
            PeakPLVTarget = PeakPLV;
            if exist([filepath savefilename])
                save([filepath savefilename], 'PLVenv_Target', 'f_Low', 'PeakPLVTarget','env_ave','-append');
            else
                save([filepath savefilename], 'PLVenv_Target', 'f_Low', 'PeakPLVTarget','env_ave');
            end
            
        end
    end
end
