% ======================================================================
%> @brief computes the spectral flux from the magnitude spectrum
%> called by ::ComputeFeature
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval v spectral flux
% ======================================================================
function [vsf] = FeatureSpectralFlux (X, f_s)

    % difference spectrum (set first diff to zero)
    afDeltaX    = diff([X(:,1), X],1,2);
    
    % flux
    vsf         = sqrt(sum(afDeltaX.^2))/size(X,1);
end
