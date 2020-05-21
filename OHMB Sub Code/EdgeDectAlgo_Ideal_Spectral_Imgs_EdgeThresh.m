%% Testing block for viewing original image
I = imread('D:\KDD\2nd Semester\Dissertation\Datasets\Ideal_Spectral_Imgs - Original\T1\T1\IMG_113.tiff');


%imshow(I)

%% Testing block for viewing various SIFT features imposed on the image

f = vl_sift(vl_imsmooth(single(I),500), 'edgethresh', 1000) ;

imshow(BW)
hold on;

h1 = vl_plotframe(f) ;
h2 = vl_plotframe(f) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
%% Testing HOG feature visualisation Orientations
I = imcomplement(I); %Invert the image
%BW = imbinarize(I, 'adaptive');
%BW = imbinarize(I,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4);
% figure
% imshow(BW)
% saveas(gcf,strcat('D:\KDD\2nd Semester\Dissertation\Datasets\Ideal_Spectral_Imgs - Original\Binarize\T1\IMG_','1','.tiff'))
% title('Binarize Image')

cellSize = 8 ;
hog = vl_hog(I, cellSize, 'verbose');

imhog = vl_hog('render', hog, 'verbose') ;
clf ; imagesc(imhog) ; colormap gray ;

% Specify the number of orientations
hog20 = vl_hog(I,cellSize,'numOrientations', 20) ;
imhog20 = vl_hog('render', hog20, 'numOrientations', 20) ;
hog40 = vl_hog(I,cellSize,'numOrientations', 40) ;
imhog40 = vl_hog('render', hog40, 'numOrientations', 40) ;
hog60 = vl_hog(I,cellSize,'numOrientations', 60) ;
imhog60 = vl_hog('render', hog60, 'numOrientations', 60) ;
figure ; clf ;
subplot(1,3,1) ; imagesc(imhog20) ; colormap gray ;
axis image off ; title('Num of Orientations 20') ;
subplot(1,3,2) ; imagesc(imhog40) ; colormap gray ;
axis image off ; title('Num of Orientations 40') ;
subplot(1,3,3) ; imagesc(imhog60) ; colormap gray ;
axis image off ; title('Num of Orientations 60') ;
%% Calculating and imposing MSER features onto the Spectrograms
T1list = dir('D:\KDD\2nd Semester\Dissertation\Datasets\Ideal_Spectral_Imgs_Original\T1\T1');
%T1list = dir('D:\KDD\2nd Semester\Dissertation\Datasets\Ideal_Spectral_Imgs_Noise\T1'); %to load noise dataset
path = fullfile(getfield(T1list,{1,1}, 'folder'));
T1savepath = 'D:\KDD\2nd Semester\Dissertation\Datasets\Ideal_Spectral_MSER_Imgs_Noise\T1\T1';
for i = 3:length(T1list(:,1))
    img = fullfile(getfield(T1list,{i,1}, 'name'));
    I = imread(strcat(path,'\',img));
    
    Img = im2uint8(I);
    [r,f] = vl_mser(Img,'MinDiversity',0.7,...
        'MaxVariation',0.2,...
        'Delta',10) ;
    %Plot MSER
    M = zeros(size(Img)) ;
    for x=r'
        s = vl_erfill(Img,x) ;
        M(s) = M(s) + 1;
    end
    figure ;
    clf ; imagesc(Img) ; hold on ; axis equal off; colormap gray ;
    [c,h]=contour(M,(0:max(M(:)))+.5) ;
    set(h,'color','y','linewidth',3) ;
    saveas(gcf,strcat(T1savepath,'\','IMG_',string(i),'.tiff'))
end

%T0list = dir('D:\KDD\2nd Semester\Dissertation\Datasets\Ideal_Spectral_Imgs - Original\T0\T0');
T0list = dir('D:\KDD\2nd Semester\Dissertation\Datasets\Ideal_Spectral_Imgs_Noise\T0'); %to load noise dataset
path = fullfile(getfield(T0list,{1,1}, 'folder'));
T0savepath = 'D:\KDD\2nd Semester\Dissertation\Datasets\Ideal_Spectral_MSER_Imgs_Noise\T0\T0';
for i = 3:length(T0list(:,1))
    img = fullfile(getfield(T0list,{i,1}, 'name'));
    I = imread(strcat(path,'\',img));
    
    Img = im2uint8(I);
    [r,f] = vl_mser(Img,'MinDiversity',0.7,...
        'MaxVariation',0.2,...
        'Delta',10) ;
    %Plot MSER
    M = zeros(size(Img)) ;
    for x=r'
        s = vl_erfill(Img,x) ;
        M(s) = M(s) + 1;
    end
    figure ;
    clf ; imagesc(Img) ; hold on ; axis equal off; colormap gray ;
    [c,h]=contour(M,(0:max(M(:)))+.5) ;
    set(h,'color','y','linewidth',3) ;
    saveas(gcf,strcat(T0savepath,'\','IMG_',string(i),'.tiff'))
end

% Plot region frames
% imshow(Img)
% f = vl_ertr(f) ;
% vl_plotframe(f) ;


%% Testing Flipping Image for HOG
cellSize = 16 ;
hog = vl_hog(I, cellSize) ;
%hog = vl_hog(I,cellSize,'numOrientations', 3) ;

hogFromFlippedImage = vl_hog(I(:,end:-1:1,:), cellSize) ;
perm = vl_hog('permutation') ;
flippedHog = hog(:,end:-1:1,perm) ;

imHog = vl_hog('render', hog) ;
%imhog = vl_hog('render', hog, 'numOrientations', 3) ;
imHogFromFlippedImage = vl_hog('render', hogFromFlippedImage) ;
imFlippedHog = vl_hog('render', flippedHog) ;

figure(4) ; clf ;
subplot(1,3,1) ; imagesc(imHog) ;
axis image off ; title('HOG features') ;
subplot(1,3,2) ; imagesc(imHogFromFlippedImage) ;
axis image off ; title('Flipping the image') ;
subplot(1,3,3) ; imagesc(imFlippedHog) ;
axis image off ; title('Flipping the features') ;
colormap gray ;
%vl_demo_print('hog_flipping',1) ;
%% Cycle through each image to build SIFT features and impose them onto the original spectrogram image
T1list = dir('D:\KDD\2nd Semester\Dissertation\Datasets\Ideal_Spectral_Imgs - Original\T1\T1');
path = fullfile(getfield(T1list,{1,1}, 'folder'));
%T1savepath = 'D:\KDD\2nd Semester\Dissertation\Datasets\Ideal_Spectral_SIFT_Imgs_Noise\T1';
for i = 3:64
    img = fullfile(getfield(T1list,{i,1}, 'name'));
    I = imread(strcat(path,'\',img));
    f = vl_sift(vl_imsmooth(I,500), 'edgethresh', 10000) ;
    %f = vl_sift(I, 'edgethresh', 70) ;
    %f = vl_sift(vl_imsmooth(I,20,'Kernel','TRIANGULAR','Padding','ZERO'), 'edgethresh', 10000) ;
    figure
    imshow(I)
    hold on;
    
    h1 = vl_plotframe(f) ;
    h2 = vl_plotframe(f) ;
    set(h1,'color','k','linewidth',3) ;
    set(h2,'color','y','linewidth',2) ;
    saveas(gcf,strcat(T1savepath,'\','IMG_',string(i),'.tiff'))
end

T0list = dir('D:\KDD\2nd Semester\Dissertation\Datasets\Ideal_Spectral_Imgs_Noise\T0')
path = fullfile(getfield(T0list,{1,1}, 'folder'));
T0savepath = 'D:\KDD\2nd Semester\Dissertation\Datasets\Ideal_Spectral_SIFT_Imgs_Noise\T0'
for i = 3:64
    img = fullfile(getfield(T0list,{i,1}, 'name'));
    I = imread(strcat(path,'\',img));
    f = vl_sift(vl_imsmooth(I,500), 'edgethresh', 10000) ;
    %f = vl_sift(I, 'edgethresh', 70) ;
    %f = vl_sift(vl_imsmooth(I,20,'Kernel','TRIANGULAR','Padding','ZERO'), 'edgethresh', 10000) ;
    figure
    imshow(I)
    hold on;
    
    h1 = vl_plotframe(f) ;
    h2 = vl_plotframe(f) ;
    set(h1,'color','k','linewidth',3) ;
    set(h2,'color','y','linewidth',2) ;
    saveas(gcf,strcat(T0savepath,'\','IMG_',string(i),'.tiff'))
end
%% Extract CannyEdges and impost them onto EEG
T1list = dir('D:\KDD\2nd Semester\Dissertation\Datasets\Ideal_Spectral_Imgs_Original\T1\T1');
path = fullfile(getfield(T1list,{1,1}, 'folder'));
%read image
img = fullfile(getfield(T1list,{9,1}, 'name'));
I = imread(strcat(path,'\',img));
Isize = [size(I,1) size(I,2)];
% Detect edges
edges = zeros(Isize) + inf;
edges(edge(I, 'canny')) = 0 ;
% compute distance transform
[distanceTransform, neighbors] = vl_imdisttf(single(edges)) ;

% plot
[u,v] = meshgrid(1:Isize(2),1:I(1)) ;
[v_,u_] = ind2sub(Isize, neighbors) ;

% avoid cluttering the plot too much
u = u(1:3:end,1:3:end) ;
v = v(1:3:end,1:3:end) ;
u_ = u_(1:3:end,1:3:end) ;
v_ = v_(1:3:end,1:3:end) ;

figure(1) ; clf ; imagesc(I) ; axis off image ;
figure(2) ; clf ; imagesc(edges) ; axis off image ;
figure(3) ; clf ; imagesc(edges) ; axis off image ;
hold on ; h = quiver(u,v,u_-u,v_-v,0) ; colormap gray ;
figure(4) ; clf ; imagesc(sqrt(distanceTransform)) ; axis off image ;

figure(1) ; vl_demo_print('imdisttf_src') ;
figure(2) ; vl_demo_print('imdisttf_edge') ;
figure(3) ; vl_demo_print('imdisttf_neigh') ;
