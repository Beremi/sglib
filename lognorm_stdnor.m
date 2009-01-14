function y=lognorm_stdnor( x, mu, sigma )
% LOGNORM_STDNOR Transforms standard normal random numbers into lognormal distributed ones.
%   Y=LOGNORM_STDNOR( X, MU, SIGMA ) transforms standard normal (i.e. N(0,1))
%   distributed random numbers into lognormal distributed random numbers.
%
% Example
%   N=10000;
%   x=randn(N,1);
%   y=lognormal_stdnor(x,1,0.5); 
%   hist(y);
%
% See also LOGNORM_CDF, LOGNORM_PDF

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


y=exp(mu+sigma*x);