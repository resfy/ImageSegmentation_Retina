%BEST IMAGE
clc; clear all; close all;


%deklarasi konstanta
jml_gambar = 21;
se = strel ('disk',10,0);%fix jangan diubah
se2 = strel ('square',1);
se5 = strel ('disk',2,0);
k = 1;



for i = 21 : jml_gambar
  %membaca data citra retina untuk ditampilkan di kanal hijau
  retina =imread([num2str(i),'_training.tif']);
  vessel = imread([num2str(i),'_training.png']);
  %gambar grayscale kanal hijau
  kanal_hijau  = retina (:,:,2);
  %gambar hasil inversi
  inverted_image  = imcomplement (kanal_hijau) ;
%   %menampilkan gambar
%   figure,subplot(2,2,1), imshow(retina );
%   subplot(2,2,2), imshow(kanal_hijau );
%   subplot(2,2,3), imshow(inverted_image );
%   subplot(2,2,4), imhist (inverted_image );
  
  %CLAHE ( contrast-Limited Adaptive Histogram Equalization )
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
  imadjust_image = imadjust(inverted_image,[min max],[]);
  CLAHE_image = adapthisteq(imadjust_image ,'clipLimit',0.02,'Distribution','exponential');
  figure,subplot(1,2,1), imshow(imadjust_image),title('Imadjust Image');
  subplot(1,2,2),imshow(CLAHE_image),title('CLAHE Image');
  
  %morphological reconstruction
  marker = imopen (imadjust_image,se);
  open_rekonstruksi = imreconstruct(marker,imadjust_image);
  marker2 = imclose (open_rekonstruksi,se5);
  close_rekonstruksi = imreconstruct(imcomplement (marker2),imcomplement (open_rekonstruksi));
  close_rekonstruksi = imcomplement (close_rekonstruksi);
    figure,subplot (1,2,1), imshow(open_rekonstruksi);    title('open-by-morphological recontruction');
    subplot (1,2,2), imshow(close_rekonstruksi);    title('close-by-morphological recontruction');
 
  
  % top hat transform
  filtered  = imtophat(CLAHE_image,se);
  contrast  = imadjust(filtered );
  filtered2  = imtophat(close_rekonstruksi,se);
  contrast2  = imadjust(filtered2 );
  
  %Citra Biner
   BW = im2bw(contrast ,0.4);
   
   BW2 = im2bw (contrast2,0.4);
   
   figure,
   subplot(1,3,1),imshow(BW),title('imadjust');
   subplot(1,3,2),imshow(BW2),title('binarize Top-HAT image');
   subplot(1,3,3), imshow(vessel), title('vessel image');
  
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
        accuracy(1,k) = (TP+TN)/(TP+TN+FP+FN)*100;
        else
        accuracy(2,k-10) =(TP+TN)/(TP+TN+FP+FN)*100;
    end
  k = k+1;
  
end





