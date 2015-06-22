% ======================================================================
%> @brief converts MIDI pitch to frequency
%>
%> @param p: MIDI pitch
%> @param f_A4: tuning frequency
%>
%> @retval f frequency
% ======================================================================
function [f] = ToolMidi2Freq(p, f_A4)

    if (nargin < 2)
        f_A4  = 440;
    end

    f   = f_A4 * 2^((p-69)/12);
end
