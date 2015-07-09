This archive contains:

1. README.txt - this file, a description of files in the archive


2. samples.csv - metadata table in CSV format, which can be read into R using:

## R-code ---
samples = read.table("samples.csv", sep=";", header=TRUE)
## ---


3. counts.csv - collated table of counts for all features across all 7 samples

## R-code ---
counts = read.csv("counts.csv")
## ---


4. SraRunInfo.csv - the file used in the protocol that can be downloaded from the NCBI Short Read Archive.


5. The individual .COUNT files output from htseq-count:

CG8144_RNAi-1.count
CG8144_RNAi-3.count
CG8144_RNAi-4.count
Untreated-1.count
Untreated-3.count
Untreated-4.count
Untreated-6.count
