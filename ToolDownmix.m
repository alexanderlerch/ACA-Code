%downmixes audio signal
%>
%> @param x: audio signal (dimension length x channels)
%>
%> @retval x_downmix (dimension length x 1)
% ======================================================================
function [x_downmix] = ToolDownmix(x)
    
    if (size(x, 2) > 1)
        x_downmix = mean(x, 2);
    else
        x_downmix = x;
    end
end
