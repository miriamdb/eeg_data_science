function param_paths = create_dirs(param_paths)

make_path(param_paths.out)

param_paths.pre_dir = [param_paths.out param_paths.pre];
param_paths.ica_dir  = [param_paths.out param_paths.ica];
param_paths.clean_dir  = [param_paths.out param_paths.clean];

make_path(param_paths.pre_dir)
make_path(param_paths.ica_dir)
make_path(param_paths.clean_dir)



end 