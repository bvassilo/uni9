function [y] = adm_decoder(b, N)  
    K = 1.5;
    DELTA_INIT = 1;
    y = zeros([size(b) 1]);
       
    delta = zeros(size(b));
    delta(1) = 0.1;
    
    y(1) = delta(1);
    if b(1) == -1
        y(1) = -delta(1);
    end
        
    for n = 2:(size(b))
        delta(n) = delta(n-1) * 1.5;

        if b(n) ~= b(n-1)
            delta(n) = delta(n-1) / 1.5;
        end
        
        y(n) = b(n) * delta(n) + y(n-1);
    end
    
    y = y(1:N:end);
end