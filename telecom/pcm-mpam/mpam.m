
function  [b_prob, s_prob] = mpam(M,snr,encoding)
    rng(42069); % for reproducible results

    % constants and config
    %M = 4;
    %snr = 2;
    PULSE = 1;
    symbol_bits = log2(M);

    nums = 0:((M / 2) - 1);
    p = (2.*nums + 1) .* PULSE;

    map = [-flip(p) p];

    L_b = 100000;

    input = make_input(L_b);

    pad_size = mod(size(input, 1), symbol_bits);
    input = padarray(input,pad_size,0);
    %input = [input zeros(pad_size)];

    mapped = zeros([int32((size(input, 1) / symbol_bits)) 1]);

    % convert input to symbols
    for i = 1:size(mapped, 1)
        start = (i - 1) * symbol_bits;
        chunk = input((start + 1):(start + symbol_bits));

        num = binarray2dec(chunk, encoding); %"normal"%
        symbol = map(num + 1);
        mapped(i) = symbol;
    end

    fc = 2.5 * 10 ^ 6;
    T_symbol = 4 * 10^-6;
    T_sub = 10^-6;
    g_t = sqrt(2 / T_sub);

    t = 0:T_sub:((size(mapped, 1) * T_symbol) - T_sub);

    wave = cos(2 * pi * fc .* t);
    out = repelem(mapped' , 4) .* wave;

    noise = make_awgn(size(out),M,snr);
    received_raw = out + noise;

    r = zeros(size(mapped));

    % matched filter
    for s = 1:size(mapped)   
       start = (s-1) * 4;
       samples = received_raw(start+1:start+4);

       ticks = 1:4;
       ts = (s-1) * T_symbol + ticks * T_sub;
       h = cos(2 * pi * fc .* ts);

       res = conv(samples, h);
       r(s) = -res(1);
    end

    received = zeros(size(mapped));
    for s = 1:size(mapped) % decision device
       val = r(s);

       for i = 2:size(map,2)-1
           low = (map(i-1) + map(i)) / 2;
           high = (map(i) + map(i+1)) / 2;
           if val >= low && val < high
               received(s) = map(i);
           end
       end

       if val <= (map(1) + map(2)) / 2
           received(s) = map(1);
       end

       if val >= (map(end) + map(end-1)) / 2
           received(s) = map(end);
       end
    end

    % ser
    symbol_errors = sum(mapped ~= received);
    s_prob = symbol_errors / size(out, 2);

    rec_bits = zeros(size(input));

    % convert received symbols to bits
    for i = 1:size(received, 1)
        start = ((i-1) * symbol_bits) + 1;

        symbol = received(i);
        mapi = find(map == symbol, 1, 'first');

        bits = dec2binarray(mapi-1, symbol_bits, encoding); %"normal"

        rec_bits(start:(start + symbol_bits - 1)) = bits(:);
    end

    % BER
    bit_errors = sum(input ~= rec_bits);
    b_prob = bit_errors / size(input, 1);

end   
    %%%%%%
    function out = make_input(length)
        out = rand([length 1]);
        out(out <= 0.5) = 0;
        out(out > 0.5) = 1;
    end

    function a = dec2binarray(i, digits, type)
        b = dec2bin(i, digits);

        bits = split(b, "");
        bits = cell2mat(bits(2:(end-1)));

        a = zeros(size(bits));
        a(bits == '1') = 1;
        a(bits == '0') = 0;

        gray = zeros(size(a));
        if type == "gray"
            gray(1) = a(1);
            for i = 2:size(bits,1)
                gray(i) = xor(a(i-1), a(i));
            end
            a = gray;
        end    
    end

    function a = binarray2dec(i, type)
        gray = zeros(size(i));
        if type == "gray"
            gray(1) = i(1);
            for j = 2:size(gray,1)
                gray(j) = xor(gray(j-1), i(j));
            end
            i = gray;
        end

        mappedbits = ['0'];
        mappedbits(i == 0) = '0';
        mappedbits(i == 1) = '1';

        a = bin2dec(mappedbits);
    end

    function noise = make_awgn(length,M,SNR)
        mu = 0;
        %sigma = (1/4) * 2;
        sigma = sqrt(1/(2*log2(M)*(10^(SNR/10))));
        noise = normrnd(mu, sigma, [length 1]);
    end
