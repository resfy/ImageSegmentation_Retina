%MASIH SANGAT MUNGKIN UNTUK DIPERBAIKI AKURASINYA
clc; clear all; close all;

%deklarasi konstanta
jml_gambar = 40;
se = strel ('square',15);%fix jangan diubah
se5 = strel ('square',4);
k = 1;

for i = 21 : jml_gambar
  %membaca data citra retina untuk ditampilkan di kanal hijau
  retina =imread([num2str(i),'_training.tif']);
  data_vessel = imread([num2str(i),'_training.png']);
  vessel = im2bw(data_vessel);
  %gambar grayscale kanal hijau
  kanal_hijau  = retina (:,:,2);
  %gambar hasil inversi
  inverted_image  = imcomplement (kanal_hijau) ;
%   %menampilkan gambar
%   figure,subplot(2,2,1), imshow(retina );
%   subplot(2,2,2), imshow(kanal_hijau );
%   subplot(2,2,3), imshow(inverted_image );
%   subplot(2,2,4), imhist (inverted_image );
  
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
  
  % top hat transform
  filtered  = imtophat(imadjust_image,se);
  contrast  = imadjust(filtered );


  %FCM segmentation
  IMG = im2double(contrast);
  [centers,U]= fcm (IMG(:),2);
  FCM_image=reshape(U(1,:),size(contrast));
%   [maxI,I] == max(U,[],1);
%   BW = reshape(IMG,size(contrast));
  figure,subplot (1,2,1),imshow(retina), title ('retina');
  subplot (1,2,2),imshow(FCM_image), title ('fuzzy C means clustering image');

  %median filter
  filtered = medfilt2(FCM_image,[3 3]);
  contrast2  = imadjust(filtered);
  %morphological reconstruction
  marker = imopen (contrast2,se5);
  open_rekonstruksi = imreconstruct(marker,contrast2);


  %citra biner
  BW = im2bw(open_rekonstruksi ,0.5);

  %menampilkan gambar 
  figure,
  subplot(1,2,1),imshow(BW),title('Hasil segmentasi dengan median filter');
  subplot(1,2,2), imshow(vessel), title('manual segmentation');
  
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





