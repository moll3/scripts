#Build by lone-wind
#默认容器路径
default_path () {
    save_path=/mnt/mmcblk2p4
}
#功能选择
work_choose () {
    echo -e '\e[92m请选择功能或退出\e[0m'
    echo "0 --- 退出 Adg脚本"
    echo "1 --- 设定容器路径"
    echo "2 --- 修改工作目录"
    echo "3 --- 操作 ADG容器"
    read -p "请输入数字[0-3],回车确认 " work_num
    case $work_num in
        0)
            echo -e '\e[91m退出脚本，结束操作\e[0m'
            exit;
            ;;
        1)
            echo -e '\e[92m已选择：设定容器路径\e[0m'
            docker_path
            ;;
        2)
            echo -e '\e[92m已选择：修改工作目录\e[0m'
            change_path
            ;;
        3)
            echo -e '\e[92m已选择：操作 ADG容器\e[0m'
            adg_choose
            ;;
        *)
            echo -e '\e[91m非法输入,请输入数字[0-3]\e[0m'
            ;;
    esac
    work_choose
}
#设定容器路径
docker_path () {
    echo -e '\e[92m当前设定的容器路径为\e[0m' ${save_path}
    echo -e '\e[91m如果不使用或修改默认容器路径，则每次运行脚本，都需要设定容器路径\e[0m'
    echo "0 --- 返回上级菜单"
    echo "1 --- 使用当前路径作为容器路径"
    echo "2 --- 手动设定容器路径"
    read -p "请输入数字[0-2],回车确认 " docker_num
    case $docker_num in
        0)
            work_choose
            ;;
        1)
            echo -e '\e[92m已选择：使用当前路径\e[0m' ${PWD}
            save_path=${PWD}
            ;;
        2)
            echo -e '\e[92m已选择：手动设定路径\e[0m'
            df -h && echo -e '\e[92m请选择足够存放容器的路径\e[0m'
            read -p "请输入带有“/”的绝对路径回车 " save_path
            ;;
        *)
            echo -e '\e[91m非法输入,请输入数字[0-2]\e[0m'
            docker_path
            ;;
    esac
}
#修改工作目录
change_path () {
    echo -e '\e[92m请选择需要修改的目录\e[0m'
    echo "0 --- 返回上级菜单"
    echo "1 --- 修改目录 1"
    echo "2 --- 修改目录 2"
    read -p "请输入数字[0-2],回车确认 " path_num
    case $path_num in
        0)
            work_choose
            ;;
        [1-2])
            echo -e '\e[92m已选择：修改目录 \e[0m' $path_num
            files_path
            ;;
        *)
            echo -e '\e[91m非法输入,请输入数字[0-2]\e[0m'
            change_path
            ;;
    esac
}
#设定工作路径
files_path () {
    echo "0 --- 返回上级菜单"
    echo "1 --- 创建工作目录"
    echo "2 --- 导出工作目录"
    echo "3 --- 删除工作目录"
    read -p "请输入数字[0-3],回车确认 " files_num
    case $files_num in
        0)
            change_path
            ;;
        1)
            echo -e '\e[92m已选择：创建工作目录\e[0m'
            files_judge
            ;;
        2)
            echo -e '\e[92m已选择：导出工作目录\e[0m'
            files_export
            ;;
        3)
            echo -e '\e[91m已选择：删除工作目录\e[0m'
            files_del
            ;;
        *)
            echo -e '\e[91m非法输入,请输入数字[0-2]\e[0m'
            ;;
    esac
    files_path
}
#判断工作目录
files_judge () {
    if [ -d "${save_path}/adg/workdir${path_num}" ]; then
        echo -e '\e[91m当前容器目录下已存在Adg工作目录\e[0m' ${path_num}
        files_path
    else
        echo -e '\e[92mAdg工作目录不存在 开始创建\e[0m'
        build_files
    fi
}
#创建工作目录
build_files () {
    echo -e '\e[92m开始创建Adg工作目录\e[0m' ${path_num}
    if [ ! -d ${save_path}/adg ]; then
        mkdir ${save_path}/adg
    fi
    mkdir ${save_path}/adg/workdir${path_num} && mkdir ${save_path}/adg/confdir${path_num}
    echo -e '\e[91m请检查文件夹是否创建完毕\e[0m'
    ls ${save_path}/adg/
}
#导出工作目录
files_export () {
    echo -e '\e[92m请选择足够存放文件的导出路径\e[0m'
    du -s ${save_path}/adg/ && df -h
    read -p "请输入带有“/”的导出路径并回车 " export_path
    read -p "是否确认导出? [Y/N] " export_choose
    case $export_choose in
        [yY][eE][sS]|[yY])
            echo -e '\e[92m已确认导出\e[0m'
            export_copy
            ;;
        [nN][oO]|[nN])
            echo -e '\e[91m已取消导出\e[0m'
            files_path
            ;;
        *)
            echo -e '\e[91m请输入[Y/N]进行确认\e[0m'
            files_export
            ;;
    esac
}
#导出工作目录
export_copy () {
    echo -e '\e[92m开始导出Adg工作目录\e[0m' ${path_num}
    if [ ! -d ${export_path}/adg ]; then
        mkdir ${export_path}/adg
    fi
    cp -r ${save_path}/adg/workdir${path_num} ${export_path}/adg
    cp -r ${save_path}/adg/confdir${path_num} ${export_path}/adg
    echo -e '\e[91m请检查文件夹是否导出完毕\e[0m'
    ls ${export_path}/adg/
}
#删除工作目录
files_del () {
    echo -e '\e[91m删除目录 Adg配置将会丢失 请谨慎操作\e[0m'
    read -p "是否确认删除? [Y/N] " del_choose
    case $del_choose in
        [yY][eE][sS]|[yY])
            echo -e '\e[92m已确认删除\e[0m'
            rm -rf ${save_path}/adg/workdir${path_num}
            rm -rf ${save_path}/adg/confdir${path_num}
            ;;
        [nN][oO]|[nN])
            echo -e '\e[91m已取消删除\e[0m'
            ;;
        *)
            echo -e '\e[91m请输入[Y/N]进行确认\e[0m'
            files_del
            ;;
    esac
}
#Adg容器选择
adg_choose () {
    echo "0 --- 返回上级菜单"
    echo "1 --- Adguradhome 1"
    echo "2 --- Adguradhome 2"
    read -p "请输入数字[0-2],回车确认 " adg_num
    case $adg_num in
        0)
            work_choose
            ;;
        [1-2])
            echo -e '\e[92m已选择：Adg容器 \e[0m' $adg_num
            adg_function
            ;;
        *)
            echo -e '\e[91m非法输入,请输入数字[0-2]\e[0m'
            adg_choose
            ;;
    esac
}
#Adg功能选择
adg_function () {
    echo "0 --- 返回上级菜单"
    echo "1 --- 创建/更新 Adg容器"
    echo "2 --- 启动 Adg容器"
    echo "3 --- 停止 Adg容器"
    echo "4 --- 删除 Adg容器"
    echo "5 --- 查看 Adg容器状态"
    echo "6 --- 查看 Adg容器日志"
    read -p "请输入数字[0-6],回车确认 " function_num
    case $function_num in
        0)
            adg_choose
            ;;
        1)
            echo -e '\e[92m已选择：创建/更新 Adg容器\e[0m'${adg_num}
            build_adg
            ;;
        2)
            echo -e '\e[92m已选择：启动 Adg容器\e[0m'${adg_num}
            docker start adguardhome${adg_num}
            ;;
        3)
            echo -e '\e[92m已选择：停止 Adg容器\e[0m'${adg_num}
            docker stop adguardhome${adg_num}
            ;;
        4)
            echo -e '\e[92m已选择：删除 Adg容器\e[0m'${adg_num}
            del_adg
            ;;
        5)
            echo -e '\e[92m已选择：查看 Adg容器状态\e[0m'
            docker ps -a -f "name=adguardhome${adg_num}"
            ;;
        6)
            echo -e '\e[92m已选择：查看 Adg容器日志\e[0m'
            docker logs -f "adguardhome${adg_num}"
            ;;
        *)
            echo -e '\e[91m非法输入,请输入数字[0-4]\e[0m'
            ;;
    esac
    adg_function
}
#创建/更新 Adg容器
build_adg () {
    del_adg
    echo -e '\e[92m开始创建/更新 Adg容器\e[0m'${adg_num}
    docker run --name adguardhome${adg_num} \
        -v ${save_path}/adg/workdir${adg_num}:/opt/adguardhome/work \
        -v ${save_path}/adg/confdir${adg_num}:/opt/adguardhome/conf \
        --restart=always \
        --net=host \
        -d adguard/adguardhome:latest
    echo -e '\e[91m请设置/完善该容器后，再操作另一容器\e[0m'
    echo -e '\e[92m首次设置，使用浏览器访问 ip:3000\e[0m'
}
#删除 Adg容器
del_adg () {
    echo -e '\e[91m开始删除 Adg容器\e[0m'${adg_num}
    docker stop adguardhome${adg_num}
    docker rm adguardhome${adg_num}
    docker pull  adguard/adguardhome:latest
    docker image prune -f
}
#start
default_path
work_choose
