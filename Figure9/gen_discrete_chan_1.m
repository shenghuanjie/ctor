
%Takes the channel transition probabilities and perturbes the encoded sequence to the
%received vector "r" according to the channel transition probabilities


%Make the following designations for the possible channel output:
%A=1
%B=2
%C=3
%D=4

tot_encod_bits=length(code);


%The channel transition probabilities P(r_{i}|s_{i}) 
%The "bad channel"
P(1,1)=0.4;   %P[ri=A|si=0]
P(2,1)=0.3;   %P[ri=B|si=0]
P(3,1)=0.2;   %P[ri=C|si=0]
P(4,1)=0.1;   %P[ri=D|si=0]
P(1,2)=0.1;   %P[ri=A|si=1]
P(2,2)=0.2;   %P[ri=B|si=1]
P(3,2)=0.3;   %P[ri=C|si=1]
P(4,2)=0.4;   %P[ri=D|si=1]

%The channel transition probabilities P(r_{i}|s_{i}) 
%The "better channel"
%P(1,1)=0.65;  %P[ri=A|si=0]
%P(2,1)=0.2;   %P[ri=B|si=0]
%P(3,1)=0.1;   %P[ri=C|si=0]
%P(4,1)=0.05;  %P[ri=D|si=0]
%P(1,2)=0.05;  %P[ri=A|si=1]
%P(2,2)=0.1;   %P[ri=B|si=1]
%P(3,2)=0.2;   %P[ri=C|si=1]
%P(4,2)=0.65;  %P[ri=D|si=1]

i8=1;
while(i8<=tot_encod_bits)

x_rand=rand;

if(code(i8)==0)
 if(x_rand <= P(1,1))
  input_stream1(i8)=1;
 end
 if(P(1,1) < x_rand && x_rand <= P(1,1)+P(2,1))
  input_stream1(i8)=2;
 end
 if(P(1,1)+P(2,1) < x_rand && x_rand <= P(1,1)+P(2,1)+P(3,1))
  input_stream1(i8)=3;
 end
 if(P(1,1)+P(2,1)+P(3,1) < x_rand)
  input_stream1(i8)=4;
 end
% i8=i8+1;
end   %for code(i8)==0 if-loop

if(code(i8)==1)
 if(x_rand <= P(1,2))
  input_stream1(i8)=1;
 end
 if(P(1,2) < x_rand && x_rand <= P(1,2)+P(2,2))
  input_stream1(i8)=2;
 end
 if(P(1,2)+P(2,2) < x_rand && x_rand <= P(1,2)+P(2,2)+P(3,2))
  input_stream1(i8)=3;
 end
 if(P(1,2)+P(2,2)+P(3,2) < x_rand)
  input_stream1(i8)=4;
 end
% i8=i8+1;
end    %for code(i8)==1 if-loop

i8=i8+1;

end %for while loop

%input_stream1
