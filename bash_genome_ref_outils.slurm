#!/bin/bash
#SBATCH --job-name=hisat2_test_maelc          # Nom du travail
#SBATCH --ntasks=1                            # Nombre de tâches (processus)
#SBATCH --cpus-per-task=16                    # Nombre de CPU par tâche
#SBATCH --mem=64G                             # Mémoire par nœud
#SBATCH --time=1-00:00:00                     # Temps maximum d'exécution (HH:MM:SS)
#SBATCH --output=output_%j.log                # Fichier de sortie
#SBATCH --error=error_%j.log                  # Fichier d'erreur
#SBATCH --partition=workq                     # Nom de la partition

INPUT_ID="fichier d'entrée des ID en .tsv"
OUTPUT_ID="fichier intermédiaire 1 des ID en .txt"
INPUT_SEQ="fichier d'entrée des séquences en .tsv"
INPUT_ID_BIS="fichier d'entrée 2 des ID en .tsv"
OUTPUT_PRE_SEQ="fichier intermédiaire 2 en .txt"

awk -F'\t' '$2 == 0 && $3 != 0 {print $1}' $INPUT_ID | grep -v '^$' > $OUTPUT_ID

while IFS= read -r ligne
do
    awk -F'\t' -v ref="$ligne" '$1 == ref {print $3}' "$INPUT_SEQ" >> "$OUTPUT_PRE_SEQ"
done < "$OUTPUT_ID"

awk -F'\t' '$3 != "" {print $3}' $INPUT_ID_BIS | grep -v '^$' >> "$OUTPUT_PRE_SEQ"

sed -i 's/,\s/\n/g' "$OUTPUT_PRE_SEQ"
sed -i 's/from_genomic//g' "$OUTPUT_PRE_SEQ"

identifiants_1="fichier intermédiaire 2"
identifiants_2="fichier intermédiaire 3"
fasta_1="fichier d'entrée de séquence en .fasta"
sortie_1="fichier intermédiaire 4 en .fasta"
fasta_2="fichier d'entrée de séquence 2 en .fasta"
sortie_2="fichier intermédiaire 5 en .fasta"

> $sortie_1

module load bioinfo/SeqKit/2.9.0

seqkit grep -f $identifiants_1 -r $fasta_1 > $sortie_1
seqkit grep -f $identifiants_2 -r $fasta_2 > $sortie_2
cat $sortie_1 $sortie_2 > "fichier intermédiaire 6 en .fasta"

module unload bioinfo/SeqKit/2.9.0

module load bioinfo/CD-HIT/4.8.1

cd-hit-est -c 0.99 -i $sortie_1 -o "dossier intermédiaire"

module unload bioinfo/CD-HIT/4.8.1 

cat "dossier intermédiaire" $fasta_1 > "fichier intermédiaire 8 en .fasta"

INPUT="fichier intermédiaire 8"
#OUTPUT_HISAT="dossier de sortie pour Hisat2"
OUTPUT_KALLISTO="dossier de sortie pour kallisto"

module load bioinfo/HISAT2/2.2.1
module load bioinfo/kallisto/0.50.1
module load devel/python/Python-3.11.1

#mkdir -p $OUTPUT_HISAT
mkdir -p $OUTPUT_KALLISTO

#hisat2-build $INPUT $OUTPUT_HISAT/Hisat2_index
kallisto index -i $OUTPUT_KALLISTO/kallisto_index $INPUT

module unload bioinfo/HISAT2/2.2.1
module unload bioinfo/kallisto/0.50.1
module unload devel/python/Python-3.11.1