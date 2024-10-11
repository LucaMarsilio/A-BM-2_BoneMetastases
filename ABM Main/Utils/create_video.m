%% Create Video %%

%  This function creates the video of the last simulation

% Color Struct Definition
DefineColors;

% ABM Sites Struct Definition
DefineABM_sites;

% RGB Channels
channels   = 3; 

% Set Video Features
v = VideoWriter('nome_video.mp4','MPEG-4');
v.Quality = 96;
open(v);

for hours = 1 : 561%follow_up
    
    display(hour)
    
    figure('Position', [150 150 700 500])
    VideoMatrix = zeros(rows, columns, 3);

    for i = 1 : rows
            for j = 1 : columns

                switch BONE(i, j, hours)
                    case site.bone_marrow
                        Videomatrix(i, j, :) = color.light_grey;

                    case site.cortical_bone
                        Videomatrix(i, j, :) = color.dark_grey;

                    case site.outer 
                        Videomatrix(i, j, :) = color.white;
                        
                    case site.tumor_edge
                        Videomatrix(i, j, :) = color.light_blue;

                    case site.tumor
                        Videomatrix(i, j, :) = color.mill_pink;

                    case site.vessel
                        Videomatrix(i, j, :) = color.red;
                        
                    case site.vessel_cabo
                        Videomatrix(i, j, :) = color.purple;

                    case site.osteoblast
                        Videomatrix(i, j, :) = color.yellow;

                    case site.osteoclast
                        Videomatrix(i, j, :) = color.ocs_blue;
                        
                    case site.mitotic_cell
                        Videomatrix(i, j, :) = color.green;
                        
                    case site.apoptotic_cell
                        Videomatrix(i, j, :) = color.orange;

                    otherwise('Unexpected ABM site type! Check bone matrix');  

                end  
            end  
    end  
    
    image(Videomatrix);
    axis off
    frame = getframe;
    axis off
    writeVideo(v, frame);
    close
    pause(0.01)
end

close(v);