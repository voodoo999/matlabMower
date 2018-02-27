
r = 10;

xstart = [0 0 0];
xodo = [0 0 0];
vstart = [0.2 0.3];
astart = [0 0 0];

X =[];
Y =[];
Xkin = [];
Ykin = [];
Xod = [];
Yod = [];
Ximu = [];
Yimu = [];

for i = 0:+.1:2*pi
    temp=kinModell(xstart, vstart);
    temp2=odometrie(xodo, vstart);
    xstart=temp;
    xodo=temp2;
    
    Xod=[Xod xodo(1,1)];
    Yod=[Yod xodo(1,2)];
    
    Xkin=[Xkin xstart(1,1)];
    Ykin=[Ykin xstart(1,2)];
    
    X=[X r*cos(i)];
    Y=[Y r*sin(i)];
    
    
end

plot(X,Y, Xkin, Ykin, Xod, Yod)