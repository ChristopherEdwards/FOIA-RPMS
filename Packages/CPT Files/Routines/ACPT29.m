ACPT29 ;IHS/SD/SDR - ACPT*2.09 install ; 12/21/2008 00:29
 ;;2.09;CPT FILES;;JAN 2, 2009
 ;
IMPORT ; Import CPTs from AMA files
 ;
 S ACPTYR=3090101
 D BMES^XPDUTL("CPT 2009 Install (CPT v2.09)")
 D MES^XPDUTL("CPT v2.09 contains 2009 CPT codes")
 D MES^XPDUTL("The install will attempt to read the CPT Description file")
 D MES^XPDUTL("acpt2009.l from the directory you specified")
 D MES^XPDUTL("The install will also attempt to read the CPT delete file")
 D MES^XPDUTL("acpt2009.d from the directory you specified")
 ;
 ;Get the directory containing the two files
 N ACPTPTH S ACPTPTH=$G(XPDQUES("POST1")) ; path to files
 I ACPTPTH="" D  ; for testing at programmer mode
 .S ACPTPTH=$G(^XTV(8989.3,1,"DEV")) ; default directory
 .D POST1(.ACPTPTH) ; input transform
 ;
 ; Installing 2009 CPTs from file acpt2009.l
 D BMES^XPDUTL("Loading 2009 CPTs from file acpt2009.l")
 D IMPORT^ACPT29L  ;add/edit codes
 D BMES^XPDUTL("Loading 2009 deleted CPTs from file acpt2009.d")
 D DELETE^ACPT29L  ;deleted codes
 ;
 ; Reindexing CPT file (81); this will take awhile.
 D BMES^XPDUTL("Reindexing CPT file (81); this will take awhile.")
 N DA,DIK S DIK="^ICPT(" ; CPT file's global root
 D IXALL^DIK ; set all cross-references for all records
 D ^ACPTCXR ; rebuild C index for all records
 ;
 ;activate 2009 CPT codes, deactivate deleted ones
 ;I ACPTYR>DT D  ; for future: queue this step if not yet time to activate
 .N ZTRTN S ZTRTN="EN^ACPT29AD" ; entry point
 .N ZTDESC ; description
 .S ZTDESC="ACPT v2.09 post-init: activate/deactivate 2009 CPT codes"
 .N ZTIO S ZTIO="" ; no I/O device
 .;N ZTDTH S ZTDTH="61362,21600" ; start time
 .N ZTDTH S ZTDTH="61342,21600" ; start time  FOR TESTING
 .N ACPTRDT S ACPTRDT=$$HTE^XLFDT(ZTDTH,1) ; save start time in external
 .N ZTSAVE S ZTSAVE("ACPTYR")="" ; save variable ACPTYR for the task
 .N ZTUCI,ZTCPU,ZTPRI,ZTKIL,ZTSYNC ; unused inputs & outputs
 .N ZTSK ; output: task # created
 .D ^%ZTLOAD
 .;
 .I $G(ZTSK) D  ; if the task was queued
 ..D MES^XPDUTL("I've taken the liberty to queue task #"_ZTSK_" to run on"_ACPTRDT)
 ..D MES^XPDUTL("This routine will inactivate deleted codes & activate new ones.")
 ..D MES^XPDUTL("If this date and time is inconvenient, you may use the Taskman")
 ..D MES^XPDUTL("reschedule option to run at a more suitable time.")
 .E  D  ; if it was not
 ..D MES^XPDUTL("Attempt to queue routine ACPT29AD was unsuccessful. This routine will")
 ..D MES^XPDUTL("need to be run to activate new codes and deactivate old ones and")
 ..D MES^XPDUTL("should be run January 2009.")
 ;
 ;E  D  ; otherwise (if time to activate), do so now
 .D BMES^XPDUTL("Activating 2009 codes and deactivating deleted ones.")
 .D EN^ACPT29AD
 Q
POST1(ACPTDIR) ; input transform for KIDS question POST1
 ;
 ; .ACPTDIR, passed by reference, is X from the Fileman Reader, the
 ; input to this input transform.
 ;
 I $ZV["UNIX" D  ; if unix, ensure proper syntax for unix
 .S ACPTDIR=$TR(ACPTDIR,"\","/") ; forward slash should delimit
 .S:$E(ACPTDIR)'="/" ACPTDIR="/"_ACPTDIR ; start with root (/)
 .S:$E(ACPTDIR,$L(ACPTDIR))'="/" ACPTDIR=ACPTDIR_"/" ; ensure trailing /
 ;
 E  D  ; otherwise, ensure proper syntax for other operating systems
 .S ACPTDIR=$TR(ACPTDIR,"/","\") ; back slash should delimit
 .I $E(ACPTDIR)'="\",ACPTDIR'[":" D
 ..S ACPTDIR="\"_ACPTDIR ; start with \ if not using : (?)
 .S:$E(ACPTDIR,$L(ACPTDIR))'="\" ACPTDIR=ACPTDIR_"\" ; ensure trailing \
 ;
 W !!,"Checking directory ",ACPTDIR," ..."
 ;
 N ACPTFIND S ACPTFIND=0 ; do we find our files in that directory?
 ; find out whether that directory contains those files
 K ACPTFILE
 S ACPTFILE("acpt2009.l")="" ; CPT description file
 S ACPTFILE("acpt2009.d")="" ; CPT delete file
 N Y S Y=$$LIST^%ZISH(ACPTDIR,"ACPTFILE","ACPTFIND")
 D  Q:ACPTFIND  ; format for most platforms:
 .Q:'$D(ACPTFIND("acpt2009.l"))
 .Q:'$D(ACPTFIND("acpt2009.d"))
 .S ACPTFIND=1
 ; format for Cache on UNIX
 Q:'$D(ACPTFIND(ACPTDIR_"acpt2009.l"))
 Q:'$D(ACPTFIND(ACPTDIR_"acpt2009.d"))
 S ACPTFIND=1
 ;
 I $D(ACPTFIND("acpt2009.l"))!$D(ACPTFIND(ACPTDIR_"acpt2009.l")) D
 .W !,"CPT Description file acpt2009.l found."
 I $D(ACPTFIND("acpt2009.d"))!$D(ACPTFIND(ACPTDIR_"acpt2009.d")) D
 .W !,"CPT delete file acpt2009.d found."
 ;
 I ACPTFIND D  Q  ; if they picked a valid directory
 .W !,"Proceeding with the install of ACPT 2.09."
 ;
 W !!,"I'm sorry, but that cannot be correct."
 W !,"Directory ",ACPTDIR," does not contain that file."
 ;
 N ACPTFILE S ACPTFILE("*")=""
 N ACPTLIST
 N Y S Y=$$LIST^%ZISH(ACPTDIR,"ACPTFILE","ACPTLIST")
 W !!,"Directory ",ACPTDIR," contains the following files:"
 S ACPTF=""
 F  S ACPTF=$O(ACPTLIST(ACPTF)) Q:ACPTF=""  D
 .W !?5,ACPTF
 ;
 W !!,"Please select a directory that contains the CPT file."
 K ACPTDIR
 ;
 Q
