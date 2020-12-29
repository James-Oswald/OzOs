#if on windows, this will kill the previous QEMU instance
curDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $curDir/..
/mnt/c/Windows/System32/cmd.exe /C taskkill /IM qemu-system-i386.exe /F
./tools/build.sh
./tools/run.sh