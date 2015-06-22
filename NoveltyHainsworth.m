% ======================================================================
%> @brief computes the novelty measure used by Hainsworth
%> called by ::ComputeNoveltyFunction
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval d_hai novelty measure
% ======================================================================
function [d_hai] = NoveltyHainsworth (X, f_s)

    epsilon     = 1e-5;
    
    % difference spectrum
    X           = [X(:,1), sqrt(X)];
    X(X<=0)     = epsilon;
    
    % flux
    d_hai       = sum(log2(X(:,2:end)./X(:,1:end-1)))/size(X,1);
end
