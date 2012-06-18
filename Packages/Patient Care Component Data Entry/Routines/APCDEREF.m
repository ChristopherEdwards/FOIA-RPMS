APCDEREF ; IHS/CMI/LAB - prompt for refusal value ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
VALUE ;EP - called from input template
 I '$D(DA) S APCDTERR=1 Q
 I 'DA S APCDTERR=1 Q
 NEW APCDX S APCDX=$P(^AUPNPREF(DA,0),U)
 S APCDTF=$P(^AUTTREFT(APCDX,0),U,2)
 I 'APCDTF S APCDTERR=1 D EOJ Q
 S DIC("B")=$S($D(APCDTOLD):APCDTOLD,1:""),DIC("A")="  Enter the "_$P(^DIC(APCDTF,0),U)_" value: ",DIC=APCDTF,DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 W !!,"Invalid entry.  Try again." G VALUE
 S APCDTIEN=+Y,APCDTID=$$VAL^XBDIQ1(APCDTF,APCDTIEN,$P(^AUTTREFT(APCDX,0),U,3))
EOJ ;
 K Y
 Q
 ;
MOD(APCDP) ;EP
 ;select entry for modify and pass to template in APCDLOOK
 S APCDTIEN=""
 D EN^XBNEW("MOD1^APCDEREF","APCDP;APCDTIEN")
 S APCDLOOK=$G(APCDTIEN)
 I 'APCDLOOK W !!,"No entry selected" S APCDTERR=1 Q
 Q
MOD1 ;EP called from xbnew
 W !?2,"0)  None"
 NEW APCDX,APCDC,APCDD K APCDD S (APCDX,APCDC)=0
 F  S APCDX=$O(^AUPNPREF("AC",APCDP,APCDX)) Q:APCDX'=+APCDX  S APCDC=APCDC+1,APCDD(APCDC)=APCDX W !?2,APCDC,")",?6,$E($$VAL^XBDIQ1(9000022,APCDX,.01),1,15),?22,$$VAL^XBDIQ1(9000022,APCDX,.04),?54,$$VAL^XBDIQ1(9000022,APCDX,.03)
 S DIR(0)="N^0:99999:",DIR("A")="Which one do you wish to modify or delete",DIR("B")="0" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I 'Y Q
 S APCDTIEN=$G(APCDD(Y))
 Q
EN(PATIENT,VFIEN) ;EP - called from APCD EL (ADD/MOD) templates
 I '$G(PATIENT) Q
 I '$G(VFIEN) Q
 I '$D(^AUPNVELD(VFIEN)) Q
 D EN^XBNEW("EN1^APCDEREF","VFIEN;PATIENT")
 Q
EN1 ;EP - called from XBNEW to update elder care status
 I '$D(^AUPNELDC("B",PATIENT)) G ADDEC
EDITEC ;
 S DA=PATIENT,DIE="^AUPNELDC("
 NEW VF
 S VF=^AUPNVELD(VFIEN,0)
 NEW D
 S D=$P($P(^AUPNVSIT($P(^AUPNVELD(VFIEN,0),U,3),0),U),".")
 I $P(^AUPNELDC(PATIENT,0),U,3)]D Q  ;later entry already updated
 S DR=".03////"_D_";.04////"_$P(VF,U,4)_";.05////"_$P(VF,U,5)_";.06////"_$P(VF,U,6)_";.07////"_$P(VF,U,7)_";.08////"_$P(VF,U,8)_";.09////"_$P(VF,U,9)_";.11////"_$P(VF,U,11)_";.12////"_$P(VF,U,12)_";.13////"_$P(VF,U,13)
 S DR=DR_";.14////"_$P(VF,U,14)_";.15////"_$P(VF,U,15)_";.16////"_$P(VF,U,16)_";.17////"_$P(VF,U,17)_";.18////"_$P(VF,U,18)
 D ^DIE
XIT ;
 K DIADD,DLAYGO,DD,DO,D0,DIC
 K DA,DIE,DIU,DIV,DIW,DR
 Q
ADDEC ;
 S DLAYGO=9000023,DIC="^AUPNELDC(",DIC(0)="L"
 S X="`"_PATIENT
 D ^DIC K DIC
 I Y=-1 W !,"ERROR ADDING ELDER CARE STATUS ENTRY" D XIT Q
 D EDITEC
 Q
