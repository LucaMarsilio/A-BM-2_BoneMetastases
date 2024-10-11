%% MAIN %%

%  This is the main function of the ABM.
%  Each epoch simulates the tumor dynamics and bone tissue plasticity under
%  in a defined follow-up time under several conditions:
%  1) Control Regimen: tumor growth without any therapy implementation
%  2) Rad-223 Therapy: tumor response to Rad-223 therapy
%  3) Cabozantinib Th: tumor responde to Cabozantinib therapy

clear all

% Experimental In-Vivo Control Data
CONTROL_IN_VIVO_DATA;
     
epoch     = 1; % Starting epoch
tot_epoch = 2; % Final epoch (+1)

tumor_area = [];      % N. Rows    -> number of epochs
                      % N. Columns -> normalized tumor area at each follow-up hour      
resorption_area = []; % N. Rows    -> number of epochs
                      % N. Columns -> resortion area in um^2

while (epoch < tot_epoch) 
    
    clearvars -except bv_number all_resorption_areas cort_bone resorption_area_2weeks renca_lesion_average renca_lesion_std time_point_renca_lesion control_curve_renca time_points_renca tumor_area resorption_area epoch tot_epoch alpha control_data_interpolated time_points MEAN STD CURVACD31 CONTROL_MEDIA CONTROL_MEDIA_RENCA CONTROL_STD CONTROL_STD_RENCA control_curve_pc3 time_points_pc3
    close all
    clc
   
    %% Select Model Features:
    % 1) Geometry: choose between femur_ls_1, femur_ls_1_lr, tibia_ls_1, tibia_ls_1_lr, tibia_cs_1, tibia_cs_2, tibia_cs_3, calvaria_ls_1,vertebra_cs_1
    % 2) CellLine: choose between c42b, pc3, renca
    global current_geometry cell_line CxT CyT tumor_dim
    current_geometry = 'tibia_cs_1'; 
    cell_line = 'pc3';
    
    % Model Driving Parameters
    ABM_DRIVING_PARAMETERS;
    
    % 2) Tumor Dimension Range from [1, 10] and Tumor Center Coordinates
    tumor_dim = 3;
%   CxT = 65; CyT = 58;%108;
  % CxT = 138 + 10; CyT = 122 + 5; % femur_ls_1
  
%   CxT = 81; CyT = 126; % femur_ls_1 up osteolysis
%   CxT = 300; CyT = 90; % femur_ls_1 centre osteolysis
%   CxT = 605; CyT = 29; % femur_ls_1 down osteolysis
  
%     CxT = 150; CyT = 75; % femur_ls_1_lr
%   CxT = 88; CyT = 122; % tibia_ls_1
% CxT = 380; CyT = 115; % tibia_ls_1
%     CxT = 200; CyT = 70; % tibia_ls_1_lr
%   CxT = 190; CyT = 92; % calavria_ls_1
%   CxT = 100; CyT = 80; % vertebra_cs_1
%   CxT = 5; CyT = 4; % tibia_cs_3 
%     CxT = 85; CyT = 45; % tibia_cs_2 _ edge
%     CxT = 59; CyT = 64; % tibia_cs_2 _ center
%     CxT = 35; CyT = 94; % tibia_cs_2 _ up edge
%     CxT = 101; CyT = 62; % tibia_cs_1
    %CxT = 114; CyT = 55; % tibia_cs_1
    CxT = 67+40; CyT = 122+40; % tibia_cs_1
    
    % 3) Start Therapies
    start_therapy_cabo = 40 * 24; % Cabozantinib Therapy starting hour.
    start_therapy_rad  = 40 * 24; % Rad223 Therapy starting hour.
    start_therapy_za   = 40 * 24;
    end_therapy_cabo   = 40 * 24; % Withdrawal hour of Cabozantinib.
    flag_resorption    = 1;       % 1 means OCs resorption is activates
    flag_cabozantinib  = 0;
    
    % 4) Display ABM and Area Plot
    show_abm  = 1; % if = 1 -> ABM is shown at the end of each iteration hour
    show_plot = 0; % if = 1 -> Tumor Normalized Area is shown every epoch
    
    %% ABM Initialization         
    ABM_Initialization;    
%     bone(140, 95:98) = site.osteoclast;
   
     follow_up = 28*24;
    
    %% Main Loop: ABM Dynamics Development
    for hour = 1 : follow_up % Time Step: 1 Hours 
        
%         if hour == 168
%             flag_cabozantinib = 0;
%         end

        % 1) CONTROL SECTION
        
        % 1a) Loop Control: No PCa Cells -> Break the Loop -> Tumor Eradicated
        if isempty(find(bone, 1)) && isempty(find(bone, 1))
            disp(['Tumor Eradicated. Hour: ', num2str(hour), '']);
            break % We can stop the simulation and exit the cycle
        end 
                
        % 1b) Rad223 Start Therapy Control: 
        [Rad] = start_rad(Rad, hour, start_therapy_rad);
        
        % 1c) Cabozantinib Therapy Control:
%         if hour == start_therapy_cabo
%             [flag_cabo, center_vessels, n_vess_start_cabo, ...
%                 n_vess_eliminated] = start_cabo(flag_cabo, center_vessels);
%         end
        
        if hour == start_therapy_za
            delay_factor = 8;
            T_ocs_resorption = ceil(T_ocs_resorption * 8);
            for row = 1 : rows
                for col = 1 : columns
                    if bone(row, col) == site.osteoclast
                        internal_clock_ocs(row, col) = ceil(internal_clock_ocs(row, col) * 8);
                    end
                end
            end
        end
                     
        % 2) MAIN LOOP BODY
        
        % 2a) Update PCa Cells Internal Clock Every Hour
        [internal_clock, internal_clock_ocs] = update_internal_clock(internal_clock, internal_clock_ocs, rows, ...
                                                                    columns, bone, site, T_cell_division, T_ocs_resorption);
        
        % 2b) Define Mitosis/Apoptosis Probabilities for each PCa agent
        ABM_Tumor_Dynamics;
        
        % 2c) Grid Re-Organization ~ Tissue Plasticity
        ABM_Grid_Reorganization;
        
        % 2d) Angiogenesis Process
        ABM_Angiogenesis;
        
        % 2e) Vessels Elimination if Cabozantinib is Administrated
        %ABM_VesselsResponseToCabo;
        
        % 2f) Osteoblasts Reduction when Rad223 is Administered
        % ABM_ObsResponseToRad223;
        
        % 2g) Tumor mediates OCs bone resorption activity
        if flag_resorption == 1
            Ocs_activity;
            Obs_Ocs_Cleaning;
        end       
        
        % 3) VARIABLE UPDATE AND UTILS        
        
        % Record the bone variable at each simulation hour
        BONE(:, :, hour) = bone;
        MITOTIC(:, :, hour) = mitotic_cells;
        APOPTOTIC(:, :, hour) = apoptotic_cells;
        
        % Update the temporal dynamic matrix
        cells_matrix(1, hour) = length(find(bone == site.tumor | bone == site.tumor_edge));        
        
        % 3a) Show ABM at the end of every simulation hour
        [abm_matrix] = display_abm(rows, columns, bone, show_abm);
        
        % Get cort bone data
        cort_bone(epoch, hour) = sum(sum(bone == site.cortical_bone));
        
        % Number of blood vessels
        bv_number(epoch, hour) = sum(sum(bone == site.vessel));
        
        % To avoid resorption creating a hole in the bone
%         a = bone == site.cortical_bone | bone == site.osteoblast | bone == site.osteoclast;
%         a = imfill(a, 'holes');
%         a = bwperim(a);
%         [row_bound, col_bound] = find(a);   
%         bone(sub2ind(size(bone), row_bound, col_bound)) = site.cortical_bone;
        
        % 3b) Display the current epoch and simulation hours
        disp(['Epoch: ' num2str(epoch), '', ' - Hour: ', num2str(hour), '']);
        
    end 
    
    % Plot in vivo vs in silico data over the follow up time
    PlotABM_Area;  
    
    % Plot cabo data
    PlotCabo_Area;
    
    % Compute and plot resorption area
    PlotResorption_Area;
    
    % We update tumor and bone marrow area development for each epoch 
    tumor_area(epoch, :) = abm_plot_area; 
    
    % Generate txt file with cortical bone coordinates 
    % BoneCoordinatesGenerator;
    
    epoch = epoch + 1; % update the number of epochs     
    
end

renca_tibia_cs_1_10_sim_cabo = tumor_area;
renca_tibia_cs_1_10_sim_bv_cabo = bv_number;
%pc3_tibia_cs_2_osteolysis_za_25_sim = all_resorption_areas;
save('Results/CaboResults/RENCA/renca_tibia_cs_1_10_sim_cabo.mat', 'renca_tibia_cs_1_10_sim_cabo')
save('Results/CaboResults/RENCA/renca_tibia_cs_1_10_sim_bv_cabo.mat', 'renca_tibia_cs_1_10_sim_bv_cabo')

% Results Request: ask to save in the Results directory current_area matrix
% ResultsRequest;

% Video Generation Request: last simulation video is created
% VideoRequest; 



