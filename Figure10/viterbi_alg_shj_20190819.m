
%first run "encoder1.m" then run "gen_discrete_chan_1.m" then run this

%I've verified the results given in this code by hand for upton k=5 (which would be k=4 in my draft because of the 0 index)


N=3;     %length of code
interleaver = [1, 0, 1];
L=2;     %constraint length; 2^L possible states

%apriori_probs( , )=   %the apriori probabilities; these are P[b_{k+1}| b_{k}] in my draft
                
%transition_probs( , )=

%lambda( , )= -log(transition_probs( , ))  %2^(L+1) possible transition pairs

%Gamma( , )= Gamma_previous() + lambda( , )

%Gamma_post= min(Gamma( , ) )    %Gamma_{b_{k+1}}
%must minimize this over b_k


%input_stream1=[4 3 1 4 4 2 4 4 1 4 4 4]  %what I have in my draft (verified)
%input_stream1=[4 3 1 4 4 2 4 4 1 4 4 4 3 2 3]  %what I have in my draft + the extra k=5 point in my notes (verified)

input_stream2=vec2mat(input_stream1, N);   %n is the block number, m is the index within the block. 
                                         %Note: components of "input_stream2" must be from the following set: 1,2,3,4.

[T_max, N_max]=size(input_stream2);   %M_max is total # of blocks to be decoded

%Make the following designations for the possible channel output:
%A=1
%B=2
%C=3
%D=4

%The channel transition probabilities P(r_{i}|s_{i})
%P(1,1)=0.4;   %P[ri=A|si=0]
%P(2,1)=0.3;   %P[ri=B|si=0]
%P(3,1)=0.2;   %P[ri=C|si=0]
%P(4,1)=0.1;   %P[ri=D|si=0]
%P(1,2)=0.1;   %P[ri=A|si=1]
%P(2,2)=0.2;   %P[ri=B|si=1]
%P(3,2)=0.3;   %P[ri=C|si=1]
%P(4,2)=0.4;   %P[ri=D|si=1]


%------------------initial conditon t=1 (begin)-----------------
t=1;

%lambda(t2,t1,1,1)=
lambda(2,1,1,1)=-log(P(input_stream2(1,1),1))-log(P(input_stream2(1,2),1))-log(P(input_stream2(1,3),1)) - weight .* log(apriori_probs(1, 1));
lambda(2,1,3,1)=-log(P(input_stream2(1,1),2))-log(P(input_stream2(1,2),2))-log(P(input_stream2(1,3),2)) - weight .* log(apriori_probs(3, 1));


gammaf(2,1,1,1)=lambda(2,1,1,1);
gammaf(2,1,3,1)=lambda(2,1,3,1);

gammaf_max_survive_index(2,1)=1;      %CHECK THIS!!!
gammaf_max_survive_index(2,2)=0; 
gammaf_max_survive_index(2,3)=1;
gammaf_max_survive_index(2,4)=0;

%------------------initial conditon t=1 (end)-----------------

%-----------------------------------initial conditon t=2 (begin)-------------------------------
t=2;

%lambda(t2,t1,1,1)=
lambda(3,2,1,1)=-log(P(input_stream2(2,1),1)) -log(P(input_stream2(2,2),1)) -log(P(input_stream2(2,3),1)) - weight .* log(apriori_probs(1, 1)); 
lambda(3,2,3,1)=-log(P(input_stream2(2,1),2)) -log(P(input_stream2(2,2),2)) -log(P(input_stream2(2,3),2)) - weight .* log(apriori_probs(3, 1)); 
lambda(3,2,2,3)=-log(P(input_stream2(2,1),2)) -log(P(input_stream2(2,2),1)) -log(P(input_stream2(2,3),2)) - weight .* log(apriori_probs(2, 3)); 
lambda(3,2,4,3)=-log(P(input_stream2(2,1),1)) -log(P(input_stream2(2,2),2)) -log(P(input_stream2(2,3),1)) - weight .* log(apriori_probs(4, 3)); 


gammaf_max(2,1)=gammaf(2,1,1,1);   %this would have to be done via a max() operation   this is for state S0
gammaf_max(2,3)=gammaf(2,1,3,1);   %this would have to be done via a max() operation   this is for state S2

gammaf(3,2,1,1)=gammaf_max(2,1) + lambda(3,2,1,1);
gammaf(3,2,3,1)=gammaf_max(2,1) + lambda(3,2,3,1);
gammaf(3,2,2,3)=gammaf_max(2,3) + lambda(3,2,2,3);
gammaf(3,2,4,3)=gammaf_max(2,3) + lambda(3,2,4,3);
   
gammaf_max_survive_index(3,1)=1;      %CHECK THIS!!!
gammaf_max_survive_index(3,2)=3; 
gammaf_max_survive_index(3,3)=1;
gammaf_max_survive_index(3,4)=3;
     
%-----------------------------------initial conditon t=2 (end)-------------------------------
%for t>=3:

gammaf_max(3,1)=gammaf(3,2,1,1);  %this would have to be done via a max() operation   this is for state S0
gammaf_max(3,2)=gammaf(3,2,2,3);  %this would have to be done via a max() operation   this is for state S1
gammaf_max(3,3)=gammaf(3,2,3,1);  %this would have to be done via a max() operation   this is for state S2
gammaf_max(3,4)=gammaf(3,2,4,3);  %this would have to be done via a max() operation   this is for state S3

t1=3;
while(t1 <= T_max)       %time loop t1 (begin)
   t2=t1+1;

   %m=1;
   %while(m <= M_max)   %m loop (begin)
   %n=1;
   %while(n <= N_max)   %t1 is the block number below, n is the index within the block and is n=1,2,3 here, hence the sum of 3 terms below

    lambda(t2,t1,1,1)=-log(P(input_stream2(t1,1),1)) -log(P(input_stream2(t1,2),1)) -log(P(input_stream2(t1,3),1)) - weight .* log(apriori_probs(1, 1)); 
    lambda(t2,t1,3,1)=-log(P(input_stream2(t1,1),2)) -log(P(input_stream2(t1,2),2)) -log(P(input_stream2(t1,3),2)) - weight .* log(apriori_probs(3, 1)); 
    lambda(t2,t1,1,2)=-log(P(input_stream2(t1,1),1)) -log(P(input_stream2(t1,2),2)) -log(P(input_stream2(t1,3),2)) - weight .* log(apriori_probs(1, 2)); 
    lambda(t2,t1,3,2)=-log(P(input_stream2(t1,1),2)) -log(P(input_stream2(t1,2),1)) -log(P(input_stream2(t1,3),1)) - weight .* log(apriori_probs(3, 2)); 
    lambda(t2,t1,2,3)=-log(P(input_stream2(t1,1),2)) -log(P(input_stream2(t1,2),1)) -log(P(input_stream2(t1,3),2)) - weight .* log(apriori_probs(2, 3));  
    lambda(t2,t1,4,3)=-log(P(input_stream2(t1,1),1)) -log(P(input_stream2(t1,2),2)) -log(P(input_stream2(t1,3),1)) - weight .* log(apriori_probs(4, 3)); 
    lambda(t2,t1,2,4)=-log(P(input_stream2(t1,1),2)) -log(P(input_stream2(t1,2),2)) -log(P(input_stream2(t1,3),1)) - weight .* log(apriori_probs(2, 4)); 
    lambda(t2,t1,4,4)=-log(P(input_stream2(t1,1),1)) -log(P(input_stream2(t1,2),1)) -log(P(input_stream2(t1,3),2)) - weight .* log(apriori_probs(4, 4)); 

    %gammaf(t2,t1,1,1)=-log(P(input_stream2(m,1),1)) -log(P(input_stream2(m,2),1)) -log(P(input_stream2(m,3),1)); 
    gammaf(t2,t1,1,1)=gammaf_max(t1,1)+lambda(t2,t1,1,1);   
    gammaf(t2,t1,3,1)=gammaf_max(t1,1)+lambda(t2,t1,3,1);  
    gammaf(t2,t1,1,2)=gammaf_max(t1,2)+lambda(t2,t1,1,2); 
    gammaf(t2,t1,3,2)=gammaf_max(t1,2)+lambda(t2,t1,3,2);   
    gammaf(t2,t1,2,3)=gammaf_max(t1,3)+lambda(t2,t1,2,3);   
    gammaf(t2,t1,4,3)=gammaf_max(t1,3)+lambda(t2,t1,4,3);  
    gammaf(t2,t1,2,4)=gammaf_max(t1,4)+lambda(t2,t1,2,4);   
    gammaf(t2,t1,4,4)=gammaf_max(t1,4)+lambda(t2,t1,4,4);  

    gammaf_max(t2,1)=min(gammaf(t2,t1,1,2), gammaf(t2,t1,1,1));
    gammaf_max(t2,2)=min(gammaf(t2,t1,2,4), gammaf(t2,t1,2,3));
    gammaf_max(t2,3)=min(gammaf(t2,t1,3,2), gammaf(t2,t1,3,1));
    gammaf_max(t2,4)=min(gammaf(t2,t1,4,4), gammaf(t2,t1,4,3));

 %Now fill matrix "gammaf_max_survive_index(t" whose rows will correspond to the time-index, and (here 4) columns are the different states
 %the value corresponds to the state that the state that the survivor path came from. (2,3)=4 means that at time t=2 the survivor path entering 
 %state s3 came from state s4 at t=1.

    if(gammaf(t2,t1,1,2)<gammaf(t2,t1,1,1))
      gammaf_max_survive_index(t2,1)=2; 
     else
      gammaf_max_survive_index(t2,1)=1; 
     end
    
     if(gammaf(t2,t1,2,4)<gammaf(t2,t1,2,3))
      gammaf_max_survive_index(t2,2)=4;
     else
      gammaf_max_survive_index(t2,2)=3; 
     end
  
     if(gammaf(t2,t1,3,2)<gammaf(t2,t1,3,1))
      gammaf_max_survive_index(t2,3)=2; 
     else
      gammaf_max_survive_index(t2,3)=1; 
     end
  
     if(gammaf(t2,t1,4,4)<gammaf(t2,t1,4,3))
      gammaf_max_survive_index(t2,4)=4; 
     else
      gammaf_max_survive_index(t2,4)=3; 
     end 

t1=t1+1;
  
end     %time loop (end)




gammaf_max;

gammaf_max_survive_index;

%Now you go forward in time to specify the ML path from the survivors:
fin_surv_path(1)=1;  %assume we start in the trellis state s0
fin_surv_path(2)=3;  %assume the second state is s3 NOTE: ANY CHANGE IN YOUR TRANS PROBS WILL CHANGE THIS!!!
t1=3;
while(t1 <= T_max+1)       %time loop t1 (begin)
  
    if(fin_surv_path(t1-1)==1)
       if(gammaf_max(t1,1) < gammaf_max(t1,3))
        fin_surv_path(t1)=1;
       else
        fin_surv_path(t1)=3;
       end    
    end
    
    if(fin_surv_path(t1-1)==2)
       if(gammaf_max(t1,1) < gammaf_max(t1,3))
        fin_surv_path(t1)=1;
       else
        fin_surv_path(t1)=3;
       end 
    end
    
    if(fin_surv_path(t1-1)==3)
       if(gammaf_max(t1,2) < gammaf_max(t1,4))
        fin_surv_path(t1)=2;
       else
        fin_surv_path(t1)=4;
       end     
    end
    
    if(fin_surv_path(t1-1)==4)
       if(gammaf_max(t1,2) < gammaf_max(t1,4))
        fin_surv_path(t1)=2;
       else
        fin_surv_path(t1)=4;
       end 
    end

  t1=t1+1;
end     %time loop (end)

fin_surv_path;

%----------------------Go through the final survivor path and determine decoded sequence (begin)
t1=2;
  while(t1 <= T_max+1)       %time loop t1 (begin)
  
    if(fin_surv_path(t1-1)==1 && fin_surv_path(t1)==1)
  dec_stream(t1-1)=0;   
    end
    
    if(fin_surv_path(t1-1)==1 && fin_surv_path(t1)==3)
      dec_stream(t1-1)=1;
    end
       
    if(fin_surv_path(t1-1)==2 && fin_surv_path(t1)==1)
      dec_stream(t1-1)=0;
    end
    
    if(fin_surv_path(t1-1)==2 && fin_surv_path(t1)==3)
      dec_stream(t1-1)=1;
    end
    
    if(fin_surv_path(t1-1)==3 && fin_surv_path(t1)==2)
      dec_stream(t1-1)=0;
    end
    
    if(fin_surv_path(t1-1)==3 && fin_surv_path(t1)==4)
      dec_stream(t1-1)=1;
    end
    
   
    if(fin_surv_path(t1-1)==4 && fin_surv_path(t1)==2)
      dec_stream(t1-1)=0;
    end
    
    if(fin_surv_path(t1-1)==4 && fin_surv_path(t1)==4)
      dec_stream(t1-1)=1;
    end 

   t1=t1+1;
  end     %time loop t1 (end)

%dec_stream
%----------------------Gow go through the final survivor path and determine decoded sequence (end)


%========================Compute SEP and BEP here (begin)=============================

%msg
BEP_error_count=0;
SEP_error_count=0;

t1=1;
while(t1 <= T_max)       %time loop t1 (begin)
  if(msg(t1) ~= dec_stream(t1))
    BEP_error_count=BEP_error_count+1;
  end
  t1=t1+1;
end     %time loop t1 (end)
  

if(BEP_error_count ~= 0)
    SEP_error_count=SEP_error_count+1;
end

BEP=BEP_error_count/T_max;
% SEP=SEP_error_count/run_num;
%========================Compute SEP and BEP here (end)=============================



% function result=mylog(x)
%     if isnan(x)
%         result=0;
%     elseif x ==0
%        result=0;
%     else
%         result=log(x);
%     end
% end

