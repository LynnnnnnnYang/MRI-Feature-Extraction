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

% ѡ�����Ȥ����
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
        s = s + img(x,y); %������ֵ�ܺ� s
    end
end
%�������ؾ�ֵ
%��һ�ַ������ȼ�����������ֵ�������ܾ�ֵ��
Mean = mean(mean(img)); 
 %�ڶ��ַ������ú���mean2���ܾ�ֵ
Mean2 = mean2(img);
%�����ַ���������ʽ���㣬����ֵ�ܺͳ������ظ�����
Mean3 = s/(m*n);  
%�����ַ�����Ҳ�ǰ���ʽ���㣬������sum��������ֵ�ܺ͡�
Mean4 = sum(sum(img))/(m*n); 

Mean5 = mean(mean(hist));

