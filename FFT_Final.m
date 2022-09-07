%pkg load image
OrigIMG=imread('cathedral.ppm');
% Convert from RGB to YCbCr
IMG=rgb2ycbcr(OrigIMG); 

w=length(IMG(1,:,1)); % Image Width
h=length(IMG(:,1,1)); % Image Height
% Crop Image &make the dimensions divisible by 8
h=h-mod(h,8); 
w=w-mod(w,8);
OrigIMG = (imresize(OrigIMG,[h w]));
hmax=h/8;
wmax=w/8;

Q=zeros(8,8);
Q(1:8,1)=ones(1,8);
Q(1,1:8)=ones(1,8);
%% Compress Image
for kk=1:3
I=IMG(:,:,kk); 
% Isolate specific Cr,Y,Cb
% Compression
MM=double(I)-128;

CC=zeros(h,w);
QQ=Q;
for i=1:hmax
for j=1:wmax
M=MM(8*i-7:8*i,8*j-7:8*j); 
% Split into 8x8 pixel blocks
D=fft(M);
C=round(D.*QQ);
CC(8*i-7:8*i,8*j-7:8*j)=C;
% Paste 8x8 blocks back together
end
end
% Inverse FFT
for i=1:hmax
for j=1:wmax
CompIMG(8*i-7:8*i,8*j-7:8*j,kk)=ifft(CC(8*i-7:8*i,8*j-7:8*j));
end
end
 % Transform scale from -128-127 to 0-255
CompIMG(:,:,kk)=CompIMG(:,:,kk)+128;
end


CompIMG=real(uint8(CompIMG));
CompIMG=ycbcr2rgb(CompIMG);

% Compare True Image with Compressed
figure(2)
subplot(1,2,1)
imshow(OrigIMG)
title('Original')
subplot(1,2,2)
imshow(CompIMG)
title('Compressed')
%output image
imwrite(OrigIMG,'cathedralInFFT.jpg');
imwrite(CompIMG,'cathedralOutFFT.jpeg');