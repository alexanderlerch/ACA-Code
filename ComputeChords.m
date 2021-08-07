% ======================================================================
%> @brief computes the key of the input audio (super simple variant)
%>
%> @param afAudioData: time domain sample data, dimension samples X channels
%> @param f_s: sample rate of audio data
%> @param afWindow: FFT window of length iBlockLength (default: hann), can be [] empty
%> @param iBlockLength: internal block length (default: 4096 samples)
%> @param iHopLength: internal hop length (default: 2048 samples)
%>
%> @retval cChordLabel likeliest chord string (e.g., C Maj)
%> @retval iChordIdx likeliest chord index (Major: 0:11, minor: 12:23, starting from C)
%> @retval t timestamps for each result (length blocks)
%> @retval afChordProbs raw chord probability matrix (dimension 24 X blocks)
% ======================================================================
function [cChordLabel, iChordIdx, t, afChordProbs] = ComputeChords (afAudioData, f_s, afWindow, iBlockLength, iHopLength)

    % set default parameters if necessary
    if (nargin < 5)
        iHopLength      = 2048;
    end
    if (nargin < 4)
        iBlockLength    = 8192;
    end

    if (nargin < 3 || isempty(afWindow))
        afWindow    = hann(iBlockLength,'periodic');
    end

    % chord names
    cChords  = char ('C Maj','C# Maj','D Maj','D# Maj','E Maj','F Maj',...
        'F# Maj','G Maj','G# Maj','A Maj','A# Maj','B Maj', 'c min',...
        'c# min','d min','d# min','e min','f min','f# min','g min',...
        'g# min','a min','a# min','b min');
    
    % chord templates
    [T] = generateTemplateMatrix ();
    
    % compute FFT window function
    if (length(afWindow) ~= iBlockLength)
        error('window length mismatch');
    end        

    % pre-processing: down-mixing
    afAudioData = ToolDownmix(afAudioData);
    
    % pre-processing: normalization 
    afAudioData = ToolNormalizeAudio(afAudioData);

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

    % estimate chord probabilities
    afChordProbs = T * v_pc;
    afChordProbs = afChordProbs ./ sum(afChordProbs,1);
    
    % assign series of labels/indices starting with 0
    [confidence, iChordIdx] = max(afChordProbs,[],1);
    cChordLabel = deblank(cChords(iChordIdx,:));
    iChordIdx = iChordIdx - 1;
end

function [T] = generateTemplateMatrix ()
    T = zeros(24,12);
    T(1,[1 5 8]) = 1/3;
    T(13,[1 4 8]) = 1/3;
    for i = 1:11
        T(i+1,:) = circshift(T(i,:),1,2);
        T(i+13,:) = circshift(T(i+12,:),1,2);
    end
end
