APCDGAP2 ;IHS/CMI/LAB - PATIENT GOALS APIs;11-Nov-2011 11:31;DU
 ;;2.0;IHS PCC SUITE;**7**;MAY 14, 2009
 ;
 ;
 ;
 ;
ADDREV(APCDGIEN,APCDREVD,APCDREVT,RETVAL) ;PEP - ADD A REVIEW TO A GOAL 9000093.13
 ;INPUT:  ien of goal,review date,review text,return value
 ;OUTPUT:  ien of review entry in multiple or 0^error text
 ;
 I '$G(APCDGIEN) S RETVAL="0^invalid ien" Q
 I '$D(^AUPNGOAL(APCDGIEN)) S RETVAL="0^invalid ien, not entry" Q
 S APCDREVD=$G(APCDREVD)
 S APCDREVT=$G(APCDREVT)
 I APCDREVD="" S RETVAL="0^invalid review date" Q
 I APCDREVT="" S RETVAL="0^review text null" Q
 ;edit incoming values
 NEW DIE,DA,DR,X,Y,%DT,APCDFU,APCDI,APCDRD,APCDIENS,APCDFDA,APCDERR
 S X=$G(APCDREVD)
 S %DT=""
 D ^%DT
 I Y=-1 S RETVAL="0^review date invalid" Q
 S APCDRD=Y
 S Y=""
 D CHK^DIE(9000093.13,.02,"",APCDREVT,.Y)
 I Y="^" S RETVAL="0^invalid review note" Q
 ;add review to multiple
 S APCDIENS=""
 S APCDFDA(9000093.13,"+2,"_APCDGIEN_",",.01)=APCDRD
 S APCDFDA(9000093.13,"+2,"_APCDGIEN_",",.02)=APCDREVT
 D UPDATE^DIE("","APCDFDA","APCDIENS","APCDERR(1)")
 I $D(APCDERR(1)) S RETVAL=APCDERR("DIERR",1,"TEXT",1)
 S RETVAL=APCDIENS(2)
 Q
 ;
ADDSTEP(APCDGIEN,SDAT,SRETVAL) ;PEP - add a step to a goal
 ;Add a Step to an existing goal
 ;  SDAT - array of steps to be added if adding steps
 ;      SDAT(n)=facility^step number^step type^step start date^step f/u date^provider^step text
 ;              one entry in array for each step being added
 ;              step number is optional, if not passed the next available step number will be used
 ;              values can be internal or external
 ;              user created / user last update fields auto stuffed with DUZ
 ;              date created / date last updated fields auto stuffed with DT and NOW^XLFDT
 ;
 ;              Example:
 ;              SDAT(1)="5217^1^NUTRITION^3101029^3101231^1239^EAT LESS THAN 1200 CAAPCDTESTES PER DAY
 ;              SDAT(2)="5217^2^PHYSICAL ACTIVITY^3101029^3101231^1239^WALK 60 MINUTES PER DAY
 NEW APCDF,APCDC,APCDSTEX,APCDSIEN,APCDIENS,APCDLOC,APCDE,APCDI,APCDERR,APCDGDAT,APCDSTD,APCDSNUM,APCDSTT,APCDSD,APCDFUD,APCDPROV,APCDNIEN
 NEW X,Y,DIC,DA
 K SRETVAL
 S APCDC=0 F  S APCDC=$O(SDAT(APCDC)) Q:APCDC'=+APCDC  D
 .S SRETVAL(APCDC)=""
SREQ .;Required fields
 .F APCDF=1,3:1:7 I $P(SDAT(APCDC),U,1)="" S SRETVAL(APCDC)="0^"_APCDF_" field value missing, required to create a STEP"
 .;check all incoming data values and convert all to internal values
 .;check facility
 .S X=$P(SDAT(APCDC),U,1)
 .I X="" S X=DUZ(2)
 .I X'?1.N S X=$O(^DIC(4,"B",X,0))
 .I X="" S SRETVAL(APCDC)="0^Facility value invalid" Q
 .S APCDLOC=X
 .;
 .S X=$P(SDAT(APCDC),U,2) I X]"" I +X'=X!(X>9999)!(X<1) S SRETVAL(APCDC)="0^Step number invalid, must be a number between 1-9999" Q
 .I X="" S X=$$NEXTSN(APCDGIEN,APCDLOC)
 .S APCDSNUM=X
 .S Y=$O(^AUPNGOAL(APCDGIEN,21,"B",APCDLOC,0))
 .I Y,$D(^AUPNGOAL(APCDGIEN,21,Y,11,"B",APCDSNUM)) S SRETVAL(APCDC)="0^Step number already in use" Q
 .;check step type
 .S Y=$P(SDAT(APCDC),U,3) I Y?1.N,'$D(^APCDTPGT(Y)) D E("invalid patient goal type") Q
 .I Y'?1.N S X=Y,DIC="^APCDTPGT(",DIC(0)="" D ^DIC D  Q:Y=-1
 ..I Y=-1 D E("invalid patient goal type") Q
 .S APCDSTT=+Y
 .;start date
 .S X=$P(SDAT(APCDC),U,4)
 .S %DT=""
 .D ^%DT
 .I Y=-1 S SRETVAL(APCDC)="0^start date invalid" Q
 .S APCDSD=Y
 .;follow up date
 .S X=$P(SDAT(APCDC),U,5)
 .S %DT=""
 .D ^%DT
 .I Y=-1 S SRETVAL(APCDC)="0^Goal start date invalid" Q
 .I Y<APCDSD S RETVAL="0^Follow up date cannot be prior to start date" Q
 .S APCDFUD=Y
 .;provider
 .S X=$P(SDAT(APCDC),U,6)
 .I X=""!(X?1.N) S (APCDPROV,X)=DUZ
 .S Y=""
 .I X'?1.N D CHK^DIE(9000093.211101,.1,"",X,.Y)
 .I Y="^" S SRETVAL(APCDC)="0^Provider value invalid" Q
 .I '$G(APCDPROV) S APCDPROV=Y
 .;step text
 .S X=$P(SDAT(APCDC),U,7)
 .D CHK^DIE(9000093.211101,1101,"",X,.Y)
 .I Y="^" S RETVAL="0^provider" Q
 .S APCDSTEX=Y
 .S APCDNIEN=$O(^AUPNGOAL(APCDGIEN,21,"B",APCDLOC,0))
 .I APCDNIEN="" S X="`"_APCDLOC,DIC="^AUPNGOAL("_APCDGIEN_",21,",DA(1)=APCDGIEN,DIC(0)="L",DIC("P")=$P(^DD(9000093,2100,0),U,2) D ^DIC K DIC,DA,DR,Y,X S APCDNIEN=$O(^AUPNGOAL(APCDGIEN,21,"B",APCDLOC,0))
 .I APCDNIEN="" S SRETVAL(APCDC)="0^ERROR UPDATING STEP LOCATION MULTIPLE" Q
 .K DIC
 .S X=APCDSNUM,DA(1)=APCDNIEN,DA(2)=APCDGIEN,DIC="^AUPNGOAL("_APCDGIEN_",21,"_APCDNIEN_",11,",DIC("P")=$P(^DD(9000093.21,1101,0),U,2),DIC(0)="L"
 .D ^DIC K DA,DR
 .I Y=-1 S SRETVAL(APCDC)="0^ERROR when updating step number multiple" Q
 .S DIE=DIC K DIC S (APCDSIEN,DA)=+Y
 .S DR=".02////^S X=DUZ;.03////^S X=DT;.07////^S X=DUZ;.08////^S X=$$NOW^XLFDT;.04////"_APCDSTT_";.05////"_APCDSD_";.06////"_APCDFUD_";.09////A;.1////^S X=APCDPROV;1101////"_APCDSTEX
 .D ^DIE
 .I $D(Y) S SRETVAL(APCDC)="0^error updating multiple for step entry" K DIE,DA,DR,Y Q
 .S SRETVAL(APCDC)=APCDSIEN
 Q
DELSTEP(APCDGIEN,APCDLIEN,APCDSIEN,APCDSPRV,APCDSDTD,APCDSREA,APCDSOTH,RET) ;PEP - DELETE A STEP
 ;delete a step
 ;  INP = Problem IEN,Location IEN,Note IEN
 ;  OUTPUT = 1 if delete successful or 0^error message
 NEW DA
 S RET=""
 I '$G(APCDGIEN) S RET="0^invalid goal ien" Q
 I '$D(^AUPNGOAL(APCDGIEN,0)) S RET="0^invalid goal ien" Q
 I '$G(APCDLIEN) S RET="0^invalid location ien" Q
 I '$G(APCDSIEN) S RET="0^invalid note ien" Q
 S APCDLIEN=$O(^AUPNGOAL(APCDGIEN,21,"B",APCDLIEN,0))
 I 'APCDLIEN S RET="0^could not find location entry in multiple" Q
 I '$D(^AUPNGOAL(APCDGIEN,21,APCDLIEN,11,APCDSIEN)) S RET="0^invalid step ien, does not exist" Q
 S APCDSPRV=$G(APCDSPRV) I 'APCDSPRV S APCDSPRV=DUZ
 S APCDSDTD=$G(APCDSDTD) I 'APCDSDTD S APCDSDTD=$$NOW^XLFDT()
 S APCDSREA=$G(APCDSREA)
 S APCDSOTH=$G(APCDSOTH)
 S DA=APCDSIEN
 S DA(1)=APCDLIEN
 S DA(2)=APCDGIEN
 S DIE="^AUPNGOAL("_APCDGIEN_",21,"_APCDLIEN_",11,",DIC("P")=$P(^DD(9000093.21,1101,0),U,2)
 S DR=".09////D;2.01////"_APCDSPRV_";2.02////"_APCDSDTD_";2.03///"_APCDSREA_";2.04///"_APCDSOTH D ^DIE K DIE,DR,DA,Y
 I $D(Y) S RETVAL="0^error updating step status" Q
 S RET=1
 Q
EDITSTEP(GIEN,LIEN,SIEN,APCDFUD,APCDSTAT,RET) ;PEP - edit a step entry
 ;edit a step entry
 ;per requirements only the followup date and status can be edited
 ;INPUT:  goal ien, location ien, note ien, new f/u date, status
 ;OUTPUT:  1 if edit successful, 0^error message if not successful
 I '$G(GIEN) S RETVAL="0^invalid ien" Q
 I '$D(^AUPNGOAL(GIEN)) S RETVAL="0^invalid ien, not entry" Q
 S APCDFUD=$G(APCDFUD)
 S APCDSTAT=$G(APCDSTAT)
 I '$G(LIEN) S RET="0^invalid location ien" Q
 I '$G(SIEN) S RET="0^invalid note ien" Q
 S LIEN=$O(^AUPNGOAL(GIEN,21,"B",LIEN,0))
 I 'LIEN S RET="0^could not find location entry in multiple" Q
 I '$D(^AUPNGOAL(GIEN,21,LIEN,11,SIEN)) S RET="0^invalid note ien, does not exist" Q
 ;edit incoming values
 NEW DIE,DA,DR,X,Y,%DT,APCDFU,APCDI,APCDRD,APCDIENS,APCDFDA,APCDERR
 S X=$G(APCDFUD)
 I X="" G S1
 S %DT=""
 D ^%DT
 I Y=-1 S RETVAL="0^Goal followup date invalid" Q
 S APCDFU=Y
 S X=$P(^AUPNGOAL(GIEN,21,LIEN,11,SIEN,0),U,5) I X>APCDFU S RETVAL="0^STEP followup date cannot be less than start date" Q
S1 ;
 S X=$G(APCDSTAT),APCDI=""
 D CHK^DIE(9000093,.11,"",X,.APCDI)
 I APCDI="^" S RETVAL="0^invalid status value" Q
 S DA=SIEN
 S DA(1)=LIEN
 S DA(2)=GIEN
 S DIE="^AUPNGOAL("_GIEN_",21,"_LIEN_",11,",DIC("P")=$P(^DD(9000093.21,1101,0),U,2)
 S DR=".09////"_APCDSTAT_";.06////"_APCDFU_";.07////^S X=DUZ;.08////^S X=$$NOW^XLFDT" D ^DIE K DIE,DR,DA,Y
 I $D(Y) S RET="0^error updating step status" Q
 S RET=1
 Q
NEXTSN(I,F) ;PEP - return next step number for this goal, facility
 NEW X,Y,J
 S J=$O(^AUPNGOAL(I,21,"B",F,0))
 I 'J Q 1
 S (Y,X)=0 F  S Y=$O(^AUPNGOAL(I,21,J,11,"B",Y)) S:Y X=Y I 'Y S X=X+1 K Y Q
 Q X
NEXTGN(P,F) ;PEP - return next available goal number for patient P, facility F
 I $G(P)="" Q ""
 I $G(F)="" Q ""
 I '$D(^AUPNPAT(P)) Q ""
 I '$D(^AUTTLOC(F)) Q ""
 Q $E($O(^AUPNGOAL("AA",P,F,""),-1),2,999)\1+1
 ;
E(V) ;
 S APCDC=APCDC+1,$P(RETVAL,"|",APCDC)=V
 Q
