close all;clear all;clc

TMR_levels={'0' '-5' '-10'};

cond={'MSK' 'ENH'};

% subnum=input('Subject number ');
currentpath = cd;
for ii=[1:18] % for the subject numbers
    for jj = 1:3 %% three TMR
        for kk=1:2  %% two conditions: MSK and ENH
            [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
            filepath=[cd '\Sub' num2str(ii) '_LF\'];
            
            filename=[filepath 'Sub' num2str(ii) '_TMR' TMR_levels{jj} '_' cond{kk} '.bdf'];
            EEG = pop_biosig(filename);
            
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off');
            EEG = eeg_checkset( EEG );
            EEG = pop_resample( EEG, 1024);
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
            EEG = pop_eegfiltnew(EEG, 1,100,3380,0,[],1); %filters from 1-100 Hz.
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off');
            EEG = eeg_checkset( EEG );
            EEG = pop_reref( EEG, [65 66] );  %%%%%%%%% 64 channels %%%%%%%%%%%%%55
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'gui','off');
            EEG = eeg_checkset( EEG );
            EEG = pop_select( EEG,'nochannel',{'EXG3' 'EXG4' 'EXG5' 'EXG6' 'EXG7' 'EXG8'});
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'gui','off');
            EEG = eeg_checkset( EEG );
            eeglab redraw
            %%
            if kk==1
                ll=-0.1;mm=0.7; %MSK
            elseif kk==2
                ll=-0.1;mm=1.1; %ENH
            end
            EEG = pop_epoch( EEG, {  '1'  '2'  }, [ll         mm], 'newname', 'BDF file resampled epochs', 'epochinfo', 'yes');
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 5,'gui','off');
            EEG = eeg_checkset( EEG );
            EEG = pop_rmbase( EEG, [-99.6094            0]);
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 6,'gui','off');
            EEG = eeg_checkset( EEG );
            filename2=['Sub' num2str(ii) '_TMR' (TMR_levels{jj}) '_' cond{kk} '.set'];
            
            EEG = pop_saveset( EEG, 'filename',filename2,'filepath',filepath);
            [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
            eeglab redraw;
            trigger=cell2mat({ALLEEG(7).event.type});
            Merged_Data=ALLEEG(7).data;
            filename3=['Sub' num2str(ii) '_LF_TMR' (TMR_levels{jj}) '_' cond{kk} '.mat'];
            savingfilename=[filepath filename3];
            save(savingfilename,'Merged_Data','trigger');
        end
    end
end

