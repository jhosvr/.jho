# jho.sh
# personal env preferences

###
### Functions
###

check_directory(){ 
    if [[ ! -d "${1}" ]]; then mkdir -p "${1}"; fi; 
}

command_exists(){
    which "${1}" &>/dev/null || { echo "The command '${1}' was not found in \$PATH" && exit 127; }
}


###
### Script execution
###

# create directories
check_directory "${HOME}/bin"
check_directory "${HOME}/tmp"
check_directory "${HOME}/.config"


### Pulling preferred tools

# check command dependencies
command_exists wget
command_exists tar
command_exists unzip

if [[ ! -d "${HOME}/tmp/jho" ]]; then mkdir -p "${HOME}/tmp/jho"; fi
cd "${HOME}/tmp/jho"
echo -n "Pulling tools: "
# gets binaries from 2nd field of tools.txt file
for line in $(cat ${HOME}/repos/.jho/src/tools.txt); do
    tool="$(echo ${line} | cut -d';' -f1)"
    url="$(echo ${line} | cut -d';' -f2)"
    if [[ ! -e "${HOME}/bin/${tool}" ]]; then
        echo -n "${tool} "
        wget -q "${url}" -O "${tool}"

        # handle non binary downloads
        case "${tool}" in
            "helm")
                tar -xzf helm
                tool="linux-amd64/helm" ;;
            "terraform")
                unzip -oq terraform ;;
            "google-cloud-sdk")
		tar xzf google-cloud-sdk
		cp -r google-cloud-sdk "${HOME}/"
		tool="google-cloud-sdk/bin/gcloud" ;;
        esac
        chmod +x "${tool}"
        cp "${tool}" "${HOME}/bin/" ;
    fi
done
echo

# clean out tmp folder
rm -rf "${HOME}/tmp/jho"
