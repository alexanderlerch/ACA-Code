% ======================================================================
%> @brief computes f_0 through zero crossing distances
%> called by ::ComputePitch
%>
%> @param x: audio signal
%> @param iBlockLength: block length in samples
%> @param iHopLength: hop length in samples
%> @param f_s: sample rate of audio data 
%>
%> @retval f double zero crossing distance (in Hz)
% ======================================================================
function [f, t] = PitchTimeZeroCrossings(x, iBlockLength, iHopLength, f_s)

    % number of results
    iNumOfBlocks    = ceil (length(x)/iHopLength);
    
    % compute time stamps
    t               = ((0:iNumOfBlocks-1) * iHopLength + (iBlockLength/2))/f_s;
    
    % allocate memory
    f               = zeros(1,iNumOfBlocks);

    for (n = 1:iNumOfBlocks)
        i_start     = (n-1)*iHopLength + 1;
        i_stop      = min(length(x),i_start + iBlockLength - 1);
        
        i_tmp       = diff(find(x(i_start:i_stop-1).*x(i_start+1:i_stop) < 0));
        f(n)        = mean(i_tmp); % or histogram max, ...
    end
 
    % convert to Hz
    f                   = f_s ./ f;
end
