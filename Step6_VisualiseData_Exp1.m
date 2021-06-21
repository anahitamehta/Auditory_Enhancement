clc
clear all
close all
load('alldata_cleaned_PLV_64Ch_exactduration_nopad.mat')
%%
PLVamplitude = alldata;
num_sub = size(PLVamplitude,1);

mean_PLV = mean(PLVamplitude);
std_PLV = std(PLVamplitude)/sqrt(num_sub);

TMR = [-10 -5 0];

Ratio_Low_MSK = PLVamplitude(:,1:3)./PLVamplitude(:,7:9);
Ratio_High_MSK = PLVamplitude(:,4:6)./PLVamplitude(:,10:12);
Ratio_Low_ENH = PLVamplitude(:,13:15)./PLVamplitude(:,19:21);
Ratio_High_ENH = PLVamplitude(:,16:18)./PLVamplitude(:,22:24);


Enhancement_low_T = PLVamplitude(:,13:15) - PLVamplitude(:,1:3);
Enhancement_low_M = PLVamplitude(:,19:21) - PLVamplitude(:,7:9);

Enhancement_high_T = PLVamplitude(:,16:18) - PLVamplitude(:,4:6);
Enhancement_high_M = PLVamplitude(:,22:24) - PLVamplitude(:,10:12);

mean_Enh_low_T = mean(Enhancement_low_T,1);
mean_Enh_high_T = mean(Enhancement_high_T,1);

mean_Enh_low_M = mean(Enhancement_low_M,1);
mean_Enh_high_M = mean(Enhancement_high_M,1);

std_Enh_low_T = std(Enhancement_low_T,1)/sqrt(num_sub);
std_Enh_high_T = std(Enhancement_high_T,1)/sqrt(num_sub);

std_Enh_low_M = std(Enhancement_low_M,1)/sqrt(num_sub);
std_Enh_high_M = std(Enhancement_high_M,1)/sqrt(num_sub);

figure

subplot(1,2,1)
%%% cortex
%%%%%%%%%% ENH response
errorbar(TMR+0.25*ones(1,3),mean_PLV(13:15),std_PLV(13:15),'Marker','o','MarkerSize',24,...
    'MarkerFaceColor',[.85 .33 0.1],'Color',[.85 .33 0.1],'LineWidth',2,'LineStyle','-');

hold on
errorbar(TMR-0.25*ones(1,3),mean_PLV(19:21),std_PLV(19:21),'Marker','o','MarkerSize',24,...
    'MarkerFaceColor',[0 0 0],'Color',[0 0 0],'LineWidth',2,'LineStyle','-');


%%%% MSK response %%%%%%%%%%%%
hold on
errorbar(TMR+0.5*ones(1,3),mean_PLV(1:3),std_PLV(1:3),'Marker','o','MarkerSize',24,...
    'Color',[.85 .33 0.1],'LineWidth',2,'LineStyle','--');

hold on
errorbar(TMR-0.5*ones(1,3),mean_PLV(7:9),std_PLV(7:9),'Marker','o','MarkerSize',24,...
    'Color',[0 0 0],'LineWidth',2,'LineStyle','--');



set(gca,'FontSize',14,'TickDir','out','box','off','XTick',TMR,'XTickLabel',{'-10' '-5' '0'});
xlabel('Target-masker ratio (dB)','FontSize',22,'fontname','arial');
ylabel('Phase locking value','FontSize',22,'fontname','arial');
title('Low modulation frequencies','FontSize',22,'fontname','arial');
h = legend('T-ENH','M-ENH','T-MSK','M-MSK','Location','Best');
set(h,'Box','off','FontSize',12)
axis([-11 1 0 0.14]);
axis square
yticks([0 0.02 0.04 0.06 0.08 0.1 0.12 0.14 0.16])

line([-11;1],[0.05;0.05],'LineStyle',':','LineWidth',2,'Color','k');
%%%

subplot(1,2,2)
%%% subcortex
errorbar(TMR+0.25*ones(1,3),mean_PLV(16:18),std_PLV(16:18),'Marker','o','MarkerSize',24,...
    'MarkerFaceColor',[.85 .33 0.1],'Color',[.85 .33 0.1],'LineWidth',2,'LineStyle','-');

hold on
errorbar(TMR-0.25*ones(1,3),mean_PLV(22:24),std_PLV(22:24),'Marker','o','MarkerSize',24,...
    'MarkerFaceColor',[0 0 0],'Color',[0 0 0],'LineWidth',2,'LineStyle','-');


%%%% MSK response %%%%%%%%%%%%
hold on
errorbar(TMR+0.5*ones(1,3),mean_PLV(4:6),std_PLV(4:6),'Marker','o','MarkerSize',24,...
    'Color',[.85 .33 0.1],'LineWidth',2,'LineStyle','--');

hold on
errorbar(TMR-0.5*ones(1,3),mean_PLV(10:12),std_PLV(10:12),'Marker','o','MarkerSize',24,...
    'Color',[0 0 0],'LineWidth',2,'LineStyle','--');

set(gca,'FontSize',14,'TickDir','out','box','off','XTick',TMR,'XTickLabel',{'-10' '-5' '0'});
axis([-11 1 0 0.14])
xlabel('Target-masker ratio (dB)','FontSize',22,'fontname','arial');
ylabel('Phase locking value','FontSize',22,'fontname','arial');
title('High modulation frequencies','FontSize',22,'fontname','arial');
line([-11;1],[0.05;0.05],'LineStyle',':','LineWidth',2,'Color','k');
axis square
yticks([0 0.02 0.04 0.06 0.08 0.1 0.12 0.14 0.16])
%%


figure

subplot(1,2,1)
%%% cortex
b1 = errorbar(TMR+0.5*ones(1,3),mean(Ratio_Low_MSK,1),std(Ratio_Low_MSK,1)/sqrt(num_sub),'Marker','o','MarkerSize',8,...
    'MarkerFaceColor',[0 0 0],'Color',[0 0 0],'LineWidth',2,'LineStyle','--');
hold on
b2 = errorbar(TMR,mean(Ratio_Low_ENH,1),std(Ratio_Low_ENH,1)/sqrt(num_sub),'Marker','o','MarkerSize',8,...
    'MarkerFaceColor',[1 0 0],'Color',[1 0 0],'LineWidth',2,'LineStyle','-');

h = legend([b1,b2],'MSK','ENH','Location','Best');
set(h,'Box','off','FontSize',12)
set(gca,'FontSize',14,'TickDir','out','box','off','XTick',TMR,'XTickLabel',{'-10' '-5' '0'});
xlabel('TMR (dB)','FontSize',14);
ylabel('Rtarget/Rmasker','FontSize',14);
title('34,43Hz','FontSize',14);
        axis([-11 1 0.5 1.6])
%             title('Cortex','FontSize',14);
subplot(1,2,2)
%%% subcortex
errorbar(TMR+0.5*ones(1,3),mean(Ratio_High_MSK,1),std(Ratio_High_MSK,1)/sqrt(num_sub),'Marker','o','MarkerSize',8,...
    'MarkerFaceColor',[0 0 0],'Color',[0 0 0],'LineWidth',2,'LineStyle','--');
hold on

errorbar(TMR,mean(Ratio_High_ENH,1),std(Ratio_High_ENH,1)/sqrt(num_sub),'Marker','o','MarkerSize',8,...
    'MarkerFaceColor',[1 0 0],'Color',[1 0 0],'LineWidth',2,'LineStyle','-');
set(gca,'FontSize',14,'TickDir','out','box','off','XTick',TMR,'XTickLabel',{'-10' '-5' '0'});
xlabel('TMR (dB)','FontSize',14);
ylabel('Rtarget/Rmasker','FontSize',14);
title('91,98Hz','FontSize',14);
axis([-11 1 0.5 1.6])


%%%%%%%%%%%%%% enhancement %%%%%%%%%%%%%

figure

subplot(1,2,1)
%%% cortex
b1 = errorbar(TMR+0.5*ones(1,3),mean_Enh_low_M,std_Enh_low_M,'Marker','o','MarkerSize',24,...
    'MarkerFaceColor',[0 0 0],'Color',[0 0 0],'LineWidth',2,'LineStyle','-');
hold on
b2 = errorbar(TMR,mean_Enh_low_T,std_Enh_low_T,'Marker','o','MarkerSize',24,...
    'MarkerFaceColor',[1 0 0],'Color',[1 0 0],'LineWidth',2,'LineStyle','-');
line([-11;1],[0;0],'LineStyle',':','LineWidth',2,'Color','k');
h = legend([b1,b2],'Masker','Target','Location','Best');
set(h,'Box','off','FontSize',12)
set(gca,'FontSize',14,'TickDir','out','box','off','XTick',TMR,'XTickLabel',{'-10' '-5' '0'});
xlabel('TMR (dB)','FontSize',14);
ylabel('Enhancement ','FontSize',14);
title('34,43Hz','FontSize',14);
        axis([-11 1 -0.03 0.05])


subplot(1,2,2)
%%% subcortex
errorbar(TMR+0.5*ones(1,3),mean_Enh_high_M,std_Enh_high_M,'Marker','o','MarkerSize',8,...
    'MarkerFaceColor',[0 0 0],'Color',[0 0 0],'LineWidth',2,'LineStyle','-');
hold on

errorbar(TMR,mean_Enh_high_T,std_Enh_high_T,'Marker','o','MarkerSize',8,...
    'MarkerFaceColor',[1 0 0],'Color',[1 0 0],'LineWidth',2,'LineStyle','-');
set(gca,'FontSize',14,'TickDir','out','box','off','XTick',TMR,'XTickLabel',{'-10' '-5' '0'});
xlabel('TMR (dB)','FontSize',14);
ylabel('Enhancement ','FontSize',14);
title('91,98Hz','FontSize',14);
axis([-11 1 -0.03 0.05])
line([-11;1],[0;0],'LineStyle',':','LineWidth',2,'Color','k');

%%
Overall_Enhancement_Low=Enhancement_low_T - Enhancement_low_M;
Overall_Enhancement_High=Enhancement_high_T - Enhancement_high_M;
save('Overall_Enhancement_Low_Exp1','Overall_Enhancement_Low');
save('Overall_Enhancement_High_Exp1','Overall_Enhancement_High');


mean_OverallEnh_Low = mean(Overall_Enhancement_Low,1);
mean_OverallEnh_High = mean(Overall_Enhancement_High,1);

std_OverallEnh_Low = std(Overall_Enhancement_Low,1)/sqrt(num_sub);
std_OverallEnh_High = std(Overall_Enhancement_High,1)/sqrt(num_sub);
%%%%%%%%%%%%%% Overall enhancement %%%%%%%%%%%%%

figure

subplot(1,2,1)
%%% cortex
b1 = errorbar(TMR+0.5*ones(1,3),mean_OverallEnh_Low,std_OverallEnh_Low,'Marker','o','MarkerSize',24,...
    'MarkerFaceColor',[0 0 0],'Color',[0 0 0],'LineWidth',2,'LineStyle','-');
hold on
line([-11;1],[0;0],'LineStyle',':','LineWidth',2,'Color','k');
% h = legend([b1],'Masker','Target','Location','Best');
% set(h,'Box','off','FontSize',12)
set(gca,'FontSize',14,'TickDir','out','box','off','XTick',TMR,'XTickLabel',{'-10' '-5' '0'});
xlabel('Target-masker ratio (dB)','FontSize',22,'fontname','arial');
ylabel('Overall enhancement ','FontSize',22,'fontname','arial');
title('34,43Hz','FontSize',14);
        axis([-11 1 -0.03 0.05])
axis square
yticks([-0.02 -0.01 0 0.01 0.02 0.03 0.04 0.05])


subplot(1,2,2)
%%% subcortex
errorbar(TMR+0.5*ones(1,3),mean_OverallEnh_High,std_OverallEnh_High,'Marker','o','MarkerSize',24,...
    'MarkerFaceColor',[0 0 0],'Color',[0 0 0],'LineWidth',2,'LineStyle','-');
hold on

% errorbar(TMR,mean_Enh_high_T,std_Enh_high_T,'Marker','o','MarkerSize',8,...
%     'MarkerFaceColor',[1 0 0],'Color',[1 0 0],'LineWidth',2,'LineStyle','-');
set(gca,'FontSize',14,'TickDir','out','box','off','XTick',TMR,'XTickLabel',{'-10' '-5' '0'});
xlabel('Target-masker ratio (dB)','FontSize',22,'fontname','arial');
ylabel('Overall enhancement ','FontSize',22,'fontname','arial');
title('91,98Hz','FontSize',22,'fontname','arial');
axis([-11 1 -0.03 0.05])
line([-11;1],[0;0],'LineStyle',':','LineWidth',2,'Color','k');
axis square
yticks([-0.02 -0.01 0 0.01 0.02 0.03 0.04 0.05])

%%
figure;
CortexTarget(:,1)=PLVamplitude(:,1); CortexTarget(:,2)=PLVamplitude(:,13);
CortexTarget(:,3)=PLVamplitude(:,2); CortexTarget(:,4)=PLVamplitude(:,14);
CortexTarget(:,5)=PLVamplitude(:,3); CortexTarget(:,6)=PLVamplitude(:,15);

subplot(2,3,1);plot(CortexTarget(:,1:2)','o-');xlim([0.5 2.5]);ylim([0.05 0.2]); title('TMR-10 Target');set(gca,'XTick',[1 2],'XTickLabel',{'MSK' 'ENH' });
subplot(2,3,2);plot(CortexTarget(:,3:4)','o-');xlim([0.5 2.5]);ylim([0.05 0.2]); title('TMR-5 Target');set(gca,'XTick',[1 2],'XTickLabel',{'MSK' 'ENH' });
subplot(2,3,3);plot(CortexTarget(:,5:6)','o-');xlim([0.5 2.5]);ylim([0.05 0.2]); title('TMR 0 Target');set(gca,'XTick',[1 2],'XTickLabel',{'MSK' 'ENH' });

%%%%%%%%%%
CortexMasker(:,1)=PLVamplitude(:,7); CortexMasker(:,2)=PLVamplitude(:,19);
CortexMasker(:,3)=PLVamplitude(:,8); CortexMasker(:,4)=PLVamplitude(:,20);
CortexMasker(:,5)=PLVamplitude(:,9); CortexMasker(:,6)=PLVamplitude(:,21);

subplot(2,3,4);plot(CortexMasker(:,1:2)','o-');xlim([0.5 2.5]);ylim([0.05 0.2]); title('TMR-10 Masker');set(gca,'XTick',[1 2],'XTickLabel',{'MSK' 'ENH' });
subplot(2,3,5);plot(CortexMasker(:,3:4)','o-');xlim([0.5 2.5]);ylim([0.05 0.2]); title('TMR-5 Masker');set(gca,'XTick',[1 2],'XTickLabel',{'MSK' 'ENH' });
subplot(2,3,6);plot(CortexMasker(:,5:6)','o-');xlim([0.5 2.5]);ylim([0.05 0.2]); title('TMR 0 Masker');set(gca,'XTick',[1 2],'XTickLabel',{'MSK' 'ENH' });
sgtitle('Cortex - 40 Hz')

figure;
SubCortexTarget(:,1)=PLVamplitude(:,4); SubCortexTarget(:,2)=PLVamplitude(:,16);
SubCortexTarget(:,3)=PLVamplitude(:,5); SubCortexTarget(:,4)=PLVamplitude(:,17);
SubCortexTarget(:,5)=PLVamplitude(:,6); SubCortexTarget(:,6)=PLVamplitude(:,18);

subplot(2,3,1);plot(SubCortexTarget(:,1:2)','o-');xlim([0.5 2.5]); ylim([0.05 0.2]);title('TMR-10 Target');set(gca,'XTick',[1 2],'XTickLabel',{'MSK' 'ENH' });
subplot(2,3,2);plot(SubCortexTarget(:,3:4)','o-');xlim([0.5 2.5]);ylim([0.05 0.2]); title('TMR-5 Target');set(gca,'XTick',[1 2],'XTickLabel',{'MSK' 'ENH' });
subplot(2,3,3);plot(SubCortexTarget(:,5:6)','o-');xlim([0.5 2.5]);ylim([0.05 0.2]); title('TMR 0 Target');set(gca,'XTick',[1 2],'XTickLabel',{'MSK' 'ENH' });

%%%%%%%%%%
SubCortexMasker(:,1)=PLVamplitude(:,10); SubCortexMasker(:,2)=PLVamplitude(:,22);
SubCortexMasker(:,3)=PLVamplitude(:,11); SubCortexMasker(:,4)=PLVamplitude(:,23);
SubCortexMasker(:,5)=PLVamplitude(:,12); SubCortexMasker(:,6)=PLVamplitude(:,24);

subplot(2,3,4);plot(SubCortexMasker(:,1:2)','o-');xlim([0.5 2.5]);ylim([0.05 0.2]); title('TMR-10 Masker');set(gca,'XTick',[1 2],'XTickLabel',{'MSK' 'ENH' });
subplot(2,3,5);plot(SubCortexMasker(:,3:4)','o-');xlim([0.5 2.5]); ylim([0.05 0.2]);title('TMR-5 Masker');set(gca,'XTick',[1 2],'XTickLabel',{'MSK' 'ENH' });
subplot(2,3,6);plot(SubCortexMasker(:,5:6)','o-');xlim([0.5 2.5]);ylim([0.05 0.2]); title('TMR 0 Masker');set(gca,'XTick',[1 2],'XTickLabel',{'MSK' 'ENH' });
sgtitle('SubCortex - 100 Hz')


