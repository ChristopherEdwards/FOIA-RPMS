BARSETUP ; IHS/SD/LSL - SETUP FOR A/R MAY 30,1996 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;; This routine for previous version 1.1....keeping for documentation.
 Q
S ;;
 I $G(DUZ(0))'="@" W *7,"pgmr @ needed" Q
 ;I '$D(^BARTMP("BARSETUP")) W *7,!,"YOU MUST FIRST RESTORE the GLOBALS" Q
 ;S ^BAR(90052.03)=^BARTMP("BARSETUP",0)
 N BARX S BARX=0
 ;remove Letters and Text File indices
 ;I $D(^BAR(90052.03))>10 S BARX="" F  S BARX=$O(^BAR(90052.03,BARX),-1) Q:BARX>0  K ^BAR(90052.03,BARX)
 ; load text files and letter templates
 ;S BARX=0 F  S BARX=$O(^BARTMP("BARSETUP",BARX)) Q:BARX'>0  D
 ;. I $D(^BAR(90052.03,2)),BARX=2 Q
 ;. K ^BAR(90052.03,BARX)
 ;. S %X="^BARTMP(""BARSETUP"","_BARX_",",%Y="^BAR(90052.03,"_BARX_"," D %XY^%RCR
 ;rebuild Letters and Text File Indicies
 ;S DIK="^BAR(90052.03," D IXALL^DIK
T ;X ^%ZOSF("UCI") I Y'="DEV,DSD" K ^BARTMP("BARSETUP")
 K BARX
INIT ;D ^BARINIT
 Q:$D(BARERUN)  ; quit if install was previously run
 D ^BARNEWS
 D ^BARNEWS1
 Q
GEN ; generate BARTMP("BARSETUP", of ^BAR(90052.03,
 K ^BARTMP("BARSETUP")
 S %X="^BAR(90052.03,",%Y="^BARTMP(""BARSETUP""," D %XY^%RCR
 W !,"You can now save the global ^BARTMP(""BARSETUP"", to HFS"
 Q
