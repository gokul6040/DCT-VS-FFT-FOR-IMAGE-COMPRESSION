%%% Cleaning the workspace and variables %%%;
clear all;
close all;
clc;
pkg load image
% Reading an input image
image = double ((imread('C:\Users\user\Downloads\Semester 2\Maths\projec\rgb8bit\hdr.ppm')));
%image=double((imread('hdr.ppm')));
%% Computing the size of an image
[M,N,dimension]=size(image);
x=min(M,N);
if(dimension>2)
display('Loaded image is coloured ')
else
display('Loaded image is grayscale ');
end
%% Selection of threshold value for DCT coefficients

thresh = 10;
%% For colored images
if(dimension==3);
%% Resize the image to make it square
image_square=(imresize(image,[x x]));
%% Compute the size of a square image
[M1,N1]=size(image_square);
%% Calculation the DCT basis matrix
for i=1:M1
for j=1:M1
if(i==1)
x(i,j)=sqrt(1/N1)*cos(((2*j-1)*(i-1)*pi)/(2*N1));
else
x(i,j)=sqrt(2/N1)*cos(((2*j-1)*(i-1)*pi)/(2*N1));
end
end
end
%% Calculate the DCT coefficients for each RGB components of an image
DCT_red=x*image_square(:,:,1)*x';
DCT_green=x*image_square(:,:,2)*x';
DCT_blue=x*image_square(:,:,3)*x';
%% Truncating the DCT coefficients to achieve compression for each channel
DCT_red(abs(DCT_red)<thresh)=0;
DCT_green(abs(DCT_green)<thresh)=0;
DCT_blue(abs(DCT_blue)<thresh)=0;
DCT(:,:,1)=DCT_red;
DCT(:,:,2)=DCT_green;
DCT(:,:,3)=DCT_blue;
%% Reconstruction of the compressed image from each channel
image_compressed(:,:,1)=x'*DCT_red*x;
image_compressed(:,:,2)=x'*DCT_green*x;
image_compressed(:,:,3)=x'*DCT_blue*x;
imwrite(uint8(image_compressed),'Compressed.jpeg');
%% Compression ratio
data_orig=imfinfo('hdr.ppm');
original_file_size=data_orig.FileSize;
data_comp=imfinfo('Compressed.jpeg');
compressed_file_size=data_comp.FileSize;
Compression_ratio=floor(original_file_size/compressed_file_size);
%% Plotting the results
figure(2)
subplot(1,2,1)
imshow(uint8(image_square))
title('Original')
subplot(1,2,2)
imshow(uint8(image_compressed))
title('Compressed')

%% Putting the images in the directory
imwrite(uint8(image_square),'hdr.jpg');
imwrite(uint8(image_compressed),'hdrComp.jpeg');
end