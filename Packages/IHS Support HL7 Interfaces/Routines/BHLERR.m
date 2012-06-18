BHLERR ; cmi/flag/maw - BHL HL7 Error Processing ; 
 ;;3.01;BHL IHS Interfaces with GIS;**2**;OCT 15, 2002
 ;
 ;this routine will handle error processing for HL7 messages
 ;
TRAP ;-- file the error
 I BHLERCD="GEN" D
 . S BHLGERR="Error filing field "_$$BHLFLD(BHLEFL,BHLFLD)_" in file "_$$BHLFL(BHLEFL)
 S BHLERIEN=$O(^BHLEM("B",BHLERCD,0))
 Q:'$G(BHLERIEN)
 S BHLERT=$S(BHLERCD="GEN":BHLGERR,1:$G(^BHLEM(BHLERIEN,1)))
 I $P(^BHLEM(BHLERIEN,0),U,2)="W" S BHLERR("WARNING")=BHLERT
 I $P(^BHLEM(BHLERIEN,0),U,2)="F" S BHLERR("FATAL")=BHLERT
 S BHLVAL=$S($G(BHLVAL):$P(BHLVAL,CS),1:"NO DATA VALUE")
 D ERR
 K BHLERCD,BHLERT
 Q
 ;
ERR ;-- this acutally files the error
 Q:'$G(BHLUIF)
 K DD,DO
 D NOW^%DTC S Y=% X ^DD("DD") S BHLNOW=Y
 S DIC="^BHLERR(",DIC(0)="L"
 S DIC("DR")=".02///"_$G(BHLRAP)_";.03///"_$G(BHPSAP)
 S DIC("DR")=DIC("DR")_";.04///"_$G(BHLRAF)_";.05///"_$G(BHLSAF)
 S DIC("DR")=DIC("DR")_";.06///"_$G(BHLRTN)_";.07///"_$G(BHLNOW)
 S DIC("DR")=DIC("DR")_";.08////"_$G(BHLERIEN)_";.09///"_$G(BHLERT)
 S DIC("DR")=DIC("DR")_";1///"_$G(BHLVAL)
 S X=BHLUIF
 D FILE^DICN
 Q
 ;
BHLFLD(BHLDIE,BHLDR)         ;get field name
 S BHLFNM=$P(^DD(BHLDIE,BHLDR,0),U)
 Q BHLFNM
 ;
BHLFL(BHLDIE)      ;get file name
 S BHLFLNM=$O(^DD(BHLDIE,0,"NM",0))
 Q BHLFLNM
 ;
