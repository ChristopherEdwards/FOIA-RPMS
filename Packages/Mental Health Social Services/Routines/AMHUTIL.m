AMHUTIL ; IHS/CMI/LAB - UTILITIES ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
GUIPL(P,R,Z) ;EP - called from GUI for patient lookup
 I '$G(P) Q 0
 I '$G(R) S R=$G(DUZ)
 I '$G(R) Q 0
 I '$G(Z) S Z=DUZ(2)
 I '$G(Z) Q 0
 ;first check to see if patient has a HRN at DUZ(2) and it is not inactive, if they don't then quit cause we're done,
 ;they should log in to the site they want the patient from
 I '$D(^AUPNPAT(P,41,Z,0)) Q 0
 I $P($G(^AUPNPAT(P,41,Z,0)),U,2)="" Q 0
 I $P(^AUPNPAT(P,41,Z,0),U,3) Q 0  ;inactive chart
 ;now do the UU junk
 Q $$ALLOWP(R,P)
 ;
DV4() ;EP
 ;get date version 4.0 installed
 NEW X,Y
 S X=$O(^DIC(9.4,"C","AMH",0))
 I X="" Q ""
 S Y=$O(^DIC(9.4,X,22,"B","4.0",0))
 I Y="" Q ""
 Q $P($G(^DIC(9.4,X,22,Y,0)),U,3)
 ;
SSN(P) ;EP
 I '$G(P) Q ""
 I '$D(^DPT(P,0)) Q ""
 Q $S($L($P(^DPT(P,0),U,9))=9:$J("XXX-XX-"_$E($P(^DPT(P,0),U,9),6,9),11),1:$J($P(^DPT(P,0),U,9),11))
 ;
ALLOWVI(P,V) ;EP - is user P allowed to see VISIT V
 ;P - DUZ, user internal entry number
 I '$G(P) Q 0
 I '$G(V) Q 0
 I '$D(^AMHBHUSR(P,0)) Q $$ALLOWSDE(P,V)     ;user is not in BH User file so allow
 ;                              access to all visits
 I '$O(^AMHBHUSR(P,11,0)) Q $$ALLOWSDE(P,V)  ;no locations so allow all
 NEW R
 S R=$P($G(^AMHREC(V,0)),U,4)  ;get location of encounter
 I 'R Q $$ALLOWSDE(P,V)                      ;if no location, don't allow
 I $D(^AMHBHUSR(P,11,R)) Q $$ALLOWSDE(P,V)   ;if location R is in the list of allowed
 ;                              locations then allow this visit to be seen by this user
 Q 0
ALLOWSDE(P,R) ;EP - is user allowed to see this visit based on "SDE" logic
 I '$G(P) Q ""
 I $D(^AMHSITE(DUZ(2),16,P)) Q 1  ;allow all with access
 NEW X,G,Z S G=0 S X=0 F  S X=$O(^AMHRPROV("AD",R,X)) Q:X'=+X  I $P(^AMHRPROV(X,0),U)=P S G=1
 I G Q 1
 I $P(^AMHREC(R,0),U,19)=P Q 1
 S G=0
 S X=0 F  S X=$O(^AMHREC(R,54,"B",X)) Q:X'=+X  D
 .S Z=$P($G(^TIU(8925,X,12)),U,2) I Z=P S G=1
 I G Q 1
 Q 0
 ;
ALLOWPCC(P,V) ;EP - is user P allowed to see VISIT V
 ;P - DUZ, user internal entry number
 I '$G(P) Q 0
 I '$G(V) Q 0
 I '$D(^AMHBHUSR(P,0)) Q $$PCCSDE(P,V)     ;user is not in BH User file so allow
 ;                              access to all visits
 I '$O(^AMHBHUSR(P,11,0)) Q $$PCCSDE(P,V)  ;no locations so allow all
 NEW R
 S R=$P($G(^AUPNVSIT(V,0)),U,6)  ;get location of encounter
 I 'R Q $$ALLOWSDE(P,V)                      ;if no location, don't allow
 I $D(^AMHBHUSR(P,11,R)) Q $$PCCSDE(P,V)   ;if location R is in the list of allowed
 ;                              locations then allow this visit to be seen by this user
 ;check patient on the visit?
 NEW S S S=$P(^AUPNVSIT(V,0),U,5)
 I S,'$$ALLOWP(P,S) Q 0
 Q $$PCCSDE(P,V)                           ;otherwise, don't allow them to see it
 ;
PCCSDE(P,R) ;EP - is user allowed to see this visit based on "SDE" logic
 I '$G(P) Q ""
 I $D(^AMHSITE(DUZ(2),16,P)) Q 1  ;allow all with access
 NEW X,G S G=0 S X=0 F  S X=$O(^AUPNVPRV("AD",R,X)) Q:X'=+X  I $P(^AUPNVPRV(X,0),U)=P S G=1
 I G Q 1
 I $P(^AUPNVSIT(R,0),U,23)=P Q 1
 Q 0
 ;
ALLOWV(P,R) ;EP - is user P allowed to see a visit from location R
 ;P - DUZ, user internal entry number R - ien of location from file 9999999.06
 I '$D(^AMHBHUSR(P,0)) Q 1     ;user is not in BH User file so allow
 ;                              access to all visits
 I '$O(^AMHBHUSR(P,11,0)) Q 1  ;no locations so allow all
 I 'R Q 0                      ;no valid location passed in so don't allow visit
 I $D(^AMHBHUSR(P,11,R)) Q 1   ;if location R is in the list of allowed
 ;                              locations then allow this visit to be seen
 Q 0
 ;
ALLOWP(P,R) ;EP - is user P allowed to see patient R?
 I '$D(^AMHBHUSR(P,0)) Q 1     ;user is not in BH User file so allow
 ;                              access to all patients
 I 'R Q 0                      ;no valid location passed in so don't allow 
 ;                              access to this patient
 I '$O(^AMHBHUSR(P,11,0)) Q 1  ;no locations  so allow all
 NEW G,X S G=0
 S X=0 F  S X=$O(^AMHBHUSR(P,11,X)) Q:X'=+X  I $D(^AUPNPAT(R,41,X)) S G=1  ;has a hrn
 I G Q 1                       ;if patient has HRN at facility any facility in the BH USer file
 ;                              then allow access to this patient
 Q 0
 ;
EHR(R) ;EP - called to determine if this is an EHR created visit
 I '$G(R) Q ""
 Q $P($G(^AMHREC(R,11)),U,10)
 ;
NALLOWP ;EP - called to write a notification to the user
 D EN^DDIOL("***** You do not have access to that patient's record, see your supervisor.","","!!")
 Q
 ;
DBHUSR ;EP - note to user
 Q:'$D(^AMHBHUSR(DUZ,0))
 Q:'$O(^AMHBHUSR(DUZ,11,0))
 NEW X
 S X=$G(IORVON)_"Please note:"_$G(IORVOFF)_"  Only visits to the following locations will"
 D EN^DDIOL(X,,"!!")
 D EN^DDIOL("be displayed:",,"!?14")
 S X=0 F  S X=$O(^AMHBHUSR(DUZ,11,X)) Q:X'=+X  D EN^DDIOL($P(^DIC(4,X,0),U),,"!?15")
 D EN^DDIOL("",,"!!")
 Q
DBHUSRP ;EP - note to user
 Q:'$D(^AMHBHUSR(DUZ,0))
 Q:'$O(^AMHBHUSR(DUZ,11,0))
 NEW X
 S X=$G(IORVON)_"Please note:"_$G(IORVOFF)_"  Only patients who have HRN's at the following "
 D EN^DDIOL(X,,"!")
 D EN^DDIOL("locations will be included in this report:",,"!?14")
 S X=0 F  S X=$O(^AMHBHUSR(DUZ,11,X)) Q:X'=+X  D EN^DDIOL($P(^DIC(4,X,0),U),,"!?15")
 D EN^DDIOL("",,"!")
 Q
ACTPROV(Y) ;EP called from data dictionary fields
 NEW D S D=""
 I '$D(^VA(200,"AK.PROVIDER",$P(^VA(200,Y,0),U),Y)) Q 0  ;not a provider - no provider key
 S D=$S($G(AMHDATE)]"":$P(AMHDATE,"."),1:"")
 I D="",$G(DA),$P($G(^AMHRPROV(DA,0)),U,3)]"" S D=$P($P(^AMHREC($P(^AMHRPROV(DA,0),U,3),0),U),".")
 I $P($G(^VA(200,Y,"PS")),U,4)]"",$P($G(^VA(200,Y,"PS")),U,4)<D Q 0
 Q 1
XTMP(N,D) ;EP -set xtmp( 0 node
 Q:$G(N)=""
 S ^XTMP(N,0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_$G(D)
 Q
PPINI(AMHUREC) ;EP Retrieve BH Primary Provider Initials
 NEW X,Y,AMHX,AMHY,DIQ,DR,DA,AMHG,AMHINI,AMHGR
 S AMHG="^AMHRPROV("
 S AMHX=0,AMHGR=AMHG_"""AD"",AMHUREC,AMHX)" F  S AMHX=$O(@AMHGR) Q:AMHX'=+AMHX  I $P(@(AMHG_AMHX_",0)"),U,4)="P" S AMHY=$P(^(0),U)
 I '$D(AMHY) S AMHINI="???" Q AMHINI
 S AMHINI=$$VAL^XBDIQ1(200,AMHY,1)
 S:AMHINI="" AMHINI="???"
 Q AMHINI
PPNAME(AMHUREC) ;EP
 NEW X,Y,AMHX,AMHY,DIQ,DR,DA,AMHG,AMHNAME,AMHGR
 S AMHG="^AMHRPROV("
 S AMHX=0,AMHGR=AMHG_"""AD"",AMHUREC,AMHX)" F  S AMHX=$O(@AMHGR) Q:AMHX'=+AMHX  I $P(@(AMHG_AMHX_",0)"),U,4)="P" S AMHY=$P(^(0),U)
 I '$D(AMHY) S AMHNAME="???" Q AMHNAME
 S AMHNAME=$P(^VA(200,AMHY,0),U)
 S:AMHNAME="" AMHNAME="???"
 Q AMHNAME
PPINT(R) ;EP primary provider internal # from 200
 NEW %,%1
 S %=0,%1="" F  S %=$O(^AMHRPROV("AD",R,%)) Q:%'=+%  I $P(^AMHRPROV(%,0),U,4)="P" S %1=$P(^AMHRPROV(%,0),U)
 Q %1
PPAFFL(AMHUREC,AMHFORM) ;EP - get pp affiliation internal or external
 NEW X,Y,AMHX,AMHY,DIQ,DR,DA,AMHG,AMHAFFL,AMHGR
 S AMHG="^AMHRPROV("
 S AMHX=0,AMHGR=AMHG_"""AD"",AMHUREC,AMHX)" F  S AMHX=$O(@AMHGR) Q:AMHX'=+AMHX  I $P(@(AMHG_AMHX_",0)"),U,4)="P" S AMHY=$P(^(0),U)
 I '$D(AMHY) S AMHAFFL="?" Q AMHAFFL
 S DA=AMHY,DIC=200,DR=9999999.01,DIQ="AMHAFFL" S:$G(AMHFORM)="I" DIQ(0)="I"
 D EN^DIQ1
 S AMHAFFL=$S($G(AMHFORM)="I":AMHAFFL(200,AMHY,9999999.01,"I"),1:AMHAFFL(200,AMHY,"9999999.01"))
 S:AMHAFFL="" AMHAFFL="?"
 Q AMHAFFL
PPCLS(AMHUREC,AMHFORM) ;EP GET primary provider discipline
 NEW X,Y,AMHX,AMHY,DIQ,DR,DA,AMHG,AMHCLS,AMHGR
 S AMHG="^AMHRPROV("
 S AMHX=0,AMHGR=AMHG_"""AD"",AMHUREC,AMHX)" F  S AMHX=$O(@AMHGR) Q:AMHX'=+AMHX  I $P(@(AMHG_AMHX_",0)"),U,4)="P" S AMHY=$P(^(0),U)
 I '$D(AMHY) S AMHCLS="??" Q AMHCLS
 S DA=AMHY,DIC=200,DR=53.5,DIQ="AMHCLS" S:$G(AMHFORM)="I" DIQ(0)="I"
 D EN^DIQ1
 S AMHCLS=$S($G(AMHFORM)="I":$G(AMHCLS(200,AMHY,53.5,"I")),1:$G(AMHCLS(200,AMHY,"53.5")))
 S:AMHCLS="" AMHCLS="??"
 Q AMHCLS
PPCLSC(AMHUREC) ;EP GET PRIMARY PROVIDER CLASS CODE
 NEW X,Y,AMHCODE,DIC,DR,DA,DIQ,AMHCLS
 S AMHCLS=$$PPCLS^AMHUTIL(AMHUREC,"I")
 I AMHCLS="??" S AMHCODE="??" Q AMHCODE
 S DIC=7,DR="9999999.01",DA=AMHCLS,DIQ="AMHCODE"
 D EN^DIQ1
 S AMHCODE=AMHCODE(7,AMHCLS,"9999999.01")
 S:AMHCODE="" AMHCODE="??"
 Q AMHCODE
 ;
IN ;EP - called from input transform on .32 field
 Q:X=""
 Q:$E(X)'="I"
 NEW P S P=$P(^AMHREC(DA,0),U,8)
 Q:'$D(^AMHREC("AIN",P,"IN"))
 I $O(^AMHREC("AIN",P,"IN",0))=DA Q
 D EN^DDIOL("This Patient Already has an Initial Intake Record.")
 K X
 Q
DIFF ;EP - called from screenman
 I $G(DA)="" Q
 I $$GET^DDSVAL(9002011.06,DA,.21)=$$GET^DDSVAL(9002011.06,DA,.22) D PUT^DDSVAL(9002011.06,DA,.23,""),UNED^DDSUTL("DIFFERENCE REASON",3,1,1) Q
 D UNED^DDSUTL("DIFFERENCE REASON",3,1,0)
 Q
SMK(A) ;EP - called from screen
 I '$D(^AUTTHF(A,0)) Q 0
 I $P(^AUTTHF(A,0),U,10)'="F" Q 0
 NEW B S B=$O(^AUTTHF("B","TOBACCO",0)) I 'B Q 0
 I $P(^AUTTHF(A,0),U,3)'=B Q 0
 Q 1
 ;
STAGE(R) ;EP called from screenman
 I '$G(R) Q ""
 NEW %,%1,%2,%3,V
 S (%,%1,%2,%3)=0
 F %=.12:.01:.18 S V=$$GET^DDSVAL(9002011.06,R,%) S:V %1=%1+V,%2=%2+1
 I '%2 Q 0
 Q $J((%1/%2),3,1)
ICDN(CIM) ;EP
 I $G(CIM)="" Q ""
 NEW X,Y,Z
 S Z=$P(^AMHPROB(CIM,0),U,5)
 I Z="" Q ""
 S X=+$$CODEN^ICDCODE(Z,80)
 I 'X!(X=-1) Q ""
 S Y=$E($P($$ICDDX^ICDCODE(X),U,4),1,25)
 Q Y
DATE(D) ;EP - return YYYYMMDD from internal fm format
 I $G(D)="" Q ""
 Q ($E(D,1,3)+1700)_$E(D,4,7)
UIDV(REC) ;EP - generate unique ID for visit
 I '$G(REC) Q REC
 NEW X
 S X=$$GET1^DIQ(9999999.06,$P(^AUTTSITE(1,0),U),.32)
 Q X_$$LZERO(REC,10)
 ;
LZERO(V,L) ;EP - left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
POSTDA ;EP - called from screeNMAN
 D REQ^DDSUTL(14,2,1,$S(X=1:1,X=2:1,X=4:1,1:0))
 D REQ^DDSUTL(15,2,1,$S(X=3:1,X=5:1,1:0))
 I X=1!(X=2)!(X=4) D PUT^DDSVAL(DIE,.DA,.17,"",,"I")
 I X=3!(X=5) D PUT^DDSVAL(DIE,.DA,.16,"",,"I")
 Q
CHART(V) ;EP - returns ASUFAC_HRN
 NEW L,%,C,S,P,Z
 S %=""
 I '$D(^AMHREC(V,0)) Q %
 S Z=^AMHREC(V,0)
 S P=$P(Z,U,8)
 I 'P Q %
 I $P(Z,U,4),$D(^AUPNPAT(P,41,$P(Z,U,4),0)) S L=$P(Z,U,4) S %=$$GETCHART(L) I %]"" Q %
 I $G(DUZ(2)) S L=DUZ(2) S %=$$GETCHART(L)
 I %="" S L=$O(^AUPNPAT(P,41,0)) I L S %=$$GETCHART(L)
 I %="" S %="      ??????"
 Q %
GETCHART(L) ;
 S S=$P(^AUTTLOC(L,0),U,10)
 I S="" Q S
 S C=$P($G(^AUPNPAT(P,41,L,0)),U,2)
 I C="" Q C
 S C=$E("000000",1,6-$L(C))_C
 S %=S_C
 Q %
 ;
PRIMPROV(V,F) ;EP - primary provider in many different formats
 I 'V Q ""
 I '$D(^AMHREC(V)) Q ""
 NEW %,Y,P,Z
 S P="",Y=0 F  S Y=$O(^AMHRPROV("AD",V,Y)) Q:Y'=+Y  I $P(^AMHRPROV(Y,0),U,4)="P" S P=$P(^AMHRPROV(Y,0),U),Z=Y
 I 'P Q P
 I '$D(^VA(200,P)) Q ""
 I $G(F)="" S F="N"
 S %="" D @F
 Q %
 ;
SECPROV(V,N,F) ;EP
 I 'V Q ""
 I '$D(^AUPNVSIT(V)) Q ""
 I '$G(N) Q ""
 NEW %,Y,P,Z
 S P="",(C,Y)=0 F  S Y=$O(^AMHRPROV("AD",V,Y)) Q:Y'=+Y  I $P(^AMHRPROV(Y,0),U,4)'="P" S C=C+1 I C=N S P=$P(^AMHRPROV(Y,0),U),Z=Y  ;IHS/TUCSON/LAB - patch 1
 I 'P Q P
 I '$D(^VA(200,P)) Q ""
 I $G(F)="" S F="N"
 S %="" D @F
 Q %
 ;
PROV ;EP
 NEW Z,C,%,S
 S (C,Y)=0 F  S Y=$O(^AMHRPROV("AD",V,Y)) Q:Y'=+Y   S C=C+1 S APCLV(C)="",P=$P(^AMHRPROV(Y,0),U) D
 .I F=99 D  Q
 ..F I=1:1 S S=$T(@I) Q:S=""  S %="" D @I S $P(APCLV(C),U,I)=%
 .I F[";" D  Q
 ..F J=1:1 S I=$P(F,";",J) Q:I=""  I I'=99 S %="" D @I S $P(APCLV(C),U,J)=%
 .S %="",I=F D @I S $P(APCLV(C),U)=%
 .Q
 Q
METHOD(SFIEN) ;EP - called from export
 I '$G(SFIEN) Q ""
 NEW X,Y,Z,C,D,A,B
 S C=0,D=0
 S X=0,Y="" F  S X=$O(^AMHPSUIC(SFIEN,11,X)) Q:X'=+X  D
 .S C=C+1
 .I C=1 S $P(Y,U)=$P(^AMHPSUIC(SFIEN,11,X,0),U)
 .I C=2 S $P(Y,U,2)=$P(^AMHPSUIC(SFIEN,11,X,0),U)
 .I $P(^AMHPSUIC(SFIEN,11,X,0),U)=8,$P(^AMHPSUIC(SFIEN,11,X,0),U,2)]"" S $P(Y,U,3)=$S($P(Y,U,3)]"":" ",1:""),$P(Y,U,3)=$P(Y,U,3)_$P(^AMHPSUIC(SFIEN,11,X,0),U,2)
 .I $P(^AMHPSUIC(SFIEN,11,X,0),U)=7 D
 ..S A=0 F  S A=$O(^AMHPSUIC(SFIEN,11,X,11,A)) Q:A'=+A  D
 ...S D=D+1 Q:D>2  S P=D+3 S Z=$P(^AMHPSUIC(SFIEN,11,X,11,A,0),U,1) I Z S Z=$P(^AMHTSDRG(Z,0),U),$P(Y,U,P)=Z
 .Q
 Q Y
SUB(SFIEN) ;EP
 I '$G(SFIEN) Q ""
 NEW X,Y,Z,C,D,J
 S C=0,D=2,E=0
 S $P(Y,U)=$P(^AMHPSUIC(SFIEN,0),U,26)
 S J=0,E=0 F  S J=$O(^AMHPSUIC(SFIEN,15,J)) Q:J'=+J  D
 .S E=E+1 Q:E>2  S Z=$P(^AMHPSUIC(SFIEN,15,J,0),U) I Z S Z=$P(^AMHTSSU(Z,0),U) S D=D+1 S $P(Y,U,D)=Z
 .Q
 Q Y
CONTRIB(SFIEN) ;EP
 I '$G(SFIEN) Q ""
 ;return cont^cont
 NEW X,Y,Z,C
 S C=0,X=0,Y="" F  S X=$O(^AMHPSUIC(SFIEN,13,X)) Q:X'=+X  D
 .S C=C+1,Z=$P(^AMHPSUIC(SFIEN,13,X,0),U) I Z S Z=$P(^AMHTSCF(Z,0),U) S $P(Y,U,C)=Z
 .Q
 Q Y
REFCHK ;EP - called from screenman to check placement disp and referred to
 NEW A,B
 S A=$$GET^DDSVAL(DIE,DA,.17)
 S B=$$GET^DDSVAL(DIE,DA,.18)
 I A]"",B="" D EN^DDIOL("If Placement Disposition is entered, Referred to is Required.") S DDSBR="1^1^2.2" Q
 I A="",B]"" D EN^DDIOL("If Referred to is entered, Placement Disposition is Required.") S DDSBR="19^2^1" Q
 Q
REFED ;EP - called from screenman to check placement disp and referred to
 NEW A,B
 S A=$$GET^DDSVAL(DIE,DA,.17)
 S B=$$GET^DDSVAL(DIE,DA,.18)
 I A]"",B="" D EN^DDIOL("If Placement Disposition is entered, Referred to is Required.") S DDSBR="1^1^2.2" Q
 I A="",B]"" D EN^DDIOL("If Referred to is entered, Placement Disposition is Required.") S DDSBR="29^2^1" Q
 Q
LISTAT ;EP - called from executable help from activity type
 NEW A,B,C
 S A=0 F  S A=$O(^AMHTACT("AC",A)) Q:A=""  D
 .S B=0 F  S B=$O(^AMHTACT("AC",A,B)) Q:B'=+B  D
 ..D EN^DDIOL($P(^AMHTACT(B,0),U,1)_"   "_$P(^AMHTACT(B,0),U,2),"","!")
 .Q
 Q
SETBAA ;EP
 I '$D(X) Q
 I $L($P(X,".",1))<3 S ^AMHPROB("BAA",X,DA)="" Q
 I $E(X)="0" S ^AMHPROB("BAA",X,DA)="" Q
 I $E(X)="V" S ^AMHPROB("BAA",X,DA)="" Q
 S ^AMHPROB("BAA",$$RBLK^AMHLEDV(X,7),DA)="" Q
 Q
KILLBAA ;EP
 I '$D(X) Q
 I $L($P(X,".",1))<3 K ^AMHPROB("BAA",X,DA) Q
 I $E(X)="0" K ^AMHPROB("BAA",X,DA) Q
 I $E(X)="V" K ^AMHPROB("BAA",X,DA) Q
 K ^AMHPROB("BAA",$$RBLK^AMHLEDV(X,7),DA) Q
 Q
 ;
I ;EP
 S %=P Q
T ;EP
 S %=$P($G(^VA(200,P,0)),U,2) Q
A ;EP
 S %=$P($G(^VA(200,P,9999999)),U) Q
B ;EP
 S %=$P($G(^VA(200,P,9999999)),U)
 Q:%=""
 S %=$$EXTSET^XBFUNC(200,9999999.01,%)
 Q
D ;EP
 D F
 Q:%=""
 S %=$P($G(^DIC(7,%,9999999)),U)
 Q
 ;
E ;EP
 S %=$$VAL^XBDIQ1(200,P,53.5)
 Q
F ;EP
 S %=$$VALI^XBDIQ1(200,P,53.5)
 Q
C ;EP
 S %=$P($G(^VA(200,P,9999999)),U,2) Q
N ;EP
 S %=$P($G(^VA(200,P,0)),U) Q
O ;EP
 NEW A D A Q:%=""  S A=%,%="" D D Q:%=""  S %=A_% Q
P ;EP
 NEW A D A Q:%=""  S A=% NEW D D D Q:%=""  S D=%,%="" D C Q:%=""  S %=A_D_% Q
1 ;
 S %=$$VD^APCLV($P(^AMHRPROV(Y,0),U,3),"I")
 Q
2 ;
 S %=$$VD^APCLV($P(^AMHRPROV(Y,0),U,3),"S")
 Q
3 ;
 S %=$P(^AMHRPROV(Y,0),U,2)
 Q
4 ;
 S %=$$PATIENT^APCLV($P(^AMHRPROV(Y,0),U,3),"E")
 Q
5 ;
 S %=$P(^AMHRPROV(Y,0),U)
 Q
6 D T Q
7 D A Q
8 D B Q
9 D C Q
10 D D Q
11 D E Q
12 D F Q
13 D N Q
14 D O Q
15 D P Q
16 S %=$P(^AMHRPROV(Y,0),U,4) Q
17 S %=$$VAL^XBDIQ1(9002011.02,Y,.04) Q
18 S %=$$VALI^XBDIQ1(9002011.02,Y,.05) Q
19 S %=$$VAL^XBDIQ1(9002011.02,Y,.05) Q
20 S %=$$VAL^XBDIQ1(9002011.02,Y,1201) Q
 ;
