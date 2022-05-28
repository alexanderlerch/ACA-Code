%computes the novelty function for onset detection
%>
%> supported novelty measures are:
%>  'Flux',
%>  'Laroche',
%>  'Hainsworth'
%>
%> @param cNoveltyName: name of the novelty measure
%> @param x: time domain sample data, dimension channels X samples
%> @param f_s: sample rate of audio data
%> @param afWindow: FFT window of length iBlockLength (default: hann), can be [] empty
%> @param iBlockLength: internal block length (default: 4096 samples)
%> @param iHopLength: internal hop length (default: 512 samples)
%>
%> @retval f frequency
%> @retval t time stamp for the frequency value
%> @retval G_T threshold function
%> @retval iPeaks indices of picked onset times
% ======================================================================
function [d, t, G_T, iPeaks] = ComputeNoveltyFunction (cNoveltyName, x, f_s, afWindow, iBlockLength, iHopLength)

    % set function handle
    hNoveltyFunc = str2func (['Novelty' cNoveltyName]);

    % set default parameters if necessary
    if (nargin < 6)
        iHopLength = 512;
    end
    if (nargin < 5)
        iBlockLength = 4096;
    end
    if (nargin < 4 || isempty(afWindow))
        afWindow = hann(iBlockLength, 'periodic');
    end

    % compute FFT window function
    if (length(afWindow) ~= iBlockLength)
        error('window length mismatch');
    end        

    % parametrization of smoothing filters
    fSmoothLpLenInS = 0.07;
    fThreshLpLenInS = 0.14;
    iSmoothLpLen = max(2, ceil(fSmoothLpLenInS * f_s / iHopLength));
    iThreshLpLen = max(2, ceil(fThreshLpLenInS * f_s / iHopLength));

    % pre-processing: down-mixing
    x = ToolDownmix(x);

    % pre-processing: normalization (not necessary for many features)
    x = ToolNormalizeAudio(x);

    % in the real world, we would do this block by block...
    [X, f, t] = ComputeSpectrogram(x, ...
                                f_s, ...
                                afWindow, ...
                                iBlockLength, ...
                                iHopLength);

    % novelty function
    d = hNoveltyFunc(X, f_s);

    d = d/max(d);
    
    % smooth novelty function
    b = ones(iSmoothLpLen,1)/iSmoothLpLen;
    d = filtfilt (b, 1, d);
    d(d<0) = 0;
    
    % compute threshold
    iLen = min(iThreshLpLen, floor(length(d) / 3));
    b = ones(iLen, 1) / iLen;
    G_T = .4*mean(d(2:end)) + filtfilt (b, 1, d);
    
    [fPeaks, iPeaks] = findpeaks(max(0, d - G_T)); 
end

