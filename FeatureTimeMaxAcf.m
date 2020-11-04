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
function [vta, t] = FeatureTimeMaxAcf(x, iBlockLength, iHopLength, f_s, f_max, fMinThresh)
 
    % initialization
    % these values are arbitrary - adapt to your use case
    if (nargin < 6)
        f_max       = 2000;
    end
    if (nargin < 5)
        fMinThresh  = 0.35;
    end

    % number of results
    iNumOfBlocks    = floor ((length(x)-iBlockLength)/iHopLength + 1);
    
    % compute time stamps
    t               = ((0:iNumOfBlocks-1) * iHopLength + (iBlockLength/2))/f_s;
    
    % allocate memory
    vta             = zeros(1,iNumOfBlocks);
    
    for (n = 1:iNumOfBlocks)
        eta_min     = ceil(f_s/f_max);
        
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
