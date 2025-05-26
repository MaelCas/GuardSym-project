#!/bin/bash
#SBATCH --job-name=instal_geno_maelc          # Nom du travail
#SBATCH --ntasks=1                            # Nombre de tâches (processus)
#SBATCH --cpus-per-task=32                    # Nombre de CPU par tâche
#SBATCH --mem=128G                            # Mémoire par nœud
#SBATCH --time=4-00:00:00                     # Temps maximum d'exécution (HH:MM:SS)
#SBATCH --output=output_%j.log                # Fichier de sortie
#SBATCH --error=error_%j.log                  # Fichier d'erreur
#SBATCH --partition=workq                     # Nom de la partition

module load devel/Miniconda/Miniconda3
#module load bioinfo/SeqKit/2.9.0

#INPUT_REF="fichier d'entrée reference en .faa"
#INPUT_BIS="fichier d'entrée complémentaire en .faa"
#INPUT_TRIS="fichier d'entrée complémentaire 2 (si nécessaire) en .fna"
#OUTPUT_FASTA="dossier de sortie"

#seqkit fx2tab -i -n -s -H $INPUT_REF | seqkit tab2fx -o $OUTPUT_FASTA/protein_ref.fasta

#seqkit fx2tab -i -n -s -H $INPUT_BIS | seqkit tab2fx -o $OUTPUT_FASTA/protein_.fasta

#seqkit fx2tab $INPUT_TRIS | seqkit tab2fx > $OUTPUT_FASTA/cds_from_genomic_tris.fasta

#module unload bioinfo/SeqKit/2.9.0

module load bioinfo/OrthoFinder/2.5.5

INPUT="dossier d'entrée"
OUTPUT="dossier de sortie"

orthofinder -d -f $INPUT -o $OUTPUT -T "iqtree" -I 1.5 -M msa -t 4 #-I granularity = cut-off between the different orthogroups (plus c est haut plus les informations seront précises)

module unload bioinfo/OrthoFinder/2.5.5
module unload devel/Miniconda/Miniconda3
