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
    
    if (UseBookDefinition)
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
        mu_X    = (f * X) ./ (sum(X,1));
        tmp     = repmat(f, size(X,2),1) - repmat(mu_X, size(X,1),1)';
        var_X   = sum((tmp.^2)'.*X)' ./ (sum(X,1)'*size(X,1));
        
        vsk    = sum((tmp.^4)'.*X)' ./ (var_X.^2 .* sum(X,1)'*size(X,1));
    end
    vsk     = vsk'-3;
       
    % avoid NaN for silence frames
    vsk (sum(X,1) == 0) = 0;

end

