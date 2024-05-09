clc
close all
clear all
rectangle('Position',[0,0,80,80]);
rectangle('Position',[0,0,10,20],"FaceColor","r");
rectangle('Position',[10,0,10,20],"FaceColor","r");
rectangle('Position',[20,0,10,20],"FaceColor","r");
rectangle('Position',[30,0,10,20],"FaceColor","r");
rectangle('Position',[40,0,10,20],"FaceColor","r");
rectangle('Position',[50,0,10,20],"FaceColor","r");
rectangle('Position',[60,0,10,20],"FaceColor","r");
rectangle('Position',[70,0,10,20],"FaceColor","r");
rectangle('Position',[0,60,10,20],"FaceColor","b");
rectangle('Position',[10,60,10,20],"FaceColor","b");
rectangle('Position',[20,60,10,20],"FaceColor","b");
rectangle('Position',[30,60,10,20],"FaceColor","b");
rectangle('Position',[40,60,10,20],"FaceColor","b");
rectangle('Position',[50,60,10,20],"FaceColor","b");
rectangle('Position',[60,60,10,20],"FaceColor","b");
rectangle('Position',[70,60,10,20],"FaceColor","b");
rectangle('Position',[10,30,10,10],"FaceColor","g");
rectangle('Position',[20,30,10,10],"FaceColor","g");
rectangle('Position',[30,30,10,10],"FaceColor","g");
rectangle('Position',[40,30,10,10],"FaceColor","g");
rectangle('Position',[50,30,10,10],"FaceColor","g");
rectangle('Position',[60,30,10,10],"FaceColor","g");
rectangle('Position',[10,40,10,10],"FaceColor","g");
rectangle('Position',[20,40,10,10],"FaceColor","g");
rectangle('Position',[30,40,10,10],"FaceColor","g");
rectangle('Position',[40,40,10,10],"FaceColor","g");
rectangle('Position',[50,40,10,10],"FaceColor","g");
rectangle('Position',[60,40,10,10],"FaceColor","g");
walls = [0,20,80,20; 10,0,10,20; 20,0,20,20; 30,0,30,20; 40,0,40,20; 
 50,0,50,20; 60,0,60,20; 70,0,70,20; 10,30,70,30; 10,40,70,40;
 10,50,70,50; 10,30,10,50; 20,30,20,50; 30,30,30,50; 40,30,40,50;
 50,30,50,50; 60,30,60,50; 70,30,70,50; 0,60,80,60; 10,60,10,80;
 20,60,20,80; 30,60,30,80; 40,60,40,80; 50,60,50,80; 60,60,60,80;
 70,60,70,80];
pwrR = input("Please Enter Received Power: ");
hold on
plot(25,25,"black*");
plot(70,25,"black*");
plot(10,55,"black*");
plot(70,55,"black*");
ap1 = [10,55];
ap2 = [70,55];
ap3 = [25,25];
ap4 = [70,25];
pwr1 = zeros([80,80]);
pwr2 = zeros([80,80]);
pwr3 = zeros([80,80]);
pwr4 = zeros([80,80]);
n=1;
L=1;
Gr=4; %dB
Gt=4; %dB
Pt=21; %dBm
lmda=0.125; %(3*10^8)/(2.4*10^9)
for x = 1:1:80
 for y = 1:1:80
 %plot(x,y,"s");
 P1 = pwr(x, y, ap1, walls);
 P2 = pwr(x, y, ap2, walls);
 P3 = pwr(x, y, ap3, walls);
 P4 = pwr(x, y, ap4, walls);
 pwr1(x, y) = P1;
 pwr2(x, y) = P2;
 pwr3(x, y) = P3;
 pwr4(x, y) = P4;
 
 end
end
distance = zeros([80,80]);
for x = 1:1:80
 for y = 1:1:80
 d = sqrt((pwrR(1)-pwr1(x,y))^2 + (pwrR(2)-pwr2(x,y))^2 + ...
 (pwrR(3)-pwr3(x,y))^2 + (pwrR(4)-pwr4(x,y))^2);
 distance(x,y) = d;
 end
end
d_min = min(distance(:));
[xU,yU] = find(distance==d_min);
disp("you are in location x = " + xU + " and y = " + yU)
plot(xU, yU, '--gs', 'LineWidth', 2, 'MarkerSize', 10, 'MarkerEdgeColor', 'k', 
'MarkerFaceColor', 'y');
pwr1T = transpose(pwr1);
pwr2T = transpose(pwr2);
pwr3T = transpose(pwr3);
pwr4T = transpose(pwr4);
figure()
title('AP1')
contourf(pwr1T)
figure()
title('AP2')
contourf(pwr2T)
figure()
title('AP3')
contourf(pwr3T)
figure()
title('AP4')
contourf(pwr4T)
pwr_total = transpose(pwr1 + pwr2 + pwr3 + pwr4);
figure()
title('Total')
contourf(pwr_total)
function Pr = pwr(x, y, ap, walls)
n=1;
L=1;
Gr=4; %dB
Gt=4; %dB
Pt=21; %dBm
lmda=0.125; %(3*10^8)/(2.4*10^9)
d = sqrt(((ap(1)-x)^2) + ((ap(2)-y)^2));
Lp = 10*log10(((4*pi*d)/lmda)^n);
m = numWalls(x, y, ap, walls);
Pr = Pt + Gt + Gr - Lp - (m*L);
end
function m = numWalls(xref, yref, ap, walls)
m = 0;
for i=1:1:length(walls)
 x1 = walls(i,1);
 y1 = walls(i,2);
 x2 = walls(i,3);
 y2 = walls(i,4);
 [x_int,y_int] = polyxpoly([xref,ap(1)], [yref,ap(2)], [x1,x2], [y1,y2]);
 if(~isempty(x_int))
 m = m+1;
 end
end
end
