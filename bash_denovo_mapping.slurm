#!/bin/bash
#SBATCH --job-name=spades_maelc               # Nom du travail
#SBATCH --ntasks=1                            # Nombre de t�ches (processus)
#SBATCH --cpus-per-task=32                    # Nombre de CPU par t�che
#SBATCH --mem=128G                            # M�moire par n�ud
#SBATCH --time=4-00:00:00                     # Temps maximum d'ex�cution (HH:MM:SS)
#SBATCH --output=output_%j.log                # Fichier de sortie
#SBATCH --error=error_%j.log                  # Fichier d'erreur
#SBATCH --partition=workq                     # Nom de la partition


# Initialiser Conda
module load devel/python/Python-3.9.18
module load bioinfo/SPAdes/4.0.0

# D�finir les variables
OUTPUT_DIR="dossier de sortie"

# Cr�er le r�pertoire de sortie si n�cessaire
mkdir -p $OUTPUT_DIR

# Commande HISAT2 pour aligner les lectures


#for SAMPLE in $(ls $READ_DIR/*_1_trimmed.fastq.gz | sed 's/_1_trimmed.fastq.gz//') 
#do

  FASTQ_1="fichier d'entr�e 1 en .fastq.gz"
  FASTQ_2="fichier d'entr�e 1 en .fastq.gz"
  SAMPLE_NAME="nom des fichiers" 
  
  spades.py -1 $FASTQ_1 -2 $FASTQ_2 -o $OUTPUT_DIR/$SAMPLE_NAME --threads 16 --memory 64 --rna
  
#done

module unload devel/python/Python-3.9.18
module unload bioinfo/HISAT2/2.2.1

echo "Mapping completed!"