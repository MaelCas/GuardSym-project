#!/bin/bash
#SBATCH --job-name=kraken_job          # Nom du job
#SBATCH --output=kraken_output_%j.log  # Fichier de sortie
#SBATCH --error=kraken_error_%j.log    # Fichier d'erreur
#SBATCH --ntasks=1                     # Nombre de tâches (processus)
#SBATCH --cpus-per-task=32             # Nombre de cœurs par tâche
#SBATCH --mem=128G                     # Mémoire par tâche
#SBATCH --time=2-00:00:00              # Temps d'exécution maximum (HH:MM:SS)
#SBATCH --partition=workq              # Partition à utiliser

# Charger les modules nécessaires
module load devel/python/Python-3.11.1
module load bioinfo/Kraken2/2.1.2 
module load bioinfo/Krona/2.8.1
module load bioinfo/KrakenTools/d4a2fbe 

# Définir les chemins des fichiers d'entrée et de sortie
READS_1="fichier d'entrée 1 en .fastq"
READS_2="fichier d'entrée 2 en .fastq"
READS_3="fichier d'entrée 3 en .fasta"
OUTPUT_DIR="dossier de sortie 1"
OUTPUT_DIR_2="dossier de sortie 2"
DB_PATH="/home/dsantos/save/Kraken2DB/hemipteraDB/"
taxon="symbiote_extract" #laisser le "_extract"
taxon_ID="X" #tomato = 4070, bemisia = 6656, wolbachia = 942, rickettsia = 775, arsenophonus = 1903414, cardinium = 768503, TYLCV = 10814, portiera = 3399795, hamiltonella = 543, homme = 9443 

# Créer le répertoire de sortie s'il n'existe pas
mkdir -p $OUTPUT_DIR
mkdir -p $OUTPUT_DIR_2

# Exécuter Kraken
kraken2 --paired $READS_1 $READS_2 --db $DB_PATH --threads 30 --output $OUTPUT_DIR/results.class $READS --report $OUTPUT_DIR/report.report

ktImportTaxonomy -i -q 2 -t 3 -o $OUTPUT_DIR/report.html $OUTPUT_DIR/report.report

#extract_kraken_reads.py -t $taxon_ID --include-children -k $OUTPUT_DIR/results.class -s $READS -o $OUTPUT_DIR/$taxon.fasta -r $OUTPUT_DIR/report.report

kraken2 $READS_3 --db $DB_PATH --threads 30 --output $OUTPUT_DIR_2/results.class --report $OUTPUT_DIR_2/report.report

ktImportTaxonomy -i -q 2 -t 3 -o $OUTPUT_DIR_2/report.html $OUTPUT_DIR_2/report.report

module unload kraken/2.1.2
module unload bioinfo/Krona/2.8.1
module unload bioinfo/KrakenTools/d4a2fbe 
module unload bioinfo/Krona/2.8.1
module unload devel/python/Python-3.11.1
