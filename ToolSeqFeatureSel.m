%computes Sequential Forward Feature Selection wrapping a nearest neighbor
%classifier
%>
%> @param V: features (dimension iNumFeatures x iNumObservations)
%> @param ClassIdx: vector with class indices (length iNumObservations)
%> @param iNumFeatures2Select: target number of features (optional)
%>
%> @retval selFeatureIdx vector with ordered feature indices (length: iNumFeatures2Select)
%> @retval AccPerSubset accuracy for each subset
% ======================================================================
function [selFeatureIdx, AccPerSubset] = ToolSeqFeatureSel(V, ClassIdx, iNumFeatures2Select)

    iNumFeatures = size(V, 1);
    if (nargin < 3)
        iNumFeatures2Select = iNumFeatures;
    end

    % initialize
    selFeatureIdx = [];
    unselectedFeatures = ones(1, iNumFeatures);
    AccPerSubset = zeros(1, iNumFeatures);

    for f = 1:iNumFeatures
        % accuracy of selected features plus current feature f
        acc(f) = ToolLooCrossVal(V(f, :), ClassIdx);
    end
    [maxacc, maxidx] = max(acc);
    selFeatureIdx(1) = maxidx;
    unselectedFeatures(maxidx) = 0;
    AccPerSubset(1) = maxacc;
    
    % iterate until target number of features is reached
    for i = 2:iNumFeatures2Select
        acc = zeros(1, iNumFeatures);
        
        % iterate over all features not yet selected
        for f = 1:iNumFeatures
            if (unselectedFeatures(f) > 0)
                % accuracy of selected features plus current feature f
                acc(f) = ToolLooCrossVal(...
                    V([selFeatureIdx(1:(i-1)) f], :), ...
                    ClassIdx);
            else
                acc(f) = -1;
                continue;
            end
        end
        
        % identify feature maximizing the accuracy
        % move feature from unselected to selected
        [maxacc, maxidx] = max(acc);
        selFeatureIdx(i) = maxidx;
        unselectedFeatures(maxidx) = 0;
        AccPerSubset(i) = maxacc;
    end
end