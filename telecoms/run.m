clc
clear 
image = load('cameraman.mat');
image = image.i;
image_array = image(:);
image_array = (image_array-128)/128;


x   = randn(10000,1);
f1  = 0.9;
f2  = 0.01;
b   = 1;
fi  = [1;f1];
fj  = [1;f2];

data1 = filter(b,fi,x);
data2 = filter(b,fj,x);
%[data,fs] = audioread('speech.wav');


[a1,b1,c1,d1,e1] = Lloyd_max(data1,2,min(data1),max(data1));
[a2,b2,c2,d2,e2] = Lloyd_max(data1,4,min(data1),max(data1));
[a3,b3,c3,d3,e3] = Lloyd_max(data1,8,min(data1),max(data1));

[a4,b4,c4,d4,e4] = Lloyd_max(data2,2,min(data2),max(data2));
[a5,b5,c5,d5,e5] = Lloyd_max(data2,4,min(data2),max(data2));
[a6,b6,c6,d6,e6] = Lloyd_max(data2,8,min(data2),max(data2));

[a7,b7,c7,d7,e7] = Lloyd_max(image_array,2,min(image_array),max(image_array));
[a8,b8,c8,d8,e8] = Lloyd_max(image_array,4,min(image_array),max(image_array));

a7 = 128*a7+128;
image_a7 = reshape(a7,256,256);

a8 = 128*a8+128;
image_a8 = reshape(a8,256,256);

[a9,d9] = deltamodulation(data1);
[a10,d10] = deltamodulation(data2);

figure(1)
plot(data1)
figure(2)
plot(a1)
figure(3)
plot(a2)
figure(4)
plot(a3)

figure(5)
plot(data2)
figure(6)
plot(a4)
figure(7)
plot(a5)
figure(8)
plot(a6)


figure(9)
imshow(uint8(image))
figure(10)
imshow(uint8(image_a7))
figure(11)
imshow(uint8(image_a8))

figure(12)
plot(a9)
figure(13)
plot(a10)


