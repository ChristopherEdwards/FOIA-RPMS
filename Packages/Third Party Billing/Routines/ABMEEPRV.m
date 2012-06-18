ABMEEPRV ;IHS/ASDST/DMJ - PROVIDER INFO   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p5 - 5/17/04 - Added code to get info for
 ;      referring provider if on page 3
 ; IHS/SD/SDR v2.5 p6 - 7/14/04 - IM14117 - Added code to get
 ;     tax code using CODE (DD was changed so code had to be updated)
 ; IHS/SD/SDR - v2.5 p9 - IM19291
 ;   Supervising provider UPIN
 ; IHS/SD/SDR - v2.5 p9 - IM18318
 ;    Correction for PTAX+16^ABMEEPRV
 ; IHS/SD/SDR - v2.5 p10 - IM20776
 ;    Fix for <SUBSCR>GETPRV+18^ABMEEPRV
 ; IHS/SD/SDR - v2.5 p10 - IM21451
 ;    Fix for Payer Assigned Provider Number for Medicare
 ;    Look for insurer match, not just looping through
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ;
LNM(X) ;EP - last name
 S X=$P($G(^VA(200,X,0)),U)
 S X=$P(X,",",1)
 Q X
FNM(X) ;EP - first name
 S X=$P($G(^VA(200,X,0)),U)
 S X=$P(X,",",2)
 S X=$P(X," ",1)
 Q X
MI(X) ;EP - middle initial
 S X=$P($G(^VA(200,X,0)),U)
 S X=$P(X,",",2)
 S X=$P(X," ",2)
 S X=$E(X,1)
 Q X
UPIN(X) ;EP - upin number
 S X=$P($G(^VA(200,X,9999999)),"^",8)
 S:X="" X="PHS000"
 Q X
SLN(X,Y) ;EP - state license number
 ;X=provider ien
 ;Y=state ien
 S X=$G(X)
 I X="" Q X
 I '$G(Y) S Y=$P(^AUTTLOC(DUZ(2),0),"^",23)
 I 'Y S Y=$P(^AUTTLOC(DUZ(2),0),"^",14)
 I 'Y S Y=999
 N I
 S I=$O(^VA(200,X,"PS1","B",Y,0))
 I 'I S I=$O(^VA(200,X,"PS1",0))
 I 'I S X="" Q X
 S Y=$P(^VA(200,X,"PS1",I,0),U)
 S X=$P(^VA(200,X,"PS1",I,0),"^",2)
 S X=$P(^DIC(5,Y,0),"^",2)_"-"_X
 Q X
MCR(X) ;EP  - medicare provider number
 ;x=provider ien
 I '$D(^VA(200,+X)) S X="" Q X
 N I
 S I=0 F  S I=$O(^VA(200,X,9999999.18,I)) Q:'I  D
 .Q:$P($G(^AUTNINS(I,2)),U)'="R"
 .Q:I'=ABMP("INS")
 .S ABMCR=$P(^VA(200,X,9999999.18,I,0),"^",2)
 I $G(ABMCR)="" D
 .S ABMCR=$P($G(^VA(200,X,9999999)),"^",6)
 S X=ABMCR K ABMCR
 Q X
MCD(X,Y) ;EP  - medicaid provider number
 ;x=provider ien
 ;Y=payer
 S X=+$G(X)
 S Y=$G(Y)
 I 'X S X="" Q X
 I '$D(^VA(200,X)) S X="" Q X
 S ABMCD=$P($G(^VA(200,X,9999999.18,+Y,0)),"^",2)
 I ABMCD="" D
 .S ABMCD=$P($G(^VA(200,X,9999999)),"^",7)
 S X=ABMCD K ABMCD
 Q X
PROVNUM(X) ; EP - Provider Number, sensitive to ABMP("INS") and ABMP("ITYPE")
 ;x=provider ien
 I 'X Q "PHS000"
 N RET S RET=""
 I ABMP("INS") D  Q:RET]"" RET
 .S RET=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),3,X,0)),"^",2)
 .Q:RET'=""
 .N D1 S D1=$O(^VA(200,X,9999999.18,"B",ABMP("INS"),0)) Q:'D1
 .S RET=$P(^VA(200,X,9999999.18,D1,0),U,2)
 I ABMP("ITYPE")="R" Q $$MCR(X)
 N ST S ST=$P($G(^AUTTLOC(+ABMP("LDFN"),0)),U,23)
 I ABMP("ITYPE")="D"!(ABMP("ITYPE")="K") Q $$MCD(X,ST)
 Q $$UPIN(X)
SSN(X) ; EP - Provider's SSN
 S X=$P($G(^VA(200,X,1)),"^",9)
 Q X
EIN(X) ; EP - Provider's EIN
 Q ""
SPEC(X) ;EP - provider specialty
 ;x=provider ien
 S ABMPS=$P($G(^VA(200,+X,"PS")),"^",5) ;
 S X=$G(^DIC(7,+ABMPS,0))
 S:$G(^DIC(7,+ABMPS,9999999))'="" X=X_"^"_^(9999999)
 K ABMPS
 Q X
NPI(X,Y,Z)         ;EP - national provider identifier
 ;x=ien file 200, y=location, z=insurer
 S X=$P($G(^ABMNINS(+Y,+Z,3,+X,0)),"^",2)
 Q X
ENVSPEC(X) ; EP - Envoy Provider Specialty Code
 ; Given X = pointer to ^VA(200,
 ; ABMP("INS") = pointer to ^AUTNINS / ^ABMNINS
 ; ABMP("XMIT") = pointer to ^ABMDTXST
 ;
 N D0
 S D0=$P($G(^VA(200,+X,"PS")),U,5) Q:'D0     ; the IHS code in ^DIC(7,X,
 Q:'$D(^ABMENVPS(D0,0))
 N CODE S CODE=$P(^ABMENVPS(D0,0),"^",2)     ; CODE we will return
 D ENVSPEC1                                  ; deal with restrictions
 Q CODE
ENVSPEC1 ; some codes are restricted to certain bill formats and
 ; whether or not we are deality with a Participating Payer
 ; Change "CODE" value if there is such a restriction
 N CODETYPE S CODETYPE=$$ENVSPECT
 N D1,STOP S D1=0
 F  S D1=$O(^ABMENVPS(D0,1,"B",CODETYPE,D1)) Q:'D1  D  Q:$G(STOP)
 .N X S X=^ABMENVPS(D0,1,D1,0)
 .; future: might have more restrictions to check, 
 .; that's why we put in the loop
 .S CODE=$P(X,U,2),STOP=1
 Q
ENVSPECT() ; Envoy Specialty Code Type
 Q "NB"  ; always go with the more restrictive list for now.
 N RCID S RCID=$$RCID^ABMERUTL(ABMP("INS")) ; receiver ID
 ; PP = whether this is an Envoy participating payer
 ; If RCID is all spaces or all 0s or all 9s, we say "no"
 N PP S PP='((RCID?." ")!(RCID?."0")!(RCID?."9"))
 I $$ENVOY15^ABMEF19 Q $S(PP:"NP",1:"NB")
 Q "NP"  ; just go with 1500 participating payer codes?
PTAX(X) ;EP - provider taxonomy
 ;X=provider ien
 I $G(ABMR("PRV",20))="RF",+$O(ABMP("PRV","F",""))=0 D  Q X
 .S X=$P($G(ABMP("PRV","F",ABMIEN)),U,2)
 I '+$G(X) S X="" Q X
 N Y
 S Y=$O(^VA(200,X,"USC1",0))
 S ABMPCLAS=$P($G(^VA(200,X,"USC1",+Y,0)),U)
 S ABMPTAX=$G(^ABMPTAX("AUSC",+ABMPCLAS))
 I ABMPTAX'="" Q ABMPTAX
 S Y=$P($G(^VA(200,X,"PS")),"^",5)
 S:Y Y=$P($G(^DIC(7,Y,9999999)),U)
 S ABMPTAX=$S($G(Y)'="":$G(^ABMPTAX("A7",Y)),1:0)
 Q ABMPTAX
GETPRV ;EP - build provider array
 ;only first provider found for each type
 N J
 S J=0
 F  S J=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,J)) Q:'J  D
 .S ABM0=^ABMDBILL(DUZ(2),ABMP("BDFN"),41,J,0)
 .S ABMPTYP=$P(ABM0,"^",2)
 .Q:$D(ABMP("PRV",ABMPTYP))
 .S ABMP("PRV",ABMPTYP,+ABM0)=""
 K ABM0,ABMPTYP
 I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),"^",8)'="" D
 .I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U,13)'="" D  ;Person Class
 ..S ABMPTAX=$G(^ABMPTAX("AUSC",$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U,13)))
 .I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U,14)'="" D  ;Provider Class
 ..S ABMPTAX=$P($G(^DIC(7,$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U,14),9999999)),U)
 ..S:ABMPTAX'="" ABMPTAX=$G(^ABMPTAX("A7",ABMPTAX))
 .I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U,15)'="" D  ;Provider Taxonomy
 ..S ABMPTAX=$P($G(^ABMPTAX($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U,15),0)),U)
 .S ABMP("PRV","F",$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U,8))=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),"^",11)_"^"_$G(ABMPTAX)
 .S:$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U,17)'="" $P(ABMP("PRV","F",$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U,8)),U,3)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U,17)
 I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,12)'="" D  ;supervising provider
 .S ABMP("PRV","S",$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),9),U,12))=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,24)
 .S:$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,25)'="" $P(ABMP("PRV","S",$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),9),U,12)),U,2)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,25)
 Q
