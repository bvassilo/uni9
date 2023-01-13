function [x_q,sqnr] = deltamodulation(x)
k=1.5;

e = zeros(length(x),1);
b = zeros(length(x),1);
d = zeros(length(x),1);
e_q = zeros(length(x),1);
x_q = zeros(length(x),1);

x_q(1)=0;
b(1)= 1;
d(1)=1; 
e(1) = x(1);

    for i = 2:1:length(x)
        e(i) = x(i)-x_q(i-1);
        
        if e(i) >= 0
            b(i) = 1;
        elseif e(i)<0
            b(i) = -1;
        
        end
        if b(i)== b(i-1)
            d(i) = d(i-1)*k;
        elseif b(i) ~= b(i-1)
            d(i) = d(i-1)/k;
        end
        e_q(i) = b(i)*d(i);
        x_q(i) = x_q(i-1)+e_q(i);
    end
    
    
Px = mean(sum(power(x,2)));
quan_error = x-x_q;
Px_quan = mean(sum(power(quan_error,2)));
sqnr = Px/Px_quan;

end 