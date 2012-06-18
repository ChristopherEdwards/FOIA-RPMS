DGENCD1 ;ALB/CJM,Zoltan,PHH - Catastrophic Disability Protocols;16 JUN 1997 01:30 pm
 ;;5.3;Registration;**121,232,387**;Aug 13,1993
 ;
EN(DFN) ;Entry point for DGENCD CATASTROPHIC DISABILITY protocol
 D EN^DGENLCD(DFN)
 D:DFN BLD^DGENL
 Q
 ;
ADDCD ;Entry point for DGENCD ADD/EDIT CATASTROPHIC DISABILITY protocol 
 ; Input  -- DFN      Patient IEN
 ; Output -- VALMBCK  R   =Refresh screen
 N YN,EXIT,PRI
 S VALMBCK="",EXIT=0
 D FULL^VALM1
 S PRI=$$PRIORITY^DGENA(DFN)
 I PRI,PRI'>4 D
 . W:$X !
 . W !,"According to the veteran's current enrollment record, the",!
 . W "assignment of a Catastrophically Disabled Status will not",!
 . W "improve his/her enrollment priority.",!!
 . S YN=$$YN("Do you still want to perform a review")
 . I "N^"[$E($G(YN)) S EXIT=1
 I 'EXIT D EDITCD^DGENCD(DFN),INIT^DGENLCD
 S VALMBCK="R"
 Q
 ;
DELETECD ;Entry point for DGENCD DELETE CATASTROPHIC DISABILITY protocol 
 ; Input  -- DFN      Patient IEN
 ; Output -- VALMBCK  R   =Refresh screen
 S VALMBCK=""
 D FULL^VALM1
 I '$D(^XUSEC("CD DELETE",DUZ)) D  Q
 .W !!,"Sorry, you do not have the required security key for this option."
 .H 3
 .D INIT^DGENLCD
 .S VALMBCK="R"
 I $$RUSURE(DFN) D
 .I $$DELETE^DGENCDA1(DFN)
 D INIT^DGENLCD
 S VALMBCK="R"
 Q
 ;
RUSURE(DFN) ;
 ;Description: Asks user 'Are you sure?'
 ;Input: DFN is the patient ien
 ;Output: Function Value returns 0 or 1
 ;
 N DIR
 S DIR(0)="Y"
 S DIR("A")="Are you sure that the Catastrophic Disability should be deleted"
 S DIR("B")="NO"
 I $$HASCAT^DGENCDA(DFN) D
 . W !!,">>> Deleting the Catastrophic Disability information will also delete all <<<",!
 . W ">>>  supporting fields, including Diagnoses, Procedures and Conditions.   <<<",!
 D ^DIR
 Q:$D(DIRUT) 0
 Q Y
 ;
YN(PROMPT,DFLT) ; Ask user a yes/no question.
 S DFLT=$E($G(DFLT,"N"))
 N YN,%,%Y
 F  D  Q:"YN^"[YN
 . W PROMPT
 . S %=$S(DFLT="N":2,DFLT="Y":1,1:0)
 . D YN^DICN
 . W !
 . S YN=$S(%=-1:"^",%=1:"Y",%=2:"N",1:"?")
 . I YN["?" W ?5,"You can just enter 'Y' or 'N'.",!!
 Q YN
