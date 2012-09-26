VENPCCKG ; IHS/OIT/GIS - KNOWLEDGEBASE RPCS FOR GUI EDITOR ;
 ;;2.6;PCC+;**1,3**;APR 03, 2012;Build 24
 ;
 ;
 ;
 ;
PRVLKUP(OUT,IN) ; EP - RPC: VEN WCM LIST PROVIDERS
 S OUT="BMX ADO SS^VEN WCM LIST PROVIDERS^^~~~~~APRV~BMXADOV2"
 Q
 ;
PTED(OUT,IN) ; EP - RPC: VEN KB EDIT PT ED TOPICS
 ; INCLUDES BOTH AG AND NUTRITION TOPICS
 S OUT=$$CKKEY I $L(OUT) Q
 S OUT="BMX ADO SS^VEN KB PT ED ITEMS^^AC~CH~CHZ~9999~~"
 Q
 ;
DEV(OUT,IN) ; EP - RPC: VEN KB EDIT DEV ITEMS
 S OUT=$$CKKEY I $L(OUT) Q
 S OUT="BMX ADO SS^VEN KB PT ED ITEMS^^B~34~37~9999"
 Q
 ;
EXAM(OUT,IN) ; EP - RPC: VEN KB EDIT EXAM ITEMS
 S OUT=$$CKKEY I $L(OUT) Q
 S OUT="BMX ADO SS^VEN KB PT ED ITEMS^^B~27~30~9999"
 Q
 ;
AUT(OUT,IN) ; EP - RPC: VEN KB EDIT AUTISM SCREENING ITEMS
 S OUT=$$CKKEY I $L(OUT) Q
 S OUT="BMX ADO SS^VEN KB PT ED ITEMS^^B~9~9~9999"
 Q
 ;
CKKEY() ; EP - KEY CHECK
 I '$G(DUZ) Q ""
 I $D(^XUSEC("VENZKBEDIT",DUZ)) Q ""
 Q "You do not hold the required VENZKBEDIT key.  Request denied..."
 ;
TXPOP ; ---------------------------------------
 ;
WCPEP(OUT,IN) ; EP - RPC: VEN WCM PT ED TX POP
 ; WELL CHILD PATIENT ED - GIVEN A VISIT IEN, POPULATE THE TRANSACTION FILE
 ; OUT = TX TABLE GEN STRING
 N VIEN
 S VIEN=+$G(IN)
 I '$D(^AUPNVSIT(VIEN,0)) S OUT="" Q
 S IN=VIEN_"|1"
 D PEPOP^VENPCCKT(IN)
 Q
 ; 
WCNP(OUT,IN) ; EP - RPC: VEN WCM NUTRITION TX POP
 ; WELL CHILD PATIENT ED - GIVEN A VISIT IEN, POPULATE THE TRANSACTION FILE
 ; OUT = TX TABLE GEN STRING
 N VIEN
 S VIEN=+$G(IN)
 I '$D(^AUPNVSIT(VIEN,0)) S OUT="" Q
 S IN=VIEN_"|6"
 D PEPOP^VENPCCKT(IN)
 Q
 ;
WCEXP(OUT,IN) ; EP - RPC: VEN WCM EXAM TX POP
 ; WELL CHILD EXAMS - GIVEN A VISIT IEN, POPULATE THE TRANSACTION FILE
 ; OUT = TX TABLE GEN STRING
 N VIEN
 S VIEN=+$G(IN)
 I '$D(^AUPNVSIT(VIEN,0)) S OUT="" Q
 S IN=IN_"|3"
 D EXPOP^VENPCCKT(IN)
 Q
 ; 
WCDBP(OUT,IN) ; EP - RPC: VEN WCM DEV BENCHMARKS TX POP
 ; WELL CHILD DEVEL BENCHMARKS - GIVEN A VISIT IEN, POPULATE THE TRANSACTION FILE
 ; OUT = TX TABLE GEN STRING
 N VIEN
 S VIEN=+$G(IN)
 I '$D(^AUPNVSIT(VIEN,0)) S OUT="" Q
 S IN=VIEN_"|2"
 D POP^VENPCCKD(IN)
 Q
 ; 
WCDCP(OUT,IN) ; EP - RPC: VEN WCM DEV COMMENTS TX POP
 ; WELL CHILD DEVEL COMMENTS - GIVEN A VISIT IEN, POPULATE THE TRANSACTION FILE
 ; OUT = TX TABLE GEN STRING
 N VIEN
 S VIEN=+$G(IN)
 I '$D(^AUPNVSIT(VIEN,0)) S OUT="" Q
 S IN=VIEN_"|9"
 D POP^VENPCCKD(IN)
 Q
 ;
TXFLUSH ; --------------------------------------
 ; 
WCPEF(OUT,IN) ; EP - RPC: VEN WCM PT ED TX FLUSH
 ; FLUSH THE PT ED TOPICS FROM TX FILE TO V FILES
 ; IN = VISIT IEN|LOU|TIME|EDUCATOR IEN
 I '$L($G(IN)) S OUT="" Q
 S IN="1|"_IN
 D PEFLUSH^VENPCCKT(IN)
 Q
 ;
WCNF(OUT,IN) ; EP - RPC: VEN WCM NUTRITION TX FLUSH
 ; FLUSH THE NUTRITION TOPICS FROM TX FILE TO V FILES
 ; IN = VISIT IEN|LOU|TIME|EDUCATOR IEN|INFANT FEEDING CHOICE
 I '$L($G(IN)) S OUT="" Q
 S IN="6|"_IN
 D PEFLUSH^VENPCCKT(IN)
 Q
 ;
WCEXF(OUT,IN) ; EP - RPC: VEN WCM EXAM TX FLUSH
 ; FLUSH EXAM RESULTS FROM TX FILE TO V FILES
 S OUT=""
 I '$D(^AUPNVSIT(+$D(IN),0)) Q
 D EXFLUSH^VENPCCKT(IN)
 Q
 ;
WCDF(OUT,IN) ; EP - RPC: VEN WCM DEVEL TX FLUSH
 ; FLUSH DEVEL COMMENTS FROM TX FILE TO V FILES
 S OUT=""
 I '$D(^AUPNVSIT(+$D(IN),0)) Q
 D FLUSH^VENPCCKD(IN)
 Q
 ;
 ; ----------------------------------------
 ; 
PETODAY(OUT,IN) ; EP - RPC: VEN WCM PTED TODAY
 ; IN = DFN, OUT = VISIT IEN|PROVIDER NAME|PROVIDER IEN|LOU|TIME
 N DFN
 S DFN=+$G(IN)
 I '$D(^DPT(DFN,0)) S OUT="" Q
 D TODAY^VENPCCKT(DFN,"P")
 Q
 ;
NTODAY(OUT,IN) ; EP - RPC: VEN WCM NUTR TODAY
 ; IN = DFN, OUT = VISIT IEN|PROVIDER NAME|PROVIDER IEN|LOU|TIME|INFANT FEEDING CHOICE
 N DFN
 S DFN=+$G(IN)
 I '$D(^DPT(DFN,0)) S OUT="" Q
 D TODAY^VENPCCKT(DFN,"N")
 Q
 ;
GG(OUT,IN) ; EP - RPC: VEN WCM GG POP ; RETURN THE GROWTH GRID DATA STRING
 N ICIEN,GCIEN,CIEN,EIEN,MM,PCE,HIEN,HDR,TAG,VAL,X,DFN,Z,%
 S DFN=+$G(IN) I '$D(^DPT(DFN,0)) Q
 S OUT=""
 S ICIEN=$O(^VEN(7.62,"B","PEDS GROWTH CHART",0)) I 'ICIEN Q
 S GCIEN=$O(^VEN(7.62,"B","IMMUNIZATION REPORT",0)) I 'GCIEN Q
 F CIEN=ICIEN,GCIEN S EIEN=0 F  S EIEN=$O(^VEN(7.62,CIEN,3,"B",EIEN)) Q:'EIEN  D
 . S TAG=$G(^VEN(7.61,EIEN,1)) I '$L(TAG) Q
 . S X=$G(^VEN(7.61,EIEN,0)) I X="" Q
 . S HIEN=$P(X,U,2) I 'HIEN Q
 . S PCE=$P(X,U,3) I 'PCE Q
 . S HDR=$P($G(^VEN(7.42,HIEN,0)),U) I HDR="" Q
 . X ("S VAL=$$"_TAG_"(DFN)")
 . S X=$G(Z)
 . S $P(X,"\",PCE)=VAL
 . S Z=X
 . Q
 S OUT=$G(Z)
 S X="BI" F  S X=$O(@X) Q:$E(X,1,2)'="BI"  K @X ; CLEANUP BI VARIABLES
 Q
 ; 
TV(OUT,IN) ; EP - RPC: VEN GEN TEST WCM VISIT AND RETURN PATIENT DFN|VISIT IEN
 ; GIVEN A CHART NUMBER, GENERATE A TEST VISIT FOR TODAY
 ; IN = HRN OR HRN;1 ; IF HRN;1 THEN THE V PATIENT ED AND V WELL CHILD FILES WILL BE POPULATED AS WELL
 N AUPNPAT,VIEN,CSIEN,CLIEN,PRV,PRVIEN,CL,X,Y,Z,DIC,DIE,DA,DR,%,GBL,NIEN,PFLAG
 S OUT=""
 I $P($G(IN),";",2) S PFLAG=1,IN=+IN
 S AUPNPAT=$$CHART^VENPCCU(+$G(IN),+$G(DUZ(2))) I '$D(^DPT(+AUPNPAT,0)) Q
 S X=+$O(^AUPNVSIT("AA",AUPNPAT,0))
 I (9999999-X)=(DT_".08") D  I $L(OUT) G TVPOV ; VISIT ALREADY EXISTS
 . S VIEN=+$O(^AUPNVSIT("AA",AUPNPAT,X,0))
 . I $D(^AUPNVSIT(VIEN,0)) S OUT=AUPNPAT_"|"_VIEN
 . Q
 S CSIEN=$O(^DIC(40.7,"C","01",0)) I 'CSIEN Q  ; CLINIC STOP
 S VIEN=$$VISIT^VENPCC3(AUPNPAT,(DT_".08"),DUZ(2),CSIEN) I 'VIEN Q
 S OUT=AUPNPAT_"|"_VIEN ; AT THIS POINT A VALID VISIT STUB HAS BEEN CREATED
 ; ADD A V POV AND V PRV ENTRY TO MAKE IT "OFFICIAL"
TVPOV S DIC="^AUTNPOV(",DIC(0)="L",DLAYGO=9999999.27,X="WELL CHILD EXAM"
 D ^DIC I Y=-1 G TVPRV
 S NIEN=+Y ; GET IEN FOR 'WELL CHILD EXAM' PROVIDER NARRATIVE
 S X=$$ICD^VENPCCU("V20.2") I 'X G TVX ; GET THE ICD9
 S DIC="^AUPNVPOV(",DIC(0)="L",X="""`"_X_"""",DLAYGO=9000010.07
 D ^DIC I Y=-1 G TVPRV
 S DA=+Y,DIE=DIC,DR=".02////^S X=AUPNPAT;.03////^S X=VIEN;.04////^S X=NIEN;.12////P"
 L +^AUPNVPOV(DA):1 I  D ^DIE L -^AUPNVPOV(DA)
TVPRV S GBL="^VA(200)"
 I $P($G(^DD(9000010.06,.01,0)),U,2)[6 S GBL=U_$C(68)_"IC(16)"
 S PRV=$O(@GBL@("B","SHORR,GR"))
 I '$L(PRV) G TVX
 S PRVIEN=$O(@GBL@("B",PRV,0))
 I 'PRVIEN G TVX
 S DIC="^AUPNVPRV(",DIC(0)="L",X="""`"_PRVIEN_"""",DLAYGO=9000010.06
 D ^DIC I Y=-1 G TVX
 S DA=+Y,DIE=DIC,DR=".02////^S X=AUPNPAT;.03////^S X=VIEN;.04////P"
 L +^AUPNVPOV(DA):1 I  D ^DIE L -^AUPNVPOV(DA)
 I '$G(PFLAG) G TVX ; PT ED ENTRIIES NOT REQUIRED
TVPED S PRVIEN=$O(^VA(200,"B",PRV,0)) I 'PRVIEN Q
 S NTIEN=$O(^AUTTEDT("B","CHT-NUTRITION",999999),-1) I 'NTIEN G TVX
 S ETIEN=$O(^AUTTEDT("B","CHT-PARENTING",999999),-1) I 'ETIEN G TVX
 S DIC="^AUPNVPED(",DIC(0)="L",X="""`"_NTIEN_""""
 D ^DIC I Y=-1 Q
 S DA=+Y,DIE=DIC,DR=".02////^S X=AUPNPAT;.03////^S X=VIEN;.05////^S X=PRVIEN;.06////^S X=2;.08////^S X=22"
 L +^AUPNVPOV(DA):1 I  D ^DIE L -^AUPNVPOV(DA)
 S ^AUPNVPED(DA,1,0)="^9000010.161^2^2"
 S ^AUPNVPED(DA,1,1,0)="Offer variety of health foods"
 S ^AUPNVPED(DA,1,"B","Offer variety of health foods",1)=""
 S ^AUPNVPED(DA,1,2,0)="Do not force eating"
 S ^AUPNVPED(DA,1,"B","Do not force eating",2)=""
 S DIC="^AUPNVPED(",DIC(0)="L",X="""`"_ETIEN_""""
 D ^DIC I Y=-1 Q
 S DA=+Y,DIE=DIC,DR=".02////^S X=AUPNPAT;.03////^S X=VIEN;.05////^S X=PRVIEN;.06////^S X=3;.08////^S X=33"
 L +^AUPNVPED(DA):1 I  D ^DIE L -^AUPNVPED(DA)
 S ^AUPNVPED(DA,1,0)="^9000010.161^2^2"
 S ^AUPNVPED(DA,1,1,0)="Read books together 30 minutes a day"
 S ^AUPNVPED(DA,1,"B","Read books together 30 minutes",1)=""
 S ^AUPNVPED(DA,1,2,0)="Do not expect child to share all toys"
 S ^AUPNVPED(DA,1,"B","Do not expect child to share a",2)=""
TVWC S DIC="^AUPNVWC(",DIC(0)="L",X=""""_0_""""
 D ^DIC I Y=-1 Q
 S DA=+Y,DIE=DIC,DR=".02////^S X=AUPNPAT;.03////^S X=VIEN;.04////^S X=PRVIEN;.06////^S X=3;.05////^S X=33"
 S DR=DR_";.09////^S X=PRVIEN;.08////^S X=2;.07////^S X=22"
 L +^AUPNVWC(DA):1 I  D ^DIE L -^AUPNVWC(DA)
 S ^AUPNVWC(DA,1,0)="^9000010.461^2^2"
 S ^AUPNVWC(DA,1,1,0)="Read books together 30 minutes a day"
 S ^AUPNVWC(DA,1,"B","Read books together 30 minutes",1)=""
 S ^AUPNVWC(DA,1,2,0)="Do not expect child to share all toys"
 S ^AUPNVWC(DA,1,"B","Do not expect child to share a",2)=""
 S ^AUPNVWC(DA,1,0)="^9000010.465^2^2"
 S ^AUPNVWC(DA,5,1,0)="Offer variety of health foods"
 S ^AUPNVWC(DA,1,"B","Offer variety of health foods",1)=""
 S ^AUPNVWC(DA,5,2,0)="Do not force eating"
 S ^AUPNVWC(DA,1,"B","Do not force eating",2)=""
TVX D ^XBFMK
 Q
 ; 
