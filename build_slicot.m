%=============================================================================
% Copyright (c) 2016-2019 Allan CORNET (Nelson)
%=============================================================================
% LICENCE_BLOCK_BEGIN
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 2 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http:%www.gnu.org/licenses/>.
% LICENCE_BLOCK_END
%=============================================================================
configure_compiler = false;
if ispc()
  configure_compiler = true;
  configuremsvc();
end
%=============================================================================
this_path = nfilename('fullpathext');
this_path = fileparts(this_path, 'path');
%=============================================================================
fortran_files = dir([this_path, '/fortran/*.f']);
destination_c = [this_path, '/c'];
if ~isdir(destination_c)
  mkdir(destination_c);
end
%=============================================================================
for k = 1:length(fortran_files)
  src = [this_path, '/fortran/', fortran_files(k).name];
  f2c(src, destination_c);
end
%=============================================================================
destinationdir = [this_path, '/bin/'];
if ~isdir(destinationdir)
  mkdir(destinationdir);
end
%=============================================================================
c_files_info = dir([this_path, '/c/*.c']);
c_files = {};
for k = 1:length(c_files_info)
  c_files = [c_files; [this_path, '/c/', c_files_info(k).name]];
end
currentpath = fileparts(nfilename('fullpathext'));
%=============================================================================
if ispc()
  external_libs = {[modulepath(nelsonroot(),'elementary_functions','bin'), '/libnlsblaslapack']; ...
  [modulepath(nelsonroot(),'f2c','bin'), '/libnlsF2C']};
else
  external_libs = {[modulepath(nelsonroot(),'f2c','bin'), '/libnlsF2C']; ...
  'blas'; 'lapack'};
end
[status, message] = dlgeneratemake(destinationdir, ...
'libslicot', ...
c_files, ...
[modulepath('f2c'), '/src/include'], [], ...
external_libs);
if ~status
  error(message);
end
%=============================================================================
[status, message] = dlmake(destinationdir);
if configure_compiler
  removecompilerconf();
end
if ~status
  error(message);
  exit(1);
else
  try
    copyfile([destinationdir, 'libslicot', getdynlibext()], [modulepath(nelsonroot,'core','bin'), '/libslicot', getdynlibext()]);
  catch
    exit(1);
  end
  exit();
end
%=============================================================================
