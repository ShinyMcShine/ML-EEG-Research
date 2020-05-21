import matplotlib.pyplot as plt  # to plot any graph
import cv2 as cv
import scipy.ndimage as ndi  # to determine shape centrality
from pylab import rcParams
import numpy as np
import os
from PIL import Image

def distanceTransform():
    rcParams['figure.figsize'] = (8, 8)  # setting default size of plots
    #imgpath = 'C:/Users/dcampoy/Pictures/TestingCannyEdge/Test_saveImages/T1/T1/IMG_139.jpg' #testing another EEG
    #imgpath = 'D:/KDD/2nd Semester/Dissertation/Datasets/EEG JPG/T0/5HzT03a/IMG_0.jpg'
    #imgpath = 'C:/Users/dcampoy/Pictures/TestingCannyEdge/T1/IMG_139.jpg'
    img_eeg_gray = cv.imread(imgpath, cv.IMREAD_GRAYSCALE)
    avg_pixel = np.mean(img_eeg_gray)
    print("\nAverage pixel value of image is ", avg_pixel)
    #dst = cv.adaptiveThreshold(img_eeg_gray, 255, cv.ADAPTIVE_THRESH_GAUSSIAN_C, cv.THRESH_BINARY, 3, 2);

    (thresh, img_bw) = cv.threshold(img_eeg_gray, 128, 255, cv.THRESH_BINARY | cv.THRESH_OTSU )

    dist_2d = ndi.distance_transform_edt(img_bw)
    fig = plt.figure(figsize=(8,8))
    plt.imshow(img_bw, cmap='Greys', alpha=.2)
    plt.imshow(dist_2d, cmap='plasma', alpha=.2)
    plt.contour(dist_2d, cmap='plasma')
    plt.axis('off')

    #fig.savefig("C:/Users/dcampoy/Pictures/TestingCannyEdge/Test_saveImages/T1/T1/IMG_145.png", bbox_inches='tight',format='png', pad_inches=0)

    # Compare the two images together after discovering its edges and contours
    plt.figure()
    plt.subplot(121), plt.imshow(img_eeg_gray, cmap='gray')
    plt.title('Original Image'), plt.xticks([]), plt.yticks([])
    plt.subplot(122), plt.imshow(img_bw, cmap='Greys', alpha=.2)
    plt.imshow(dist_2d, cmap='plasma', alpha=.2)
    plt.contour(dist_2d, cmap='plasma')
    plt.title('Distance Transform after Binarization'), plt.xticks([]), plt.yticks([])
    plt.show()


def cnvrt_spectr (dir):
    rcParams['figure.figsize'] = (8, 8)  # setting default size of plots
    #savepath = 'D:/KDD/2nd Semester/Dissertation/Datasets/Binarize_Distransform_EEG/T1'
    #savepath =  "C:/Users/dcampoy/Pictures/TestingCannyEdge/EEG DistTransform"
    savepath = "D:/KDD/2nd Semester/Dissertation/Datasets/OHBM_DisTransformEEG"
    ext = '.png'
    for root, dirs, files in os.walk(dir):
        print('Root dir is ', root)
        #rootname = root
        for name in dirs:
            subdir = name
            print('This is sub dir ', subdir)
            for names in os.listdir(root+"/"+subdir):
                filename = names
                print('Processing file name', filename)
                name, tiff_ext = filename.split('.', 1)
                img_eeg_gray = cv.imread(root+"/"+subdir+"/"+filename, cv.IMREAD_GRAYSCALE)
                avg_pixel = np.mean(img_eeg_gray)
                print("\nAverage pixel value of image is ", avg_pixel)
                (thresh, img_bw) = cv.threshold(img_eeg_gray, 128, 255, cv.THRESH_BINARY | cv.THRESH_OTSU)
                dist_2d = ndi.distance_transform_edt(img_bw)
                fig = plt.figure(figsize=(8, 8))
                plt.imshow(img_bw, cmap='Greys', alpha=.2)
                plt.imshow(dist_2d, cmap='plasma', alpha=.2)
                plt.contour(dist_2d, cmap='plasma')
                plt.axis('off')
                #plt.margins(0, 0)
                #plt.gca().xaxis.set_major_locator(plt.NullLocator())
                #plt.gca().yaxis.set_major_locator(plt.NullLocator())
                plt.savefig(savepath +"/"+ subdir + "/"+ name + ext, format='png', pad_inches=0, bbox_inches = 'tight')
                print("Image saved, ", filename)

def cvrt_tiff (dir):
    #savepath = "D:/KDD/2nd Semester/Dissertation/Datasets/EEG JPG/T0/5HzT03a/"
    #savepath = "D:/KDD/2nd Semester/Dissertation/Datasets/EEG JPG/T0/5HzT03b/"
    #savepath = "D:/KDD/2nd Semester/Dissertation/Datasets/EEG JPG/T0/5HzT04a/"
    #savepath = "D:/KDD/2nd Semester/Dissertation/Datasets/EEG JPG/T0/5HzT04b/"
    #savepath = "D:/KDD/2nd Semester/Dissertation/Datasets/EEG JPG/T0/5HzT06a/"
    #savepath = "D:/KDD/2nd Semester/Dissertation/Datasets/EEG JPG/T0/5HzT06b/"
    #savepath = "C:/Users/dcampoy/Pictures/TestingCannyEdge/EEG JPG/T1/
    #savepath = "D:/KDD/2nd Semester/Dissertation/Datasets/EEG JPG/OHBM_Data/T1/"
    savepath = "D:/KDD/2nd Semester/Dissertation/Datasets/EEG JPG/OHBM_Data/T0/"

    ext = '.jpg'
    for files in os.listdir(dir):
        if os.path.isfile(os.path.join(dir, files)):
            filename = files
            path = dir
            I = Image.open(path+'/'+filename)
            #I = plt.imread(path+'/'+filename)
            #I = cv.imread(path+'/'+filename, cv.IMREAD_UNCHANGED)
            #normlse_img = I / I.max() * 255
            #I = normlse_img.astype(np.uint8)
            name, tiff_ext = filename.split('.',1)
            #print (name)
            plt.imsave(savepath+name+ext, I, format='jpg')
            print("\nSaved image, ", name, " as JPG")

#### This block is for converting TIFF files to JPG
#dir = "D:/KDD/2nd Semester/Dissertation/Datasets/TIFF/T0/5HzT03a"
#dir = "D:/KDD/2nd Semester/Dissertation/Datasets/TIFF/T0/5HzT03b"
#dir = "D:/KDD/2nd Semester/Dissertation/Datasets/TIFF/T0/5HzT04a"
#dir = "D:/KDD/2nd Semester/Dissertation/Datasets/TIFF/T0/5HzT04b"
#dir = "D:/KDD/2nd Semester/Dissertation/Datasets/TIFF/T0/5HzT06a"
#dir = "D:/KDD/2nd Semester/Dissertation/Datasets/TIFF/T0/5HzT06b"
#dir = "C:/Users/dcampoy/Pictures/TestingCannyEdge/T1/"
#dir = "D:/KDD/2nd Semester/Dissertation/Datasets/Ideal_Spectral_Imgs_Original/T0/T0"
#cvrt_tiff(dir)
#### end block

### Converting Spectra to Polyheat map using distance transform
#dir = "D:/KDD/2nd Semester/Dissertation/Datasets/EEG JPG/T1"
#dir = "D:/KDD/2nd Semester/Dissertation/Datasets/OHBM_DisTransformEEG/T1"
dir = "D:/KDD/2nd Semester/Dissertation/Datasets/EEG JPG/OHBM_Data/"
cnvrt_spectr(dir)


#distanceTransform()
