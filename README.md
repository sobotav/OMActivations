# OMActivations

This repository contains MATLAB scripts with implementation of the method for detection of activations in optical mapping recordings of atrial fibrillation.
This software is licensed under the GNU GPL v3. In case of any questions please contact vladimir.sobota@ihu-liryc.com

## Download and first run
Download/clone the repository `OMActivations`. Unzip the file and open `run.m`.

At the beginning of the script, provide the path and name of the optical mapping file that you would like to process:
```
path = '';
name = 'file.rsh';
```
## Using a MAT file as input
The function `readOMAData.m` uses an RSH file as input. In case your data are in MAT format, you can replace the **Data load** section with the following code, providing the path and name of your MAT file:
```
path = '';
name = 'file.mat';
load(fullfile(path,name));
```
The scripts have been optimized for processing optical mapping files with 100x100 pixels, stored as two-dimensional arrays with each row representing a time frame and each column representing a pixel (for example 1024x10000). 

If the script is executed well, you should see a graph like this:

![Sample graph](https://github.com/sobotav/OMActivations/tree/main/OMActivations/data/graph_sample_data_AF.png)

## Compatibility with MATLAB versions
The scripts should be compatible with MATLAB 2016a or later. Previous MATLAB releases have not been tested. The latest release has been tested on MATLAB 2021a. 
