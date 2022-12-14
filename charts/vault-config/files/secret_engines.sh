#! /bin/sh

source "$(dirname -- "${BASH_SOURCE[0]}")/env.sh"
echo "## Secet Engines"

export VAULT_ADDR=
export VAULT_POD_SELECTOR="${VAULT_POD_SELECTOR:-app.kubernetes.io/instance=hc-vault}"
# Ensure you are running agains active pod
export VAULT_POD_SELECTOR="${VAULT_POD_SELECTOR,vault-active=true}"
export VAULT_POD_ADDRESS=
export VAULT_SECRET_ENGINES_PATH="/SecretEngines"
export VAULT_TOKEN=

function set_secret_engine(){
    secret_engine="${1}"
    secret_engine_params="$(cat ${VAULT_SECRET_ENGINES_PATH}/${1})"

    vault secrets enable ${secret_engine_params} ${secret_engine}
}

function set_secret_engines(){
    for secret_engine in $(ls -1 ${VAULT_SECRET_ENGINES_PATH}); do
        set_secret_engine ${secret_engine}
    done
}

function main(){
    select_init_pod_address
    login
    set_secret_engines
}

main
