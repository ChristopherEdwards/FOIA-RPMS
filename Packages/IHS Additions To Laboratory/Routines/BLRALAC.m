BLRALAC ;DAOU/ALA-Archive/Purge Lab Audit ;[ 12/19/2002  7:13 AM ]
 ;;5.2;LR;**1013,1015**;NOV 18, 2002
 ;
 ;**PROGRAM DESCRIPTION**
 ;  This program will archive and purge lab audit data.
 ;
EN ;  Determine archive filename,path, and last date run
 ;  Check for parameters in Audit sub-file, if null QUIT.
 I '$D(^BLRALAB(9009027.2,1,0)) G EXIT
 I $P($G(^BLRALAB(9009027.2,1,0)),U,2)<1 G EXIT
 S BLRAPTH=$P($G(^BLRALAB(9009027.2,1,0)),U,4) I BLRAPTH="" G EXIT
 S BLRADAYS=$P($G(^BLRALAB(9009027.2,1,0)),U,3)
 I BLRADAYS="" S BLRADAYS=7
 S BLRAEDT=$$FMADD^XLFDT($$DT^XLFDT(),-BLRADAYS)
 S BLRADT=$$HLDATE^HLFNC($$DT^XLFDT())
 S BLRANME="BLRA"_BLRADT_".txt"
 K ^TMP($J,"BLRA"),^TMP("BLRZ",$J)
 ;------------------------------------------------------------
DDD ;DATE PORTION OF ROUTINE
 S DDD1="",PID1=""
 F  S DDD1=$O(^BLRALAB(9009027,"B",DDD1)) Q:DDD1\1>BLRAEDT!(DDD1="")  D
 . F  S PID1=$O(^BLRALAB(9009027,"B",DDD1,PID1)) Q:PID1=""  D
 .. D GETS^DIQ(9009027,PID1,"*","R","^TMP(""BLRZ"",$J","ERR")
 ;THE AFOREMENTIONED CODE LOOPS THRU GLOBAL ^BLRALAB GETS ALL NODES
 ;OF THE DATA AND STORES THEM IN A TEMP GLOBAL ^TMP
 ;------------------------------------------------------------
FIL ;  Set file
 S BGLOB="^TMP(""BLRZ"",$J,9009027)"
 S BLRAY=$$OPEN^%ZISH(BLRAPTH,BLRANME,"A") I BLRAY=1 W !!,"Unable to open Host File Server to create archive file" Q
 U IO W "ACCESSION#^DATE/TIME STAMP^MENU OPTION^PATIENT^USER"
 S IEN="" F  S IEN=$O(@BGLOB@(IEN)) Q:'IEN  D
 . U IO W ! S FLD="" F  S FLD=$O(@BGLOB@(IEN,FLD)) Q:FLD=""  D
 .. U IO W @BGLOB@(IEN,FLD),"^"
 U IO W ! D CLOSE^%ZISH(BLRAY)
 S $P(^BLRALAB(9009027.2,1,0),U,5)=$$NOW^XLFDT()
 ;------------------------------------------------------------
DEL ;  Delete Records by date
 K DA,DIK
 S BDTM=""
 S DIK="^BLRALAB(9009027,"
 F  S BDTM=$O(^BLRALAB(9009027,"B",BDTM)) Q:BDTM\1>BLRAEDT!(BDTM="")  D
 . S DA="",DA(1)=BDTM
 . F  S DA=$O(^BLRALAB(9009027,"B",BDTM,DA)) Q:'DA  D ^DIK
 ;-----------------------------------------------------------
EXIT K BLRADT,BLRANME,BLRAPTH,DIR,Y,X,DIK,DA,IEN,%DT
 K BLRAY,BGLOB,FLD,DDD1,PID1,DIC,BDTM,BLRAEDT
 K ^TMP("BLRZ",$J),^TMP($J,"BLRAUSC"),^TMP($J,"BLRAU")
 Q
 ;
EN2 ;EP
 ;
 ;  This sub-routine will allow the site manager to setup
 ;  the Lab ESIG Audit Parameters.
 ;
 N Y,BLRAFIL
 K DIC,DIE,DIR,DA,DR
 ;  Find the Lab ESIG Audit Record
 W @IOF
 S DIC="^BLRALAB(9009027.2,"
 S DIC(0)="AELMQO"
 D ^DIC
 I Y<1 Q
 ;  Display the current parameters
 S DA=$P($G(Y),U)
 S BLRAFIL=$$EXTERNAL^DILFD(9009027.2,.01,"",$P($G(Y),U,2))
 D EN^DDIOL("","","!!")
 D EN^DDIOL("THE CURRENT LAB ESIG PARAMETERS ARE:","","!")
 S DR=0 D EN^DIQ
 ;  Allow to edit parameters
 S DIR(0)="Y"
 S DIR("A")="Would you like to edit these parameters "
 S DIR("B")="YES"
 D ^DIR
 I Y S DIE=DIC,DR="[BLRA AUDIT PARAMETERS]" D ^DIE
 I $$GET1^DIQ(9009027.2,DA,.02,"I")<1 D
 . D EN^DDIOL("     *** THE LAB ESIG AUDITING AND ARCHIVING IS TURNED OFF ***","","!!!")
 . D EN^DDIOL("     *** PLEASE UNSCHEDULE THE 'BLRA LAB ARCHIVE' OPTION IN TASKMAN ***","","!")
 E  D
 . D EN^DDIOL("     *** THE LAB ESIG AUDITING AND ARCHIVING IS TURNED ON ***","","!!!")
 . D EN^DDIOL("     *** PLEASE SCHEDULE THE 'BLRA LAB ARCHIVE' OPTION IN TASKMAN ***","","!")
 D EN^DDIOL("","","!!!!")
 K DIE,DIC,DIR,DR,DA
 Q
 ;
FORM ;EP - Check format of directory pathname
 ;
 S BLRAMVER=$$VERSION^%ZOSV(1)
 I BLRAMVER["UNIX" D
 . I X["\"!($E(X,1,1)'="/")!($E(X,$L(X),$L(X))'="/") K X D
 .. D EN^DDIOL("*** INCORRECT DIRECTORY PATHNAME! ***","","!!")
 E  D
 . I X["/"!($E(X,1,1)'?.A)!($E(X,2,2)'=":")!($E(X,3,3)'="\") K X D
 .. D EN^DDIOL("*** INCORRECT DIRECTORY PATHNAME! ***","","!!")
 K BLRAMVER
 Q
KILLX ;  EP
 S BLRAMVER=$$VERSION^%ZOSV(1)
 I BLRAMVER["UNIX" D
 . D EN^DDIOL("Enter UNIX directory pathnames in the following format: /usr3/IHS/RPMS0/","","!")
 E  D
 . D EN^DDIOL("Enter NT directory pathnames in the following format: C:\","","!")
 K BLRAMVER
 Q
