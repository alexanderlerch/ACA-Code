%computes two peak envelope measures for a time domain signal
%> called by ::ComputeFeature
%>
%> @param x: audio signal
%> @param iBlockLength: block length in samples
%> @param iHopLength: hop length in samples
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval vppm peak envelope (1,:: max, 2,:: PPM)
%> @retval t time stamp
% ======================================================================
function [vppm, t] = FeatureTimePeakEnvelope(x, iBlockLength, iHopLength, f_s)

    % blocking
    [x_b, t] = ToolBlockAudio(x, iBlockLength, iHopLength, f_s);
    iNumOfBlocks = size(x_b, 1);
    
    % allocate memory
    vppm = zeros(2, iNumOfBlocks);
    v_tmp = zeros(1, iBlockLength);

    %initialization
    alpha = 1 - [exp(-2.2 / (f_s * 0.01)), exp(-2.2 / (f_s * 1.5))];

    for n = 1:iNumOfBlocks
        % calculate the maximum
        vppm(1, n) = max(abs(x_b(n, :)));
        
        % calculate the PPM value 
        v_tmp = ppm_I(x_b(n, :), v_tmp(iHopLength), alpha);
        vppm(2, n) = max(v_tmp);
    end
 
    % convert to dB avoiding log(0)
    epsilon = 1e-5; %-100dB
    vppm(vppm < epsilon) = epsilon;
    vppm = 20*log10(vppm);
end

function [ppmout] = ppm_I(x, filterbuf, alpha)

    %initialization
    ppmout = zeros(size(x));
    alpha_AT = alpha(1);
    alpha_RT = alpha(2);
 
    x = abs(x);
    for i = 1: length(x)
        if (filterbuf > x(i))
            % release state
            ppmout(i) = (1-alpha_RT) * filterbuf;
        else
            % attack state
            ppmout(i) = alpha_AT * x(i) + (1-alpha_AT) * filterbuf;
        end
        filterbuf = ppmout(i);
    end
end