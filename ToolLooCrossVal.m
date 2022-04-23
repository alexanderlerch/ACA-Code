%Leave One Out Cross Validation with Nearest Neighbor Classifier
%>
%> @param FeatureMatrix: features (dimension iNumFeatures x iNumObservations)
%> @param ClassIdx: vector with class indices (length iNumObservations, starting from 0)
%>
%> @retval Acc overall accuracy after Cross-Validation
% ======================================================================
function [Acc, conf_mat] = ToolLooCrossVal(FeatureMatrix, ClassIdx)
 
    % initialize
    TP = 0;
    
    conf_mat = zeros(length(unique(ClassIdx)));
    
    % loop over observations
    for o = 1:size(FeatureMatrix, 2)
        % remove current observation from 'training set'
        v_train = [FeatureMatrix(:, 1:o-1) FeatureMatrix(:, o+1:end)]';
        C_train = [ClassIdx(1:o-1) ClassIdx(:, o+1:end)]';
        
        % compute result of Nearest Neighbor Classifier given the traindata
        res = ToolSimpleKnn(FeatureMatrix(:, o)', v_train, C_train, 1);
        
        conf_mat(ClassIdx(o)+1, res+1) = conf_mat(ClassIdx(o)+1, res+1) + 1;     
        
        % if result is correct increment number of true positives
        if (res == ClassIdx(o))
            TP = TP+1;
        end
    end
 
    % compute overall (micro) accuracy
    Acc = TP / length(ClassIdx);
end
