#!/bin/bash

echo "-----START-----"
start_time=`date +%s`

#content=$(curl -L https://www.cardmarket.com/fr/Magic/Products/Singles/Modern-Horizons/Prismatic-Vista)
NOW=$(date +"%m-%d-%Y")
#echo $NOW

htmlLinename=$NOW"-MCMprices.txt"
#Parcours le fichier MCMsearchCards et lance un curl par entrée
while IFS= read -r urlMCM; do
    isFound=false
    urlMCM=${urlMCM%$'\r'}
    content=$(curl -L -s $urlMCM)
	
	#Parcours le fichier HTML à la recherche de Tendance des prix
    for htmlLine in $content; do
       #printf "%s" "$htmlLine" | cat -v
       #echo "################"
	   #echo $htmlLine
	   #ATTENTION A LA LANGUE DES DATA !! fr only
        if [[ "$htmlLine" == 'col-xl-5">Tendance' ]]
        then
            isFound=true
        fi
    
        if [ "$isFound" = true ]
        then
            searchPrice="col-xl-7\"><span>"
            if [[ $htmlLine == *"span>"* ]]
            then
	      #echo $urlMCM ":" ${htmlLine#"$searchPrice"}
              price=${htmlLine#"$searchPrice"}
	      #echo $price >> ./data/$htmlLinename	      
	      if [ $price == ""]
	      then
	      	price="-"
	      fi
              stringPrices="${stringPrices}${price}\n"
              isFound=false
	      break
            fi
        fi
    done 
done < ./data/MCMsearchCards.txt
echo -e "${stringPrices}" 
echo "-----END-----" && echo run time is $(expr `date +%s` - $start_time) s
