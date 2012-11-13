function cmpsol_large
% show results for solving the huge model

clc
log_start( fullfile( log_file_base(), mfilename ) );
compare_solvers_pcg( 'model_large_easy', get_solve_options, 'accurate', true )
%compare_solvers_pcg( 'model_medium_easy', get_solve_options, 'accurate', true )
show_tex_table(1,[]);
log_stop();


function opts=get_solve_options

% struct( 'longdescr', 'normal tensor solver', 'descr', 'normal');
gsi_std_opts1={...
    'descr', 'gsi', ...
    'longdescr', 'gsi/basic', ...
    'solve_opts', {'div_b', 1, 'div_op', 1}, ...
    'eps', 5e-6};

gsi_std_opts2={...
    'descr', 'gsi', ...
    'longdescr', 'gsi/basic', ...
    'solve_opts', {'fast_qr', false}, ...
    'eps', 5e-6};

gsi_std_opts3={...
    'descr', 'gsi fqr', ...
    'longdescr', 'gsi fqr/basic', ...
    'solve_opts', {'fast_qr', true}, ...
    'eps', 5e-6};


gsi_dyn_opts={...
    'descr', 'gsi dyn', ...
    'longdescr', 'gsi dyn/basic', ...
    'dyn', true, ...
    'eps', 1e-8 };

gsi_inside_opts={...
    'descr', 'gsi dyn inside', ...
    'longdescr', 'gsi dyn/inside', ...
    'prec_strat', {'inside'}, ...
    'dyn', true, ...
    'solve_opts', {'div_b', 10, 'div_op', 10}, ...
    'eps', 1e-8};

ilu_options={'type', 'ilutp', 'droptol', 2e-2, 'milu', 'row', 'udiag', 1 };
gsi_ilu_opts={...
    'descr', 'gsi dyn ilu', ...
    'longdescr', 'gsi dyn/ilu', ...
    'prec_strat', {'ilu', ilu_options}, ...
    'dyn', true, ...
    'solve_opts', {'div_b', 10, 'div_op', 10}, ...
    'eps', 1e-8};




gpcg_std_opts1={...
    'descr', 'gpcg', ...
    'longdescr', 'gpcg/basic', ...
    'type', 'gpcg', ...
    'solve_opts', {'div_b', 1, 'div_op', 1}, ...
    'eps', 5e-6};

gpcg_dyn_opts={...
    'descr', 'gpcg dyn', ...
    'longdescr', 'gpcg dyn/basic', ...
    'type', 'gpcg', ...
    'dyn', true, ...
    'eps', 1e-8 };

gpcg_inside_opts={...
    'descr', 'gpcg dyn inside', ...
    'longdescr', 'gpcg dyn/inside', ...
    'type', 'gpcg', ...
    'prec_strat', {'inside'}, ...
    'dyn', true, ...
    'solve_opts', {'div_b', 10, 'div_op', 10}, ...
    'eps', 1e-8};

%ilu_setup=  {'type', 'ilutp', 'droptol', 2e-2, 'milu', 'row', 'udiag', 1 };
%opts{end+1}=varargin2options( {'longdescr', 'ilutp 2 row prec tensor solver', ...
%    'dyn', true, 'prec_strat', {'ilu', ilu_setup}, 'descr', 'dyn_ilutp'} );
ilu_options={'type', 'ilutp', 'droptol', 2e-2, 'milu', 'row', 'udiag', 1 };
gpcg_ilu_opts={...
    'descr', 'gpcg dyn ilu', ...
    'longdescr', 'gpcg dyn/ilu', ...
    'type', 'gpcg', ...
    'prec_strat', {'ilu', ilu_options}, ...
    'dyn', true, ...
    'solve_opts', {'div_b', 10, 'div_op', 10}, ...
    'eps', 1e-8};


optlist={gsi_std_opts1, gsi_dyn_opts, gsi_inside_opts, gsi_ilu_opts}%, ...
    %gpcg_std_opts1, gpcg_dyn_opts, gpcg_inside_opts, gpcg_ilu_opts};
opts={};
for def_opts=optlist
    opts{end+1}=varargin2options( def_opts{1} );
end
