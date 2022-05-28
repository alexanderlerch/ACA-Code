%computes the novelty measure used by laroche
%> called by ::ComputeNoveltyFunction
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval d_lar novelty measure
% ======================================================================
function [d_lar] = NoveltyLaroche (X, f_s)

    % difference spectrum
    afDeltaX    = diff([sqrt(X(:,1)), sqrt(X)],1,2);
    
    % half-wave rectification
    afDeltaX(afDeltaX<0) = 0;
    
    % flux
    d_lar       = sum(afDeltaX)/size(X,1);
end
