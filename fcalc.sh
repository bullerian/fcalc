#! /bin/bash 

inputEqv=$1
inputScale=$2
mantisSepr="."

if [[ ${#inputEqv} -lt 3 ]]; then
	echo -e "Specify equation string in form \"A/B\"\nSeparate whole and \
fractional part witn '$mantisSepr'" >&2;
	exit 1
fi

dt=${inputEqv%%/*}
dv=${inputEqv##*/}
scale=${inputScale:=2}

# remove mantiss separator
dvInt=${dv/$mantisSepr}
dtInt=${dt/$mantisSepr}

# divident and divisor are equal. Result = 1
if [[ "$dt" == "$dv" ]]; then
	echo "1"
	exit 0

# in case of division by zero
elif [[ $dvInt -eq 0 ]]; then
	echo "Division by zero is undeffined!" >&2
	exit 1

# if divident=0 then result is 0
elif [ $dtInt -eq 0 ]; then
	echo "0"
	exit 0
fi

# return number of digits after separator
function digAftrSepr(){
	numString=$1
	local fraction
	if [[ "$numString" != *$mantisSepr* ]]; then 
		echo 0
	else
	        fraction="${numString/#*.}"
		echo ${#fraction}
	fi
}

# absolute power
dvPow=$(digAftrSepr $dv)
dtPow=$(digAftrSepr $dt)

# in case of division powers substract
delta=$((-dtPow+dvPow))
# absolute result of powers substraction
deltaAbs=${delta/'-'}

pow=$((10**$((delta+scale))))
res=$((10#$dtInt*pow/10#$dvInt))
resLen=${#res}

if [[ $resLen -le $scale ]]; then
	res="$(printf '%*s' $(($scale-$resLen+1)) | tr ' ' 0)"$res
       	resLen=${#res}	
fi
	
echo ${res:0:$((resLen-scale))}$mantisSepr${res:(-scale)}







