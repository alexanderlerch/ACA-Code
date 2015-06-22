% ======================================================================
%> @brief computes a simple beat histogram
%>
%> supported novelty measures are:
%>  'Flux',
%>  'Laroche',
%>  'Hainsworth'
%>
%> @param afAudioData: time domain sample data, dimension channels X samples
%> @param f_s: sample rate of audio data
%> @param afWindow: FFT window of length iBlockLength (default: hann), can be [] empty
%> @param iBlockLength: internal block length (default: 4096 samples)
%> @param iHopLength: internal hop length (default: 512 samples)
%>
%> @retval f frequency
%> @retval t time stamp for the frequency value
%> @retval iPeaks indices of picked onset times
% ======================================================================
function [T, Bpm] = ComputeBeatHisto (afAudioData, f_s, afWindow, iBlockLength, iHopLength)

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

    % compute FFT window function
    if (length(afWindow) ~= iBlockLength)
        error('window length mismatch');
    end        

    % novelty function
    [d,t,peaks] = ComputeNoveltyFunction ('Flux', afAudioData, f_s, afWindow, iBlockLength, iHopLength);
%     tmp = zeros(size(d));
%     tmp(peaks) = d(peaks);
%     d = tmp;
    
    % compute autocorrelation
    afCorr  = xcorr(d,'coeff');
    afCorr  = afCorr((ceil((length(afCorr)/2))+1):end);
    
    Bpm     = fliplr(60./t(2:end));
    T       = fliplr (afCorr);

end
