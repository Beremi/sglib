function B=apply_tensor_operator( A, X, varargin )
% APPLY_TENSOR_OPERATOR Apply a tensor operator to a tensor.
%   B=APPLY_TENSOR_OPERATOR( A, X, VARARGIN ) applies the tensor operator A
%   to the tensor X. Different format for A and X are supported, and can be
%   specified via additional options or automatically detected. The
%   following formats are currently possible for the operator A:
%      kron:     A is just a huge M1M2xN1N2 matrix 
%                i.e. A=kron(M1xN1,M2xN2))
%      block:    A is an M1xN1 cell array of M2xN2 matrices/linear operators
%      tensor:   A is an Kx2 cell array of M1xN1 and M2xN2 matrices
%   The following vector formats are supported:
%      vect:     X is an N1N2 vector
%      mat:      X is an N1*N2 matrix
%      tensor:   X is a Kx2 cell array of vectors of size N and M
%   Note: the block format has to be specified explicitly, since it cannot
%   be unambiguously differentiated from the tensor format.
% 
%   The following combinations of formats are possible:
%      kron/vect, block/vect, block/mat, tensor/mat, tensor/tensor
%
%   NOT POSSIBLE is 'kron/mat' because it allows different interpretations
%   (i.e. should the matrix itself or its transpose be vectorised?) and
%   thus the user should decide that before calling this function. The
%   reasion is that the Kronecker product groups multiples of the second
%   matrices and not of the first. Example
%       irnd=@(x,y)(round(10*rand(x,y)))
%       A=irnd(2,5); B=irnd(4,3); x=irnd(5,1); y=irnd(3,1); 
%       kron(A,B)*kron(x,y)==kron(A*x,B*y)
%   but
%       kron(B,A)*reshape(x*y',[],1)==reshape(A*x*(B*y)',[],1)
%   and not
%       kron(A,B)*reshape(x*y',[],1)==reshape(A*x*(B*y)',[],1)
%   That means you have to 'transpose' the Kronecker product so that it
%   matches a stacked dyadic product.
%
% Example (<a href="matlab:run_example apply_tensor_operator">run</a>)
%
% See also APPLY_LINEAR_OPERATOR, ISFUNCTION

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin{:} );
[optype,options]=get_option( options, 'optype', 'auto' );
[vectype,options]=get_option( options, 'vectype', 'auto' );
check_unsupported_options( options, mfilename );

if strcmp( optype, 'auto' )
    if isnumeric(A)
        optype='kron';
    elseif iscell(A)
        optype='tensor';
    else
        error( 'apply_tensor_operator:auto', 'cannot determine tensor operator type (%s)', class(A) );
    end
end


if strcmp( vectype, 'auto' )
    if isnumeric(X) && isvector(X)
        vectype='vect';
    elseif isnumeric(X) && ~isvector(X)
        vectype='mat';
    elseif iscell(X) 
        vectype='tensor';
    else
        error( 'apply_tensor_operator:auto', 'cannot determine tensor operator type (%s)', class(A) );
    end
end


switch [optype, '/', vectype]
    case 'kron/vect'
        B=apply_kron_vect( A, X );
    case 'block/vect'
        B=apply_block_vect( A, X );
    case 'block/mat'
        B=apply_block_mat( A, X );
    case 'tensor/tensor'
        B=apply_tensor_tensor( A, X );
    case 'tensor/mat'
        B=apply_tensor_mat( A, X );
    otherwise
        error( 'apply_tensor_operator:format', 'unsupported tensor operator/vector combination: %s',  [optype, '/', vectype]);
end
        

function B=apply_kron_vect( A, X )
check_condition( {A,X}, 'match', false, {'A','X'}, mfilename );
B=apply_linear_operator( A, X );


function B=apply_block_vect( A, X )
% TODO: doesn't yet work with general linear operators
[M1,N1]=size(A);
[M2,N2]=size(A{1,1});
B=cell2mat(A)*X;

function B=apply_block_mat( A, X )
% TODO: doesn't yet work with general linear operators
[M1,N1]=size(A);
[M2,N2]=size(A{1,1});
B=reshape(cell2mat(A)*X(:),[M2,M1]);

function B=apply_tensor_tensor( A, X )
% TODO: doesn't yet work with higher order tensors
% TODO: no reduction yet
check_condition( {A{1,1},X{1}}, 'match', true, {'A{1,1}','X{1}'}, mfilename );
check_condition( {A{1,2},X{2}}, 'match', true, {'A{1,2}','X{2}'}, mfilename );
[M1,N1]=apply_linear_operator(A{1,1});
[M2,N2]=apply_linear_operator(A{1,2});
B={zeros(M1,0),zeros(M2,0)};
R=size(A,1);
for i=1:R
    B1n=apply_linear_operator(A{i,1},X{1});
    B2n=apply_linear_operator(A{i,2},X{2});
    B={[B{1}, B1n], [B{2}, B2n] };
end


function B=apply_tensor_mat( A, X )
% TODO: doesn't yet work with higher order tensors
% TODO: no reduction yet
check_condition( {A{1,1},X}, 'match', false, {'A{1,1}','X'}, mfilename );
check_condition( {A{1,2},X'}, 'match', false, {'A{1,2}','X'''}, mfilename );

K=size(A,1);
for i=1:K
    Y=A{i,1}*X*A{i,2}';
    if i==1; B=Y; else B=B+Y; end;
end