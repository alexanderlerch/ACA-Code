% ======================================================================
%> @brief computes the spectral spread from the magnitude spectrum
%> called by ::ComputeFeature
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data 
%>
%> @retval v spectral spread (in Hz)
% ======================================================================
function [vss] = FeatureSpectralSpread (X, f_s)

    % get spectral centroid as index
    vsc     = FeatureSpectralCentroid (X, f_s)*2/f_s * size(X,1);

    % allocate memory
    vss     = zeros(size(vsc));
 
    % compute spread
    X       = X.^2;
    for (n = 1:size(X,2))
        vss(n)  = (([0:size(X,1)-1]-vsc(n)).^2*X(:,n))./sum(X(:,n));
    end
    vss     = sqrt(vss);
    
    % convert from index to Hz
    vss     = vss / size(X,1) * f_s/2;
       
    % avoid NaN for silence frames
    vss (sum(X,1) == 0) = 0;
end


