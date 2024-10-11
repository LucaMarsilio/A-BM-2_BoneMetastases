# AGENT BASED MODEL FOR PCa BONE METASTASES _ HMRI 

Introduction
==========================
This repository stores the Matlab code for the development of an Agent Based Model (ABM) able to reproduce the growth of pre-established bone metastases and their response to Radium 223 (Rad-223) and cabozantinib as a versatile platform to test therapeutic treatments. This project is carried out with the collaboration between the Politecnico di Milano (Milan, Italy), the Houston Methodist Research Institute (Tx, USA) and the University of Texas MD Anderson Cancer Center (Tx, USA). Previous works of this group can be seen in these publications:

- "Casarin S, Dondossola E., "*An agent-based model of prostate Cancer bone metastasis progression and response to Radium223.*," BMC Cancer. 2020 Jun 29;20(1):605. doi: 10.1186/s12885-020-07084-w. PMID: 32600282; PMCID: PMC7325060."

- "Dondossola E, Casarin S, Paindelli C, De-Juan-Pardo EM, Hutmacher DW, Logothetis CJ, Friedl P., "*Radium 223-Mediated Zonal Cytotoxicity of Prostate Cancer in Bone.*," J Natl Cancer Inst. 2019 Oct 1;111(10):1042-1050. doi: 10.1093/jnci/djz007. PMID: 30657953; PMCID: PMC6792112."


![Immagine1](https://user-images.githubusercontent.com/85581432/197823023-d6458d83-96d3-46dc-850b-76d5bcacee01.png)

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
