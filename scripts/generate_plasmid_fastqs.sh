# generate perfect reads from the plasmid with varying levels of coverage
for i in {25..100..5}; do fastaq to_perfect_reads --seed ${i} LN890519_plasmid.fasta - 400 20 ${i} 125 | fastaq deinterleave - LN890519_plasmid_${i}x_1.fastq.gz LN890519_plasmid_${i}x_2.fastq.gz ; done
# generate perfect reads from the chromosome at 50X
fastaq to_perfect_reads --seed 50 LN890518_chromosome.fasta - 400 20 50  125 | fastaq deinterleave - LN890518_chromosome_1.fastq.gz LN890518_chromosome_2.fastq.gz

# merge the chromosome and plasmid FASTQ files to form a single file for forward and reverse.
for i in {25..100..5}; do cat LN890518_chromosome_1.fastq.gz LN890519_plasmid_${i}x_1.fastq.gz > LN890518_chromosome_LN890519_plasmid_${i}x_1.fastq.gz; done
for i in {25..100..5}; do cat LN890518_chromosome_2.fastq.gz LN890519_plasmid_${i}x_2.fastq.gz > LN890518_chromosome_LN890519_plasmid_${i}x_2.fastq.gz; done

