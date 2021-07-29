% ======================================================================
%> @brief Leave One Out Cross Validation with Nearest Neighbor Classifier
%>
%> @param FeatureMatrix: features (dimension iNumFeatures x iNumObservations)
%> @param ClassIndices: vector with class indices (length iNumObservations)
%>
%> @retval Acc overall accuracy after Cross-Validation
% ======================================================================
function [Acc] = ToolLooCrossVal(FeatureMatrix, ClassIndices)
 
    % initialize
    TP = 0;
    
    % loop over observations
    for o = 1:size(FeatureMatrix,2)
        % remove current observation from 'training set'
        v_train = [FeatureMatrix(:,1:o-1) FeatureMatrix(:,o+1:end)]';
        C_train = [ClassIndices(1:o-1) ClassIndices(:,o+1:end)]';
        
        % compute result of Nearest Neighbor Classifier given the traindata
        res = ToolSimpleKnn(FeatureMatrix(:,o)', v_train,C_train,1);
        
        % if result is correct increment number of true positives
        if (res == ClassIndices(o))
            TP = TP+1;
        end
    end
 
    % compute overall (macro) accuracy
    Acc = TP/length(ClassIndices);
end
