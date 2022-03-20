#!/bin/bash

#miejsce ze smietnikiem
SMIETNIK="/home/zuzanka/Desktop/shellscripts/smietnik1"
echo "Folder smietnik to: $SMIETNIK"

if [ -d "$SMIETNIK" ]  # sprawdzamy czy istnieje folder smietnik
  then
        echo "istnieje folder ustalony za smietnik"
  else
	echo "ustalony folder smietnik nie istnieje, tworze folder smietnik..."
	mkdir $SMIETNIK
fi

#kompresowanie i przenoszenie do folderu
for i in "$@"
do
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
