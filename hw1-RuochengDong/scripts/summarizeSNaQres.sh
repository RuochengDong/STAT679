#(1)Make a csv file and add column names
echo "analysis","h","CPUtime","Nruns","Nfail","fabs","frel","xabs","xrel","seed","under3450" > ../results/stat679_exercise1-3.csv

#(2)Find the required information in files and output them to csv file Start from log files in log folder
for logfiles in ../log/*.log 
do
	#Root of the file name
	filename=$(basename -s .log ${logfiles})
	analysis=$(echo $filename |sed 's/_.*//') #Get string before "_" ("_snaq")

	#Maximun number of hybridizations allowed:Get the number in this line
	hmax_line=$(grep "hmax = " ${logfiles})
	hmax=${hmax_line//[!0-9]/}

	#Elapsed time:Get the value between ":" and "seconds"
	CPUtime=$(grep -o -P '(?<=: ).*(?= seconds)' ../out/$filename.out)

	#Numbers of run
	Nruns_line=$(grep "BEGIN:" ${logfiles})
	#Get the first number in line "BEGIN: ..."
	Nruns=$(echo $Nruns_line |grep -o -E '[0-9]+' | head -1)

	#Max number of failed proposals:Get the first number in line "max number ..."
	Nfail=$(grep "max number" ${logfiles} |grep -o -E '[0-9]+' | head -1)

	#Tuning parameter "ftolAbs":Get the value between second "=" and ","
	fabs=$(grep "tolerance" ${logfiles}|sed -e 's/\(^.*=\)\(.*\)\(,.*$\)/\2/')

	#Tuning parameter "ftoRel":Get the value between "ftolRel=" and ","
	frel=$(grep "tolerance" ${logfiles}|sed -e 's/\(^.*ftolRel=\)\(.*\)\(, .*$\)/\2/')

	#Tuning parameter "xtolAbs":Get the value after "xtolAbs="
	xabs=$(grep -oP '(?<=xtolAbs=)[0-9]+([.][0-9]+)' ${logfiles})

	#Tuning parameter "xtolRel":Get the value after "xtolRel="
	xrel=$(grep -oP '(?<=xtolRel=)[0-9]+([.][0-9]+)' ${logfiles})

	#Main seed:Get the value after "main seed"
	seed=$(grep -oP '(?<=main seed )[0-9]+' ${logfiles})

	#Number of runs that returned a network with a score (-loglik value) better than (below) 3450
	loglik=$(grep -oP '(?<=-loglik=)[0-9]+' ${logfiles})
	under3450=0
	for number in $loglik
	do
		if [ $((number)) -lt 3450 ]
		then
			((under3450++))
		fi
	done

	#Output rootname, hmax and CPUtime in to csc file
	echo $analysis,$hmax,$CPUtime,$Nruns,$Nfail,$fabs,$frel,$xabs,$xrel,$seed,$under3450 >> ../results/stat679_exercise1-3.csv
done

#(3)Check the csv file
cat ../results/stat679_exercise1-3.csv