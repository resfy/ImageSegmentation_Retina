%A FUNCTION TO DETECT EDGES IN THE IMAGE

function [imageOut]=kirschedge(imageIn)
    imageIn = double(imageIn);
    [N M L] = size(imageIn);
    g = double([5 5 5;-3 0 -3; -3 -3 -3] );
    kirschImage = zeros(N,M,8);
    for j = 1:8
        theta = (j-1)*45;
        gDirection = imrotate(g,theta,'crop');
        kirschImage(:,:,j) = conv2(imageIn,gDirection,'same');
    end
    imageOut = zeros(N,M);
    for n = 1:N
        for m = 1:M
            imageOut(n,m) = max(kirschImage(n,m,:));
        end
    end
end