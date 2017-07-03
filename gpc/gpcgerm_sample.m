function xi = gpcgerm_sample(V, n, varargin)
% GPCGERM_SAMPLE Draw samples from a GPC germ.
%   XI = GPCGERM_SAMPLE(V, N) creates M rows and N columns of samples, where M
%   is the number of random variables. V contains a specification of the
%   random variables and a multiindex set (see Example). 
%
%   XI = GPCGERM_SAMPLE(V, N, 'mode', 'qmc') creates the random samples via
%   transformed uniform [0,1] Quasi Monte Carlo random numbers generated by
%   the standard Halton sequence.
%
%   XI = GPCGERM_SAMPLE(V, N, 'mode', 'lhs') creates the random samples via
%   transformed uniform [0,1] Latin hypercube samples. You can also choose
%   between 'mlhs' and 'rlhs' (see below under Options).
%
%   XI = GPCGERM_SAMPLE(V, N, 'rand_func', @my_rand_func) creates the random
%   samples via a call to @my_rand_func. The returned values must be in
%   the range [0,1].
%
% Options:
%    mode: {'default'}, 'qmc', 'lhs', 'mlhs', 'rlhs'
%      Determine how the uniform samples are generated. In the default mode
%      some samples (e.g. for normal rv's) are generated directly and not
%      via the inverse cdf transform method.
%      'mlhs' and 'rlhs' are different modes for the latin hypercube, with
%      the points chosen randomly inside the hypercubes and in the centers
%      of the hypercubes, respectively. The default 'lhs' corresponds to
%      'rlhs'.
%    rand_func: {}
%      Specifies a function to call in order to produce the random samples.
%      The function will be called by funcall(rand_func,n,m), where the
%      first parameter N is the number of samples and M is the number of
%      random variables.
%
% Example 1 (<a href="matlab:run_example gpcgerm_sample 1">run</a>)
%    V = gpcbasis_create('H', 'm', 3, 'p', 2);
%    xi = gpcgerm_sample(V, 5)
%
% Example 2 (<a href="matlab:run_example gpcgerm_sample 2">run</a>)
%    V = gpcbasis_create('PLh');
%    xi = gpcgerm_sample(V, 3000, 'mode', 'default');
%    subplot(2,2,1);
%    plot(xi(1,:), xi(2,:), '.')
%    xlabel('Uniform'); ylabel('Exponential');
%    subplot(2,2,2);
%    plot(xi(3,:), xi(2,:), '.')
%    xlabel('Gauss'); ylabel('Exponential');
%    subplot(2,2,3);
%    plot(xi(1,:), xi(3,:), '.')
%    xlabel('Uniform'); ylabel('Gauss');
%
% Example 3 (<a href="matlab:run_example gpcgerm_sample 3">run</a>)
%    V = gpcbasis_create('hh');
%    subplot(2,2,1);
%    xi = gpcgerm_sample(V, 300, 'mode', 'default');
%    plot(xi(1,:), xi(2,:), '.')
%    subplot(2,2,2);
%    xi = gpcgerm_sample(V, 300, 'mode', 'qmc');
%    plot(xi(1,:), xi(2,:), '.')
%    subplot(2,2,3);
%    xi = gpcgerm_sample(V, 300, 'mode', 'lhs');
%    plot(xi(1,:), xi(2,:), '.')
%    subplot(2,2,4);
%    xi = gpcgerm_sample(V, 300, 'mode', 'mlhs');
%    plot(xi(1,:), xi(2,:), '.')
% See also GPC, GPC_EVALUATE

%   Elmar Zander
%   Copyright 2012, Inst. of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[mode,options]=get_option(options, 'mode', 'default');
[rand_func,options]=get_option(options, 'rand_func', []);
[qmc_options,options]=get_option(options, 'qmc_options', {});
check_unsupported_options(options,mfilename);

syschars = V{1};
I = V{2};
m = size(I,2);
check_boolean(length(syschars)==1 || length(syschars)==m, 'length of polynomial system must be one or match the size of the multiindices', mfilename);

if nargin<2 || isempty(n)
    n = 1;
end

switch(mode)
    case {'mc', 'default'}
        U = [];
        if ~isempty(rand_func)
            U = funcall(rand_func, n, m);
            if any(size(U)~=[n, m])
                error('sglib:gpcgerm_sample', 'rand_func did not return an array of the expect size [%d,%d], but [%d,%d]', n, m, size(U,1), size(U,2));
            end
        end
    case 'qmc'
        U = halton_sequence(n, m, qmc_options);
    case 'qmc_sobol'
        U = sobol_sequence(n, m, qmc_options);
    case {'lhs', 'rlhs'}
        U = lhs_uniform(n, m);
    case 'mlhs'
        U = lhs_uniform(n, m, 'mode', 'median');
    otherwise
        error('sglib:gpcgerm_sample', 'Unknown paramter value "%s" for option "mode"', mode);
end

if length(syschars)==1
    if isempty(U)
        xi = polysys_sample_rv(syschars, m, n);
    else
        xi = polysys_sample_rv(syschars, U');
    end
else
    check_range(length(syschars), m, m, 'len(syschars)==m', mfilename);
    xi = zeros(m, n);
    for j = 1:m
        if isempty(U)
            xi(j,:) = polysys_sample_rv(syschars(j), 1, n);
        else
            xi(j,:) = polysys_sample_rv(syschars(j), U(:,j));
        end
    end
end




% function gpc_from_uniform(sys, U)
% if length(sys)==1
%     xi = polysys_sample_rv(sys, U');
% else
%     check_range(length(sys), m, m, 'len(sys)==m', mfilename);
%     xi = zeros(m, n);
%     for j = 1:m
%         xi(j,:) = polysys_sample_rv(sys(j), U(:,j));
%     end
% end

