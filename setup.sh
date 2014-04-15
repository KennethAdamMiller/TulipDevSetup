#!/bin/bash
qtVersion=$1
if [[ $(uname) == "Darwin" ]]; then
  export Qt5Prefix="/Applications/Qt/$qtVersion/clang_64/lib/cmake/Qt5"
  export ADDITIONAL_OPTIONS="-DPYTHON_EXECUTABLE=/opt/local/bin/python3.4 -DPYTHON_INCLUDE_DIR=/opt/local/Library/Frameworks/Python.framework/Versions/3.4/include/python3.4m -DPYTHON_LIBRARY=/opt/local/Library/Frameworks/Python.framework/Versions/3.4/lib/libpython3.4.dylib -DQt5Widgets_DIR=$(echo $Qt5Prefix)Widgets -DQt5OpenGL_DIR=$(echo $Qt5Prefix)OpenGL -DQt5Xml_DIR=$(echo $Qt5Prefix)Xml -DQt5XmlPatterns_DIR=$(echo $Qt5Prefix)XmlPatterns -DQt5Network_DIR=$(echo $Qt5Prefix)Network -DQt5WebKit_DIR=$(echo $Qt5Prefix)WebKit -DQt5WebKitWidgets_DIR=$(echo $Qt5Prefix)WebKitWidgets"
fi

if [[ $(uname) == "Linux" ]]; then
  Qt5Prefix="/usr/lib/x86_64-linux-gnu/cmake/Qt5"
sudo apt-get install clang g++ make vim cmake-gui python-sip python-sip-dev libpng12-dev libjpeg-dev zlib1g-dev zlib-bin zlibc libfreetype6 libfreetype6-dev libglew1.8 libxml2-dev terminator qt5-default libqt5xmlpatterns5 libqt5xmlpatterns5-dev libqt5webkit5 libqt5webkit5-dev libqt5widgets5 libqt5xml5 libqt5opengl5 libqt5network5 libqt5gui5 qtquick1-5-dev qttools5-dev-tools qt5declarative5-dev libqt5webkit5-qmlwebkitplugin qtlocation5-dev libqt5location5 libqt5sensors5 qtsensors5-dev libpython-dev python-dev python-sphinx doxygen binutils-dev
fi

if [[ -z $1 ]]; then
    printf "\n\nUsage: ./setup.sh <Qt Version>\nAs in 5.2.1 or so \n\n"
    exit -1
fi

installPrefix="$HOME/workspace/tulip/build/x64/debug/Qt/$qtVersion/install"
echo "installPrefix: " $installPrefix $1 
mkdir -p $installPrefix
cd $HOME/workspace/tulip
if [[ -d ./tulip-src ]]; then
  printf "\n\nrepo exists!\n\n"
  cd tulip-src
  svn up
  cd ..
else
  svn checkout svn://svn.code.sf.net/p/auber/code/tulip ./tulip-src
fi

cd $installPrefix/..
cmake $installPrefix/.. $HOME/workspace/tulip/tulip-src/ -G "Unix Makefiles" \
	-D"USE_QT5_IF_INSTALLED=true" \
	-D"CMAKE_CXX_FLAGS=-std=c++11" \
	-D"CMAKE_INSTALL_PREFIX=$installPrefix" \
	-D"CMAKE_BUILD_TYPE=Debug" \
        $ADDITIONAL_OPTIONS

cd $installPrefix/..
make clean && make -j9 install
echo "export PYTHONPATH=$installPrefix/lib/python"
echo "export LD_LIBRARY_PATH=$installPrefix"
if [[ -z $PYTHONPATH ]]; then
	echo "export PYTHONPATH=\"$installPrefix/lib/python\"" >> ~/.bashrc
fi
if [[ -z $LD_LIBRARY_PATH ]]; then
	echo "export LD_LIBRARY_PATH=\"$installPrefix/install/lib\"" >> ~/.bashrc
fi
