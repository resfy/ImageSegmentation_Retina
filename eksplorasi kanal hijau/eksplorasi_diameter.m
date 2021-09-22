clear; clc;
pkg load image;

pi = 180;

% Read file
vessel = imread('1_sampel.png');
retina = imread('1_sampel.tif');

greenChannel = retina(:,:,2);

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
  

% Pilih titik uji vessel terbesar (cabang utama)
% Pemilihan titik ujinya berurutan, 
% jadi buat 1 nilai diameter butuh 2 titik uji (disimpan di x1 & x2)
f1=figure;
x1=zeros(2,1);
x2=zeros(2,1);
imshow(retina);
hold on;
but = 1;
n1 = 0; n2 = 0;
while but == 1
    [xi,yi,but] = ginput(1);
    if but == 1
        plot(xi,yi,'r+')
        if (n1 == n2)
          n1 = n1+1;
          x1(:,n1) = [xi;yi];
        else
          n2 = n2+1;
          x2(:,n2) = [xi;yi];
        end
    end
end
% Hitung diameter
d_besar = zeros(1,n2);
for i=1:n2
  delta_x = x2(1,i) - x1(1,i);
  delta_y = x2(2,i) - x1(2,i);
  d_besar(1,i) = sqrt(delta_x*delta_x + delta_y*delta_y);
end

% Pilih titik uji vessel sedang
% Pemilihan titik ujinya berurutan, 
% jadi buat 1 nilai diameter butuh 2 titik uji (disimpan di x1 & x2)
x3=zeros(2,1);
x4=zeros(2,1);
imshow(retina);
but = 1;
n1 = 0; n2 = 0;
while but == 1
    [xi,yi,but] = ginput(1);
    if but == 1
        plot(xi,yi,'b+')
        if (n1 == n2)
          n1 = n1+1;
          x3(:,n1) = [xi;yi];
        else
          n2 = n2+1;
          x4(:,n2) = [xi;yi];
        end
    end
end
% Hitung diameter
d_sedang = zeros(1,n2);
for i=1:n2
  delta_x = x4(1,i) - x3(1,i);
  delta_y = x4(2,i) - x3(2,i);
  d_sedang(1,i) = sqrt(delta_x*delta_x + delta_y*delta_y);
end

% Pilih titik uji vessel terkecil (cabang utama)
% Pemilihan titik ujinya berurutan, 
% jadi buat 1 nilai diameter butuh 2 titik uji (disimpan di x1 & x2)
x5=zeros(2,1);
x6=zeros(2,1);
imshow(retina);
but = 1;
n1 = 0; n2 = 0;
while but == 1
    [xi,yi,but] = ginput(1);
    if but == 1
        plot(xi,yi,'g+')
        if (n1 == n2)
          n1 = n1+1;
          x5(:,n1) = [xi;yi];
        else
          n2 = n2+1;
          x6(:,n2) = [xi;yi];
        end
    end
end
% Hitung diameter
d_kecil = zeros(1,n2);
for i=1:n2
  delta_x = x6(1,i) - x5(1,i);
  delta_y = x6(2,i) - x5(2,i);
  d_kecil(1,i) = sqrt(delta_x*delta_x + delta_y*delta_y);
end

hold off
close(f1);

%PLOT LOKASI PIXEL VS INTENSITAS PEMBULUH DARAH
