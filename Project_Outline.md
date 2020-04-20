---
title: "Pan-CoV Networks; Project Outline"
author: "Euan_McDonnell"
date: "19 April 2020"
output: html_document
---

# Pan-CoV Networks


## Project Outline

The main goal of this hackathon project is to leverage high-throughput data (transcriptomics, proteomics etc) of previous outbreak strains of coronaviruses and what data exists for SARS-CoV-2 to identify gene sets and pathways that are consistently dysregulated during infection by related coronaviruses. Multiple data-sets exist for MERS & SARS and these mostly take the form of time-series experiments using transcriptomic microarray data; ranging from 0 - 96 hrs, with various time intervals in-between. There also exists some data for various, less well-known coronavirus outbreak species, including 229E and OC43. 

We aim to do up to 3 different types of analyses, however will focus on the different stages in a hierarchical manner, meaning that one set of analyses will be the primary goal, with the next two analyses being of less importance, respectively. These sets of analyses will be;

1. Network construction by performing differential gene expression to get differentially expressed genes (DEGs) between the various time-points, then integrate interaction and pathway data from databases, including Reactome and IntAct to generate networks. Networks for the various (or appropriate) time-points could then be integrated to identify core pathways constitutively dysregulated. This process would be repeated for both MERS, SARS-CoV-1 and any other data-sets, then the virus-specific consensus networks overlapped/integrated to generate a consensus network of virus-specific consensus networks. Module detection would then follow, utilising DOMINO (or related tool) that accounts for the log fold change (LFC) of each gene and ontology analyses performed on each module gene set to identify the pathways that they represent. Interactome and differential expression analyses from the current SARS-CoV-2 outbreak virus could then be integrated, to identify pathways that are dysregulated by SARS-CoV-2 and all $\beta$-coronaviruses in general.

2. The second path of analyses would take the time-specific DEG networks from above, but analyse how the networks change through each time-point for each virus-specific network. These virus-specific dynamic network models would then be merged between viruses, module detection and ontology analyses performed, and SARS-CoV-2 data integrated, to identify which pathways are dysregualted at which time-points and understand how coronavirus infection proceeds over time.

3. The final (and least necessary analysis) would involve leveraging the fact that most the data for SARS-CoV-1 and MERS is time-series and utilise time-series-specific network construction methods (Jump3, OKVAR-Boost, dynGENIE3) to generate network models for each virus. As before, these virus-specific networks could then be overlapped, modules identified and ontology analyses peformed before subsequent integration of SARS-CoV-2 data to identify pan-coronavirus dysregulated pathways.

![**HackseqRNA Project Outline** : Three analytical pipelines are proposed, which will be followed in a hierachical manner, with *green* pipeline being the highest priority, followed by the *amber* and *red*.  ](/home/euan/Documents/other_projects/hackseqRNA/network_construction/pipeline.jpg)

<br />

## Tasks

### General

* Standardisation, formatting, clustering and quality-control of input data. 
* Differential expression analyses and taking of consensus DEGs per time-point.
* Identification, collation and analyses of SARS-CoV-2 interaction data (ie proteomics).
* Collation of genes, gene-sets and pathways shown to be dysregulated in the literature.

<br />

### DEG Network Construction & Pathway Analyses

1. Generation of DEG-interactome network models and overlapping of these models to get consensus DEG virus-specific network models.
2. Integration of virus-specific consensus DEG network models to get consensus DEG network models.
3. Module identification and ontology analyses on each module to identify dysregulated pathways.
4. Integration of SARS-CoV-2 data.

<br />

### DEG Network & Pathway Change Over Time

1. Analysis of network & changes over time.
2. Integration of virus-specific DEG network models to get consensus DEG network models per time-point.
3. Relation of these changes to module/pathways.
4. Integration of SARS-CoV-2 data.

<br />

### Time-Series Network Construction & Pathway Analyses

1. Time-series network construction.
2. Overlap of time-series networks between viruses.
3. Module identification and ontology analyses to identify dysregulated pathways.
4. Integration of SARS-CoV-2 data.

<br />
<br />
<br />
