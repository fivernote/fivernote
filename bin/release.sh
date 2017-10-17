#!/bin/sh

# release fivernote
PROD_NAME=fivernote

# 当前路径
SP=$(cd "$(dirname "$0")"; pwd)

# tmp path to store fivernote release files
tmp="${HOME}/Desktop/${PROD_NAME}_release"
mkdir -p $tmp

# version
V="v2.5"

##=================================
# 1. 先build 成 3个平台, 2种bit = 6种
##=================================

# cd ~/Documents/Go/package2/src/github.com/fivernote/fivernote/bin
# GOOS=darwin GOARCH=amd64 go build -o fivernote-darwin-amd64 ../app/tmp

cd $SP

# $1 = darwin, linux
# $2 = amd64
function build()
{
	echo build-$1-$2
	if [ $1 = "linux" -o $1 = "darwin" ]
	then
		suffix=""
	else
		suffix=".exe"
	fi
	
	GOOS=$1 GOARCH=$2 go build -o ${PROD_NAME}-$1-$2$suffix ../app/tmp
}

build "linux" "386";
build "linux" "amd64";
build "linux" "arm";

build "windows" "386";
build "windows" "amd64";

# build "darwin" "386";
build "darwin" "amd64";


##======================
# 2. release目录准备工作
##======================
rm -rf $tmp/${PROD_NAME}
mkdir -p $tmp/${PROD_NAME}/app
mkdir -p $tmp/${PROD_NAME}/conf
mkdir -p $tmp/${PROD_NAME}/bin

##==================
# 3. 复制
##==================

cd $SP
cd ../

# bin
cp -r ./bin/src $tmp/${PROD_NAME}/bin/
cp  ./bin/run.bat $tmp/${PROD_NAME}/bin/

# views
cp -r ./app/views $tmp/${PROD_NAME}/app
# 可不要, 源码
#cp -r ./app/service $tmp/${PROD_NAME}/app/service
#cp -r ./app/controllers $tmp/${PROD_NAME}/app/controllers
#cp -r ./app/db $tmp/${PROD_NAME}/app/db
#cp -r ./app/info $tmp/${PROD_NAME}/app/info
#cp -r ./app/lea $tmp/${PROD_NAME}/app/lea

# conf
cp ./conf/app.conf $tmp/${PROD_NAME}/conf/app.conf
cp ./conf/routes $tmp/${PROD_NAME}/conf/routes
# 处理app.conf, 还原配置
cat $tmp/${PROD_NAME}/conf/app.conf | sed 's/db.dbname=fivernote.*#/db.dbname=fivernote #/' > $tmp/${PROD_NAME}/conf/app.conf2 # 不能直接覆盖
rm -rf $tmp/${PROD_NAME}/conf/app.conf
mv $tmp/${PROD_NAME}/conf/app.conf2 $tmp/${PROD_NAME}/conf/app.conf

# others
cp -r ./messages ./public ./mongodb_backup $tmp/${PROD_NAME}/

# delete some files
rm -rf $tmp/${PROD_NAME}/public/tinymce/classes
rm -rf $tmp/${PROD_NAME}/public/upload
mkdir $tmp/${PROD_NAME}/public/upload
rm -rf $tmp/${PROD_NAME}/public/.codekit-cache
rm -rf $tmp/${PROD_NAME}/public/.DS_Store
rm -rf $tmp/${PROD_NAME}/public/config.codekit

# make link
# cd $tmp/${PROD_NAME}/bin
# ln -s ../../../../ ./src/github.com/${PROD_NAME}/${PROD_NAME}

# archieve
# << 'BLOCK

##===========
# 4. 打包
##===========
# $1 = linux
# $2 = 386, amd64

# 创建一个$V的目录存放之
rm -rf $tmp/$V
mkdir $tmp/$V

function tarRelease()
{
	echo tar-$1-$2
	cd $SP
	cd ../
	rm -rf $tmp/${PROD_NAME}/bin/${PROD_NAME}-* # 删除之前的bin文件
	rm -rf $tmp/${PROD_NAME}/bin/run* # 删除之前的run.sh 或 run.bat
	
	if [ $1 = "linux" -o $1 = "darwin" ]
	then
		suffix=""
		if [ $2 = "arm" ]
		then
			cp ./bin/run-arm.sh $tmp/${PROD_NAME}/bin/run.sh
		else
			cp ./bin/run-$1-$2.sh $tmp/${PROD_NAME}/bin/run.sh
		fi
	else
		cp ./bin/run.bat $tmp/${PROD_NAME}/bin/
		suffix=".exe"
	fi
	
	cp ./bin/${PROD_NAME}-$1-$2$suffix $tmp/${PROD_NAME}/bin/
	rm ./bin/${PROD_NAME}-$1-$2$suffix
	cd $tmp
	tar -cf $tmp/$V/${PROD_NAME}-$1-$2-$V.bin.tar ${PROD_NAME}
	gzip $tmp/$V/${PROD_NAME}-$1-$2-$V.bin.tar
}

tarRelease "linux" "386";
tarRelease "linux" "amd64";
tarRelease "linux" "arm";

tarRelease "windows" "386";
tarRelease "windows" "amd64";

# tarRelease "darwin" "386";
tarRelease "darwin" "amd64";

# BLOCK'
