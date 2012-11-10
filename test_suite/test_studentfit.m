
y = 10+random('t',100,[10000 1]);

hist(y,50);

[u,l,v] = studentfit(y);
