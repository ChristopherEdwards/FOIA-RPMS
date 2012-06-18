BMCPXSTF ; IHS/PHXAO/TMJ - Stuff CPT if Site Parameters Request stuffing ;   
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;IHS/ITSC/FCJ Killed DIADD var, was not allowing entry on the Prc Nar
 ;
 ;This routine stuffs the CPT Procedure Code if the 27th Piece
 ;of the RCIS SITE PARAMETERS FILE request these fields to be automatically stuffed.
 ;
START ;Begin Looping through stuffed PX's
 S BMCQ=0
 F  D STUFFPX,ANOTHER Q:BMCQ
 D XIT
 Q
 ;
STUFFPX ;Adds PX  as 00999 if Site Parameters = Yes
 S BMCRPX=""
 F  S BMCRPX=$O(^ICPT("B","00099",BMCRPX)) Q
 I BMCRPX="" Q
 S X="`"_BMCRPX,DLAYGO=90001.02,DIADD=1,DIC(0)="L",DIC="^BMCPX(" D ^DIC
 I X="" W !!,"Error has ocurred..Cannot Add a 00099 CPT Code to RCIS PROCEDURE File - Call Developer On This Error!!!"
 S BMCPXIEN=+Y
PXDIE ;Prompt for CPT Type & Provider Narrative
 K DIADD
 W !!
 I BMCPXIEN'="" D
 . S BMCLOOK=1
 . S BMCPXT="P"
 . S DIE="^BMCPX(",DA=BMCPXIEN,DR="[BMC STUFF PX]"
 . D DIE^BMCFMC
 . K BMCLOOK
 . S:'$G(BMCPX) BMCQ=1
 . K BMCPX
 Q
 ;
ANOTHER ;Ask if User wants to enter Another Dx
 S BMCQ=0
 W !!
 S DIR("A")="Continue entering PX's",DIR("B")="N",DIR(0)="Y" D ^DIR
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
