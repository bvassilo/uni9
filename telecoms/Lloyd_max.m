function [x_quan,centers,D,sqnr,entropy] = Lloyd_max(x,N,x_min,x_max)
x_quan = zeros(length(x),1);
e=10^-8; 
acc = 1; 
entropy = 0;
sqnr = zeros (length(x),1);
D = zeros (length(x),1);
syms k ;
centers = zeros(2^N,1);
centers_probability = zeros(2^N,1) + 2^(N-1)/x_max ;
t = zeros((2^N)-1,1); 
Px = mean(sum(power(x,2)));
for i = 1:1:2^(N-1)%initial center calculation
    centers(i) = x_min*((2^(N-1))-i)/2^(N-1);
    centers(((2^N)/2)+i) = x_max*i/2^(N-1);
end
    while 1
        %calculation of the areas
        for i=1:1:(2^N)-1
            t(i) = (centers(i)+centers(i+1))/2;
        end
        
        for i=1:1:length(x)
            if x(i)<t(1)
                x_quan(i)= centers(1);
                centers_probability(1) = centers_probability(1) + 1;
            elseif t((2^N)-1)<x(i)
                x_quan(i)= centers(2^N);
                centers_probability(2^N) = centers_probability(2^N) + 1;
            end
            for j=1:1:(2^N)-2
                if t(j)<x(i) && x(i)<t(j+1)
                    x_quan(i) = centers(j+1);
                    centers_probability(j+1) = centers_probability(j+1) + 1;
                end
            end   
        end
        %calculating the probability of each center
        centers_probability = centers_probability / length(x);
        %SQNR calculation
        quan_error = x-x_quan;
        Px_quan = mean(sum(power(quan_error,2)));
        sqnr(acc) = Px/Px_quan;
        %centers calculation
        for i=2:1:(2^N)-1
            centers(i) = int(k*centers_probability(i), k, t(i-1), t(i))/ int(centers_probability(i), k, t(i-1),t(i));
        end
        centers(1) = int(k*centers_probability(1), k, x_min, t(1))/ int(centers_probability(1), k, x_min,t(1));
        centers(2^N) = int(k*centers_probability(2^N), k, t((2^N)-1), x_max)/ int(centers_probability(2^N), k, t((2^N)-1),x_max);
        acc = acc + 1;
        %entropy calculation
        for i=1:1:2^N
            entropy = entropy + centers_probability(i)*log(1/centers_probability(i));
        end
        %deformation calculation
        for i=1:1:(2^N)-2
            D(acc) = D(acc) + int(((k-centers(i+1))^2)*centers_probability(i), k, t(i), t(i+1));
        end 
        D(acc) = D(acc) + int(((k-centers(1))^2)*centers_probability(1), k, x_min, t(1)) + int(((k-centers(i))^2)*centers_probability(2^N), k, t((2^N)-1), x_max);
        if abs(D(acc)-D(acc-1))<e
            break;
        end    
    end
end  