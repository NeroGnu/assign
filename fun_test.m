function y=fun_test( x)
for i=1:length(x)
    y(i)=1/(exp(-x(i)) + 1);
end