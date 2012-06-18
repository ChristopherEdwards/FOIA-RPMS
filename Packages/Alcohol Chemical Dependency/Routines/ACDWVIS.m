ACDWVIS ;IHS/ADC/EDE/KML - SET LOC VARS FROM ACDVIS GLOBAL;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;*******************************************************************
 ;//^ACDWCD1, ^ACDWCD2, ^ACDWCD3,^ACDWDRV1,^ACDWDRV2,^ACDWDRV3,^ACDWDRV4
 ;//^ACDWSTAF
 ;Needs ACDDA as internal DA to file entry
 ;*****************************************************************
 S ACDN0=^ACDVIS(ACDDA,0) S:$P(ACDN0,U,2)="" $P(ACDN0,U,2)="PHANTOM"
 S ACDPG=^ACDVIS(ACDDA,"BWP")
 I $D(^ACDF5PI(ACDPG,0)) S ACDPG=$P(^ACDF5PI(ACDPG,0),U),ACDPG=$P(^AUTTLOC(ACDPG,0),U),ACDAUF=$P(^(0),U,10),ACDPG=$P(^DIC(4,ACDPG,0),U)
 E  S ACDPG="NOT DEFINED"
 S Y=$P(ACDN0,U) S ACDCLIV=$$DD^ACDFUNC(Y)
 S ACDCOMC=$P(ACDN0,U,2)
 S ACDCOMCS="???" S:ACDCOMC ACDCOMCS=$P($G(^ACDCOMP(ACDCOMC,0)),U,2)
 S ACDCOMCL=$P($G(^ACDCOMP(ACDCOMC,0)),U)
 ;S ACDP(3)=$S($D(^ACDCOMP(ACDCOMC,0)):$P(^(0),U,6),1:""),ACDP(1)=9002170.1,ACDP(2)=5 S ACDCOMCL=$$SETS^ACDFUNC(.ACDP)
 S ACDCOMT=$P(ACDN0,U,7)
 S ACDP(3)=ACDCOMT,ACDP(1)=9002172.1,ACDP(2)=5 S ACDCOMTL=$$SETS^ACDFUNC(.ACDP)
 ;S ACDPROV=$P(ACDN0,U,3) S:'ACDPROV ACDPROV="NONE",ACDDFNP=0 S ACDPROV=$S($D(^DIC(16,ACDPROV,0)):$P(^(0),U),1:"NONE")
 S ACDPROV=$P(ACDN0,U,3) S:'ACDPROV ACDPROV="NONE",ACDDFNP=0 S ACDPROV=$S($D(^VA(200,ACDPROV,0)):$P(^(0),U),1:"NONE")
 S ACDPROVP=$P(ACDN0,U,3)
 S ACDCONT=$P(ACDN0,U,4)
 S ACDP(3)=ACDCONT,ACDP(1)=9002172.1,ACDP(2)=3 S ACDCONTL=$$SETS^ACDFUNC(.ACDP)
 S (ACDDFN,ACDDFNP)=$P(ACDN0,U,5) S:'ACDDFN ACDDFN="NONE",ACDDFNP=0 S ACDDFN=$S($D(^DPT(ACDDFN,0)):$P(^(0),U),1:"NONE")
 S ACDFOLL=$P(ACDN0,U,6) S:$G(ACDFOLL)="" ACDFOLL="UNKNOWN"
 S ACDTRIB=$P(ACDN0,U,10) S:ACDTRIB="" ACDTRIB="UNKNOWN"
 S ACDSTATE=$P(ACDN0,U,11) S:ACDSTATE="" ACDSTATE="UNKNOWN"
 ;Many records at HQ/AREA could have the same DFN but they came from
 ;different facilities. So, use ACDAUF_ACDDFNP so reports will sort
 ;properly and be accurate. Only use when visit has a patient pointer.
 I ACDDFNP'=0 S ACDDFNP=1_ACDAUF_ACDDFNP
 S ACDFOLMO=$P(ACDN0,U,6)
 S ACDP(3)=$P(ACDN0,U,13),ACDP1(1)=9002172.1,ACDP(2)=104 S ACDVET=$$SETS^ACDFUNC(.ACDP)
 S ACDAGE=$P(ACDN0,U,16)
 S ACDP(3)=$P(ACDN0,U,8),ACDP(2)=9,ACDP(1)=9002172.1 S ACDAGER=$$SETS^ACDFUNC(.ACDP)
 S ACDP(3)=$P(ACDN0,U,12),ACDP(1)=9002172.1,ACDP(2)=103,ACDSEX=$$SETS^ACDFUNC(.ACDP)
 S:'ACDDFNP ACDDFNP=.1 ;***********************
 ;
 ;If staff report, stop after getting locals from the visit file
 ;
 I $D(ACDWSTAF(1)) Q
MATCH ;EP
 ;//^ACDWDRV3
 ;***************************************************************
 ;This is the key to building report data or not. We go to ^ACDWASF
 ;and check to see if the record ASUFAC matches one of the arrays
 ;defined by the user's request. If so, ACDONE,ACDTWO,ACDTHREE will
 ;come back defined.
 ;If a match is found, keep counters of how many visit records matched
 ;for the area, su,facility,state,tribe,community, or contact type
 ;***************************************************************
 S ACDOK=0 D ^ACDWASF I $D(ACDONE),$D(ACDTWO),$D(ACDTHREE) S ACDOK=1 D ACDTRB,ACDSTA,CNT
 ;
 I $D(ACDCRST($P(ACDN0,U,4))),ACDOK S ACDCRST($P(ACDN0,U,4))=ACDCRST($P(ACDN0,U,4))+1
 I $D(ACDTRB(ACDTRIB)),ACDOK S ACDTRB(ACDTRIB)=ACDTRB(ACDTRIB)+1
 I $D(ACDSTA(ACDSTATE)),ACDOK S ACDSTA(ACDSTATE)=ACDSTA(ACDSTATE)+1
 I $D(ACDFAC(ACDAUF)),ACDOK S ACDFAC(ACDAUF)=ACDFAC(ACDAUF)+1 Q
 I $D(ACDAREA($E(ACDAUF,1,2))),ACDOK S ACDAREA($E(ACDAUF,1,2))=ACDAREA($E(ACDAUF,1,2))+1 Q
 I $D(ACDSU($E(ACDAUF,1,4))),ACDOK S ACDSU($E(ACDAUF,1,4))=ACDSU($E(ACDAUF,1,4))+1 Q
 ;
 ;**************************************************************
 ;If the user has selected to run the area, su, or facility reports
 ;with a further restriction by tribe, state, or community, come here
 ;and further validate the record meets print criteria.
 ;*************************************************************
 ;
ACDTRB ;
 ;See if user running by tribe
 I '$D(ACDTRB) Q  ;User not running by tribe
 I $D(ACDTRB("*ALL*")) Q  ;User wants all tribes
 I '$D(ACDTRB(ACDTRIB)) S ACDOK=0 Q  ;Sel tribes or category
 ;
ACDSTA ;
 ;See if user running by state
 I '$D(ACDSTA) Q  ;User not running by state
 I $D(ACDSTA("*ALL*")) Q  ;User wants all states
 I '$D(ACDSTA(ACDSTATE)) S ACDOK=0 Q  ;Sel states or categories
 ;
 ;
 ;
CNT ;Check to see if user is restricting output by contact type and
 ;if so, check the contact type of visit and see if it matches
 ;one that the user requested
 Q:'$D(ACDWDRV(1))
 I $D(ACDCRST),'$D(ACDCRST($P(ACDN0,U,4))) S ACDOK=0
