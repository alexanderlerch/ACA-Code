%converts frequency to MIDI pitch
%>
%> @param fInHz: frequency
%> @param f_A4: tuning frequency
%>
%> @retval p MIDI pitch
% ======================================================================
function [p] = ToolFreq2Midi(fInHz, f_A4)

    % set tuning freq
    if (nargin < 2)
        f_A4 = 440;
    end

    p = 69 + 12*log2(fInHz/f_A4);
end
