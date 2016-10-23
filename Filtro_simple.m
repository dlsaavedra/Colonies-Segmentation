function [ Y ] = Filtro_simple( X )
%UNTITLED Summary of this function goes here
%X vector nx1
%   Detailed explanation goes here
n=length(X);
Y=zeros(n,1);
Y(1)=X(1);

for i=2:n-1
    min=Y(i-1);
    max=X(i+1);
    delta=abs(max-min);
    if X(i)>min+delta || X(i)<min-delta || max<min
        Y(i)=min;    
    else 
        Y(i)=X(i);
    end
end
Y(n)=(X(n)+Y(n-1))/2;
end

