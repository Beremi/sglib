classdef PolynomialSystem < FunctionSystem
    % POLYNOMIALSYSTEM abstract base class for polynomial basis functions
    %
    % See also FUNCTIONSYSTEM HERMITEPOLYNOMIALS LEGENDREPOLYNOMIALS
    
    %   Elmar Zander, Aidin Nojavan
    %   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
    %
    %   This program is free software: you can redistribute it and/or modify it
    %   under the terms of the GNU General Public License as published by the
    %   Free Software Foundation, either version 3 of the License, or (at your
    %   option) any later version.
    %   See the GNU General Public License for more details. You should have
    %   received a copy of the GNU General Public License along with this
    %   program.  If not, see <http://www.gnu.org/licenses/>.
    
    methods (Abstract)
        % RECUR_COEFF compute recursion coefficients of the basis function
        r=recur_coeff(poly, deg)
    end
    
    methods
        function y_alpha_j=evaluate(poly, deg, xi)
            % EVALUATE Evaluates the basis functions at given points.
            %   Y_ALPHA_J = EVALUATE(SYS, XI) evaluates the basis function
            %   specified by SYS at the points specified by XI. If there
            %   are M basis functions and XI is 1 x N matrix, where N is
            %   the number of evaulation points, then the returned matrix Y
            %   is of size N x M such that Y(j,I) is the I-th basis function
            %   evaluated at point XI(J).
            k = size(xi, 2);
            p = zeros(k,deg+1);
            p(:,1) = 0;
            p(:,2) = 1;
            r = recur_coeff(poly, deg+1);
            for d=1:deg
                p(:,d+2) = (r(d,1) + xi' * r(d, 2)) .* p(:,d+1) - r(d,3) * p(:,d);
            end
            
            y_alpha_j = p(:,2:end);
        end
        
        function nrm2=sqnorm(poly, n)
            % SQNORM Compute the square norm of the orthogonal polynomials.
            %   NRM2 = POLYSYS_SQNORM(SYS, N) computes the square of the
            %   norm NRM2 of the system of orthogonal polynomials given by
            %   SYS for the degree N. If N is a vector a vector of square
            %   norms NRM is returned with the same shape.
            %
            %   Note: this method uses an algorithm that computes the norm
            %   based on the recurrence coefficients alone. It can be
            %   overwritten in derived classes for increased effiency or
            %   accuracy (if necessary).
            deg = max(n(:))+1;
            rc = recur_coeff(poly, deg);
            nrm2 = sqnorm_by_rc(rc);
            nrm2 = reshape(nrm2(n+1), size(n));
        end
        
        function poly=normalized(poly)
            % NORMALIZED Return a normalized version of these polynomials
            poly = NormalizedPolynomials(poly);
        end
    end
end

