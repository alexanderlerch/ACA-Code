% ======================================================================
%> @brief computes two peak envelope measures for a time domain signal
%> called by ::ComputeFeature
%>
%> @param x: audio signal
%> @param iBlockLength: block length in samples
%> @param iHopLength: hop length in samples
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval vppm peak envelope (1: max, 2: PPM)
%> @retval t time stamp
% ======================================================================
function [vppm, t] = FeatureTimePeakEnvelope(x, iBlockLength, iHopLength, f_s)

    % number of results
    iNumOfBlocks    = ceil (length(x)/iHopLength);
    
    % compute time stamps
    t               = ((0:iNumOfBlocks-1) * iHopLength + (iBlockLength/2))/f_s;
    
    % allocate memory
    vppm            = zeros(2,iNumOfBlocks);
    v_tmp           = zeros(1,iBlockLength);

    %initialization
    alpha           = 1 - [exp(-2.2 / (f_s * 0.01)), exp(-2.2 / (f_s * 1.5))];

    for (n = 1:iNumOfBlocks)
        i_start   = (n-1)*iHopLength + 1;
        i_stop    = min(length(x),i_start + iBlockLength - 1);
        
        % calculate the maximum
        vppm(1,n)   = max(abs(x(i_start:i_stop)));
        
        % calculate the PPM value - take into account block overlaps
        % and discard concerns wrt efficiency
        v_tmp       = ppm(x(i_start:i_stop), v_tmp(iHopLength), alpha);
        vppm(2,n)   = max(v_tmp);
    end
 
    % convert to dB
    epsilon         = 1e-5; %-100dB
    
    i_eps           = find(vppm < epsilon);
    vppm(i_eps)     = epsilon;
    vppm            = 20*log10(vppm);
end

function [ppmout]   = ppm(x, filterbuf, alpha)

    %initialization
    alpha_AT        = alpha(1);
    alpha_RT        = alpha(2);
 
    x               = abs(x);
    for (i = 1: length(x))
        if (filterbuf > x(i))
            % release state
            ppmout(i)   = (1-alpha_RT) * filterbuf;
        else
            % attack state
            ppmout(i)   = alpha_AT * x(i) + (1-alpha_AT) * filterbuf;
        end
        filterbuf       = ppmout(i);
    end
end