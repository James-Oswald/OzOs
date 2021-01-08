
curDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $curDir/..
rm -r docs/*
doxygen -d Preprocessor tools/doxy.cfg 