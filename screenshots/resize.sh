#!/bin/sh

# settings ==========

# src file name
fileNamePrefix="ss"

# dest directory name
orgDir="./original/"
destDir="./iOS/"
destDir4_7="./iOS/4.7inch/"
destDir4="./iOS/4inch/"
destDir3_5="./iOS/3.5inch/"
destDir5_5="./iOS/5.5inch/"
destDirIpad="./iOS/ipad/"

destDirAndroid="./Android/"
destDirAndroid180x120="./Android/180x120/"
destDirAndroid320x480="./Android/320x480/"
destDirAndroid480x800="./Android/480x800/"
destDirAndroid480x854="./Android/480x854/"
destDirAndroid800x1280="./Android/800x1280/"


# ====================

# create dest directory
# mkdir $orgDir

mkdir $destDir
mkdir $destDir4_7
mkdir $destDir4
mkdir $destDir3_5
mkdir $destDir5_5
mkdir $destDirIpad

mkdir $destDirAndroid
mkdir $destDirAndroid180x120
mkdir $destDirAndroid320x480
mkdir $destDirAndroid480x800
mkdir $destDirAndroid480x854
mkdir $destDirAndroid800x1280

#################################
# loop for iOS 5.5inch
#################################
echo "5.5inch"
for i in 1 2 3 4 5
do
destFilePath=$destDir5_5$fileNamePrefix$i".png"
echo $destFilePath

#リサイズ&白埋め（白の画像を重ねるcomposite）
new_size="1242x2208"
convert $orgDir$fileNamePrefix$i".png" -resize $new_size\> -size $new_size xc:white +swap -gravity center -composite $destFilePath

done

#################################
# loop for iOS 4.7inch
#################################
echo "4.7inch"
for i in 1 2 3 4 5
do
  destFilePath=$destDir4_7$fileNamePrefix$i".png"
  echo $destFilePath

#リサイズ&白埋め（白の画像を重ねるcomposite）
new_size="750x1334"
convert $orgDir$fileNamePrefix$i".png" -resize $new_size\> -size $new_size xc:white +swap -gravity center -composite $destFilePath

done

#################################
# loop for iOS 4inch
#################################
echo "4inch"
for i in 1 2 3 4 5
do
  destFilePath=$destDir4$fileNamePrefix$i".png"
  echo $destFilePath

#リサイズ&白埋め（白の画像を重ねるcomposite）
new_size="640x1136"
convert $orgDir$fileNamePrefix$i".png" -resize $new_size\> -size $new_size xc:white +swap -gravity center -composite $destFilePath

done

#################################
# loop for iOS 3.5inch
#################################
echo "iOS 3.5inch"
for i in 1 2 3 4 5
do
  destFilePath=$destDir3_5$fileNamePrefix$i".png"
  echo $destFilePath
#リサイズ&白埋め（白の画像を重ねるcomposite）
new_size="640x960"
convert $orgDir$fileNamePrefix$i".png" -resize $new_size\> -size $new_size xc:white +swap -gravity center -composite $destFilePath

done

#################################
# loop for iOS iPad
#################################
echo "iOS iPad"
for i in 1 2 3 4 5
do
destFilePath=$destDirIpad$fileNamePrefix$i".png"
echo $destFilePath
#リサイズ&白埋め（白の画像を重ねるcomposite）
new_size="768x1024"
convert $orgDir$fileNamePrefix$i".png" -resize $new_size\> -size $new_size xc:white +swap -gravity center -composite $destFilePath

done

#################################
# loop for Android 180x120
#################################
#echo "Android 180x120"
#for i in 1 2 3 4 5
#do
#destFilePath=$destDirAndroid180x120$fileNamePrefix$i".png"
#echo $destFilePath
#リサイズ&白埋め（白の画像を重ねるcomposite）
#new_size="180x120"
#convert $orgDir$fileNamePrefix$i".png" -resize $new_size\> -size $new_size xc:white +swap -gravity center -composite $destFilePath
#done

#################################
# loop for Android 320x480
#################################
echo "Android 320x480"
for i in 1 2 3 4 5
do
destFilePath=$destDirAndroid320x480$fileNamePrefix$i".png"
echo $destFilePath
#リサイズ&白埋め（白の画像を重ねるcomposite）
new_size="320x480"
convert $orgDir$fileNamePrefix$i".png" -resize $new_size\> -size $new_size xc:white +swap -gravity center -composite $destFilePath

done

#################################
# loop for Android 480x800
#################################
echo "Android 480x800"
for i in 1 2 3 4 5
do
destFilePath=$destDirAndroid480x800$fileNamePrefix$i".png"
echo $destFilePath
#リサイズ&白埋め（白の画像を重ねるcomposite）
new_size="480x800"
convert $orgDir$fileNamePrefix$i".png" -resize $new_size\> -size $new_size xc:white +swap -gravity center -composite $destFilePath
done

#################################
# loop for Android 480x854
#################################
echo "Android 480x854"
for i in 1 2 3 4 5
do
destFilePath=$destDirAndroid480x854$fileNamePrefix$i".png"
echo $destFilePath
#リサイズ&白埋め（白の画像を重ねるcomposite）
new_size="480x854"
convert $orgDir$fileNamePrefix$i".png" -resize $new_size\> -size $new_size xc:white +swap -gravity center -composite $destFilePath
done

#################################
# loop for Android 800x1280
#################################
echo "Android 800x1280"
for i in 1 2 3 4 5
do
destFilePath=$destDirAndroid800x1280$fileNamePrefix$i".png"
echo $destFilePath
#リサイズ&白埋め（白の画像を重ねるcomposite）
new_size="800x1280"
convert $orgDir$fileNamePrefix$i".png" -resize $new_size\> -size $new_size xc:white +swap -gravity center -composite $destFilePath
done
