%BEST ACCURATION
clc; clear all; close all;

%deklarasi konstanta
jml_gambar = 40;
se = strel ('square',15);%fix jangan diubah
se5 = strel ('disk',2,0);
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
%    figure,subplot(2,4,1), imshow(retina ),title('retina');
%    subplot(2,4,2), imshow(kanal_hijau ),title('retina pada kanal hijau');;
%    subplot(2,4,3), imshow(inverted_image),title('inverted retina');

  
  %Histogram Equalization
  n=3;
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
  figure
  %subplot(1,3,1), imshow(imadjust_image),title('Hasil Ekualisasi Histogram');
  
  % top hat transform
  filtered  = imtophat(imadjust_image,se);
  contrast1  = imadjust(filtered );
  %subplot(1,3,2), imshow(contrast1),title('Hasil Top-Hat Transform');
  
  %median filter
  contrast = medfilt2(contrast1);
  %subplot(1,3,3), imshow(contrast),title('Hasil Median filter');

  %Citra Biner
  L_otsu = graythresh(contrast);
  BW = imbinarize (contrast,L_otsu);
  BW2 = im2bw(contrast ,0.4);
  
  %Menampilkan citra hasil segmentasi
  figure,
  subplot(1,2,1),imshow(BW),title('Hasil imbinarize');
  subplot(1,2,2), imshow(BW2), title('Hasil im2BW');
  
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





