% ======================================================================
%> @brief Leave One Out Cross Validation with Nearest Neighbor Classifier
%>
%> @param FeatureMatrix: features (dimension iNumFeatures x iNumObservations)
%> @param ClassIndices: vector with class indices (length iNumObservations)
%>
%> @retval Acc overall accuracy after Cross-Validation
% ======================================================================
function [AccPerSubset, selectedFeatureIdx] = ToolSeqFeatureSel(FeatureMatrix, ClassIndices, iNumFeatures2Select)

    iNumFeatures        = size(FeatureMatrix,1);
    if (nargin < 3)
        iNumFeatures2Select = iNumFeatures;
    end

    % initialize
    selectedFeatureIdx  = [];
    unselectedFeatures  = ones(1,iNumFeatures);
    AccPerSubset        = zeros(1,iNumFeatures);
    
    % iterate until target number of features is reached
    for (i = 1:iNumFeatures2Select)
        acc = zeros(1,iNumFeatures);
        
        % iterate over all features not yet selected
        for f = 1:iNumFeatures
            if (unselectedFeatures(f) > 0)
                % accuracy of selected features plus current feature f
                acc(f)  = ToolLooCrossVal(FeatureMatrix([selectedFeatureIdx f],:),ClassIndices);
            else
                acc(f)  = -1;
                continue;
            end
        end
        
        % identify feature maximizing the accuracy
        % move feature from unselected to selected
        [maxacc,maxidx]             = max(acc);
        selectedFeatureIdx          = [selectedFeatureIdx, maxidx];
        unselectedFeatures(maxidx)  = 0;
        AccPerSubset(i)             = maxacc;
    end
end