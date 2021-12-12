% ======================================================================
%> @brief computes the spectral skewness from the magnitude spectrum
%> called by ::ComputeFeature
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval v spectral skewness
% ======================================================================
function [vssk] = FeatureSpectralSkewness (X, f_s)

    % interpret the spectrum as pdf
    f       = linspace(0, f_s/2, size(X,1));
    
    % compute mean and standard deviation
    mu_X    = FeatureSpectralCentroid(X, f_s);
    std_X   = FeatureSpectralSpread(X, f_s);
    tmp     = repmat(f, size(X,2),1) - repmat(mu_X, size(X,1),1)';

    vssk    = sum((tmp.^3)'.*X)' ./ (std_X'.^3 .* sum(X,1)'*size(X,1));

    vssk    = vssk';
       
    % avoid NaN for silence frames
    vssk (sum(X,1) == 0) = 0;
end