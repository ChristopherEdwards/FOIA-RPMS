ZIBENVCK ; IHS/HQW/JDH - NO DESCRIPTION PROVIDED ; [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1004,1005,1007**;APR 1, 2003
 ;IHS UTILITY/JDH; environment check instll routine
 ; usage S X=$$MGR^ZIBSETUP(DEV_ROUTINE)
 ;
 ;
ENVCHK ; IHS KIDS environment check utility 
 ;N ZIBOS,ZIBOSVR,ZIBMSM,ZIBUSE,ZIBUSER
 ;  check user
 W !!,"THIS IS THE IHS SPECIFIC ENVIRONMENT CHECK ROUTINE."
 W !!,"START OF ENVIRONMENT CHECK"
 W !,"NOTE:  THE ENVIRONMENT CHECK IS PERFORMED DURING BOTH PACKAGE INSTALL AND LOAD"
 S ZIBUSER=$P($G(^VA(200,+$G(DUZ),0)),"^") ;if valid get name
 I '$L(ZIBUSER) D  G QUIT ; user not valid
 .W !!,"You are not a valid user - either your DUZ is undefined,"
 .W !,"or this is a virgin install."
 ; prevent queueing of install
 S XPDNOQUE=1
 ; write out executing option name and demographics 
 S ZIBOPT=$S('XPDENV:"'LOAD A DISTRIBUTION'",1:"'KIDS INSTALL'")
 W !!,"OPTION: "_ZIBOPT
 W !,"USER: "_ZIBUSER
 W !,"PATCH: "_XPDNM
 W !,"SITE: "_$P(^XMB(1,1,0),"^")
 S ZIBKRNL=$$VERSION^XPDUTL("XU") ; kernel version
 W !,"KERNEL VERSION: "_ZIBKRNL
 S ZIBTLKT=$$VERSION^XPDUTL("XT") ; VA toolkit version
 W !,"VA TOOLKIT VERSION: "_ZIBTLKT
 S ZIBOS=$P(^%ZOSF("OS"),"^") ; mumps OS
 S ZIBOSVR=$$VERSION^%ZOSV ; mumps version number
 W !,"M SYSTEM: "_ZIBOS_" VERSION "_ZIBOSVR 
 S ZIBMSM=ZIBOS["MSM" ; boolean MSM 1 or 0
 S %=$ZU(0) ; current UCI/VOL
 W !,"CURRENT UCI/VOL: "_% ; verify single user
 ;S ZIBUSE=0 ; flag for the number of users on the system
 ;S:ZIBMSM ZIBUSE=$$LIST^%ACTJOB(.ZIBJOB)
 ;W !,"NUMBER OF USERS ON THE SYSTEM: "_ZIBUSE
 ;I ZIBUSE'=1 D  ;G QUIT
 .W !!,"THIS "_ZIBOPT_" REQUIRES NO OTHER USERS ON THE SYSTEM."
 ; Can I show the system users, so the user can tell the others to get off or die!!!!!!!!!!!
 ; what to do if other than MSM system
 ; verify versions
 I ZIBOSVR<4.4 D  G QUIT
 .W !!,"YOUR "_ZIBOS_" VERSION MUST BE GREATER THAN 4.4 FOR THIS "_ZIBOPT
 ; check versions
 I ZIBKRNL<8.0 D  G QUIT
 .W !!,"YOU NEED KERNEL VERSION 8.0 OR GREATER TO RUN THIS INSTAll."
 ; verify single user mode
 ; if TASKMAN is running, shut it down
 S %=$D(^%ZTSCH("RUN")) ; check taskman run node
 W !!,"TASKMAN IS"_$S(%:"",1:" NOT")_" RUNNING"
 I % W !,"SHUTTING DOWN TASKMAN" D STOP^ZTMKU
 ; 
 Q
 ;
QUIT ; quit the KIDS install    
 W !!,"THE HELP DESK"
 S XPDABORT=1 ;abort all transport globals in the distribution and kill them from ^XTMP
 ; if ^XTMP("XPDI") exists, the install option will abort
 Q
 ;
VA() ; execute the VA's ZTMGRSET routine in the MGR uci
 Q  S POP=0
 S ZIBCURR=$V(2,$J,2) ; get the number of the current UCI 
 ; V 2:$J:1:2 sets the current uci to the Volume Group MGR uci
 ; V 2:$J:ZIBCURR:2 resets the current uci
 V 2:$J:1:2 W $ZU(0) D ^ZTMGRSET V 2:$J:ZIBCURR:2 Q POP
 ; 
MGRSET() ; copy a routine from the list into the volume groups uci
 ;
 ; Usage:  S X=$$MGRSET^ZIBSETUP
 ;
 N POP S POP=0
 F I=1:1 S %=$P($T(MGR+I),";;",2) Q:%="END"  D
 .S ZIBRPROD=$P(%,";"),ZIBRMGR=$P(%,";",2)
 .I $L(ZIBRPROD),$D(^$ROUTINE(ZIBRPROD)) D  ; does the routine exist
 ..S %=$$MGRCHG(ZIBRPROD,ZIBRMGR),POP=1
 ..W !,"Routine "_ZIBRPROD_" copied from "_$P(%,"^")_" to "_$P(%,"^",2)
 Q POP
 ;
MGRCHG(ZIBRPROD,ZIBRMGR) ; zsave a routine from the production uci to the MGR uci of
 ; the volume group
 ; 
 ; input:   routine name
 ; output:  uci routine copied from^uci copied to
 ; usage:   S X=$$MGRCHG^ZIBSETUP("routine_name")
 ;
 ;N ZIBCURR
 S ZIBRPROD=$TR(ZIBRPROD,"^"),ZIBRMGR=$TR(ZIBRMGR,"^") ; remove any "^" characters
 S ZIBCURR=$V(2,$J,2) ; get the number of the current UCI 
 ; V 2:$J:1:2 sets the current uci to the Volume Group MGR uci
 ; V 2:$J:ZIBCURR:2 resets the current uci
 S %="ZL @ZIBRPROD V 2:$J:1:2 ZS @ZIBRMGR V 2:$J:ZIBCURR:2"
 X % Q $ZU(0)_"^"_$ZU(1,0)
 ;
MGR ; list of routines to copy into the MGR UCI of the Volume group.  END marks the end of the list
 ;;ZZHAY1;%ZZHAY
 ;;END
 ;;DIDT;%DT
 ;;DIDTC;%DTC
 ;;END
