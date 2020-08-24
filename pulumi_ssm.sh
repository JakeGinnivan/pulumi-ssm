select_stack() {
    export PULUMI_CONFIG_PASSPHRASE=$(aws ssm get-parameter \
        --name "/pulumi/passphrase/$1" \
        --with-decryption |
        jq -r .Parameter.Value)

    pulumi stack select $1
}

create_new_stack() {
    echo "Creating stack $1"
    aws ssm put-parameter \
        --name "/pulumi/passphrase/$1" \
        --type SecureString --value "$(
            cat /dev/urandom | env LC_CTYPE=C tr -dc a-zA-Z0-9 | head -c 16
            echo
        )"

    export PULUMI_CONFIG_PASSPHRASE=$(aws ssm get-parameter \
        --name "/pulumi/passphrase/$1" \
        --with-decryption |
        jq -r .Parameter.Value)

    pulumi stack init --stack $1
}