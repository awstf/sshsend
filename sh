function usage() {
    printf "${0} OPTIONS

Send SSH public key to EC2 instance

OPTIONS

    -o          os user (default: ec2-user)
    -k          path to SSH public key (default: ~/.ssh/id_rsa)
    -z          availability zone name (required)
    -i          EC2 instance id
    -h          print this message and exit

"
    exit 2
}

function required() {
    local name=$1
    local opt=$2

    if ! [ ${!name} ]; then
        echo "error: missing required argument ${opt}"
        exit 1
    fi
}

osuser=ec2-user
keypath=~/.ssh/id_rsa.pub

while getopts "ho:k:i:a:" opt; do
    case $opt in
    o) osuser=$OPTARG;;
    k) keypath=$OPTARG;;
    i) id=$OPTARG;;
    a) az=$OPTARG;;
    h) usage ;;
    *) usage ;;
    esac
done

required az -a
required id -i

sshkey=$(cat $keypath)

aws ec2-instance-connect send-ssh-public-key \
    --ssh-public-key "$sshkey" \
    --instance-os-user $osuser \
    --availability-zone $az \
    --instance-id $id
