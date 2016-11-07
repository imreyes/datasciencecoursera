# DSS Coursera.org
## Getting and Cleaning Data
### Week4 Programming Assignment

__As the course coding project, this script (run_analysis.R) serves to:__

1. Download the raw dataset as 'SamsungGalaxy5.zip', into `./data/` folder, if none of above exists.

2. Extract activity labels and features from `activity_labels.txt` and `features.txt` respectively; rename the characters properly.

3. Load data from training and test datasets respectively, and select the variables of mean and standard deviation only.

4. Merge the datasets with the corresponding activity labels and subjects.

5. Merge the two datasets, and names each column variable with the proper activity lable.

6. Convert `Activity` and `Subject` variables into factors.

7. Make new dataset containing averages of each measurement variable, by combinations of each `Activity` and each `Subject` (volunteer).

8. Output the dataset obtained from Step 7 into `TidySummary.txt` file under the `./data/` folder.

9. Reset the working directory the same as the beginning.

__Final note:__ The work starts from and ends at current working directory, where all files, including the final `TidySummary.txt` output, stored in `./data/` folder.