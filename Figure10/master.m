clearvars -except ax1 originalSize;

%first run "encoder2.m" 
%then run "gen_discrete_chan_1.m" 
%then run "viterbi_alg_my_own_2.m"

iterations=1e3;
rng(1);
bit_error_num=0;
symbol_error_num=0;
k9=1;

% 1: MAP, 0: MLE
weight = 1;

Nstates = 4;

default_apriori_probs = zeros(Nstates);
default_apriori_probs(1, 1) = 1/2;
default_apriori_probs(3, 1) = 1/2;
default_apriori_probs(1, 2) = 1/2;
default_apriori_probs(3, 2) = 1/2;
default_apriori_probs(2, 3) = 1/2;
default_apriori_probs(4, 3) = 1/2;
default_apriori_probs(4, 4) = 1/2;
default_apriori_probs(2, 4) = 1/2;
pick_column = [1, 0, 1, 0, ...
                              1, 0, 1, 0, ...
                              0, 1, 0, 1, ...
                              0, 1, 0, 1];


% set up a-priority probabilities
% (b_k+1, b_k)
apriori_probs = default_apriori_probs;
apriori_probs_matrix = nan(iterations, numel(apriori_probs));

correct_stream_matrix = nan(iterations, 60);

BEP_array = nan(1, iterations);
SEP_array = nan(1, iterations);

h = waitbar(0, 'Please wait...');
apriori_count = zeros(Nstates);
bk_count = zeros(1, Nstates);
while(k9<=iterations)
   waitbar(k9/iterations, h, ['Running: ', num2str(k9./iterations)]);
   encoder2;
   gen_discrete_chan_1;
   viterbi_alg_shj_20190819;
   bit_error_num= bit_error_num + BEP_error_count;
   symbol_error_num= symbol_error_num + SEP_error_count;

   weight_of_decoded_message(k9) = sum(dec_stream);
    
    % record BEP and SEP
   BEP_array(k9) = BEP_error_count;
   SEP_array(k9) = SEP_error_count;
    
   correct_stream_matrix(k9, :) = (dec_stream==msg);
    % UPDATE apriori_probs here
    % compress the decoded stream here
    dec_stream_compressed = reshape(dec_stream, N, length(dec_stream)/N)';
    % interleaver determines which bit is more important
    dec_stream_important = dec_stream_compressed .* interleaver;
    [Au,~,ic] = unique(dec_stream_important, 'rows', 'stable');
    N_groups = 1:size(Au, 1);
    dec_stream_unimportant = dec_stream_compressed .* (1-interleaver);
    dec_stream_important_compressed = Au;
    dec_stream_unimportant_compressed = ...
        cell2mat(arrayfun(@(group) mode(dec_stream_unimportant(ic==group, :), 1), ...
        N_groups', 'UniformOutput', false));
    dec_stream_compressed = ...
        dec_stream_unimportant_compressed ...
        + dec_stream_important_compressed;
    
    dec_stream_compressed = dec_stream_compressed';
    dec_stream_compressed = dec_stream_compressed(:);
    dec_stream_compressed = dec_stream_compressed';
    % prepending two zeros to the decoded stream
    dec_stream_prezeros = [0, 0, dec_stream_compressed];
    for icode=1:length(dec_stream_prezeros)-2
        bk = sum(dec_stream_prezeros(icode:icode+1) .* [1,  2])+1;
        bk_1 = sum(dec_stream_prezeros(icode+1:icode+2) .* [1,  2])+1;
        apriori_count(bk_1, bk) = apriori_count(bk_1, bk) + 1;
        bk_count(bk) = bk_count(bk) + 1;
    end
    
    apriori_probs = apriori_count ./ bk_count;
    if sum(bk_count==0) > 0
        apriori_probs(:, bk_count==0) = default_apriori_probs(:, bk_count==0);
    end
    
    apriori_probs_matrix(k9, :) = apriori_probs(:);
    
    k9=k9+1;
%     clearvars -except h apriori_probs weight_of_decoded_message bit_error_num symbol_error_num k9 iterations

end
close(h);

any(all(correct_stream_matrix, 2))

k9 
iterations
bit_error_num 
symbol_error_num 

unique(weight_of_decoded_message)
histc(weight_of_decoded_message, unique(weight_of_decoded_message))


%% plot the original data
% figure('Position', [10, 0, 1200, 600]);
if exist('ax1', 'var') && ishandle(ax1)
    ax0 = ax1;
    ax1 = axes;
else
    ax1 = subplot(2, 2, 3);
    originalSize = get(gca, 'Position');
    delete(ax1);
    ax1 = axes;
    set(ax1, 'Position', originalSize);
end
colormap(ax1, [1, 0, 0; 0, 0, 1]);
caxis([0, 1]);
heatmap(correct_stream_matrix, 1:numel(dec_stream), 1:iterations);

% xlim([0, numel(dec_stream)]);
% ylim([0, iterations]);
% set(gca, 'ytick', 0:200:iterations, 'xtick', 0:20:numel(dec_stream));
ylabel('iteration');
set(ax1,  'Position', [originalSize(1), ...
    originalSize(2) + (1-weight)*(originalSize(4)/2+0.05),  ...
    originalSize(3), originalSize(4)/2-0.05]);
set(ax1, 'xticklabelrotation', 90);
set(ax1,  'TickLength', get(gca, 'TickLength')*2, 'LineWidth', 2, ...
    'FontWeight', 'bold', 'FontSize', 14);
% axis square;
if weight == 1
    title('decoded sequence (MAP)');
    xlabel('index of object bits');
else
    title('decoded sequence (MLE)');
    set(ax1, 'xtick', [], 'xticklabel', []);
end

% plot the change of apiority kymograph
if weight==1
    ax2 = subplot(2, 2, 4);
    colormap(ax2, 'jet');
    caxis([0, 1]);
    stateLabels = arrayfun(@(x) ['S', num2str(x)], 1:Nstates, 'UniformOutput', false);
    [xgrid, ygrid] = meshgrid(1:Nstates, 1:Nstates);
    xlabels = strcat(stateLabels(xgrid(:)), '\rightarrow', stateLabels(ygrid(:)));
    heatmap(apriori_probs_matrix(:, find(pick_column)), [], 1:iterations);
    xlabel('state transition');
    ylabel('iteration');
    set(gca, 'xtick', 1:sum(pick_column), 'xticklabel', xlabels(find(pick_column)), 'TickLabelInterpreter','tex');
    set(gca, 'xticklabelrotation', 90);
    set(gca, 'TickLength', get(gca, 'TickLength')*2, 'LineWidth', 2, ...
        'FontWeight', 'bold', 'FontSize', 14);
    axis square;
    originalSize2 = get(gca, 'Position');
    colorbar;
    set(gca, 'Position', originalSize2);
    title('A priori probabilities');
end

subplot(2, 2, 1);
hold on;
plot(1-BEP_array./length(msg), 'LineWidth', 2);
% title('Iteration vs. Bit Correct');
xlabel('iteration');
ylabel('Bit Correct (BC)');
set(gca, 'TickLength', get(gca, 'TickLength')*2, 'LineWidth', 2, ...
    'FontWeight', 'bold', 'FontSize', 14);
box on;
axis square;
set(gca, 'xlim', get(gca, 'xlim')+[-100, 100], 'ylim', [-0.1, 1.1]);
legend('MAP  ', 'MLE  ');
title('Iteration vs. Bit Correct');

subplot(2, 2, 2);
hold on;
plot(1-SEP_array, 'LineWidth', 2+(1-weight));
% title('Iteration vs. Symbol Correct');
xlabel('iteration');
ylabel('Symbol Correct (SC)');
set(gca, 'TickLength', get(gca, 'TickLength')*2, 'LineWidth', 2, ...
    'FontWeight', 'bold', 'FontSize', 14);
box on;
axis square;
set(gca, 'xlim', get(gca, 'xlim')+[-100, 100], 'ylim', [-0.1, 1.1]);
legend('MAP  ', 'MLE  ');
title('Iteration vs. Symbol Correct');

set(gcf, 'PaperPositionMode', 'manual', ...
    'Units', 'centimeters', 'Position', [0 0 20 35], ...
    'PaperUnits', 'centimeters', 'PaperPosition', [0 0 20 35]);
myStyle = hgexport('factorystyle');
myStyle.Format = 'png';
myStyle.Resolution = 300;
myStyle.Units = 'centimeters';
myStyle.Width = 18;
myStyle.Height = 27;
% myStyle.FixedFontSize = 12;
hgexport(gcf, 'figure10.png',myStyle,'Format','png');