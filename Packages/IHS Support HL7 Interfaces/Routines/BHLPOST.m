BHLPOST ; IHS/TUCSON/DCP - HL7 - POST-INITIALIZATION PROGRAM ; 
 ;;1.0;IHS SUPPORT FOR HL7 INTERFACES;;JUL 7, 1997
 ;
 ; This routine performs any post-initialization actions for the BHL
 ; package as a whole. If a COTS Pharmacy system is being installed,
 ; then ^BHLRXPST must be run after this routine.
 ;
 ; This routine is called from the MUMPS prompt: ">" This routine does
 ; not require any pre-defined external variables.
 ;
START ; ENTRY POINT from MUMPS prompt
 D ^XBKVAR
 ;
 ; kill BHL-namespace globals
 W !!,"  DELETING UNNECESSARY BHL-NAMESPACE FILES."
 S XBKDDEL="D",XBKDTMP="D",XBKDLO=90071,XBKDHI=90079 D EN1^XBKD
 ;
 ; delete BHL Package Entry
 W !!,"  DELETING BHL PACKAGE ENTRY."
 S DA=$O(^DIC(9.4,"C","BHL",0)) I DA'="" S DIK="^DIC(9.4," D ^DIK
 ;
XIT ; clean up and leave
 K DA,DIC,DIK,X,Y,%
 W !!,"  BHL post-init is complete.",!!
 Q
