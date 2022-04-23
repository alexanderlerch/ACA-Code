%computes the fundamental frequency of the (monophonic) audio
%>
%> supported pitch trackers are:
%>  'SpectralAcf',
%>  'SpectralHps',
%>  'TimeAcf',
%>  'TimeAmdf',
%>  'TimeAuditory',
%>  'TimeZeroCrossings',
%>
%> @param cPitchTrackName: feature to compute, e.g. 'SpectralHps'
%> @param x: time domain sample data, dimension channels X samples
%> @param f_s: sample rate of audio data
%> @param afWindow: FFT window of length iBlockLength (default: hann), can be [] empty
%> @param iBlockLength: internal block length (default: 4096 samples)
%> @param iHopLength: internal hop length (default: 2048 samples)
%>
%> @retval f frequency
%> @retval t time stamp for the frequency value
% ======================================================================
function [f, t] = ComputePitch (cPitchTrackName, x, f_s, afWindow, iBlockLength, iHopLength)

    % set function handle
    hPitchFunc = str2func (['Pitch' cPitchTrackName]);

    % set default parameters if necessary
    if (nargin < 6)
        iHopLength = 2048;
    end
    if (nargin < 5)
        iBlockLength = 4096;
    end
  
    % pre-processing: down-mixing
    x = ToolDownmix(x);

    % pre-processing: normalization (not necessary for many features)
    if (length(x)> 1)
        x = x/max(abs(x));
    end
 
    x = [x; zeros(iBlockLength, 1)];
    
    if (IsSpectral_I(cPitchTrackName))
        if (nargin < 4 || isempty(afWindow))
            afWindow = hann(iBlockLength, 'periodic');
        end
        
        % check FFT window function
        if (length(afWindow) ~= iBlockLength)
            error('window length mismatch');
        end        

        % in the real world, we would do this block by block...
        [X, f, t] = ComputeSpectrogram(x, ...
                                    f_s, ...
                                    afWindow, ...
                                    iBlockLength, ...
                                    iHopLength);
        
        % compute frequency
        f = hPitchFunc(X, f_s);
    end %if (IsSpectral_I(cPitchTrackName))
    
    if (IsTemporal_I(cPitchTrackName))
        % compute frequency
        [f,t] = hPitchFunc( x, ...
                            iBlockLength, ...
                            iHopLength, ...
                            f_s);
    end %if (IsTemporal_I(cPitchTrackName))
end

function [bResult] = IsSpectral_I(cName)
    bResult = false;
    iIdx    = strfind(cName, 'Spectral');
    if (~isempty(iIdx))
        if (iIdx(1) == 1)
            bResult = true;
        end
    end
end

function [bResult] = IsTemporal_I(cName)
    bResult = false;
    iIdx    = strfind(cName, 'Time');
    if (~isempty(iIdx))
        if (iIdx(1) == 1)
            bResult = true;
        end
    end
end