VENPCCM1 ; IHS/OIT/GIS - MANAGE SYSTEM SYNCHRONIZATION ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ; 2.5 HEADER FILE SYNC NO LONGER REQUIRED
 ;
PG ; EP-PRINT GROUP SYNCHRONIZATION
 N IP,IPA,SOCK
 I '$$VAR Q
 K ^TMP("VEN MSG") S ^TMP("VEN SYNC",$J)="PRINT_GRP_SYNC"
 I $$RUN D PSYNC(IP,IPA)
 Q
 ; 
TEMPLATE ; EP-TEMPLATE SYNCHRONIZATION
 N IP,IPA,SOCK
 I '$$VAR Q
 K ^TMP("VEN MSG") S ^TMP("VEN SYNC",$J)="TEMPLATE_SYNC"
 I $$RUN D TSYNC^VENPCCM2(IP,IPA)
 Q
 ; 
HEADER ; EP-SYNC HEADER FILES
 N CFIGIEN,PATH,POP,HF,RSTG
 S CFIGIEN=$$CFG^VENPCCU
 S PATH=$G(^VEN(7.5,CFIGIEN,2))
 I PATH="" W !,"Unable to find the Path to the header files on the RPMS Server!" Q
 F HF="efheader.txt","25header.txt","hsheader.txt" D
 . I $$FIND^VENPCCP(PATH,HF) W !,"Header file ",HF," has been validated" Q
 . W !,"Header file '",HF,"'can not be located in ",PATH
 . Q
 Q  ; HEADER FILE COMPARISON NO LONGER REQUIRED
 W !!,"Checking encounter form header files....."
 D HDR("ef_header.txt","efheader.txt")
 W !!,"Checking health summary header file......."
 D HDR("hs_header.txt","hsheader.txt")
 Q
 ; 
HDR(X,Y) ; EP-COMPARE HEADER FILES
 ; DEAD CODE
 N IP,IPA,SOCK,PHDR
 I '$$VAR Q
 S X="c:\program files\ilc\ilc forms print service\templates\"_X
 K ^TMP("VEN MSG") S ^TMP("VEN SYNC",$J)="FILE_SEND"_U_X
 S PHDR=$P(X,"\",$L(X,"\"))
 I $$RUN D HDR^VENPCCM2(IP,IPA,PHDR,Y)
 Q
 ; 
VAR() ; EP-CREATE LOCAL VARIABLES
 N CFIGIEN
 S CFIGIEN=$$CFG^VENPCCU I 'CFIGIEN Q 0
 S IP=$P($G(^VEN(7.5,CFIGIEN,11)),U) I IP="" Q 0
 S IPA=$P($G(^VEN(7.5,CFIGIEN,11)),U,2) I IPA="" S IPA=IP
QQ ; S (IP,IPA)="161.223.80.111" ; CROW TEST
 S SOCK=$P($G(^VEN(7.5,CFIGIEN,11)),U,3) I 'SOCK Q 0
 Q 1
 ; 
RUN() ; EP-REQUEST SPECIAL PRINT SERVICE FUNCTIONS
 N I,START,%,A,B,OUT S OUT=0
 I '$D(^TMP("VEN TASK")) S START=1 X "J"_" "_U_"VENPCCP" ; START THE PRINT DEAMON IF IT IS NOT RUNNING
 W !!,"Accessing information..."
 F I=1:1:99 Q:$D(^TMP("VEN MSG",$J,"OK"))  H 1 W "."
 I '$D(^TMP("VEN MSG",$J,"OK")) W !,"Unable to get required information from the Print Server(s).  Request terminated!"  G FIN
 S OUT=1
 I $G(^TMP("VEN MSG",$J,"OK")) S %=^("OK"),A=+%,B=$P(%,U,2) W !,"Unable to get required information from Print Server #",A," (",B,")"
FIN I $G(START) K ^TMP("VEN TASK") ; STOP THE PRINT DEAMON IF IT WASN'T RUNNING BEFORE THIS REQUEST
 K ^TMP("VEN MSG")
 Q OUT
 ; 
SYNC ; EP-START SPECIAL PRINT SERVICE FUNCTIONS ; RUNS IN BACKGROUND
 N MSG,J,IP,IPA,SOCK,FUNC,COMP,POP,TMP,PSN,%,GBL
 I '$$VAR Q
 S J=$O(^TMP("VEN SYNC",0)) I 'J Q
 S MSG=^TMP("VEN SYNC",J) K ^(J)
SMSG ; EP-ANALYZE SYNC MESSAGE
 I MSG="PRINT_GRP_SYNC" S FUNC="VEN PSYNC"
 I MSG="TEMPLATE_SYNC" S FUNC="VEN TSYNC"
 I $P(MSG,U)="FILE_SEND" S FUNC="VEN FSYNC"
 I $P(MSG,U)="FILE_GET" S %="FILE_SEND"_U_$P(MSG,U,2) D GET($P(MSG,U,3),$P(MSG,U,4),%,("^TMP(""VEN GETFILE"","_J_")")) Q
 I $P(MSG,U)="TEMP_GET" D GET($P(MSG,U,2),$P(MSG,U,3),"TEMPLATE_SYNC",("^TMP(""VEN GETTEMP"","_J_")")) Q
 I $P(MSG,U)="PG_GET" D GET($P(MSG,U,2),$P(MSG,U,3),"PRINT_GRP_SYNC",("^TMP(""VEN GETPG"","_J_")")) Q
 I '$L($G(FUNC)) Q
 F PSN=1,2 D  I IP=IPA Q
 . S TMP="^TMP("""_FUNC_""","_J_","_PSN_")" K @TMP
 . S %=$S(PSN=1:IP,1:IPA)
 . D GET(%,SOCK,MSG,TMP)
 . Q
 S TMP="^TMP("""_FUNC_""","_J_")",GBL="^TMP(""VEN MSG"","_J_",""OK"")" K @GBL
 I '$D(@TMP@(1)),'$D(^(2)) Q
 I IP'=IPA,'$D(@TMP@(2)) S @GBL=2 Q
 I '$D(@TMP@(1)) S @GBL=1 Q
 S @GBL=""
 Q
 ; 
GET(IP,SOCK,MSG,TMP) ; EP-GET DATA FROM PRINT SERVER AND STORE IT IN TMP
 N ACK,POP,LEN,TOT,BYTES,CACHE
 S (TOT,BYTES)=0
 S CACHE=($$VEN^VENPCCU=2)
 S POP=$$OTCP^VENPCCP(IP,SOCK) I POP S @TMP@(0)="Unable to access the print server" Q
 W MSG W:CACHE !
 R ACK:30 E  S @TMP@(0)="Print service does not respond!" Q
 I ACK=-8 S @TMP@(0)="Unable to locate this file!" D CTCP^VENPCCP Q
 I ACK'?1"START^"1.N S @TMP@(0)="Print service unable to respond to this command!" D CTCP^VENPCCP Q
 S LEN=$P(ACK,U,2) I 'LEN S @TMP@(0)="Print Service error!" D CTCP^VENPCCP Q
 F  W 1 W:CACHE ! R ACK:30 S:'$T ACK="STOP" Q:ACK="STOP"  S TOT=TOT+1,@TMP@(TOT)=$E(ACK,1,250),%=$E(ACK,251,505),BYTES=BYTES+$L(ACK) I $L(%) S TOT=TOT+1,@TMP@(TOT)=%
 I LEN'=BYTES W -1 W:CACHE ! R ACK:2  S @TMP@(0)="Print Service transmission error.  Try again soon!" D CTCP^VENPCCP Q
 E  K ACK W 0 W:CACHE ! R ACK:2 S @TMP@(0)=""
 D CTCP^VENPCCP
 Q
 ; 
TEST D GET("127.0.0.1",5143,"PRINT_GRP_SYNC","^TMP(""XXX"")") Q
PSYNC(IP,IPA) ; EP-PRINT GRP SYNC
 N PSN,STOP,PS1,PS2,RPMS,I,X,Y,PCE,PIEN,OK,BAD,WARN,STG
 S STOP=0
 F PSN=1,2 Q:$G(STOP)  D PS1(PSN,$S(PSN=1:IP,1:IPA)),PSM(PSN) I IP=IPA Q
 K ^TMP("VEN PSYNC")
 Q
 ; 
PS1(PSN,IP) ; EP-PRINT SERVICE PRINT GROUPS
 S PCE=0,(PS1,PS2,RPMS,OK,BAD,WARN,STG)=""
 F  S PCE=$O(^TMP("VEN PSYNC",$J,PSN,PCE)) Q:'PCE  S STG=STG_^(PCE)
 F I=1:1:$L(STG,U) S X=$P(STG,U,I) D
 . I PS1'="" S PS1=PS1_U,PS2=PS2_U
 . S PS1=PS1_$P(X,"|")
 . S PS2=PS2_$P(X,"|",2)
 . Q
PS2 ; RPMS PRINT GROUPS
 S PIEN=0 F  S PIEN=$O(^VEN(7.4,PIEN)) Q:'PIEN  S X=$P($G(^VEN(7.4,PIEN,0)),U) D
 . I RPMS'="" S RPMS=RPMS_U
 . S RPMS=RPMS_X
 . Q
PSA ; ANALYZE PRINT GROUPS
 F I=1:1:$L(RPMS,U) S X=$P(RPMS,U,I) I $L(X) D
 . I (U_PS1_U)[(U_X_U) S:OK'="" OK=OK_U S OK=OK_X Q
 . I BAD'="" S BAD=BAD_U
 . S BAD=BAD_X
 . Q
 F I=1:1:$L(PS1,U) S X=$P(PS1,U,I),Y=$P(PS2,U,I) I $L(X),(U_RPMS_U)'[(U_X_U) S:WARN'="" WARN=WARN_U S WARN=WARN_X I $L(Y) S WARN=WARN_" ("_Y_")"
 Q
 ; 
PSM(PSN) ; EP-STATUS MESSAGE
 I PSN=2 W ! S STOP='$$WAIT^VENPCCU I STOP Q
 W !!,"Checking files in Print Server #",PSN," (",$S(PSN=1:IP,1:IPA),")"
 I OK="",BAD="" W !?5,"The VEN EHP PRINTER GROUP FILE is empty!  At least 1 printer group must exist." Q
 I OK="",WARN="" W !?5,"There are no Printer Groups registered on the Print Server!",!,"  At least 1 Printer Group must exist." Q
 I $L(OK)>1 D
 . W !?5,"PRINTER GROUP(S) properly synchronized on the RPMS and Print Servers:"
 . F I=1:1:$L(OK,U) W !?10,$P(OK,U,I)
 . Q
 I $L(BAD)>1 W ! S STOP='$$WAIT^VENPCCU Q:STOP  D
 . W ?5,"PRINTER GROUP(S) entered in the VEN EHP PRINTER GROUP file, but",!?5,"not registered on the Print Server:"
 . F I=1:1:$L(BAD,U) W !?10,$P(BAD,U,I)
 . W !?5,"Either remove GROUP(S) from VEN EHP PRINTER GROUP file OR",!?5,"add GROUP(S) to the PCC+ Print Service.  TO AVOID CRASHES, DO THIS NOW!"
 . I $G(CFLG)=0 S CFLG=1
 . Q
 I $L(WARN)>1 W ! S STOP='$$WAIT^VENPCCU Q:STOP  D
 . W ?5,"PRINTER GROUP(S) registered in the PCC+ Print Service but not",!?5,"in the VEN EHP PRINTER GROUP file:"
 . F I=1:1:$L(WARN,U) W !?10,$P(WARN,U,I)
 . W !?5,"This will not cause any tech problems, but you will not be able to access",!?5,"a PRINTER GROUP unless it is entered in the VEN EHP PRINTER GROUP file"
 . Q
 Q
 ; 
