APCDDUPP ; IHS/CMI/LAB - find and delete duplicate visits ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 W !!,"This routine will find all visits that have duplicate primary providers"
 W !,"and delete one of the primary provider entries.",!!
 D EN^XBVK("APCD")
 ;
GETDATES ;
DATES ;
 S (APCDBD,APCDED,APCDSD)=""
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Visit Date"
 D ^DIR Q:Y<1  S APCDBD=Y
 K DIR S DIR(0)="DO^::EXP",DIR("A")="Enter Ending Visit Date"
 D ^DIR Q:Y<1  S APCDED=Y
 ;
 I APCDED<APCDBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Visit Date MUST not be earlier than Beginning Visit Date."
 S APCDSD=$$FMADD^XLFDT(APCDBD,-1)_".9999"
 ;
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y D EOJ Q
 ;
PROCESS ;
 S APCDCNT=0
 F  S APCDSD=$O(^AUPNVSIT("B",APCDSD)) Q:APCDSD=""!($P(APCDSD,".")>APCDED)  D
 .;W "+"
 .S APCDV=0 F  S APCDV=$O(^AUPNVSIT("B",APCDSD,APCDV)) Q:APCDV'=+APCDV  D CHECK
 .Q
 W !!,"A total of ",APCDCNT," duplicate primary providers were deleted."
 D EOJ
 Q
 ;
EOJ ;
 D EN^XBVK("APCD")
 D ^XBFMK
 D KILL^AUPNPAT
 K AUPNVSIT
 Q
CHECK ;
 Q:$P(^AUPNVSIT(APCDV,0),U,11)  ;deleted visit, do not check
 Q:'$P(^AUPNVSIT(APCDV,0),U,9)  ;no dependent entries so don't bother
 ;loop through V PROVIDER and check for duplicate primary providers
 K APCDPRV  ;array of primary providers
 S APCDP=0 F  S APCDP=$O(^AUPNVPRV("AD",APCDV,APCDP)) Q:APCDP'=+APCDP  D
 .Q:'$D(^AUPNVPRV(APCDP,0))  ;bad xref
 .Q:$P(^AUPNVPRV(APCDP,0),U,4)'="P"  ;not primary so don't bother
 .S X=$P(^AUPNVPRV(APCDP,0),U)  ;provider pointer
 .I $D(APCDPRV(X)) D DELETE Q  ;already have this one so delete it
 .S APCDPRV(X)=""
 .Q
 Q
DELETE ;
 W !,"Deleting provider ",$P(^VA(200,X,0),U)," from visit: "
 W !?10,"Patient: ",$$VAL^XBDIQ1(9000010,APCDV,.05),"  visit date: ",$$VAL^XBDIQ1(9000010,APCDV,.01)
 S APCDCNT=APCDCNT+1
 S DA=APCDP,DIK="^AUPNVPRV(" D ^DIK D ^XBFMK
 S AUPNVSIT=APCDV D MOD^AUPNVSIT K AUPNVSIT
 Q
