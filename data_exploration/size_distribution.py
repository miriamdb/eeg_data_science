# This is a sample Python script.

# Press Shift+F10 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.


import os
import seaborn as sns
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

def list_files(dir):
    r = []
    for root, dirs, files in os.walk(dir):
        for name in files:
            r.append(os.path.join(root, name))
    return r

def is_outlier(points, thresh=3.5):
    """
    Returns a boolean array with True if points are outliers and False
    otherwise.

    Parameters:
    -----------
        points : An numobservations by numdimensions array of observations
        thresh : The modified z-score to use as a threshold. Observations with
            a modified z-score (based on the median absolute deviation) greater
            than this value will be classified as outliers.

    Returns:
    --------
        mask : A numobservations-length boolean array.

    References:
    ----------
        Boris Iglewicz and David Hoaglin (1993), "Volume 16: How to Detect and
        Handle Outliers", The ASQC Basic References in Quality Control:
        Statistical Techniques, Edward F. Mykytka, Ph.D., Editor.
    """
    if len(points.shape) == 1:
        points = points[:,None]
    median = np.median(points, axis=0)
    diff = np.sum((points - median)**2, axis=-1)
    diff = np.sqrt(diff)
    med_abs_deviation = np.median(diff)

    modified_z_score = 0.6745 * diff / med_abs_deviation

    return modified_z_score > thresh


data_dir = 'C:/Users/cognitive/nimh data/eeg_sub_files01_unzip'

#names = os.listdir(data_dir)
names = list_files(data_dir)
paths = [os.path.join(data_dir, name) for name in names if 'Rest' in name]
sizes = [(path, os.stat(path).st_size) for path in paths]

sizes = pd.DataFrame(sizes, columns=['Name', 'Size'])
print(sizes)

#sns.displot(sizes, x="Size")#, log_scale=True)


# Generate some data
x = sizes['Size']/1024

# Keep only the "good" points
# "~" operates as a logical not operator on boolean numpy arrays
filtered = x[~is_outlier(x)]

# Plot the results
fig, (ax1, ax2) = plt.subplots(nrows=2)

ax1.hist(x)
ax1.set_title('Size Distribution - Original')
plt.ylabel("Count")

ax2.hist(filtered)
ax2.set_title('Size Distribution - Without Outliers')
plt.xlabel("KB")
plt.show()


plt.title("Distribution of Files Size")
plt.show()