FROM julia:1.9.0-bullseye

ENV JULIA_CPU_TARGET=generic;broadwell;haswell;cascadelake;skylake;skylake-avx512;tigerlake

# RUN apt-get update
# RUN apt-get install -y gdb

RUN useradd -ms /bin/bash app
USER app

ENV HOME=/home/app
WORKDIR $HOME

# RUN julia -t auto -e 'using Pkg; Pkg.add("HTTP"); Pkg.precompile()'

COPY . ./

ENV JULIA_NUM_THREADS=auto
CMD exec julia -e '@show Sys.CPU_NAME; using InteractiveUtils; versioninfo(); include("main-nohttp.jl")'

# CMD exec gdb -batch -ex "run" -ex "bt" --args /usr/local/julia/bin/julia main-nohttp.jl
