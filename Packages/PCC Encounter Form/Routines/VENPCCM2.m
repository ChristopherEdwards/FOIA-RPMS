VENPCCM2 ; IHS/OIT/GIS - MANAGE SYSTEM SYNCHRONIZATION PRINT DEAMON - ; 
 ;;2.6;PCC+;**1,3**;APR 03, 2012;Build 24
 ;
 ; 2.5 HEADR FILE COMPARISON NO LONGER NEEDED
 ;
TSYNC(IP,IPA) ; EP-PRINT TEMPLATE SYNC
 N TSN,STOP S STOP=0
 F TSN=1,2 Q:$G(STOP)  D TS1(TSN,$S(TSN=1:IP,1:IPA)) I IP=IPA Q
 K ^TMP("VEN TSYNC")
 Q
 ; 
TS1(TSN,IP) ; EP-PRINT SERVICE PRINT TEMPLATES
 N TS1,TS2,I,X,Y,RPMS,I,X,PCE,TIEN,OK,BAD,WARN
 S PCE=0,(TS1,TS2,RPMS,OK,BAD,WARN)=""
 F  S PCE=$O(^TMP("VEN TSYNC",$J,TSN,PCE)) Q:'PCE  S TS1=TS1_^(PCE)
 S TS1=$$LOW^XLFSTR(TS1)
TS2 ; EP-RPMS PRINT TEMPLATES
 S TIEN=0 F  S TIEN=$O(^VEN(7.41,TIEN)) Q:'TIEN  D
 . S X=$P($G(^VEN(7.41,TIEN,0)),U),Y=$P($G(^(0)),U,3)
 . I '$L(X)!('$L(Y)) Q
 . I RPMS'="" S RPMS=RPMS_U,TS2=TS2_U
 . S RPMS=RPMS_X,TS2=TS2_Y_"_template.doc"
 . Q
 S TS2=$$LOW^XLFSTR(TS2)
TSA ; ANALYZE PRINT TEMPLATES
 F I=1:1:$L(TS2,U) S X=$P(TS2,U,I) I $L(X),X'["HS2_",X'["hs2_" D
 . I (U_TS1_U)[(U_X_U) S:OK'="" OK=OK_U S OK=OK_X_" ("_$P(RPMS,U,I)_")" Q
 . I BAD'="" S BAD=BAD_U
 . S BAD=BAD_X_" ("_$P(RPMS,U,I)_")"
 . Q
 F I=1:1:$L(TS1,U) S X=$P(TS1,U,I) I $L(X),X'["HS2_",X'["hs2_",(U_TS2_U)'[(U_X_U) S:WARN'="" WARN=WARN_U S WARN=WARN_X
TSM ; STATUS MESSAGE
 I TSN=2 W ! S STOP='$$WAIT^VENPCCU I STOP Q
 I OK="",BAD="" W !?5,"VEN EHP EF TEMPLATES file is empty!  At least 1 template must exist." Q
 I OK="",WARN="" W !?5,"Print Service Templates folder is empty!  At least 1 template must exist." Q
 W !!,"Checking out templates on Print Server #",TSN," (",IP,")"
 I $L(OK)>1 D
 . W !?5,"PRINT TEMPLATE(S) properly synchronized on the RPMS and Print Servers:"
 . F I=1:1:$L(OK,U) W !?10,$P(OK,U,I)
 . Q
 I $L(BAD)>1 W ! S STOP='$$WAIT^VENPCCU Q:STOP  D
 . W ?5,"PRINT TEMPLATE(S) entered in the VEN EHP EF TEMPLATES file, but",!?5,"not registered on the Print Server:"
 . F I=1:1:$L(BAD,U) W !?10,$P(BAD,U,I)
 . W !?5,"Either remove TEMPLATE(S) from VEN EHP EF TEMPLATES file OR",!?5,"add TEMPLATE(S) to the PCC+ Print Service.  TO AVOID CRASHES, DO THIS NOW!"
 . I $G(CFLG)=0 S CFLG=1
 . Q
 I $L(WARN)>1 W ! S STOP='$$WAIT^VENPCCU Q:STOP  D
 . W ?5,"PRINT TEMPLATE(S) registered in the PCC+ Print Service but not",!?5,"in the VEN EHP EF TEMPLATES file:"
 . F I=1:1:$L(WARN,U) W !?10,$P(WARN,U,I)
 . W !?5,"This will not cause any tech problems, but you will not be able to access",!?5,"a PRINT TEMPLATE unless it is entered in the VEN EHP EF TEMPLATES file"
 . Q
 Q
 ; 
FS(FSN) ; EP-GET FILE  FROM GLOBALS AND RETURN THE STRING
 N STG,I,X,PCE
 S PCE=0,STG=""
 F  S PCE=$O(^TMP("VEN FSYNC",$J,FSN,PCE)) Q:'PCE  S STG=STG_^(PCE)
 Q STG
 ;
HEADER(Z,MN) ; EP - VALIDATE HEADER FILES FOR VER 2.7
 S Z=2
 I '$L($G(MN)) Q
 N X,Y,%,IP,IPA,RH,PH,GBL,H,PATH,CFIGIEN,TOT,POP,SOCK,PPATH,TARGET,MSG,N,A,B,C,RSTG
 S CFIGIEN=$$CFG^VENPCCU
 I 'CFIGIEN W !?7,"Unable to locate thePCC+ configuration!" Q
 S GBL=$NA(^TMP("VEN HVAL",$J)) K @GBL
 S PATH=$G(^VEN(7.5,CFIGIEN,2))
 I PATH="" W !?7,"Unable to find the Path to the header files on the RPMS Server!" Q
 S PPATH="c:\program files\ilc\ilc forms print service\templates\"
 S RH=MN_"header.txt",PH=MN_"_header.txt",TARGET=PPATH_PH,MSG="FILE_SEND^"_TARGET
 S %=$G(^VEN(7.5,CFIGIEN,11)),IP=$P(%,U,1)
 I IP="" W !?7,"Unable to find the Path to the header files on the Print Server(s)!" Q
 S IPA=$P(%,U,2) I IPA="" S IPA=IP
 S SOCK=$P(%,U,3) I SOCK="" S SOCK=5143
 S Z=1 ; FROME HERE ON, ERRORS ARE NOT FATAL
 S POP=$$OPN^VENPCCP(PATH,RH,"R","R RSTG") ; GET RPMS HEADER FILE
 I POP!($G(RSTG)="") W !?7,"Unable to find the header file on the RPMS Server!"  K @GBL Q
 F TOT=1:1 S X=$E(RSTG,1,250),RSTG=$E(RSTG,251,99999),@GBL@(1,TOT)=X I RSTG="" Q  ; RPMS HEADER GLOBAL
 D GET^VENPCCM1(IP,SOCK,MSG,"^TMP(""VEN HVAL"",$J,2)")
 I '$D(@GBL@(2,1)) W !?7,"Unable to find the header file on Print Server ",IP K @GBL Q
 I IP=IPA G HCMP
 D GET^VENPCCM1(IPA,SOCK,MSG,"^TMP(""VEN HVAL"",$J,3)")
 I '$D(@GBL@(2,1)) W !?7,"Unable to find the header file on Print Server ",IPA K @GBL Q
HCMP S N=0,%=0 F  S N=$O(@GBL@(1,N)) Q:'N  D  I % Q
 . S A=$G(@GBL@(1,N)),B=$G(@GBL@(2,N)),C=$G(@GBL@(3,N))
 . S X=$L(A) I X<250 S B=$E(B,1,X) I IP'=IPA S C=$E(C,1,X)
 . I A'=B S %=1 W !?7,"The header file on RPMS server does not match the file on ",IP
 . I IP'=IPA,A'=C S %=1 W !?7,"The header file on RPMS server does not match the file on ",IPA
 . Q
 I '% W !?7,"Header files valid/synchronized on RPMS Server & Print Server(s)",! S Z=0
 K @GBL
 Q
 ; 
HDR(IP,IPA,PHDR,COMP) ; EP-COMPARE HEADER FILES
 N FSN,CFIGIEN,POP,RSTG,PS,PATH
 S CFIGIEN=$$CFG^VENPCCU
 S PATH=$G(^VEN(7.5,CFIGIEN,2)) I PATH="" W !,"Unable to find the Path to the header files on the RPMS Server!" G HDRQ
 S POP=$$OPN^VENPCCP(PATH,COMP,"R","R RSTG")
 I POP W !,"Unable to find the header file '"_COMP_"' on the RPMS Server!" G HDRQ
 F FSN=1,2 S PS="Print Server #"_FSN_" ("_$S(FSN=1:IP,1:IPA)_")" D HDR1(PS,RSTG,PHDR,COMP) I IP=IPA Q
HDRQ K ^TMP("VEN FSYNC",$J)
 Q
 ; 
HDR1(PS,RSTG,PHDR,COMP) ;
 W !
 N PSTG,X,Y,%
 S PSTG=$$FS(FSN)
 I PSTG="" W !,"Unable to locate the header file '",PHDR,"' on ",PS
 I $P(PSTG,$C(13))'=RSTG W !,"The header file '",PHDR,"' on ",PS,!,"does not match the header file on the RPMS Server '",COMP,"'." Q
 I $L(RSTG,U)*2'=($L(PSTG,U)+1) W !,"Invalid header file '",PHDR,"' on ",PS Q
 W !,"Header files '",PHDR,"' on ",PS,!,"and '",COMP,"' on the RPMS Server are valid and synchronized."
 Q
 ; 
FILE(FILE,IP) ; EP-GIVEN A PATHFILE AND IP, RETURN THE FILE IN A STRING
 N I,START,%,PCE,STG,CFIGIEN,SOCK
 I $D(SOCKET) S SOCK=SOCKET
 I '$D(SOCK) S SOCK=$P($G(^VEN(7.5,$$CFG^VENPCCU,11)),U,3) I 'SOCK Q ""
 S ^TMP("VEN SYNC",$J)="FILE_GET"_U_FILE_U_IP_U_SOCK
 I '$D(^TMP("VEN TASK")) S START=1 X "J"_" "_U_"VENPCCP" ; START THE PRINT DEAMON IF IT IS NOT RUNNING
 F I=1:1:30 Q:$D(^TMP("VEN GETFILE",$J,0))  H 1
 I '$D(^TMP("VEN GETFILE",$J,0)) Q ""
 I $G(START) D KILLTASK^VENPCCP ; STOP THE PRINT DEAMON IF IT WASN'T RUNNING BEFORE THIS REQUEST
 S STG=^TMP("VEN GETFILE",$J,0) I STG'="" K ^(0) Q STG
 S PCE=0
 F  S PCE=$O(^TMP("VEN GETFILE",$J,PCE)) Q:'PCE  S STG=STG_^(PCE)
 K ^TMP("VEN GETFILE")
 Q STG
 ; 
TEMPLATE(IP) ; EP-RETURN THE TEMPLATE LIST FROM A PRINT SERVER
 N I,START,%,SOCK,PCE,STG,CFIGIEN
 I $G(SOCKET) S SOCK=SOCKET
 I '$D(SOCK) S SOCK=$P($G(^VEN(7.5,$$CFG^VENPCCU,11)),U,3) I 'SOCK Q ""
 S ^TMP("VEN SYNC",$J)="TEMP_GET"_U_IP_U_SOCK
 I '$D(^TMP("VEN TASK")) S START=1 X "J"_" "_U_"VENPCCP" ; START THE PRINT DEAMON IF IT IS NOT RUNNING
 F I=1:1:30 Q:$D(^TMP("VEN GETTEMP",$J,0))  H 1
 I '$D(^TMP("VEN GETTEMP",$J,0)) Q ""
 I $G(START) D KILLTASK^VENPCCP ; STOP THE PRINT DEAMON IF IT WASN'T RUNNING BEFORE THIS REQUEST
 S STG=^TMP("VEN GETTEMP",$J,0) I STG'="" K ^(0) Q STG
 S PCE=0
 F  S PCE=$O(^TMP("VEN GETTEMP",$J,PCE)) Q:'PCE  S STG=STG_^(PCE)
 K ^TMP("VEN GETTEMP")
 Q STG
 ; 
PGRP(IP) ; EP-RETURN THE PRINT GROUP LIST FROM A PRINT SERVER
 N I,START,%,SOCK,PCE,STG,CFIGIEN
 I $D(SOCKET) S SOCK=SOCKET
 I '$D(SOCK) S SOCK=$P($G(^VEN(7.5,$$CFG^VENPCCU,11)),U,3) I 'SOCK Q ""
 S ^TMP("VEN SYNC",$J)="PG_GET"_U_IP_U_SOCK
 I '$D(^TMP("VEN TASK")) S START=1 X "J"_" "_U_"VENPCCP" ; START THE PRINT DEAMON IF IT IS NOT RUNNING
PGG F I=1:1:30 Q:$D(^TMP("VEN GETPG",$J,0))  H 1
 I '$D(^TMP("VEN GETPG",$J,0)) Q ""
 I $G(START) D KILLTASK^VENPCCP ; STOP THE PRINT DEAMON IF IT WASN'T RUNNING BEFORE THIS REQUEST
 S STG=^TMP("VEN GETPG",$J,0) I STG'="" K ^(0) Q STG
 S PCE=0
 F  S PCE=$O(^TMP("VEN GETPG",$J,PCE)) Q:'PCE  S STG=STG_^(PCE)
 K ^TMP("VEN GETPG")
 Q STG
 ; 
