

%--------the encoder part (begin)

t=poly2trellis([3],[6 5 7]);  %the (3,1,2) code on page 315 of Lin+Costello
%k=

%msg=[1 0 1 0 1 0]
%msg=[1 0 1 0 1 0 1 0 1 0 1 0]
%msg=[1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0]
%msg=[1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0]
%msg=[1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0]
msg=[1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0]

code=convenc(msg,t);
tblen=length(msg);

[d m p in]=vitdec(code, t, tblen, 'cont', 'hard');

%--------the encoder part (end)


