% ======================================================================
%> @brief computes the key of the input audio (super simple variant)
%>
%> @param afAudioData: time domain sample data, dimension channels X samples
%> @param f_s: sample rate of audio data
%> @param afWindow: FFT window of length iBlockLength (default: hann), can be [] empty
%> @param iBlockLength: internal block length (default: 4096 samples)
%> @param iHopLength: internal hop length (default: 2048 samples)
%>
%> @retval cKey key string
% ======================================================================
function [cKey] = ComputeKey (afAudioData, f_s, afWindow, iBlockLength, iHopLength)

    % set default parameters if necessary
    if (nargin < 5)
        iHopLength      = 2048;
    end
    if (nargin < 4)
        iBlockLength    = 4096;
    end

    if (nargin < 3 || isempty(afWindow))
        afWindow    = hann(iBlockLength,'periodic');
    end

    % key names
    cMajor  = char ('C Maj','C# Maj','D Maj','D# Maj','E Maj','F Maj',...
        'F# Maj','G Maj','G# Maj','A Maj','A# Maj','B Maj');
    cMinor  = char ('c min','c# min','d min','d# min','e min','f min',...
        'f# min','g min','g# min','a min','a# min','b min');
    
    % template pitch chroma (Krumhansl major/minor)
    t_pc    = [6.35 2.23 3.48 2.33 4.38 4.09 2.52 5.19 2.39 3.66 2.29 2.88
               6.33 2.68 3.52 5.38 2.60 3.53 2.54 4.75 3.98 2.69 3.34 3.17];
    t_pc    = diag(1./sum(t_pc,2))*t_pc;
    
    % compute FFT window function
    if (length(afWindow) ~= iBlockLength)
        error('window length mismatch');
    end        

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

    % instantaneous pitch chroma
    v_pc        = FeatureSpectralPitchChroma(X, f_s);

    % average pitch chroma
    v_pc        = mean(v_pc,2);
    
    % compute manhattan distances for major and minor
    d           = zeros(2,12);
    for (i = 0:11)
        d(:,i+1)    = sum(abs(repmat(v_pc',2,1)-circshift(t_pc,[0 i])),2);
    end
    [dist,iKeyIdx]  = min(d,[],2);
    if (dist(1) < dist(2))
        cKey    = deblank(cMajor(iKeyIdx(1),:));
    else
        cKey    = deblank(cMinor(iKeyIdx(2),:));
    end    
end
