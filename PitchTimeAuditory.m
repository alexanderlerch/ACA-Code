% ======================================================================
%> @brief computes the f_0 via a simple "auditory" approach
%> called by ::ComputePitch
%>
%> @param x: audio signal
%> @param iBlockLength: block length in samples
%> @param iHopLength: hop length in samples
%> @param f_s: sample rate of audio data 
%>
%> @retval f fundamental frequency estimate (in Hz)
% ======================================================================
function [f, t] = PitchTimeAuditory(x, iBlockLength, iHopLength, f_s)

    % number of results
    iNumOfBlocks    = ceil (length(x)/iHopLength);
    
    % compute time stamps
    t               = ((0:iNumOfBlocks-1) * iHopLength + (iBlockLength/2))/f_s;
    
    % allocate memory
    f               = zeros(1,iNumOfBlocks);

    %initialization
    f_max           = 2000;
    eta_min         = round(f_s/f_max);
    iNumBands       = 20;
    fLengthLpInS    = 0.001;
    iLengthLp       = ceil(fLengthLpInS*f_s);

    % apply filterbank
    X               = ToolGammatoneFb(x, f_s, iNumBands);
    
    % half wave rectification
    X(X < 0)        = 0;

    % smooth the results
    b               = ones(iLengthLp,1)/iLengthLp;
    X               = filtfilt (b,1,X')';
        
    for (n = 1:iNumOfBlocks)
        afSumCorr       = zeros(1, iBlockLength-1);
        i_start         = (n-1)*iHopLength + 1;
        i_stop          = min(length(x),i_start + iBlockLength - 1);
 
        % compute ACF per band and summarize
        for (k = 1: iNumBands)
            afCorr      = xcorr([X(k,i_start:i_stop), zeros(1,iBlockLength-(i_stop-i_start)-1)],'coeff');
            afSumCorr   = afSumCorr + afCorr((ceil((length(afCorr)/2))+1):end);
        end
        
        % find local maxima
        [afPeaks,eta_peak]   = findpeaks(afSumCorr);

        i_tmp                = find(eta_peak > eta_min,1);
        
        % set all entries below eta_min and the first local maximum to 0
        afSumCorr(1:eta_peak(i_tmp)-1) = 0;

        % calculate the acf maximum
        [fDummy, f(n)]  = max(afSumCorr);
    end
 
    % convert to Hz
    f                   = f_s ./ f;
end
