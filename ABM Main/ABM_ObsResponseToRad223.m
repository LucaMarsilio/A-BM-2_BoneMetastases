%% ABM OBs Response to Rad223 %%

%  This function is used to reduce the osteoblasts number when Rad223
%  theraphy starts. At the moment, when the drug is administered we have
%  the maximum number of obs, that decreases to 50% after 11.3 days.

% This algorithm performs an obs halving between the theraphy start and the
% half life time of rad223 (this parameters can be modified if needed)
if hour >= start_therapy_rad && hour <= start_therapy_rad + half_life_time_rad223
    
    % Time passed since Rad223 was administered
    time_rad = hour - start_therapy_rad + 1;
    
    % Current osteoblast number
    obs_number = sum(sum(bone == site.osteoblast));
    
    % Obs to be eliminated at the current iteration
    obs_to_eliminate = obs_number - fix((1 - time_rad / (2 * half_life_time_rad223)) * obs_number_start);
    
    % Check whether Rad223 caused any obs dead at the current iteration
    if obs_to_eliminate > 0
        
        % For loop whether multiple obs have to be removed
        for obs = 1 : obs_to_eliminate
        
            % Find Obs Coordinates
            [row_obs, col_obs] = find(bone == site.osteoblast);
            
            % Randomly find an obs coordinates ...
            random_obs = randi(size(row_obs, 1));
            
            % ... and change matrix value to cortical bone
            bone(row_obs(random_obs), col_obs(random_obs)) = site.cortical_bone;
        end        
    end
end