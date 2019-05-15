[![GitHub license](https://img.shields.io/badge/license-GPL2-blue.svg)](https://github.com/Nelson-numerical-software/slicot_f2c/blob/master/LICENSE)

# slicot_f2c for Nelson
slicot library using f2c for Nelson

# build
at Nelson's prompt go to this directory and type:

```bash
run('build_slicot.nls');
```


generated dynamic library will be available in bin directory. 

copy it in
 
```bash
modulepath(nelsonroot,'core','bin') 
```