%performs kmeans clustering
%>
%> @param V: features for all train observations (dimension iNumFeatures x iNumObservations)
%> @param k: number of clusters
%> @param numMaxIter: maximum number of iterations (stop if not converged before)
%> @param prevState: internal state that can be stored to continue clustering later
%>
%> @retval clusterIdx cluster index of each observation
%> @retval state internal state (only if needed)
% ======================================================================
function [clusterIdx, state] = ToolSimpleKmeans(V, K, numMaxIter, prevState)
    
    if (nargin < 3)
        numMaxIter = 1000;
    end
    if (nargin == 4)
        state = prevState;
    else
        % initialize
        % use fixed seed for reproducibility (comment out if needed)
        %rng(42); 
        
        % pick random observations as cluster means
        state = struct('m', V(:, round(rand(1, K) * (size(V, 2)-1))+1)); 
    end
    range_V = [min(V, [], 2) max(V, [], 2)];
    
    % assign observations to clusters
    clusterIdx = assignClusterLabels_I(V, state);
    
    for i = 1:numMaxIter
        prevState = state;
        
        % update means
        state = computeClusterMeans_I(V, clusterIdx, K);
        
        % reinitialize empty clusters
        state = reinitState_I(state, clusterIdx, K, range_V);
        
        % assign observations to clusters
        clusterIdx = assignClusterLabels_I(V, state);
        
        % if we have converged, break
        if (max(sum(abs(state.m-prevState.m))) == 0)
            break;
        end
    end
end

function [clusterIdx]  = assignClusterLabels_I(V, state)

    K = size(state.m, 2);
    
    % compute distance to all points
    for k = 1:K
        D(k, :) = sqrt(sum((repmat(state.m(:, k), 1, size(V, 2))-V).^2, 1));
    end
    
    % assign to closest
    [dummy, clusterIdx] = min(D, [], 1);
end

function [state] = computeClusterMeans_I(V, clusterIdx, K)
    m = zeros(size(V, 1), K);
    for k = 1:K
        if~(isempty(find(clusterIdx==k)))
            m(:, k) = mean(V(:,find(clusterIdx==k)), 2);
        end
    end
    state = struct('m',m);
end

function  [state] = reinitState_I(state, clusterIdx, K, range)
    for k = 1:K
        if(isempty(find(clusterIdx==k)))
            state.m(:, k) = rand(size(state, 1), 1).*(range(:, 2)-range(:, 1)) + range(:, 1);
        end
    end
end
