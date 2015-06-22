% ======================================================================
%> @brief computes the zero crossing rate from a time domain signal
%> called by ::ComputeFeature
%>
%> @param x: audio signal
%> @param iBlockLength: block length in samples
%> @param iHopLength: hop length in samples
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval vtp predictivity ratio
%> @retval t time stamp
% ======================================================================
function [vtp, t] = FeatureTimePredictivityRatio(x, iBlockLength, iHopLength, f_s)
 
    % initialize
    iNumPredCoeffs  = 12;
    
    % number of results
    iNumOfBlocks    = ceil (length(x)/iHopLength);
    
    % compute time stamps
    t               = ((0:iNumOfBlocks-1) * iHopLength + (iBlockLength/2))/f_s;
    
    % allocate memory
    vtp             = zeros(1,iNumOfBlocks);
    
    for (n = 1:iNumOfBlocks)
        i_start     = (n-1)*iHopLength + 1;
        i_stop      = min(length(x),i_start + iBlockLength - 1);
        afBlock     = x(i_start:i_stop);

        % compute prediction coefficients
        b           = lpc(afBlock, iNumPredCoeffs);
        
        % compute the predictivity ratio
        vtp(n)      = sqrt(mean((afBlock-filter([0 -b(2:end)],1,afBlock)).^2)/mean(afBlock.^2));
    end
end
