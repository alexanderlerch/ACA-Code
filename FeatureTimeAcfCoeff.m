%computes the ACF coefficients of a time domain signal
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
        eta = 20;
    end

    % blocking
    [x_b, t] = ToolBlockAudio(x, iBlockLength, iHopLength, f_s);
    iNumOfBlocks = size(x_b, 1);
    
    % allocate memory
    vacf = zeros(length(eta),iNumOfBlocks);
    
    for (n = 1:iNumOfBlocks)
        % calculate the acf
        if (sum(x_b(n, :)) == 0)
            afCorr = zeros(2*size(x_b, 2)+1,1);
        else
            afCorr = xcorr(x_b(n, :), 'coeff');
        end
        afCorr = afCorr((ceil((length(afCorr)/2))+1):end);
    
        % find the coefficients as requested
        vacf(1:length(eta),n) = afCorr(eta);
    end
end
