: ' Docking Runner Bash Script

MCQB. Flor Maria Briceño-Vargas

Este código ejecturá de manera consecutiva Autodock 4
para generar numerosas salidas a partir de un par ligando-receptor
previamente preparado con Autogrid 4 y el script "prepare.py" incluido
con el paquete de Autodock 4. Se requiere de varias ejecuciones del docking
para asegurar significancia estadística.

En el caso de emplear Autodock Vina en vez de Autodock 4, favor de usar
la variante de este script adaptada a los archivos .pdbqt de Autodock Vina

El script se ejecuta como:

./dockingRunner.sh > salida.out &

Posiblemente sea necesario concederle el permiso de ejecución con

chmod +x dockingRunner.sh

Esto dirige toda la información del estatus de los cálculos a un archivo de salida
y a ejecución en segundo plano, para que el terminal continúe utilizable. ' 

#!/bin/bash
read -p "Introduce el nombre del archivo .dpf del ligando: " dpf_file
if [ -z ${dpf_file} ]; # prueba para evitar dejar la variable vacía
then 
    echo "No se introdujo el nombre del archivo"
    exit 1 # salir del programa reportando que hubo un problema
else
    echo -e "El nombre de los archivos de salida será i-${dpf_file}.dlg.pdb"
fi

for i in {1..10..1} # inicializacion de un ciclo for para la variable i, {1..# de repeticiones..intervalo}
do    
    ini=$(date + '%C') # fecha y hora de inicio de la corrida i
    echo -e "Hora de inicio de corrida $i: $ini"
    autodock4 -p $dpf_file -l $i-$dpf_file.dlg.pdb & # ejecución del docking número i
    echo -e "PID del docking $i: $!" # ID de programa (PID) de cada corrida
    wait $! # esperar a que el cálculo acabe, esto hace que se ejecuten de manera consecutiva sin saturar la máquina
    fin=$(date + '%C') # fecha y hora de finalización del docking numero i
    echo -e "Hora de finalización de corrida $i: $fin\n"
    # echo -e "$i-$dpf_file\n" # Esto era para checar que el ciclo funcione bien
done