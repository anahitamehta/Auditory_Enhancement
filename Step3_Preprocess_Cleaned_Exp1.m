close all
clear all
clc

TMR_levels=[0 -5 -10];
cond={'MSK' 'ENH'};
subnum=[1:18];%input('Subject number ');
currentpath = cd;
for ii=subnum % for the subject numbers
    for jj=1:3
        for kk=1:2
            [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
            filepath=[cd '\Sub' num2str(ii) '\'];
% filepath = ['M:\Lab_Shared\Lei\Enhancement_EEG\Final_Test_Data\Sub' num2str(ii) '\'];
            filename=[filepath 'Sub' num2str(ii) '_TMR' num2str(TMR_levels(jj)) '_' cond{kk} 'withICA_cleaned.set'];
            savefilename=[filepath 'Sub' num2str(ii) '_TMR' num2str(TMR_levels(jj)) '_' cond{kk} '_cleaned.mat'];
            EEG = pop_loadset(filename);
            Merged_Data=EEG.data;
            trigger=cell2mat({EEG.event.type});
            save(savefilename,'Merged_Data','trigger');
        end
    end
end
eeglab redraw


