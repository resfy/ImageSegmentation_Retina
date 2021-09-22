%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                 %
%                                                                 %
% Author: Enio GJERGA                                             %
% Date: 07/05/2015                                                %
% email: enio.gjerga@gmail.com                                    %
% Universiteit Gent, Belgium                                      %
%                                                                 %
% Description: This code segments a region based on the value of  %
% the pixel selected and on which thresholding region it belongs  %
% based on the region growing algorithm.                          %
%                                                                 %
%                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I = im2double(imread('Image_To_Read.tiff'));
figure, imshow(I)
%imtool(I);
Isizes = size(I); %size of the image

threshI = multithresh(I, 3); %thresholding for three regions

[m, n]=ginput(1); %pick one pixel of the region to be segmented
c = impixel(I, m, n); %value of the pixel picked
currPix = c(1); %current pixel

surr = [-1 0; 1 0; 0 -1; 0 1]; %create a mask which represents the four surrounding pixels
mem = zeros(Isizes(1)*Isizes(2), 3); %create a register to put the pixel coordinates and pixel value 
mem(1, :) = [m, n, currPix]; %insert initial picked pixel to the register
regSize = 1; %initial size

J = zeros(Isizes(1), Isizes(2)); %create another black image with the same size as the original image

init = 1;
posInList = 1;
k=1; %create the initial condition to run the loop
%The region growing algorithm.
while(k==1)
    
  for l=init:posInList %first pointer on the register
  for j=1:4 %second pointer for the neighboring pixels
        m1 = m + surr(j,1);
        n1 = n + surr(j,2);
        
        check=(m1>=1)&&(n1>=1)&&(m1<=Isizes(1))&&(n1<=Isizes(2)); %simple check if pixel position still inside the image
        
        current = impixel(I, m1, n1);
        currPix = current(1);
        if(check && currPix<=threshI(2) && (J(m1, n1)==0)) %check if it belongs to the thresholding boundary and if not set yet on the image we want to recreate
            posInList = posInList+1;
            mem(posInList, :) = [m1, n1, currPix]; %add the new pixel
            J(m1, n1) = 1;
        end
  end
  end
  if(posInList == init) %when there is no more pixels to add
      k = 0; %make k=0 to close the loop
  else
      init = init+1;
      m = mem(init, 1, :);
      n = mem(init, 2, :);
      k = 1; %keep running the loop
  end
end

imshow(J); %the segmented black and white region