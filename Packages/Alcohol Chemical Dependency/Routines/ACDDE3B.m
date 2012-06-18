ACDDE3B ;IHS/ADC/EDE/KML - GENERATE SUBORDINATE FILE ENTRIES; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
GENIIF ; EP - GENERATE NEW CDMIS INIT/INFO/FU
 D GENIIF2
 I (ACDFHCP+ACDFPCC),$G(ACDDFNP) S Y=$O(^ACDIIF("C",ACDVIEN,0)) I Y S ACDPCCL(ACDDFNP,ACDVIEN,"IIF",Y)=""
 Q
 ;
GENIIF2 ;
 S ACDQ=1
 S DIE="^ACDVIS(",DA=ACDVIEN,DR="[ACD INIT/INFO/FU ADD]",DIE("NO^")="BACK"
 D DIE^ACDFMC
 Q:$D(DTOUT)!($D(DUOUT))
 I $D(Y) W !,IORVON,"Creation of CDMIS INIT/INFO/FU record failed.  Notify programmer.",IORVOFF,!! S:$D(^%ZOSF("$ZE")) X="CDMIS INIT/INFO/FU",@^("$ZE") D @^%ZOSF("ERRTN") D PAUSE^ACDDEU Q
 I '$G(ACDIIEN) S ACDQ=0 Q  ;    must have hit return to .01 field
 S ACDCEFLE="INIT/INFO/FU",ACDCEGBL="^ACDIIF(",ACDCEIEN=ACDIIEN
 F  D CHKEDIT Q:ACDQ
 K ACDCEFLE,ACDCEGBL,ACDCEIEN
 S ACDQ=0
 Q
 ;
GENTDC ; EP - GENERATE NEW CDMIS TRANS/DISC/CLOSE
 D GENTDC2
 I (ACDFHCP+ACDFPCC) S Y=$O(^ACDTDC("C",ACDVIEN,0)) I Y S ACDPCCL(ACDDFNP,ACDVIEN,"TDC",Y)=""
 Q
 ;
GENTDC2 ;
 S ACDQ=1
 S DIE="^ACDVIS(",DA=ACDVIEN,DR="[ACD TRANS/DISC/CLOSE ADD]",DIE("NO^")="BACK"
 D DIE^ACDFMC
 Q:$D(DTOUT)!($D(DUOUT))
 I $D(Y)!('$G(ACDTDC)) W !,IORVON,"Creation of CDMIS TRANS/DISC/CLOSE record failed.  Notify programmer.",IORVOFF,!! S ACDQ=1 S:$D(^%ZOSF("$ZE")) X="CDMIS TRANS/DISC/CLOSE",@^("$ZE") D @^%ZOSF("ERRTN") D PAUSE^ACDDEU Q
 S ACDCEFLE="TRANS/DISC/CLOSE",ACDCEGBL="^ACDTDC(",ACDCEIEN=ACDTDC
 F  D CHKEDIT Q:ACDQ
 K ACDCEFLE,ACDCEGBL,ACDCEIEN
 S ACDQ=0
 Q
 ;
GENCS ; EP - GENERATE NEW CDMIS CLIENT SVCS
 K ACDCS ;         kill client svcs array set by input template
 F  D GENCS2 Q:ACDQ
 S ACDQ=0
 I (ACDFHCP+ACDFPCC) S Y=0 F  S Y=$O(ACDCS(Y)) Q:'Y  S ACDPCCL(ACDDFNP,ACDVIEN,"CS",Y)=""
 Q
 ;
GENCS2 ; ALLOW COPY SETS/CLIENT SVCS UNTIL ALL DONE
 S ACDQ=1
 S DIR(0)="SO^"_$S($D(ACDCS):"0:Exit;",1:"")_"1:Individual Client Services;2:Group Client Services",DIR("A")="Do you want to "_$S($D(ACDCS):"exit or ",1:"")_"enter individual client services or perform group client services"
 S DIR("B")=$S($D(ACDCS):"0",1:"1") K DA D ^DIR K DIR
 Q:$D(DIRUT)
 Q:Y=0
 I Y=1 D GENCSI I 1 ;       generate individual client services
 E  D GENCSM^ACDDE3C ;      generate a copy set of client services (group client services)
 Q:ACDQ
 S ACDCEFLE="CLIENT SVCS",ACDCEGBL="^ACDCS(",ACDCEIEN=0
 F  D CHKEDIT Q:ACDQ
 K ACDCEFLE,ACDCEGBL,ACDCEIEN
 S ACDQ=0
 Q
 ;
GENCSI ; GENERATE INDIVIDUAL CLIENT SVCS
 S DIE="^ACDVIS(",DA=ACDVIEN,DR="[ACD CLIENT SVCS ADD]",DIE("NO^")="BACK"
 D DIE^ACDFMC
 Q:$D(DTOUT)
 I $D(Y) W !,IORVON,"Creation of CDMIS CLIENT SVCS record failed.  Notify programmer.",IORVOFF,!! S ACDQ=1 S:$D(^%ZOSF("$ZE")) X="CDMIS CLIENT SVCS",@^("$ZE") D @^%ZOSF("ERRTN") D PAUSE^ACDDEU Q
 Q:'$D(ACDCS)  ;          no CS records created
 S ACDQ=0
 Q
 ;
CHKEDIT ; ALLOW EDIT OF RECORD(S) JUST GENERATED
 S ACDQ=1
 W !!,"You may now display or edit the CDMIS ",ACDCEFLE," record(s) just created."
 S DIR(0)="S^0:Continue;1:Display record;2:Edit record" S:ACDCONT="CS" DIR(0)=DIR(0)_";3:Delete record" S DIR("B")="0" K DA D ^DIR K DIR
 S ACDY=Y
 Q:'ACDY
 I ACDCONT="CS" D CHKEDIT2 Q:'ACDCEIEN  ;  select one CS entry
 W !
 I ACDY=1 S DIC=ACDCEGBL,DA=ACDCEIEN,ACDQ=0 D DIQ^ACDFMC,PAUSE^ACDDEU Q
 I ACDY=3 D  Q  ;      make sure they really want to delete then do it
 . S ACDQ=0
 . S DIR(0)="YO",DIR("A")="Are you sure you want to delete this entry",DIR("B")="N" K DA D ^DIR K DIR
 . Q:'Y  ;        guess they changed their mind
 . K ACDCS(ACDCEIEN) S DIK="^ACDCS(",DA=ACDCEIEN D DIK^ACDFMC
 . Q
 ; must be 2 edit
 S DIE=ACDCEGBL,DA=ACDCEIEN,DR="[ACD "_ACDCEFLE_" EDIT]"
 D DIE^ACDFMC
 S ACDQ=0
 Q
 ;
CHKEDIT2 ; SELECT ONE CS ENTRY
 N ACDY
 S ACDCEIEN=0
 K ACDX
 W !,?5,"Select one of the following:",!!
 S (ACDLC,ACDY)=0
 F  S ACDY=$O(ACDCS(ACDY)) Q:'ACDY  D
 . S ACDLC=ACDLC+1
 . S ACDX(ACDLC)=ACDY
 . S X=^ACDCS(ACDY,0),Z=$P(X,U,2),X=+X
 . D PFTV^XBPFTV(9002170.6,Z,.Z)
 . W ?10,ACDLC,?20,X,?25,Z,!
 . I '(ACDLC#20) D PAUSE^ACDDEU W !
 . Q
 S DIR(0)="NO^1:"_ACDLC_":0",DIR("A")="Select one Client Service entry." K DA D ^DIR K DIR
 K ACDLC
 Q:$D(DIRUT)
 S ACDCEIEN=ACDX(Y)
 Q
