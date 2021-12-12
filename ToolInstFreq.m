function [f_I] = ToolInstFreq(X,iHop,fs)
    % get phase
    phi         = angle(X);

    % phase offset
    omega       = pi*iHop/size(X,2)*(0:size(X,2)-1);
    
    % unwrapped difference
    deltaphi    = omega + princarg_I(phi(2,:)-phi(1,:)-omega);
    
    % instantaneous frequency
    f_I         = deltaphi/iHop/(2*pi)*fs;
end

function phase = princarg_I(phi)
    phase = mod(phi + pi,-2*pi) + pi;
end