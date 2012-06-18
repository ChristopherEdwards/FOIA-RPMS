ADEPQA3 ; IHS/HQT/MJL - SEARCH PARAMS ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;**11**;JAN 15, 2002
 ;IHS/HMW
 ;Functions to set up search parameters
 ;
PROV() ;EP - Returns "1/0^dfn,dfn,dfn" where dfn is dfn in provider file
 N DIR,ADEPRV,ADEFLG,DIC,ADEJ,ADEK,ADEY
PRV1 S ADEPRV=""
 K DIR W ! S DIR("A")="Limit search to specific ATTENDING DENTIST(S)"
 S DIR(0)="Y",DIR("B")="NO" D ^DIR
 I $$HAT()!(Y=0) Q 0
 K DIC
 S DIC="^DIC(6,",DIC(0)="AQEM"
 S DIC("S")="I $P(^DIC(6,Y,0),U,4)]"""",$D(^DIC(7,$P(^DIC(6,Y,0),U,4),9999999)),+^DIC(7,$P(^DIC(6,Y,0),U,4),9999999)=52"
 F ADEJ=1:1 S DIC("A")="Select "_$S(ADEPRV]"":"ANOTHER ",1:"")_"Attending Dentist: " D ^DIC Q:X=""  Q:$$HAT()  S ADEY=$P(Y,U,2) D
 . S ADEFLG=0 F ADEK=1:1:$L(ADEPRV,",") I $P(ADEPRV,",",ADEK)=ADEY S ADEFLG=1 Q
 . Q:ADEFLG
 . I ADEPRV]"" S $P(ADEPRV,",",$L(ADEPRV,",")+1)=ADEY Q
 . S ADEPRV=ADEY
 I $$HAT() G PRV1
 I ADEPRV="" G PRV1
 Q "1^"_ADEPRV
 ;
HYG() ;EP - Returns "1/0^dfn,dfn,dfn" where dfn is dfn in provider file
 N DIR,ADEPRV,ADEFLG,DIC,ADEJ,ADEY,ADEK
HYG1 S ADEPRV=""
 K DIR W ! S DIR("A")="Limit search to specific HYGIENIST/THERAPIST(S)"
 S DIR(0)="Y",DIR("B")="NO" D ^DIR
 I $$HAT()!(Y=0) Q 0
 K DIC
 S DIC="^DIC(6,",DIC(0)="AQEM"
 S DIC("S")="I $P(^DIC(6,Y,0),U,4)]"""",$D(^DIC(7,$P(^DIC(6,Y,0),U,4),9999999)),+^DIC(7,$P(^DIC(6,Y,0),U,4),9999999)=46"
 F ADEJ=1:1 S DIC("A")="Select "_$S(ADEPRV]"":"ANOTHER ",1:"")_"Hygienist/Therapist: " D ^DIC Q:X=""  Q:$$HAT()  S ADEY=$P(Y,U,2) D
 . S ADEFLG=0 F ADEK=1:1:$L(ADEPRV,",") I $P(ADEPRV,",",ADEK)=ADEY S ADEFLG=1 Q
 . Q:ADEFLG
 . I ADEPRV]"" S $P(ADEPRV,",",$L(ADEPRV,",")+1)=ADEY Q
 . S ADEPRV=ADEY
 I $$HAT() G HYG1
 I ADEPRV="" G HYG1
 Q "1^"_ADEPRV
 ;
STP() ;EP - Returns "1/0^Search Template DFN^file it's attached to"
 N DIR
STP1 K DIR W ! S DIR("A")="Limit search to entries in one of your Search Templates"
 S DIR(0)="Y",DIR("B")="NO" D ^DIR
 I $$HAT()!(X="")!(Y=0) Q 0
 K DIC S DIC(0)="AQEM",DIC="^DIBT(",DIC("A")="Select SEARCH TEMPLATE: "
 S DIC("S")="I $P(^DIBT(Y,0),U,5)=DUZ I $P(^DIBT(Y,0),U)'[""ADEQA"" I $P(^DIBT(Y,0),U,4)]"""" I $P(^DIBT(Y,0),U,4)=9000001!($P(^DIBT(Y,0),U,4)=9002007)"
 D ^DIC
 I $$HAT()!(X="")!(Y=-1) G STP1
 Q "1^"_+Y_U_$P(^DIBT(+Y,0),U,4)
 ;
DATE() ;EP - Returns "1 or 0^Begin^End" where first piece is 1 if a
 ;date limited search is requested
 N DIR,ADEBEG,X,Y,ADEND
DAT1 W !,"The report will cover the following time period:"
 W ! S DIR("A")="Start with (and include) DATE: "
 S DIR(0)="DA^2810101:"_DT_":EX"
 D ^DIR
 Q:$$HAT() 0
 S ADEBEG=Y
 S DIR("A")="Go to (and include) DATE: "
 S DIR(0)="DA^"_ADEBEG_":"_DT_":EX"
 D ^DIR
 G:$$HAT() DAT1
 S ADEND=Y
 ;IHS/ANMC/HMW 8-14-2002 **11** Added next 2 lines
 S ADEBEG=ADEBEG-1_".9999"
 S ADEND=ADEND_".9999"
 Q "1^"_ADEBEG_U_ADEND
AGE() ;EP - Returns "1or0^Begin^end" where first piece=1 if age search
 N DIR,ADEBEG,X,Y,ADEND
AGE1 W ! S DIR("A")="Do you want to limit the search according to AGE AT TIME OF VISIT"
 S DIR("B")="NO"
 S DIR(0)="Y" D ^DIR
 I $$HAT() Q 0
 I Y=0 Q 0
AGE2 K DIR
 S DIR("A")="Start with (and include) AGE: "
 S DIR(0)="NA^0:110:0"
 D ^DIR
 I $$HAT()!($D(DIRUT)) G AGE1
 S ADEBEG=Y
 S DIR("A")="Go to (and include) AGE: "
 S DIR(0)="NA^"_ADEBEG_":110:0"
 D ^DIR
 I $$HAT()!($D(DIRUT)) W ! G AGE2
 S ADEND=Y
 Q "1^"_ADEBEG_U_ADEND
 ;
HAT() ;EP
 I $D(DTOUT)!($D(DUOUT))!($D(DIROUT)) Q 1
 Q 0
LOC() ;EP - Returns "1/0^location1,location2...locationn" where Location is
 ;a location in Local Facilities subfile of DENTAL SITE PARAM
 N ADEFAC,DIR,ADELOC,ADEJ,ADEY,ADEK,ADEFLG
LOC1 S ADEFAC=""
 W ! S DIR("A")="Do you want to limit the search to visits at a particular FACILITY" S DIR("B")="NO"
 S DIR(0)="Y" D ^DIR
 I $$HAT() Q 0
 I Y=0 Q 0
 S ADELOC=$O(^ADEPARAM(0)) Q:'+ADELOC 0  ;FHL 9/9/98;Add message if no DSP entry
 K DIR
 S DIR(0)="PO^ADEPARAM(ADELOC,1,:QEM"
 S DIR("A")="Select Facility"
 F ADEJ=1:1 D ^DIR Q:X=""  Q:$$HAT()  S ADEY=$P(Y,U,2) D
 . S ADEFLG=0 F ADEK=1:1:$L(ADEFAC,",") I $P(ADEFAC,",",ADEK)=ADEY S ADEFLG=1 Q
 . S:'ADEFLG $P(ADEFAC,",",ADEJ)=ADEY
 I $$HAT() K DIR G LOC1
 I ADEFAC="" Q 0
 Q "1^"_ADEFAC
