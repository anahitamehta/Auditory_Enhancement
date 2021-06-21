
close all
clear all
clc
TMR_levels=[-5 -10 0];
cond={'MSK' 'ENH'};
%  subnum=input('Subject number ');
currentpath = cd;
for ii= [1:18]%subnum % subject numbers
    for jj=1:3
        for kk=1:2
            [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
filepath = [cd '\Sub' num2str(ii) '_LF\'];
%             filepath=['M:\Lab_Shared\PuiYii\EnhancementEEG_HighFreq\Sub' num2str(ii)];
            filename=['Sub' num2str(ii) '_TMR' num2str(TMR_levels(jj)) '_' cond{kk} '.set'];
            EEG = pop_loadset('filename',filename,'filepath',filepath);
            [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
            EEG = eeg_checkset( EEG );
%             EEG = pop_select( EEG,'nochannel',{'EXG3' 'EXG4' 'EXG5' 'EXG6' 'EXG7' 'EXG8'}); %comment if doesnt work
%             [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');%comment if doesnt work
            EEG=pop_chanedit(EEG, 'lookup','C:\\Users\\mehta\\Desktop\\eeglab14_1_1b\\plugins\\dipfit2.3\\standard_BESA\\standard-10-5-cap385.elp','load',{'M:\\Lab_Shared\\PuiYii\\EnhancementEEG\\ChanLocs2.ced' 'filetype' 'autodetect'});
%             EEG=pop_chanedit(EEG, 'lookup',[cd '\eeglab14_1_1b\plugins\dipfit2.3\standard_BESA\standard-10-5-cap385.elp'],'load',{['M:\Lab_Shared\PuiYii\EnhancementEEG_HighFreq\ChanLocs2.ced'] 'filetype' 'autodetect'});
            [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
            EEG = eeg_checkset( EEG );
            EEG = pop_runica(EEG, 'extended',1,'interupt','on');
            [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
            EEG = eeg_checkset( EEG );
            saveset_filename=['Sub' num2str(ii) '_LF_TMR' num2str(TMR_levels(jj)) '_' cond{kk} 'withICA.set'];
            EEG = pop_saveset( EEG, 'filename',saveset_filename,'filepath',filepath);
            [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
            eeglab redraw;
        end
    end
end

