%computes a mel spectrogram from the audio data
%>
%> @param x: time domain sample data, dimension channels X samples
%> @param f_s: sample rate of audio data
%> @param afWindow: FFT window of length iBlockLength (default: hann), can be [] empty
%> @param iBlockLength: internal block length (default: 4096 samples)
%> @param iHopLength: internal hop length (default: 2048 samples)
%> @param bNormalize: normalize input audio (default: True)
%> @param bMagnitude: return magnitude instead of complex spectrum (default: True)
%>
%> @retval X spectrogram
%> @retval f frequency bands
%> @retval t time stamps
% ======================================================================
function [X, f, t] = ComputeSpectrogram (x, f_s, afWindow, iBlockLength, iHopLength, bNormalize, bMagnitude)

    % set default parameters if necessary
    if (nargin < 7)
        bMagnitude = true;
    end
    if (nargin < 6)
        bNormalize = true;
    end
    if (nargin < 5)
        iHopLength = 2048;
    end
    if (nargin < 4)
        iBlockLength = 4096;
    end
    if (nargin < 3 || isempty(afWindow))
        afWindow = hann(iBlockLength,'periodic');
    end
    
    if (length(afWindow) ~= iBlockLength)
        error('window length mismatch');
    end
    
    if (size(afWindow, 1) < size(afWindow, 2))
        afWindow = afWindow';
    end
    if (size(x, 1) < size(x, 2))
        x = x';
    end
    
    % pre-processing: down-mixing
    x = ToolDownmix(x);
    
    % pre-processing: normalization 
    if bNormalize
        x = ToolNormalizeAudio(x);
    end

    [x_b, t] = ToolBlockAudio (x, iBlockLength, iHopLength, f_s);

    X = zeros(size(x_b, 2)/2+1, size(x_b, 1));
    f = linspace(0, f_s/2, (size(X, 1)));

    for n = 1:size(X,2)
        tmp = fft(x_b(n, :)' .* afWindow);
        
        if bMagnitude
            X(:, n) = abs(tmp(1:size(X, 1))) * 2 / iBlockLength;
        else
            X(:, n) = (tmp(1:size(X, 1))) * 2 / iBlockLength;
        end            
    end
    
    % normalization
    X([1 end],:) = X([1 end],:) / sqrt(2);
end
