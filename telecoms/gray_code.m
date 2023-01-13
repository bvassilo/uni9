function a = gray_code(m)
    if m > 1
        temp1 = gray_code(m-1);
        temp2 = flipud(temp1);
        temp3 = [temp1;temp2];
        a = [ones(2^m,1),temp3];
        a(1:1:2^(m-1)) = 0;
    else
        a = [0;1];
    end
end