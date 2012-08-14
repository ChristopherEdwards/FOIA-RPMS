ACHSRPF1 ; IHS/OIT/FCJ - PRINT CHS FORM AND DATA 2 OF 3 - INIT VARS;  [ 01/21/2005  3:50 PM ] ; 30 Jun 2011  10:09 AM
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**18,19,20**;JUNE 11,2001
 ;3.1*18 NEW ROUTINE
 ;CALLED FROM ACHSRPF
 ;
ST ;
 ;IF NO DATA FOR DOCUMENT OR TRANSACTION QUIT
 I '$D(^ACHSF(DUZ(2),"D",ACHSDIEN,0))!'$D(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",ACHSTIEN,0)) D END Q
 ;QUIT IF PAR SET TO NO ON CANCEL OR SUPPLEMENT
 S ACHSTYPE=$P(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",ACHSTIEN,0),U,2) ;ACHS*3.1*19
 I $$PARM^ACHS(2,6)="N",(ACHSTYPE=4)!(ACHSTYPE=2) Q    ;ACHS*3.1*19
 I $$PARM^ACHS(2,7)="N",ACHSTYPE=1 Q     ;ACHS*3.1*19
 ;
 D INIT,REF:ACHSTYP'=2
 D ^ACHSRPFU
 ;
DOCP ;
 I $D(ACHSRPNT) K ^TMP("ACHSRR",$J,DUZ(2),ACHSTYPV,ACHSDIEN,ACHSTIEN) D END Q
 ;             
 ;ADD DOCUMENT TO CHS DOCUMENTED PRINTED LIST FILE
 S X=$G(^ACHS(7,ACHS7DA,"D",0))
 S N=$P(X,U,3)+1      ;INCREMENT ENTRY 
 S M=$P(X,U,4)+1      ;INCREMENT LAST ENTRY USED
 S ^ACHS(7,ACHS7DA,"D",N,0)=ACHSORDN_U_DUZ(2)_U_ACHSDIEN_U_ACHSTIEN
 S ^ACHS(7,ACHS7DA,"D","B",ACHSORDN,N)=""
 S ^ACHS(7,ACHS7DA,"D",0)=$P(X,U,1,2)_U_N_U_M
 S ^ACHS(7,"P",DUZ(2),ACHSDIEN,ACHSTIEN,ACHS7DA,N)=""
 LOCK -^ACHS(7,ACHS7DA):60
 K ^ACHSF("PQ",DUZ(2),ACHSTYPV,ACHSDIEN,ACHSTIEN)
 ;
END ;
 ; Removed following line so we keep ^TMP("ACHSPO",$J around for printing
 ;K ^TMP("ACHSPO",$J,ACHSDIEN,ACHSTIEN)
 K A,B,C,D,E,F,I,R,N
 Q
 ;
INIT ; Initialize local vars for existing document data.
 ;SET NOTFOUND VARIABLE TO UNDEFINED STRINGS
 D KILLNULS
 K ACHSNOTF
 S $P(ACHSNOTF," --- "_U,30)=""
 S ACHSARCO=$P(^ACHSF(DUZ(2),0),U,11)
 S ACHSDOC0=$G(^ACHSF(DUZ(2),"D",ACHSDIEN,0),ACHSNOTF)  ;DOC NODE 0
 S ACHSDOC1=$G(^ACHSF(DUZ(2),"D",ACHSDIEN,1),ACHSNOTF)  ;DOC NODE 1
 S ACHSDOC2=$G(^ACHSF(DUZ(2),"D",ACHSDIEN,2),ACHSNOTF)  ;DOC NODE 2
 S ACHSDOC3=$G(^ACHSF(DUZ(2),"D",ACHSDIEN,3),ACHSNOTF)  ;DOC NODE 3
 S ACHSTRA0=$G(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",ACHSTIEN,0),ACHSNOTF) ;TRANS NODE 0
 ;
 S ACHSCONP=$P(ACHSDOC0,U,5)                  ;CONTRACT PTR
 S ACHSCAN=$$UNDEF($P(ACHSDOC0,U,6))          ;COMMON ACCT #
 S ACHSSCC=$$UNDEF($P(ACHSDOC0,U,7))          ;OBJECT CLASS.
 S ACHSOBJC=$$UNDEF($P(ACHSDOC0,U,10))        ;VENDOR CHRG. EST.
 S S=$$UNDEF($P(ACHSDOC0,U,14))               ;FISCAL YEAR
 S ACHSTYP=$$UNDEF($P(ACHSDOC0,U,4))         ;TYPE OF SERVICE
 S ACHSCOPT=$$UNDEF($P(ACHSDOC0,U,13))        ;COMMENTS OPTIONAL
 S ACHSODT=$$UNDEF($P(ACHSDOC0,U,2))            ;ORDER DATE
 S ACHSBLAN=$$UNDEF($P(ACHSDOC0,U,3))          ;BLANKET ORDER?
 S ACHSDEST=$$UNDEF($P(ACHSDOC0,U,17))        ;DOCUMENT DEST.
 S ACHSDCR="" S:$$PARM^ACHS(2,18)="Y" ACHSDCR="DCR: "_$P(ACHSDOC0,U,19)  ;DOCUMENT CONTROL REGISTER ACHS*3.1*19
 S ACHSESIG=$$GET1^DIQ(200,$$UNDEF($P(ACHSDOC0,U,24)),.01) ;E SIG
 S Y=$$UNDEF($P(ACHSDOC0,U,28)) X ^DD("DD") S ACHSEDTE=Y    ;E DATE
 S ACHSASIG=$$GET1^DIQ(200,$$UNDEF($P(ACHSDOC0,U,29)),.01) ;AUTH SIG
 S Y=$$UNDEF($P(ACHSDOC0,U,30)) X ^DD("DD") S ACHSADTE=Y    ;A DATE  
 ;
 ;PROVIDER INFO
 S ACHSMPP=$P(ACHSDOC1,U,4)                   ;MEDICARE PROV. PTR.
 S ACHSPROV=$$UNDEF($P(ACHSDOC0,U,8))          ;PROVIDER PTR
 S ACHSAGRP=$$UNDEF($P(ACHSDOC0,U,23))         ;VENDOR AGREE. PTR
 S ACHSPR18=""
 S:ACHSAGRP'="" ACHSPR18=$G(^AUTTVNDR(ACHSPROV,18,ACHSAGRP,0),ACHSNOTF)
 S ACHSMRTO=$$UNDEF($P(ACHSPR18,U,5))          ;MEDICARE RATE OUTPATIENT
 S ACHSMRTI=$$UNDEF($P(ACHSPR18,U,4))          ;MEDICARE RATE INPATIENT
 I ACHSMPP'="" S ACHSMPN=$P($G(^AUTTVNDR(ACHSPROV,"MP",ACHSMPP,0)),U),ACHSDS=$P($G(^(0)),U,2),ACHSDS=$$EXTSET^XBFUNC(9999999.112303,2,ACHSDS)
 ;
 S ACHSORDN=S_"-"_ACHSFC_"-"_$P(ACHSDOC0,U)    ;FULL ORDER #
 ;
 ;FACILITY INFO
 S ACHSPATF=$$UNDEF($P(ACHSDOC0,U,20))          ;PATIENT FACILITY PTR
 S ACHSLOC0=$G(^AUTTLOC(ACHSPATF,0),ACHSNOTF)   ;LOCATION NODE 0 
 ;
 ;TRANSACTION INFO
 S ACHSDOS=$P(ACHSTRA0,U,10)                   ;DATE OF SERVICE
 S ACHSTYPE=$P(ACHSTRA0,U,2)                   ;TRANSACTION TYPE
 S ACHSLCA=$P(ACHSTRA0,U,7)                    ;CANCEL NUMBER
 ;
 ;GET CANCEL OR SUPPLEMENT NUMBER
 S ACHSSF=$S(ACHSTYPE="C":"C"_$P(ACHSTRA0,U,7),ACHSTYPE="S":"S"_$P(ACHSTRA0,U,6),1:"")
 ;
 S E(7)=ACHSODT
 I ACHSTYPE="S" D
 .S E(11)=E(7)                    ;MOVE ORDER DATE TO E(11)
 .S X=$P(ACHSTRA0,U)              ;TRANSACTION DATE
 .I X'=" --- " S E(7)=$E(X,4,5)_"-"_$E(X,6,7)_"-"_$E(X,2,3)
 .E  S E(7)=X
 ;                                    
 ;NEXT LINE GETS 'REFERRAL TYPE (DENTAL ONLY)' FROM DOCUMENT SUBFILE
 ;AND 'REFERRAL TYPE (NOT USED)' FROM TRANSACTION SUBFILE
 S ACHSREFT=$E($P(ACHSTRA0,U,11)_$P(ACHSDOC3,U,10))
 ;
 K ACHSBLKF
 ;
 ;IF THIS IS A BLANKET ORDER GET BLANKET ORDER TYPE
 I ACHSBLAN S ACHSBLKF="",ACHSBLT=$G(^ACHSF(DUZ(2),"D",ACHSDIEN,"BT"))
 S ACHSISIG=$$GET1^DIQ(200,$$UNDEF($P(ACHSDOC0,U,18)),.01) ;DOC INITIATOR
 S ACHSSIG=$$GET1^DIQ(200,$$UNDEF($P(ACHSDOC0,U,18)),20.3) ;TITLE
 S ACHSESDO=$$UNDEF($P(ACHSTRA0,U,4))           ;IHS PAYMENT AMOUNT
 S DFN=$$UNDEF($P(ACHSTRA0,U,3))                ;PATIENT PTR
 ;
 S (ACHSEDOS,ACHSFDT,ACHSTDT)=""
 I ACHSTYP D
 .S ACHSFDT=$$UNDEF($P(ACHSDOC3,U))            ;AUTH BEGINNING DATE
 .S ACHSTDT=$P(ACHSDOC3,U,2)
 . I ACHSTYP=1,(ACHSTDT="") N X,X1,X2 S X1=ACHSFDT,X2=$P(ACHSDOC1,U,1) D C^%DTC S ACHSTDT=X
 . ;
 .S ACHSTDT=$$UNDEF(ACHSTDT)                   ;AUTH ENDING DATE
 .S ACHSEDOS=$$UNDEF($P(ACHSDOC3,U,9))         ;EST. DATE OF SERVICE
 .S:ACHSEDOS="" ACHSEDOS=ACHSFDT               ;
 S ACHSESDA=$$UNDEF($P(ACHSDOC1,U))            ;ESTIMATED INPATIENT DAYS
 ;
 S ACHSHON=$$UNDEF($P(ACHSDOC2,U))             ;HOSPITAL ORDER #
 ;
 S ACHSDES=$$UNDEF($P(ACHSDOC1,U,2))           ;DESCRIPTION OF SERVICE
 S A(7)=ACHSDES
 D PRT^ACHSUDF                                 ;GET PATIENT, FACILITY &
 ;                                             ;INSURANCE INFO
 Q
 ;RESET ARRAY VALUES TO NULL
KILLNULS ;
 F ACHSX="A","B","C","D","E","F" F ACHSY=1:1:12 S ACHS=ACHSX_"("_ACHSY_")" S @(ACHS)=" --- "
 Q
 ;
REF ; Set Referral Physician and Medical Priority into print vars.
 Q:$D(ACHSBLKF)               ;DON'T GET INFO IF BLANKET ORDER
 S (ACHSDX,ACHSPX,X,N)=""
 ;
 S ACHS200=$S($G(^DD(9002080.01,80,0))["VA(200,":1,1:0)
 ;
 I $D(^ACHSF(DUZ(2),"D",ACHSDIEN,3)) D
 .S R(1)=$$UNDEF($P(ACHSDOC3,U,5))      ;REFERRING PHYSICIAN PTR
 .;
 .S R(2)=$$UNDEF($P(ACHSDOC3,U,6))      ;REFERRAL MEDICAL PRIORITY
 .;
 .I ACHS200 S:R(1)>0 R(1)=$P($G(^VA(200,R(1),0)," --- "),U)
 .I 'ACHS200 D
 ..S ACHSREFP=$$UNDEF($P($G(^DIC(6,R(1),0)),U))
 ..S:+R(1)>0 R(1)=$$UNDEF($P($G(^DIC(16,ACHSREFP,0)),U))
 . I R(2),R(2)["I" S R(2)=$$UNDEF($P($T(@R(2)),";;",2))
 ;
PROC1 ; Set Referral Procedure Narrative into print vars for Universal Form.
 G:'$D(^ACHSF(DUZ(2),"D",ACHSDIEN,7)) DIAG1 S ACHSPX=$G(^ACHSF(DUZ(2),"D",ACHSDIEN,7))
 I $L(ACHSPX)>118 S R("P",1)=$E(ACHSPX,1,22),N=23
 I $L(ACHSPX)<118 S R("P",1)="",N=1
 F X=2:1:4 S R("P",X)=$E(ACHSPX,N,N+36),N=N+37
DIAG1 ; Set Referral Diagnosis Narrative into print vars for Universal Form.
 G:'$D(^ACHSF(DUZ(2),"D",ACHSDIEN,5)) EXT1 S ACHSDX=$G(^ACHSF(DUZ(2),"D",ACHSDIEN,5))
 I $L(ACHSDX)>72 S R("D",1)=$E(ACHSDX,1,22),N=23
 I $L(ACHSDX)<72 S R("D",1)="",N=1
 F X=2:1:3 S R("D",X)=$E(ACHSDX,N,N+36),N=N+37
EXT1 ;
 K ACHSDX,ACHSPX,X,N
 Q
 ;
UNDEF(X) ;
 ;RETURN " --- " IF NULL
 I X="UNDEFINED"!(X="") Q " --- "
 Q X
 ; 
REFCOD ;
I ;;Emergent/Acutely Urg
II ;;Preventive Services
III ;;Prim/Sec Services
IV ;;Chr Tert/Exten Svc
 ; 