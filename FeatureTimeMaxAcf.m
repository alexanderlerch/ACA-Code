% ======================================================================
%> @brief computes the ACF maxima of a time domain signal
%> called by ::ComputeFeature
%>
%> @param x: audio signal
%> @param iBlockLength: block length in samples
%> @param iHopLength: hop length in samples
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval vta autocorrelation maximum
%> @retval t time stamp
% ======================================================================
function [vta, t] = FeatureTimeMaxAcf(x, iBlockLength, iHopLength, f_s)
 
    % initialization
    % these values are arbitrary - adapt to your use case
    f_max        = 2000;
    fMinThresh      = 0.35;

    % number of results
    iNumOfBlocks    = ceil (length(x)/iHopLength);
    
    % compute time stamps
    t               = ((0:iNumOfBlocks-1) * iHopLength + (iBlockLength/2))/f_s;
    
    % allocate memory
    vta             = zeros(1,iNumOfBlocks);
    
    for (n = 1:iNumOfBlocks)
        eta_min     = floor (f_s/f_max);
        
        i_start   = (n-1)*iHopLength + 1;
        i_stop    = min(length(x),i_start + iBlockLength - 1);
        
        % calculate the acf
        afCorr      = xcorr(x(i_start:i_stop), 'coeff');
        afCorr      = afCorr((ceil((length(afCorr)/2))+1):end);
        
        % ignore values until threshold was crossed
        eta_tmp     = find (afCorr < fMinThresh, 1);
        if (~isempty(eta_tmp))
            eta_min = max(eta_min, eta_tmp);
        end
        
        % only take into account values after the first minimum
        afDeltaCorr = diff(afCorr);
        eta_tmp     = find(afDeltaCorr > 0, 1);
        if (~isempty(eta_tmp))
            eta_min = max(eta_min, eta_tmp);
        end
        
        % find the maximum in the computed range
        vta(n)      = max(afCorr(1+eta_min:end));
    end
end
