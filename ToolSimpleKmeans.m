% ======================================================================
%> @brief kmeans clustering
%>
%> @param FeatureMatrix: features for all train observations (dimension iNumFeatures x iNumObservations)
%> @param k: number of clusters
%> @param numMaxIter: maximum number of iterations (stop if not converged before)
%> @param prevState: internal state that can be stored to continue clustering later
%>
%> @retval clusterIdx cluster index of each observation
%> @retval state internal state (only if needed)
% ======================================================================
function [clusterIdx,state] = ToolSimpleKmeans(FeatureMatrix, k, numMaxIter, prevState)
    
    if (nargin < 3)
        numMaxIter  = 1000;
    end
    if (nargin == 4)
        state = prevState;
    else
        % initialize
        % use fixed seed for reproducibility (comment out if needed)
        rng(42); 
        
        % pick random observations as cluster means
        state = computeClusterMeans_I(FeatureMatrix,...
            round(rand(1,size(FeatureMatrix,2))*(k-1))+1, k);
    end
    range = [min(FeatureMatrix,[],2) max(FeatureMatrix,[],2)];
    
    % assign observations to clusters
    clusterIdx = assignClusterLabels_I(FeatureMatrix,state);
    
    for i=1:numMaxIter
        prevState = state;
        
        % update means
        state = computeClusterMeans_I(FeatureMatrix,clusterIdx,k);
        
        % reinitialize empty clusters
        state = reinitState_I(state, clusterIdx, k, range);
        
        % assign observations to clusters
        clusterIdx = assignClusterLabels_I(FeatureMatrix,state);
        
        % if we have converged, break
        if (max(sum(abs(state.m-prevState.m)))==0)
            break;
        end
    end
end

function [clusterIdx]  = assignClusterLabels_I(FeatureMatrix,state)
    % compute distance to all points
    for (k=1:length(state.m))
        D(k,:) = sqrt(sum((repmat(state.m(:,k),1,size(FeatureMatrix,2))-FeatureMatrix).^2,1));
    end
    
    % assign to closest
    [dummy,clusterIdx] = min(D,[],1);
end

function [state] = computeClusterMeans_I(FeatureMatrix,clusterIdx,K)
    m = zeros(size(FeatureMatrix,1), K);
    for (k=1:K)
        if~(isempty(find(clusterIdx==k)))
            m(:,k) = mean(FeatureMatrix(:,find(clusterIdx==k)),2);
        end
    end
    state = struct('m',m);
end

function  [state] = reinitState_I(state, clusterIdx, K, range)
    for (k=1:K)
        if(isempty(find(clusterIdx==k)))
            state.m(:,k) = rand(size(state,1),1).*(range(:,2)-range(:,1)) + range(:,1);
        end
    end
end
