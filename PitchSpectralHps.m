%computes the maximum of the Harmonic Product Spectrum
%> called by ::ComputePitch
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data 
%>
%> @retval f_0 HPS maximum (in Hz)
% ======================================================================
function [f_0] = PitchSpectralHps (X, f_s)

    % initialize
    iOrder = 4;
    f_min = 300;
    k_min = round(f_min/f_s * 2 * (size(X, 1)-1)) + 1;

    afHps = X;
    
    % compute the HPS
    for j = 2:iOrder
        afHps = afHps .* [X(1:j:end, :); zeros(size(X, 1)-size(X(1:j:end,:), 1), size(X, 2))];
    end
    
    % find max index and convert to Hz
    [fDummy, f_0] = max(afHps(k_min:end, :), [], 1);
    f_0 = (f_0 + k_min - 2) / (size(X, 1)-1) * f_s / 2;
    f_0(sum(afHps, 1) == 0) = 0;
end
