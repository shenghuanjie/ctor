

%first run "encoder1.m" 
%then run "gen_discrete_chan_1.m" 
%then run "viterbi_alg_my_own_2.m"

iterations=1e3
bit_error_num=0;
symbol_error_num=0;
k9=1;

BEP_array = nan(1, iterations);
SEP_array = nan(1, iterations);

while(k9<iterations)
  encoder1;
  gen_discrete_chan_1;
  viterbi_alg_my_own_2;
  bit_error_num= bit_error_num + BEP_error_count;
  symbol_error_num= symbol_error_num + SEP_error_count;

  weight_of_decoded_message(k9)=sum(dec_stream);

    % record BEP and SEP
   BEP_array(k9) = BEP_error_count;
   SEP_array(k9) = SEP_error_count;
   
  k9=k9+1
  
  clearvars -except msg BEP_array SEP_array weight_of_decoded_message bit_error_num symbol_error_num k9 iterations

end

k9 
iterations
bit_error_num 
symbol_error_num 

unique(weight_of_decoded_message)
histc(weight_of_decoded_message, unique(weight_of_decoded_message))


subplot(1, 2, 1);
hold on;
plot(BEP_array./length(msg), 'LineWidth', 2);
title('1-BCP');
xlabel('iteration');
ylabel('1-BCP');
set(gca, 'TickLength', get(gca, 'TickLength')*2, 'LineWidth', 2, ...
    'FontWeight', 'bold', 'FontSize', 14);

subplot(1, 2, 2);
hold on;
plot(1-SEP_array, 'LineWidth', 2);
title('SCP');
xlabel('iteration');
ylabel('SCP');
set(gca, 'TickLength', get(gca, 'TickLength')*2, 'LineWidth', 2, ...
    'FontWeight', 'bold', 'FontSize', 14);
