%computes a simple beat histogram
%>
%> supported computation methods are:
%>  'Corr',
%>  'FFT',
%>
%> @param x: time domain sample data, dimension channels X samples
%> @param f_s: sample rate of audio data
%> @param cMethod: method of beat histogram computation (default: 'FFT')
%> @param afWindow: FFT window of length iBlockLength (default: hann), can be [] empty
%> @param iBlockLength: internal block length (default: 4096 samples)
%> @param iHopLength: internal hop length (default: 512 samples)
%>
%> @retval T: Beat histogram
%> @retval Bpm: tempo axis
% ======================================================================
function [T, Bpm] = ComputeBeatHisto (x, f_s, cMethod, afWindow, iBlockLength, iHopLength)

    % set default parameters if necessary
    if (nargin < 6)
        iHopLength = 8;
    end
    if (nargin < 5)
        iBlockLength = 1024;
    end
    if (nargin < 4 || isempty(afWindow))
        afWindow = hann(iBlockLength, 'periodic');
    end
    if (nargin < 3)
        cMethod = 'FFT';
    end
    % compute FFT window function
    if (length(afWindow) ~= iBlockLength)
        error('window length mismatch');
    end        

    % pre-processing: down-mixing
    x = ToolDownmix(x);

    % novelty function
    [d, t, G_T, peaks] = ComputeNoveltyFunction (  'Flux', ...
                                            x, ...
                                            f_s, ...
                                            afWindow, ...
                                            iBlockLength, ...
                                            iHopLength);

    if strcmp(cMethod, 'Corr')
        % compute autocorrelation
        r_dd  = xcorr(d, 'coeff');
        r_dd  = r_dd((ceil((length(r_dd) / 2)) + 1):end);

        Bpm = fliplr(60 ./ t(2:end));
        T = fliplr (r_dd);
    else %if method == 'FFT'
        iLength = 65536;
        f_s = f_s / iHopLength;
        if length(d)< 2 * iLength
            d = [d zeros(1, 2 * iLength - length(d))];
        end
        [D, f, tf] = ComputeSpectrogram(d, ...
                                        f_s, ...
                                        [hann(iLength); zeros(iLength,1)], ...
                                        2*iLength, ...
                                        iLength/4);
 
        % adjust output BPM range
        T       = mean(abs(D), 2);
        Bpm     = f * 60;
        lIdx    = max(find(Bpm < 30));
        hIdx    = min(find(Bpm > 200));
        T       = T(lIdx:hIdx);
        Bpm     = Bpm(lIdx:hIdx);
        T = T/max(T);
    end
end
