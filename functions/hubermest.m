function m = hubermest(y)
x = zeros(length(in));
fit = robustfit(x,y,'huber');
m = fit(1);
end