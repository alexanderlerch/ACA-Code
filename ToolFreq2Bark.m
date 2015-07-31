% ======================================================================
%> @brief converts frequency to bark
%>
%> @param fInHz: frequency
%> @param cModel: 'Schroeder','Terhardt', 'Zwicker', or 'Traunmuller'
%>
%> @retval bark value
% ======================================================================
function [bark] = ToolFreq2Bark(fInHz, cModel)

    if (nargin < 2)
        cModel  = 'Schroeder';
    end

    % set function handle
    hPitchFunc  = str2func (['aca' cModel]);
    
    bark         = hPitchFunc(fInHz);
end

function [bark] = acaSchroeder(f)
    bark         = 7 * asinh(f/650);
end

function [bark] = acaTerhardt(f)
    bark         = 13.3 * atan(0.75 * f/1000);
end

function [bark] = acaZwicker(f)
    bark         = 13 * atan(0.76 * f/1000) + 3.5 * atan(f/7500);
end

function [bark] = acaTraunmuller(f)
    bark         = 26.81/(1+1960./f) - 0.53;
end
