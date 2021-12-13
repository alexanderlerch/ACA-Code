% ======================================================================
%> @brief nmf implementation inspired by https://github.com/cwu307/NmfDrumToolbox/blob/master/src/PfNmf.m
%>
%> @param V: non-negative matrix to factorize (usually ifreq x iObservations)
%> @param iRank: nmf rank
%> @param iMaxIteration: maximum number of iterations (default: 300)
%> @param fSparsity: sparsity weight (default: 0)
%>
%> @retval W dictionary matrix
%> @retval H activation matrix
%> @retval err loss function result
% ======================================================================
function [W, H, err] = ToolSimpleNmf(V, iRank, iMaxIteration, fSparsity)

    if nargin < 4
        fSparsity = 0;
    end
    if nargin < 3
        iMaxIteration = 300;
    end
    rng(42);
    
    % avoid zero input
    V = V + realmin;

    % initialization
    [iFreq, iFrames] = size(V);
    err = zeros(1,iFrames);
    W_update = 1;
    H_update = 1;

    W = rand(iFreq, iRank);
    H = rand(iRank, iFrames);

    %normalize W / H matrix
    for i = 1:iRank
        W(:,i) = W(:,i)./(norm(W(:,i),1));
    end

    count = 0;
    rep   = ones(iFreq, iFrames);

    % iteration
    while (count < iMaxIteration)  
    
        % current estimate
        approx = W*H; 
 
        % update
        if H_update
            H = H .* (W'* (V./approx))./(W'*rep);
        end
        if W_update
            W = W .* ((V./approx)*H')./(rep*H');
        end
    
        %normalize
        for i = 1:(iRank)
            W(:,i) = W(:,i)./(norm(W(:,i),1));
        end
       
        %calculate variation between iterations
        count = count + 1;
        err(count) = KlDivergence_I(V, (W*H)) + fSparsity * norm(H, 1);
    
        if (count >=2)               
            if (abs(err(count) - err(count -1 )) / ...
                    (err(1) - err(count) + realmin)) < 0.001
                break;
            end
        end   
    end
end

function [D] = KlDivergence_I(p, q)
    D = sum(sum( p.*( log(p + realmin) - log(q + realmin)) - p + q ));
end
