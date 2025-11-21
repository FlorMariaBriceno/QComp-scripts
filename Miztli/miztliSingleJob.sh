: ' Bash script para enviar un job a Miztli

El script original pertenece al Laboratorio Nacional de Cómputo de Alto Desempeño (LANCAD),
pero hice algunas modificaciones para facilitar su uso.

Se ejecuta como: bsub < miztliSingleJob.sh

La supercomputadora Miztli usa IBM Spectrum LSF como administrador de recursos HPC (High Performance Computing)
y cuenta con RedHat Linux '

#!/bin/bash +H

# Zona BSUB, aquí se dan indicaciones a LSF sobre los parámetros con los que se asignarán recursos
# Información como el tipo de cola y el grupo de clústeres es brindada por el LANCAD
# El comando BSUB -R "span[hosts=1]" puede eliminarse si se van a usar más de 16 procesadores.

#BSUB -q q_hpc                  # Esta es la cola, cambia dependiendo del tipo de proyecto
#BSUB -n 16                     # Este es el número de procesadores requeridos
#BSUB -R "span[hosts=1]"        # Span especifica que los 16 procesadores deben encontrarse en un mismo clúster
#BSUB -m "g1"                   # El job debe de ejecutarse en los clústeres que pertenecen al grupo 1
#BSUB -J job1                   # Aquí se le pone nombre al cálculo
#BSUB -oo %J.o                  # Este es el nombre del archivo de salida de LSF
#BSUB -eo %J.e                  # Este es el nombre del archivo de error de LSF

# Preparación del ambiente y carga de módulos
source /tmpu/scunam/config/tipo_nodo.sh             # NO TOCAR, ESTO ES DEL LANCAD
module list                                         # Enlistar los módulos (programas) disponibles
module purge                                        # Eliminar módulos cargados
#module load orca/5.0.3                              # Cargar ORCA 5.0.3, comentar si se va a usar otra versión
#module load orca/6                                  # Cargar ORCA 6.0.0, comentar si se va a usar otra versión
module load orca/6.1                                # Cargar ORCA 6.1.0, comentar si se va a usar otra versión
module load xtb/6.6                                 # Cargar xTB 6.6.0, comentar si no se necesita
export workdir=$PWD                                 # Crear directorio de trabajo en la carpeta actual (PWD)
export tempdir=$PWD/tempdir                         # Crear directorio temporal para almacenar los resultados del cálculo
if [ ! -d $tempdir ]; then mkdir $tempdir; fi       # Si ~/tmpu/tempdir no existe, se crea.
export OMPI_MCA_pml="^ucx"                          # NO MODIFICAR!!! Establece que la interfaz de paso de mensajes (MPI) se comunique mediante la red infiniband
export OMPI_MCA_btl_openib_allow_ib="true"          # NO MODIFICAR!!! Permite a MPI usar la conexión por InifiBand

# Procesamiento del archivo de entrada. Se copia desde ~/tmpu/ a $PWD/tempdir/
file="insertarAquiElNombre"                         # Modificar entre las comillas con el nombre del archivo .inp, sin extensión
cp -f ${file}.inp $tempdir
cd $tempdir
${ORCA}/orca ${file}.inp | tee ${file}.out          # Ejecutar el cálculo con el módulo de ORCA cargado anteriormente

# Post-procesamiento
rm $tempdir/*.tmp*                                  # Eliminar todos los archivos temporales
cp -rf $tempdir $workdir                            # Copiar el contenido de $tempdir a $workdir
rm -rf $tempdir/*                                   # Eliminar el contenido  de $tempdir una vez copiados los archivos
cd ..                                               # Regresar a $workdir
rmdir $tempdir                                      # eliminar $tempdir vacío

