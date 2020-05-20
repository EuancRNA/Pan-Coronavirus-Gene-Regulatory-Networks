This app is used to visualize temporal gene expression changes in different datasets

# Organization
Each dataset will get its own directory (directory name should start with "data_").
Within each data_ directory there should be filenames starting with "long_". These files contain the differential expression data for each gene at each pair of adjacent time points. So it'll have the following form:

```
Gene	T1	T2	log2FoldChange	Colour
gene1	4	12	2.32	Significant
gene2	4	12	-1.5	Not
gene3	4	12	0.2	Not
...
gene1	12	24	0	Not
gene2	12	24	-5.1	Significant
gene3	12	24	3.1	Significant
...
```

The file must be tab-delimited and the headings must match the ones shown above. The Colour column should contain only values of "Significant" and "Not".
Ideally, the data_ directory should also cotain the the DE analysis data, and the sample meta info, scripts used to generate the files, etc... But these aren't necessary for the app to run. It only needs the raw read counts and the long_ files

This app also has a file groupToColumns.txt which mentions each experimental group available in the app, as well as what column of what file contains the raw data for that experimental group.
