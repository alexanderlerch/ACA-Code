% ======================================================================
%> @brief 
%>
%> @param 
%> @param iRank: nmf rank
%> @param iMaxIteration: maximum number of iterations (default: 300)
%> @param fSparsity: sparsity weight (default: 0)
%>
%> @retval W dictionary matrix
%> @retval H activation matrix
%> @retval err loss function result
% ======================================================================
function [T,u_pc,ev] = ToolPca(V)

    Cov     = (V' * V)/size(V,1);
    [U,D,T] = svd(Cov);
    u_pc    = V*T; 
    ev      = diag(D); 
end

