%BEST ACCURATION
clc; clear all; close all;

%deklarasi konstanta
jml_gambar = 23;
se = strel ('octagon',15);%fix jangan diubah
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
  
  %Histogram Equalization
  n=3;
  Idouble = im2double(inverted_image );
  avg{i} = mean2(Idouble);
  if avg{i} < 0.5
      imadjust_image = imadjust(inverted_image,[0.3 0.7],[]);
  else 
      imadjust_image = imadjust(inverted_image,[0.4 0.6],[]);
  end
  figure, imshow (imadjust_image);
  
  %region growing
  

  
 
  
end





