clc
clear 
close all

%% Step-1  Input Image 
figure(1)
Input_read =  imread('Sekil1.jpg');
subplot(2,2,1),imshow(Input_read), title('Color Image')

%% Step-2  RGB Image to Grayscale Image
gray_Image = rgb2gray(Input_read);
subplot(2,2,2),imshow(gray_Image), title('RGB Image to Grayscale Image')

%% Step-3  Contrast and saturates adjustment
gray_Image = imadjust(gray_Image);
subplot(2,2,3),imshow(gray_Image), title('Contrast and saturates adjustment')

%% Step-4  Find optimum threshold value and Grayscale Image to Binary Image 
figure(2)
thresh_val = graythresh(gray_Image);
image_bw = im2bw(gray_Image, thresh_val);
subplot(2,4,1),imshow(image_bw), title('Grayscale Image to BW Image')

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