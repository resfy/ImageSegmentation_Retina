clear; clc;
pkg load image;

% Read in original RGB image.
rgbImage = imread('21_training.tif');
pemdar = imread('21_training.png');

% Extract color channels.
greenChannel = rgbImage(:,:,2); % Green channel

##figure 1;
##fontSize = 20;
##imhist (greenChannel);
##title('Histogram Green Channel', 'FontSize', fontSize);
##
##figure 2;
##imshow (greenChannel);
##title('Green Channel in Gray Level', 'FontSize', fontSize);
##
##figure 3;
##imshow (pemdar);
##title('Pembuluh Darah', 'FontSize', fontSize);

% Ekstraksi nilai intensitas asli pembuluh darah
[row col] = size (greenChannel);
pem_darah = zeros(row, col);
N = 0; 
for i=1:row
  for j=1:col
    if (pemdar(i,j)==1)
      N = N+1;
      pem_darah(i,j)= greenChannel(i,j);
    end
  end
end

##figure 4;
##imshow (pem_darah);
##title('Pembuluh Darah', 'FontSize', fontSize);

% Ambil nilai intensitas pembuluh darah saja
data_pemdar = zeros(N-1,1);
k = 1;
for i=1:row
  for j=1:col
    if (pem_darah(i,j)!=0)
      data_pemdar(k,1)= pem_darah(i,j);
      k = k+1;
    end
  end
end

% Cari mean & standar deviasi
mean = mean2(data_pemdar);
std = std(data_pemdar); 

% Nampilin histogram cara manual
n_min = min(min(data_pemdar));
n_max = max(max(data_pemdar));
x = n_min:n_max
y = zeros(1, n_max-n_min+1)
for k=1:N-1
  y(1, data_pemdar(k,1)-8) = y(1, data_pemdar(k,1)-8) + 1;
end
figure 5;
bar (x,y);
