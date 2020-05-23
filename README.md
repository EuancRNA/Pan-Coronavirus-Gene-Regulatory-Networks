# SARS-CoV-2 Gene Regulatory Networks

## Introduction
We set out to characterise changes to cellular gene regualtory networks during infection by coronaviruses, primarily as a means to identify genes consistently dysregulated by them. We also developed an app that would enable one to input a set of genes and determine how these genes change over the course of infection and where these genes fit into gene regulatory networks.

## Project Outline
ven the short timescale between when SARS-Cov-2 was first discovered and when it was designated a pandemic, there is next-to-no high-throughput data for the virus. This precludes in-depth integrative, systems-level analyses on it and as such our understanding of the large-scale effects it has on cellular behaviour are limited. However, there is such data for other coronaviruses, namely the 2003 outbreak strain (which SARS-CoV-2 is believed to be closely related to) and Middle Eastern Respiratory Syndrome (MERS) virus, alongside other less well-documented coronaviruses. Using these data, differential expression analyses and various gene regulatory network construction methods (primarily computation of "perturbation scores" as implemented in https://bmcsystbiol.biomedcentral.com/articles/10.1186/s12918-017-0417-1 ), we identified "consensus" modules/pathways that are dysregulated by all coronaviruses, or at least in coronaviruses that are highly related (SARS coronaviruses). Modules/pathways identified this way could then be compared to the current SARS-CoV-2 literature to identify any evidence that these gene sets are dys-regulated during SARS-CoV-2 infection, with the aim of providing better understanding of the life cycle of the virus and how it causes SARS-CoV-2. Moreover integration of these data and networks generated with a user interface allows one to leverage the models generated in order to better understand the role that genes of interest play in cellular signalling networks, thus during viral infection in general.

## Features
To help in our analysis, as well as to create a platform for others to do exploratory analysis of their own, we've designed two applications that will provide complementary persepctives on the data. One will focus on observing gene expression changes during the infection, while the other complement this by letting one explore how the genes of interest interact with gene modules, communities and sub-networks that they are a component of. 

### Gene Expression Trajectory
#### Purpose
The purpose of the application is to allow the user to see how certain genes react to infection with the virus. A user may use as input, some list of genes that they determined to be interesting, and see how the expression of those genes changes over time. The dataset used to construct this application was GSE48729 and comprises a time series of mock, SARS-Cov-1 or SARS-CoV-2 infected cells. 

#### Usage
The user will input their genes of interest (Curretnly only accepts Ensembl gene IDs), and selects the datasets they are interested in observing. The app will then display how the genes change over time in the selected datasets. The x-axis represents the time since infection; the y-axis shows the log2foldchange between adjacent time points. A black dot (excpet the left-most one) indicates that the fold change was statistically significant, while yellow indicates that the change was not statistically significant.

### Network Evolution
#### Purpose
The purpose of this application is to allow the user to see the interaction network of their genes of interest, and to see how this network changes during the infection, as gene expression fluctuates. In this way, the wider context of the interactory environment in which the gene exists can be investigated, placing such genes in their place in respective modules and pathways. The interaction information was obtained using the BioConductor Package OmnipathR (v1.2.0), and the datasets used were downloading from the NCBI GEO. Data comprised 2 time series datasets ranging from 0 to 96 hrs post-infection by either MERS (GSE37287) or SARS (GSE56677). The analysis was extended to construct a consensus network of the SARS-CoV-1 and MERS gene expression changes over time, in order to identify pathways and modules that are consistently dys-regulated by coronaviruses.

#### Usage
The user will be able to input some genes of interest, and the app will return the clusters/modules/communities of nodes that the genes belong to. The size of the nodes will represent the gene's expression level, and the colour wil represent what module it belongs to.


## Authors

* Zuhaib Ahmed
* Euan McDonnell
* Tayab Soomro
* Huda Alfardus
* Nazia Ahmed


## Acknowledgements

We would like to acknowledge the RNA Society and the hackseqRNA team for letting us participate in this hackathon and providing support and guidance where needed.



