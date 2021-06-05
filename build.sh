#! /bin/bash

workspace=$1
hostname=$(hostname)
branch=$3

echo "Directory: $workspace"
echo "Machine: $hostname"
echo "Branch name: $branch"

echo "Branch: $3"

# Make a directory in /tmp/openfpm_data

mkdir /tmp/openfpm_io
mv * .[^.]* /tmp/openfpm_io
mv /tmp/openfpm_io openfpm_io

git clone git@git.mpi-cbg.de:openfpm/openfpm_devices.git openfpm_devices
cd openfpm_devices
git checkout develop
cd ..
git clone git@git.mpi-cbg.de:openfpm/openfpm_data.git openfpm_data
cd openfpm_data
git checkout develop
cd ..
git clone git@git.mpi-cbg.de:openfpm/openfpm_pdata.git openfpm_pdata
cd openfpm_pdata
git checkout develop
cd ..
git clone git@git.mpi-cbg.de:openfpm/openfpm_vcluster.git openfpm_vcluster
cd openfpm_vcluster
git checkout develop
cd ..

cd "$1/openfpm_io"

#rm -rf $HOME/openfpm_dependencies/openfpm_io/$branch/MPI
#rm -rf $HOME/openfpm_dependencies/openfpm_io/$branch/HDF5
#rm -rf $HOME/openfpm_dependencies/openfpm_io/$branch/BOOST

if [ x"$hostname" == x"cifarm-centos-node.mpi-cbg.de"  ]; then
	source /opt/rh/devtoolset-7/enable
        ./install_CMAKE_on_CI.sh $HOME/openfpm_dependencies/openfpm_pdata/$branch/
        export PATH="$HOME/openfpm_dependencies/openfpm_pdata/$branch/CMAKE/bin:$PATH"
        ./install_MPI_mpich.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
	export PATH="$HOME/openfpm_dependencies/openfpm_io/$branch/MPI/bin/:$PATH"
        ./install_BOOST.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
	./install_HDF5.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
	./install_LIBHILBERT.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
        ./install_VCDEVEL.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4 gcc g++
	./install_CATALYST.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
	./install_ADIOS2.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
	./install_OPENPMD.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
fi

if [ x"$hostname" == x"cifarm-ubuntu-node"  ]; then
        ./install_CMAKE_on_CI.sh $HOME/openfpm_dependencies/openfpm_pdata/$branch/
        export PATH="$HOME/openfpm_dependencies/openfpm_pdata/$branch/CMAKE/bin:$PATH"
        ./install_MPI_mpich.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
	export PATH="/opt/bin:$HOME/openfpm_dependencies/openfpm_io/$branch/MPI/bin/:$PATH"
	./install_BOOST.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
	./install_HDF5.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
        ./install_LIBHILBERT.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
        ./install_VCDEVEL.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4 gcc g++
        ./install_CATALYST.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
        ./install_ADIOS2.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
        ./install_OPENPMD.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
fi

if [ x"$hostname" == x"cifarm-mac-node.mpi-cbg.de"  ]; then
        ./install_CMAKE_on_CI.sh $HOME/openfpm_dependencies/openfpm_pdata/$branch/
        export PATH="$HOME/openfpm_dependencies/openfpm_pdata/$branch/CMAKE/bin:$PATH"
        export PATH="/usr/local/bin:$PATH"
        ./install_MPI_mpich.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
	export PATH="$HOME/openfpm_dependencies/openfpm_io/$branch/MPI/bin/:$PATH"
	./install_BOOST.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
	./install_HDF5.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
        ./install_LIBHILBERT.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
        ./install_VCDEVEL.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4 gcc g++
        ./install_CATALYST.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
        ./install_ADIOS2.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
        ./install_OPENPMD.sh $HOME/openfpm_dependencies/openfpm_io/$branch/ 4
fi

# Go in the right branch

echo "Compiling on $2"

sh ./autogen.sh
sh ./configure CXX=mpic++ --with-vcdevel=$HOME/openfpm_dependencies/openfpm_io/$branch/VCDEVEL --with-libhilbert=$HOME/openfpm_dependencies/openfpm_io/$branch/LIBHILBERT --with-hdf5=$HOME/openfpm_dependencies/openfpm_io/$branch/HDF5 --with-boost=$HOME/openfpm_dependencies/openfpm_io/$branch/BOOST --with-openpmd=$HOME/openfpm_dependencies/openfpm_io/$branch/OPENPMD --with-catalyst=$HOME/openfpm_dependencies/openfpm_io/$branch/CATALYST --with-adios2=$HOME/openfpm_dependencies/openfpm_io/$branch/ADIOS2   --with-pdata=../../openfpm_pdata/ --enable-cuda-on-cpu

make VERBOSE=1 -j 4


