% ======================================================================
%> @brief principal component analysis
%>
%> @param V: input matrix (observations X features)
%>
%> @retval T transformation matrix (loading)
%> @retval u_pc transformed features (score)
%> @retval ev eigenvalues (latent)
% ======================================================================
function [T,u_pc,ev] = ToolPca(V)

    Cov     = (V' * V)/size(V,1);
    [U,D,T] = svd(Cov);
    u_pc    = V*T; 
    ev      = diag(D); 
end

