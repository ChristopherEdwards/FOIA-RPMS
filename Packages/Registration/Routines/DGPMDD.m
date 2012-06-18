DGPMDD ;ALB/MRL - FILE 405 DD CALLS; 27 JAN 89]
 ;;5.3;Registration;**41,129**;Aug 13, 1993
ID ;Display Identifiers
 N DGPMDISP
 S DGPMDD(1)=$S($D(^DPT(+$P(DGPMDD,"^",3),0)):^(0),1:"")
 S DGPMDISP(1)=$P(DGPMDD(1),"^")_" ("_$P(DGPMDD(1),"^",9)_")"
 S DGPMDISP(1,"F")="?30"
 S DGPMDISP(2)=$S($D(^DG(405.3,+$P(DGPMDD,"^",2),0)):$P(^(0),"^"),1:"TRANSACTION UNKNOWN")_":  "
 S DGPMDISP(2)=DGPMDISP(2)_$S($D(^DG(405.1,+$P(DGPMDD,"^",4),0)):$P(^(0),"^"),1:"UNKNOWN MOVEMENT TYPE")
 S DGPMDISP(2,"F")="!?15"
 D EN^DDIOL(.DGPMDISP)
 K DGPMDD
 Q
 ;
SCREEN(Y,DA,DGDT) ;screen called from various files/fields - select active providers in file 200
 ;File 405 - Patient Movement:
 ;     Field .08 - Primary Care Physician
 ;     Field .19 - Attending Physician
 ;File 2 - Patient:
 ;     Field .104 - Provider
 ;     Field .1041 - Attending Physician
 ;File 41.1 - Scheduled Admission:
 ;     Field 5 - Provider
 ;File 45 - PTF, Subfile 45.02 (Field 50) - 501:
 ;     Subfield 24 - Provider
 ;File 45.7 - Facility Treating Speciality, Subfile 45.701 (Field 10):
 ;     Subfield .01 - Providers
 ;INPUT:  Y=ien if file 200
 ;        DA=record edited
 ;        DGDT=date, either today's or date of movement
 ;date of movement is used for fields .19 (attending) & .08 (primary) in file 405.
 ;OUTPUT: 1 to select; 0 to not select
 S:'+$G(DA) DA=0 S:'+$G(DGDT) DGDT=DT I '+$G(Y) Q 0
 N DGINACT,DGY S DGY=0,DGDT=$P(DGDT,".")
 I $D(^VA(200,"AK.PROVIDER",$P($G(^VA(200,+Y,0)),U),+Y)) D
 .S DGY=0,DGINACT=$G(^VA(200,+Y,"PS"))
 .S DGY=$S(DGINACT']"":1,'+$P(DGINACT,U,4):1,DGDT'>+$P(DGINACT,U,4):1,1:0)
 Q DGY
 ;
HELP(DA,DGDT) ;executable help called from various files/fields - display active providers in file 200
 ;File 405 - Patient Movement:
 ;     Field .08 - Primary Care Physician
 ;     Field .19 - Attending Physician
 ;File 2 - Patient:
 ;     Field .104 - Provider
 ;     Field .1041 - Attending Physician
 ;File 41.1 - Scheduled Admission:
 ;     Field 5 - Provider
 ;File 45 - PTF, Subfile 45.02 (Field 50) - 501:
 ;     Subfield 24 - Provider
 ;File 45.7 - Facility Treating Speciality, Subfile 45.701 (Field 10):
 ;     Subfield .01 - Providers
 ;INPUT:  DA=record edited
 ;        DGDT=date, either today's or date of movement
 ;date of movement is used for fields .08 (attending) & .19 (primary) in file 405.
 S:'+$G(DGDT) DGDT=DT I '+$G(DA) Q
 ;OUTPUT: display of active providers
 N D,DGINACT,DO,DIC,X
 S X="??",DIC="^VA(200,",DIC(0)="EQ",D="AK.PROVIDER"
 S DIC("S")="I $$SCREEN^DGPMDD(Y,DA,DGDT)"
 D IX^DIC
 Q
