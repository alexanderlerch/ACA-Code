% ======================================================================
%> @brief computes the spectral flatness from the magnitude spectrum
%> called by ::ComputeFeature
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval vtf spectral flatness
% ======================================================================
function [vtf] = FeatureSpectralFlatness (X, f_s)

    XLog    = log(X+1e-20);
    vtf     = exp(mean(XLog,1)) ./ (mean(X,1));
   
    % avoid NaN for silence frames
    vtf (sum(X,1) == 0) = 0;
    
end


