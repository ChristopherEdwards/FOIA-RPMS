ADEGRL0 ; IHS/HQT/MJL  - DENTAL ENTRY PART 1.5 ;04:55 PM  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
INIT ;EP
 S Y=0
 I '$D(ADEDIR) S ADEDIR=1,ADECON=0
 I '$D(DUZ(2)) W !!,"SIGN-ON FACILITY NOT SET IN USER FILE.  CONTACT SITE MANAGER" Q
 S ^ADEUTL($J,"DUZ2")=DUZ(2)
 D ^XBKVAR I '$D(DUZ(2))!(DUZ(2)="") W !,"DIVISION NOT SET IN USER FILE -- CONTACT SITE MANAGER OR ISC" Q
 I DUZ(2)=0 S DUZ(2)=+^AUTTSITE(1,0) ;Reset to RPMS SITE
 I '$D(^ADEPARAM(+^AUTTSITE(1,0),0)) D WARN(+^AUTTSITE(1,0)) Q
 I '$D(^ADEPARAM(DUZ(2),0)) D WARN(DUZ(2)) Q
 I '$P(^ADEPARAM(DUZ(2),0),U)!($P(^(0),U,2)="")!($P(^(0),U,4)="")!($P(^(0),U,5)="")!($P(^(0),U,6)="")!('$P(^(0),U,7))!('$P(^(0),U,8))!($P(^(0),U,9)="") D WARN(DUZ(2)) Q
 I $P(^AUTTSITE(1,0),U,13)="" W !,*7,"UNIVERSAL LOOKUP FOR VISITS field in the RPMS SITE file",!,"has no entry. Contact your site manager." Q
 I '$D(DUZ(0)) W !,"FileMan Access Undefined.  Contact site manger." Q
 I DUZ(0)'="@",DUZ(0)'["M"!(DUZ(0)'["[") W !,"FileMan Access denied.  Contact site manager." Q
 K ADELIN S ADEFAST=0,$P(ADELIN,"-",79)=""
 S Y=1
 Q
UNIV(ADEFACD) ;EP - Returns 0 if local facility has no entry in UNIVERSAL LOOKUP
 ;;otw, returns 1 and resets DUZ(2) to dfn of Local Facility
 ;S Y=0
 ;S ADEDUZ(2)=DUZ(2),ADETMP=DUZ(2)
 N ADEDFN,ADESITE
 S ADESITE=+^AUTTSITE(1,0)
 I '$D(^ADEPARAM("AB",ADEFACD)) D WARN(ADEFACD) Q 0
 I '$D(^ADEPARAM("AB",ADEFACD,ADESITE)) D WARN(ADEFACD) Q 0
 S ADEDFN=$O(^ADEPARAM("AB",ADEFACD,ADESITE,0))
 I $P(^ADEPARAM(ADESITE,1,ADEDFN,0),U,2)']"" W !,*7,"UNIVERSAL LOOKUP field value for this local facility not entered." Q 0
 K AUPNLK("ALL")
 I $P(^ADEPARAM(ADESITE,1,ADEDFN,0),U,2) S AUPNLK("ALL")=""
 S DUZ(2)=ADEFACD
 Q 1
 ;
WARN(ADEFACD) ;
 W *7,!!,"Dental Site Parameter File has not been set up properly or fully"
 I ADEFACD]"",$D(^AUTTLOC(ADEFACD,0)) W !,"for ",$P(^AUTTLOC(ADEFACD,0),U,2)
 W ".",!,"Consult the DDS Documentation, the Help Frames, or your Site Manager.",!!
 H 1
 Q
