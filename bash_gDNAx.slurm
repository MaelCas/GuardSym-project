#!/bin/bash
#SBATCH --job-name=gDNAx_analysis       # Nom du job
#SBATCH --output=gDNAx_analysis_%j.out  # Nom du fichier de sortie (avec %j pour l'ID du job)
#SBATCH --error=gDNAx_analysis_%j.err   # Nom du fichier d'erreur (avec %j pour l'ID du job)
#SBATCH --time=12:00:00                 # Temps d'exécution maximal
#SBATCH --mem=32G                       # Mémoire demandée
#SBATCH --cpus-per-task=8               # Nombre de cœurs à utiliser
#SBATCH --partition=long

# Charger R
conda activate r_env

# Dossier contenant les fichiers .bam.gz
INPUT_DIR="dossier d'entrée"
OUTPUT_DIR="dossier de sortie"
DB="base de donnée de référence en .gff"

# Créer un répertoire de sortie si nécessaire
mkdir -p $OUTPUT_DIR

Rscript -e "
txdb <- makeTxDbFromGFF("$DB")
"

# Boucle sur tous les fichiers .bam.gz dans le dossier d'entrée
for bam_file in $INPUT_DIR/*.sam.gz; do
    # Nom de base sans l'extension .bam.gz
    base_name=$(basename "$bam_file" .sam.gz)
    
    # Décompresser le fichier .bam.gz
    echo "Décompression de $bam_file"
    gunzip -c "$bam_file" > "$OUTPUT_DIR/$base_name.sam"
    samtools view -b "$OUTPUT_DIR/$base_name.sam" > "$OUTPUT_DIR/$base_name.bam"
    # Exécuter l'analyse avec gDNAx dans R
    echo "Analyse de $base_name avec gDNAx"
    Rscript -e "
      library(gDNAx)
      library(GenomicFeatures)
      library(txdbmaker)
      # Charger le fichier BAM
      bam_file <- '$OUTPUT_DIR/$base_name.bam'
      # Effectuer l'analyse avec gDNAx
      result <- gDNAdx(bamfiles, txdb)
      class(result) 
      attr(,"package")
      # Sauvegarder les résultats dans un fichier
      write.table(result, file = '$OUTPUT_DIR/$base_name_analysis.txt', sep = '\t', quote = FALSE, row.names = FALSE)
      
      par(mar=c(4, 5, 2, 1))
      pdf('$OUTPUT_DIR/$base_name_analysis.pdf')
      plot(result, group=pdat$gDNA, pch=19)
      dev.off()
    "
    
    # Recompresser le fichier BAM après analyse
    rm "$OUTPUT_DIR/$base_name.bam"
    
    echo "Analyse terminée pour $base_name"
done

conda deactivate