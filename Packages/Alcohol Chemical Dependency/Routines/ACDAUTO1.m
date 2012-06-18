ACDAUTO1 ;IHS/ADC/EDE/KML - auto create client services for multiple dfn's; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;;
 ;***********************************************************
 ;ACDVISP is set in the input template and must be defined
 ;when leaving the template and coming here. ACDVISP is the
 ;internal DA to ^ACDVIS for the original visit
 ;***********************************************************
EN ;EP Ask for clients to auto create 'CS' for
 ;//^ACDDE
 D MAIN
 D K
 Q
 ;
MAIN ;
 K ACDQUIT
 Q:'$G(ACDVISP)
 S ACDOPAT=$P(^ACDVIS(ACDVISP,0),U,5) ;   save patient IEN
 ;
 S:'$D(ACDLINE) $P(ACDLINE,"=",80)="="
 ;W @IOF,!,ACDLINE,!,*7,*7,*7
 W !!,ACDLINE,!
 I $G(ACDDECSN) D  I 1
 . W "Since you have created a new Client Service visit, I can now",!
 . W "automatically create an exact duplicate of it for you with",!
 . W "the visit and 'ALL' attached client service days but for",!
 . W "different patients you select.",!
 . Q
 E  D
 . W "Since you have added client service days to a Client Service",!
 . W "visit I can now automatically duplicate the client service days",!
 . W "for different patients you select.",!
 . Q
 W ACDLINE,!
 ;
DIR ;Ask for patients Category or Selected patients
 S DIR("A")="SELECTION",DIR(0)="S^1:SELECT A CATEGORY OF PATIENTS;3:EXIT" D ^DIR S:X["^"!($D(DTOUT))!(X="")!(X=3) ACDQUIT=1
 Q:$D(ACDQUIT)
 W !
 ;
 ;Ask for category of patients
 K ACDPT1
 S DIC=9002172.8,DIC(0)="AEQM",DIC("S")="I $P(^(0),U,3)=ACDCOMC,$P(^(0),U,4)=ACDCOMT,$P(^(0),U,2)=ACDPGM" D ^DIC
 G:Y<0 DIR
 I $D(^ACDPAT(+Y,1,0)) S ACDCATP=+Y F ACDA=0:0 S ACDA=$O(^ACDPAT(+Y,1,ACDA)) Q:'ACDA  I $D(^(ACDA,0)) S ACDPT1(ACDA)=""
 ;
EN1 ;Begin auto creation process of entries in ^ACDVIS
 Q:'$O(ACDPT1(0))
 W !!,"Auto creating visit nodes for:",!!
 F ACDDFNP=0:0 S ACDDFNP=$O(ACDPT1(ACDDFNP)) Q:'ACDDFNP  D
 . Q:ACDDFNP=ACDOPAT  ;   don't process original patient
 . W $P(^DPT(ACDDFNP,0),U),!
 . D CHKCSV ;             see if CS visit exists
 . I ACDVIEN S ACDPT1(ACDDFNP)=ACDVIEN Q
 . D GENCSV ;             go autoduplicate the CS visit
 . Q
 D CS ;                   go autoduplicate the CS entries
 Q
 ;
CHKCSV ; SEE IF CS VISIT EXISTS
 S ACDVIEN=0
 D GETVSITS^ACDDEU ;      gather up all visits for this patient
 S ACDY=0
 I $D(^TMP("ACD",$J,"VISITS",ACDVDTI)) S ACDY=0 F  S ACDY=$O(^TMP("ACD",$J,"VISITS",ACDVDTI,ACDY)) Q:'ACDY  D  Q:ACDQ
 . S X=^ACDVIS(ACDY,0)
 . I $P(X,U,2)=ACDCOMC,$P(X,U,7)=ACDCOMT,$P(X,U,4)="CS" S ACDQ=1 Q
 . Q
 S ACDQ=0
 I ACDY S ACDVIEN=ACDY Q  ;   CS visit exists
 Q
 ;
GENCSV ; AUTODUPLICATE CS VISIT
 D GENV ;              generate CS visit with .01 field only
 D DUPV ;              duplicate the rest of the CS visit
 D MODV ;              modify demographic part of CS visit
 ;Re-index new entry in ^ACDVIS to be safe
 S DA=ACDPT1(ACDDFNP)
 S DIK="^ACDVIS(" D IX1^DIK
 Q
 ;
GENV ; GENERATE VISIT NODE
 S X=$P(^ACDVIS(ACDVISP,0),U)
 S DIC="^ACDVIS("
 S DIC(0)="L"
 D FILE^ACDFMC
 ;Reset ACDPT1 array to form ACDPT1(DFN)=DA
 S ACDPT1(ACDDFNP)=+Y
 Q
 ;
DUPV ; DUPLICATE CS VISIT
 ;Duplicate the original visit from ^ACDVIS for new patient
 S %X="^ACDVIS("_ACDVISP_","
 S %Y="^ACDVIS("_ACDPT1(ACDDFNP)_","
 D %XY^%RCR
 Q
 ;
MODV ; MODIFY DEMOGRAPHIC PORTION OF VISIT JUST GENERATED
 D MODV^ACDAUTO3
 Q
 ;
CS ;Begin auto creation of entries in ^ACDCS
 ;
 W !!,"Auto creating Client Service nodes now for:"
 F ACDDFNP=0:0 S ACDDFNP=$O(ACDPT1(ACDDFNP)) Q:'ACDDFNP  D
 .Q:ACDDFNP=ACDOPAT  ;       quit if original patient
 .W !!,$P(^DPT(ACDDFNP,0),U)
 .F ACDCSORI=0:0 S ACDCSORI=$O(ACDCS(ACDCSORI)) Q:'ACDCSORI  D
 ..;
 ..;Set up new entry in ^ACDCS i.e. set up .01 field
 ..S X=$P(^ACDCS(ACDCSORI,0),U),ACDUPDT=X
 ..S DIC="^ACDCS("
 ..S DIC(0)="L"
 ..D FILE^ACDFMC S ACDNEWCS=+Y
 ..;
 ..I (ACDFHCP+ACDFPCC) S ACDPCCL(ACDDFNP,ACDPT1(ACDDFNP),"CS",ACDNEWCS)=""
 ..;
 ..;Duplicate the original entries in the client service file
 ..S %X="^ACDCS("_ACDCSORI_","
 ..S %Y="^ACDCS("_ACDNEWCS_","
 ..D %XY^%RCR
 ..;
 ..;Set up the^ACDCS 'BWP' to ^ACDVIS
 ..S DIE="^ACDCS("
 ..S DA=ACDNEWCS
 ..S DR="99.99////^S X=ACDPT1(ACDDFNP)"
 ..D DIE^ACDFMC
 ..;
 ..;Re-index new entry in ^ACDCS to be safe
 ..S DIK="^ACDCS(",DA=ACDNEWCS D IX1^DIK W ?35,"Client service day: ",ACDUPDT," being auto-created.",!
 W !!!,"Finished auto-creating.",!
 Q
 ;
K ;
 K ACDA,ACDCATP,ACDCSORI,ACDLINE,ACDNEWCS,ACDPT1,ACDUPDT,ACDXXX
 Q
