%BEST ACCURATION
clc; clear all; close all;

%deklarasi konstanta
jml_gambar = 40;
se = strel ('square',15);%fix jangan diubah
k = 1;

for i = 21 : jml_gambar
  %membaca data citra retina untuk ditampilkan di kanal hijau
  retina =imread([num2str(i),'_training.tif']);
  data_vessel = imread([num2str(i),'_training.png']);
  
  
  %gambar grayscale kanal hijau
  kanal_hijau  = retina (:,:,2);
  vessel = im2bw(data_vessel);
  
  %gambar hasil inversi
  inverted_image  = imcomplement (kanal_hijau) ;
  
   %menampilkan gambar
    figure,subplot(1,3,1), imshow(retina ),title('Retina');
    subplot(1,3,2), imshow(kanal_hijau),title('green channel gray-scale retina');
    subplot(1,3,3), imshow(inverted_image),title('inverted gray-scale retina');
   
   %menampilkan gambar
    figure,subplot(1,2,1), imshow(inverted_image ),title('Inverted Gray Scale Retina');
    subplot(1,2,2), imhist(inverted_image),title('Histogram');

  %Histogram Equalization
  n=2;
  Idouble = im2double(inverted_image );
  avg = mean2(Idouble);
  stdI = std2(Idouble);
  min = avg-n*stdI;
  max = avg+n*stdI;
  if max > 1
    max =1;
  else
    max=max;
  end
  if min <0
    min=0;
  else
    min=min;
  end  
  imadjust_image = imadjust(inverted_image,[min max],[]);
%   CLAHE_image = adapthisteq(imadjust_image ,'clipLimit',0.02,'Distribution','exponential');
   figure,
   subplot(1,2,1), imshow(imadjust_image),title('Intensity Adjusted Gray Scale Retina');
   subplot(1,2,2), imhist(imadjust_image),title('Histogram');
  Idouble2 = im2double(imadjust_image );
  avg2 = mean2(imadjust_image);
  stdI2 = std2(imadjust_image);
  
%    %morphological reconstruction
%   marker = imopen (imadjust_image,se);
%   open_rekonstruksi = imreconstruct(marker,imadjust_image);
%   marker2 = imclose (open_rekonstruksi,se5);
%   close_rekonstruksi = imreconstruct(imcomplement (marker2),imcomplement (open_rekonstruksi));
%   close_rekonstruksi = imcomplement (close_rekonstruksi);
  
  % top hat transform
  filtered  = imtophat(imadjust_image,se);
  contrast1  = imadjust(filtered );
  figure,
   subplot(2,2,1), imshow(filtered),title('Top-Hat transformation image');
   subplot(2,2,2), imhist(filtered),title('Top-Hat transformation histogram');
   subplot(2,2,3), imshow(contrast1),title('Contrast adjusted top-Hat image');
   subplot(2,2,4), imhist(filtered),title('Top-Hat transformation histogram');
   
%    %FCM segmentation
%   IMG = im2double(contrast);
%   [centers,U]= fcm (IMG(:),2);
%   FCM_image=reshape(U(1,:),size(contrast));
  
  %median filter
  contrast = medfilt2(contrast1);
  figure, imshow(contrast),title('Median filter Image');

  %Citra Biner
  BW = im2bw(contrast ,0.37);
  
  %Menampilkan citra hasil segmentasi
  figure,
  subplot(1,2,1),imshow(BW),title('Hasil algoritma segmentasi');
  subplot(1,2,2), imshow(vessel), title('Hasil segmentasi manual');
  
   %menghitung akurasi
   [row col] = size (vessel);
   TP =0; TN=0; FP=0; FN=0;
     for i=1:row
      for j=1:col
         if (vessel(i,j)==1 && BW(i,j)==1)
            TP =TP +1;
          else if (vessel(i,j)==0 && BW(i,j)==0)
             TN =TN+1;
             else if(vessel(i,j)== 0 && BW(i,j)==1)
               FP = FP+1;
                 else (vessel(i,j)==1 && BW(i,j)==0)
                      FN = FN+1;
                 end
              end
          end
      end
     end
      if (k<11)
         Tp(1,k)= TP;
         Tn(1,k)= TN;
         Fp(1,k)= FP;
         Fn(1,k)= FN;
         sensitivity(1,k) = (TP)/(TP+FN)*100;
         specificity(1,k) = (TN)/(TN+FP)*100;
         accuracy(1,k) = (TP+TN)/(TP+TN+FP+FN)*100;
      else
         Tp(2,k-10)= TP;
         Tn(2,k-10)= TN;
         Fp(2,k-10)= FP;
         Fn(2,k-10)= FN;
         sensitivity(2,k-10) = (TP)/(TP+FN)*100;
         specificity(2,k-10) = (TN)/(TN+FP)*100;
         accuracy(2,k-10) =(TP+TN)/(TP+TN+FP+FN)*100;
     end
   k = k+1;
   
end





