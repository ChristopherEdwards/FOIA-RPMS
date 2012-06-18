ACHSYCX ; IHS/ITSC/PMF - CROSS REFERENCE CLEANUP FOR CHS FACILITY FILE ;  [ 04/19/2002  12:14 PM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**4**;JUN 11, 2001
 ;ACHS*3.1*4  whole routine is new
 ;
 ;look for cross references to documents that are not there and
 ;kill them.  this utility does not check xrefs down to the trans
 ;level, just the doc level.  So if a xref points to a doc that
 ;is there and a transaction that is not there, nothing is done.
 ;
 ;the xrefs all have their name, i.e., TB, in subscript 2 except
 ;for AC, where it is ss 1, and B, where it is ss 2.  the routine
 ;is generic enough to handle that
 ;
 ;EOBR has the document pointer in position 3
 ;B and TB have doc pointer in position 5
 ;the rest have doc pointer in position 4
 ;
 ;if the flag MOCK is set, it means we've entered from another
 ;routine and we will not kill anything, just find the buggers
 ;
 S DOLH=$H,DOLH=$TR(DOLH,",","_")
 S MOCK=$G(MOCK)
 K COUNT
 ;
 ;before we get started, clean up anything this util stored
 ;in ^TEMP more than 90 days ago
 S XDOLH="" F  S XDOLH=$O(^TEMP("ACHSCLXR",XDOLH)) Q:XDOLH=""  Q:((XDOLH+3)>+DOLH)  K ^TEMP("ACHSCLXR",XDOLH)
 ;
 F XREF="AC","B","EOBD","EOBP","EOBR","ES","PB","PDOS","TB","VB" D CLEAN
 ;
 I MOCK W !!!,"This was a trial run and no actual changes were made",!,"These numbers are counts only"
 W !!!,"Number of cross references examined:",?50,+$G(COUNT("TOTCHK"))
 W !!,"Total number of cross references removed:",?50,+$G(COUNT("KILL"))
 W !
 F XREF="AC","B","EOBD","EOBP","EOBR","ES","PB","PDOS","TB","VB" W !,"For cross reference ",XREF,":",?50,+$G(COUNT(XREF))
 W !!
 S ^TEMP("ACHSCLXR",DOLH)=$H
 ;
 K COUNT,DOLH,FAC,MOCK,SS1,SS2,SS3,SS4,SS5,XREF,XDOLH
 Q
 ;
CLEAN ;
 ;handle AC as a special case, since it appears in the first
 ;subscript position
 I XREF="AC" S SS1="AC" D CLEAN2 Q
 S SS1=0 F  S SS1=$O(^ACHSF(SS1)) Q:'SS1  D CLEAN2
 Q
 ;
CLEAN2 ;
 I XREF="B" S SS2="D" D CLEAN3 Q
 I XREF'="AC" S SS2=XREF D CLEAN3 Q
 S SS2="" F  S SS2=$O(^ACHSF(SS1,SS2)) Q:SS2=""  D CLEAN3
 Q
 ;
CLEAN3 ;
 I XREF="B" S SS3=XREF D CLEAN4 Q
 S SS3="" F  S SS3=$O(^ACHSF(SS1,SS2,SS3)) Q:SS3=""  D CLEAN4
 Q
 ;
CLEAN4 ;
 ;we can now identify the facility code.  It's in subscript 1
 ;unless the cross reference is AC, then it's in ss 3.
 ;
 I XREF="AC" S FAC=SS3
 E  S FAC=SS1
 ;
 ;for cross reference EOBR, doc pointer is in ss3, so we are
 ;ready to test
 I XREF="EOBR" D  Q
 . S COUNT("TOTCHK")=$G(COUNT("TOTCHK"))+1 I COUNT("TOTCHK")#500=0 W " ."
 . I $D(^ACHSF(FAC,"D",SS3)) Q
 . M ^TEMP("ACHSCLXR",DOLH,SS1,SS2,SS3)=^ACHSF(SS1,SS2,SS3)
 . S COUNT("KILL")=$G(COUNT("KILL"))+1
 . S COUNT(XREF)=$G(COUNT(XREF))+1
 . I MOCK Q
 . K ^ACHSF(SS1,SS2,SS3)
 . Q
 S SS4="" F  S SS4=$O(^ACHSF(SS1,SS2,SS3,SS4)) Q:SS4=""  D CLEAN5
 Q
 ;
CLEAN5 ;
 ;all of the cross references have the doc pointer in ss4, except
 ;EOBR, which is already done, and TB and B, which are handled as
 ;exceptions
 ;
 I XREF'="TB",(XREF'="B") D  Q
 . S COUNT("TOTCHK")=$G(COUNT("TOTCHK"))+1 I COUNT("TOTCHK")#500=0 W " ."
 . I $D(^ACHSF(FAC,"D",SS4)) Q
 . M ^TEMP("ACHSCLXR",DOLH,SS1,SS2,SS3,SS4)=^ACHSF(SS1,SS2,SS3,SS4)
 . S COUNT("KILL")=$G(COUNT("KILL"))+1
 . S COUNT(XREF)=$G(COUNT(XREF))+1
 . I MOCK Q
 . K ^ACHSF(SS1,SS2,SS3,SS4)
 . Q
 S SS5="" F  S SS5=$O(^ACHSF(SS1,SS2,SS3,SS4,SS5)) Q:SS5=""  D CLEAN6
 Q
 ;
CLEAN6 ;
 S COUNT("TOTCHK")=$G(COUNT("TOTCHK"))+1 I COUNT("TOTCHK")#500=0 W " ."
 I $D(^ACHSF(FAC,"D",SS5)) Q
 M ^TEMP("ACHSCLXR",DOLH,SS1,SS2,SS3,SS4,SS5)=^ACHSF(SS1,SS2,SS3,SS4,SS5)
 S COUNT("KILL")=$G(COUNT("KILL"))+1
 S COUNT(XREF)=$G(COUNT(XREF))+1
 I MOCK Q
 K ^ACHSF(SS1,SS2,SS3,SS4,SS5)
 Q
