#!/bin/bash
#SBATCH --job-name=interproscan_test_maelc    # Nom du travail
#SBATCH --ntasks=1                            # Nombre de t�ches (processus)
#SBATCH --cpus-per-task=64                    # Nombre de CPU par t�che
#SBATCH --mem=512G                            # M�moire par n�ud
#SBATCH --time=4-00:00:00                     # Temps maximum d'ex�cution (HH:MM:SS)
#SBATCH --output=output_%j.log                # Fichier de sortie
#SBATCH --error=error_%j.log                  # Fichier d'erreur
#SBATCH --partition=workq                     # Nom de la partition


# Initialiser Conda

module load devel/java/17.0.6
module load bioinfo/InterProScan/5.64-96.0
module load bioinfo/Seqtk/1.3

# Variables
OUTPUT_DIR="dossier de sortie"

# Cr�er le r�pertoire de sortie si n�cessaire
mkdir -p $OUTPUT_DIR

interproscan.sh -i "fichier d'entr�e en .fasta" -t n -goterms -iprlookup -pa -f TSV, GFF3 -d $OUTPUT_DIR -appl Pfam, FunFam, ProSiteProfiles, SMART, PANTHER, PRINTS, ProSitePatterns, CDD -cpu 64 # -t n si fichiers RNA ou DNA

echo "analyse achevee pour $SAMPLE"


module unload devel/java/17.0.6
module unload bioinfo/InterProScan/5.64-96.0
module unload bioinfo/Seqtk/1.3 