# --------- SKIP: This might take too long -----------
# Read in the data
# tr <- read.csv("renal-cancer/1753-6561-8-s6-s2-s2.csv")
tr <- read.csv("http://www.biomedcentral.com/content/supplementary/1753-6561-8-s6-s2-s2.csv")
dim(tr)

# Filter the genes
gn <- colnames(tr[-c(1,20534)])
sg <- scan("selected-genes.txt", what=character())
sga <- paste(sg, collapse="|")
keep <- grepl(sga, gn)
keep <- c(TRUE, keep, TRUE)

tr.s <- tr[,keep]
dim(tr.s)
colnames(tr.s)
tr.s <- tr.s[,-c(13,19,32,39)]
summary(tr.s)
# --------- UP TO HERE -----------

# Read in reduced data set
tr.s <- read.csv("rc-tr.csv")

# Make some pictures
library(GGally)
library(dplyr)
library(tidyr)
library(ggplot2)
tr.s[,2:63] <- log(tr.s[,2:63]+1)
summary(tr.s)
ggparcoord(tr.s, columns=2:63, groupColumn="Cinical_Status", scale="globalminmax")

tr.s.g <- gather(tr.s, Gene, value, -Patient_id, -Cinical_Status)
gm <- summarise(group_by(tr.s.g, Gene), m = median(value))
tr.s.g$Gene <- factor(tr.s.g$Gene, levels=gm$Gene[order(gm$m)])
qplot(Gene, value, data=tr.s.g, color=Cinical_Status, geom="boxplot") + coord_flip()

# Standardize all the counts, fit a classification model
tr.s.sd <- data.frame(Patient_id=tr.s[,1], scale(tr.s[,2:63]), Cinical_Status=tr.s[,64])
library(MASS)
tr.lda <- lda(Cinical_Status~., data=tr.s.sd[,-1])
tr.p <- predict(tr.lda, tr.s.sd)
table(tr.s.sd$Cinical_Status, tr.p$class)
tr.df <- data.frame(class=tr.s.sd$Cinical_Status, tr.p$x)
qplot(LD1, data=tr.df, geom="histogram", facets=class~.)

# Plot the coefficients, to learn which genes contribute the most
ts.coef <- data.frame(g=rownames(tr.lda$scaling), tr.lda$scaling)
ts.coef$ymin <- ifelse(ts.coef$LD1<0, ts.coef$LD1, 0)
ts.coef$ymax <- ifelse(ts.coef$LD1>0, ts.coef$LD1, 0)
ts.coef <- arrange(ts.coef, desc(abs(ts.coef$LD1)))
ts.coef$g <- factor(ts.coef$g, levels=ts.coef$g)
ggplot(ts.coef) + geom_linerange(aes(x=g, ymin=ymin, ymax=ymax)) +
  geom_hline(yintercept=0, color="grey80") + ylim(-0.4, 0.4) +
  coord_flip()
options(digits=2)
ts.coef[,1:2]

# Plot the most important genes
tr.s.sd.g <- gather(tr.s.sd, Gene, value, -Patient_id, -Cinical_Status)
g1 <- filter(tr.s.sd.g, Gene %in% ts.coef[1:6,1])
g1$Gene <- factor(g1$Gene, levels=ts.coef[1:6,1])
qplot(Cinical_Status, value, data=g1, geom="boxplot") +
  facet_wrap(~Gene) + coord_flip()

# How does this compare with the test set?
# ts <- read.csv("1753-6561-8-s6-s2-s3.csv")
# ------ SKIP: Too slow -----------
ts <- read.csv("http://www.biomedcentral.com/content/supplementary/1753-6561-8-s6-s2-s3.csv")
dim(ts)

ts.s <- ts[,keep]
dim(ts.s)
colnames(tr.s)
ts.s <- ts.s[,-c(13,19,32,39)]
summary(ts.s)
# ------ UP TO HERE -----------

ts.s <- read.csv("rc-ts.csv")

ts.s[,2:63] <- log(ts.s[,2:63]+1)
summary(ts.s)

# Standardizing requires using the mean/sd of the training data
mn <- apply(tr.s[,2:63], 2, mean, na.rm=T)
s <- apply(tr.s[,2:63], 2, sd, na.rm=T)
ts.s.sd <- data.frame(Patient_id=ts.s[,1], scale(ts.s[,2:63],
                                                 center=mn, scale=s),
                      Cinical_Status=ts.s[,64])

# Plot the top 6
ts.s.sd.g <- gather(ts.s.sd, Gene, value, -Patient_id, -Cinical_Status)
g2 <- filter(ts.s.sd.g, Gene %in% ts.coef[1:6,1])
g2$Gene <- factor(g2$Gene, levels=ts.coef[1:6,1])
qplot(Cinical_Status, value, data=g2, geom="boxplot") +
  facet_wrap(~Gene) + coord_flip()

# Compare training and test more closely
g <- rbind(g1, g2)
g$set <- c(rep("Train", 2280), rep("Test", 570))
qplot(Cinical_Status, value, data=g, geom="boxplot") +
  facet_grid(set~Gene) + coord_flip()

# Scatterplot matrix
g1.s <- spread(g1, Gene, value)
ggscatmat(g1.s, columns=3:8, color="Cinical_Status")
g2.s <- spread(g2, Gene, value)
ggscatmat(g2.s, columns=3:8, color="Cinical_Status")

# Now predict the test data
ts.p <- predict(tr.lda, ts.s.sd)
table(ts.s.sd$Cinical_Status, ts.p$class)
ts.df <- data.frame(class=ts.s.sd$Cinical_Status, ts.p$x)
qplot(LD1, data=ts.df, geom="histogram", facets=class~.)

# Use a penalized form of the model, to account for high-d
library(penalizedLDA)
cl <- as.numeric(tr.s.sd$Cinical_Status)
cv <- PenalizedLDA.cv(as.matrix(tr.s.sd[,2:63]), cl, type="ordered",
                      lambdas=c(1e-4,1e-3,1e-2,.1,1,10), lambda2=0.2, K=1)
print(cv)
tr.pda <- PenalizedLDA(as.matrix(tr.s.sd[,2:63]), cl,
                       xte=as.matrix(tr.s.sd[,2:63]), lambda=0.01, K=1,
                       standardized=TRUE)
print(tr.pda)
plot(tr.pda)
table(tr.pda$y, tr.pda$ypred)

# Now predict the test data
tr.pda <- PenalizedLDA(as.matrix(tr.s.sd[,2:63]), cl,
                       xte=as.matrix(ts.s.sd[,2:63]), lambda=0.01, K=1,
                       standardized=TRUE)
table(ts.s.sd$Cinical_Status, tr.pda$ypred)
tr.pda.df <- data.frame(PD1=tr.pda$xproj, y=tr.pda$y)
qplot(PD1, data=tr.pda.df, geom="histogram", facets=y~.)

# Test data
ts.pda.df <- data.frame(PD1=tr.pda$xteproj, y=ts.s.sd$Cinical_Status)
qplot(PD1, data=ts.pda.df, geom="histogram", facets=y~.)

# Plot the coefficients
pd.coef <- data.frame(g=colnames(tr.pda$x), PD1=tr.pda$discrim)
pd.coef$ymin <- ifelse(pd.coef$PD1<0, pd.coef$PD1, 0)
pd.coef$ymax <- ifelse(pd.coef$PD1>0, pd.coef$PD1, 0)
pd.coef <- arrange(pd.coef, desc(abs(pd.coef$PD1)))
pd.coef$g <- factor(pd.coef$g, levels=pd.coef$g)
ggplot(pd.coef) + geom_linerange(aes(x=g, ymin=ymin, ymax=ymax)) +
  geom_hline(yintercept=0, color="grey80") + ylim(-0.25, 0.25) +
  coord_flip()
head(pd.coef)

# New package, that uses projection pursuit to find low-d projections
# upon which to build classifier. Nice visualization of results
library(PPtreeViz)
Tree.result <- PP.Tree.class(tr.s.sd$Cinical_Status, tr.s.sd[,2:62],"PDA", 0.1)
p <- PP.classify(Tree.result, ts.s.sd[,2:62], 1, ts.s.sd$Cinical_Status)
plot(Tree.result)
PPclassNode.Viz(Tree.result,1,1)

# Color check
library(dichromat)
library(scales)
clrs <- hue_pal()(2)
qplot(LD1, data=ts.df, geom="histogram", facets=class~., fill=class) +
  scale_fill_manual(values=clrs)
clrs <- dichromat(hue_pal()(2))
qplot(LD1, data=ts.df, geom="histogram", facets=class~., fill=class) +
  scale_fill_manual(values=clrs)

# Genomic plots with ggbio
# source("http://bioconductor.org/biocLite.R")
# biocLite("ggbio")
library(ggbio)
# biocLite("biovizBase")
library(biovizBase)
# biocLite("GenomicRanges")
library(GenomicRanges)

# Manhattan
snp <- read.table(system.file("extdata", "plink.assoc.sub.txt",
            package = "biovizBase"), header = TRUE)
gr.snp <- transformDfToGr(snp, seqnames = "CHR", start = "BP", width = 1)
head(gr.snp)
gr.snp <- keepSeqlevels(gr.snp, as.character(1:22))
data(ideoCyto, package = "biovizBase")
seqlengths(gr.snp) <- as.numeric(seqlengths(ideoCyto$hg18)[1:22])
gr.snp <- gr.snp[!is.na(gr.snp$P)]
values(gr.snp)$pvalue <- -log10(values(gr.snp)$P)
gro <- GRanges(c("1", "11"), IRanges(c(100, 2e6), width = 5e7))
names(gro) <- c("group1", "group2")
plotGrandLinear(gr.snp, aes(y = pvalue), highlight.gr = gro)

# Circular layout
data("CRC", package = "biovizBase")
head(hg19sub)
gr.crc1 <- crc.gr[values(crc.gr)$individual == "CRC-1"]
p <- ggbio() +
  circle(gr.crc1, geom = "link", linked.to = "to.gr", aes(color = rearrangements)) +
  circle(gr.crc1, geom = "point", aes(y = score, size = tumreads),
         color = "red", grid = TRUE) + scale_size(range = c(1, 2.5)) +
  circle(mut.gr, geom = "rect", color = "steelblue") +
  circle(hg19sub, geom = "ideo", fill = "gray70") +
  circle(hg19sub, geom = "scale", size = 2) +
  circle(hg19sub, geom = "text", aes(label = seqnames), vjust = 0, size = 3)
p

# Genemodel
# biocLite("Homo.sapiens")
library(Homo.sapiens)
class(Homo.sapiens)
data(genesymbol, package = "biovizBase")
wh <- genesymbol[c("BRCA1", "NBR1")]
wh <- range(wh, ignore.strand = TRUE)
p.txdb <- autoplot(Homo.sapiens, which  = wh)
p.txdb
