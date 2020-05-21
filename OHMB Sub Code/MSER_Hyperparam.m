T1list = dir('C:\Users\dcampoy\Pictures\TestingCannyEdge\T1\');
%T0list = dir('C:\Users\dcampoy\Pictures\TestingCannyEdge\T0\');


%Semester\Dissertation\Datasets\Ideal_Spectral_Imgs_Noise\T1'); %to load
%noise dataset
path = fullfile(getfield(T1list,{1,1}, 'folder'));
%T1savepath = 'C:\Users\dcampoy\Pictures\TestingCannyEdge\MSER_HyperParam\T1\T1';
%T0savepath = 'C:\Users\dcampoy\Pictures\TestingCannyEdge\MSER_HyperParam\T0\T0';
%for i = 3:length(T0list(:,1))
    img = fullfile(getfield(T1list,{6,1}, 'name'));
    I = imread(strcat(path,'\',img));
    imgname = img(1:end - 5);
    Img = im2uint8(I);
    mindiv = 0.79;
    maxvar = 0.9;
    delta = 10;
    maxarea = 0.75;
    minarea = 0;
    [r,f] = vl_mser(Img,'MinDiversity',mindiv,...
        'MaxVariation',maxvar,'Delta',delta, ... %I tried 0.7 too
        'MaxArea', maxarea, 'MinArea', minarea) ;
    %Plot MSER
    M = zeros(size(Img)) ;
    for x=r'
        s = vl_erfill(Img,x) ;
        M(s) = M(s) + 1;
    end
    figure;
    clf ; imagesc(Img) ; hold on ; axis equal off; colormap gray ;
    colormap default
    [c,h]=contour(M,(0:max(M(:)))+.5) ;
    set(h,'color','w','linewidth',3) ;
    
    %saveas(gcf,strcat(T1savepath,'\',imgname,'.tiff')
    saveas(gcf,strcat(T0savepath,'\',imgname,'.png'))
    
%end
