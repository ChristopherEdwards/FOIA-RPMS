ACDDE3 ;IHS/ADC/EDE/KML - CDMIS DE - CONTACT TYPES;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
ADDIN ; EP - ADD INITIAL
 ; ADD MODE
 S ACDINR=0
 D CHKFIN ;           check for INITIAL
 Q:ACDQ
 D GENVSIT ;          generate CDMIS VISIT
 Q:ACDQ
 D GENIIF^ACDDE3B ;   generate CDMIS INIT/INFO/FU
 Q:ACDQ
 D FACE ;             print face sheet if wanted
 Q
 ;
ADDRE ; EP - ADD REOPEN
 ; ADD MODE
 S ACDINR=1
 D CHKFIN ;           check for INITIAL
 Q:ACDQ
 D CHKRE^ACDDE3A ;    logical check
 Q:ACDQ
 D GENVSIT ;          generate CDMIS VISIT
 Q:ACDQ
 D GENIIF^ACDDE3B ;   generate CDMIS INIT/INFO/FU
 Q:ACDQ
 D FACE ;             print face sheet if wanted
 Q
 ;
ADDFU ; EP - ADD FOLLOWUP
 ; ADD MODE
 S ACDINR=1
 D CHKFIN ;           check for INITIAL
 Q:ACDQ
 D CHKFU^ACDDE3A ;    logical check
 Q:ACDQ
 S DIR(0)="9002172.1,3.5",DIR("A")="Enter Follow-up Months" K DA D ^DIR K DIR
 S ACDFUM=Y
 D GENVSIT ;          generate CDMIS VISIT
 Q:ACDQ
 D GENIIF^ACDDE3B ;   generate CDMIS INIT/INFO/FU
 Q
 ;
ADDTD ; EP - ADD TRANS/DISC/CLOSE
 ; ADD MODE
 S ACDINR=1
 D CHKFIN ;           check for INITIAL
 Q:ACDQ
 D CHKTD^ACDDE3A ;    logical check
 Q:ACDQ
 D GENVSIT ;          generate CDMIS VISIT
 Q:ACDQ
 D GENTDC^ACDDE3B ;   generate CDMIS TRANS/DISC/CLOSE
 Q:ACDQ
 D FACE ;             print face sheet if wanted
 Q
 ;
ADDCS ; EP - ADD CLIENT SERVICE
 ; ADD MODE
 K ACDDECSN
 S ACDINR=1
 D CHKFIN ;           check for INITIAL
 Q:ACDQ
 D CHKCS^ACDDE3A ;    logical check
 Q:ACDQ
 D ADDCS2 ;           get/gen CDMIS VISIT
 Q:ACDQ
 D GENCS^ACDDE3B ;    generate CDMIS CLIENT SVCS
 Q
 ;
ADDCS2 ; EP - GET CS VISIT OR GENERATE A NEW ONE
 S ACDY=0
 I $D(^TMP("ACD",$J,"VISITS",ACDVDTI)) S ACDY=0 F  S ACDY=$O(^TMP("ACD",$J,"VISITS",ACDVDTI,ACDY)) Q:'ACDY  D  Q:ACDQ
 . S X=^ACDVIS(ACDY,0)
 . I $P(X,U,2)=ACDCOMC,$P(X,U,7)=ACDCOMT,$P(X,U,4)="CS" S ACDQ=1 Q
 . Q
 S ACDQ=0
 I ACDY S ACDVIEN=ACDY D  Q  ;   CS visit already exists
 . S ACDPROV=$P(^ACDVIS(ACDVIEN,0),U,3)
 .;D PFTV^XBPFTV(6,ACDPROV,.ACDPROVN)
 . S ACDPROVN=$P($G(^VA(200,ACDPROV,0)),U)
 . S ^TMP("ACD",$J,"PRI PROV")=ACDPROVN
 . ;D DSPCSH
 . Q
 ; will get here only if CS visit does not exist
 D GENVSIT ;                     generate CDMIS VISIT
 S:ACDVIEN ACDDECSN=ACDVIEN ;    set new CS visit flag
 Q
 ;
DSPCSH ; DISPLAY CLIENT SVC HISTORY FOR THIS CS VISIT
 Q:'$O(^ACDCS("C",ACDVIEN,0))
 W !,"CLIENT SVCS history for this CS VISIT",!,"----------",!
 K ACDPTBL
 S Y=0
 F  S Y=$O(^ACDCS("C",ACDVIEN,Y)) Q:'Y  S X=^ACDCS(Y,0),ACDPTBL($P(X,U),Y)=$P(X,U,2)
 S Y=0
 F  S Y=$O(ACDPTBL(Y)) Q:'Y  S Z=0 F  S Z=$O(ACDPTBL(Y,Z)) Q:'Z  S X=ACDPTBL(Y,Z) D PFTV^XBPFTV(9002170.6,X,.ACDX) W Y,?5,ACDX,!
 K ACDPTBL
 W "----------",!
 Q
 ;
ADDOT ; EP - ADD CRISIS/BRIEF INT
 D GENVSIT ;          generate CDMIS VISIT
 Q:ACDQ
 D GENIIF^ACDDE3B ;   generate CDMIS INIT/INFO/FU
 Q
 ;
ADDIR ; EP - ADD INFO/REFERRAL
 D GENVSIT ;          generate CDMIS VISIT
 Q:ACDQ
 D GENIIF^ACDDE3B ;   generate CDMIS INIT/INFO/FU
 Q
 ;
CHKFIN ; CHECK FOR INITIAL CONTACT TYPE
 D CHKFIN^ACDDEU
 Q
 ;
GENVSIT ; GENERATE NEW CDMIS VISIT
 S ACDQ=0,ACDVIEN=0
 D GENVSIT2 ;        set DR based on contact type
 Q:ACDQ
 S ACDQ=1
 S DIC="^ACDVIS(",DIC(0)="L",DLAYGO=9002172.1,X=ACDVDTI
 D FILE^ACDFMC
 I +Y<0 W !,IORVON,"Creation of CDMIS VISIT record failed.  Notify programmer.",IORVOFF,!! S ACDQ=1 S:$D(^%ZOSF("$ZE")) X="CDMIS VISIT",@^("$ZE") D @^%ZOSF("ERRTN") D PAUSE^ACDDEU Q
 S ACDVIEN=+Y
 W !!
 W $$VAL^XBDIQ1(9002172.1,ACDVIEN,.01)," - ",$$VAL^XBDIQ1(9002172.1,ACDVIEN,1),"/",$$VAL^XBDIQ1(9002172.1,ACDVIEN,5),"  ",$$VAL^XBDIQ1(9002172.1,ACDVIEN,3),!
 S DIR(0)="Y",DIR("A")="Accept visit as generated",DIR("B")="Y" K DA D ^DIR K DIR
 I 'Y S DIK="^ACDVIS(",DA=ACDVIEN D DIK^ACDFMC K:$G(ACDDFNP) ^TMP("ACD",$J,"PAT",ACDDFNP) S ACDVIEN=0 Q
 I (ACDFHCP+ACDFPCC),$G(ACDDFNP),ACDVIEN S ACDPCCL(ACDDFNP,ACDVIEN)=""
 S ACDQ=0
 Q
 ;
GENVSIT2 ; SET DR BASED ON CONTACT TYPE
 ; if IR or OT set and quit
 I ACDCONT="IR"!(ACDCONT="OT") D  Q
 .  S DIC("DR")="1////"_ACDCOMC_";2////"_ACDPROV_";3////"_ACDCONT_";5////"_ACDCOMT_";99.99////"_ACDPGM_";1102////"_DUZ
 .  Q  ;              Wilbur says to remove FT name
 .  Q:ACDCONT'="OT"
 .  D CBNAME
 .  Q:X=""
 .  S DIC("DR")=DIC("DR")_"26////"_X
 .  Q
 ; set for other than IR or OT
 I ACDCONT="CS" D GETPROV^ACDDE2 ;   get primary provider
 Q:ACDQ
 S DIC("DR")="1////"_ACDCOMC_";2////"_ACDPROV_";3////"_ACDCONT
 I ACDCONT="FU",ACDFUM]"" S DIC("DR")=DIC("DR")_";3.5////"_ACDFUM
 S DIC("DR")=DIC("DR")_";4////"_ACDDFNP_";5////"_ACDCOMT_";9////"_ACDAGER_";99.99////"_ACDPGM_";1102////"_DUZ
 S DIC("DR")=DIC("DR")_";101////"_ACDTRBCD_";102////"_ACDSTACD_";103////"_$E(ACDSEX)_";104////"_$E(ACDVET)_";105////"_ACDTRB_";106////"_ACDSTA_";107////"_ACDAGE
 Q
 ;
CBNAME ; GET NAME FOR CRISIS BRIEF
 S DIR(0)="9002172.1,26",DIR("A")="Enter patient name for Crisis Brief" K DA D ^DIR K DIR
 S:X["^" (X,Y)=""
 Q
 ;
FACE ; PRINT FACE SHEED IF WANTED
 Q:'$D(ACDVIEN)  ;                   quit if no visit
 I '$G(ACDIIEN),(ACDCONT="IN"!(ACDCONT="RE")) Q
 I ACDCONT="TD",'$G(ACDTDC) Q  ;     quit if TD and no TDC entry
 W !
 S DIR(0)="Y",DIR("A")="Print Face Sheet",DIR("B")="Y" K DA D ^DIR K DIR
 Q:'Y
 D DEV^ACDDEU
 Q:ACDQ
 D DISPLAY^ACDPFACE,PAUSE^ACDDEU
 Q
