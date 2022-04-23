%computes nmf (implementation inspired by
%https://github.com/cwu307/NmfDrumToolbox/blob/master/src/PfNmf.m)
%>
%> @param X: non-negative matrix to factorize (usually ifreq x iObservations)
%> @param iRank: nmf rank
%> @param iMaxIteration: maximum number of iterations (default: 300)
%> @param fSparsity: sparsity weight (default: 0)
%>
%> @retval W dictionary matrix
%> @retval H activation matrix
%> @retval err loss function result
% ======================================================================
function [W, H, err] = ToolSimpleNmf(X, iRank, iMaxIteration, fSparsity)

    if nargin < 4
        fSparsity = 0;
    end
    if nargin < 3
        iMaxIteration = 300;
    end
    %rng(42);
    
    % avoid zero input
    X = X + realmin;

    % initialization
    [iFreq, iFrames] = size(X);
    err = zeros(1, iMaxIteration);
    bUpdateW = true;
    bUpdateH = true;

    W = rand(iFreq, iRank);
    H = rand(iRank, iFrames);

    % normalize W / H matrix
    for i = 1:iRank
        W(:, i) = W(:, i) ./ (norm(W(:, i), 1));
    end

    count = 0;
    rep   = ones(iFreq, iFrames);

    % iteration
    while (count < iMaxIteration)  
    
        % current estimate
        X_hat = W * H; 
 
        % update
        if bUpdateH
            H = H .* (W'* (X./X_hat)) ./ (W'*rep);
        end
        if bUpdateW
            W = W .* ((X./X_hat)*H') ./ (rep*H');
        end
    
        %normalize
        for i = 1:iRank
            W(:, i) = W(:, i) ./ (norm(W(:, i), 1));
        end
       
        %calculate variation between iterations
        count = count + 1;
        err(count) = KlDivergence_I(X, (W*H)) + fSparsity * norm(H, 1);
    
        if (count >=2)               
            if (abs(err(count) - err(count - 1)) / ...
                    (err(1) - err(count) + realmin)) < 0.001
                break;
            end
        end   
    end
    err = err(1:count);
end

function [D] = KlDivergence_I(p, q)
    D = sum(sum( p.*( log(p + realmin) - log(q + realmin)) - p + q ));
end
