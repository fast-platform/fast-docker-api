function run_or_exit {
	MSG=$1; CMD=$2;
	echo $MSG;
	echo "$CMD";
	$CMD
	if [ $? -ne 0 ]; then
		echo "Failed with exit status: $?"
		exit 1
	fi
	echo "----"
}

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color