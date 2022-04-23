%computes the RMS of a time domain signal
%> called by ::ComputeFeature
%>
%> @param x: audio signal
%> @param iBlockLength: block length in samples
%> @param iHopLength: hop length in samples
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval vrms root mean square (row 1: block-based rms, row 2: single pole approx)
%> @retval t time stamp
% ======================================================================
function [vrms, t] = FeatureTimeRms(x, iBlockLength, iHopLength, f_s)

    T_i = .3; 
    alpha = 1 - exp(-2.2/f_s/T_i);

    % blocking
    [x_b, t] = ToolBlockAudio(x, iBlockLength, iHopLength, f_s);
    
    % allocate memory
    vrms = zeros(2, length(t));

    % single pole implementation
    v_sp = filter(alpha, [1 -(1-alpha)], x.^2);

    % per block standard implementation
    for n = 1:size(x_b, 1)
        i_start = (n-1) * iHopLength + 1;
        i_stop = min(length(x), i_start + iBlockLength - 1);
        
        % calculate the rms
        vrms(1, n) = sqrt(mean(x_b(n, :).^2));
        vrms(2, n) = max(sqrt(v_sp(i_start:i_stop)));
    end

    % convert to dB
    epsilon = 1e-5; %-100dB
    vrms(vrms < epsilon) = epsilon;
    vrms = 20*log10(vrms);
end
