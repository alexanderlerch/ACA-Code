%gaussian mixture model
%>
%> @param FeatureMatrix: features for all train observations (dimension iNumFeatures x iNumObservations)
%> @param k: number of gaussians
%> @param numMaxIter: maximum number of iterations (stop if not converged before)
%> @param prevState: internal state that can be stored to continue clustering later
%>
%> @retval mu means
%> @retval sigma standard deviations
%> @retval state result containing internal state (if needed)
% ======================================================================
function [mu, sigma, state] = ToolGmm(V, k, numMaxIter, prevState)
    
    if (nargin < 3)
        numMaxIter  = 1000;
    end
    if (nargin == 4)
        state = prevState;
    else
        % initialize state
        state = initState_I(V, k);
    end
    
    for j = 1:numMaxIter
        prevState = state;
        
        % compute weighted gaussian 
        p = computeProb_I(V, state);
        
        % update clusters
        state = updateGaussians_I(V, p, state);
         
        % if we have converged, break
        if (max(sum(abs(state.m-prevState.m))) <= 1e-20)
            break;
        end
    end
    
    mu = state.m;
    sigma = state.sigma;
end

function [state] = updateGaussians_I(FeatureMatrix, p, state)

    % number of clusters
    K = size(state.m, 2);
 
    % update priors
    state.prior = mean(p, 1)';

    for k = 1:K
        s = 0;
        
        % update means
        state.m(:, k) = FeatureMatrix * p(:, k) / sum(p(:, k));
        
        % subtract mean
        F = FeatureMatrix - repmat(state.m(:, k), 1, size(FeatureMatrix, 2));
        
        for n = 1:size(FeatureMatrix, 2)
            s = s + p(n, k) * (F(:, n) * F(:, n)');
        end
        state.sigma(:, :, k) = s / sum(p(:, k));
    end
end

function [p] = computeProb_I(FeatureMatrix, state)

    K = size(state.m, 2);
    p = zeros(size(FeatureMatrix, 2), K);
    
    % for each cluster
    for k = 1:K
        % subtract mean
        F = FeatureMatrix - repmat(state.m(:, k), 1, size(FeatureMatrix, 2));

        % weighted gaussian
        p(:, k) = 1 / sqrt((2*pi)^size(F, 1) * det(state.sigma(:, :, k))) *...
            exp(-1/2 * sum((F .* (inv(state.sigma(:, :, k)) * F)), 1)');
        p(:, k) = state.prior(k) * p(:, k);
    end
    
    % norm over clusters
    p = p ./ repmat(sum(p, 2), 1, K);
end

function [state] = initState_I(FeatureMatrix, K)

    %init
    m       = zeros(size(FeatureMatrix, 1), K);
    sigma   = zeros(size(FeatureMatrix, 1), size(FeatureMatrix, 1), K);
    prior   = zeros(1, K);

    % pick random points as cluster means
    mIdx    = round(rand(1, K) * (size(FeatureMatrix, 2)-1)) + 1;
 
    % assign means etc.
    m       = FeatureMatrix(:, mIdx);
    prior   = ones(1, K) / K;
    sigma   = repmat(cov(FeatureMatrix'), 1, 1, K);

    % write initial state
    state   = struct('m', m, 'sigma', sigma, 'prior', prior);
end
