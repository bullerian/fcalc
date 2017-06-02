nputString=$1
inputScale=$2
mantisSepr="."
readonly zero=0

if [[ ${#inputString} -lt 3 ]]; then
	echo "Specify equation string in form \"A / B\"" >&2;
	exit 1
fi

divident=${inputString%% *}
divisor=${inputString##* }
scale=${inputScale:=2}
dvtNum=0
dvrNum=0

if [[ $dividend == $divisor ]]; then
	echo "1"
	exit 0
elif [ ${divisor/$mantisSepr} -eq $zero ]; then
	echo "Division by zero is forbidden!" >&2
	exit 2
elif [ ${divident/$mantisSepr} -eq $zero ]; then
	echo "0"
	exit 0
fi

tmp=${divident/@(#*.)}
dvtNum=${#tmp}
divident=${divident/./''}

if [ $dvtNum -lt $scale ]; then
	tmp=$(($scale - $dvtNum))
	echo "Scale delta "$tmp
	while [ $tmp -ne 0 ]; do
		divident=${divident}0
		((tmp--))
	done


	((dvtNum=scale))
fi

tmp=${divisor/#*.}
dvrNum=${#tmp}
divisor=${divisor/./''}

echo $divident $divisor

tmp=$(( $divident / $divisor ))
tmp=${tmp:0:$scale}.${tmp:0:$scale}
