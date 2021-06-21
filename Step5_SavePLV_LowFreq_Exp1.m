clc
clear all
close all
alldata = [];

for ii = [1:18] %subject number
    clear finalstring

    TMR_levels=[-10 -5 0];
    
    cond={'MSK' 'ENH'};
    
    
    PLV_target = [];
    PLV_masker = [];
    
    for jj = 1:2
        for nn = 1:3
            clear PeakPLVTarget
             filename = [cd '\Sub' num2str(ii) '\Sub' num2str(ii) '_TMR' num2str(TMR_levels(nn)) '_' cond{jj} ...
                    '_cleaned_PLV_64Ch_exactduration_nopad.mat'];
                load(filename);
            
            PLV_target = [PLV_target; PeakPLVTarget(1,:)];
            PLV_masker = [PLV_masker; PeakPLVTarget(2,:)];
        end
    end
    
    finalstring = [PLV_target(1:3,1)' PLV_target(1:3,2)' PLV_masker(1:3,1)' PLV_masker(1:3,2)'...
        PLV_target(4:6,1)' PLV_target(4:6,2)' PLV_masker(4:6,1)' PLV_masker(4:6,2)'];
    
    alldata = [alldata;finalstring];
end

save('alldata_cleaned_PLV_64Ch_exactduration_normwindow_nopad_2.mat','alldata')

