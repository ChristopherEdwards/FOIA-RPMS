AUPNREP ; IHS/CMI/LAB - REPRODUCTIVE FACTORS;  ; 20 Nov 2009  9:23 AM
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
RHX(X) ;PEP - called to return a string of reproductive history
 I '$G(X) Q ""
 I '$D(^AUPNREP(X)) Q ""
 NEW A,B,N,G
 S B=""
 S N=$G(^AUPNREP(X,11))
 I N="" Q ""
 S (A,G)=$P(N,U,3)
 S:A="" A=" " S B=B_"Total # of Pregnancies "_A
 S A=$P(N,U,7)
 I A=""
 S:A="" A=" " S B=B_"; Full Term "_A
 S B=B_" "
 S A=$P(N,U,9)
 S:A="" A=" " S B=B_"; Premature "_A
 S A=$P(N,U,31)
 S:A="" A=" " S B=B_"; Abortions, Induced "_A
 S A=$P(N,U,33)
 S:A="" A=" " S B=B_"; Abortions, Spontaneous "_A
 S A=$P(N,U,11)
 S:A="" A=" " S B=B_"; Ectopic Pregnancies "_A
 S A=$P(N,U,5)
 S:A="" A=" " S B=B_"; Multiple Births "_A
 S A=$P(N,U,13)
 S:A="" A=" " S B=B_"; Living Children "_A
 Q B
 ;
RHXSM(X) ;PEP - called from screenman screen to populate reproductive history
 I '$G(X) Q ""
 NEW A,B,N,G
 S B=""
 S (A,G)=$$GET^DDSVAL(DIE,.DA,1103)
 S:A="" A=" " S B=B_"G"_A
 S A=$$GET^DDSVAL(DIE,.DA,1105)
 I A="",G=0 S A=0
 S:A="" A=" " S B=B_"P"_A
 S B=B_" "
 S A=$$GET^DDSVAL(DIE,.DA,1107)
 I A="",G=0 S A=0
 S:A="" A=" " S B=B_"F"_A
 S A=$$GET^DDSVAL(DIE,.DA,1109)
 I A="",G=0 S A=0
 S:A="" A=" " S B=B_"P"_A
 S A=$$GET^DDSVAL(DIE,.DA,1111)
 I A="",G=0 S A=0
 S:A="" A=" " S B=B_"A"_A
 S A=$$GET^DDSVAL(DIE,.DA,1113)
 I A="",G=0 S A=0
 S:A="" A=" " S B=B_"LC"_A
 Q B
 ;
 ;;
CONVRH ;EP - called from post init
 NEW APCDX,APCDY,APCDZ
 D EN^DDIOL("Converting Reproductive History field to individual field values","","!!")
 S APCDX=0 F  S APCDX=$O(^AUPNREP(APCDX)) Q:APCDX'=+APCDX  D
 .S APCDY=$P(^AUPNREP(APCDX,0),U,2)
 .Q:APCDY=""
 .I $D(^AUPNREP(APCDX,11)) Q  ;already has new data fields
 .S APCDZ=$$PARSERHS(APCDY)
 .Q:APCDZ=""
 .D ^XBFMK
 .S DIE="^AUPNREP(",DA=APCDX,DR="1103///"_$P(APCDZ,U,1)_";1107///"_$P(APCDZ,U,2)_";1113///"_$P(APCDZ,U,3)_";1133///"_$P(APCDZ,U,4)_";1131///"_$P(APCDZ,U,5)_";1///@"
 .D ^DIE
 .I $D(Y) D EN^DDIOL("Entry "_APCDX_" failed")
 .D ^XBFMK
 .;D EN^DDIOL(".")
 .Q
 Q
 ;
PARSERHS(%) ;EP
 ;return G^P^LC^SA^TA
 NEW R
 S R=""
 S $P(R,U)=+$P(%,"G",2)
 I $P(%,"P",2)]"" S $P(R,U,2)=+$P(%,"P",2)
 I $P(%,"LC",2)]"" S $P(R,U,3)=+$P(%,"LC",2)
 I $P(%,"SA",2)]"" S $P(R,U,4)=+$P(%,"SA",2)
 I $P(%,"TA",2)]"" S $P(R,U,5)=+$P(%,"TA",2)
 Q R
