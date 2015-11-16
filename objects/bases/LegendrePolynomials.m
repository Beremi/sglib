classdef LegendrePolynomials < PolynomialSystem
    % LEGENDREPOLYNOMIALS Construct the LegendrePolynomials.
    %
    % Example (<a href="matlab:run_example LegendrePolynomials">run</a>)
    %   poly=LegendrePolynomials();
    %   x=linspace(-1,1);
    %   y=poly.evaluate(5, x);
    %   plot(x,y);
    %
    % See also HERMITEPOLYNOMIALS POLYNOMIALSYSTEM
    
    %   Elmar Zander, Aidin Nojavan, Noemi Friedman
    %   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
    %
    %   This program is free software: you can redistribute it and/or modify it
    %   under the terms of the GNU General Public License as published by the
    %   Free Software Foundation, either version 3 of the License, or (at your
    %   option) any later version.
    %   See the GNU General Public License for more details. You should have
    %   received a copy of the GNU General Public License along with this
    %   program.  If not, see <http://www.gnu.org/licenses/>.
    
    properties
    end
    
    methods
        function poly=LegendrePolynomials()
            % LEGENDREPOLYNOMIALS Construct the LegendrePolynomials.
            %   POLY=LEGENDREPOLYNOMIALS() constructs a polynomial system
            %   representing the Legendre polynomials.
        end
        
        function r=recur_coeff(~, deg)
            % RECUR_COEFF Compute recurrence coefficient of the Legendre polynomials.
            %
            % References:
            %   [1] http://dlmf.nist.gov/18.3.T1
            %
            % See also POLYNOMIALSYSTEM.RECUR_COEFF
            n = (0:deg-1)';
            zero = zeros(size(n));
            r = [zero, (2*n+1)./(n+1), n ./ (n+1)];
        end
        
        function nrm2 =sqnorm(~, n)
            % SQNORM Compute the square norm of the Legendre polynomials.
            %
            % References:
            %   [1] http://dlmf.nist.gov/18.3.T1
            %
            % See also POLYNOMIALSYSTEM.SQNORM
            nrm2 = 1 ./ (2*n + 1);
        end
        
        %         function w_dist=weighting_func(poly)
        %             %w_dist=UniformDistribution(-1,1);
        %             w_dist= gendist_create('uniform', {-1,1});
        %         end
    end
end
