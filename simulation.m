close all;
clear all;
clc;

R = 2;

xstart = [0 0 55];
xodo = [0 0 55];
ximu = [path(0, 0) path(0,0) 55];
v = [0.2 0.5 0];
a = [1 2 0 0];

X =[];
Y =[];
Xkin = [];
Ykin = [];
Xod = [];
Yod = [];
Ximu = [];
Yimu = [];
figure;
hold on;

for i = -10:+.1:10
    v = [.2 .5 .1];
    a = [1 path(i, 2) ximu(1,3) .1];
    temp=kinModell(xstart, v);
    temp2=odometrie(xodo, v);
    temp3=imuModell(ximu, a);
    xstart=temp.';
    xodo=temp2.';
    ximu=temp3;
    
    Xod=[Xod xodo(1,1)];
    Yod=[Yod xodo(1,2)];
    
    Xkin=[Xkin xstart(1,1)];
    Ykin=[Ykin xstart(1,2)];
    
    Ximu = [Ximu ximu(1,1)];
    Yimu = [Yimu ximu(1,2)];

    plot(Xkin, Ykin, 'g');
    plot(Xod, Yod, 'r');
    %plot(Ximu, Yimu, 'b');
    pause(0.01);
end