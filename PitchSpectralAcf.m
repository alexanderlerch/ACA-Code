%computes the maximum of the spectral autocorrelation function
%> called by ::ComputePitch
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data 
%>
%> @retval f_0 acf maximum location (in Hz)
% ======================================================================
function [f_0] = PitchSpectralAcf (X, f_s)

    % initialize
    f_min = 300;
    
    % allocate
    f_0 = zeros(1, size(X,2));
    
    % use spectral symmetry for robustness
    X(1, :) = max(max(X));
    X = [flipud(X(2:end, :)); X(1:end-1,:)];
    
    % compute the ACF
    for n = 1: size(X, 2)
        eta_min = round(f_min/f_s * (size(X, 1)-2));
        afCorr = xcorr(X(:,n),'coeff');
        afCorr = afCorr((ceil((length(afCorr)/2))+1):end);
        
        % find local maxima
        [fDummy, eta_peak] = findpeaks(afCorr);

        eta_min = max(eta_min, find(eta_peak > eta_min, 1));
        [fDummy, f_0(n)] = max(afCorr(eta_min:end));
    end
    
    % find max index and convert to Hz (note: X has double length)
    f_0 = (f_0 + eta_min - 1) / (size(X, 1)-2) * f_s;
end
