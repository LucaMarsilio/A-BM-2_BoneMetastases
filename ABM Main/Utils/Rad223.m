function R = Rad223(t, Tau, Rad_max)

    % Time dependent function of Rad activity
    t = t/24;
    R = Rad_max * exp(-t / Tau);
    
end