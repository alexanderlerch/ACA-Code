%computes the lag of the autocorrelation function
%> called by ::ComputePitch
%>
%> @param x: audio signal
%> @param iBlockLength: block length in samples
%> @param iHopLength: hop length in samples
%> @param f_s: sample rate of audio data 
%>
%> @retval f_0 acf lag (in Hz)
%> @retval t time stamp of f_0 estimate (in s)
% ======================================================================
function [f_0, t] = PitchTimeAcf(x, iBlockLength, iHopLength, f_s)

    % blocking
    [x_b, t] = ToolBlockAudio(x, iBlockLength, iHopLength, f_s);
    iNumOfBlocks = size(x_b, 1);
    
    % allocate memory
    f_0 = zeros(1, iNumOfBlocks);

    %initialization
    fMaxFreq = 2000;
    fMinThresh = 0.35;

    for n = 1:iNumOfBlocks
        eta_min = round(f_s / fMaxFreq);

        if (sum(abs(x_b(n, :))) == 0)
            f_0(n) = 0;
            continue;
        end
        % calculate the acf maximum
        afCorr = xcorr(x_b(n, :), 'coeff');
        afCorr = afCorr((ceil((length(afCorr)/2))+1):end);

        % ignore values until threshold was crossed
        eta_tmp = find (afCorr < fMinThresh, 1);
        if (~isempty(eta_tmp))
            eta_min = max(eta_min, eta_tmp);
        end
        
        % only take into account values after the first minimum
        afDeltaCorr = diff(afCorr);
        eta_tmp = find(afDeltaCorr > 0, 1);
        if (~isempty(eta_tmp))
            eta_min = max(eta_min, eta_tmp);
        end
        
        [fDummy, T_0(n)] = max(afCorr(1+eta_min:end));

        % convert to Hz
        f_0(n) = f_s ./ (T_0(n) + eta_min);
    end
end
