%{
Take one image mode picture and plot the 2D image also the sum of each
Vpixel.  Return the sum of Vpixel.

Benjamin Kao
Last update: 2020/11/24
%}


function img_hSum=fun_take_picture_and_return_hSum(Xlength,Ylength,SDS_location)
[ret] = StartAcquisition();
CheckWarning(ret);
[ret] = WaitForAcquisition();
CheckWarning(ret);
[ret, imageData] = GetMostRecentImage(Xlength * Ylength);
CheckWarning(ret);
if ret == atmcd.DRV_SUCCESS
    %display the acquired image
    imageData=transpose(reshape(imageData, Xlength, Ylength));
    nexttile(1);
    imagesc(imageData);
    colormap(gray);
    colorbar;
    nexttile(2);
    img_hSum=sum(imageData,2);
    plot(img_hSum);
    
    hold on;
    for s=1:size(SDS_location,1)
        for j=1:2
            xline(SDS_location(s,j));
        end
    end
    hold off;
    
    drawnow;
else
    error('Camera acquisition wrong!');
end
end