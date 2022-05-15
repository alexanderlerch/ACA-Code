%computes the spectral kurtosis from the magnitude spectrum
%> called by ::ComputeFeature
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval vsk spectral kurtosis
% ======================================================================
function [vsk] = FeatureSpectralKurtosis (X, f_s)
    
    % compute mean and standard deviation
    mu_X = FeatureSpectralCentroid(X, f_s) * 2 / f_s * (size(X, 1)-1);
    std_X = FeatureSpectralSpread(X, f_s) * 2 / f_s * (size(X, 1)-1);
    tmp = repmat(0:size(X, 1)-1, size(X, 2), 1) - repmat(mu_X, size(X, 1), 1)';
    
    vsk = sum((tmp.^4)'.*X)' ./ (std_X'.^4 .* sum(X, 1)')-3;

    vsk = vsk';
       
    % avoid NaN for silence frames
    vsk (sum(X, 1) == 0) = 0;
    
end

