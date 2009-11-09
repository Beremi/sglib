function exstr=strvarexpand( str )
% STRVAREXPAND Expand variables and expression inside a string.
%   STRVAREXPAND(STR) looks for expressions inside STR delimited by dollar
%   signs ($) and replace them by their value. Everything inside $'s maybe 
%   a variable or expressions that is valid in the scope of the caller. It
%   may evaluate to a string or a number.
%
% Example (<a href="matlab:run_example strvarexpand">run</a>)
%   num=12.3;
%   str='foobar';
%   disp( strvarexpand('num=$num$ str=$str$' ) );
%   index=1;
%   disp( strvarexpand('next index will be: $index+1$ $char(10)$' ) );
%
% See also SPRINTF

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


exstr='';
lpos=1;
pos = strfind(str, '$');
doeval=false;
for i=pos
    part=str(lpos:i-1);
    if doeval
        part=evalin( 'caller', part );
        if isnumeric(part)
            part=num2str(part);
        end
    end
    exstr=[exstr part];
    lpos=i+1;
    doeval=~doeval;
end
if lpos<=length(str)
    part=str(lpos:end);
    exstr=[exstr part];
end
