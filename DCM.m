%% 
%  Instructions
%  ------------

%% Initialization
clear ; close all; clc

%% ================= Part 1: Read DCM file ====================
% Open Select DCM file
% [filename,pathname] = uigetfile({'*.dcm','All Image Files';...
%     '*.*','All Files'});
% info = dicominfo([pathname,filename]);

info = dicominfo('I1.dcm'); 
img = dicomread(info);
subplot(2,2,1);imshow(img,'DisplayRange',[]);title('Original');
img = double(img);
[m n] = size(img);
img = img(1:m/2,1:n);
subplot(2,2,1);imshow(img,'DisplayRange',[]);title('Original');

bmp = imread('I1.bmp');
bmp = double(bmp);

% 绘制直方图
[m,n] = size(bmp);
his = zeros(1,256);
for k = 0:255   his(k+1)=length(find(bmp == k))/(m*n);end
figure,bar(0:255,his,'g')
title('Histogram')
xlabel('灰度值') 
ylabel('像素的概率密度')

% 选择感兴趣区域
% h = imrect;
% pos = getPosition(h);
% interest = imcrop(img,pos);
% subplot(2,2,2);imshow(interest,'DisplayRange',[]);title('Select');

% ROI = roicirclecrop(img);
% subplot(2,2,2);imshow(ROI,'DisplayRange',[]);title('Select');

%% ================= Part 2: RETRIVE FEATURES ====================
% ================= HISTOGRAM ================
% Total number of histogram based features: 9
HIS_FEAT = histogramfeature(img);

% Get BMP data to compare with output of MaZda
% HIS_FEAT_BMP = histogramfeature(bmp);


% ================= GRADIENT ================
% Total number of absolute gradient based features: 5
GRA_FEAT = gradientfeature(img);

% Get BMP data to compare with output of MaZda
% GRA_FEAT_BMP = gradientfeature(bmp);


% ================= RUN LENGTH MATRIX ================
% Features are computed for 4 (2D images) or 13 (3D images) various directions.
% Total number of run length matrix based features: 44 (2D) or 143 (3D)

[GLRLMS,SI] = grayrlmatrix(img,'NumLevels',64,'G',[]);
RL_STATS = grayrlprops(GLRLMS,4);

% Get BMP data to compare with output of MaZda
% [GLRLMS_BMP,SI_BMP] = grayrlmatrix(bmp,'NumLevels',64,'G',[]);
% RL_STATS_BMP = grayrlprops(GLRLMS_BMP,4);


% ================= COOCURRENCE MATRIX ================
% Features are computed for 5 between-pixels distances (1, 2, 3, 4, 5) and for 4 (2D images) or 13 (3D images) various directions.
% Total number of co-occurrence matrix based features: 220 (2D) or 715 (3D)
for D = 1:5
    GLCMS{4*D-3} = graycomatrix(img,'Offset',[0,D],'NumLevels',64,'G',[]);
    GLCMS{4*D-2} = graycomatrix(img,'Offset',[-D,0],'NumLevels',64,'G',[]);
    GLCMS{4*D-1} = graycomatrix(img,'Offset',[-D,D],'NumLevels',64,'G',[]);
    GLCMS{4*D} = graycomatrix(img,'Offset',[D,D],'NumLevels',64,'G',[]);
end
CM_STATS = graycomyprops(GLCMS,20);

% Get BMP data to compare with output of MaZda
%{ 
for D = 1:5
    GLCMS_BMP{4*D-3} = graycomatrix(bmp,'Offset',[0,D],'NumLevels',64,'G',[]);
    GLCMS_BMP{4*D-2} = graycomatrix(bmp,'Offset',[-D,0],'NumLevels',64,'G',[]);
    GLCMS_BMP{4*D-1} = graycomatrix(bmp,'Offset',[-D,D],'NumLevels',64,'G',[]);
    GLCMS_BMP{4*D} = graycomatrix(bmp,'Offset',[D,D],'NumLevels',64,'G',[]);
end
CM_STATS_BMP = graycomyprops(GLCMS_BMP,20);
%}


% ================= AUTOREGRESSIVE MODEL  ================
% Total number of autoregressive model based features: 5 
% AUTOREG_FEAT = regfeature(bmp);


% ================= HAAR WAVELET  ================
% Feature is computed at 5 scales within four frequency bands LL, LH, HL and HH. 
% Total number of Haar wavelet based features: 20 

% HAAR_FEAT = haarfeature(bmp);
HAAR_FEAT = zeros(5,4);
[c s] = wavedec2(img,5,'haar');

for i = 1:5
    LL=appcoef2(c,s,'haar',i);
    LH=detcoef2('h',c,s,i);
    HL=detcoef2('v',c,s,i);
    HH=detcoef2('d',c,s,i); 
    HAAR_FEAT(i,:) = haarfeature(LL,LH,HL,HH);
end

% Get BMP data to compare with output of MaZda
% [c s] = wavedec2(bmg,5,'haar');