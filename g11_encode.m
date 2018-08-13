function code11 = g11_encode(code6)
global generator_poly
[~,r]=gfdeconv(horzcat(zeros([1,5]),code6), generator_poly,3);
code11 = horzcat(mod(-r,3),code6);
end