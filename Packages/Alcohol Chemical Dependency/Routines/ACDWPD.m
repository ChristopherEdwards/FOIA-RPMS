ACDWPD ;IHS/ADC/EDE/KML - SET LOC VARS FROM ACDPD FILE;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;**********************************************************************
 ;//^ACDTX10, ^ACDWDRV5
 ;Needs ACDDA as internal DA to file entry
 ;***********************************************************************
 S ACDN0=^ACDPD(ACDDA,0)
 S ACDPDT=$P(ACDN0,U)
 S ACDCOMC=$P(ACDN0,U,2) S:ACDCOMC="" ACDCOMC="NF" S ACDCOMCL=$S($D(^ACDCOMP(ACDCOMC,0)):$P(^(0),U),1:"NF")
 S ACDPG=$P(ACDN0,U,4)
 I $D(^ACDF5PI(ACDPG,0)) S ACDPG=$P(^ACDF5PI(ACDPG,0),U),ACDPG=$P(^AUTTLOC(ACDPG,0),U),ACDAUF=$P(^(0),U,10),ACDPG=$P(^DIC(4,ACDPG,0),U)
 E  S ACDPG="NOT DEFINED"
 S (ACDCOMT,ACDP(3))=$P(ACDN0,U,3),ACDP(1)=9002170.7,ACDP(2)=2 S ACDCOMTL=$$SETS^ACDFUNC(.ACDP)
 ;S (ACDPROV,ACDPROVP)=$P(ACDN0,U,5) S:ACDPROV="" ACDPROV="NF" S ACDPROV=$S($D(^DIC(16,ACDPROV,0)):$P(^(0),U),1:"NF")
 S (ACDPROV,ACDPROVP)=$P(ACDN0,U,5) S:ACDPROV="" ACDPROV="NF" S ACDPROV=$S($D(^VA(200,ACDPROV,0)):$P(^(0),U),1:"NF")
 Q:$D(ACDWSTAF(1))
MATCH ;
 ;***************************************************************
 ;This is the key to building report data or not. We go to ^ACDWASF
 ;and check to see if the record ASUFAC matches one of the arrays
 ;defined by the user's request. If so, ACDONE,ACDTWO,ACDTHREE will
 ;come back defined.
 ;If a match is found, keep counters of how many visit records matched
 ;for the area, su, or facility
 ;***************************************************************
 S ACDOK=0 D ^ACDWASF I $D(ACDONE),$D(ACDTWO),$D(ACDTHREE) S ACDOK=1
 I $D(ACDFAC(ACDAUF)),ACDOK S ACDFAC(ACDAUF)=ACDFAC(ACDAUF)+1 Q
 I $D(ACDAREA($E(ACDAUF,1,2))),ACDOK S ACDAREA($E(ACDAUF,1,2))=ACDAREA($E(ACDAUF,1,2))+1 Q
 I $D(ACDSU($E(ACDAUF,1,4))),ACDOK S ACDSU($E(ACDAUF,1,4))=ACDSU($E(ACDAUF,1,4))+1 Q
 Q
 ;
M ;EP Multiple // ^ACDWDRV5
 S ACDN01=^ACDPD(ACDDO,1,ACDA1,0)
M1 ;EP Multiple //^ACDWSTA1
 S ACDAY=$P(ACDN01,U) S:'ACDAY ACDAY=0
 S ACDCOED=$P(ACDN01,U,7)
 S ACDPRVA=$P(ACDN01,U,2) S:ACDPRVA="" ACDPRVA="NF" S ACDPRVA=$S($D(^ACDPREV(9002170.9,ACDPRVA,0)):$P(^(0),U),1:"NF"),ACDPRVC=$S($D(^(0)):$P(^(0),U,2),1:"NF")
 S ACDLOTY=$P(ACDN01,U,3) S:'ACDLOTY ACDLOTY="NF" S ACDLOTY=$S($D(^ACDLOT(ACDLOTY,0)):$P(^(0),U),1:"NF")
 S ACDP(3)=$P(ACDN01,U,4),ACDP(2)=3,ACDP(1)=9002170.75 S ACDTRG=$$SETS^ACDFUNC(.ACDP)
 S ACDNUMR=$P(ACDN01,U,5) S:'ACDNUMR ACDNUMR=0
 S ACDPCHRS=$P(ACDN01,U,8) S:'ACDPCHRS ACDPCHRS=0
 S ACDP(3)=$P(ACDN01,U,6),ACDP(2)=5,ACDP(1)=9002170.75 S ACDOUTC=$$SETS^ACDFUNC(.ACDP)
 ;S ACDSUB(ACDA1)=ACDAY_U_ACDPRVA_U_ACDLOTY_U_ACDTRG_U_ACDNUMR_U_ACDOUTC
 ;
