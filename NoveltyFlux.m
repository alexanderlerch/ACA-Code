% ======================================================================
%> @brief computes the novelty measure per Spectral Flux
%> called by ::ComputeNoveltyFunction
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval d_flux novelty measure
% ======================================================================
function [d_flux] = NoveltyFlux(X, f_s)
    d_flux = FeatureSpectralFlux(X, f_s);
end
