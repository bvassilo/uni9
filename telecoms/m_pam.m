function  bout = m_pam(m)
    %Rsym = 250.000; %symbols per sec
    Tsymbol = 4*10^-6;
    fc = 2.5*10^6;
    %Tc = 0.4*10^-6;
    %Tsample = 10^-7;
    
    x = zeros(m,1);
    k = log2(m); %number of bits
    acc = 0;
    syms t;
    
    %binary 
    b = randsrc(10000,1,[0 1]);
    s_m = zeros(length(b)/k,1);
    sm_t = zeros(length(b)/k,1);

    %mapper
    gc = gray_code(k);
    for i=1:1:m
        x(i) = (2*i)-1-m;
    end
    for i=1:k:length(b)/k
        acc = acc + 1;
        for j=1:1:length(gc)
            if isequal(b(i:1:i*k),gc(j,1:1:k))
                s_m(acc) = x(j);
                break;
            end
        end    
    end
    
    %pulse
    g_t = sqrt(2/Tsymbol);
    %modulation
    for i=1:1:length(b)/k
        sm_t(i) = s_m(i)*g_t*cos(2*pi*fc);
    end
    
     %channel AWGN
    n = randn(length(sm_t),1);
    r_t = n + sm_t;
    
    r = zeros(length(sm_t),1);
    
    %demodulation
    for i=1:1:length(sm_t)
        r(i) = int(g_t*r_t(i),t,0,Tsymbol);
    end
    
    s_maf = zeros(length(sm_t),1);
    
    %detector
    for i=1:1:length(r)
        diff = s_m - r(i);
        [~,index] = min(diff);
        s_maf(i) = s_m(index);
    end   
    bout = zeros(length(b),k);
    %demapper
    for i=1:1:length(s_maf)
        acc = acc + 1;
        for j=1:1:length(x)
            if s_maf(i) == x(j)
                bout(i , 1:1:k) = gc(j,1:1:k);
                break;
            end
        end    
    end
    bout = bout';
    bout = bout(:);
end