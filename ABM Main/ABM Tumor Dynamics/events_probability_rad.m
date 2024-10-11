%% Events Probability Rad %%

%  This function is used to compute the mitosis and apoptosis probabilities
%  for each PCa cell at the current 'hour' when Rad223 therapy is active. 
%  The idea here is that Rad has both a time and a distance dependent effect
%  towards PCa cells, and we modify their mitosis/apoptosis probabilities
%  according to experimental validated data

%  Input  -> rows, columns : Y and X size of the grid
%            X, Y          : hexagonal grid
%            site_dim      : ABM scaling factor 
%            bone          : main ABM matrix, it labels each model agent
%            alpha         : struct with the 6 model driving parameters 
%            site          : struct with the ABM agents names
%            row/col_agent : current site coordinates (row/column)
%            B_mit/B_apo   : coefficients of the 3rd order polynomial 
%                            function fitting the distance-dependent 
%                            activity of Rad
%            Rad           : Struct containing mit/apo Rad parameters
%            hour          : current simulation hour
%            tau, rad_max  : see FixedParameters in ABM_Initialization
%
%  Output -> p_mit, p_apo  : mitosis and apoptosis probability of the
%                            current tumor 'agent'. These probs will be the
%                            input of the M.Carlo algorithm to define
%                            whether the cell will divide or die

function [p_mit, p_apo] = events_probability_rad(rows, columns, X, Y, site_dim, bone, ...
                                                    site, row_agent, col_agent, B_mit, B_apo, ...
                                                    Rad, hour, tau, rad_max)
    
    % Initialize a Distance Matrix: each site ~0 is the tumor - CB distance
    tumor_bone_distance = ones(rows, columns) * rows; % Initialize high
    
    % Scan Each Site of the Grid
    for row_agent_1 = 1 : rows
        for col_agent_1 = 1 : columns
            
            % If Current Site is Cortical Bone ...
            if bone(row_agent_1, col_agent_1) == site.cortical_bone || ... 
                    bone(row_agent_1, col_agent_1) == site.osteoblast || ...
                    bone(row_agent_1, col_agent_1) == site.osteoclast
                % ... Compute the CB - Tumor Distance
                tumor_bone_distance(row_agent_1, col_agent_1) = ...
                compute_distance(X, Y, row_agent, col_agent, row_agent_1, col_agent_1);
            end
            
        end
    end
    
    clear row_agent_1 col_agent_1
    
    % Find Tumor - CB Min Distance and Rescale it to um
    tumor_bone_min_distance = min(min(tumor_bone_distance)) * site_dim;
    
    % Get the distance dependency for mitosis and apoptosis
    epsilon(1) = (Rad.mitosis / poly_fun(tumor_bone_min_distance, B_mit)) - 1;
    epsilon(2) = 1 - (Rad.apoptosis / poly_fun(tumor_bone_min_distance, B_apo));
    
    % Now we can get the mitosis/apoptosis for the current site
    p_mit = Rad.mitosis / (1 + epsilon(1) * Rad223(hour, tau, rad_max));
    p_apo = Rad.apoptosis / (1 - epsilon(2) * Rad223(hour, tau, rad_max));  

end