AGACXREF ; IHS/ASDS/EFG - DELETE AND REBUILD THE AC (CURRENT COMMUNITY) X-REF, STUFF CUR COMM FIELD ;    
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 W $$S^AGVDF("IOF"),!
 W ?30,"***   AGACXREF   ***",!
 W ?5,"===   CURRENT COMMUNITY (AC) and TRIBE OF MEMBERSHIP indices   ==="
 W *7,!!,"Because of a bug in IHS REGISTRATION v 4.22, the 'AC' cross-reference",!
 W "of the Patient file was set only when a patient was edited, not when the",!
 W "patient was first entered."
 W !!,"This routine will kill and rebuild the 'AC' (Current Community) and 'AE'",!
 W "(Tribe of Membership) cross-references on the PATIENT File (^AUPNPAT).",!!
 W "It will also reset the Current Community field from LAST(PREVIOUS COMMUNITY)."
 W !!,"It should take approximately ",$J(1244/36277*+$P(^AUPNPAT(0),U,4)/60,3,1)," minutes to complete",!
 W "on your ",+$P(^AUPNPAT(0),U,4)," patients.",!!
 W "Q'ing to TaskMan is possible."
 ;
 K DIR,DTOUT,DUOUT,DFOUT,DQOUT,DIRUT,DIROUT,DLOUT
 S DIR(0)="Y"
 S DIR("A")="Do you want to continue? (Y/N) "
 W !!
 D ^DIR
 I Y=0 W *7,!!,"Please 'D ^AGACXREF' at your convenience." Q
QUE ;
 K DIR,DTOUT,DUOUT,DFOUT,DQOUT,DIRUT,DIROUT,DLOUT
 S DIR(0)="Y"
 W !!
 S DIR("A")="Do you want to q this process? "
 S DIR("B")="YES"
 D ^DIR
 G END:$D(DTOUT)!(Y["^")        ; EXIT IF TIME OUT OR ^
 G ENTRY:Y=0                    ; RUN THE XREF NOW
DEV ;
 X ^%ZOSF("UCI")
 S ZTRTN="ENTRY^AGACXREF"
 S ZTUCI=Y
 S ZTIO=""
 S ZTDESC="Rebuild PATIENT AC index, for "_$P(^AUTTLOC(DUZ(2),0),U,2)_"."
 S ZTSAVE=""
 D ^%ZTLOAD G:'$D(ZTSK) QUE W !!,"Task Number = ",ZTSK,!!,"Press RETURN..." R Y:DTIME K AG,AGIO,AGQIO,G,ZTDESC,ZTIO,ZTRTN,ZTSAVE,ZTSK,ZTUCI D ^%ZISC Q
ENTRY ;EP - TaskMan.
 I '$D(ZTQUEUED) W ! S IOP=ION D ^%ZIS,WAIT^DICD W !,+$P(^AUPNPAT(0),U,4)," patients.",! S DX=$X,DY=$Y+1
 K ^AUPNPAT("AC"),^("AE") F DFN=0:0 S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D C1,AE
END K AGCC,AGCCSV,AGCCPTR,AGCCNAME,DFN,DX,DY,X,XY,Y
 D:$D(ZTQUEUED) KILL^%ZTLOAD
 Q
C1 ;
 F AGCC=0:0 S AGCC=$O(^AUPNPAT(DFN,51,AGCC)) Q:AGCC'=+AGCC  S AGCCSV=AGCC
 Q:'$D(^AUPNPAT(DFN,51,AGCCSV,0))
 S AGCCPTR=$P($G(^AUPNPAT(DFN,51,AGCC,0)),U,3) Q:AGCCPTR=""
 Q:'$D(^AUTTCOM(AGCCPTR,0))
 S AGCCNAME=$P($G(^AUTTCOM(AGCCPTR,0)),U) Q:AGCCNAME=""
 S $P(^AUPNPAT(DFN,11),U,18)=AGCCNAME,^AUPNPAT("AC",AGCCNAME,DFN)=""
 Q
AE I $D(^AUPNPAT(DFN,11)),$P(^(11),U,8)]"" S ^AUPNPAT("AE",$P(^AUPNPAT(DFN,11),U,8),DFN)=""
 Q
