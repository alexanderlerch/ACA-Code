% ======================================================================
%> @brief computes the maximum of the spectral autocorrelation function
%> called by ::ComputePitch
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data 
%>
%> @retval f acf maximum (in Hz)
% ======================================================================
function [f] = PitchSpectralAcf (X, f_s)

    % initialize
    iOrder  = 4;
    f_min   = 300;
    
    eta_min = round(f_min/f_s * 2 * size(X,1));

    % allocate
    f       = zeros(1, size(X,2));
    
    % use spectral symmetry for robustness
    X(1,:)  = max(max(X));
    X       = [flipud(X); X];
    
    % compute the ACF
    for (n = 1: size(X,2))
        afCorr          = xcorr(X(:,n),'coeff');
        afCorr          = afCorr((ceil((length(afCorr)/2))+1):end);
        [fDummy, f(n)]  = max(afCorr(1+eta_min:end));
    end
    
    % find max index and convert to Hz (note: X has double length)
    f           = (f + eta_min - 1) / size(X,1) * f_s;
end
