BMCREF ; IHS/PHXAO/TMJ - SET REFERRAL VARIABLES ; 
 ;;4.0;REFERRED CARE INFO SYSTEM;**7**;JAN 09, 2006
 ;
 ;   BMCRIEN=referral ien
 ;   BMCRDATE=referral date in internal FileMan form (.01 field)
 ;   BMCRNUMB=referral number (.02 field)
 ;   BMCDFN=patient ien (.03 field)
 ;   BMCRTYPE=type of referral (.04 field)
 ;   BMCCHSCT=CHS authorization count (1115 field)
 ;   BMCRIO=Inpatient or Outpatient (.14 field)
 ;   BMCREC("PAT NAME")=patient name
 ;   BMCREC("REF DATE")=referral date in external form
 ;   BMCSUF=Secondary referral suffix  ;4.0*7
 ;
START ;
 Q:$D(BMCOVRPS)  ;override post selection variable
 S (BMCCHSCT,BMCRIEN,BMCRDATE,BMCRNUMB,BMCDFN,BMCRTYPE,BMCRIO,BMCREC("PAT NAME"),BMCREC("REF DATE"))=""
 Q:'$G(Y)
 Q:'$D(^BMCREF(+Y,0))
 NEW X
 S BMCRIEN=+Y
 S X=^BMCREF(BMCRIEN,0)
 S BMCRDATE=$P(X,U)
 S BMCRNUMB=$P(X,U,2)
 S BMCDFN=$P(X,U,3)
 S BMCRSTAT=$P(X,U,15)
 S BMCRTYPE=$P(X,U,4)
 S BMCRIO=$P(X,U,14)
 S:$G(BMCDFN) BMCREC("PAT NAME")=$P(^DPT(BMCDFN,0),U)
 ;
 S BMCCHSCT=+$P($G(^BMCREF(BMCRIEN,11)),U,15)
 S BMCSUF=$P($G(^BMCREF(BMCRIEN,1)),U)   ;4.0  FCJ
 ;
 NEW Y
 S Y=BMCRDATE
 D DD^%DT
 S BMCREC("REF DATE")=Y
 Q
 ;
 ;
 ;
SETCA ;EP - trigger the CHS APPROVAL STATUS AUDIT multiple from
 ;call fileman with a xbnew call
 NEW BMCCA
 S BMCCA("DA")=DA,BMCCA("NEW")=$S($G(BMCNEWV)]"":BMCNEWV,1:X),BMCCA("OLD")=$S($G(BMCOLDV)]"":BMCOLDV,$D(D):$P(D,U,12),1:""),BMCCA("OPT")=$P($G(XQY0),U)
 I BMCCA("NEW")=BMCCA("OLD") K BMCCA Q  ;don't update audit if values are the same
 D EN^XBNEW("SETCA1^BMCREF","BMCCA")
 K BMCCA
 Q
SETCA1 ;EP entry point for XBNEW
 S DA=BMCCA("DA")
 S DIADD=1,DIE="^BMCREF(",DR="4200///NOW",DR(2,90001.42)=".02////^S X=DUZ;.04///"_$G(BMCCA("OLD"))_";.05///"_$G(BMCCA("NEW"))_";.03///"_$S(BMCCA("OPT")]"":BMCCA("OPT"),1:"UNKNOWN") D ^DIE K DIE,DA,DR,DIADD
 Q
KILLCA ;EP trigger the CHS APPROVAL STATUS AUDIT multiple
 ;from the kill side of CHS APPROVAL STATUS xref AAS
 ;if this is not a delete just quit and set on set side
 Q:$P($G(^BMCREF(DA,11)),U,12)]""  ;this is a change or add
 NEW BMCCA
 S BMCCA("DA")=DA,BMCCA("OLD")=X,BMCCA("NEW")=""
 D EN^XBNEW("SETCA1^BMCREF","BMCCA")
 K BMCCA
 Q
