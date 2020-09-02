% ======================================================================
%> @brief computes the spectral kurtosis from the magnitude spectrum
%> called by ::ComputeFeature
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval vsk spectral kurtosis
% ======================================================================
function [vsk] = FeatureSpectralKurtosis (X, f_s)

    UseBookDefinition = false;
    
    if (UseBookDefinition) % not recommended
        % compute mean and standard deviation
        mu_x    = mean(abs(X), 1);
        std_x   = std(abs(X), 1);

        % remove mean
        X       = X - repmat(mu_x, size(X,1), 1);

        % compute kurtosis
        vsk     = sum ((X.^4)./(repmat(std_x, size(X,1), 1).^4*size(X,1)));
    else
        % interpret the spectrum as pdf, not as signal
        f       = linspace(0, f_s/2, size(X,1));

        % compute mean and standard deviation
        mu_X = FeatureSpectralCentroid(X, f_s);
        std_X = FeatureSpectralSpread(X, f_s);
        tmp = repmat(f, size(X,2),1) - repmat(mu_X, size(X,1),1)';
 
        vsk = sum((tmp.^4)'.*X)' ./ (std_X'.^4 .* sum(X,1)'*size(X,1))-3;
    end
    vsk     = vsk';
       
    % avoid NaN for silence frames
    vsk (sum(X,1) == 0) = 0;

end

