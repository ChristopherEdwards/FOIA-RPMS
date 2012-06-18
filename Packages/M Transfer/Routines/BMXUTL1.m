BMXUTL1 ; IHS/OIT/HMW - UTIL: PATIENT DEMOGRAPHICS ;
 ;;4.0;BMX;;JUN 28, 2010
 ;;Stolen from:* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  UTILITY: PATIENT DEMOGRAPHICS.
 ;
 ;
 ;----------
NAME(DFN,ORDER) ;EP
 ;---> Return text of Patient Name.
 ;---> Parameters:
 ;     1 - DFN   (req) Patient's IEN (DFN).
 ;     2 - ORDER (opt) ""/0=Last,First   2=First Only
 ;                        1=First Last   3=Last Only
 ;
 Q:'$G(DFN) "NO PATIENT"
 Q:'$D(^DPT(DFN,0)) "Unknown"
 N X S X=$P(^DPT(DFN,0),U)
 Q:'$G(ORDER) X
 S X=$$FL(X)
 Q:ORDER=1 X
 Q:ORDER=2 $P(X," ")
 Q:ORDER=3 $P(X," ",2)
 Q "UNKNOWN ORDER"
 ;
 ;
 ;----------
FL(X) ;EP
 ;---> Switch First and Last Names.
 Q $P($P(X,",",2)," ")_" "_$P(X,",")
 ;
 ;
 ;----------
DOB(DFN) ;EP
 ;---> Return Patient's Date of Birth in Fileman format.
 ;---> Parameters:
 ;     1 - DFN   (req) Patient's IEN (DFN).
 ;
 Q:'$G(DFN) "NO PATIENT"
 Q:'$P($G(^DPT(DFN,0)),U,3) "NOT ENTERED"
 Q $P(^DPT(DFN,0),U,3)
 ;
 ;
 ;----------
DOBF(DFN,BMXDT,BMXNOA) ;EP
 ;---> Date of Birth formatted "09-Sep-1994 (35 Months)"
 ;---> Parameters:
 ;     1 - DFN   (req) Patient's IEN (DFN).
 ;     2 - BMXDT  (opt) Date on which Age should be calculated.
 ;     3 - BMXNOA (opt) 1=No age (don't append age).
 ;
 N X,Y
 S X=$$DOB($G(DFN))
 Q:'X X
 S X=$$TXDT1^BMXUTL5(X)
 Q:$G(BMXNOA) X
 S Y=$$AGEF(DFN,$G(BMXDT))
 S:Y["DECEASED" Y="DECEASED"
 S X=X_" ("_Y_")"
 Q X
 ;
 ;
 ;----------
AGE(DFN,BMXZ,BMXDT) ;EP
 ;---> Return Patient's Age.
 ;---> Parameters:
 ;     1 - DFN  (req) IEN in PATIENT File.
 ;     2 - BMXZ  (opt) BMXZ=1,2,3  1=years, 2=months, 3=days.
 ;                               2 will be assumed if not passed.
 ;     3 - BMXDT (opt) Date on which Age should be calculated.
 ;
 N BMXDOB,X,X1,X2  S:$G(BMXZ)="" BMXZ=2
 Q:'$G(DFN) "NO PATIENT"
 S BMXDOB=$$DOB(DFN)
 Q:'BMXDOB "Unknown"
 I '$G(BMXDT)&($$DECEASED(DFN)) D  Q X
 .S X="DECEASED: "_$$TXDT1^BMXUTL5(+^DPT(DFN,.35))
 S:'$G(DT) DT=$$DT^XLFDT
 S:'$G(BMXDT) BMXDT=DT
 Q:BMXDT<BMXDOB "NOT BORN"
 ;
 ;---> Age in Years.
 N BMXAGEY,BMXAGEM,BMXD1,BMXD2,BMXM1,BMXM2,BMXY1,BMXY2
 S BMXM1=$E(BMXDOB,4,7),BMXM2=$E(BMXDT,4,7)
 S BMXY1=$E(BMXDOB,1,3),BMXY2=$E(BMXDT,1,3)
 S BMXAGEY=BMXY2-BMXY1 S:BMXM2<BMXM1 BMXAGEY=BMXAGEY-1
 S:BMXAGEY<1 BMXAGEY="<1"
 Q:BMXZ=1 BMXAGEY
 ;
 ;---> Age in Months.
 S BMXD1=$E(BMXM1,3,4),BMXM1=$E(BMXM1,1,2)
 S BMXD2=$E(BMXM2,3,4),BMXM2=$E(BMXM2,1,2)
 S BMXAGEM=12*BMXAGEY
 I BMXM2=BMXM1&(BMXD2<BMXD1) S BMXAGEM=BMXAGEM+12
 I BMXM2>BMXM1 S BMXAGEM=BMXAGEM+BMXM2-BMXM1
 I BMXM2<BMXM1 S BMXAGEM=BMXAGEM+BMXM2+(12-BMXM1)
 S:BMXD2<BMXD1 BMXAGEM=BMXAGEM-1
 Q:BMXZ=2 BMXAGEM
 ;
 ;---> Age in Days.
 S X1=BMXDT,X2=BMXDOB
 D ^%DTC
 Q X
 ;
 ;
 ;----------
AGEF(DFN,BMXDT) ;EP
 ;---> Age formatted "35 Months" or "23 Years"
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - BMXDT (opt) Date on which Age should be calculated.
 ;
 N Y
 S Y=$$AGE(DFN,2,$G(BMXDT))
 Q:Y["DECEASED" Y
 Q:Y["NOT BORN" Y
 ;
 ;---> If over 60 months, return years.
 Q:Y>60 $$AGE(DFN,1,$G(BMXDT))_" years"
 ;
 ;---> If under 1 month return days.
 I Y<1 S Y=$$AGE(DFN,3,$G(BMXDT)) Q Y_$S(Y=1:" day",1:" days")
 ;
 ;---> Return months
 Q Y_$S(Y=1:" month",1:" months")
 ;
 ;
 ;----------
DECEASED(DFN,BMXDT) ;EP
 ;---> Return 1 if patient is deceased, 0 if not deceased.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - BMXDT (opt) If BMXDT=1 return Date of Death (Fileman format).
 ;
 Q:'$G(DFN) 0
 N X S X=+$G(^DPT(DFN,.35))
 Q:'X 0
 Q:'$G(BMXDT) 1
 Q X
 ;
 ;
 ;----------
SEX(DFN,PRON) ;EP
 ;---> Return "F" is patient is female, "M" if male.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - PRON (opt) Pronoun: 1=he/she, 2=him/her,3=his,her
 ;
 Q:'$G(DFN) ""
 Q:'$D(^DPT(DFN,0)) ""
 N X S X=$P(^DPT(DFN,0),U,2)
 Q:'$G(PRON) X
 I PRON=1 Q $S(X="F":"she",1:"he")
 I PRON=2 Q $S(X="F":"her",1:"him")
 I PRON=3 Q $S(X="F":"her",1:"his")
 Q X
 ;
 ;
 ;----------
SEXW(DFN) ;EP
 ;---> Return Patient sex: "Female"/"Male".
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;
 Q:$$SEX(DFN)="M" "Male"
 Q:$$SEX(DFN)="F" "Female"
 Q "Unknown"
 ;
 ;
 ;----------
NAMAGE(DFN) ;EP
 ;---> Return Patient Name concatenated with age.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;
 Q:'$G(DFN) "NO PATIENT"
 Q $$NAME(DFN)_" ("_$$AGE(DFN)_"y/o)"
 ;
 ;
 ;----------
SSN(DFN) ;EP
 ;---> Return Social Security Number (SSN).
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 N X
 Q:'$G(DFN) "NO PATIENT"
 Q:'$D(^DPT(DFN,0)) "Unknown"
 S X=$P(^DPT(DFN,0),U,9)
 Q:X']"" "Unknown"
 Q X
 ;
 ;
 ;----------
HRCN(DFN,DUZ2,AGD) ;EP
 ;---> Return IHS Health Record Number.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - DUZ2 (opt) User's Site/Location IEN.  If no DUZ2
 ;                    provided, function will look for DUZ(2).
 ;     3 - AGD  (opt) If AGD=1 return HRCN with no dashes.
 ;
 ;
 S:'$G(DUZ2) DUZ2=$G(DUZ(2))
 Q:'$G(DFN)!('$G(DUZ2)) "Unknown1"
 Q:'$D(^AUPNPAT(DFN,41,DUZ2,0)) "Unknown2"
 Q:'+$P(^AUPNPAT(DFN,41,DUZ2,0),"^",2) "Unknown3"
 N Y S Y=$P(^AUPNPAT(DFN,41,DUZ2,0),"^",2)
 Q:$G(AGD) Y
 Q:'+Y Y
 I $L(Y)=7 D  Q Y
 .S Y=$TR("123-45-67",1234567,Y)
 S Y=$E("00000",0,6-$L(Y))_Y
 S Y=$TR("12-34-56",123456,Y)
 Q Y
 ;
 ;
 ;----------
PHONE(AGDFN,AGOFF) ;EP
 ;---> Return patient's home phone number.
 ;---> Parameters:
 ;     1 - AGDFN (req) Patient's IEN (DFN).
 ;     2 - AGOFF (opt) =1 will return Patient's Office Phone.
 ;
 Q:'$G(AGDFN) "Error: No DFN"
 Q $P($G(^DPT(AGDFN,.13)),U,$S($G(AGOFF):2,1:1))
 ;
 ;
 ;----------
STREET(DFN) ;EP
 ;---> Return patient's street address.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;
 Q:'$G(DFN) "No Patient"
 Q:'$D(^DPT(DFN,.11)) ""
 Q:$P(^DPT(DFN,.11),U)="" ""
 Q $P(^DPT(DFN,.11),U)
 ;
 ;
 ;----------
CITY(DFN) ;EP
 ;---> Return patient's city.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;
 Q:'$G(DFN) "No Patient"
 Q:'$D(^DPT(DFN,.11)) ""
 Q:$P(^DPT(DFN,.11),U,4)="" ""
 Q $P(^DPT(DFN,.11),U,4)
 ;
 ;
 ;----------
STATE(DFN,NOTEXT) ;EP
 ;---> Return patient's state.
 ;---> Parameters:
 ;     1 - DFN    (req) Patient's IEN (DFN).
 ;     2 - NOTEXT (opt) If NOTEXT=1 return only the State IEN.
 ;                      If NOTEXT=2 return IEN|Text.
 ;
 Q:'$G(DFN) ""
 N Y S Y=$P($G(^DPT(DFN,.11)),U,5)
 Q:$G(NOTEXT)=1 Y
 Q:$G(NOTEXT)=2 Y_"|"_$$GET^BMXG(1,Y)
 Q $$GET^BMXG(1,Y)
 ;
 ;
 ;----------
ZIP(DFN) ;EP
 ;---> Return patient's zipcode.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;
 Q:'$G(DFN) "No Patient"
 Q:'$D(^DPT(DFN,.11)) ""
 Q:$P(^DPT(DFN,.11),U,6)="" ""
 Q $P(^DPT(DFN,.11),U,6)
 ;
 ;
 ;----------
CTYSTZ(DFN) ;EP
 ;---> Return patient's city, state zip.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;
 Q:'$G(DFN) "No Patient"
 Q $$CITY(DFN)_", "_$$STATE(DFN)_"  "_$$ZIP(DFN)
 ;
 ;
CURCOM(DFN,NOTEXT) ;EP
 ;---> Return patient's Current Community IEN or Text.
 ;---> (Item 6 on page 1 of Registration).
 ;---> Parameters:
 ;     1 - DFN    (req) Patient's IEN (DFN).
 ;     2 - NOTEXT (opt) If NOTEXT=1 return only the Current Comm IEN.
 ;                      If NOTEXT=2 return IEN|Text.
 ;
 Q:'$G(DFN) "No Patient"
 Q:'$D(^AUPNPAT(DFN,11)) ""  ;"Unknown1"
 ;
 N X,Y,Z
 S X=^AUPNPAT(DFN,11)
 ;---> Set Y=Pointer (IEN in ^AUTTCOM, piece 17), Z=Text (piece 18).
 S Y=$P(X,U,17),Z=$P(X,U,18)
 ;---> If both Pointer and Text are null, return "Unknown2".
 Q:('Y&(Z="")) ""  ;"Unknown2"
 ;
 ;---> If Y is null or a bad pointer, set Y="".
 I Y<1!('$D(^AUTTCOM(+Y,0))) S Y=""
 ;
 ;---> If no valid pointer and if Text (pc 18) exists in the
 ;---> Community file, then set Y=IEN in ^AUTTCOM(.
 I Y<1,$D(^AUTTCOM("B",Z)) S Y=$O(^AUTTCOM("B",Z,0))
 ;
 Q:'$D(^AUTTCOM(+Y,0)) ""  ;"Unknown3"
 Q:$G(NOTEXT)=1 Y
 Q:$G(NOTEXT)=2 Y_"|"_$$GET^BMXG(2,Y)
 Q $$GET^BMXG(2,Y)
 ;
 ;
 ;----------
PERSON(X,ORDER) ;EP
 ;---> Return person's name from File #200.
 ;---> Parameters:
 ;     1 - X     (req) Person's IEN in New Person File #200.
 ;     2 - ORDER (opt) ""/0=Last,First   1=First Last
 ;
 Q:'X "Unknown"
 Q:'$D(^VA(200,X,0)) "Unknown"
 N Y S Y=$P(^VA(200,X,0),U)
 Q:'$G(ORDER) Y
 Q $$FL(Y)
