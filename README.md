# C.elegans-Nuclear-Image-Processing
This repository contains the segmentation program and classification notes.
The details are described in this paper[1].
Please download here (https://link.springer.xilesou.top/content/pdf/10.1186/s12859-017-1817-3.pdf)


[1]Zhao, Mengdi, et al. Segmentation and classification of two-channel C. elegans nucleus-labeled fluorescence images. BMC bioinformatics 18.1 (2017) 412


Documentation for Segmentation

This document provides a brief overview of the segmentation method, program structure, usage instruction and parameter descriptions. This program is designed on Matlab 2014b.

Overview of segmentation method
The method contains four steps: two-channel image fusion, thresholding segmentation, seed-based segmentation and precise segmentation, as shown in the flowchart below. In two-channel image fusion, we binarize the green channel image and fuse the foreground part of red channel image with green channel image. The fused image therefore has higher contrast and is easier to be roughly binarized by Otsu’s method (“Thresholding Segmentation”). Then we detect seeds according to the distance matrix and use seed-based watershed to segment the cluster nuclear region. Finally, we use k-means to cluster the pixels into two groups, foreground and background.
 
Program structure
example.m (a demo of this program) segment_nuclei.m (the main program of segmentation)
fuse_2channel.m (fuse two channel images)
init_binarize.m (binarize the fused images with Otsu’s method)
find_seed.m (compute the distance matrix, detect seeds and combine seeds) watershe_seg.m (use seed-based watershed to segment the cluster region) precise_seg.m (modify the nuclear contour)
seg_image.m (segment each nuclei into a small window)
kmeans_cluster.m (use k-means to cluster the pixels into foreground and background groups) xhex2goct_colormap.m (construct a colormap for your image)
Usage instruction
segment_nuclei ( green channel image, red channel image);
segment_nuclei ( green channel image, red channel image, ‘BinarizeThresh’, para1, ‘LHRatio’, para2, ‘PreciseWeight’, para3);

Description of the parameters
	BinarizeThresh: [0, 2]; default 0.8; It is the weight of threshold (calculated from Otsu’s method) in both “Two-channel Image Fusion” and “Thresholding Segmentation”. Set it higher if the image has high contrast, otherwise set it lower.
	LHRatio: [0, 1]; default 0.928; It is used in “Seed-based segmentation” when estimating if two seeds have to be combined into one seed. It is a value around the ratio of the lowest to highest intensity of the target object. Please test for some representative images to optimize this parameter. If your images are often over-segmented, it should be higher. Otherwise it should be lower.
	PreciseWeight: [0, 1]; default 0.4; It is the weight of binary image in “Precise Segmentation”. If the output of seed-based watershed need to be modified heavily according to the fused image, set it lower. Otherwise, set it higher.




Documentation for Classification

We constructed five classifiers using Support Vector Machine (SVM), Random Forest (RF), k-Nearest Neighbor (kNN), Decision Tree (DT) and Neural Net (NN). This document describes the details of the classifiers, include range of parameter grid, the parameters and functions we used for each classifier. The classifiers are constructed using scikit-learn (http://scikit- learn.org/stable/), a machine learning library in Python.

Range of parameter grid
We use GridSearchCV to find the optimal parameters, the parameter ranges of grid search are:
	SVM: ‘C’: [1:1:10] / ‘kernel’: linear, rbf / ‘decision_function’: ovo, ovr
	RF: ‘n_estimators’: [5:1:20] / ‘criterion’: gini, entropy / ‘max_features’: auto, sqrt, log2, None
	kNN: ‘n_neighbors’: [5:1:15] / ‘weights’: uniform, distance / ‘algorithm’: auto, ball_tree, kd_tree, brute / ‘p’: [1:1:3]
	DT: ‘criterion’: gini, entropy / ‘splitter’: best, random / ‘max_features’: auto, sqrt, log2, None
	NN: ‘hidden_layer_size’: [5:1:25] / ‘activation’: identity, logistic, tanh, relu / ‘solver’: lbfgs, sgd, adam / ‘learning_rate’: constant, invscaling, adaptive

Parameters and functions
	SVM: SVC (C=1, kernel = ‘linear’, decision_function_shape = ‘ovo’, probability = 1, class_weight = w)
	RF: RandomForestClassifier (n_estimators = 19, criterion = ‘entropy’, max_features = ‘auto’, class_weight = w)
	kNN: KNeighborsClassifier (n_neighbors = 10, weights = ‘uniform’, algorithm = ‘auto’, p = 1)
	DT: DecisionTreeClassifier (criterion = ‘entropy’, max_features = None, splitter = ‘random’, class_weight = w)
	NN: MLPClassifier (hidden_layer_sizes = 15, activation = ‘tanh’, solver = ‘adam’, learning_rate = ‘constant’)
