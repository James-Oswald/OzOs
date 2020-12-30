curDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $curDir/..
/mnt/c/Windows/System32/cmd.exe /C taskkill /IM qemu-system-i386.exe /F
echo "running QEMU"
curDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $curDir/..
source tools/config.cfg
nohup $($QEMUPath/qemu-system-i386.exe -s -S -cdrom build/$OsName.iso) & 
