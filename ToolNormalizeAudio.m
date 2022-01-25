% ======================================================================
%> @brief normalizes audio signal
%>
%> @param x: audio signal (dimension length x channels)
%>
%> @retval x_norm (dimension length x 1)
% ======================================================================
function [x_norm] = ToolNormalizeAudio(x)
    
    if (length(x) > 1)
        x_norm = x / max(abs(x), [], 'all');
    else
        x_norm = x;
    end
end
