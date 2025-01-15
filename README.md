# AGENT BASED MODEL FOR PCa BONE METASTASES _ HMRI 

Introduction
==========================
This repository archives Matlab code for the development of a spatially explicit, in vivo-inspired, multicellular agent-based model called A(BM)2 that effectively recapitulates key aspects of tumor progression (including angiogenesis and bone resorption) and response to therapy. This project is based on a collaboration between Politecnico di Milano (Milan, Italy), Houston Methodist Research Institute (Houston, TX, USA), and the University of Texas MD Anderson Cancer Center (Houston, TX, USA). Previous work by this group is reported in these publications:

Dondossola E, Casarin S, Paindelli C, De-Juan-Pardo EM, Hutmacher DW, Logothetis CJ, Friedl P. Radium 223-Mediated Zonal Cytotoxicity of Prostate Cancer in Bone. J Natl Cancer Inst. 2019 Oct; 111(10):1042-1050. PMID: 30657953.

Casarin S, Dondossola E. An agent-based model of prostate Cancer bone metastasis progression and response to Radium223. BMC Cancer. 2020 Jun; 20(1):605. PMID: 32600282.

Paindelli C, Casarin S, Wang F, Diaz-Gomez L, Zhang J, Mikos AG, Logothetis CJ, Friedl P, Dondossola E. Enhancing Radium 223 treatment efficacy by anti-beta 1 integrin targeting. J Nucl Med. 2022 Jul; 63(7):1039-1045. PMID: 34711616.

Bektemessov Z, Cherfils L, Allery C, Berger J, Serafini E, Dondossola E, Casarin S. On a data-driven mathematical model for prostate cancer bone metastasis. AIMS Mathematics 2024; Vol.9 Issue 12: 34785-34805.

![Immagine1](https://github.com/user-attachments/assets/a28098fb-30bc-4724-9eb6-fad07eb63348)

Code Description
==========================
The whole code is stored in the "*ABM Main*" folder, which is split into 7 major areas that combined together build the computational model. These areas are:

- ABM Initialization Folder
- ABM Tumor Dynamics
- ABM Grid Reorganization 
- ABM Angiogenesis
- ABM Vessels Response to Cabo
- New Bone Initialization
- Utils

ABM Initialization Folder
==========================
This folder contains the set of functions needed to initialize the ABM. These functions are called in the "*ABM Initialization.m*" script. Its aim is to define the fundamental model parameters, load the desidered bone geometry where tumor cells grow, build the hexagonal grid upon which every model agent is built and create the starting tumor and vessels distribution according to the user requests.

ABM Tumor Dynamics
==========================
In this section a MonteCarlo algorithm chooses the tumor cells (among the ones at the end of their cell cycle) that will undergo mitosis or apoptosis at the end of the current simulation hour. All functions are called in the "*ABM_Tumor_Dynamics.m*" script. Each PCa cell agent has an internal clock randomly initialized between 0 and 24h, where 24h represents the end of a cell cycle. Every simulation hour this clock is increased by 1 until it reaches the 24h. At that time, the cell will undergo mitosis, apoptosis or quiescence. According to the environmental condition (e.g. cabozantinib is administered, Rad223 is administered or no therapy is administerd) a certain mitoisis/apopstosis probability is computed. These probabilities are the input of a montecarlo algorithm that decides the destiny of that cell.

ABM Grid Reorganization
==========================
According to the mitosis and apoptosis probabilities previously computed, here we perform the grid reorganization by removing eliminating the apoptotic cells and generating the correct number of new cells (following the mitosis event). All functions are called in the "*ABM_Grid_Reorganization*" script. Every simulation hour, the algorithm counts the number of mitosis and apoptosis events and performs them consecutively. Mitosis Rational: first, the external tumor boundary is computed, then the x% (with 0 < x < 1) of the closest boundary cells to the mitotic site is shuffled to select the mitotic site. x parameter can be selected by the user in "*Utils/bm_site_selction.m*". Apoptosis Rational: the closest PCa site to the mitotic site previously defined will undergo apoptosis.

ABM Angiogenesis
==========================
In this section the angiogenesis process is performed. Three main functions are called in the "*ABM_Angiogenesis.m*" script to perform angiogenesis at different frequencies. Accordingly, new vessels are generated every six, twenty and thirty hours (fast, medium, slow angiogenesis). The number of new vessels and their spatial localization was computed sperimentally by M.G. as well as all the scripting. 

ABM Vessels Response to Cabo
==========================
In this section the vessels elimination caused by cabozantinib administration is performed. Every simulation hour the number of vessels to be eliminated is computed after the interpolation of the experimental data extracted by Varkaris et al. in their paper: "Varkaris A, Corn PG, Parikh NU, Efstathiou E, Song JH, Lee YC, Aparicio A, Hoang AG, Gaur S, Thorpe L, Maity SN, Bar Eli M, Czerniak BA, Shao Y, Alauddin M, Lin SH, Logothetis CJ, Gallick GE., "*Integrating Murine and Clinical Trials with Cabozantinib to Understand Roles of MET and VEGFR2 as Targets for Growth Inhibition of Prostate Cancer.*," Clin Cancer Res. 2016 Jan 1;22(1):107-21. doi: 10.1158/1078-0432.CCR-15-0235. Epub 2015 Aug 13. PMID: 26272062; PMCID: PMC4703437." The reduction of vessels number causes an overall decrease of the mitosis probabilities and increase of the apoptosis probabilities leading to a major tumor reserption.

Utils
==========================
Contains several functions used throughout the script several times such as the "*compute_distance*" able to compute the distance between two separate points in the *hexagonal* grid.

New Bone Initialization
==========================
This group of function is not used by the ABM during the main simulation, however, it is used to generate the masks for the implementation of a new bone geometry.

TODO
----
- [ ] Modify therapy response according to the newest experimental data
- [ ] Add osteoclasts resorption activity
- [ ] Implement a front end to make the parameters choice easier to the user.
