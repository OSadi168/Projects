
ImageList = dir(fullfile("C:\Users\omsad\Downloads\Data Engineering-20240104T175841Z-001\Data Engineering\images"));
mkdir('Resized Images')

for i = 1:size(ImageList)

resizedImage = imresize(I,[500,500]);
subplot(2,1,1);
imshow(I);
title("Original Image")
subplot(2,1,2);
imshow(resizedImage);
title("Resied Image")
imwrite(resizedImage,fullfile('Resized Images',strcat(num2str(i))));

end