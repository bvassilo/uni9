
function [sqnr] = sqnr(x,x_q)
    Px = mean(sum(power(x,2)));
    quan_error = x-x_q;
    Px_quan = mean(sum(power(quan_error,2)));
    sqnr = Px/Px_quan;
end