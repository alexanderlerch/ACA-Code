% ======================================================================
%> @brief computes the tonal power ratio from the magnitude spectrum
%> called by ::ComputeFeature
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data (unused)
%> @param G_T: energy threshold
%>
%> @retval vsk tonal power ratio
% ======================================================================
function [vtpr] = FeatureSpectralTonalPowerRatio(X, f_s, G_T)

    % initiliaze
    if (nargin < 3)
        G_T = 5e-4;
    end

    % allocate memory
    vtpr    = zeros(1,size(X,2));

    X       = X.^2;
    fSum    = sum(X,1);
 
    for (n = 1:size(X,2))
        if (fSum(n) == 0)
            % do nothing for 0-blocks
            continue;
        end
        % find local maxima
        [afPeaks]   = findpeaks(X(:,n));
        
        % find peaks above the threshold
        k_peak      = find(afPeaks > G_T);
        
        % calculate the ratio
        vtpr(n)     = sum(afPeaks(k_peak))/fSum(n);
    end
end
