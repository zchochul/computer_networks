#!/bin/bash

#miejsce ze smietnikiem
SMIETNIK="/home/zuzanka/Desktop/shellscripts/smietnik1"


if [ -d "$SMIETNIK" ]  # sprawdzamy czy istnieje folder smietnik
  then
        echo "istnieje folder ustalony za smietnik"
  else
	echo "Ustalony folder smietnik nie istnieje, tworze folder smietnik..."
	mkdir $SMIETNIK
fi

if [ $# = 0 ]
	then
	echo "Nie podano argumentow! Sprobuj ponownie"
	echo "Lub sprawdz opcje --help"
	exit
fi

#kompresowanie i przenoszenie do folderu
for i in "$@"
do
	if [ $i -ef $SMIETNIK ] #zabezpieczenie przed usunieciem folderu smietnik
		then
		echo "ERROR: No nie mozna usuwac folderu smietnik, nie tak to dziala. Sprobuj ponownie!"
		exit
	fi
	if [ $1 = "--help" ] #pomoc
		then
		echo
		echo "WITAJ W POMOCY DO SKRYPTU KOSZ W BASHU!!"
		echo "Pliki przenoszone sa do ustalonego folderu smietnik"
		echo "Pliki do usuniecia dodawaj po spacji wedlug konwencji: ./bin.sh <argument1> <argument2> ..."
		echo "Folder smietnik to: $SMIETNIK"
		echo
		exit
	fi
	if [ $1 = "--author" ] #autor
		then
		echo
		echo "Autor: Zuzanna Chochulska"
		echo "Wydzial Fizyki Politechniki Warszawskiej"
		echo
		exit
	fi
	
	if [[ -d $i ]]  # sprawdza czy zmienna jest folderem 
          then
		#przypadek folderu
		#kompresowanie - tutaj nie trzeba sprawdzac czy jest skompresowany, po plik skompresowany nie jest widziany jako folder
		tar -zcf $(basename $i).tar.gz $i
		rm -r  $i		#usuwanie tego z czego jest ten tar
		mv $(basename $i).tar.gz $SMIETNIK		#przenoszenie do smietnika
        else
		#przypadek niefolderu
		#sprawdzenie czy skompresowany
		if ( ! file $i | grep -q compressed ); then
			#nieskompresowany
			tar -czf $(basename $i).tar.gz $i
			rm $i
			mv $(basename $i).tar.gz $SMIETNIK
		fi
		if ( file $i | grep -q compressed ); then
			mv $i $SMIETNIK
		fi
	fi

done

#usuwanie plikow starszych niz Xh
DAYS=1
MINUTES=10

#find ./$(basename $SMIETNIK) -mmin +$(basename $MINUTES) -type f -delete #files older than MINUTES min
find ./$(basename $SMIETNIK) -mtime +$(basename $DAYS) -type f -delete #files older than DAYS days
