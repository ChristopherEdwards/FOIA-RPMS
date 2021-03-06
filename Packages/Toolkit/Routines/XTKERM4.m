XTKERM4 ;SF/RWF - Kermit utility parts ;11/8/93  11:46 ; [ 11/22/95  1:20 PM ]
 ;;7.3;TOOLKIT;;Apr 25, 1995
 ;IHS/OHPRD/FJE 11/22/95 modified for use with HL7
 ;IHS/OHPRD/FJE tests for XTKHL7 variable to determine if IO needed
INIT ;Init kermit paramiters
 S (XTKS("PN"),XTKR("PN"))=0
 S XTKRDAT="~+ @-#N1" D RPAR S XTKSDAT="~+ @-#N1" D SPAR
 S XTKS("TO")=15,XTKS("QA")="#",(XTKS("SOH"),XTKR("SOH"))=1
 S (XTKR("MAXTRY"),XTKS("MAXTRY"))=10,XTKERR=0
 S (XTKR("TRY"),XTKR("CCNT"),XTKR("PN"))=0,XTKR("PT")="B",XTKR("SA")=""
 S (XTKS("TRY"),XTKS("CCNT"),XTKS("PN"))=0,XTKS("PT")="S",XTKS("SA")=""
 S:'$D(XTKDIC) XTKERR=1 S:'$D(XTKMODE) XTKMODE=2 S:'$D(DWLC) DWLC=0
 S U="^",XTKR("TRMRD")=^%ZOSF("TRMRD")
 Q
RPAR ;Setup receive paramiters from the S packet, Some go into send parameters
 Q:XTKRDAT']""
 S X=$A(XTKRDAT)-35 S:X>1 XTKS("SIZ")=X
 S XTKR("TO")=$A(XTKRDAT,2)-32,XTKS("EOL")=$A(XTKRDAT,5)-32,XTKR("QA")=$E(XTKRDAT,6)
 S:XTKS("EOL")<1 XTKS("EOL")=13 S:XTKR("QA")=" "!(XTKR("QA")="") XTKR("QA")="#"
 S:XTKR("TO")<1 XTKR("TO")=5
 Q
SPAR ;Setup send paramiters from the Y packet.
 Q:XTKSDAT']""
 S X=$A(XTKSDAT)-35 S:X>1 XTKS("SIZ")=X
 S XTKR("TO")=$A(XTKSDAT,2)-32,XTKS("NPAD")=$A(XTKSDAT,3)-32,XTKS("PADC")=$E(XTKSDAT,4)#64,XTKS("EOL")=$A(XTKSDAT,5)-32,XTKR("QA")=$E(XTKSDAT,6)
 S:XTKS("EOL")<1 XTKS("EOL")=13 S:XTKR("QA")=" "!(XTKR("QA")="") XTKR("QA")="#" S:XTKS("NPAD")<0 XTKS("NPAD")=0
 S:XTKR("TO")<1 XTKR("TO")=5
 Q
SFILE ;Get file to send.
 K DIC S XTKERR=1,DIC="^DIZ(8980,",DIC(0)="AEMQ",DIC("A")="KERMIT FILE TO SEND:" D ^DIC Q:Y'>0
 S XTKERR=0,XTKDA=+Y,XTKDIC="^DIZ(8980,"_XTKDA_",2,",XTKFILE=$P(Y,U,2),DIE=DIC,DA=+Y,DR="1///NOW;3" D ^DIE
 S XTKMODE=$P(^DIZ(8980,XTKDA,0),U,4) K DIC,DIE,DR,DA
 Q
RFILE ;Receive file   IHS/OHPRD/FJE corrected spelling
 I '$D(XTKHL7) W !!,"If you enter 'XXX' for the file name it will be replaced by the name sent."  ;IHS/OHPRD/FJE If $D added to bypass IO if for HL7
 I '$D(XTKHL7) K DIC S XTKERR=1,DLAYGO=8980,DIC="^DIZ(8980,",DIC(0)="AEMQLZ",DIC("A")="RECIEVE TO KERMIT FILE:",DIC("DR")="2//YES;3//TEXT" D ^DIC Q:Y'>0  ;IHS/OHPRD/FJE If added to test for XTKHL7
 I $D(XTKHL7) K DIC S XTKERR=1,DIADD=1,DLAYGO=8980,DIC="^DIZ(8980,",DIC(0)="MLZ",DIC("DR")="2///YES;3///TEXT",X="XXX" D ^DIC K DIADD Q:Y'>0  ;IHS/OHPRD/FJE added If for HL7 to bypass fm IO
 S XTKDA=+Y,XTKFILE=$P(Y,U,2) I '$P(Y,U,3) S DA=+Y,DIE=DIC,DR="1///NOW;2;3" D ^DIE S Y(0)=^DIZ(8980,XTKDA,0)
 S XTKERR=0,XTKDIC="^DIZ(8980,"_XTKDA_",2,",XTKR("RFN")=$P(Y(0),U,3),XTKMODE=$P(Y(0),U,4)
 S @(XTKDIC_"0)")="" K DIC,DIE,DA,DR
 Q
READY S X=0 X ^%ZOSF("RM"),^%ZOSF("TYPE-AHEAD"),^%ZOSF("EOFF"),^%ZOSF("TRMON") Q
RESTORE S X=$S($D(IOM):IOM,1:80) X ^%ZOSF("RM"),^%ZOSF("EON"),^%ZOSF("TRMOFF") Q:$D(XTKDEBUG)
CLEAN ;Kill off variables
 K A,C,F1,L,X1,X2,XTKR,XTKS,XTKRDAT,XTKSDAT,XTKRPK,XTKSPK,XTKDA,XTKFILE,XTKDIC,Y,Z,XTKET
 Q
BSPAR ;Build S or Y init string
 S XTKSDAT="~"_$C(XTKS("TO")+32)_" @-#N1"
 Q
