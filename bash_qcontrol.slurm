#!/bin/bash

#SBATCH --job-name=rnaseq_analysis_test_maelc # Nom du travail
#SBATCH --ntasks=1                            # Nombre de t�ches (processus)
#SBATCH --cpus-per-task=4                     # Nombre de CPU par t�che
#SBATCH --mem=16G                             # M�moire par n�ud
#SBATCH --time=02:00:00                       # Temps maximum d'ex�cution (HH:MM:SS)
#SBATCH --output=output_%j.log                # Fichier de sortie
#SBATCH --error=error_%j.log                  # Fichier d'erreur
#SBATCH --partition=short                     # Nom de la partition


# Initialiser Conda
source /home/maelc/miniforge3/etc/profile.d/conda.sh

# Variables 
FASTQ_DIR="dossier d'entr�e"
OUTPUT_DIR="dossier de sortie"

# Cr�er le r�pertoire de sortie si n�cessaire
mkdir -p $OUTPUT_DIR

# Boucle pour traiter plusieurs fichiers de reads 
conda activate fastp

for SAMPLE in $(ls $FASTQ_DIR/*_1.fastq.gz | sed 's/_1.fastq.gz//'); do
    BASENAME=$(basename $SAMPLE)

    FASTQ_1="${SAMPLE}_1.fastq.gz"  
    FASTQ_2="${SAMPLE}_2.fastq.gz"  
  
    # Pr�-traitement des lectures avec fastp 
    fastp -i $FASTQ_1 -I $FASTQ_2 -o $OUTPUT_DIR/${BASENAME}_1_trimmed.fastq.gz -O $OUTPUT_DIR/${BASENAME}_2_trimmed.fastq.gz -h $OUTPUT_DIR/${BASENAME}_fastp_report.html -j $OUTPUT_DIR/${BASENAME}_fastp_report.json -l "15" -q "5" --length_limit "200" # pour les s�quences mi et sRNA et -l "120" pour mRNA plantes
  
done

conda deactivate

# G�n�ration de rapports MultiQC
conda activate multiqc

multiqc $OUTPUT_DIR -o $OUTPUT_DIR/multiqc_report

conda deactivate

# Fin du script
echo "T�che termin�e le $(date)"