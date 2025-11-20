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

./dockingRunner.sh 

Posiblemente sea necesario concederle el permiso de ejecución previamente con

chmod +x dockingRunner.sh

Cualquier duda conmigo, por favor' 

#!/bin/bash
# Parte 1. Introducir el nombre del ligando
read -p "Introduce el nombre del archivo .dpf del ligando: " dpf_file
if [ -z ${dpf_file} ]; # prueba para evitar dejar la variable vacía
then 
    echo "No se introdujo el nombre del archivo"
    exit 1 # salir del programa reportando que hubo un problema
else
    echo -e "El nombre de los archivos de salida será i-${dpf_file}.dlg.pdb"
fi

# Parte 2.  Introducir el numero de repeticiones
read -p "Introduce el número de repeticiones para el docking: " rep
if [ -z ${rep} ]; # prueba para evitar dejar la variable vacía
then 
    echo "No se introdujo el nombre del archivo"
    exit 1 # salir del programa reportando que hubo un problema
else
    echo -e "Se harán ${rep} repeticiones del docking con el ligando: ${dpf_file}.dpf"
fi

# Parte 3. Ejecución cíclica
for i in $(seq 1 $rep) # secuencia desde 1 hasta el número de repeticiones
do
    ini=$(date + '%C') # fecha y hora de inicio de la corrida i
    echo -e "Hora de inicio de corrida $i: $ini" | tee $i-$dpf_file.pdb.dlg
    autodock4 -p $dpf_file -l $i-$dpf_file.dlg.pdb & # ejecución del docking número i
    echo -e "PID del docking $i: $!" | tee -a $i-$dpf_file.pdb.dlg # ID de programa (PID) de cada corrida
    wait $! # esperar a que el cálculo acabe, esto hace que se ejecuten de manera consecutiva sin saturar la máquina
    fin=$(date + '%C') | tee $i-$dpf_file.pdb.dlg # fecha y hora de finalización del docking numero i
    echo -e "Hora de finalización de corrida $i: $fin\n" | tee -a $i-$dpf_file.pdb.dlg
    #echo -e "$i-$dpf_file\n" | tee $i-$dpf_file.dlg.pdb
    #sleep 15
    #rm $i-$dpf_file.dlg.pdb  # Esto era para checar que el ciclo funcione bien
done
exit 0
