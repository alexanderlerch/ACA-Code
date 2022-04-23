%computes the novelty measure per Spectral Flux
%> called by ::ComputeNoveltyFunction
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval d_flux novelty measure
% ======================================================================
function [d_flux] = NoveltyFlux(X, f_s)

    % difference spectrum (set first diff to zero)
    afDeltaX = diff([X(:, 1), X], 1, 2);
    
    % half-wave rectification
    afDeltaX(afDeltaX<0) = 0;
    
    % flux
    d_flux = sqrt(sum(afDeltaX.^2)) / size(X, 1);
end
