figure('Position', [10, 10, 1000, 800])

%Data from running  simulation_2.m  using the (3,1,2) code in  encoder1.m
%this is in "data_from_simulation_2.txt" with the "bad channel" namely:
%P(1,1)=0.4;   %P[ri=A|si=0]
%P(2,1)=0.3;   %P[ri=B|si=0]
%P(3,1)=0.2;   %P[ri=C|si=0]
%P(4,1)=0.1;   %P[ri=D|si=0]
%P(1,2)=0.1;   %P[ri=A|si=1]
%P(2,2)=0.2;   %P[ri=B|si=1]
%P(3,2)=0.3;   %P[ri=C|si=1]
%P(4,2)=0.4;   %P[ri=D|si=1]
%
BEP=[0.24234683333333 0.333138833333333  0.38524591666666  0.4032140 0.412149833333333  0.41750186666666 ];
SEP=[0.6322800  0.90366500  0.993512000  0.999535000  0.9999670 0.99999800 ];
CCP=[602546/999999  377918/999999  237652/999999  187650/999999  159579/999999  141123/999999 ];
ACCP=[(109490 + 602546 + 240205)/999999  (181476 + 377918 + 260125)/999999  (179683 + 237652 + 209750)/999999  (157906 + 187650 + 174030 )/999999  (140487 + 159579 + 153176)/999999  (126552 + 141123 + 137774)/999999 ];

BCP=1-BEP;
SCP=1-SEP;
bits=[6 12 24 36 48 60];

subplot(2, 2, 1);
plot(bits, BCP, '-x', bits, SCP, '-o', bits, CCP, '-+', bits, ACCP, '-.', 'LineWidth', 3, 'MarkerSize', 10);
set(gca, 'LineWidth', 2, 'TickLength', get(gca, 'TickLength').*2);
grid;
axis square;
title({'Simple Encoder', 'More-dispersive Channel'}, 'FontSize', 12, 'FontName', 'Arial');
xlabel('# of object bits (KM)', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Performance', 'FontSize', 12, 'FontName', 'Arial');
legend({'BCR', 'SCR','CCR', 'ACCR'},'Location', 'EastOutside', 'FontSize', 12, 'FontName', 'Arial');
%semilogy(bits, BCP, '-x', bits, SCP, '-o')


%Data from running  simulation_2.m  using the (3,1,2) code in  encoder1.m
%this is in "data_from_simulation_2.txt" with the "better channel" namely:
%P(1,1)=0.65;  %P[ri=A|si=0]
%P(2,1)=0.2;   %P[ri=B|si=0]
%P(3,1)=0.1;   %P[ri=C|si=0]
%P(4,1)=0.05;  %P[ri=D|si=0]
%P(1,2)=0.05;  %P[ri=A|si=1]
%P(2,2)=0.1;   %P[ri=B|si=1]
%P(3,2)=0.2;   %P[ri=C|si=1]
%P(4,2)=0.65;  %P[ri=D|si=1]
%
BEP=[0.06801766666   0.11133075  0.14393970833  0.15533738888  0.1615204791666   0.165073916666];
SEP=[0.17062600    0.3470690   0.595177  0.748878  0.8440220  0.9033410];
CCP=[0.91106791106  0.81437881437  0.65953065953065  0.5478015478015  0.46757546757546  0.40882840882840];
ACCP=[0.9963989963989 0.98638498638498   0.9565949565949  0.91751791751791  0.875840875840876  0.83389183389183];

BCP=1-BEP;
SCP=1-SEP;
bits=[6 12 24 36 48 60];

subplot(2, 2, 2);
plot(bits, BCP, '-x', bits, SCP, '-o', bits, CCP, '-+', bits, ACCP, '-.', 'LineWidth', 3, 'MarkerSize', 10);
set(gca, 'LineWidth', 2, 'TickLength', get(gca, 'TickLength').*2);
grid;
axis square;
title({'Simple Encoder', 'Less-dispersive Channel'}, 'FontSize', 12, 'FontName', 'Arial');
xlabel('# of object bits (KM)', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Performance', 'FontSize', 12, 'FontName', 'Arial');
legend({'BCR', 'SCR','CCR', 'ACCR'},'Location', 'EastOutside', 'FontSize', 12, 'FontName', 'Arial');

%===============================This was using the Matlab "vitdec()" function with hard-decoding (begin)===============

%Data from running  "simulation_3.m" with the (3,1,8) code in Table 11.1(b) on page 330 of Lin+Costello
%this is in "data_from_simulation_2.txt" with the "bad channel" namely:
%P(1,1)=0.4;   %P[ri=A|si=0]
%P(2,1)=0.3;   %P[ri=B|si=0]
%P(3,1)=0.2;   %P[ri=C|si=0]
%P(4,1)=0.1;   %P[ri=D|si=0]
%P(1,2)=0.1;   %P[ri=A|si=1]
%P(2,2)=0.2;   %P[ri=B|si=1]
%P(3,2)=0.3;   %P[ri=C|si=1]
%P(4,2)=0.4;   %P[ri=D|si=1]
%
% BEP=[2111586/(1000000*6)  4823286/(1000000*12)  10719388/(1000000*24)  16689145/(1000000*36) 22643300/(1000000*48)  28587007/(1000000*60)];
% SEP=[758195/1000000   920686/1000000  988444/1000000   998134/1000000 999656/1000000  999943/1000000];
% CCP=[477594/999999   287874/999999  173491/999999   135696/999999  115697/999999  103421/999999];
% ACCP=[(127649 + 477594 + 248041)/999999  (142300 + 287874 + 226254)/999999  (132899 + 173491 + 166872)/999999  (118881 + 135696 + 133616)/999999   (107457 + 115697 + 115138)/999999  (98073 + 103421 + 102140)/999999];

%Data from running  "simulation_3.m" with the (3,1,8) code in Table 11.1(b) on page 330 of Lin+Costello
%this is in "data_from_simulation_2.txt" with the "better channel" namely:
%P(1,1)=0.65;  %P[ri=A|si=0]
%P(2,1)=0.2;   %P[ri=B|si=0]
%P(3,1)=0.1;   %P[ri=C|si=0]
%P(4,1)=0.05;  %P[ri=D|si=0]
%P(1,2)=0.05;  %P[ri=A|si=1]
%P(2,2)=0.1;   %P[ri=B|si=1]
%P(3,2)=0.2;   %P[ri=C|si=1]
%P(4,2)=0.65;  %P[ri=D|si=1]
%
% BEP=[620370/(1000000*6) 1256998/(1000000*12) 2421959/(1000000*24) 3396031/(1000000*36) 4214292/(1000000*48)  4941000/(1000000*60)];
% SEP=[263368/1000000  345715/1000000 416456/1000000  453367/1000000 482502/1000000  508169/1000000];
% CCP=[825277/999999  748447/999999  680970/999999  646144/999999  620366/999999  597074/999999];
% ACCP=[(37434 + 825277 + 98334)/999999 (47576 + 748447 + 109444)/999999  (55831 + 680970 + 112175)/999999  (60067 + 646144 + 112522)/999999  (64470 + 620366 + 113517)/999999  (68837  + 597074 + 115019 )/999999];

%===============================This was using the Matlab "vitdec()" function with hard-decoding (end)===============



%========This was using the Matlab "vitdec()" function with soft-decoding with 4 levels (2 bits) (begin)=========

%Data from running  "simulation_3.m" with the (3,1,8) code in Table 11.1(b) on page 330 of Lin+Costello
%this is in "data_from_simulation_2.txt" with the "bad channel" namely:
%P(1,1)=0.4;   %P[ri=A|si=0]
%P(2,1)=0.3;   %P[ri=B|si=0]
%P(3,1)=0.2;   %P[ri=C|si=0]
%P(4,1)=0.1;   %P[ri=D|si=0]
%P(1,2)=0.1;   %P[ri=A|si=1]
%P(2,2)=0.2;   %P[ri=B|si=1]
%P(3,2)=0.3;   %P[ri=C|si=1]
%P(4,2)=0.4;   %P[ri=D|si=1]
%
BEP=[1816343/(1000000*6)  4283389/(1000000*12)  9944301/(1000000*24)  15824787/(1000000*36)  21695751/(1000000*48)  27557066/(1000000*60)];
SEP=[670958/1000000  859663/1000000  967368/1000000  991527/1000000 997719/1000000   999340/1000000];
CCP=[534368/999999 345899/999999  199479/999999   147099/999999  121292/999999  107362/999999];
ACCP=[(128870 + 534368 + 220769)/999999  (148837 + 345899 + 212513)/999999  (139227 + 199479 + 167523)/999999  (124008 + 147099 + 136565)/999999  (110091 + 121292 + 117936)/999999  (99855 + 107362 + 103948)/999999];

BCP=1-BEP;
SCP=1-SEP;
bits=[6 12 24 36 48 60];

subplot(2, 2, 3);
plot(bits, BCP, '-x', bits, SCP, '-o', bits, CCP, '-+', bits, ACCP, '-.', 'LineWidth', 3, 'MarkerSize', 10);
set(gca, 'LineWidth', 2, 'TickLength', get(gca, 'TickLength').*2);
grid;
axis square;
title({'Complex Encoder', 'More-dispersive Channel'}, 'FontSize', 12, 'FontName', 'Arial');
xlabel('# of object bits (KM)', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Performance', 'FontSize', 12, 'FontName', 'Arial');
legend({'BCR', 'SCR','CCR', 'ACCR'},'Location', 'EastOutside', 'FontSize', 12, 'FontName', 'Arial');

%Data from running  "simulation_3.m" with the (3,1,8) code in Table 11.1(b) on page 330 of Lin+Costello
%this is in "data_from_simulation_2.txt" with the "better channel" namely:
%P(1,1)=0.65;  %P[ri=A|si=0]
%P(2,1)=0.2;   %P[ri=B|si=0]
%P(3,1)=0.1;   %P[ri=C|si=0]
%P(4,1)=0.05;  %P[ri=D|si=0]
%P(1,2)=0.05;  %P[ri=A|si=1]
%P(2,2)=0.1;   %P[ri=B|si=1]
%P(3,2)=0.2;   %P[ri=C|si=1]
%P(4,2)=0.65;  %P[ri=D|si=1]
%
BEP=[335177/(1000000*6)  596066/(1000000*12)  940155/(1000000*24)  1128846/(1000000*36)  1238126/(1000000*48)  1312835/(1000000*60)];
SEP=[152565/1000000   191396/1000000  216921/1000000  226818/1000000  233040/1000000   237741/1000000];
CCP=[892260/999999  859884/999999   836597/999999   827964/999999   822976/999999  819261/999999];
ACCP=[(25705 + 892260 + 65471)/999999  (31623 + 859884 + 70133)/999999  (34688 + 836597 + 72425)/999999  (35649 + 827964 + 73486)/999999   (36875 + 822976 + 73835)/999999   (37812 + 819261 + 74587)/999999];

BCP=1-BEP;
SCP=1-SEP;
bits=[6 12 24 36 48 60];

subplot(2, 2, 4);
plot(bits, BCP, '-x', bits, SCP, '-o', bits, CCP, '-+', bits, ACCP, '-.', 'LineWidth', 3, 'MarkerSize', 10);
set(gca, 'LineWidth', 2, 'TickLength', get(gca, 'TickLength').*2);
grid;
axis square;
title({'Complex Encoder', 'Less-dispersive Channel'}, 'FontSize', 12, 'FontName', 'Arial', 'interpreter', 'tex');
xlabel('# of object bits (KM)', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Performance', 'FontSize', 12, 'FontName', 'Arial');
legend({'BCR', 'SCR','CCR', 'ACCR'},'Location', 'EastOutside', 'FontSize', 12, 'FontName', 'Arial');
%========This was using the Matlab "vitdec()" function with soft-decoding with 2 levels (end)=========


hgexport(gcf, 'figure9.png',myStyle,'Format','png');
