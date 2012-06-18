BIUTL6 ;IHS/CMI/MWR - UTIL: TEXT FOR POINTERS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UTILITY: TEXT FOR PROVIDER, HOSP LOC, INSTIT, OTHER LOC,
 ;;           TRANSLATIONS, REACTION, CONTRA, SITE HDR, CUR COM TXT.
 ;
 ;
 ;----------
USERPOP(BIDFN,BIEDATE) ;EP - Return 1 if Patient is in User Population as of BIEDATE.
 ;---> Code from Lori Butcher, CMI, Feb 2010.
 ;---> Return 1 if Patient is in User Population; otherwise return 0.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient DFN.
 ;     2 - BIEDATE (req) Date as of which Patient is an in User Population.
 ;                       User Population = 1 or more qualifying visits in last 3 years.
 ;
 I '$D(^AUPNPAT(BIDFN,0)) Q 0      ;invalid patient
 I '$D(^AUPNVSIT("AC",BIDFN)) Q 0  ;patient has no visits
 ;
 NEW A,B,E,G,X,BIBDATE
 S BIBDATE=$$FMADD^XLFDT(BIEDATE,-1096)  ;get beginning date for search, 3 yrs ago (1096 days)
 K ^TMP($J,"ALL VISITS")
 S A="^TMP($J,""ALL VISITS"","
 S B=BIDFN_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BIBDATE)_"-"_$$FMTE^XLFDT(BIEDATE)
 S E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"ALL VISITS",1)) Q 0
 S (X,UP)=0
 F  S X=$O(^TMP($J,"ALL VISITS",X)) Q:((X'=+X)!(UP))  S V=$P(^TMP($J,"ALL VISITS",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:'$D(^AUPNVPRV("AD",V))          ;MUST BE A COMPLETE VISIT
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)  ;must be ambulatory, hosp, day surgery or obervation
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)      ;can't be a VA type visit
 .Q:$P(^AUPNVSIT(V,0),U,6)=""
 .S UP=1                            ;has at least one visit so in user pop
 Q UP
 ;
 ;
 ;----------
ACTCLIN(BIDFN,BIEDATE) ;EP - Return 1 if Patient is Active Clinical User as of BIEDATE.
 ;---> Code from Lori Butcher, CMI, Feb 2010.
 ;---> Return 1 if Patient is Active Clinical; otherwise return 0.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient DFN.
 ;     2 - BIEDATE (req) Date as of which Patient is an Active Clinical User.
 ;                       Active Clinical = 2 or more qualifying visits in last 3 years.
 ;
 I '$D(^AUPNPAT(BIDFN,0)) Q 0      ;invalid patient
 I '$D(^AUPNVSIT("AC",BIDFN)) Q 0  ;patient has no visits
 ;
 NEW A,B,E,G,X,BIBDATE,AC,S,F,BIGPRAYR
 S BIBDATE=$$FMADD^XLFDT(BIEDATE,-1096)  ;get begin date for search, 3 yrs ago (1096 days)
 K ^TMP($J,"ALL VISITS")
 ;
 ;---> Get IEN of GPRA Control File entry.
 S BIGPRAYR=$$GPRAIEN
 I 'BIGPRAYR Q 0
 ;
 S A="^TMP($J,""ALL VISITS"","
 S B=BIDFN_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BIBDATE)_"-"_$$FMTE^XLFDT(BIEDATE)
 S E=$$START1^APCLDF(B,A)
 ;
 I '$D(^TMP($J,"ALL VISITS",1)) Q 0
 S (X,G,AC,S,F)=0
 F  S X=$O(^TMP($J,"ALL VISITS",X)) Q:((X'=+X)!(AC))  S V=$P(^TMP($J,"ALL VISITS",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:'$D(^AUPNVPRV("AD",V))          ;MUST BE A COMPLETE VISIT
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)  ;must be ambulatory, hosp, day surgery or obervation
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)      ;can't be a VA type visit
 .Q:$P(^AUPNVSIT(V,0),U,6)=""
 .S B=$$CLINIC^APCLV(V,"C")         ;get clinic for active clinical check
 .Q:B=""
 .I 'G,$D(^BGPCTRL(BIGPRAYR,11,"B",B)) S G=V          ;must be a primary clinic
 .I V'=G,$D(^BGPCTRL(BIGPRAYR,12,"B",B)) S S=1        ;has a secondary type of clinic
 .I G,S S AC=1                      ;if have both then they are active clinical
 .Q
 Q AC
 ;
 ;
 ;----------
GPRAIEN() ;EP
 ;---> Return GPRA Control File IEN
 ;
 ;---> Get the most recent GPRA Year Control file entry.
 N BIYR,BIGPIEN
 S BIYR=$O(^BGPCTRL("B",""),-1)
 Q:'BIYR 0
 S BIGPIEN=$O(^BGPCTRL("B",BIYR,0))
 Q:'BIGPIEN 0
 Q:('$G(^BGPCTRL(BIGPIEN,0))) 0
 Q BIGPIEN
 ;
 ;
 ;----------
PROV200(X) ;EP
 ;---> Given PROVIDER's IEN in File #3, return the IEN in File #200.
 ;---> Parameters:
 ;     1 - X  (req) =IEN in old PROVIDER File #6.
 ;
 Q:'$G(X) ""
 Q $G(^DIC(16,X,"A3"))
 ;
 ;
 ;----------
PROVIDER(X) ;EP
 ;---> Code to check whether to return File 6 or File 200 for
 ;---> Provider.  ** Not used so far. **
 ;
 Q:'X ""
 ;---> IF PCC WANTS A FILE 6 POINTER FOR PROVIDER, RESET X.
 I '$P(^AUTTSITE(1,0),U,22) D
 .I $P($G(^VA(200,X,0)),U,16) S X=$P(^(0),U,16) Q
 .S X=$P($G(^DIC(3,X,0)),U,16)
 Q X
 ;
 ;
 ;----------
REACTXT(X) ;EP
 ;---> Return text of Reaction to Immunization.
 ;---> Parameters:
 ;     1 - X  (req) =IEN in IMMUNIZATION File #9002084.8.
 ;
 Q:'$G(X) ""
 Q:'$D(^BIREC(X,0)) ""
 Q $P(^BIREC(X,0),U)
 ;
 ;
 ;----------
CONTXT(X) ;EP
 ;---> Return text of a Contraindication Reason.
 ;---> Parameters:
 ;     1 - X  (req) =IEN in BI TABLE CONTRA REASON File #9002084.81.
 ;
 Q:'$G(X) ""
 Q:'$D(^BICONT(X,0)) ""
 Q $P(^BICONT(X,0),U)
 ;
 ;
 ;----------
SKNAME(X) ;EP
 ;---> Return text of Skin Test name.
 ;---> Parameters:
 ;     1 - X  (req) =IEN in IMMUNIZATION File #9999999.14.
 ;
 Q:'$G(X) "NO SKIN TEST"
 Q:'$D(^AUTTSK(X,0)) "UNK POINTER"
 Q $P(^AUTTSK(X,0),U)
 ;
 ;
 ;----------
SKRESLT(X) ;EP
 ;---> Return text of Skin Test Result.
 ;---> Parameters:
 ;     1 - X  (req) = Code for Skin Test Result.
 ;
 Q:$G(X)="" ""
 Q:X="P" "Positive"
 Q:X="N" "Negative"
 Q:X="D" "Doubtful"
 Q:X="O" "No Take"
 Q "Unknown"
 ;
 ;
 ;----------
HOSPLC() ;EP
 ;---> RETURN TEXT OF HOSPITAL LOCATION NAME.
 ;---> REQUIRED VARIABLE: X=IEN IN HOSPITAL LOCATION FILE #44.
 Q:'$D(X) ""
 Q:'X "UNKNOWN"
 Q:'$D(^SC(X,0)) "UNKNOWN POINTER"
 Q $P(^SC(X,0),U)
 ;
 ;
 ;----------
INSTIT() ;EP
 ;---> RETURN IEN OF INSTITUTION (FACILITY) FILE 4, FOR THIS HOSPITAL
 ;---> LOCATION ENTRY IN HOSPITAL LOCATION FILE 44.
 ;---> ALSO CONCATENATE "`" TO THE FRONT OF IEN FOR USE IN DR STRINGS.
 Q:'$D(X) ""
 Q:X="" ""
 Q:'$D(^SC(X,0)) ""
 Q:$P(^SC(X,0),U,4)']"" ""
 Q "`"_$P(^SC(X,0),U,4)
 ;
 ;
 ;----------
INSTTX(FACILITY) ;EP
 ;---> Return text of Institution (Facility) Name.
 ;---> Parameters:
 ;     1 - FACILITY  (req) IEN in INSTITUTION File #4.
 ;
 Q:'$G(FACILITY) ""
 Q:'$D(^DIC(4,FACILITY,0)) "Unknown facility"
 Q $P(^DIC(4,FACILITY,0),U)
 ;
 ;
 ;----------
LOCABBR(FACILITY) ;EP
 ;---> Return text of Institution/Location Abbreviated Name.
 ;---> Parameters:
 ;     1 - FACILITY  (req) IEN in INSTITUTION File #4.
 ;
 Q:'$G(FACILITY) ""
 Q:'$D(^AUTTLOC(FACILITY,0)) "UNKN"
 Q $P(^AUTTLOC(FACILITY,0),U,7)
 ;
 ;
 ;----------
INSTTX1(BIVPTR,BIMX,BIIHS) ;EP
 ;---> Return text of Other Location if it exists (for this Visit);
 ;---> otherwise, return text of IHS Location.
 ;---> Parameters:
 ;     1 - BIVPTR  (req) IEN of Visit in VISIT File.
 ;     2 - BIMX    (opt) BIMX=1 to return text in mixed case.
 ;     3 - BIIHS   (opt) BIIHS=1 to force IHS LOCATION (ignore OTHER).
 ;                       BIIHS>1 to force OTHER LOCATION.
 ;                       BIIHS<1 Look first for OTHER LOCATION;
 ;                               if null, then return IHS LOCATION.
 ;
 Q:'$G(BIVPTR) "No Visit Pointer."
 Q:'$D(^AUPNVSIT(BIVPTR,0)) "Visit does not exist."
 ;
 N Y
 S:'$G(BIMX) BIMX=0
 S:'$G(BIIHS) BIIHS=0
 ;
 D
 .;---> If this Visit has an OTHER LOCATION and IHS LOCATION
 .;---> is not forced, return OUTSIDE LOCATION text.
 .I BIIHS<1 I $P($G(^AUPNVSIT(BIVPTR,21)),U)]"" D  Q
 ..S Y=$P(^AUPNVSIT(BIVPTR,21),U)
 .;
 .;---> If OTHER LOCATION is forced, return it (even if null).
 .I BIIHS>1 S Y=$P($G(^AUPNVSIT(BIVPTR,21)),U) Q
 .;
 .;---> If IHS Location is forced (or if neither IHS nor OTHER was
 .;---> forced, but OTHER is null), return the IHS LOCATION
 .;---> (.06 of VISIT File).
 .S Y=$P(^AUPNVSIT(BIVPTR,0),U,6)
 .I Y<1 S Y="Location not entered." Q
 .S Y=$E($$INSTTX(Y),1,20)
 ;
 Q:BIMX $$T^BITRS(Y)
 Q Y
 ;
 ;
 ;----------
OTHERLOC(BIDUZ2,Z) ;PEP - Return IEN of the "OTHER" Location.
 ;---> Return IEN of the "OTHER" Location, as selected in the
 ;---> BI SITE PARAMETER File.  (For use with Outside Locations
 ;---> in PCC Visit entries.)
 ;---> Parameters:
 ;     1 - BIDUZ2 (req) IEN of "OTHER" in LOCATION File.
 ;     2 - Z      (opt) If Z=1 return text of "OTHER" Location.
 ;
 N X S:'$G(Z) Z=0
 Q:'$G(BIDUZ2) $S(Z:"OTHER NOT DEFINED",1:"")
 Q:'$D(^BISITE(BIDUZ2,0)) $S(Z:"SITE PARAMETERS NOT SET.",1:"")
 S X=$P(^BISITE(BIDUZ2,0),U,3)
 Q:'X $S(Z:"OTHER not set in BI SITE PARAMETERS.",1:"")
 Q:'$D(^DIC(4,X,0)) $S(Z:"UNKNOWN FACILITY",1:"")
 Q:'Z X
 Q $$INSTTX(X)
 ;
 ;
 ;----------
DEFPROV(BIDUZ2) ;EP
 ;---> Return 1 if Site Parameter says User should be the Default
 ;---> Provider for a new Visit.
 ;---> Parameters:
 ;     1 - BIDUZ2 (req) User's DUZ(2)
 ;
 Q +$P($G(^BISITE(+$G(BIDUZ2),0)),U,16)
 ;
 ;
 ;----------
REPHDR(BISITE) ;EP
 ;---> Return text of Record/Report Header for this Site.
 ;---> This is the free text full name of the site as it should
 ;---> appear at the top of records and reports.
 ;---> Parameters:
 ;     1 - BISITE  (req) IEN in BI SITE PARAMETERS File,
 ;                         the user's DUZ(2) (INSTITUTION File #4).
 ;
 Q:'$G(BISITE) "No Facility IEN passed."
 Q:'$D(^BISITE(BISITE,0)) "Report Header not set."
 N X S X=$P(^BISITE(BISITE,0),U,6)
 S:X="" X=$$INSTTX(BISITE)
 Q X
 ;
 ;
 ;----------
CCTX(X) ;EP
 ;---> Return text of Current Community Name.
 ;---> Parameters:
 ;     1 - X  (req) IEN in COMMUNITY File #9999999.05.
 ;
 Q:'$G(X) ""
 Q:'$D(^AUTTCOM(X,0)) "BAD POINTER"
 Q $P(^AUTTCOM(X,0),U)
 ;
 ;
 ;----------
BENTX(X) ;EP
 ;---> Return text of Beneficiary Type.
 ;---> Parameters:
 ;     1 - X  (req) IEN in BENEFICIARY File #9999999.25.
 ;
 Q:'$G(X) ""
 Q:'$D(^AUTTBEN(X,0)) "BAD POINTER"
 Q $P(^AUTTBEN(X,0),U)
 ;
 ;
 ;----------
BIUPTX(X,Y) ;EP
 ;---> Return text of Patient Group.
 ;---> Parameters:
 ;     1 - X  (req) Code for Patient Group.
 ;     2 - Y  (opt) If Y=1 return the long form.
 ;
 Q:X="r" $S($G(Y):"Registered",1:"Registered Patients (All)")
 Q:X="i" $S($G(Y):"Imm Register",1:"Immunization Register Patients (Active)")
 Q:X="u" $S($G(Y):"User Population",1:"User Population (1 visit, 3 yrs)")
 Q:X="a" $S($G(Y):"Active Users",1:"Active Users (2+ visits, 3 yrs)")
 Q $S($G(Y):"Error",1:"Error (Unknown Patient Group)")
 ;
 ;
 ;----------
LOTTX(X,Y) ;EP
 ;---> Return text or vaccine of a Lot Number.
 ;---> Parameters:
 ;     1 - X  (req) =IEN in IMMUNIZATION LOT File #9999999.41.
 ;     2 - Y  (opt) If Y=1, return the Vaccine IEN associated with
 ;                  this Lot Number.  If Y=2, return text of Vaccine Name.
 ;                  If Y=3 return default NDC for this Lot Number.
 ;
 Q:'$G(X) ""
 Q:'$D(^AUTTIML(X,0)) ""
 ;---> Return Lot Number text.
 Q:'$G(Y) $P(^AUTTIML(X,0),U)
 I Y=1 Q $P(^AUTTIML(X,0),U,4)
 I Y=2 Q $$VNAME^BIUTL2(Z)
 I Y=3 Q $P(^AUTTIML(X,0),U,17)
 Q ""
 ;
 ;
 ;----------
DETX(X) ;EP
 ;---> Return text of a Data Element name.
 ;---> Parameters:
 ;     1 - X  (req) =IEN in BI TABLE DATA ELEMENT File 9002084.91.
 ;
 Q:'$G(X) ""
 Q:'$D(^BIEXPDD(X,0)) ""
 Q $P(^BIEXPDD(X,0),U)
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;You have selected a "Duplicate Lot Number."  This means that this
 ;;Lot Number exists at least one other time in the Lot Number file,
 ;;and the Immunization visit you are entering cannot be stored until
 ;;the duplicate has been resolved.
 ;;
 ;;Only a person with access to the Immunization Manager's Menu can
 ;;resolve duplicate Lot Numbers.  Since you do not have this access,
 ;;you should contact your Immunization Program Manager or your
 ;;Computer Site Manager for support with this problem.
 ;;
 ;;In the meantime, you can either finish entering the Immunization
 ;;visit without a Lot Number, and come back to add the Lot Number to
 ;;this visit later, after the duplicate has been resolved.
 ;;Or you can simply quit without adding this visit at this time.
 ;;
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;You have selected a "Duplicate Lot Number."  This means that this
 ;;Lot Number exists at least one other time in the Lot Number file,
 ;;and the Immunization visit you are entering cannot be stored until
 ;;the duplicate has been resolved.
 ;;
 ;;Two steps should be taken to resolve duplicate Lot Numbers:
 ;;
 ;;STEP 1
 ;;------
 ;;Duplicate Lot Numbers are resolved under the Manager Menu, "Lot
 ;;Number Add/Edit" (MGR-->LOT).  Go to this option and enter the Lot
 ;;Number in question.  Two or more choices will be presented.  Select
 ;;one of the choices to be the valid Lot Number.  Edit this Lot Number,
 ;;making sure it is Active and that all relevant vaccines are listed
 ;;under it.
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
TEXT3 ;EP
 ;;STEP 2
 ;;------
 ;;Select and edit each of the duplicate Lot Numbers.
 ;;
 ;;Edit the Lot Number itself by placing  "z" at the beginning
 ;;(e.g, 483-116 --> z483-116).  If there is a second duplicate, add
 ;;"zz" to the beginning of that Lot Number; for a third duplicate,
 ;;add "zzz", and so on.  The adding of leading "z"s to the duplicates
 ;;will make them distinguishable from the valid Lot Number.  This
 ;;method will also make the old duplicate Lot Numbers recognizable on
 ;;pre-existing visits.
 ;;
 ;;The duplicate Lot Numbers should also be made INACTIVE.
 ;;If an old Visit is to be edited and it has one of the old duplicate
 ;;Lot Numbers, the old duplicate should be replaced with the current
 ;;valid Lot Number (easily recognized by ignoring the leading "z"s).
 D PRINTX("TEXT3")
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
