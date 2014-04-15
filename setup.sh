#!/bin/bash
if [[ $(uname) == "Darwin" ]]; then
  echo "OSX"
  Qt5Prefix=/Applications/Qt/5.2.1/clang_64/lib/cmake/Qt5
  export ADDITIONAL_OPTIONS='-D"PYTHON_EXECUTABLE=/opt/local/bin/python3.4" \
         -D"PYTHON_INCLUDE_DIR=/opt/local/Library/Frameworks/Python.framework/Versions/3.4/include/python3.4m" \
         -D"PYTHON_LIBRARY=/opt/local/Library/Frameworks/Python.framework/Versions/3.4/lib/libpython3.4.dylib" '
fi
if [[ $(uname) == "Linux" ]]; then
  Qt5Prefix="/usr/lib/x86_64-linux-gnu/cmake/Qt5"
sudo apt-get install clang g++ make vim cmake-gui python-sip python-sip-dev libpng12-dev libjpeg-dev zlib1g-dev zlib-bin zlibc libfreetype6 libfreetype6-dev libglew1.8 libxml2-dev terminator qt5-default libqt5xmlpatterns5 libqt5xmlpatterns5-dev libqt5webkit5 libqt5webkit5-dev libqt5widgets5 libqt5xml5 libqt5opengl5 libqt5network5 libqt5gui5 qtquick1-5-dev qttools5-dev-tools qt5declarative5-dev libqt5webkit5-qmlwebkitplugin qtlocation5-dev libqt5location5 libqt5sensors5 qtsensors5-dev libpython-dev python-dev python-sphinx doxygen binutils-dev
fi

mkdir -p ~/workspace/tulip/build/x64/debug/Qt5
cd ~/workspace/tulip
svn checkout svn://svn.code.sf.net/p/auber/code/tulip ./tulip-src
cd tulip-src

Qt5Prefix="/usr/lib/x86_64-linux-gnu/cmake/Qt5"
cmake ~/workspace/tulip/build/x64/debug/Qt5/ ~/workspace/tulip/tulip-src/tulip -G "Unix Makefiles" \
	-D"USE_QT5_IF_INSTALLED=true" \
	-D"CMAKE_CXX_FLAGS=-std=c++11" \
	-D"CMAKE_INSTALL_PREFIX=~/workspace/tulip/build/x64/debug/Qt5/install" \
	-D"CMAKE_BUILD_TYPE=Debug"

if [[ -z $PYTHONPATH ]]; then
	echo 'export PYTHONPATH="~/workspace/tulip/build/x64/debug/Qt5/install/lib/python"' >> ~/.bashrc
fi
if [[ -z $LD_LIBRARY_PATH ]]; then
	echo 'export LD_LIBRARY_PATH="~/workspace/tulip/build/x64/debug/Qt5/install/lib"' >> ~/.bashrc
fi
