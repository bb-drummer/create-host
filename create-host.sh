#!/bin/bash

##
## "_shellscript.base.sh"
##    basic shell script template...
##
## usage/info: ./{scriptname} -h
##
## (c) Björn Bartels, coding@bjoernbartels.earth
##

##
## global vars
##
TITLE="Create a new Vagrant Host"
HOMEPAGE="https://gitlab.bjoernbartels.earth/groups/shellscripts"
COPYRIGHT="(c) 2016 Björn Bartels, coding@bjoernbartels.earth"
LICENCE="Apache 2.0"
VERSION="1.0.0"

## init vars, parameter defaults
TARGETPATH=`pwd`
TMPPATH="/tmp/"
LOGFILE=$TMPPATH"/bash.log"
VAGRANTFILETMPLATE="/Users/bba/bash/Vagrantfile"

VM_BOX=
VM_HOSTNAME=
VM_IPADDR=

SKIP_LOG=0
VERBOSE=1
NONINTERACTIVE=0
CDIR=`pwd`


## info texts
USAGEMANDATORY="--vmbox <boxname> --hostname <hostname> --ipaddr <ip-address>";

USAGEOPTIONAL="[--template <path_to_vagrant_file_template>] [--targetpath <path_to_vagrant_target>] [--logfile <path_to_logfile>] [--tmppath <path_to_tmp>] [--noninteractive] [--skip-log] [-v] [-h]";

DESCRIPTION="
    This script initializes an vagrant environment in <path_to_vagrant_target> with the 
    given <boxname> vagrant/virtualbox VM.
    A template Vagrantfile is copied into <path_to_vagrant_target> and the VM's network 
    configuration, <hostname> and <ip-address>, is applied.
";

AVAILABLE_OPTIONS="
    --vmbox boxname              vagrant/virtualbox box name/id (ex: 'puphpet/ubuntu1404'), mandatory(!)

    --hostname hostname          host's hostname (ex: 'my-awesome-project.devel.local'), mandatory(!)

    --ipaddr ip-address          privat network ip (ex: '192.168.1.2'), mandatory(!)

    --template templatefile      path to vagrantfile template (default ${VAGRANTFILETMPLATE})

    -t targetpath                path to vagrant target (default ${TARGETPATH})
    --target-path targetpath
    --targetpath targetpath

    -l logfile                   path to script logfile (default ${LOGFILE})
    --log-file logfile
    --logfile logfile

    -T tmppath                   path for temporary file storage (default ${TMPPATH})
    --tmp-path tmppath
    --tmppath tmppath

    -n                           be non-interactive
    --non-interactive
    --noninteractive

    --skip-log                   do not write to script logfile, alternatives: --disable-log
    -h                           show this message, alternatives: --help
    -v                           verbose output, alternatives: --verbose
";

EXAMPLES="
    [more to come...]
";

DISCLAIMER="
    THIS SCRIPT COMES WITH ABSOLUTELY NO WARRANTY !!! USE AT YOUR OWN RISK !!!
";

CHANGELOG="
    2016-08-04     : (bba) initial release 
";



##
## custom methods
##

## setup the vagrant environment...
##
setup_vagranthost ()
{
    logMessage ">>> setting up vagrant environment in '${SCRIPT_TARGETPATH}'...";
    echo ">>> setting up vagrant environment in '${SCRIPT_TARGETPATH}'...";
    if [ "$SCRIPT_VERBOSE" == "1" ]; then 

		cd ${SCRIPT_TARGETPATH};

		vagrant init ${SCRIPT_VM_BOX};

    else

		cd ${SCRIPT_TARGETPATH} > /dev/null;

		vagrant init ${SCRIPT_VM_BOX} > /dev/null;

    fi


}

## setup the vagrant environment...
##
setup_vagrantfile ()
{
    logMessage ">>> applying configuration in vagrant environment in '${SCRIPT_TARGETPATH}'...";
    echo ">>> applying configuration in vagrant environment in '${SCRIPT_TARGETPATH}'...";
    if [ "$SCRIPT_VERBOSE" == "1" ]; then 

		cp ${VAGRANTFILETMPLATE} ${SCRIPT_TARGETPATH}/Vagrantfile

        replace -v "{VM_BOX}" "${SCRIPT_VM_BOX}" -- ${SCRIPT_TARGETPATH}/Vagrantfile

        replace -v "{VM_HOSTNAME}" "${SCRIPT_VM_HOSTNAME}" -- ${SCRIPT_TARGETPATH}/Vagrantfile

        replace -v "{VM_IPADDR}" "${SCRIPT_VM_IPADDR}" -- ${SCRIPT_TARGETPATH}/Vagrantfile

    else

		cp ${VAGRANTFILETMPLATE} ${SCRIPT_TARGETPATH}Vagrantfile > /dev/null

        replace "{VM_BOX}" "${SCRIPT_VM_BOX}" -- ${SCRIPT_TARGETPATH}/Vagrantfile > /dev/null

        replace "{VM_HOSTNAME}" "${SCRIPT_VM_HOSTNAME}" -- ${SCRIPT_TARGETPATH}/Vagrantfile > /dev/null

        replace "{VM_IPADDR}" "${SCRIPT_VM_IPADDR}" -- ${SCRIPT_TARGETPATH}/ls -laVagrantfile > /dev/null

    fi


}

## setup the vagrant environment...
##
display_dns_hint ()
{
cat << EOF



!!! HINT !!!



If you plan to connect to this host via the VM\'s hostname \'${SCRIPT_VM_HOSTNAME}\' add 
the following line to your local hosts file (ex \'/etc/hosts\'):

${SCRIPT_VM_IPADDR}    ${SCRIPT_VM_HOSTNAME}

(on OS-X, flush the DNS cache: \`dscacheutil -flushcache\` afterwards)





EOF;


}


##
## >>> INTERNAL SCRIPT METHODS <<<
##

## show script config info
##
scriptinfo()
{
cat << EOF

CONFIGURATION:
    VERSION        = ${VERSION} 
    TARGETPATH     = ${TARGETPATH}
    TMPPATH        = ${TMPPATH}
    LOGFILE        = ${LOGFILE}

    VM_BOX         = ${VM_BOX}
    VM_HOSTNAME    = ${VM_HOSTNAME}
    VM_IPADDR      = ${VM_IPADDR}

OS:
    OS             = ${OS}
    ID             = ${ID}
    CODENAME       = ${CODENAME}
    RELEASE        = ${RELEASE}

EOF
}


## show script vendor information
##
scriptvendor()
{
cat << EOF

DISCLAIMER:
${DISCLAIMER}

         
CHANGELOG:
${CHANGELOG}


SCRIPT INFO:
    homepage/        ${HOMEPAGE}
    support/bugs    
    copyright        ${COPYRIGHT}
    licence          ${LICENCE}

EOF
}


## show script usage help
##
scriptusage()
{
cat << EOF
${TITLE}, v${VERSION}

USAGE: 
    $0 $USAGEMANDATORY $USAGEOPTIONAL


DESCRIPTION:
${DESCRIPTION}


OPTIONS:
${AVAILABLE_OPTIONS}


EXAMPLES:
${EXAMPLES}
    

EOF
}


## detect current OS type
##
detectOS () 
{
    TYPE=$(echo "$1" | tr '[A-Z]' '[a-z]')
    OS=$(uname)
    ID="unknown"
    CODENAME="unknown"
    RELEASE="unknown"

    if [ "${OS}" == "Linux" ] ; then
        # detect centos
        grep "centos" /etc/issue -i -q
        if [ $? = '0' ]; then
            ID="centos"
            RELEASE=$(cat /etc/redhat-release | grep -o 'release [0-9]' | cut -d " " -f2)
        # could be debian or ubuntu
        elif [ $(which lsb_release) ]; then
            ID=$(lsb_release -i | cut -f2)
            CODENAME=$(lsb_release -c | cut -f2)
            RELEASE=$(lsb_release -r | cut -f2)
        elif [ -f "/etc/lsb-release" ]; then
            ID=$(cat /etc/lsb-release | grep DISTRIB_ID | cut -d "=" -f2)
            CODENAME=$(cat /etc/lsb-release | grep DISTRIB_CODENAME | cut -d "=" -f2)
            RELEASE=$(cat /etc/lsb-release | grep DISTRIB_RELEASE | cut -d "=" -f2)
        elif [ -f "/etc/issue" ]; then
            ID=$(head -1 /etc/issue | cut -d " " -f1)
            if [ -f "/etc/debian_version" ]; then
                RELEASE=$(</etc/debian_version)
            else
                RELEASE=$(head -1 /etc/issue | cut -d " " -f2)
            fi
        fi

    elif [ "${OS}" == "Darwin" ]; then
        ID="osx"
        OS="Mac OS-X"
        RELEASE=""
        CODENAME="Darwin"
    fi

    ##ID=$(echo "${ID}" | tr '[A-Z]' '[a-z]')
    ##TYPE=$(echo "${TYPE}" | tr '[A-Z]' '[a-z]')
    ##OS=$(echo "${OS}" | tr '[A-Z]' '[a-z]')
    ##CODENAME=$(echo "${CODENAME}" | tr '[A-Z]' '[a-z]')
    ##RELESE=$(echo "${RELEASE}" | tr '[A-Z]' '[a-z]' '[0-9\.]')

}


## display confirm dialog
##
DIALOG__CONFIRM=0
confirm () {
    DIALOG__CONFIRM=0
    if [ "$1" != "" ] 
        then
            read -p ">>> $1 [(YJ)/n]: " CONFIRMNEXTSTEP
            case "$CONFIRMNEXTSTEP" in
                Yes|yes|Y|y|Ja|ja|J|j|"") ## continue installing...
                    logMessage ">>> '$1' confirmed...";
                    DIALOG__CONFIRM=1
                ;;
                *) ## operation canceled...
                    echo "WARNING: operation has been canceled through user interaction..."
                ;;
            esac
    fi
}


## write message to log-file...
##
logMessage () {
    if [ "$SCRIPT_SKIP_LOG" == "0" ] && [ "$1" != "" ]; then 
        echo "$1" >>${SCRIPT_LOGFILE}; 
    fi
}


## >>> START MAIN SHELL SCRIPT <<<
##


## init user parameters...
##
TYPE=
OS=
ID=
CODENAME=
RELEASE=

detectOS

## parse shell script arguments
##
CLI_ERROR=0
CLI_CMDOPTIONS_TEMP=`getopt -o d:p:t:i:l:H:I:s:u:T:envh --long displayname:,display-name:,php-version:,phpversion:,target-path:,targetpath:,path:,php-path:,phppath:,target-ini-path:,targetinipath:,ini-path:,inipath:,php-inipath:,phpinipath:,log-file:,logfile:,php-handler:,php-handler:,plesk-phphandler:,pleskphphandler:,plesk-id:,pleskid:,source-host:,sourcehost:,php-host:,phphost:,source-file:,sourcefile:,source-url:,sourceurl:,archive:,file:,sapi,apxs-path:,tmp-path:,tmppath:,edit-ini:,editini:,non-interactive,noninteractive,verbose,help,info,manual,man,skip-dependencies,disable-dependencies,skip-dependency-check,disable-dependency-check,skip-dependencycheck,disable-dependencycheck,skip-fetch,disable-fetch,skip-fetch-php,disable-fetch-php,skip-fetchphp,disable-fetchphp,skip-build,disable-build,skip-build-php,disable-build-php,skip-buildphp,disable-buildphp,skip-handler,disable-handler,skip-php-handler,disable-php-handler,skip-phphandler,disable-phphandler,apply-suhosin,suhosin,suhosin-host:,suhosin-version:,suhosin-url:,apply-xdebug,xdebug,xdebug-host:,xdebug-version:,xdebug-url:,apply-memcached,memcached,memcached-host:,memcached-version:,memcached-url:,configure: -n 'php2plesk.sh' -- "$@"`
while true; do
    case "${1}" in
    
## --- my script options --------
        --vmbox)
        VM_BOX=${2}
            shift 2
        ;;

        --hostname)
        VM_HOSTNAME=${2}
            shift 2
        ;;

        --ipaddr)
        VM_IPADDR=${2}
            shift 2
        ;;

        -t|--target-path|--targetpath)
        TARGETPATH=${2}
            shift 2
        ;;

        ## --configure)
        ##     CONFIGURE_MODE=${2}
        ##     case "${CONFIGURE_MODE}" in
        ##         *default*)
        ##             ## no action required now
        ##         ;;
        ##         *none*)
        ##             ## no action required now
        ##         ;;
        ##         *full*)
        ##             ## no action required now
        ##         ;;
        ##         *custom*)
        ##             ## no action required now
        ##         ;;
        ##         *)
        ##             CONFIGURE_MODE=default
        ##         ;;
        ##     esac
        ##     
        ##     shift 2
        ##     ;;



## --- generic script options --------
        -T|--tmp-path|--tmppath)
            TMPPATH=${2}
            shift 2
            ;;

        -l|--log-file|--logfile)
            LOGFILE=${2}
            shift 2
            ;;

        -n|--non-interactive|--noninteractive)    
            shift
            NONINTERACTIVE=1
            ;;
            
        -v|--verbose)    
            shift
            VERBOSE=1
            ;;

        --skip-log|--disable-log)    
            shift
            SKIP_LOG=1
            ;;

## --- shell script info/help --------
        -h|--help|--info|--manual|--man)
            shift    
            scriptusage
            scriptvendor
            exit
            ;;

        -i|--info)
            shift    
            scriptinfo
            exit
            ;;

        --version)
            shift    
            echo "v"${VERSION}
            exit
            ;;

        --) 
            shift
            break
            ;;
        *)    
            ## halt on unknown parameters
            #echo "ERROR: invalid command line option/argument : ${1}!"
            #CLI_ERROR=1
            #break
            
            ## ignore unknown parameters
            shift
            break
            ;;

    esac
done
CLI_CMDARGUMENTS=( ${CLI_CMDOPTIONS[@]} )

## halt on command line error...
##
if [ $CLI_ERROR == 1 ]
    then
    	echo "!!! ERROR !!!";
        scriptusage
    	scriptinfo 
        scriptvendor
        exit 1
fi

## check for mandatory script argument values
##
if [[ -z $TARGETPATH ]] || [[ -z $LOGFILE ]]
then
    echo "!!! ERROR !!!";
    scriptusage
    scriptinfo
    #scriptvendor
    exit 1
fi

## select/perform script operations...
##

    ## setting parameters, sampling paths and vars...
    ##
    clear;
    current_work_dir=`pwd`;
    DIALOG__CONFIRM=0
    
    SCRIPT_VERSION=$VERSION
    SCRIPT_TARGETPATH=${TARGETPATH}
    SCRIPT_LOGFILE=$LOGFILE
    SCRIPT_TMPPATH=${TMPPATH}
    SCRIPT_VERBOSE=${VERBOSE}
    SCRIPT_NONINTERACTIVE=${NONINTERACTIVE}
    SCRIPT_KEEPFILES=${KEEP_FILES}
    SCRIPT_KEEPARCHIVE=${KEEP_ARCHIVE}
    
    SCRIPT_VM_BOX=$VM_BOX;
    SCRIPT_VM_IPADDR=$VM_IPADDR;
    SCRIPT_VM_HOSTNAME=$VM_HOSTNAME;

    ## check parameters, if paths and targets are set properly...
    ##
    SETTINGERROR=0

    ## check box parameter
    if [[ $SCRIPT_VM_BOX == "" ]]
    	then
    		echo "ERROR: you must provide a vagrant/virtualbox box name/id...";
    		logMessage "ERROR: you must provide a vagrant/virtualbox box name/id...";
            SETTINGERROR=1
    fi     		

    ## check hostname parameter
    if [[ $SCRIPT_VM_HOSTNAME == "" ]]
    	then
    		echo "ERROR: you must provide a hostname...";
    		logMessage "ERROR: you must provide a hostname...";
            SETTINGERROR=1
    fi     		

    ## check ip-adress parameter
    if [[ $SCRIPT_VM_IPADDR == "" ]]
    	then
    		echo "ERROR: you must provide an (private network) IP address...";
    		logMessage "ERROR: you must provide an (private network) IP address...";
            SETTINGERROR=1
    fi     		

    ## check for 'target path'
    if [[ ! -d $SCRIPT_TARGETPATH ]] 
        then
            echo "ERROR: '$SCRIPT_TMPPATH' does not exist or you have no permission to write there, please select another path using option '-T path'...";
            logMessage "ERROR: '$SCRIPT_TMPPATH' does not exist or you have no permission to write there, please select another path using option '-T path'...";
            SETTINGERROR=1
    fi 
    
    ## check for 'temporary file storage path'
    if [[ ! -d $SCRIPT_TMPPATH ]] 
        then
            echo "ERROR: '$SCRIPT_TMPPATH' does not exist or you have no permission to write there, please select another path using option '-T path'...";
            logMessage "ERROR: '$SCRIPT_TMPPATH' does not exist or you have no permission to write there, please select another path using option '-T path'...";
            SETTINGERROR=1
    fi 
    
    ## check for 'logfile'
    touch $SCRIPT_LOGFILE
    if [[ ! -w $SCRIPT_LOGFILE ]] 
        then
            echo "ERROR: could not write to log-file '$SCRIPT_LOGFILE', please select another log-file using option '-l filepath'...";
            logMessage "ERROR: could not write to log-file '$SCRIPT_LOGFILE', please select another log-file using option '-l filepath'...";
            SETTINGERROR=1
    fi 
    
    ## prepare script execution
    ##
    ## prepare_script_execution_defined_as_a_function_in_the_beginning;
    
    if [[ $SETTINGERROR == 1 ]] 
        then
    		echo "!!! ERROR !!!";
            scriptinfo
            scriptusage
            scriptvendor
            exit
    fi 
    
    
    ## show shell script configuration, confirm execution
    ##
    scriptinfo;
    scriptvendor;
    
    CONTINUESCRIPT=0
    if [ $NONINTERACTIVE == 0 ]
        then
            confirm "Do you really want to setup a new vagrant environment in '${SCRIPT_TARGETPATH}'?";
            CONTINUESCRIPT=$DIALOG__CONFIRM;
        else
            CONTINUESCRIPT=1;
    fi
    
    ## execute the script methods...
    ##
    if [ $CONTINUESCRIPT == 1 ]
        then

            ## initialize vagrant environment
            ##
            SCRIPT_SKIP_VAGRANTHOST=0;
            if [ $NONINTERACTIVE == 0 ] && [ $SCRIPT_SKIP_VAGRANTHOST == 0 ]
                then
                    confirm "Do you want to setup box '${SCRIPT_VM_BOX}'?";
                    CONTINUE_STEP=$DIALOG__CONFIRM;
                else
                    CONTINUE_STEP=1;
            fi
            if [ $CONTINUE_STEP == 1 ] && [ $SCRIPT_SKIP_VAGRANTHOST == 0 ]
                then

                	## execute step
                	setup_vagranthost;

		            ## apply configuration to Vagrantfile
		            ##
		            SCRIPT_SKIP_VAGRANTFILE=0;
		            if [ $NONINTERACTIVE == 0 ] && [ $SCRIPT_SKIP_VAGRANTFILE == 0 ]
		                then
		                    confirm "Do you want to setup the VM's network: '${SCRIPT_VM_HOSTNAME}', '${SCRIPT_VM_IPADDR}'?";
		                    CONTINUE_STEP=$DIALOG__CONFIRM;
		                else
		                    CONTINUE_STEP=1;
		            fi
		            if [ $CONTINUE_STEP == 1 ] && [ $SCRIPT_SKIP_VAGRANTFILE == 0 ]
		                then

                			## execute step
		                    setup_vagrantfile;

				            ## start the created VM
				            ##
				            SCRIPT_SKIP_VAGRANTUP=0;
				            if [ $NONINTERACTIVE == 0 ] && [ $SCRIPT_SKIP_VAGRANTUP == 0 ]
				                then
				                    confirm "Do you want to start up the VM?";
				                    CONTINUE_STEP=$DIALOG__CONFIRM;
				                else
				                    CONTINUE_STEP=1;
				            fi
				            if [ $CONTINUE_STEP == 1 ] && [ $SCRIPT_SKIP_VAGRANTUP == 0 ]
				                then

		                			## execute step
				                    vagrant up;

				            fi

				            display_dns_hint;

		            fi


            fi


            ## echo "execute script...";
            
            ## example of executing a sub-step of a 'real' script...
            ##
            ## SCRIPT_SKIP_THIS_STEP=0; # remove  in a real script ;)
            ## if [ $NONINTERACTIVE == 0 ] && [ $SCRIPT_SKIP_THIS_STEP == 0 ]
            ##     then
            ##         confirm "Do you want to execute this step of the script?";
            ##         CONTINUE_STEP=$DIALOG__CONFIRM;
            ##     else
            ##         CONTINUE_STEP=1;
            ## fi
            ## if [ $CONTINUE_STEP == 1 ] && [ $SCRIPT_SKIP_THIS_STEP == 0 ]
            ##     then
            ##         ## execute_next_step_defined_as_a_function_in_the_beginning();
            ##         echo "execute step...";
            ## 
            ##         ## (optionally ask for the next step to be executed...)
            ## fi

    fi # go?

    ## return to last working directory...
    cd ${current_work_dir};

    ## display script vendor info
    #scriptvendor;
    #scriptinfo;

## exit script script
exit 0;