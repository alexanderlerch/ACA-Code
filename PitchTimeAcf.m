% ======================================================================
%> @brief computes the lag of the autocorrelation function
%> called by ::ComputePitch
%>
%> @param x: audio signal
%> @param iBlockLength: block length in samples
%> @param iHopLength: hop length in samples
%> @param f_s: sample rate of audio data 
%>
%> @retval f acf lag (in Hz)
% ======================================================================
function [f, t] = PitchTimeAcf(x, iBlockLength, iHopLength, f_s)

    % number of results
    iNumOfBlocks    = ceil (length(x)/iHopLength);
    
    % compute time stamps
    t               = ((0:iNumOfBlocks-1) * iHopLength + (iBlockLength/2))/f_s;
    
    % allocate memory
    f               = zeros(1,iNumOfBlocks);

    %initialization
    fMaxFreq        = 2000;
    eta_min         = round(f_s/fMaxFreq);

    for (n = 1:iNumOfBlocks)
        i_start         = (n-1)*iHopLength + 1;
        i_stop          = min(length(x),i_start + iBlockLength - 1);
        
        % calculate the acf maximum
        afCorr          = xcorr(x(i_start:i_stop),'coeff');
        afCorr          = afCorr((ceil((length(afCorr)/2))+1):end);
        [fDummy, f(n)]  = max(afCorr(1+eta_min:end));
    end
 
    % convert to Hz
    f                   = f_s ./ (f + eta_min);
end
