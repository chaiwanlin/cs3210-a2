#!/bin/bash

## Try to keep this prefix at least for your job name
## so that SoC can keep track of our jobs

#SBATCH --job-name=cs3210_a2

## Change based on length of job and `sinfo` partitions available
## You shouldn't need to change this unless there are very limited GPUs on the standard partition for some reason

#SBATCH --partition=standard

## Specifying what kind of GPU you want. We will grade on A100 MIG instances, but feel free to develop on other machines.
## gpu:1 ==> any gpu. gpu:a100mig:1 gets you one of the A100 GPU shared instances, which are the most plentiful.

#SBATCH --gres=gpu:a100mig:1

## Time limit for the job, set to 30 sec for initial testing, but change this as necessary.

#SBATCH --time=00:00:30

## Just useful logfile names

#SBATCH --output=logs/cs3210_a2_%j.slurmlog
#SBATCH --error=logs/cs3210_a2_%j.slurmlog

## You shouldn't have to change these settings

#SBATCH --ntasks=1
#SBATCH --nodes=1

# Uncomment these two lines if we ask you for debugging information
# echo "DEBUG: All Slurm environment variables for this job"
# printenv | grep SLURM

echo "Job is running on $(hostname), started at $(date)"

# Get some output about GPU status before starting the job
nvidia-smi 

# Compile the code with make - this should produce the 'scanner' executable
echo "Running make to compile your code..."
srun make all

# Run the executable - you can replace the default arguments here with "$@" to pass in the arguments to this job script instead
echo "Running!"
./check.py signatures/sigs-exact.txt tests/virus-0001-Win.Downloader.Banload-242+Win.Trojan.Matrix-8.in

### RECIPES: Examples of what you can run here instead of the line above
## Just runs the scanner executable directly
# srun ./scanner signatures/sigs-exact.txt tests/benign-0001.in tests/virus-0001-Win.Downloader.Banload-242+Win.Trojan.Matrix-8.in
## Works as above if you call this script as sbatch a2_slurm_job.sh signatures/sigs-exact.txt tests/benign-0001.in tests/virus-0001-Win.Downloader.Banload-242+Win.Trojan.Matrix-8.in
# ./scanner $@
## Runs the debug version of the executable with NVIDIA's Nsight Systems profile in nvprof mode
# /usr/local/cuda/bin/nsys nvprof ./scanner-debug signatures/sigs-exact.txt tests/benign-0001.in tests/virus-0001-Win.Downloader.Banload-242+Win.Trojan.Matrix-8.in

echo -e "\n====> Finished running.\n"

echo -e "\nJob completed at $(date)"
