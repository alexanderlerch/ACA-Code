% ======================================================================
%> @brief computes the spectral slope from the magnitude spectrum
%> called by ::ComputeFeature
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval vsk spectral slope
% ======================================================================
function [vssl] = FeatureSpectralSlope (X, f_s)

    % compute mean
    mu_x    = mean(abs(X), 1);
    
    % compute index vector
    kmu     = [0:size(X,1)-1] - size(X,1)/2;
    
    % compute slope
    X       = X - repmat(mu_x, size(X,1), 1);
    vssl    = (kmu*X)/(kmu*kmu');
end


