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
%> @retval iChordIdx likeliest chord index (Major: 0:11, minor: 12:23, starting from C, dimensions 2 X number of blocks: first row are the raw results without post-processing, second row are the postprocessed results)
%> @retval t timestamps for each result (length blocks)
%> @retval afChordProbs raw chord probability matrix (dimension 24 X blocks)
% ======================================================================
function [cChordLabel, aiChordIdx, t, P_E] = ComputeChords (afAudioData, f_s, iBlockLength, iHopLength)

    % set default parameters if necessary
    if (nargin < 5)
        iHopLength      = 2048;
    end
    if (nargin < 4)
        iBlockLength    = 8192;
    end

    % chord names
    cChords  = char ('C Maj','C# Maj','D Maj','D# Maj','E Maj','F Maj',...
        'F# Maj','G Maj','G# Maj','A Maj','A# Maj','B Maj', 'c min',...
        'c# min','d min','d# min','e min','f min','f# min','g min',...
        'g# min','a min','a# min','b min');
 
    % chord templates
    [T] = generateTemplateMatrix ();
    
    % pre-processing: normalization 
    afAudioData = ToolNormalizeAudio(afAudioData);

    % extract pitch chroma
    [v_pc, t] = ComputeFeature ('SpectralPitchChroma',...
                                afAudioData,...
                                f_s,...
                                [],...
                                iBlockLength,...
                                iHopLength);

    % estimate chord probabilities
    P_E = T * v_pc;
    P_E = P_E ./ sum(P_E,1);
    
    % assign series of labels/indices starting with 0
    aiChordIdx = zeros(2,length(t));
    [~, aiChordIdx(1,:)] = max(P_E,[],1);
    
    % transition probabilities
    [P_T] = getChordTransProb ();

    % compute path with Viterbi algorithm
    [aiChordIdx(2,:), ~] = ToolViterbi(P_E,...
                                P_T,...
                                ones(24,1)/24,...
                                true);

    cChordLabel = deblank(cChords(aiChordIdx,:));
    % we want to start with 0!
    aiChordIdx = aiChordIdx - 1; 

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

function [P_T] = getChordTransProb()
    
    circ = [0 -5 2 -3 4 -1 6 1 -4 3 -2 5,...
            -3 4 -1 6 1 -4 3 -2 5 0 -5 2];
        
    % set the circle radius and distance
    R = 1;
    d = .5;
    
    x = R*cos(2*pi*circ/12);
    y = R*sin(2*pi*circ/12);
    z = [d*ones(1,12),...
        zeros(1,12)];
    
    for (m = 1:size(x,2))
        for (n = 1:size(x,2))
            P_T(m,n) = sqrt((x(m)-x(n))^2 + (y(m)-y(n))^2 + (z(m)-z(n))^2);
        end
    end
 
    P_T = .1+P_T;
    P_T = 1 - P_T/max(max(P_T));
    P_T = P_T ./ sum(P_T,1);
end