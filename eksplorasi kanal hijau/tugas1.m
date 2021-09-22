##TUGAS BESAR EB3206
##"Segmentasi struktur pembuluh darah retina dari citra fotografi fundus" 
##Bagian I : Eksplorasi kanal hijau
##Last Update : 17 April 2020.

##data yang dipilih adalah :
##21_training.tif       1_test.tif
##23_training.tif       2_test.tif
##25_training.tif       4_test.tif
##31_training.tif       7_test.tif
##36_training.tif       9_test.tif
##alasan data tersebut dipilih :
##- Citra diatas dianggap mewakili seluruh karakteristik data
##- Dipilih 5 data citra retina training yang memiliki sebaran histogram bervariasi
##  Hal tersebut bertujuan untuk mencakup seluruh karakteristik histogram citra retina yang berbeda-beda
##- Dipilih 5 data citra retina test dengan beberapa variasi bentuk retina dan pembuluh darah
##  Dengan alasan yang sama dengan pemilihan citra training
##  Namun tetap memilih gambar dengan karakteristik yang sejenis dalam jumlah yg lebih banyak

##semua citra tersebut di rename menjadi [no]_sampel.tif agar mudah saat pembacaan citra


clc; clear all; close all;
pkg load image;

%KONSTANTA
%jml_gambar = 2;
fontSize = 12;
k =1;
m =1;
mean = zeros(2,10);
std_dev = zeros(2,10);


for i = 10 : 10
  %membaca sampel gambar retina
  i = num2str (i);
  string1 = '_sampel.tif';
  judul = strcat (i, string1);
  retina = imread(judul); 
  
  %membaca sampel gambar pembuluh darah
  string2 = '_sampel.png';
  judul_vessel = strcat (i, string2);
  vessel = imread(judul_vessel); 
  
  %gambar grayscale kanal hijau
  greenChannel = retina(:,:,2);
  
##  %HISTOGRAM RETINA
##  figure,
##  subplot(1,3,1), imshow(retina),
##  subplot(1,3,2), imshow(greenChannel),title(strcat('Retina Sampel ke-',i), 'FontSize', fontSize);
##  subplot(1,3,3), imhist(greenChannel); 
##  
##  % MEAN DAN STANDAR DEVIASI RETINA
##  if (k<6)
##    mean_retina(1,k) = mean2(greenChannel);
##    std_dev_retina(1,k) = std2(greenChannel);
##  else
##    mean_retina(2,k-5) = mean2(greenChannel);
##    std_dev_retina(2,k-5) = std2(greenChannel);
##  end
  
  % Ekstraksi nilai intensitas asli pembuluh darah
  [row col] = size (greenChannel);
  pem_darah = zeros(row, col);
  N = 0; 
  for r=1:row
    for s=1:col
      % ketika vessel = 1 berarti ada pembuluh darah
      if (vessel(r,s)==1)
        N = N+1;
        %dibentuk citra pem_darah yang hanya mengandung intensitas pembuluh darah dari retina kanal hijau
        pem_darah(r,s)= greenChannel(r,s);
      end
    end
  end
  figure,
  subplot (1,2,1), imshow (pem_darah),title(strcat('Vessel Sampel ke-',i), 'FontSize', fontSize);
  % subplot (1,2,2), hist (pem_darah(:),1:max(pem_darah(:)));
  

  % Ambil nilai intensitas pembuluh darah saja
  data_vessel = zeros(N-1,1);
  for t=1:row
    for u=1:col
      if (pem_darah(t,u)!=0)
        data_vessel(m,1)= pem_darah(t,u);
        m = m+1;
      end
    end
  end
  %subplot(1,3,2), hist (data_vessel);

  %HISTOGRAM PEMBULUH DARAH
  %MASALAH : skala dari hitogramnya masi bermasalah,
  n_min = min(min(data_vessel));
  n_max = max(max(data_vessel));
  x = (n_min-n_min):n_max;
  y = zeros(1, n_max-n_min+n_min+1);
  for v=1:N-1
    y(1, data_vessel(v,1)+1) = y(1, data_vessel(v,1)+1) + 1;
  end
  subplot(1,2,2), bar (x,y);
  v=1;
  %MEAN DAN STANDAR DEVIASI PEMBULUH DARAH
  if (k<6)
    mean_vessel(1,k) = mean2(data_vessel);
    std_dev_vessel(1,k) = std(data_vessel);
  else
    mean_vessel(2,k-5) = mean2(data_vessel);
    std_dev_vessel(2,k-5) = std(data_vessel);
  end
  k = k+1;
 endfor