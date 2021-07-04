#!/bin/bash

echo "-----START-----"
start_time=`date +%s`

#content=$(curl -L https://www.cardmarket.com/fr/Magic/Products/Singles/Modern-Horizons/Prismatic-Vista)
NOW=$(date +"%m-%d-%Y")
echo $NOW

htmlLinename=$NOW"-MCMprices.txt"

#Parcours le fichier MCMsearchCards et lance un curl par entrée
while IFS= read -r urlMCM; do
    isFound=false
    urlMCM=${urlMCM%$'\r'}
    content=$(curl -L $urlMCM)
	
	#Parcours le fichier HTML à la recherche de Tendance des prix
    for htmlLine in $content; do
       #printf "%s" "$htmlLine" | cat -v
       #echo "################"
	   #echo $htmlLine
        if [[ "$htmlLine" == 'col-xl-5">Tendance' ]]
        then
            isFound=true
        fi
    
        if [ "$isFound" = true ]
        then
            searchPrice="col-xl-7\"><span>"
            if [[ $htmlLine == *"span>"* ]]
            then
			  echo $urlMCM ":" ${htmlLine#"$searchPrice"}
              echo ${htmlLine#"$searchPrice"} >> $htmlLinename
              isFound=false
			  break
            fi
        fi
    done 
done < MCMsearchCards.txt
<<<<<<< HEAD
echo "-----END-----" && echo run time is $(expr `date +%s` - $start_time) s
=======
echo "-----END-----" && echo run time is $(expr `date +%s` - $start_time) s
>>>>>>> dbbb6458792f81df01fdeb0362ab20ae5a37ba71
