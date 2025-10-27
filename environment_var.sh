echo "Setting up the environment..."
setup_proxy(){
    # proxy settings
    echo "Setting up proxy..."
    export HTTP_PROXY="http://proxy.alcf.anl.gov:3128"
    export HTTPS_PROXY="http://proxy.alcf.anl.gov:3128"
    export http_proxy="http://proxy.alcf.anl.gov:3128"
    export https_proxy="http://proxy.alcf.anl.gov:3128"
    export ftp_proxy="http://proxy.alcf.anl.gov:3128"
    export no_proxy="127.0.0.1, admin,polaris-adminvm-01,localhost,*.cm.polaris.alcf.anl.gov,polaris-*,*.polaris.alcf.anl.gov,*.alcf.anl.gov"
}

# Set environment variables
setup_generic(){
    echo "Setting up generic paths and flags..."
    export HF_DATASETS_CACHE='/lus/eagle/projects/argonne_tpc/abalaji/model_weights/'
    export HF_HOME='/lus/eagle/projects/argonne_tpc/abalaji/model_weights/'
    export OMP_NUM_THREADS=4
    export VLLM_IMAGE_FETCH_TIMEOUT=60
    export VLLM_ATTENTION_BACKEND='XFORMERS'
    export HF_TOKEN='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' #CHNAGE THIS
    export HYDRA_FULL_ERROR=1
    export RAYON_NUM_THREADS=4
    export RUST_BACKTRACE=1
    export RAY_TMPDIR='/tmp'
    export PROMETHEUS_MULTIPROC_DIR="/tmp"
    export VLLM_RPC_BASE_PATH="/tmp"
    export RAY_gcs_rpc_server_reconnect_timeout_s=30
    ulimit -c unlimited
}


setup_nccl_aws(){
    #NCCL AWS SETUP
    echo "Setting up nickel and aws paths and flags..."
    # error torch.distributed.DistBackendError: NCCL error in: ../torch/csrc/distributed/c10d/ProcessGroupNCCL.cpp:2044, internal error - please report this issue to the NCCL developers, NCCL version 2.20.5 
    export NCCL_NET_GDR_LEVEL=PHB
    export NCCL_CROSS_NIC=1
    export NCCL_COLLNET_ENABLE=1
    export NCCL_NET="AWS Libfabric"
    #export NCCL_IB_DISABLE=1
    export NCCL_IB_TC=128
    export NCCL_IB_GID_INDEX=3
    export NCCL_IB_TIMEOUT=22
    export NCCL_SOCKET_IFNAME='infinibond0,ib0,bond0,eth0,br01,br0'
    #export NCCL_P2P_DISABLE=1
    export NCCL_DEBUG=INFO
    unset NCCL_NET_GDR_LEVEL NCCL_CROSS_NIC NCCL_COLLNET_ENABLE NCCL_NET
    export LD_LIBRARY_PATH=/soft/libraries/aws-ofi-nccl/v1.9.1-aws/lib:$LD_LIBRARY_PATH
    export FI_MR_CACHE_MONITOR=userfaultfd
}

setup_CXI_network(){
    echo "Setting up CXI..."
    # Additional variables that might be critical to address any potential hang issue in Python applications. 
    export FI_CXI_DEFAULT_TX_SIZE=131072
    export FI_CXI_DISABLE_HOST_REGISTER=1
    export FI_CXI_RDZV_PROTO=alt_read
    export FI_CXI_RX_MATCH_MODE=software
    export FI_CXI_REQ_BUF_SIZE=16MB
    export FI_CXI_RDZV_GET_MIN=0
    export FI_CXI_SAFE_DEVMEM_COPY_THRESHOLD=16000
    export FI_CXI_RDZV_THRESHOLD=2000
}

export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1
export NODE_OPTIONS='--disable-wasm-trap-handler'
VLLM_ATTENTION_BACKEND=XFORMERS
#main function
module use /soft/modulefiles
module load conda; conda activate
module load cudatoolkit-standalone/12.6.1
#module load cudatoolkit-standalone/12.4.0
CRAY_CFLAGS=$(cc --cray-print-opts=cflags)
CRAY_LIB=$(cc --cray-print-opts=libs)

#module swap PrgEnv-nvhpc PrgEnv-gnu
#module load nvhpc-mixed
module load PrgEnv-gnu

setup_proxy
setup_generic
setup_nccl_aws
setup_openai
setup_CXI_network
module unload xalt
