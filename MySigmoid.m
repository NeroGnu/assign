function threshold=MySigmoid(median, divider, x)
         threshold=1/(exp((median-x)/divider) + 1);
end