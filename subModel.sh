#!/bin/bash
#SBATCH --job-name=radmodel
#SBATCH --output=logs/radmodel_%j.out
#SBATCH --error=logs/radmodel_%j.err
#SBATCH --partition=batch
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G

set -euo pipefail
walltime=02:00:00
outfile="Jobname.o"
repeats=1
memory=8G
basePath=$PWD
model=${PWD##*/}
jobname=""
num_cores=1
date=`date +%Y-%m-%d-T%H-%M-%S`
params="/users/sbessey/akhann16/ccv/khanna-lab-radmodel/params/radmodel_params.yaml"
# read params and sbatch opts
while getopts m:j:T:p:n: option
do
  case "${option}"
    in
  p) params=${OPTARG};;
  m) memory=${OPTARG};;
  j) jobname=${OPTARG};;
  T) walltime=${OPTARG};;
  n) nodes=${OPTARG};;
esac
done

# REPO="/users/sbessey/akhann16/ccv/khanna-lab-radmodel"
# PARAMS="${1:-$REPO/params/radmodel_params.yaml}"
if [[ $jobname == "" ]]; then
	jobname="Analysis_$date"
fi

if [[ $params == "" ]]; then
  params = "/users/sbessey/akhann16/ccv/khanna-lab-radmodel/params/radmodel_params.yaml"
fi

outPath="$HOME/scratch/radmodel"
# cd "$REPO"
# mkdir -p logs
# TODO what is settings?
# source settings.sh

# sbatch submit_radmodel.sh
prepSubmit() {
	mkdir -p $finalPath
	echo -e "\t$finalPath"
#	sbatch --output=$finalPath/slurm.out -J $jobname -t $walltime --mem=$memory -c $num_cores ./submit_radmodel.sh -p $params -o $finalPath/results
sbatch --output=$finalPath/slurm.out --error=$finalPath/slurm.err -J $jobname -t $walltime --mem=$memory -c $num_cores ./batch.sh $params -o $finalPath/results
}

echo -e "\tMaking directory in scratch"
mkdir -p $outPath
echo -e "\t $outPath"
finalPath=$outPath"/"$jobname
prepSubmit;
# echo "Host: $(hostname)"
#echo "Job: ${SLURM_JOB_ID:-<none>}  Params: $PARAMS"
#echo "Started: $(date -Is)"
#mpirun -n 1 radmodel "$PARAMS"
# mpirun -n "$SLURM_NTASKS" radmodel "$PARAMS"

#echo "Finished: $(date -Is)"

