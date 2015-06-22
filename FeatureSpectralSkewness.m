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

    UseBookDefinition = true;
    
    if (UseBookDefinition)
        % compute mean and standard deviation
        mu_x    = mean(abs(X), 1);
        std_x   = std(abs(X), 1);

        % compute skewness
        X       = X - repmat(mu_x, size(X,1), 1);
        vssk    = sum ((X.^3)./(repmat(std_x, size(X,1), 1).^3*size(X,1)));
    else
        % interpret the spectrum as pdf, not as signal
        f       = linspace(0, f_s/2, size(X,1));
        % compute mean and standard deviation
        mu_X    = (f * X) ./ (sum(X,1));
        tmp     = repmat(f, size(X,2),1) - repmat(mu_X, size(X,1),1)';
        var_X   = diag (tmp.^2 * X) ./ (sum(X,1)'*size(X,1));
        
        vssk    = diag (tmp.^3 * X) ./ (var_X.^(3/2) .* sum(X,1)'*size(X,1));
    end
       
    % avoid NaN for silence frames
    vssk (sum(X,1) == 0) = 0;
end