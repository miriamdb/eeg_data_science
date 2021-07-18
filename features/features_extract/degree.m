function k = degree(A)

N_CHAN = size(A,1); 

k = zeros(N_CHAN, 1);
for i = 1: N_CHAN
    k(i) = sum(A(i,:));
end 


end 