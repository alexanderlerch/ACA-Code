% ======================================================================
%> @brief computes the spectral centroid from the (squared) magnitude spectrum
%> called by ::ComputeFeature
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data 
%>
%> @retval v spectral centroid (in Hz)
% ======================================================================
function [vsc] = FeatureSpectralCentroid (X, f_s)

    X       = X.^2;
    vsc     = ([0:size(X,1)-1]*X)./sum(X,1);
    
    % avoid NaN for silence frames
    vsc (sum(X,1) == 0) = 0;
        
    % convert from index to Hz
    vsc     = vsc / size(X,1) * f_s/2;
end
