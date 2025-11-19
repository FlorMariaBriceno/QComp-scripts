#!/bin/bash
alias orcampi="/home/orca/bin/orca"
for i in {1..12..1}
do
        ini=$(date +'%c') # fecha y hora de inicio del calculo
        echo "Hora de inicio $i: $ini"
       	orcampi $i.inp > $i.out & # ejecucion del calculo
        echo "ID $i: $!" # program id del calculo individual
        wait $! # esperar a que el calculo termine
        fin=$(date +'%c') # fecha y hora de finalizacion del calculo
        echo "Hora de finalización $i: $fin"
        est="(grep -q "NORMALLY" $i.out)" #revisamos el estatus del calculo al finalizar
        if [[ $est == 0 ]] #es 0 si se encontro el patron pero 1 si tuvo errores, ta raro pero asi es linux
                then echo "Cálculo $i finalizado exitosamente"
                else echo "Cálculo $i con errores, favor de revisarlo"
        fi
done

