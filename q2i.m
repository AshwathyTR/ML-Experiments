x = rand(1000,1);
hist(x,40);
help hist
[nn, xx] = hist(x);
bar(nn);
