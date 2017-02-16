#! /bin/bash
# Given a directory of FASTQ files and an output directory, produce plasmidtron assemblies
# run_plasmidtron.sh /mnt/data/plasmidtron_copynumber /data /data/plasmidtron


if [ $# -ne 3 ]
then
    echo "Usage: `basename $0` host_base input_directory output_directory"
    exit 1
fi

HOST_BASE=$1
INPUT_DIRECTORY=$2
OUTPUT_DIRECTORY=$3
DOCKER_HASH=compose_plasmidtron
SOFTWARE=plasmidtron

mkdir -p ${HOST_BASE}/${SOFTWARE}

for FORWARD_FILE in $(find ${HOST_BASE} -type f -name "*_1.fastq.gz");
  do
    FORWARD_FILE=${FORWARD_FILE/${HOST_BASE}/${INPUT_DIRECTORY}}
    REVERSE_FILE=${FORWARD_FILE/_1.fastq.gz/_2.fastq.gz}
    BASE_NAME=${FORWARD_FILE/_1.fastq.gz/}
    BASE_NAME=${BASE_NAME##*/}

    echo "/data/fastqs/LN890518_chromosome_1.fastq.gz,/data/fastqs/LN890518_chromosome_2.fastq.gz" > ${HOST_BASE}/${SOFTWARE}/${BASE_NAME}_nontraits
    echo "${FORWARD_FILE},${REVERSE_FILE}" > ${HOST_BASE}/${SOFTWARE}/${BASE_NAME}_traits
    echo "plasmidtron ${OUTPUT_DIRECTORY}/${BASE_NAME} ${OUTPUT_DIRECTORY}/${BASE_NAME}_traits  ${OUTPUT_DIRECTORY}/${BASE_NAME}_nontraits"
    { time docker run -it --rm -v ${HOST_BASE}:/data ${DOCKER_HASH} plasmidtron ${OUTPUT_DIRECTORY}/${BASE_NAME} ${OUTPUT_DIRECTORY}/${BASE_NAME}_traits  ${OUTPUT_DIRECTORY}/${BASE_NAME}_nontraits ; }  2> ${HOST_BASE}/${SOFTWARE}/timings_${BASE_NAME}
done
