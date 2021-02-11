% ======================================================================
%> @brief computes a mel spectrogram from the audio data
%>
%> @param afAudioData: time domain sample data, dimension channels X samples
%> @param f_s: sample rate of audio data
%> @param bLogarithmic: levels (true) or magnitudes (false)
%> @param afWindow: FFT window of length iBlockLength (default: hann), can be [] empty
%> @param iBlockLength: internal block length (default: 4096 samples)
%> @param iHopLength: internal hop length (default: 2048 samples)
%>
%> @retval v feature value
%> @retval t time stamp for the feature value
% ======================================================================
function [M, f_c, t] = ComputeMelSpectrogram (afAudioData, f_s, bLogarithmic, afWindow, iBlockLength, iHopLength, iNumMelBands, fMax)

    % set default parameters if necessary
    if (nargin < 8)
        fMax            = f_s/2;
    end
    if (nargin < 7)
        iNumMelBands    = 128;
    end
    if (nargin < 6)
        iHopLength      = 2048;
    end
    if (nargin < 5)
        iBlockLength    = 4096;
    end
    if (nargin < 3)
        bLogarithmic    = true;
    end
    if (nargin < 1)
        load handel;
        afAudioData = y;
        f_s = Fs;
        clear y,Fs;
    end
 
    % pre-processing: down-mixing
    if (size(afAudioData,2)> 1)
        afAudioData = mean(afAudioData,2);
    end
    % pre-processing: normalization (not necessary for many features)
    if (length(afAudioData)> 1)
        afAudioData = afAudioData/max(abs(afAudioData));
    end
 
    afAudioData = [afAudioData; zeros(iBlockLength,1)];
    
    if (nargin < 4 || isempty(afWindow))
        afWindow    = hann(iBlockLength,'periodic');
    end

    % compute FFT window function
    if (length(afWindow) ~= iBlockLength)
        error('window length mismatch');
    end        

    % in the real world, we would do this block by block...
    [X,f,t]     = spectrogram(  afAudioData,...
                                afWindow,...
                                iBlockLength-iHopLength,...
                                iBlockLength,...
                                f_s);

    % magnitude spectrum
    X           = abs(X)*2/iBlockLength;
    X([1 end],:)= X([1 end],:)/sqrt(2); %let's be pedantic about normalization

    % compute mel filters
    [H,f_c] = locMelFb(iBlockLength, f_s, iNumMelBands, fMax);

    M = H*X;
    
    % amplitude to level
    if (bLogarithmic)
        M = 20*log10(M+1e-12);
    end
end

function [H,f_c] = locMelFb (iFftLength, f_s, iNumFilters, f_max)

    % initialization
    f_min = 0;
    f_max = min(f_max,f_s / 2);
    f_fft = linspace(0, f_s/2, iFftLength/2+1);
    H = zeros(iNumFilters, length(f_fft));

    % compute band center freqs
    mel_min = ToolFreq2Mel(f_min);
    mel_max = ToolFreq2Mel(f_max);
    f_mel = ToolMel2Freq(linspace(mel_min, mel_max, iNumFilters+2));

    f_l = f_mel(1:iNumFilters);
    f_c = f_mel(2:iNumFilters+1);
    f_u = f_mel(3:iNumFilters+2);

    afFilterMax = 2./(f_u-f_l);

    % compute the transfer functions
    for (c = 1:iNumFilters)
        H(c,:)      = ...
            (f_fft > f_l(c) & f_fft <= f_c(c)).* ...
            afFilterMax(c).*(f_fft-f_l(c))/(f_c(c)-f_l(c)) + ...
            (f_fft > f_c(c) & f_fft < f_u(c)).* ...
            afFilterMax(c).*(f_u(c)-f_fft)/(f_u(c)-f_c(c));
    end
end
