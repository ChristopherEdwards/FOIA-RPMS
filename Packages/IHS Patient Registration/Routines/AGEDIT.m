AGEDIT ; IHS/ASDS/EFG - MAIN ROUTINE FOR EDITING A PATIENT;  
 ;;7.1;PATIENT REGISTRATION;**1,2**;JAN 31, 2007
 ;
PATLK ;EP -
 S AG("PG")=0
 D PTLK^AG
PATNLK ;PEP -- entry point for packages that already have patient name
 S AG("PG")=0
 Q:'$D(DFN)
 S AGPATDFN=$G(DFN)  ;AG*7.1*1 FIX PROBLEM WITH CURRENT PAT. IN EDIT SCREEN CHANGING WHEN PATIENT LOOKUP IS USED (DFN CHANGES)
 L +^AUPNPAT(DFN):3 I '$T D  Q
 . W !,*7,"Patient's record is being used, Try again soon" H 2
 ;L +^DPT(DFN):5 I '$T W !,"Patient's DPT record already in use! Try again later!" H 2 Q
 ;BEGIN NEW CODE IHS/SD/TPF 5/2/2006 AG*7.1*2 PAGE 12 ITEM 3
 I $$AGE^AGUTILS(AGPATDFN)<3,('$$DECEASED^AGEDERR2(AGPATDFN)) D AUTOADD^BIPATE(AGPATDFN,DUZ(2),.AGERR,"")
 ;END NEW CODE
 S AUPNPAT=DFN
 G:$D(AGXTERN)!($E($O(^AUPNPAT("D",999999)))'="T") SSNCK
 W !!,*7,"There are patients on file with TEMPORARY CHART NUMBERS.",!!
 W "Please print the list of these patients and supply the missing data.",!!
SSNCK ;
 I $P($G(^DPT(DFN,0)),U,9)="" D  G CONT
 . W !?5,"**** WARNING: SSN MISSING  ("
 . W $S($P($G(^AUPNPAT(DFN,0)),U,24)=1:"Not Available",$P(^(0),U,24)=2:"Patient Refused",$P(^(0),U,24)=3:"Patient will Submit",1:"Reason for no SSN not yet entered")
 . W ") *****",!!
 E  G:$D(AGXTERN)!($E($O(^AUPNPAT("D",999999)))'="T") DATCK
CONT ;
DATCK ;
 D ^AGDATCK
 I AG("DTOT")>0 D ^AGBADATA I $D(DUOUT)!$D(DTOUT)!$D(DFOUT) K:$D(AGXTERN) DFN Q
ELIG ;
 K AG("ELIG")
 I AGOPT(14)="Y" G BICELIG
 I $D(^AUPNPAT(DFN,11)),$P(^(11),U,12)]"","I"[$P(^(11),U,12) D
 . W !!,*7,"Patient has been designated ""INELIGIBLE"".",!!
 . S AG("ELIG")=""
 G CLASS
BICELIG ;
 I $D(^AUPNPAT(DFN,11)),+$P(^(11),U,24)>2 D
 . W !!,*7,"Patient has been designated:",!
 . W $P(^AUTTBICE($P(^AUPNPAT(DFN,11),U,24),0),U),!!
 . S AG("ELIG")=""
CLASS ;
 I $D(^AUPNPAT(DFN,11)),$D(AG("ELIG")),$P(^(11),U,11)]"",$D(^AUTTBEN($P(^AUPNPAT(DFN,11),U,11),0)) W "Patient is classified as: ",$P(^(0),U),!! K DIR S DIR(0)="E" S DIR("A")="Press the RETURN key to continue. " D ^DIR
 K AG("ELIG")
DFN ;Pre-determined patient (DFN) defined.
L1 ;
 Q:'$D(DFN)
 I "YC"[AGOPT(14) D
 . S AG("SVELIG")=""
 . I $D(^AUPNPAT(DFN,11)),$P(^(11),U,12)]"" S AG("SVELIG")=$P(^(11),U,12)
 I '$D(^DPT(DFN,0)) K:$D(AGXTERN) DFN Q
 S AGPAT=$P($G(^DPT(DFN,0)),U)
 S AGCHRT=$S($D(^AUPNPAT(DFN,41,DUZ(2),0)):$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2),1:"xxxxx")
 S AG("AUPN")=""
 S:$D(^AUPNPAT(DFN,0)) AG("AUPN")=^(0)
 S AGLINE("-")=$TR($J(" ",78)," ","-")
 S AGLINE("EQ")=$TR($J(" ",78)," ","=")
 Q:$D(AGXTERN)
 I '$D(AGXTERN) D EDCHEK
 D ^AGED1
 L -^AUPNPAT(DFN)
 ;L -^DPT(DFN)  ;AG*7,1*2 ADDING APIS WITH EDITS
 K DFOUT,DTOUT,DUOUT
 K AGSELECT
 Q
EDCHEK ;EP
 K MYERRS,MYVARS
 D FETCHERR^AGEDERR(AG("PG"),.MYERRS)
 S MYVARS("DFN")=DFN,MYVARS("FINDCALL")="",MYVARS("SITE")=DUZ(2)
 D EDITCHEK^AGEDERR(.MYERRS,.MYVARS,1)
 I $$PATREFBC^AGEDERR(DFN) W !!,"**PATIENT HAS AN OPEN BENEFITS CASE**"
 W !
 K DIR
 S DIR("A")="Press the RETURN key to continue. "
 S DIR(0)="E"
 D ^DIR
 Q
