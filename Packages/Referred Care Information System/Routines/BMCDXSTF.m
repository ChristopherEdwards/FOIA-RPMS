BMCDXSTF ; IHS/PHXAO/TMJ - Stuff Dx & CPT if Site Parameters Request stuffing ;   
 ;;4.0;REFERRED CARE INFO SYSTEM;**8,9**;JAN 09, 2006;Build 51
 ;IHS/ITSC/FCJ Killed DIADD var, was not allowing
 ;       lookup on the Prov. Nar file
 ;BMC*4.0*8 CSV added a space to the .9999 code now checking for ".9999 " for ICD9
 ;BMC*4.0*9 modified to .9999 Code to ZZZ.999 for ICD10
 ;
 ;This routine stuffs the Dx Code or CPT Code if the 27th Piece
 ;of the RCIS SITE PARAMETERS FILE request these fields to be automatically stuffed.
 ;
START ;Begin Looping through stuffed dx's
 S BMCQ=0
 F  D STUFFDX,ANOTHER Q:BMCQ
 D XIT
 Q
 ;
STUFFDX ;Adds DX  as .9999 if Site Parameters = Yes
 S BMCRDX=""
 ;BMC*4.0*9 added ICD-10 TEST
 ;F  S BMCRDX=$O(^ICD9("AB",".9999",BMCRDX)) Q
 ;F  S BMCRDX=$O(^ICD9("AB",".9999 ",BMCRDX)) Q      ;BMC*4.0*8 change ".9999" to ".9999 "
 ;BMC*4.0*9 added ICD-10 TEST
 I BMCDOS>(BMCDX10-1) S BMCRDX=$O(^ICD9("AB","ZZZ.999 ",BMCRDX))
 E  S BMCRDX=$O(^ICD9("AB",".9999 ",BMCRDX))
 I BMCRDX="" Q
 ;BMC*4.0*9 REMOVED "`" FR X,DIADD AND CHANGED DIC TO FILE^DICN
 ;S X="`"_BMCRDX,DLAYGO=90001.01,DIADD=1,DIC(0)="L",DIC="^BMCDX(" D ^DIC
 S X=BMCRDX,DLAYGO=90001.01,DIC(0)="L",DIC="^BMCDX(" D FILE^DICN
 ;BMC*4.0*9 CHANGED TEST FROM X="" TO +Y<0
 I +Y<0 W !!,"Error has ocurred..Cannot add ICD Uncoded Diagnosis Code to RCIS DIAGNOSIS File - Call Developer On This Error!!!"
 S BMCDXIEN=+Y
DXDIE ;Prompt for Diagnosis Type & Provider Narrative
 K DIADD
 W !!
 I BMCDXIEN'="" D
 . S BMCLOOK=1
 . S BMCDXT="P"
 . S DIE="^BMCDX(",DA=BMCDXIEN,DR="[BMC STUFF DX]"
 . D DIE^BMCFMC
 . K BMCLOOK
 . S:'$G(BMCDX) BMCQ=1
 . K BMCDX
 Q
 ;
ANOTHER ;Ask if User wants to enter Another Dx
 S BMCQ=0
 W !!
 S DIR("A")="Continue entering DX's",DIR("B")="N",DIR(0)="Y" D ^DIR
 I $D(DIRUT) S X="N"
 I Y=0 S BMCQ=1
 S:"Nn"[X BMCQ=1
 W !
 K DIR,DIRUT,DUOUT,DTOUT,DIROUT
 Q
 ;
XIT ;Exit this Loop - go back to BMCADD1
 ;
 Q
