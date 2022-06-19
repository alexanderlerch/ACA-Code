%normalizes audio signal
%>
%> @param x: audio signal (dimension length x channels)
%>
%> @retval x_norm (dimension length x 1)
% ======================================================================
function [x_norm] = ToolNormalizeAudio(x)
    
    x_norm = x;
    if (length(x) > 1)
        fMax = max(abs(x), [], 'all');
        if (fMax ~= 0)
            x_norm = x / fMax;
        end
    end
end
