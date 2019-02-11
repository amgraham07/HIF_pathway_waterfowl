#!/bin/bash

for fn in ./*_RAD_ST_H.vcf
do

# get the path to the file
dir=`dirname $fn`;

# get just the file (without the path)
base=`basename $fn`;

# the read filename, without the *_RAD_ST_H.vcf suffix
rf=${base%_RAD_ST_H.vcf};

# Do whatever we want
echo ">>>>>>>>>>bzip and taabix<<<<<<<<<<<<<"
bgzip ${dir}/${rf}_RAD_ST_H.vcf
tabix -p vcf ${dir}/${rf}_RAD_ST_H.vcf.gz
echo ">>>>>>>>>>vcf consensus<<<<<<<<<<<<<"
cat RAD_REF_overlap.fasta | bcftools consensus --iupac-codes --sample ${rf} ${rf}_RAD_ST_H.vcf.gz > ${rf}_RAD_ST_H_consensus_out.fasta
echo ">>>>>>>>>>collapsing<<<<<<<<<<<<<"
grep -v "^>" ${dir}/${rf}_RAD_ST_H_consensus_out.fasta | awk 'BEGIN { ORS=""; print ">collapsed RAD\n" } { print }' > ${rf}_RAD_ST_H_consensus_collapsed.fasta

done
