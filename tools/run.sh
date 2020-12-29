curDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $curDir/..
source tools/config.cfg
$QEMUPath/qemu-system-i386.exe -cdrom build/$OsName.iso &
    exit 0