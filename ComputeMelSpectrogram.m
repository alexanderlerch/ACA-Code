%computes a mel spectrogram from the audio data
%>
%> @param x: time domain sample data, dimension channels X samples
%> @param f_s: sample rate of audio data
%> @param bLogarithmic: levels (true) or magnitudes (false)
%> @param afWindow: FFT window of length iBlockLength (default: hann), can be [] empty
%> @param iBlockLength: internal block length (default: 4096 samples)
%> @param iHopLength: internal hop length (default: 2048 samples)
%> @param iNumMelBands: num of frequency bands (default: 128)
%> @param fMax: maximum frequency (default: f_s/2)
%>
%> @retval M spectrogram
%> @retval f frequency bands
%> @retval t time stamps
% ======================================================================
function [M, f_c, t] = ComputeMelSpectrogram (x, f_s, bLogarithmic, afWindow, iBlockLength, iHopLength, iNumMelBands, fMax)

    % set default parameters if necessary
    if (nargin < 8)
        fMax = f_s/2;
    end
    if (nargin < 7)
        iNumMelBands = 128;
    end
    if (nargin < 6)
        iHopLength = 2048;
    end
    if (nargin < 5)
        iBlockLength = 4096;
    end
    if (nargin < 4 || isempty(afWindow))
        afWindow = hann(iBlockLength,'periodic');
    end
    if (nargin < 3)
        bLogarithmic = true;
    end
    if (nargin < 1)
        load handel;
        x = y;
        f_s = Fs;
        clear y, Fs;
    end
    
    if (length(afWindow) ~= iBlockLength)
        error('window length mismatch');
    end
    
    % pre-processing: down-mixing
    x = ToolDownmix(x);
    
    % pre-processing: normalization 
    x = ToolNormalizeAudio(x);
 
    % in the real world, we would do this block by block...
    [X, f, t] = ComputeSpectrogram(x, ...
                                f_s, ...
                                afWindow, ...
                                iBlockLength, ...
                                iHopLength);

    % compute mel filters
    [H, f_c] = getMelFb_I(iBlockLength, f_s, iNumMelBands, fMax);

    % apply mel filters
    M = H*X;
    
    % amplitude to level
    if (bLogarithmic)
        M = 20*log10(M+1e-12);
    end
end

function [H,f_c] = getMelFb_I (iFftLength, f_s, iNumFilters, f_max)

    % initialization
    f_min   = 0;
    f_max   = min(f_max,f_s / 2);
    f_fft   = linspace(0, f_s/2, iFftLength/2+1);
    H       = zeros(iNumFilters, length(f_fft));

    % compute band center freqs
    mel_min = ToolFreq2Mel(f_min);
    mel_max = ToolFreq2Mel(f_max);
    f_mel   = ToolMel2Freq(linspace(mel_min, mel_max, iNumFilters+2));

    f_l = f_mel(1:iNumFilters);
    f_c = f_mel(2:iNumFilters+1);
    f_u = f_mel(3:iNumFilters+2);

    afFilterMax = 2./(f_u-f_l);

    % compute the transfer functions
    for (c = 1:iNumFilters)
        H(c,:) = ...
            (f_fft > f_l(c) & f_fft <= f_c(c)).* ...
            afFilterMax(c).*(f_fft-f_l(c))/(f_c(c)-f_l(c)) + ...
            (f_fft > f_c(c) & f_fft < f_u(c)).* ...
            afFilterMax(c).*(f_u(c)-f_fft)/(f_u(c)-f_c(c));
    end
end
