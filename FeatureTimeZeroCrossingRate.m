% ======================================================================
%> @brief computes the zero crossing rate from a time domain signal
%> called by ::ComputeFeature
%>
%> @param x: audio signal
%> @param iBlockLength: block length in samples
%> @param iHopLength: hop length in samples
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval vzc zero crossing rate
%> @retval t time stamp
% ======================================================================
function [vzc, t] = FeatureTimeZeroCrossingRate(x, iBlockLength, iHopLength, f_s)
 
    % number of results
    iNumOfBlocks    = ceil (length(x)/iHopLength);
    
    % compute time stamps
    t               = ((0:iNumOfBlocks-1) * iHopLength + (iBlockLength/2))/f_s;
    
    % allocate memory
    vzc             = zeros(1,iNumOfBlocks);
    
    for (n = 1:iNumOfBlocks)
        i_start     = (n-1)*iHopLength + 1;
        i_stop      = min(length(x),i_start + iBlockLength - 1);
  
        % compute the zero crossing rate
        vzc(n)      = 0.5*mean(abs(diff(sign(x(i_start:i_stop)))));
    end
end
