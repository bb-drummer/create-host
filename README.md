## create vagrant/virtualbox host, v1.0


### USAGE: 

`create-host.sh --vmbox <boxname> --hostname <hostname> --ipaddr <ip-address> [--template <path_to_vagrant_file_template>] [--targetpath <path_to_vagrant_target>] [--logfile <path_to_logfile>] [--tmppath <path_to_tmp>] [--noninteractive] [--skip-log] [-v] [-h]`
   


### DESCRIPTION:

    This script initializes an vagrant environment in <path_to_vagrant_target> with the 
    given <boxname> vagrant/virtualbox VM.
    A template Vagrantfile is copied into <path_to_vagrant_target> and the VM's network 
    configuration, <hostname> and <ip-address>, is applied.



### OPTIONS:


*	`--vmbox boxname`    vagrant/virtualbox box name/id (ex: 'puphpet/ubuntu1404'), mandatory(!)

*	`--hostname hostname`    host's hostname (ex: 'my-awesome-project.devel.local'), mandatory(!)

*	`--ipaddr ip-address`    privat network ip (ex: '192.168.1.2'), mandatory(!)

*	`--template templatefile`    path to vagrantfile template (default ./Vagrantfile)

*	`-t targetpath`    path to vagrant target
*	`--target-path targetpath`
*	`--targetpath targetpath`
*	`-l logfile`    path to script logfile (default '...')
*	`--log-file logfile`
*	`--logfile logfile`
*	`-T tmppath`    path for temporary file storage (default '...')
*	`--tmp-path tmppath`
*	`--tmppath tmppath`



*	`-n`    be non-interactive
*	`--non-interactive`
*	`--noninteractive`
*	`--skip-log`    do not write to logfile
*	`--disable-log`
*	`-h`    show this message
*	`--help`
*	`-v`    verbose output
*	`--verbose`


	
	
### EXAMPLES:

-	[more to come...]
	  



### @TODO: 

*   [...]




### DISCLAIMER:

THIS SCRIPT COMES WITH ABSOLUTELY NO WARRANTY !!! USE AT YOUR OWN RISK !!!




### CHANGELOG:

-	2016-08-04     : (bba) initial release 



