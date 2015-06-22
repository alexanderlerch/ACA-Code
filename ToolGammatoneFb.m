% ======================================================================
%> @brief computes a gammatone filterbank
%> see function MakeERBFilters.m from Slaneys Auditory Toolbox
%>
%> @param afAudioData: time domain sample data, dimension channels X samples
%> @param f_s: sample rate of audio data
%> @param iNumBands: number of filter bands
%> @param f_low: start frequency
%>
%> @retval X filtered signal (dimension bands X samples)
%> @retval f_c filterbank mid frequencies
% ======================================================================
function [X, f_c] = ToolGammatoneFb(afAudioData, f_s, iNumBands, f_low)
    
    if (nargin < 4)
        f_low       = 100;
    end
    if (nargin < 3)
        iNumBands   = 20;
    end
        
    %initialization
    fEarQ   = 9.26449;				
    fBW     = 24.7;
    iOrder  = 1;
    
    T       = 1/f_s;
    
    % compute the mid frequencies
    f_c     = GetMidFrequencies (f_low, f_s/2, iNumBands, fEarQ, fBW);
    
    % compute the coefficients
    [afCoeffB, afCoeffA] = GetCoeffs (f_c, 1.019*2*pi*(((f_c/fEarQ).^iOrder + fBW^iOrder).^(1/iOrder)), T);
 
    % allocate output memory
    X       = zeros(iNumBands, length(afAudioData));
 
    % pre-processing: down-mixing
    if (size(afAudioData,2)> 1)
        afAudioData = mean(afAudioData,2);
    end
 
    % do the (cascaded) filter process
    for (k = 1:iNumBands)
        X(k,:)  = afAudioData;
        for (j = 1:4)
            X(k,:)  = filter(afCoeffB(j,:,k), afCoeffA(j,:,k), X(k,:));
        end
    end
end

%> see function ERBSpace.m from Slaneys Auditory Toolbox
function [f_c] = GetMidFrequencies (f_low, f_hi, iNumBands, fEarQ, fBW)
    f_c     = -(fEarQ*fBW) + exp((1:iNumBands)'*(-log(f_hi + fEarQ*fBW) + ...
            log(f_low + fEarQ*fBW))/iNumBands) * (f_hi + fEarQ*fBW);
end


%> see function MakeERBFilters.m from Slaneys Auditory Toolbox
function [afCoeffB, afCoeffA] = GetCoeffs (f_c, B, T)

    fCos    = cos(2*f_c*pi*T);
    fSin    = sin(2*f_c*pi*T);
    fExp    = exp(B*T);
    fSqrtA  = 2*sqrt(3+2^1.5);
    fSqrtS  = 2*sqrt(3-2^1.5);

    A0      = T;
    A2      = 0;
    B0      = 1;
    B1      = -2*fCos./fExp;
    B2      = exp(-2*B*T);

    A11     = -(2*T*fCos./fExp + fSqrtA*T*fSin./ fExp)/2;
    A12     = -(2*T*fCos./fExp - fSqrtA*T*fSin./ fExp)/2;
    A13     = -(2*T*fCos./fExp + fSqrtS*T*fSin./ fExp)/2;
    A14     = -(2*T*fCos./fExp - fSqrtS*T*fSin./ fExp)/2;

    fSqrtA  = sqrt(3 + 2^(3/2));
    fSqrtS  = sqrt(3 - 2^(3/2));
    fArg    = i*f_c*pi*T;
    
    afGain    = ...
    abs((-2*exp(4*fArg)*T+2*exp(-(B*T)+2*fArg).*T.*(fCos-fSqrtS*fSin)).* ...
        (-2*exp(4*fArg)*T+2*exp(-(B*T)+2*fArg).*T.*(fCos+fSqrtS*fSin)).* ...
        (-2*exp(4*fArg)*T+2*exp(-(B*T)+2*fArg).*T.*(fCos-fSqrtA*fSin)).* ...
        (-2*exp(4*fArg)*T+2*exp(-(B*T)+2*fArg).*T.*(fCos+fSqrtA*fSin))./ ...
        (-2 ./ exp(2*B*T) - 2*exp(4*fArg) + 2*(1 + exp(4*fArg))./fExp).^4);

    % this is Slaneys compact format - now resort into 3D Matrices
    %fcoefs = [A0*ones(length(f_c),1) A11 A12 A13 A14 A2*ones(length(f_c),1) B0*ones(length(f_c),1) B1 B2 afGain];
    
    afCoeffB = zeros(4,3,length(B));    
    afCoeffA = zeros(4,3,length(B));
    
    for (k = 1:length(B))
        afCoeffB(1,:,k)     = [A0 A11(k) A2]/afGain(k);
        afCoeffA(1,:,k)     = [B0 B1(k) B2(k)];
        
        afCoeffB(2,:,k)     = [A0 A12(k) A2];
        afCoeffA(2,:,k)     = [B0 B1(k) B2(k)];
        
        afCoeffB(3,:,k)     = [A0 A13(k) A2];
        afCoeffA(3,:,k)     = [B0 B1(k) B2(k)];
        
        afCoeffB(4,:,k)     = [A0 A14(k) A2];
        afCoeffA(4,:,k)     = [B0 B1(k) B2(k)];
        
    end
end