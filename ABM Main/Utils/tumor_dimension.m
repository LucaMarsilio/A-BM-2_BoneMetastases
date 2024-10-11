%% Tumor Dimension %% 

% the code defines the initial tumor size according to experimental plan

%  Input  -> Dim_Flag  : tumor dimension chosen by the user
%
%  Output -> a_tumor   : tumor semi-axis on the X-axis
%            b_tumor   : tumor semi-axis on the Y-axis


function [a_tumor,b_tumor] = tumor_dimension(Dim_Flag)
    
    % Initialization of tumor semi-axis dimensions
    a_tumor_init = [2, 3, 5, 7, 9, 12, 15, 18, 20, 23]; 
    b_tumor_init = [1, 2, 4, 6, 7, 10, 12, 15, 17, 20];
        
    % Select the corresponding dimensions (according to Dim_Flag value)
    for i_size = 1:10
        if i_size == Dim_Flag
           a_tumor = a_tumor_init(i_size);
           b_tumor = b_tumor_init(i_size);
        end
    end        

end

