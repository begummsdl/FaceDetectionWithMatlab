clc
clear 
close all

%% Step-1  Input Image 
Input_read =  imread('Sekil1.jpg');

%% Step-2 Convert Image from RGB to HSI
figure(1)
Input_read = im2double(Input_read);
r = Input_read(:,:,1);
g = Input_read(:,:,2);
b = Input_read(:,:,3);
th = acos((0.5*((r-g)+(r-b)))./((sqrt((r-g).^2+(r-b).*(g-b)))+eps));
H = th;
H(b > g) = 2 * pi - H(b > g);
H = H/(2 * pi);
S = 1-3.*(min(min(r,g),b))./(r+g+b+eps);
I = (r + g + b)/3;
Image_hsi = cat(3,H,S,I);
subplot(2,2,1) , imshow(Image_hsi), title('RGB to HSI')

%% Step-3 Seprate H, S and I Frame and Contrast and saturates adjustment
Image_hsi1 = imadjust(Image_hsi(:,:,1)) ; 
Image_hsi2 = imadjust(Image_hsi(:,:,2)) ; 
Image_hsi3 = imadjust(Image_hsi(:,:,3)) ; 

subplot(2,2,2), imshow(Image_hsi1), title('H frame')
subplot(2,2,3) , imshow(Image_hsi2),title('S frame')
subplot(2,2,4), imshow(Image_hsi3), title('I frame')


%% Step-4 Convert HSI Frame to Bw
figure(2)
thresh_val1 = graythresh(Image_hsi1);
thresh_val11 = Image_hsi1 < thresh_val1;
thresh_val2 = graythresh(Image_hsi2); 
thresh_val21 = Image_hsi2 < thresh_val1;
thresh_val = thresh_val11 .* thresh_val21;
image_bw = im2bw(thresh_val);
subplot(2,4,1),imshow(image_bw), title('HSI to BW Conversion')

%% Step-5 Image Labelling
[lableed_Image, Numbers] = bwlabel(image_bw);
subplot(2,4,2),imshow(lableed_Image), title('Labelled Image')

%% Step-6 Morphological Operations
erode_Image  =  bwmorph(image_bw,'erode');
dilate_Image  = bwmorph(erode_Image,'dilate',3);
open_Image = imopen(dilate_Image,strel('disk',10));

subplot(2,4,3),imshow(erode_Image),title('Morphological- Erode Image')
subplot(2,4,4),imshow(dilate_Image),title('Morphological- Dilate Image')
subplot(2,4,5),imshow(open_Image),title('Morphological- Open Image')

%% Step-7 After Euler Test
filter_Image = imfill(open_Image,'holes');
subplot(2,4,6),imshow(filter_Image), title('Fill Holes')

filter_Image2 = bwareaopen(filter_Image,62);
subplot(2,4,7),imshow(filter_Image2), title('Remove Unwanted Noise')

%% Step-8 Filter Image Labelling
[lableed_Image1, Numbers1] = bwlabel(filter_Image2);
subplot(2,4,8),imshow(lableed_Image1), title('Label filtered Image')

%% Step-9 Plot Rectagle around Image
Iprops = regionprops(lableed_Image1);
Ibox = [Iprops.BoundingBox];
Ibox = reshape(Ibox,[4 Numbers1]);

figure,imshow(Input_read)
 
hold on;
for cnt = 1:Numbers1
    rectangle('position',Ibox(:,cnt),'edgecolor','r');
     pause(1)
end
title(['Total Face Detected = ', num2str(Numbers1)])