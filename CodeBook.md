# Data Code Book
This document describes the tidy output dataset contained in the directory
`./tidy_data.txt`. 

## Data origin
The original data set is the "Human Activity Recognition Using Smartphones Dataset",
which is available for download from [the UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
A detailed description of the original dataset can be found in the README that accompanies the data.


The feature vectors  activity codes, and subject names were used to create the tidy data.
All raw inertial signal data was not used (i.e. all data in `./data/unzipped/UCI HAR Dataset/test/Inertial Signals` and
`./data/unzipped/UCI HAR Dataset/train/Inertial Signals` folders).

## Tidy Data Transformations
The following transformations were done on the origin dataset described above to create the tidy dataset.
1. The `test` and `train` data were combined together
2. Columns with `mean()` and `std()` were retained. All other columns were discarded.
3. The `mean()` and `std()` columns were averaged over all SubjectId's and ActivityClass'es.

the SubjectId values range from 1 to 30 and indicate the actual participant of 30 participants 
the ActivityClass value indicate what actual activity the participant was performing (laying, sitting,...) 

This averaging was accomplished using the `ddply` functions from the `plyr2` library.
The resulting tidy dataset contains one row for each unique combination of SubjectId and ActivityClass.