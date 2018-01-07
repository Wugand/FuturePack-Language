# (first arg) $0 if the be thaim main path
# second arg $1 will be the path to compare

list()
{
	echo "Parent Dir $1 , Sub Dir $2"
	echo ""
	echo "| File | Time diff | Commit |"
	echo "| --- | --- | --- |"
	
	git ls-tree -r --name-only HEAD $1 | while read filename; do
		export fname="$(basename $filename)"
		export sub="$(git log -1 --format="%at" -- $2/$fname)"
		export base="$(git log -1 --format="%at" -- $1/$fname)"
		if [ -z "$sub" ]; then		
			echo "| $2/$fname | *does not exists* | - |"
		else
			if (( $base > $sub )); then
				export timediff="$(expr $base - $sub)"
				if (( $timediff > 120 )); then
					export timediff="$(expr $timediff / 60)"
					if (( $timediff > 120 )); then
						export timediff="$(expr $timediff / 60)"
						if (( $timediff > 48 )); then
							export timediff="$(expr $timediff / 24) days"
						else
							export timediff="$timediff h"
						fi
					else
						export timediff="$timediff min"
					fi	  
				else
					export timediff="$timediff s"
				fi
			
				export name="$(git log -1 --format="%an:%s" -- $1/$fname)"
				echo "| $2/$fname | $timediff | $name |"
			fi
		fi
	done
	echo ""
	echo ""
}

echo "Last Update at $(date)" > "outdated.md"
echo "" >> "outdated.md"
echo "" >> "outdated.md"
echo "zh_cn..."
list de_de zh_cn >> "outdated.md"
echo "en_us..."
list de_de en_us >> "outdated.md"
echo "de_de..."
list en_us de_de >> "outdated.md"
echo "fr_fr..."
list de_de fr_fr >> "outdated.md"
echo "pt_br..."
list de_de pt_br >> "outdated.md"
