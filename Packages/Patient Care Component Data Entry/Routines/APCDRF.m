APCDRF ; IHS/CMI/LAB - LIST MANAGER API'S FOR FAMILY HISTORY AND API FOR REP FACTORS 19 Jun 2008 2:14 PM ; 28 Jan 2009  11:59 AM 
 ;;2.0;IHS PCC SUITE;**2,7,11**;MAY 14, 2009;Build 58
 ;
 ;
 ;
RFADD(P) ;PEP - called to add a patient to the Reproductive Factors file
 ;output:  DFN (ien of entry, file is dinum)
 ;         0^error message if add failed
 I '$G(P) Q 0_"^patient DFN invalid"
 I '$D(^DPT(P)) Q 0_"^patient DFN invalid"
 I $P(^DPT(P,0),U,2)'="F" Q 0_"^patient not FEMALE"
 I $D(^AUPNREP(P,0)) Q P
 NEW X,DIC,DD,D0,DO,Y
 S X=P,DIC="^AUPNREP(",DIC(0)="L"
 K DD,D0,DO,DINUM
 S DINUM=X
 D FILE^DICN
 I Y=-1 Q 0_"^fileman failed adding patient"
 Q 1
 ;
RHEDIT(APCDIE,APCDPT,APCDDATA,RETVAL) ;PEP - called to edit reproductive hx data fields
 ;input - APCDPT is DFN of patient
 ;        APCDDATA - passed in by reference array containing fields and values to be updated and put in the FDA array.
 ;                  should be in format APCDDATA(field #)=value (either internal or external)
 ;        either internal or external values can be passed, values will be checked for validity
 ;        PLEASE NOTE:  if you send a field in the array and the value is blank the field value will be deleted, you can also send an "@" to delete a field value
 ;output - ien^error message 1 if error occured|error message 2 if error occured|error message 3|etc until all errors passed back to caller
 ;         if patient could not be added to the file the return value will be 0^error message
 ;note:  each individual field value passed is checked for validity, those that pass will be filed, those that don't will be passed back
 ;with the VAL^DIE message
 I '$G(APCDPT) S RETVAL="0^patient DFN invalid" Q
 I '$D(^DPT(APCDPT)) S RETVAL="0^patient DFN invalid" Q
 I $P(^DPT(APCDPT,0),"^",2)'="F" S RETVAL="0^patient not FEMALE" Q
 I $G(APCDVAL)="" S APCDVAL="I"
 I $G(APCDIE)="" S APCDIE="I"  ;default to internal values if not passed in
 NEW V,APCDIENS,APCDFDA,E,APCDC
 S APCDC=0
 I '$D(^AUPNREP(APCDPT,0)) S V=$$RFADD(APCDPT) I 'V S RETVAL=V Q
 ;I $G(APCDDATA)="" S RETVAL="0^no fields to edit" Q  ;Q APCDPT  ;no fields to edit??
 I '$D(APCDDATA) S RETVAL="0^no fields to edit" Q  ;Q APCDPT  ;no fields to edit??
 ;M APCDDATA=@APCDDATA
 I '$O(APCDDATA("")) S RETVAL="0^no fields in the data array" Q  ;Q APCDPT  ;no fields in the data array
 S APCDIENS=APCDPT_","
 S APCDIENS(1)=APCDPT
 ;let's check the values being passed in with VAL^DIE, if any are in error set error and don't set into FDA array
 ;guess you never know what people will try to pass
 NEW APCDF,APCDV,APCDE,APCDI
 I $G(APCDIE)="E" D  ;if external check the validity of data
 .S APCDF="" F  S APCDF=$O(APCDDATA(APCDF)) Q:APCDF=""  D
 ..I APCDF=".01" K APCDDATA(APCDF) Q  ;you can't edit the .01, it's dinum'ed
 ..I '$D(^DD(9000017,APCDF,0)) K APCDDATA(APCDF) D E("field number not valid") Q
 ..S APCDV=APCDDATA(APCDF)
 ..Q:APCDV=""
 ..K APCDE,APCDI
 ..S APCDI=""
 ..D VAL^DIE(9000017,APCDIENS,APCDF,"E",APCDV,.APCDI,,"APCDE")
 ..I $D(APCDE("DIERR",1,"TEXT",1)) D E(APCDE("DIERR",1,"TEXT",1)) K APCDDATA(APCDF) Q
 ..S APCDDATA(APCDF)=APCDI
 ;now set FDA array with values left that are valid and call FILE^DIE
 K APCDFDA
 S APCDF="" F  S APCDF=$O(APCDDATA(APCDF)) Q:APCDF=""  D
 .S APCDFDA(9000017,APCDIENS,APCDF)=APCDDATA(APCDF)
 ;CALL FILE^DIE
 K APCDE
 D FILE^DIE("K","APCDFDA","APCDE(0)")
 S APCDI=0 F  S APCDI=$O(APCDE(0,"DIERR",APCDI)) Q:APCDI'=+APCDI  D
 .Q:'$D(APCDE(0,"DIERR",APCDI,"TEXT"))
 .D E(APCDE(0,"DIERR",APCDI,"TEXT"))
 S RETVAL=APCDPT_"^"_RETVAL
 Q
E(V) ;
 S APCDC=APCDC+1,$P(RETVAL,"|",APCDC)=V
 Q
 ;
TEST ;
 S P=478
 K APCDLORI,LORIERR
 S APCDLORI(2)=3090101
 S APCDLORI(1103)="A"
 ;S APCDLORI(3)="O"
 S APCDLORI(3.05)=3090101
 S APCDLORI(4)=3100405
 S APCDLORI(4.05)="D"
 S APCDLORI(1103)=5
 S APCDLORI(1105)=0
 S APCDLORI(1107)=5
 S APCDLORI(1109)=0
 S APCDLORI(1111)=""
 S APCDLORI(1113)=5
 S APCDLORI(1131)="XX"
 S APCDLORI(1133)=""
 D RHEDIT("E",P,.APCDLORI,.LORIERR)
 ;ZW LORIERR
 Q
 ;
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
OLDCM(%) ;EP - called from trigger
 Q ""
SETTOMUL ;EP - called from trigger on 3 field
 NEW APCDDA,APCDDA1
 S APCDDA1=$G(D0) ;D0
 Q:'APCDDA1
 Q:'$D(^AUPNREP(APCDDA1,0))
 D EN^XBNEW("SETTOM1^APCDRF","APCDDA1")
 Q
 ;
NEWVAL(E) ;
 NEW X,Y,APCDTEXT,APCDY
 S Y=""
 S APCDTEXT="CMMAP" F APCDY=1:1 S X=$T(@APCDTEXT+APCDY) Q:$P(X,";;",2)=""!(Y]"")  I $P(X,";;",2)=E S Y=$P(X,";;",3)_U_$P(X,";;",4)
 Q Y
 ;
CMMAP ;;
 ;;ABSTINENCE;;ABSTINENCE
 ;;HORMONE INJECTION;;HORMONAL/DEPO PROVERA
 ;;HORMONAL IMPLANT;;HORMONAL/IMPLANT
 ;;MENOPAUSE;;NA MENOPAUSE
 ;;EDUCATION ONLY;;OTHER;;1
 ;;ORAL CONTRACEPTIVES;;OTHER;;1
 ;;IUD;;OTHER;;1
 ;;BARRIER METHODS;;OTHER;;1
 ;;OTHER;;OTHER
 ;;NATURAL TECHNIQUES;;PERIODIC ABSTINENCE METHODS
 ;;SURGICAL STERILIZATION;;STERILIZATION (FEMALE)
 ;;PARTNER STERILIZED;;STERILIZATION (MALE)
 ;;NONE;;NONE
 ;;
SETTOM1 ;
 ;create multiple from fields 3, 3.05, 3.1 if it doesn't currently exist
 ;edit the multiple .04 if it does exist
 ;if 3 field null do nothing
 ;
 NEW APCDFPV,APCDFPBD,APCDFPDT,APCDTE,APCDT,APCDCOM,APCDISNG,APCDX
 S APCDCOM="",APCDISNG=1
 S APCDFPV=$$VAL^XBDIQ1(9000017,APCDDA1,3)
 I APCDFPV="" Q  ;do nothing
 S APCDFPBD=$P(^AUPNREP(APCDDA1,0),U,7)
 S APCDFPDT=$P(^AUPNREP(APCDDA1,0),U,8)
 ;do we have this one on this begun date?  if so update .04 and quit
 S APCDTE=$$NEWVAL(APCDFPV)  ;get external new value
 I $P(APCDTE,U,1)="" Q  ;no external value
 S APCDT=$O(^AUTTCM("B",$P(APCDTE,U,1),0))
 I APCDT="" Q
 I APCDFPBD I $D(^AUPNREP("ACON",APCDDA1,APCDT,APCDFPBD)) S APCDX=$O(^AUPNREP("ACON",APCDDA1,APCDT,APCDFPBD,APCDDA1,0)) I APCDX,$P(^AUPNREP(APCDDA1,2101,APCDX,0),U,6)=APCDFPV Q  ;already has this one in the multiple
 I 'APCDFPBD Q:$$HASND(APCDDA1,APCDT,APCDFPV)  ;already have it with no date
 I $P(APCDTE,U,2) S APCDCOM=APCDFPV
 ;now create multiple entry
 S DIC="^AUPNREP("_APCDDA1_",2101,"
 S DIC(0)="L"
 S DA(1)=APCDDA1
 S DIC("P")=$P(^DD(9000017,2101,0),U,2)
 S X=APCDT
 S DIC("DR")=".02////"_APCDFPBD_";.06///"_APCDCOM   ;.04///^S X=$S($G(APCDDATE):$$FMTE^XLFDT(APCDDATE),1:$$FMTE^XLFDT(DT))"
 K DD,D0,DO
 D FILE^DICN
 K DIC,DD,DO,D0,DA
 Q
HASND(X,T,C) ;DOES THIS PATIENT HAVE THIS ONE WITH NO DATE BEGUN?
 NEW Y,G
 S G=0
 S Y=0 F  S Y=$O(^AUPNREP(X,2101,Y)) Q:Y'=+Y  I $P(^AUPNREP(X,2101,Y,0),U,1)=T,$P(^AUPNREP(X,2101,Y,0),U,2)="",$P(^AUPNREP(X,2101,Y,0),U,6)=C S G=1
 Q G
 ;
MULTOSET ;EP - CALLED FROM TRIGGER
 ;if enter into the multiple then overlay 3, 3.05, 3.1 if date begun later than 3.05
 ;
 NEW APCDDA,APCDDA1
 S APCDDA=$G(DA)  ;MULTIPLE IEN
 S APCDDA1=$G(DA(1)) ;IEN
 Q:'APCDDA1
 Q:'APCDDA
 Q:'$D(^AUPNREP(APCDDA1,0))
 D EN^XBNEW("MUTOSET1^APCDRF","APCDDA1;APCDDA")
 Q
 ;
MUTOSET1 ;
 NEW APCDFPV,APCDFPBD,APCDFPDT,APCDTE,APCDT,APCDCOM,APCDINMU
 S APCDCOM="",APCDINMU=1
 ;GET LATEST OF THE DATE BEGUNS, IF NO DATE BEGUNS THEN USE THE LAST ONE IN, IF NONE, @ FIELDS
 NEW APCDCM,APCDX,APCDC,APCDDB,APCDM
 S APCDX=0 F  S APCDX=$O(^AUPNREP(APCDDA1,2101,APCDX)) Q:APCDX'=+APCDX  D
 .Q:$P($G(^AUPNREP(APCDDA1,2101,APCDX,1)),U,1)]""  ;DELETED
 .S APCDC=$P(^AUPNREP(APCDDA1,2101,APCDX,0),U,1)
 .Q:'APCDC
 .S APCDDB=$P(^AUPNREP(APCDDA1,2101,APCDX,0),U,2)
 .S APCDDE=$P(^AUPNREP(APCDDA1,2101,APCDX,0),U,3)
 .S APCDCM((9999999-APCDDB),-APCDX)=""
 .Q
 S APCDFPBD=$O(APCDCM(""))
 I 'APCDFPBD S DIE="^AUPNREP(",DA=APCDDA1,DR="3///@;3.05////@;3.1////"_DT D ^DIE K DIE,DA,DR Q
 S APCDX=$O(APCDCM(APCDFPBD,""))
 Q:APCDX=""
 S APCDX=$P(APCDX,"-",2)
 S APCDFPV=$P(^AUPNREP(APCDDA1,2101,APCDX,0),U,1)
 I APCDFPV="" Q  ;do nothing
 S APCDFPBD=$P(^AUPNREP(APCDDA1,2101,APCDX,0),U,2)  ;BEGUN
 S APCDFPDT=$P(^AUPNREP(APCDDA1,2101,APCDX,0),U,4)  ;UPDATED
 ;do we have this one on this begun date?  if so update .04 and quit
 S APCDTE=$P(^AUTTCM(APCDFPV,0),U,4)  ;get external OLD SET value
 I $$VAL^XBDIQ1(9000017,APCDDA1,3)=APCDTE D  Q  ;already have that method so edit date begun and date hx obtained
 .S DIE="^AUPNREP(",DA=APCDDA1,DR="3.05////"_APCDFPBD_";3.1////"_DT D ^DIE K DA,DR,DIE
 I APCDFPBD Q:$P(^AUPNREP(APCDDA1,0),U,7)'<APCDFPBD  ;already have one with a greater date begun
 S DIE="^AUPNREP(",DA=APCDDA1,DR="3///"_APCDTE_";3.05////"_APCDFPBD_";3.1////"_DT D ^DIE K DIE,DA,DR
 Q
EDCTONEW ;EP
 Q:$G(APCDEDDI)
 Q:$G(APCDDEFI)
 NEW APCDDA1
 S APCDDA1=$G(D0) ;D0
 Q:'APCDDA1
 Q:'$D(^AUPNREP(APCDDA1,0))
 D EN^XBNEW("EDCTONE1^APCDRF","APCDDA1")
 Q
EDCTONE1 ;EP
 NEW APCDIEDC
 S APCDIEDC=1
 S APCDEDD=$P(^AUPNREP(APCDDA1,0),U,9)
 S APCDHOW=$P(^AUPNREP(APCDDA1,0),U,10)
 I APCDHOW=""!(APCDHOW=0) D  Q
 .S DA=APCDDA1,DIE="^AUPNREP(",DR="1314///"_APCDEDD D ^DIE K DA,DIE,DR
 I APCDHOW=1 D  Q
 .S DA=APCDDA1,DIE="^AUPNREP(",DR="1305////"_APCDEDD_";1314///@" D ^DIE K DIE,DA,DR
 I APCDHOW=2 D  Q
 .S DA=APCDDA1,DIE="^AUPNREP(",DR="1302////"_APCDEDD_";1314///@" D ^DIE K DIE,DA,DR
 I APCDHOW=3 D  Q
 .S DA=APCDDA1,DIE="^AUPNREP(",DR="1308////"_APCDEDD_";1314///@" D ^DIE K DIE,DA,DR
 Q
EDDTOEDC(APCDF) ;EP - if enter EDD move to old EDC fields 4, 4.05, 4.1
 I $G(APCDIEDC) Q
 NEW APCDEDDI
 S APCDEDDI=1
 NEW APCDDA1
 S APCDDA1=$G(D0) ;D0
 Q:'APCDDA1
 Q:'$D(^AUPNREP(APCDDA1,0))
 D EN^XBNEW("EDDTOED1^APCDRF","APCDDA1;APCDF;APCDEDDI")
 Q
EDDTOED1 ;
 NEW APCDHOW
 S APCDHOW=$S(APCDF=1314:0,APCDF=1305:1,APCDF=1302:2,APCDF=1308:3,1:"")
 I APCDHOW="" Q
 S DA=APCDDA1,DIE="^AUPNREP(",DR="4////"_$$VALI^XBDIQ1(9000017,APCDDA1,APCDF)_";4.05////"_APCDHOW_";4.1////"_$$NOW^XLFDT D ^DIE K DIE,DA,DR
 Q
DEDD ;
 I X="L",$$VAL^XBDIQ1(9000017,DA,1302)="" D  Q
 .D EN^DDIOL("EDD (LMP) is blank therefore the Definitive EDD cannot be L - EDD (LMP).")
 .K X
 I X="U",$$VAL^XBDIQ1(9000017,DA,1305)="" D  Q
 .D EN^DDIOL("EDD (ULTRASOUND) is blank therefore the Definitive EDD cannot be U - EDD (ULTRASOUND).")
 .K X
 I X="C",$$VAL^XBDIQ1(9000017,DA,1308)="" D  Q
 .D EN^DDIOL("EDD (CLINICAL PARAMETERS) is blank therefore the Definitive EDD cannot be C - EDD (CLINICAL PARAMETERS).")
 .K X
 Q
DEFEDDF4 ;EP - move definitive EDD to EDC 4, 4.05, 4.1
 I $G(APCDIEDC) Q
 NEW APCDDA1
 S APCDDA1=$G(D0) ;D0
 Q:'APCDDA1
 Q:'$D(^AUPNREP(APCDDA1,0))
 D EN^XBNEW("DEFEDDF^APCDRF","APCDDA1;APCDF")
 Q
DEFEDDF ;
 NEW APCDHOW,APCDF,APCDDEFI
 S APCDDEFI=1
 S APCDF=$$VALI^XBDIQ1(9000017,APCDDA1,1311)
 S APCDF=$S(APCDF="L":1302,APCDF="U":1305,APCDF="C":1308,1:"")
 I APCDF="" S DA=APCDDA1,DIE="^AUPNREP(",DR="4///@;4.05///@;4.1///@" D ^DIE K DIE,DA,DR Q
 S APCDHOW=$S(APCDF=1314:0,APCDF=1305:1,APCDF=1302:2,APCDF=1308:3,1:"")
 I APCDHOW="" Q
 S DA=APCDDA1,DIE="^AUPNREP(",DR="4////"_$$VALI^XBDIQ1(9000017,APCDDA1,APCDF)_";4.05////"_APCDHOW_";4.1////"_$$NOW^XLFDT D ^DIE K DIE,DA,DR
 Q
