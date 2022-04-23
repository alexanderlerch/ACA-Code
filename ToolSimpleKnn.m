%performs knn classification
%>
%> @param TestFeatureVector: features for test observation (length iNumFeatures)
%> @param TrainFeatureMatrix: features for all train observations (dimension iNumFeatures x iNumObservations)
%> @param TrainClassIndices: audio signal (length iNumObservations)
%> @param k: number of points taken into account (default = 3)
%>
%> @retval class index of the resulting class
% ======================================================================
function [class] = ToolSimpleKnn(TestFeatureVector, TrainFeatureMatrix, TrainClassIndices, k)
 
    % set order to 3 if not set
    if (nargin < 4)
        k = 3;
    end
 
    % compute distances to all training observations
    d = computeEucDist_I(TestFeatureVector, TrainFeatureMatrix);
    
    % sort the distances to find closest
    [dummy,idx] = sort(d); 
    
    % pick the majority of the k closest training observations
    % note that for multi-class problems and even k, this needs to be
    % refined
    class = mode(TrainClassIndices(idx(1:k)));
end

function d = computeEucDist_I(A, B)
    d = sqrt(sum(A.^2, 2)*ones(1,size(B,1)) - ...
        2*A*B' + ...
        ones(size(A,1),1)*sum(B.^2, 2)');
end
