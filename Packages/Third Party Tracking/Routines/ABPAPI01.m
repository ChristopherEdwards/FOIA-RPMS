ABPAPI01 ;POST INITIALIZATION TASKS; [ 08/07/91  12:03 PM ]
 ;;1.4;AO PVT-INS TRACKING;*1*;IHS-OKC/KJR;AUGUST 6, 1991
 ;;PATCH 1: ADDED CMRP+4;SET 0TH NODE IF REQUIRED;IHS-OKC/KJR;07AUG91
 G MAIN
 ;---------------------------------------------------------------------
DEVICE ;PROCEDURE TO SELECT PRINTER DEVICE FOR THE INSTALLATION GUIDE
 W !!,"   I have some additional notes to help you complete this "
 W "installation process. "
 K %IS,%ZIS S %IS("A")="   Select PRINTER to use: ",%IS="N"
 F I=0:0 D  Q:$D(ABPAIO)=11
 .K ABPAIO D ^%ZIS I POP!($E(IOST,1)'="P")!($D(IO("S"))=1) D  Q
 ..S %IS("A")="   Select PRINTER to use: ",%IS="N" K IO("S")
 ..W *7,"   MUST SELECT A NON-SLAVED 'PRINTER' DEVICE"
 .S ABPAIO=+IO,ABPAIO(0)=IO(0)
 Q
 ;---------------------------------------------------------------------
ACCTPT ;PROCEDURE TO CHECK FOR/ESTABLISH PRIMARY ACCOUNTING POINT
 W !!,"   Checking for a primary account..." H 1 S MSG="found!"
 I $D(^ABPAFAC("B"))=0 K MSG W *7,"not found!",!,?6,"Establishing '" D
 .W $P(^DIC(4,ABPASITE,0),"^"),"' as the primary account."
 .K DIC,DIE,DA,DR,X,Y S DIC="^ABPAFAC(",DIC(0)="L"
 .S X=$P(^DIC(4,ABPASITE,0),"^") D ^DIC
 I $D(MSG)=1 W MSG
 Q
 ;---------------------------------------------------------------------
CMRP ;PROCEDURE TO CLOSE THE REPORTING PERIOD PRIOR TO SYSTEM START-UP
 S Y=$E(DT,1,3),X=$E(DT,4,5) I +X'=1 S X=X-1 S:X<10 X=0_X S Y=Y_X_"00"
 E  S Y=(Y-1)_1200
 S ABPA("DT")=Y K DIC,DA S DA(1)=$O(^ABPAFAC(0)) Q:+DA(1)'>0
 I $D(^ABPAFAC(DA(1),1,0))'=1 S ^ABPAFAC(DA(1),1,0)="^9002270.08D^^0"
 S DIC="^ABPAFAC("_DA(1)_",1,",DIC(0)="L",X=ABPA("DT") D ^DIC
 Q
 ;---------------------------------------------------------------------
XREF ;PROCEDURE TO VALIDATE CROSS REFERENCES
 W !!,"   ...Excuse me, I insist upon checking your file indexes..."
 W !,"      This may take awhile.  Please be patient.  "
 K DIK,DA S DIK="^ABPVAO(" D IXALL^DIK W "all done!"
 Q
 ;---------------------------------------------------------------------
CLOSE ;PROCEDURE TO CLOSE OUTPUT DEVICE(S) & KILL TEMPORARY VARIABLES
 U IO W @IOF X ^%ZIS("C") S IOP=ABPAIO(0) D ^%ZIS
 K ABPAIO,MSG,DIK,I,QFLG,ABPAIO,DIR,DIC,DIE,DR,DA,J
 Q
 ;---------------------------------------------------------------------
MAIN ;ENTRY POINT - THE PRIMARY ROUTINE DRIVER
 W *7,!!,"I HAVE TO RUN A POST-INITIALIZATION ROUTINE."
 D ACCTPT,OPTS^ABPAPI02,LOCKS^ABPAPI02,KEYS^ABPAPI03,CMRP,XREF
 I ABPA("CONVERT") D BEGIN^ABPADC01 ;Convert pre v1.4 data
 D DEVICE U IO(0) W !,"      This will take 5-10 minutes. ",!
 D DOCS^ABPAPI03,CLOSE W !!,"POST INITIALIZATION COMPLETE!"
 Q
