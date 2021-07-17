% ======================================================================
%> @brief computes a simple beat histogram
%>
%> supported computation methods are:
%>  'Corr',
%>  'FFT',
%>  'Hainsworth'
%>
%> @param afAudioData: time domain sample data, dimension channels X samples
%> @param f_s: sample rate of audio data
%> @param method: preferred method of beat histogram computation (default: Corr), can be [] empty
%> @param afWindow: FFT window of length iBlockLength (default: hann), can be [] empty
%> @param iBlockLength: internal block length (default: 4096 samples)
%> @param iHopLength: internal hop length (default: 512 samples)
%>
%> @retval T: Beat histogram
%> @retval Bpm: tempo axis
% ======================================================================
function [T, Bpm] = ComputeBeatHisto (afAudioData, f_s, method, afWindow, iBlockLength, iHopLength)

    % set default parameters if necessary
    if (nargin < 6)
        iHopLength      = 8;
    end
    if (nargin < 5)
        iBlockLength    = 1024;
    end
    if (nargin < 4 || isempty(afWindow))
        afWindow    = hann(iBlockLength,'periodic');
    end
    if (nargin < 3)
        method    = 'FFT';
    end
    % compute FFT window function
    if (length(afWindow) ~= iBlockLength)
        error('window length mismatch');
    end        

    % novelty function
    [d,t,peaks] = ComputeNoveltyFunction ('Flux', afAudioData, f_s, afWindow, iBlockLength, iHopLength);
%     tmp = zeros(size(d));
%     tmp(peaks) = d(peaks);
%     d = tmp;

    if strcmp(method,'Corr')
        % compute autocorrelation
        afCorr  = xcorr(d,'coeff');
        afCorr  = afCorr((ceil((length(afCorr)/2))+1):end);

        Bpm     = fliplr(60./t(2:end));
        T       = fliplr (afCorr);
    else %if method == 'FFT'
        iLength = 65536;
        iHop    = 1024;
        f_s     = f_s / iHopLength;
        if length(d)< 2*iLength
            d = [d zeros(1,2*iLength-length(d))];
        end
        [X,f,tf] = spectrogram(  d,...
                                    [hann(iLength); zeros(iLength,1)],...
                                    iLength-iHopLength,...
                                    2*iLength,...
                                    f_s);
        
        T   = mean(abs(X),2);
        T(1:8)= 0;
        Bpm = f*60;
        low = max(find(Bpm < 30));
        hi = min(find(Bpm > 200));
        T = T(low:hi);
        Bpm = Bpm(low:hi);
        
    end
end
