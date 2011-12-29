function cmpsol_large_op_klterms

% compares performance different numbers of KL terms in the operator

clc

log_start( fullfile( log_file_base(), mfilename ) );
compare_solvers_pcg( 'model_large_easy_lk40', get_solve_options, 'accurate', false )
show_tex_table_2d(1, [], 'hl',[]);
log_stop();

function opts=get_solve_options
%#ok<*AGROW>
opts={};

ilu_options={'type', 'ilutp', 'droptol', 2e-2, 'milu', 'row', 'udiag', 1 };

gsi_std_opts={...
    'descr', 'gsi', ...
    'longdescr', 'gsi', ...
    'eps', 3e-6
    };

gsi_dyn_opts={...
    'descr', 'gsi dyn', ...
    'longdescr', 'gsi dyn', ...
    'dyn', true, ...
    'eps', 1e-8
    };

gsi_ilu_opts={...
    'descr', 'gsi dyn ilu', ...
    'longdescr', 'gsi dyn ilu', ...
    'prec_strat', {'ilu', ilu_options}, ...
    'dyn', true, ...
    'eps', 1e-8, ...
    'check', true
    };


pcg_mean_opts={...
    'descr', 'pcg', ...
    'longdescr', 'pcg', ...
    'type', 'pcg', ...
    };

pcg_kron_opts={...
    'descr', 'pcg kron', ...
    'longdescr', 'pcg kron', ...
    'type', 'pcg', ...
    'prec', 'kron' };

if fasttest('get')
    lk_set=1:3;
    optlist = {gsi_ilu_opts,pcg_mean_opts,pcg_kron_opts};
else
    lk_set=round(sqrspace(2,40,10));
    optlist = {gsi_std_opts,gsi_dyn_opts,gsi_ilu_opts,pcg_mean_opts};
    %,pcg_kron_opts};
end


for l_k=lk_set
%    for def_opts={gsi_std_opts,gsi_dyn_opts,gsi_ilu_opts,pcg_mean_opts,pcg_kron_opts}
    for def_opts=optlist
        opts{end+1}=varargin2options( [def_opts{1} {'mod_opts', {'l_k',l_k}}] ); 
    end
end

