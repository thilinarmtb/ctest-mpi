# Introduction

This repo contains an example on how to use `CTest` with MPI. Tests used are
located in `tests/` directory.

# Build the tests

You need to have `CMake` and `MPI` installed in your system (in addition to a C
compiler). You can use the `environment.yml` to install `CMake` and `MPI` using
`conda`. Read more about installing `conda` [here](https://conda.io/projects/conda/en/latest/user-guide/install/index.html).

```sh
conda env create -f environment.yml
conda activate ctestmpi
```

Then you can use the `build.sh` script to build the tests.
```sh
./build.sh
```

Do `build.sh --help` to see all the available configuration options.
You can pass additional MPI flags to `CTest` by using the `--custom-mpiflags`
option.
```sh
./build.sh --custom-mpiflags "--oversubscribe"
```

# Run the tests

You can build and run the tests in a single go by doing:
```sh
./build.sh --test
```

# Common issues

- You might have to set the `OMPI_CC` environment variable in case the MPI
  compiler can't find your C compiler.
- Pass `--custom-mpiflags "--use-hwthread-cpus"` or
  `--custom-mpiflags "--oversubscribe"` to `build.sh` if you want to use more
  MPI processes than the physical cores available in your system.
