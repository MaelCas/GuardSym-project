#!/bin/bash
#SBATCH --job-name=hisat2_test_maelc          # Nom du travail
#SBATCH --ntasks=1                            # Nombre de tâches (processus)
#SBATCH --cpus-per-task=2                     # Nombre de CPU par tâche
#SBATCH --mem=128G                            # Mémoire par nœud
#SBATCH --time=4-00:00:00                     # Temps maximum d'exécution (HH:MM:SS)
#SBATCH --output=/dev/null                    # Fichier de sortie
#SBATCH --error=error_%j.log                  # Fichier d'erreur
#SBATCH --partition=workq                     # Nom de la partition


# Initialiser Conda
module load bioinfo/HISAT2/2.2.1
module load bioinfo/samtools/1.20

# Définir les variables
GENOME_INDEX="dossier index"

READ_DIR="dossier d'entrée"

OUTPUT_DIR="dossier de sortie"

# Créer le répertoire de sortie si nécessaire
mkdir -p $OUTPUT_DIR

# Commande HISAT2 pour aligner les lectures
for FILE in $READ_DIR/*_1_trimmed.fastq.gz
do
  SAMPLE=$(basename $FILE "_1_trimmed.fastq.gz")  # Extrait juste le nom du sample sans le suffixe
  FASTQ_1="$READ_DIR/${SAMPLE}_1_trimmed.fastq.gz"
  FASTQ_2="$READ_DIR/${SAMPLE}_2_trimmed.fastq.gz"

  if [[ -f "$FASTQ_1" && -f "$FASTQ_2" ]]; then
    hisat2 -p 4 -x $GENOME_INDEX/Hisat2_index -1 $FASTQ_1 -2 $FASTQ_2 --summary-file $OUTPUT_DIR/${SAMPLE}.log --fr
  else
    echo "Fichiers FASTQ manquants pour $SAMPLE" >> $OUTPUT_DIR/missing_files.log
  fi
done

module unload bioinfo/HISAT2/2.2.1
module unload bioinfo/samtools/1.20

#echo "Mapping completed!"