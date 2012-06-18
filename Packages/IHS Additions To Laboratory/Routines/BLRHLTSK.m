BLRHLTSK ; IHS/HQT/MJL -Create a Background Task to Start the HL7 Lower Level Routine for a Non-DHCP Application and Purge HL7 Transmissions ;
 ;;5.2;LR;**1010**;MAR 01, 2001
 ;;MODIFIED FROM HLTASK SPECIFIC FOR LAB DATA INNOVATIONS STARTUP TASK
 ;;1.6;HEALTH LEVEL SEVEN;;Oct 13, 1995
 ;This routine is used for the Version 1.5 Interface Only
 ;ENTRY IN FILE 770 MUST BE: Lab Interface
 ;
 S X="Lab Interface" D:'$D(^HL(770,"B",X))
 .S X1="" F  S X1=$O(^HL(770,"B",X1)) Q:X1=""  I $TR($P(X1," "),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")="LAB" S X=X1 Q
 .K X1
 S HLF1=1,DIC="^HL(770,",DIC(0)="XMZ",DIC("S")="I $P(^(0),""^"",6)]""""" D ^DIC G EXIT:Y<0 K DIC S HLNDAP=+Y,HLNDAP0=Y(0),HLION=$P(HLNDAP0,"^",6)
TASK S ZTDESC="HL7 Message Processor for "_$P(HLNDAP0,"^")
 S ZTRTN="^HLLP",ZTDTH=$H,ZTIO=HLION,ZTSAVE("HLION")="",ZTSAVE("HLNDAP")="",ZTSAVE("HLNDAP0")=""
 D ^%ZTLOAD
EXIT K DIC,X,Y,ZTDESC,ZTRTN,ZTDTH,ZTIO,ZTSAVE K:$D(HLF1) HLF1,HLION,HLNDAP,HLNDAP0 Q
