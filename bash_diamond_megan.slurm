#!/bin/bash
#SBATCH --job-name=kraken_job          # Nom du job
#SBATCH --output=kraken_output_%j.log  # Fichier de sortie
#SBATCH --error=kraken_error_%j.log    # Fichier d'erreur
#SBATCH --ntasks=1                     # Nombre de t�ches (processus)
#SBATCH --cpus-per-task=32             # Nombre de c�urs par t�che
#SBATCH --mem=128G                     # M�moire par t�che
#SBATCH --time=2-00:00:00              # Temps d'ex�cution maximum (HH:MM:SS)
#SBATCH --partition=workq              # Partition � utiliser

module load bioinfo/DIAMOND/2.1.9 
module load bioinfo/MEGAN/6

INPUT="fichier d'entr�e en .fasta"
OUTPUT="fichier de sortie en .daa"
DB="/work/bank2/ncbi/blast/nr/nr_2025-3-1/diamond/nr"
DB_MEGAN="/work/user/mcastin/esp_travail/scripts/megan-map-Jul2020-2-X.db/megan-map-Jul2020-2-X.db"

diamond blastx -d $DB -q $INPUT -o $OUTPUT -f 100
daa-meganizer -i $OUTPUT -mdb $DB_MEGAN

module unload bioinfo/DIAMOND/2.1.9 
module unload bioinfo/MEGAN/6