%converts frequency to mel
%>
%> @param fInHz: frequency
%> @param cModel: 'Fant','Shaughnessy', or 'Umesh'
%>
%> @retval mel pitch value
% ======================================================================
function [mel] = ToolFreq2Mel(fInHz, cModel)

    if (nargin < 2)
        cModel = 'Fant';
    end

    % set function handle
    hPitchFunc = str2func (['aca' cModel '_I']);
    
    mel = hPitchFunc(fInHz);
end

% Fant
function [mel] = acaFant_I(f)
    mel = 1000 * log2(1 + f/1000);
end

% Shaughnessy
function [mel] = acaShaughnessy_I(f)
    mel = 2595 * log10(1 + f/700);
end

% Umesh
function [mel] = acaUmesh_I(f)
    mel = f./(2.4e-4*f + 0.741);
end