%computes the ACF maxima of a time domain signal
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
        f_max = 2000;
    end
    if (nargin < 5)
        fMinThresh = 0.35;
    end
    
    % blocking
    [x_b, t] = ToolBlockAudio(x, iBlockLength, iHopLength, f_s);
    iNumOfBlocks = size(x_b, 1);
    
    % allocate memory
    vta = zeros(1, iNumOfBlocks);
    
    for n = 1:iNumOfBlocks
        eta_min = ceil(f_s / f_max);
        
        % calculate the acf
        afCorr = xcorr(x_b(n, :), 'coeff');
        afCorr = afCorr((ceil((length(afCorr)/2))):end);
        
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
        
        % find the maximum in the computed range
        vta(n) = max(abs(afCorr(1+eta_min:end)));
    end
end
