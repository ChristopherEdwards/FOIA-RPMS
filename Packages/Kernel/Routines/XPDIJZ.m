XPDIJ ;SFISC/RSD - Install Job ;08/17/98  13:34
 ;;8.0;KERNEL;**1005**;FEB 09, 1999
 ;;8.0;KERNEL;**2,21,28,41,44,68,81,95**;Jul 10, 1995
EN ;install all packages
 ;XPDA=ien of first package
 ;this is needed to restore XPDIJ1
 I $D(^XTMP("XPDI",XPDA,"RTN","XPDIJ1")) D
 .N DIE,XCM,XCN,XCS,X
 .S DIE="^XTMP(""XPDI"",XPDA,""RTN"",""XPDIJ1"",",XCN=0,X="XPDIJ1"
 .X ^%ZOSF("SAVE")
 .S XCN=$$RTNUP^XPDUTL("XPDIJ1",2)
 N IEN,XPDI,XPD0,XPDSET,XPDABORT,XPDMENU,XPDQUIT,XPDVOL,X,Y,ZTRTN,ZTDTH,ZTIO,ZTDESC,ZTSK
 I $$NEWERR^%ZTER N $ETRAP,$ESTACK S $ETRAP="D ERR^XPDIJ"
 E  S X="ERR^XPDIJ",@^%ZOSF("TRAP")
 Q:'$D(^XPD(9.7,+$G(XPDA),0))  S XPD0=^(0)
 D INIT^XPDID
 ;disable options & protocols for setname, XPDSET=1/0^setname^out of order msg.
 S Y=$P(XPD0,U,8),XPDSET=+Y_U_$E(Y,2,99)_U_$S($L(Y):$P($G(^XTMP("XQOO",$E(Y,2,99),0)),U),1:"")
 ;hang the number of seconds given in 0;10
 I XPDSET D OFF^XQOO1($P(XPDSET,U,2)) I $P(XPD0,U,10) H ($P(XPD0,U,10)*60)
 ;XPDVOL is set only if they want to update other CPUs
 I $O(^XPD(9.7,XPDA,"VOL",0)) M XPDVOL=^XPD(9.7,XPDA,"VOL") D
 .S Y=0
 .F  S Y=$O(XPDVOL(Y)) Q:'Y  S $P(XPDVOL(Y,0),U,2,3)="^" K XPDVOL(Y,1)
 .;jobup RTN^XPDIJ(XPDA), to install routines on other CPU if Taskman is running
 .;check that taskman is running
 .D:$$TM^%ZTLOAD
 ..N XPDU,XPDY,XPDV,XPDV0,XPDVOL,ZTUCI,ZTCPU,ZTDESC,ZTRTN,ZTDTH,ZTIO,ZTSK
 ..X ^%ZOSF("UCI") S XPDU=$P(Y,","),XPDY=$P(Y,",",2),XPDV=0
 ..F  S XPDV=$O(^XPD(9.7,XPDA,"VOL",XPDV)) Q:'XPDV  S XPDV0=$P(^(XPDV,0),U) D:XPDV0'=XPDY
 ...S ZTUCI=XPDU,ZTDTH=$H,ZTIO="",ZTDESC="KIDS update CPUs "_XPDV0,ZTCPU=XPDV0,ZTRTN="EN^XPDCPU("_XPDA_","_XPDV_")"
 ...D ^%ZTLOAD
 ...;save task number under Volume set multiple
 ...Q:'$G(ZTSK)  K XPD
 ...S XPD(9.703,XPDV_","_XPDA_",",3)=ZTSK D FILE^DIE("","XPD")
 S Y=0
 ;XPDABORT can be set in pre or post install to abort install
 F  S Y=$O(^XPD(9.7,"ASP",XPDA,Y)) Q:'Y  S %=$O(^(Y,0)) D:%  Q:$D(XPDABORT)
 .;build volume multiple for each package
 .I $D(XPDVOL),'$D(^XPD(9.7,%,"VOL")) M ^("VOL")=XPDVOL
 .N XPD,XPDA,XPDNM,XPDV,XPDV0,XPDVOL,XPDX,XPDY,Y
 .S XPDA=%,XPDNM=$P($G(^XPD(9.7,XPDA,0)),U) D IN^XPDIJ1 Q:$D(XPDABORT)
 .;check status of other cpu jobs, do if not this volume
 .X ^%ZOSF("UCI") S XPDY=$P(Y,",",2),XPDV=0
 .F  S XPDV=$O(^XPD(9.7,XPDA,"VOL",XPDV)) Q:'XPDV  S XPDV0=^(XPDV,0) D:$P(XPDV0,U)'=XPDY
 ..;if completed time,write message and quit
 ..I $P(XPDV0,U,2) D BMES^XPDUTL(" Job on VOLUME SET "_$P(XPDV0,U)_" Completed.") Q
 ..;if job had no start time, write message and quit
 ..I '$P(XPDV0,U,3) D  I '$P(XPDV0,U,3)  D VOLERR($P(XPDV0,U),1) Q
 ...D BMES^XPDUTL(" Waiting for job on VOLUME SET "_$P(XPDV0,U)_" to start.")
 ...;hang 1 minute, try 5 times
 ...F %=1:1:5 H 60 S XPDV0=^XPD(9.7,XPDA,"VOL",XPDV,0) Q:$P(XPDV0,U,3)
 ..D BMES^XPDUTL(" Waiting for job on VOLUME SET "_$P(XPDV0,U)_" to complete.")
 ..S XPD=0,XPDX=$G(^XPD(9.7,XPDA,"VOL",XPDV,1))
 ..;check the last update node
 ..F  S Y=$P(^XPD(9.7,XPDA,"VOL",XPDV,0),U,2),X=$G(^(1)),XPD=XPD+1 Q:XPD>360!Y  S:X'=XPDX XPD=0,XPDX=X H 10
 ..;quit if we have a complete time
 ..I Y D BMES^XPDUTL(" Job on VOLUME SET "_$P(XPDV0,U)_" Completed.") Q
 ..D VOLERR($P(XPDV0,U),0)
 ;ZTREQ tells taskman to delete task
 I $G(ZTSK) S ZTREQ="@" D
 .;remove task # from Install File
 .N XPD S XPD(9.7,XPDA_",",5)="@"
 .D FILE^DIE("","XPD")
 ;quit if install was aborted
 I $D(XPDABORT) D EXIT^XPDID("Install Aborted!!"),^%ZISC Q
 ;put option back in order
 I $P(XPDSET,U,2)]"" D ON^XQOO1($P(XPDSET,U,2)) K ^XTMP("XQOO",$P(XPDSET,U,2))
 ;check if menu rebuild is wanted (only if option has been added)
 S IEN=""
 S IEN=$O(^XPD(9.7,XPDA,"QUES","B","XPO1",IEN))
 D:IEN
 .I ^XPD(9.7,XPDA,"QUES",IEN,1)  D
 ..D KIDS^XQ81
 ..;check if need to queue menu rebuild on other CPUs
 ..D:$O(^XPD(9.7,XPDA,"VOL",0))
 ...N XPDU,XPDY,XPDV,XPDV0,ZTUCI,ZTCPU
 ...X ^%ZOSF("UCI") S XPDU=$P(Y,","),XPDY=$P(Y,",",2),XPDV=0
 ...;loop thru VOLUMES SET and don't do current volume set
 ...F  S XPDV=$O(^XPD(9.7,XPDA,"VOL",XPDV)) Q:'XPDV  S XPDV0=$P(^(XPDV,0),U) D:XPDV0'=XPDY
 ....S ZTUCI=XPDU,ZTDTH=$H,ZTIO="",ZTDESC="Install Menu Rebuild",ZTCPU=XPDV0,ZTRTN="KIDS^XQ81" D ^%ZTLOAD
 ;
 ;clean up globals
 S Y=0
 F  S Y=$O(^XPD(9.7,"ASP",XPDA,Y)) Q:'Y  S XPDI=$O(^(Y,0)) D:XPDI
 .N Y,XPD
 .;kill transport global
 .K ^XTMP("XPDI",XPDI)
 .;update the status field
 .S XPD(9.7,XPDI_",",.02)=3
 .D FILE^DIE("","XPD")
 D EXIT^XPDID("Install Completed"),^%ZISC
 Q
 ;
SAVE(X) ;restore routine X
 N %,DIE,XCM,XCN,XCS
 S DIE="^XTMP(""XPDI"",XPDA,""RTN"",X,",XCN=0
 X ^%ZOSF("SAVE")
 Q
RTN(XPDA) ;restore all routines for package XPDA
 ;^XPD("XPDI",XPDA,"RTN",routine name)=0-install, 1-delete, 2-skip^checksum
 Q:$G(XPDA)=""
 N X,XPDI,XPDJ S XPDI=""
 F  S XPDI=$O(^XTMP("XPDI",XPDA,"RTN",XPDI)) Q:XPDI=""  S XPDJ=^(XPDI) D
 .;if we are doing VT graphic display, set counter
 .I $D(XPDIDVT) S XPDIDCNT=XPDIDCNT+1 D:'(XPDIDCNT#XPDIDMOD) UPDATE^XPDID(XPDIDCNT)
 .I 'XPDJ D SAVE(XPDI) Q
 .;set checksum to null, since routine wasn't loaded
 .I $P(XPDJ,U,2) S $P(^XTMP("XPDI",XPDA,"BLD",XPDBLD,"KRN",9.8,"NM",$P(XPDJ,U,2),0),U,4)=""
 .I $P(XPDJ,U)=1 S X=XPDI X ^%ZOSF("DEL")
 ;if graphic display, update full count
 I $D(XPDIDVT) D UPDATE^XPDID(XPDIDCNT)
 Q
 ;
VOLERR(V,F) ;volume set not updated,V=volume set, F=flag
 N XQA,XQAMSG,XPDMES
 S XPDMES(1)=" ",XPDMES(2)=" ** Job on VOLUME SET "_V_$S(F:" never started **",1:" has been idle for an hour.")
 S XPDMES(3)=" ** "_V_" has NOT been updated! **"
 S XQA(DUZ)="",XQAMSG="VOLUME SET "_V_" NOT updated for Install "_$E($P($G(^XPD(9.7,+$G(XPDA),0)),"^"),1,30)
 D MES^XPDUTL(.XPDMES),SETUP^XQALERT
 Q
 ;come here on error, record error in Install file and cleanup var.
ERR N XPDERROR,XQA,XQAMSG
 S XPDERROR=$$EC^%ZOSV
 ;record error, write message, reset terminal
 D ^%ZTER,BMES^XPDUTL(XPDERROR),EXIT^XPDID()
 S XQA(DUZ)="",XQAMSG="Install "_$E($P($G(^XPD(9.7,+$G(XPDA),0)),"^"),1,30)_" has encountered an Error."
 D SETUP^XQALERT G UNWIND^%ZTER
