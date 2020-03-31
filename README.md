# Identifying Pan-Coronavirus Dysregulated Gene Sets

## *Pitch*
We aim to identify consensus gene sets/modules that are consistently dysregulated during infection by various coronaviruses with the aim of enhancing the understanding of SARS-CoV-2 infection and COVID-19.

## *Description*
Given the short timescale between when SARS-Cov-2 was first discovered and when it was designated a pandemic, there is next-to-no high-throughput data for the virus. This precludes in-depth integrative, systems-level analyses on it and as such our understanding of the large-scale effects it has on cellular behaviour are limited. However, there is such data for other coronaviruses, namely the 2003 outbreak strain (which SARS-CoV-2 is believed to be closely related to) and Middle Eastern Respiratory Syndrome (MERS) virus, alongside other less well-documented coronaviruses. Using these data, differential expression analyses and various gene regulatory network construction methods, it may be possible to identify "consensus" modules/pathways that are dysregulated by all coronaviruses, or at least in coronaviruses that are highly related (SARS coronaviruses). Modules/pathways identified this way could then be compared to the current SARS-CoV-2 literature to identify any evidence that these gene sets are dys-regulated during SARS-CoV-2 infection, with the aim of providing better understanding of the life cycle of the virus and how the virus causes COVID-19.

## *Objectives*
* Identification of data will be important, as even for previous coronaviruses (MERS,SARS), data is limiting and heterogenous in technology (Microarray, SILAC, Next-Gen Sequencing, Third-Gen Sequencing etc), source (proteomics vs transcriptomes etc) and cell-lines/conditions (tissue culture, primary cell line, clinical samples etc). We will mine OmicsDI, ArrayExpress etc for this data and perform various clustering analyses to remove outliers. This may need to be done prior to the official hackathon. 
* Identification of genes/modules where there is evidence for their dysregulation during SARS-Cov-2019 infection, to compare back to the consensus network predictions. This will be accomplished via a literature search.
* Differential expression analyses on the various datasets will provide a relatively simplistic but still informative indication of what gene-sets are dys-regulated during infection by all coronaviruses.
* Construction of network models and identification of consensus modules/pathways in order to determine possible pan-coronavirus dysregulated modules/gene sets, using tools/packages such as WGCNA, ARACNE etc.

## *The Team*
**Euan McDonnell (Team Lead)**
I'm a computational biology PhD student based at the University of Leeds. My interests lie in transcriptomics, gene expression, virology, pathway analyses, multiomics integration and network analyses. My PhD project is focused on investigating dys-regulated ncRNA networks during lytic reactivation of the oncogenic y-herpesvirus Kaposi's Sarcoma-associated Herpesvirus using various transcriptomic and proteomic datasets. 

**Tayab Soomro (Participant)**
I'm a Bioinformatics undergraduate student at the University of Saskatchewan in Canada. I am also a Bioinformatician at Agriculture and Agri-Food Canada (AAFC) working on genome assembly and annotation projects. I am interested to explore various projects within the scope of bioinformatics.

**Layla Hosseini-Gerami (Partipant)**
I'm a PhD student based at the Centre for Molecular Informatics at the University of Cambridge in the areas of bioinformatics and cheminformatics. My work focuses on network/systems biology methods using gene expression and molecular interaction (e.g. protein-protein interaction) data to understand drug mechanism of action. 

## Useful Resources 

### Gene Expression/Omics Databases

Many of these databases are redundant, meaning that the same datasets will appear in each. If searching, check the data table and include new codes (E-GEOD-XXXX or GSEXXXXX) that correspond to the dataset, in the correcct column. Then download all data associated with the dataset, ie raw/processed data and metadata file. 

* OmicsDI:         https://www.omicsdi.org/
* ArrayExpress:    https://www.ebi.ac.uk/arrayexpress/
* SRA:             https://www.ncbi.nlm.nih.gov/sra/
* GEO:             https://www.ncbi.nlm.nih.gov/geo/
* COVID-19 PORTAL: https://www.ebi.ac.uk/covid-19


### Literature Databases

**_CORD-19_**: https://pages.semanticscholar.org/coronavirus-research
COVID-19 Open Research Dataset. A database set up by the Allen Institute for AI containing 45,000 scholarly articles on SARS-CoV-2 and associated coronaviruses, updated weekly as new peer-reviewed & preprint articles are published. The whole dataset can be downloaded, else the databased can be queried via the search engine: https://cord-19.apps.allenai.org/.

**_WHO COVID-2019_**: https://www.who.int/emergencies/diseases/novel-coronavirus-2019/global-research-on-novel-coronavirus-2019-ncov
A database curated by the WHO via manual searching of the table of contents of relevant journals and track down other related scientific articles that enrich the dataset. You can query the database or download the whole set.


### Differential expression

These are the major/most popular differential expression tools, there isn't a huge amount of variety in how they operate and they tend to provide highly similar results. Where they do vary tends to be in normalisation; so it'd probably be best to normalise raw data using the same method and use the same tool for differential expression analyses. However, limma tends to be good for cases where there are a low number of replicates.

**_Microarray_**
* limma:      https://kasperdanielhansen.github.io/genbioconductor/html/limma.html

**_RNA-seq (count data)_**
* DESeq2:     http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html
* edgeR:      https://bioconductor.org/packages/release/bioc/vignettes/edgeR/inst/doc/edgeRUsersGuide.pdf
* limma-voom: https://ucdavis-bioinformatics-training.github.io/2018-June-RNA-Seq-Workshop/thursday/DE.html


### Network Construction

Networks in cellular biology are a graphical representation of the large-scale interacting genes/molecular species/regulatory elements. Such networks are composed of "nodes", which represent the genes/interactors and "edges", which are lines that represent such interactions. Nodes can have metadata associated with them (ie ontology, gene abundance, log-fold changes) and edges can be have values associated representing the strength of interaction (weighted) or just represent an interaction in a binary yes/no manner (unweighted). Edges can also show the directionality of interaction (are directed), ie whether gene A affects gene B, but B doesn't affect A, or can be undirected.

* A good introduction can be found here: https://www.ebi.ac.uk/training/online/course/network-analysis-protein-interaction-data-introduction
* A more advanced introduction can be found here: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4817425/

**Co-expression methods**
* WGCNA:  https://horvath.genetics.ucla.edu/html/CoexpressionNetwork/Rpackages/WGCNA/
* ARACNE: http://califano.c2b2.columbia.edu/aracne

**Time-Series**
* SMARTS: https://academic.oup.com/bioinformatics/article/31/8/1250/212503?fbclid=IwAR3ddRpNP1g451UpNws4YZPNZE91x5tl378eXmkOH60nFwJj7DbBpguLohU


### Module Detection

Once a network has been constructed, the usual next step is to identify gene modules, or sets/groups of genes that are highly interconnected and usually function in the same/similar pathways. There are a plethora of methods for this that use ontological data and network metrics to identify such modules.

**Network-based Module Detection**
* DOMINO: https://www.biorxiv.org/content/10.1101/2020.03.10.984963v2.full


