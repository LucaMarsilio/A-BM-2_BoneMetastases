function [lesion_area, std_tp] = compute_lesion_area(cortical_bone, time_points)

     % Compute the resorption area at each simulation area
    cortical_bone = abs(cortical_bone - cortical_bone(:, 1));
    
    % Transform the area to mm^2
    resorption_area = cortical_bone * (20.833 / 1000) * (20.833 / 1000);
    
    % Compute mean and std
    mean_resorption = mean(resorption_area);
    std_resorption = std(resorption_area);
    
    % Get lesion area at given time points
    lesion_area = mean_resorption(time_points);
    
    % Get standard deviation at time points
    std_tp = std_resorption(time_points);

end

