% ======================================================================
%> @brief computes the novelty function for onset detection
%>
%> supported novelty measures are:
%>  'Flux',
%>  'Laroche',
%>  'Hainsworth'
%>
%> @param cNoveltyName: name of the novelty measure
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
function [d, t, iPeaks] = ComputeNoveltyFunction (cNoveltyName, afAudioData, f_s, afWindow, iBlockLength, iHopLength)

    % set function handle
    hNoveltyFunc    = str2func (['Novelty' cNoveltyName]);

    % set default parameters if necessary
    if (nargin < 6)
        iHopLength      = 512;
    end
    if (nargin < 5)
        iBlockLength    = 4096;
    end
    if (nargin < 4 || isempty(afWindow))
        afWindow    = hann(iBlockLength,'periodic');
    end

    % compute FFT window function
    if (length(afWindow) ~= iBlockLength)
        error('window length mismatch');
    end        

    fLengthLpInS    = 0.3;
    iLengthLp       = max(2,ceil(fLengthLpInS*f_s/iHopLength));

    
    % pre-processing: down-mixing
    if (size(afAudioData,2)> 1)
        afAudioData = mean(afAudioData,2);
    end
    % pre-processing: normalization (not necessary for many features)
    if (size(afAudioData,2)> 1)
        afAudioData = afAudioData/max(abs(afAudioData));
    end

    % in the real world, we would do this block by block...
    [X,f,t]     = spectrogram(  afAudioData,...
                                afWindow,...
                                iBlockLength-iHopLength,...
                                iBlockLength,...
                                f_s);

    % magnitude spectrum
    X           = abs(X)*2/iBlockLength;

    % novelty function
    d           = hNoveltyFunc(X, f_s);
    
    % smooth novelty function
    b               = ones(10,1)/10;
    d               = filtfilt (b,1,d);
    d(d<0)          = 0;
    
    % compute threshold
    b               = ones(iLengthLp,1)/iLengthLp;
    G_T             = .5*mean(d(2:end)) + filtfilt (b,1,d);
    
    [fPeaks,iPeaks] = findpeaks(max(0,d-G_T)); 
    
end

