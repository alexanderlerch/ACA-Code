%computes path through a probability matrix with Viterbi
%>
%> @param P_E: emmission probability matrix (S X N)
%> @param P_T: transition probability matrix (S X S)
%> @param p_s: start probability vector (S X 1)
%> @param bUseLogLikelihood: flag (default: false)
%>
%> @retval p path vector with matrix row indices (N)
%> @retval P_res probability matrix
% ======================================================================
function [p, P_res] = ToolViterbi(P_E, P_T, p_s, bUseLogLikelihood)
 
    if (nargin < 4)
        bUseLogLikelihood = true;
    end
        
    if (~bUseLogLikelihood)
        % initialization
        I  = zeros(size(P_E));
        P_res = zeros(size(P_E));
        P_res(:, 1) = P_E(:, 1) .* p_s;

        % recursion
        for n = 2:size(P_E, 2)
            for s = 1:size(P_E, 1)
                % find max of preceding times trans prob
                [p_max, I(s, n)] = max(P_res(:, n-1) .* P_T(:, s));
                P_res(s, n) = P_E(s, n) * p_max;
            end
        end
    else
        % initialization
        P_E = log(P_E); % hope for non-zero entries
        P_T = log(P_T); % hope for non-zero entries
        p_s = log(p_s); % hope for non-zero entries
        I = zeros(size(P_E));
        P_res = zeros(size(P_E));

        P_res(:, 1) = P_E(:, 1) + p_s; 
    
        % recursion
        for n = 2:size(P_E, 2)
            for s = 1:size(P_E, 1)
                % find max of preceding times trans prob
                [p_max, I(s, n)] = max(P_res(:, n-1) + P_T(:, s));
                P_res(s, n) = P_E(s, n) + p_max;
            end
        end
    end
        
    % traceback
    p = zeros(1,size(P_E, 2));  
    % start with the last element, then count down
    [prob, p(end)] = max(P_res(:, end));
    for n = size(P_E, 2)-1:-1:1
        p(n) = I(p(n+1), n+1);
    end   
end