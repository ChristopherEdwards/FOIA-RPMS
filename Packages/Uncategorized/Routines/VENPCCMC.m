VENPCCMC ; IHS/OIT/GIS - PCC+ INSTALLATION CHECKER ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ;
 ; 
INTRO ; WELCOME
 N %,X,%Y,BACK,BYP,CDFN,CFG,CFIGIEN,CFLG,CIEN,CMED,DA,DEM,DP,GP,VER,EXRX,ART,AUTO,SM
 N I,IP,MON,MV,OS,PATH,PHS,POP,PULL,SOCK,STG,TIEN,TOT,TYPE,UNI,X,Y,SUB,IPFLG,CNT
 D ^XBCLS W !,?20,"*****  PCC+ INSTALLATION CHECKER  *****",!!
 W "NOTE: This utility does NOT update the PCC+ configuration files.",!," It simply reports on the status of the current installation."
 W !!,"When you see the '<>' symbol, press the <ENTER> key to continue scrolling..."
ENV ; CHECK THE OPERATING ENVIRONMENT
CSC26 I +$P($T(VENPCCMC+1),";",3)=2.6 W !!,"Now let's check connectivity and the Windows components of PCC+",! D CSC^VENPCCQX(.CNT) D PAUSE^VENPCCU G CPC ; CSC FOR VER 2.6
 W !!!!!,"First, let's check the operating environment..."
 I $$OS^VENPCCME W !,"Unable to proceed because the operating system is not defined for PCC+!" Q
CMP ; CHECK FOR REQUIRED COMPONENTS
 ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 W ! I $$WAIT^VENPCCU
 D ^XBCLS
 W !!,"Next, let's make sure that all required components have been installed "
 D COMP^VENPCCME(.OUT)
 W !,OUT
 I OUT'["OK" D PAUSE^VENPCCU Q  ; KEY COMPONENTS ARE MISSING.  STOP HERE
 W ! I '$$WAIT^VENPCCU Q
CPC ; CHECK PRIMARY CONFIGURATION
 D ^XBCLS
 W !,"Checking the primary configuration..."
 S CFLG=0
 D CK^VENPCCME(.CFLG)
 I CFLG W !,"Please make all suggested corrections and then run this utility again" D PAUSE^VENPCCU Q
 W ! I '$$WAIT^VENPCCU Q
CCPS ; CHECK CONNECTION TO THE PRINT SERVERS
 D ^XBCLS
 W !,"Checking connectivity to the PCC+ print server(s)..."
 S IPFLG=0 D IP(.IPFLG)
 I IPFLG D  Q
 . W !!,"Make sure the PCC+ Print Service is running on the print server(s)"
 . W !,"If this is not successful, fix the LAN connection to the print server(s)."
 . W !,"Then run this utility again."
 . D PAUSE^VENPCCU
 . Q
 I 'IPFLG W !,"Connectivity is OK",!
 W ! I '$$WAIT^VENPCCU Q
CEF ; CHECK ENCOUNTER FORMS
 D ^XBCLS
 W !,"Checking PCC+ ENCOUNTER FORMS..."
 W !,"Only essential properties and template synchronization will be checked now."
 W !,"For managing all other TEMPLATE properties, use the TCU option.",!
 S CFLG=0
 D EF(.CFLG)
 I CFLG W !,"Please make all suggested corrections and then run this utility again" Q
 W ! I $$WAIT^VENPCCU
 W !!,"Checking PCC+ encounter form synchronization."
 D TEMPLATE^VENPCCM1
 I CFLG W !,"Please make all suggested corrections and then run this utility again" Q
 W ! I '$$WAIT^VENPCCU
 D ^XBCLS
CPG ; CHECK PRINT GROUPS
 D PG(.CFLG)
 I CFLG W !,"Please make all suggested corrections and then run this utility again" Q
 W !!,"Now let's check print group synchronization.",!
 D PG^VENPCCM1
 I CFLG W !,"Please make all suggested corrections and then run this utility again" Q
 W ! I '$$WAIT^VENPCCU
 D ^XBCLS
CCL ; CHECK CLINICS
 W !,"Checking PCC+ CLINICS..."
 W !,"Only the essential properties will be checked now."
 W !,"For managing all other CLINIC properties, use the TCC option.",!
 D CL(.CFLG)
 I CFLG W !,"Please make all suggested corrections and then run this utility again" Q
 W ! I '$$WAIT^VENPCCU
 D ^XBCLS
CHF ; CHECK HEADER FILES
 I $P($G(^VEN(7.5,$$CFG^VENPCCU,13)),U) W !,"New PCC+ data format IN USE.  No need for header files." D PAUSE^VENPCCU Q
 W !!,"Checking HEADER FILES..."
 D HF(.CFLG)
 I CFLG W !,"Please make all suggested corrections and then run this utility again"
 E  W !,"Header Files have been validated." W !!!,"CONGRATULATIONS!!!  Your PCC+ system has been valdated"
 D PAUSE^VENPCCU
 Q
 ; 
IP(IPFLG) ; EP - CHECK IP AND SOCKET
 N POP,X,I,ACK
 I $G(SOCK)'=5143 W !?5,"CURRENT TCP SOCKET IS INVALID.  IT SHOULD BE '5143'" S IPFLG=1 Q
 F I=1,2 S X=IP(I) D  Q:IP(1)=IP(2)  I IPFLG Q
 . I X'?1.3N1"."1.3N1"."1.3N1"."1.3N W !?5,"IP address ",I," is invalid.  Current address: ",X S IPFLG=1 Q
 . S %=$$OTCP^VENPCCP(X,5143)
 . I % W !?5,"Failed to establish a TCP/IP connection to ",X S IPFLG=1 Q
 . W ("ABOUT") W:$G(CACHE) ! K ACK R ACK:15
 . E  W !,"Print service not responding on ",IP(I) D CTCP^VENPCCP Q
 . I ACK'=0,ACK'=-7 W !,"Print service not responding on ",IP(I)
 . D CTCP^VENPCCP
 . W !?5,"Connection to print service on ",IP(I)," validated (Ver. "
 . W $S(ACK=0:"2.5",1:"2.2"),")."
 . Q
 Q
 ; 
EF(CFLG) ; EP-ENCOUTER FORMS
 N TOT,TIEN
 S TOT=0
 I '$O(^VEN(7.41,0)) W !?5,"NO ENCOUNTER FORM TEMPLATES HAVE BEEN ENTERED YET!" Q
 S TIEN=0 F  S TIEN=$O(^VEN(7.41,TIEN)) Q:'TIEN  I $D(^VEN(7.41,TIEN,0)) D
 . D ECK(TIEN)
 . S TOT=TOT+1
 . I '(TOT#10) W ! I $$WAIT^VENPCCU
 Q
 ;
ECK(TIEN) ; EP - CK TEMPLATE
 ; BAR CODE CHARACTER CHECK NO LONGER REQUIRED IN 2.2
 N STG,HDR,TMN,BAR,X,Y,NAME
 S NAME=$P($G(^VEN(7.41,TIEN,0)),U) W !?5,NAME
 S STG=^VEN(7.41,TIEN,0),HDR=$P(STG,U,2),TMN=$P(STG,U,3),BAR=$P(STG,U,4),CFLG=0
 I HDR'="ef",HDR'="25",HDR'="pn",HDR'="fp" W !?7,"Invalid/missing header mnemonic." S CFLG=1
 I TMN="" W !?7,"Missing template mnemonic" S CFLG=1 Q
 I TMN'?1.10L W !?7,"Invalid template mnemonic.  Must be 1-10 lowercase letters - no spaces." S CFLG=1 Q
 S X=0 F  S X=$O(^VEN(7.41,X)) Q:'X  I X'=TIEN S Y=$P($G(^VEN(7.41,X,0)),U,3) I Y=TMN W !?7,"The mnemonic '"_Y_"' is not unioque." S CFLG=1 Q
 I 'CFLG W "  <= OK"
 Q
 ; 
HF(CFLG) ; EP - HEADER FILES
 N CFIGIEN,PATH,HF,IPI,IPX,HSTG,X
 S CFIGIEN=$$CFG^VENPCCU
 S PATH=$G(^VEN(7.5,CFIGIEN,2))
 I PATH="" W !,"Unable to find the Path to the header files on the RPMS Server!" Q
 F HF="efheader.txt","25header.txt","hsheader.txt" D
 . I $$FIND^VENPCCP(PATH,HF) W !,"Header file ",HF," has been validated" Q
 . W !,"Header file '",HF,"'can not be located in ",PATH
 . Q
 W !!,"Accessing information...",!
 S IPX=2 I IP(1)=IP(2) S IPX=1
 F HF="ef_header.txt","25_header.txt","hs_header.txt" F IPI=1:1:IPX D
 . S HSTG=$$FILE^VENPCCM2("c:\program files\ilc\ilc forms print service\templates\"_HF,IP(IPI))
 . I $L(HSTG)>1 W !,HF," is properly synchronized on Print Server #"_IPI Q
 . W !,HF," has not been loaded on Print Server #",IPI S CFLG=1
 . Q
 Q  ; HEADER FILE COMPARISON NO LONGER REQUIRED
 ; 
PG(CFLG) ; EP-PRINT GROUPS
 W !!,"CHECKING PRINT GROUPS..."
 I '$O(^VEN(7.4,0)) W !?5,"NO PRINT GROUPS HAVE BEEN ENTERED YET!" Q
 S X=0 F  S X=$O(^VEN(7.4,X)) Q:'X  S Y=$P($G(^VEN(7.4,X,0)),U,2) I Y Q
 I 'Y W !?7,"No MEDICAL RECORDS print group has been defined." S CFLG=1 Q
 S (X,TOT)=0 F  S X=$O(^VEN(7.4,X)) Q:'X  D
 . W !?5,$P($G(^VEN(7.4,X,0)),U)
 . I $P(^VEN(7.4,X,0),U,2) W " (MEDICAL RECORDS PRINT GROUP)" S TOT=TOT+1
 . I $P($G(^VEN(7.4,X,0)),U)'["_" W !,?7,"Name not is recommended format: Facility_Group e.g., 'GIMC_ORTHO'"
 . E  W "  <=OK"
 . Q
 I TOT>1 W !,"There is more than one Medical Records print group!" S CFLG=1 Q
 Q
 ; 
CL(CFLG) ; EP-CLINICS
 N DIC,DIE,DA,DR,X,CIEN
 S CIEN=0,TOT=0
 F TOT=1:1 S CIEN=$O(^VEN(7.95,CIEN)) Q:'CIEN  D CCK(CIEN)
 F X="TELEPHONE ENCOUNTER","MEDICAL RECORDS" I '$D(^VEN(7.95,"B",X)) D
 . S NAME=X,X=""""_X_""""
 . S DIC="^VEN(7.95,",DIC(0)="L",DLAYGO=19707.95
 . D ^DIC I Y=-1 Q
 . S CIEN=+Y
 . S %=$O(^VEN(7.22,"B",NAME,0))
 . I % D  I 1 ; JUST NEED TO MAKE THE CONNECTION
 .. S DIE="^VEN(7.95,",DA=CIEN,DR="1.01////"_%_";2.07////1"
 .. L +^VEN(7.95,DA):0 D ^DIE L -^VEN(7.95,DA)
 .. Q
 . E  D
 .. S X=""""_NAME_"""",DIC="^VEN(7.22,",DIC(0)="L",DLAYGO=19707.22
 .. D ^DIC I Y=-1 Q  ; UPDATE THE QUEUE TYPE FILE
 .. S DIE="^VEN(7.95,",DA=CIEN,DR="1.01////"_+Y_";2.07////1"
 .. L +^VEN(7.95,DA):0 D ^DIE L -^VEN(7.95,DA) ; MAKE THE CONNECTION
 .. Q
 . W !?5,X," has been added to the VEN EHP CLINIC file & VEN QUEUE TYPE file."
 . Q
 D ^XBFMK
 Q
 ; 
CCK(CIEN) ; EP-CHECK CLINIC
 N A,B,NAME,DEPT,PGRP,DPRV,DEF,DHS,INST,QUE,QIEN,DIC,DIE,DA,DR,X,Y,%
 S A=$G(^VEN(7.95,CIEN,0)),B=$G(^VEN(7.95,CIEN,2))
 S NAME=$P(A,U),CFLG=0
 S TOT=TOT+1 I '(TOT#10) W ! I $$WAIT^VENPCCU
 W !?5,NAME W:$P(B,U,3) " (TRIAGE MODULE ACTIVE)"
 I NAME'="MEDICAL RECORDS",NAME'="TELEPHONE ENCOUNTER",NAME'="CHART REVIEW"
 E  W "  <=OK" Q
 I NAME'[" - " W !?10,"USE VALID NAME FORMAT: 'Facility - Clinic'; e.g., PIMC - PEDIATRICS"
 S DEPT=$P(A,U,4) I DEPT="" W !?10,"UNKNOWN CLINIC STOP" S CFLG=1
 E  I '$D(^DIC(40.7,DEPT,0)) W !?10,"INVALID CLINIC STOP" S CFLG=1
 S PGRP=$P(B,U,1) I PGRP="" W !?10,"UNKNOWN PRINT GROUP" S CFLG=1
 E  I '$D(^VEN(7.4,PGRP,0)) W !?10,"INVALID PRINT GROUP" S CFLG=1
 S DPRV=$P(B,U,2) I DPRV="" W !?10,"UNKNOWN DEFAULT PROVIDER" S CFLG=1
 E  I '$D(^VA(200,DPRV,0)) W !?10,"INVALID DEFAULT PROVIDER" S CFLG=1
 S DEF=$P(B,U,5) I DEF="" W !?10,"UNKNOWN DEFAULT ENCOUNTER FORM" S CFLG=1
 E  I '$D(^VEN(7.41,DEF,0)) W !?10,"INVALID DEFAULT ENCOUTER FORM" S CFLG=1
 S INST=$P(B,U,4) I INST="" W !?10,"UNKNOWN MEDICAL RECORDS LOCATION" S CFLG=1
 E  I '$D(^DIC(4,INST,0)) W !?10,"INVALID MEDICAL RECORDS LOCATION" S CFLG=1 G CCK1
 S QIEN=$P($G(^VEN(7.95,CIEN,1)),U) I 'QIEN D  ; QUEUE TYPE FILE LINKAGE
 . S %=$O(^VEN(7.22,"B",NAME,0))
 . I % D  Q  ; JUST NEED TO MAKE THE CONNECTION
 .. S DIE="^VEN(7.95,",DA=CIEN,DR="1.01////"_%
 .. L +^VEN(7.95,DA):0 D ^DIE L -^VEN(7.95,DA)
 .. W !?10,"Clinic registered in QUEUE TYPE file"
 .. Q
 . S X=""""_NAME_"""",DIC="^VEN(7.22,",DIC(0)="L",DLAYGO=19707.22
 . D ^DIC I Y=-1 Q  ; UPDATE THE QUEUE TYPE FILE
 . S DA=+Y S DIE="^VEN(7.95,",DA=CIEN,DR="1.01////"_DA
 . L +^VEN(7.95,DA):0 D ^DIE L -^VEN(7.95,DA) ; MAKE THE CONNECTION
 . D ^XBFMK
 . W !?10,"QUEUE TYPE file has been updated"
 . Q
CCK1 I $P(B,U,7) W !?10,"INACTIVE CLINIC" Q
 I 'CFLG W "  <=OK"
 Q
 ; 
