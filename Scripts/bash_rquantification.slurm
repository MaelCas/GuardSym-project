#!/bin/bash
#SBATCH --job-name=kallisto_maelc                                       # Nom du travail
#SBATCH --ntasks=1                                                      # Nombre de tâches (processus)
#SBATCH --cpus-per-task=32                                              # Nombre de CPU par tâche
#SBATCH --mem=128G                                                      # Mémoire par nœud
#SBATCH --time=4-00:00:00                                               # Temps maximum d'exécution (HH:MM:SS)
#SBATCH --output=output_%j.log 						# Fichier de sortie
#SBATCH --error=error_%j.log    					# Fichier d'erreur
#SBATCH --partition=workq                                               # Nom de la partition

module load bioinfo/kallisto/0.50.1

# Chemin vers le dossier contenant les fichiers
input_dir="dossier d'entrée"

# Chemin vers le dossier de sortie
output_dir="dossier de sortie"

# Chemin vers les fichiers d'index
REFERENCE_GENOME="dossier vers la référence"

# Créer le répertoire de sortie si nécessaire
mkdir -p $output_dir

# Lancer les analyses en parallèle
for SAMPLE in $(ls $input_dir/*_1_trimmed.fastq.gz | sed 's/_1_trimmed.fastq.gz//') 
do
  echo "${SAMPLE}"
  FASTQ_1="${SAMPLE}_1_trimmed.fastq.gz"
  FASTQ_2="${SAMPLE}_2_trimmed.fastq.gz"  
  SAMPLE_NAME=$(basename $SAMPLE) 
  
  # Créer un répertoire de sortie spécifique pour chaque échantillon
  sample_output_dir="${output_dir}/${SAMPLE_NAME}"
  mkdir -p $sample_output_dir

  # Vérifier si les fichiers FASTQ existent
  if [[ -f $FASTQ_1 && -f $FASTQ_2 ]]; then
    # Kallisto    
    kallisto quant -i $REFERENCE_GENOME/kallisto_index -t 8 --seed=60 --bootstrap-samples=1000 --output-dir=$sample_output_dir $FASTQ_1 $FASTQ_2 #--single -l 565 -s 845 
  else
    echo "Error: One or both FASTQ files for sample $SAMPLE_NAME not found."
  fi
done

# Attendre que tous les processus se terminent
wait

# Désactiver l'environnement Conda après l'exécution
module unload bioinfo/kallisto/0.50.1

echo "travail terminé"
