function parallelImageRead (filename)
% PARALLELIMAGEREAD Reads data from an image in parallel
%
% The input is the name of the file that will be read simultaneously on
% multiple labs. The image is then filtered to remove noise, and displayed
% in a figure.
%
% Example:
% parallelImageRead('MarsNoisy.tif')
%

% Serial version
I = imread(filename);
figure
imshow(I,'InitialMagnification',25);
title('\bfNoisy Image');

J =  medfilt2(I, [4 4]);
figure
imshow(J,'InitialMagnification',25);
title('\bfFiltered Image, Serial');

% Parallel version
% Get and display size of the image file
fileInfo = imfinfo (filename);
imageWidth = fileInfo.Width;
imageHeight = fileInfo.Height;
fprintf ('\nImage Size: %d by %d\n', imageWidth, imageHeight);

% Specify dimensions for overlapping border
borderWidth = 2;

spmd
  % TODO (2): Create distribution scheme using a codistributor object
  % The width and height of the image define the total size of the object
  
  % TODO (3): Identify image indices to import into each lab
  % Use globalIndices on the codistributor object to get the
  % start and end indices for each lab
 
  % Take care of the overlap
  startIndex = max(1, startIndex - borderWidth);
  endIndex = min(imageWidth, endIndex + borderWidth);
  
  % TODO (4): Import sections of the image on each lab into a variable
  % named myLocalPart 
  % Use the 'pixelRegion' option of IMREAD to achieve this

  % TODO (5): Filter the data on the local portion of each lab. Specify a filter
  % width that's twice as much as the border width (look at the
  % documentation for MEDFILT2)

  % Unpad the data
  if startIndex ~= 1 && endIndex ~= imageWidth
     mydata = mydata(:, borderWidth+1:end-borderWidth); % If we're neither at the beginning nor the end of the image, take care of overlap
  elseif startIndex == 1
     mydata = mydata(:, 1:end-borderWidth); % If we're at the image beginning, subtract the borderWidth
  elseif endIndex == imageWidth
     mydata = mydata(:, borderWidth+1:end); % If we're at the image end, add the borderWidth
  end
end

figure;

% TODO (6): Display the image stored in the variable mydata

title('\bfFiltered image');
