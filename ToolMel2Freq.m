%converts frequency to mel
%>
%> @param fMel: frequency
%> @param cModel: 'Fant','Shaughnessy', or 'Umesh'
%>
%> @retval Hertz value
% ======================================================================
function [fInHz] = ToolMel2Freq(fMel, cModel)

    if (nargin < 2)
        cModel  = 'Fant';
    end

    % set function handle
    hPitchFunc  = str2func (['aca' cModel '_I']);
    
    fInHz       = hPitchFunc(fMel);
end

function [f] = acaFant_I(m)
    %mel         = 1000 * log2(1 + f/1000);
    f   = 1000 * (2.^(m/1000)-1);
end

function [f] = acaShaughnessy_I(m)
    %mel         = 2595 * log10(1 + f/700);
    f   = 700 * (10.^(m/2595)-1);
end

function [f] = acaUmesh_I(m)
    %mel         = f./(2.4e-4*f + 0.741);
    f   = m*.741 ./ (1 - m * 2.4e-4);
end