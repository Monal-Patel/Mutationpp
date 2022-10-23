#!/bin/bash
############### Detect OS
platform='unknown'
if [[ "$OSTYPE" == "linux-gnu" ]]; then
        platform='linux'
        echo LinuxOS
elif [[ "$OSTYPE" == "darwin"* ]]; then
        platform='mac'
        echo MacOSX $OSTYPE
elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
        platform='cygwin'
        echo CYGWIN/Linux emulator
fi

############### check if cmake installed
cmd=cmake
if [ -x "$(command -v "$cmd")" ]; then
        echo "$cmd is in .. $PATH"
else
        echo "ERROR $cmd not found"
        exit
fi
############### set-up environment variables
file=$HOME/.bashrc
if [ -f "$file" ]
then
        echo "set-up variables in .. $file"

				echo "export MPPDIR=$PWD" >> $file
        echo 'export MPP_DIRECTORY=$MPPDIR' >> $file
        echo 'export MPP_DATA_DIRECTORY=$MPPDIR/data'>> $file
        echo 'export PATH=$MPPDIR/install/bin:$PATH' >> $file
        if [[ $platform == 'mac' ]]; then
                echo set-up $platform
                echo 'export DYLD_LIBRARY_PATH=$MPPDIR/install/lib' >> $file
        else
                echo set-up $platform
                echo 'export LD_LIBRARY_PATH=$MPPDIR/install/lib:$PATH'>> $file
        fi
        source ~/.bashrc
else
    echo "$file not found"
    exit 2
fi
echo -e "\\033[1;34m  MUTATIONPP: ..... Environment set  \\033[0m"
#################  install the code  (Fortran option cmake)
mkdir -p $MPPDIR/build
cd $MPPDIR/build
cmake -DBUILD_FORTRAN_WRAPPER=ON -DCMAKE_CXX_COMPILER=g++ -DCMAKE_INSTALL_PREFIX:PATH=$(realpath ../install) ..
make -j 4 install
###################
echo -e "\\033[1;32m  MUTATIONPP: Installed  Locally \\033[0m"
