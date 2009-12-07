function testsuite
% TESTSUITE Run all unit tests in this directory.
%   TESTSUITE runs all tests in this directory.
%
% Example (<a href="matlab:run_example testsuite">run</a>)
%   assert_set_debug( debug )
%   testsuite
%
% See also

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


% TODO: implement proper recursive behaviour of testsuite

dir=fileparts(mfilename('fullpath'));
munit_run_testsuite( 'module_name', 'sglib', 'dir', dir );

% if false
%     subdirs={ 'munit', 'util', 'plot', 'simplefem', 'tensor' };
%     %recursive=true;
%     %dir=get_mfile_path;
%     dir=fileparts(mfilename('fullpath'));
%     prefix='unittest_';
%     disp(dir)
%     munit_run_testsuite( 'sglib', dir, 'subdirs', subdirs, 'prefix', prefix );
% end
