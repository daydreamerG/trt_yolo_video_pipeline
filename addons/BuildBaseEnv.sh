#!/bin/bash
#用于初始化基础三方库环境，默认装在系统环境下，建议在容器中安装

unzip opencv_contrib-4.8.0.zip
unzip opencv-4.8.0.zip
tar -zxvf x264-master.tar.gz
tar -zxvf ffmpeg-5.1.2.tar.gz


# 安装opencv
cd ./opencv-4.8.0 \
  && mkdir -p build \
  && cd build \
  && cmake  -D CMAKE_BUILD_TYPE=Release  \
            -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-4.8.0/modules .. \
  && make -j10 \
  && make install \
  && cd ../../

# 安装x264
cd ./x264-master \
  && ./configure --enable-shared \
  && make -j10 \
  && make install \
  && cd ../

# 安装ffmpeg
cd ./ffmpeg-5.1.2 \
  && export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig \
  && ./configure --enable-gpl --enable-libx264 \
                 --enable-nonfree --enable-shared \
                 --disable-static \
  && make -j10 \
  && make install \
  && cd ../


# 安装ffmpeg支持nvidia硬件加速
# 查看对应的nvidia驱动版本和显卡型号，然后去nvidia官网下载对应的nv-codec-headers，有的计算卡卡不带编解码器就不支持硬件加速
# 1、安装nv-codec-headers
# 2、安装ffmpeg

# git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
# cd ./nv-codec-headers \
#   && make -j10 \
#   && make install \
#   && cd ../


##  此处可能需要手动修改cuda动态库应用的路径

# cd ./ffmpeg-5.1.2 \
#   && export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig \
#   && ./configure --enable-gpl --enable-libx264 \
#                  --enable-nonfree --enable-shared \
#                  --disable-static \
#                  --enable-cuda --enable-cuvid --enable-nvenc \
#                  --enable-libnpp --extra-cflags=-I/usr/local/cuda/include \
#                  --extra-ldflags=-L/usr/local/cuda/lib64 \
#   && make -j10 \
#   && make install \
#   && cd ../


rm -rf ./opencv-4.8.0
rm -rf ./opencv_contrib-4.8.0
rm -rf ./x264-master
rm -rf ./ffmpeg-5.1.2


