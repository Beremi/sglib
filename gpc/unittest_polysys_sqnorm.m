function unittest_polysys_norm
% UNITTEST_POLYSYS_NORM Test the POLYSYS_NORM function.
%
% Example (<a href="matlab:run_example unittest_polysys_norm">run</a>)
%   unittest_polysys_norm
%
% See also POLYSYS_NORM, TESTSUITE 

%   Elmar Zander
%   Copyright 2012, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'polysys_norm' );

% Hermite
assert_equals(polysys_sqnorm('H', 0:5), [1, 1, 2, 6, 24, 120], 'H');
assert_equals(polysys_sqnorm('H', (0:5)'), [1, 1, 2, 6, 24, 120]', 'H');
assert_equals(polysys_sqnorm('h', 0:5), [1, 1, 1, 1, 1, 1], 'h')
assert_equals(polysys_sqnorm('H', 0:5, 'quad'), [1, 1, 2, 6, 24, 120], 'H_quad');
assert_equals(polysys_sqnorm('H', (0:5)', 'quad'), [1, 1, 2, 6, 24, 120]', 'H_quad');

% Legendre
assert_equals(polysys_sqnorm('P', 0:5), [1, 1/3, 1/5, 1/7, 1/9, 1/11], 'P');
assert_equals(polysys_sqnorm('P', (0:5)'), [1, 1/3, 1/5, 1/7, 1/9, 1/11]', 'P');
assert_equals(polysys_sqnorm('p', 0:5), [1, 1, 1, 1, 1, 1], 'p');
assert_equals(polysys_sqnorm('P', 0:5, 'quad'), [1, 1/3, 1/5, 1/7, 1/9, 1/11], 'P_quad');

% Chebyshev 1st kind
assert_equals(polysys_sqnorm('T', 0:5), [1, 0.5, 0.5, 0.5, 0.5, 0.5], 'T');
assert_equals(polysys_sqnorm('t', 0:5), [1, 1, 1, 1, 1, 1], 't');

% Chebyshev 2nd kind
assert_equals(polysys_sqnorm('U', 0:5), [1, 1, 1, 1, 1, 1], 'U');
assert_equals(polysys_sqnorm('u', 0:5), [1, 1, 1, 1, 1, 1], 'u');

% Laguerre
assert_equals(polysys_sqnorm('L', 0:5), [1, 1, 1, 1, 1, 1], 'L');
assert_equals(polysys_sqnorm('l', 0:5), [1, 1, 1, 1, 1, 1], 'l');

