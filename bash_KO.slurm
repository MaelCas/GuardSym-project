#!/bin/bash
#SBATCH --job-name=hisat2_test_maelc          # Nom du travail
#SBATCH --ntasks=1                            # Nombre de t�ches (processus)
#SBATCH --cpus-per-task=16                    # Nombre de CPU par t�che
#SBATCH --mem=64G                             # M�moire par n�ud
#SBATCH --time=4-00:00:00                     # Temps maximum d'ex�cution (HH:MM:SS)
#SBATCH --output=output_%j.log                # Fichier de sortie
#SBATCH --error=error_%j.log                  # Fichier d'erreur
#SBATCH --partition=workq                     # Nom de la partition

# === CONFIGURATION ===
gunzip "/work/user/mcastin/esp_travail/Annotation/GCF_036512215.1_SLM_r2.1_protein.faa.gz"

FASTA="fichier d'entr�e en .faa"                  # Argument 1 : fichier FASTA en entr�e
OUTFILE="fichier de sortie en .tsv" # Argument 2 (optionnel) : fichier de sortie
PROFILES="/usr/local/bioinfo/src/KofamScan/kofam_scan-v1.3.0/KOfam_202312/profiles/"
KOLIST="/usr/local/bioinfo/src/KofamScan/kofam_scan-v1.3.0/KOfam_202312/ko_list"

module load bioinfo/HMMER/3.2.1
module load bioinfo/KofamScan/1.3.0

# === V�rifications de base ===
if [ ! -f "$FASTA" ]; then
  echo "? Fichier FASTA introuvable : $FASTA"
  exit 1
fi

# === Ex�cution de l'annotation ===
echo "?? Lancement de l'annotation avec KofamScan..."
/usr/local/bioinfo/src/KofamScan/kofam_scan-v1.3.0/exec_annotation -f mapper -o "$OUTFILE" -p $PROFILES -k $KOLIST "$FASTA"

echo "? Termin�. R�sultats dans : $KO_DIR/$OUTFILE"

rm $FASTA

module unload bioinfo/HMMER/3.2.1
module unload bioinfo/KofamScan/1.3.0