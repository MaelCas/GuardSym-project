#!/bin/bash
#SBATCH --job-name=kallisto_maelc                                       # Nom du travail
#SBATCH --ntasks=1                                                      # Nombre de t�ches (processus)
#SBATCH --cpus-per-task=32                                              # Nombre de CPU par t�che
#SBATCH --mem=128G                                                      # M�moire par n�ud
#SBATCH --time=4-00:00:00                                               # Temps maximum d'ex�cution (HH:MM:SS)
#SBATCH --output=output_%j.log 						# Fichier de sortie
#SBATCH --error=error_%j.log    					# Fichier d'erreur
#SBATCH --partition=workq                                               # Nom de la partition

module load bioinfo/kallisto/0.50.1

# Chemin vers le dossier contenant les fichiers
input_dir="dossier d'entr�e"

# Chemin vers le dossier de sortie
output_dir="dossier de sortie"

# Chemin vers les fichiers d'index
REFERENCE_GENOME="dossier vers la r�f�rence"

# Cr�er le r�pertoire de sortie si n�cessaire
mkdir -p $output_dir

# Lancer les analyses en parall�le
for SAMPLE in $(ls $input_dir/*_1_trimmed.fastq.gz | sed 's/_1_trimmed.fastq.gz//') 
do
  echo "${SAMPLE}"
  FASTQ_1="${SAMPLE}_1_trimmed.fastq.gz"
  FASTQ_2="${SAMPLE}_2_trimmed.fastq.gz"  
  SAMPLE_NAME=$(basename $SAMPLE) 
  
  # Cr�er un r�pertoire de sortie sp�cifique pour chaque �chantillon
  sample_output_dir="${output_dir}/${SAMPLE_NAME}"
  mkdir -p $sample_output_dir

  # V�rifier si les fichiers FASTQ existent
  if [[ -f $FASTQ_1 && -f $FASTQ_2 ]]; then
    # Kallisto    
    kallisto quant -i $REFERENCE_GENOME/kallisto_index -t 8 --seed=60 --bootstrap-samples=1000 --output-dir=$sample_output_dir $FASTQ_1 $FASTQ_2 #--single -l 565 -s 845 
  else
    echo "Error: One or both FASTQ files for sample $SAMPLE_NAME not found."
  fi
done

# Attendre que tous les processus se terminent
wait

# D�sactiver l'environnement Conda apr�s l'ex�cution
module unload bioinfo/kallisto/0.50.1

echo "travail termin�"