%% Zoom and Enhance (run section with ctrl + enter)
%% Inmport image to matlab (run section with ctrl + enter)
%In this section we will import an image into the matlab software, 

% start by clearing the workspace with the 'clear' function
clear
% Read image file into matlab workspace using the matlab IMREAD function
IMG = imread('mario.jpg');
% Display image in figure window using IMSHOW function
figure, imshow(IMG), title('Original')

%% Create Low res image (run section with ctrl + enter)
%Here we will remove some pixels to make a low resolution version of the image and display the original and low res images side by side

%close figure window
close all
%Determine the resolution. The higher the scale factor, the more pixels
% that will be removed
scale_factor =5;

% retain pixels in each row and column every index locations which are
% multiples of the scale factor
IMG_low_res = IMG(1:scale_factor:end,1:scale_factor:end,:);

%display original image and low res version
figure,
subplot(121), imshow(IMG), title('Original')
subplot(122), imshow(IMG_low_res), title('Low res version')
%% Zoom and crop (run section with ctrl + enter)
% Here will will use the mouse to select a pixel and extract a region of
% sixe px x px surrounding the pixel and discard the rest of te image

%Make low res version default image
IMG= IMG_low_res;

%  create a figure window and display the image, use magnification to enlarge low res image.
figure, imshow(IMG,'InitialMagnification','fit'), title('Select a pixel region')

% Calculate image dimensions
[r,c,z]=size(IMG);
%Define region size Px x Px
Px = 25;
% Select pixel with mouse which defines the zoom region location
[x, y] = ginput(1);

% Calculate region coords (max and min functions are used to ensure region
% stays within the borders of the image by constraining the size of pixel
% region)

xdims =max(1,round(x-Px/2)):min(round(x+Px/2),c);
ydims = max(1,round(y-Px/2)):min(round(y+Px/2),r);

%Create cropped image using selected pixels
ZoomIMG=IMG(ydims,xdims,1:3);

%close figures
close all
% Display outputs
figure,
subplot(1,2,1),imshow(IMG), title('Low Res Image')
subplot(1,2,2),imshow(ZoomIMG), title('Zoom and Cropped')
%% Enhance (run section with ctrl + enter)
% Here we will enhance the quality of the image by upscaling the resolution, 
% we achieve this using a process called interpolation
% This is the inverse process of what we did earlier to reduce image resolution

% Determine the factor by which we want to increase the image resolution
upscale_factor =3;

% Next we use MATLAB's INTERP2 function which creates pixel values to fit
% inbetween existing pixels. Note: We have to do this 3 times, one for each
% of the colour channels Red, Green and Blue
ImgEnhancedRedCh =interp2(double(ZoomIMG(:,:,1)),upscale_factor);
ImgEnhancedGreenCh =interp2(double(ZoomIMG(:,:,2)),upscale_factor);
ImgEnhancedBlueCh =interp2(double(ZoomIMG(:,:,3)),upscale_factor);

% Combine the interpolated colour channels back into a single image
EnhancedIMG(:,:,1)=ImgEnhancedRedCh;
EnhancedIMG(:,:,2)=ImgEnhancedGreenCh;
EnhancedIMG(:,:,3)=ImgEnhancedBlueCh;
EnhancedIMG=uint8(round(EnhancedIMG));
%close figures
close all
% Display the upscaled image with the cropped image
figure,
subplot(1,2,1),imshow(ZoomIMG), title('Zoom and Cropped')
subplot(1,2,2),imshow(EnhancedIMG), title('Enhanced (Upscaled)')

%% Sharpen (run section with ctrl + enter)
% Finally, we can apply a sharpening filter to remove some of the blur,
% note there are several options for filtering, some have a much stronger
% effect than others. Here we will apply a subtle sharpening effect using
% convolution filtering
%
%Create sharpening filter kernel
h = [0, -1, 0; -1, 5, -1; 0, -1, 0];
% Apply filter using convolution
SharpenedIMG = imfilter(EnhancedIMG, h, 'conv');

%close old figures
close all
%create new figure
figure, 
subplot(2,2,1),imshow(IMG), title('Low Res Image');
subplot(2,2,2),imshow(ZoomIMG), title('Zoom and Cropped');
subplot(2,2,3),imshow(EnhancedIMG), title('Upscaled');
subplot(2,2,4),imshow(uint8(SharpenedIMG)), title('Sharpened');