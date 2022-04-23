%principal component analysis
%>
%> @param V: input matrix (features X observations)
%>
%> @retval U_pc transformed features (score)
%> @retval T transformation matrix (loading)
%> @retval eigenvalues (latent)
% ======================================================================
function [U_pc,T,eigenvalues] = ToolPca(V)

    % covariance
    cov_VV = cov(V');
    
    % svd
    [~,D,T] = svd(cov_VV);
    
    % features to components
    U_pc    = T'*V; 
    
    eigenvalues = diag(D); 
end

