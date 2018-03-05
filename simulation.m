close all;
clear all;
clc;

%Positions Vektoren
posKin = [0 0 0];
posOld = [0 0 0];
posOdo = [0 0 0];
posImu = [0 0 0];

%Geschwindigkeit und Winkelgeschwindigkeit Odometrie
velocity = 0;
w = 0;

%Beschleunigungen und Geschwindigkeiten IMU
velX = 0;
velY = 0;
velPhi = 0;
accX = 0;
accY = 0;
accPhi = 0;

%Koordinaten der einzlenen Kurven
XKin = [];
YKin = [];
XOdo = [];
YOdo = [];
XImu = [];
YImu = [];

figure;
hold on;

for c = 0:+.5:20
    %Berechnen der letzten Geschwindigkeiten/Beschleunigungen durch Positionsänderung für
    %IMU
    velOldX = velX;
    velOldY = velY;
    velOldPhi = velPhi;
    velX = (posKin(1,1)-posOld(1,1))/.1;
    velY = (posKin(1,2)-posOld(1,2))/.1;
    velPhi = (posKin(1,3)-posOld(1,3))/.1;
    accX = (velX - velOldX)/.1;
    accY = (velY - velOldY)/.1;
    accPhi = (velPhi - velOldPhi)/.1;
    
    %Berechnen der Geschwindigkeiten für Odometrie
    velocity = rand(1)*3 + velocity;
    w = (rand(1)*(2*pi - -2*pi) + -2*pi) + w;
    
    %Vektoren für Modelle
    v = [velocity w .1];
    a = [accX accY accPhi .1];
    
    %Abspeichern letzter Position für Änderungsberechnung im nächsten
    %Schritt
    posOld = posKin;
    
    %Berechnen der neuen Positionen der Modelle
    posKin=kinModell(posKin, v);
    posOdo=odometrie(posOdo, v, 0.001);
    posImu=imuModell(posImu, a);
    
    %Hinzufügen der neuen Punkte
    XOdo=[XOdo posOdo(1,1)];
    YOdo=[YOdo posOdo(1,2)];
    XKin=[XKin posKin(1,1)];
    YKin=[YKin posKin(1,2)];
    XImu=[XImu posImu(1,1)];
    YImu=[YImu posImu(1,2)];
    
    %Plotten
    plot(XKin, YKin, 'g');
    plot(XOdo, YOdo, 'r');
    plot(XImu, YImu, 'b');
    pause(.1);
end