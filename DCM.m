%% Machine Learning Online Class
%  Instructions
%  ------------

%% Initialization
clear ; close all; clc

%% ================= Part 1: Read DCM file ====================
%
info = dicominfo('I1.dcm'); 
img = dicomread(info);   
subplot(2,2,1);imshow(img,'DisplayRange',[]);title('Original');
img = double(img);  

hist = imhist(img);

% 选择感兴趣区域
h = imrect;
pos = getPosition(h);
interest = imcrop(img,pos);
subplot(2,2,2);imshow(interest,'DisplayRange',[]);title('Select');

% ROI = roicirclecrop(img);
% subplot(2,2,2);imshow(ROI,'DisplayRange',[]);title('Select');

%% ================= Part 2: TEXTURE FEATURES ====================
% Mean (histogram's mean)
[m,n] = size(img);
s=0;
for x = 1:m
    for y = 1:n
        s = s + img(x,y); %求像素值总和 s
    end
end
%所有像素均值
%第一种方法：先计算列向量均值，再求总均值。
Mean = mean(mean(img)); 
 %第二种方法：用函数mean2求总均值
Mean2 = mean2(img);
%第三种方法：按公式计算，像素值总和除以像素个数。
Mean3 = s/(m*n);  
%第四种方法：也是按公式计算，但是用sum来求像素值总和。
Mean4 = sum(sum(img))/(m*n); 

Mean5 = mean(mean(hist));

