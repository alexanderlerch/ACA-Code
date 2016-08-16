% ======================================================================
%> @brief computes the ACF coefficients of a time domain signal
%> called by ::ComputeFeature
%>
%> @param x: audio signal
%> @param iBlockLength: block length in samples
%> @param iHopLength: hop length in samples
%> @param f_s: sample rate of audio data (unused)
%> @param eta: index (or vector of indices) of coeff result
%>
%> @retval vacf autocorrelation coefficient
%> @retval t time stamp
% ======================================================================
function [vacf, t] = FeatureTimeAcfCoeff(x, iBlockLength, iHopLength, f_s, eta)
 
    % initialization
    % these values are arbitrary - adapt to your use case
    if (nargin < 5)
        eta         = 20;
    end

    % number of results
    iNumOfBlocks    = ceil (length(x)/iHopLength);
    
    % compute time stamps
    t               = ((0:iNumOfBlocks-1) * iHopLength + (iBlockLength/2))/f_s;
    
    % allocate memory
    vacf            = zeros(length(eta),iNumOfBlocks);
    
    for (n = 1:iNumOfBlocks)
        i_start   = (n-1)*iHopLength + 1;
        i_stop    = min(length(x),i_start + iBlockLength - 1);
        
        % calculate the acf
        if (sum(x(i_start:i_stop)) == 0)
            afCorr = zeros(2*(i_stop-i_start)+1,1);
        else
            afCorr = xcorr(x(i_start:i_stop), 'coeff');
        end
        afCorr      = afCorr((ceil((length(afCorr)/2))+1):end);
    
        % find the coefficients as requested
        vacf(1:length(eta),n)   = afCorr(eta);
    end
end
