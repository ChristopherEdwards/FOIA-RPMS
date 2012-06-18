BIUTL2 ;IHS/CMI/MWR - UTIL: ZIS, PATH, ERRCODE; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UTILITY: ZIS, ERROR CODE, VACCINE NAME & GROUP,
 ;;           MAX SERIES#, LOT DFLT, CASE MGR DFLT, VIS DATE DFLT.
 ;;  PATCH 1: Do not provide default Lot Number if Lot Number is restricted
 ;;           to a site and user's DUZ(2) does not match the site.  LOTDEF+19
 ;
 ;
 ;----------
ERRCD(BIIEN,BITEXT,BIDISPL,BIABBRV) ;EP
 ;---> Display Error Code from BI TABLE ERROR CODE File.
 ;---> Parameters:
 ;     1 - BIIEN   (req) IEN of Error Code in ^BIERR(.
 ;     2 - BITEXT  (ret) Text of Error Code.
 ;     3 - BIDISPL (opt) BIDISPL=1 if Error Code Text SHOULD BE displayed here.
 ;     4 - BIABBRV (opt) BIABBRV=1 return Abbreviated Error Text (<20 chars).
 ;
 ;---> Set BITEXT=Text of Error Code.
 D
 .I '$G(BIIEN) D  Q
 ..I $G(BIABBRV) S BITEXT="No Error Code" Q
 ..S BITEXT="Error Code not provided by software."
 .;
 .I '$D(^BIERR(BIIEN,0)) D  Q
 ..I $G(BIABBRV) S BITEXT="No Error Code" Q
 ..S BITEXT="Error Code does not exist in BI TABLE ERROR CODE File."
 .;
 .I $G(BIABBRV) S BITEXT=$P(^BIERR(BIIEN,0),"^",3) Q
 .S BITEXT=$P(^BIERR(BIIEN,0),"^",2)_" #"_BIIEN
 ;
 ;---> Display Error Code Text.
 D:$G(BIDISPL)
 .N BICRT S BICRT=$S(($E($G(IOST))="C")!($G(IOST)["BROWSER"):1,1:0)
 .W !!?3,BITEXT
 .W:'BICRT @IOF D:BICRT DIRZ^BIUTL3()
 ;
 ;---> Not used for now.
 ;D EN^DDIOL("* "_BITEXT,"","!!?3"),DIRZ^BIUTL3()
 Q
 ;
 ;
 ;----------
VNAME(IEN,LONG) ;EP
 ;---> Return the Short, Long, or Full Name for a Vaccine.
 ;---> Parameters:
 ;     1 - IEN  (req) IEN of Vaccine.
 ;     2 - LONG (opt) 0/null=Short Name; 1=Long Name; 2=Full Name;
 ;                    3="ShortName  (LongName)."
 ;
 Q:'$G(IEN) "NO IEN"
 Q:'$D(^AUTTIMM(IEN,0)) "UNKNOWN"
 Q:$G(LONG)=1 $P(^AUTTIMM(IEN,0),"^")
 Q:$G(LONG)=2 $P($G(^AUTTIMM(IEN,1)),"^",14)
 Q:$G(LONG)=3 " "_$P(^AUTTIMM(IEN,0),"^",2)_"  ("_$P(^AUTTIMM(IEN,0),"^")_") "
 Q $P(^AUTTIMM(IEN,0),"^",2)
 ;
 ;
 ;----------
MNAME(IEN,MVX) ;EP
 ;---> Return Manufacturer Name or MVX Code.
 ;---> Parameters:
 ;     1 - IEN (req) IEN of Manufacturer.
 ;     2 - MVX (opt) If MVX=1, return MVX Code
 ;
 Q:'$G(IEN) "NO IEN"
 Q:'$D(^AUTTIMAN(IEN,0)) $S($G(MVX):"UNK",1:"UNKNOWN")
 Q:$G(MVX)=1 $P(^AUTTIMAN(IEN,0),"^",2)
 Q $P(^AUTTIMAN(IEN,0),"^")
 ;
 ;
 ;----------
CODE(IEN,TYPE) ;EP
 ;---> Return the HL7-CVX, CPT, ICD Diagnosis, or ICD Procedure Code
 ;---> for a Vaccine.
 ;---> Parameters:
 ;     1 - IEN  (req) IEN of Vaccine.
 ;     2 - TYPE (opt) TYPE of Code to return:
 ;                        1=HL7-CVX (also default)
 ;                        2=CPT
 ;                        3=ICD Diagnosis
 ;                        4=ICD Procedure
 ;                        5=Volume Default
 ;                        6=HL7-CVX w/leading zero
 ;
 Q:'$G(IEN) "NO IEN"
 Q:'$D(^AUTTIMM(IEN,0)) "UNKNOWN"
 ;
 Q:$G(TYPE)=2 $P(^AUTTIMM(IEN,0),"^",11)
 Q:$G(TYPE)=3 $P(^AUTTIMM(IEN,0),"^",14)
 Q:$G(TYPE)=4 $P(^AUTTIMM(IEN,0),"^",15)
 Q:$G(TYPE)=5 $P(^AUTTIMM(IEN,0),"^",18)
 N X S X=$P(^AUTTIMM(IEN,0),"^",3)
 I $G(TYPE)=6,$L(X)=1 S X=0_X
 Q X
 ;
 ;
 ;----------
IMMVG(BIIEN,Z) ;EP
 ;---> For a particular Vaccine, return its Vaccine Group Information.
 ;---> (Note: Vaccine Group is also called "Series Ty
 ;---> .
 ;---> Parameters:
 ;     1 - BIIEN  (req) IEN in of Vaccine in IMMUNIZATION File #9999999.14.
 ;     2 - Z      (opt) If Z=1, return Vaccine Group FULL NAME.
 ;                      If Z=2, return Vaccine Group IEN (default if no Z).
 ;                      If Z=3, return Vaccine Group Forecast indicator:
 ;                              1=ON, 0=OFF
 ;                      If Z=4, return Display Order for reports.
 ;                      If Z=5, return SHORT NAME of Vaccine Group.
 ;
 ;---> Default: Return IEN of Vaccine Group.
 S:'$G(Z) Z=2
 N BIVG,BIVG0
 ;
 ;---> If any values or pointers are null, set Vaccine Group IEN=12: "Other".
 D
 .I '$G(BIIEN) S BIVG=12 Q
 .I '$D(^AUTTIMM(BIIEN,0)) S BIVG=12 Q
 .S BIVG=$P(^AUTTIMM(BIIEN,0),U,9)
 .S:'BIVG BIVG=12
 ;
 I Z=2 Q BIVG
 Q $$VGROUP(BIVG,Z)
 ;
 ;
 ;----------
VGROUP(BIVG,Z) ;EP
 ;---> Return Vaccine Group or ("Series Type") or Information
 ;---> for a particular Vaccine Group.
 ;---> Parameters:
 ;     1 - BIVG  (req) IEN in BI TABLE VACCINE GROUP File #9002084.93.
 ;     2 - Z     (opt) If Z=1, return Vaccine Group FULL NAME (default if no Z).
 ;                     If Z=3, return Vaccine Group Forecast indicator:
 ;                             1=ON, 0=OFF
 ;                     If Z=4, return Display Order for reports.
 ;                     If Z=5, return SHORT NAME of Vaccine Group.
 ;                     If Z=6, return max doses in Quarterly/Two-Yr-Old Reports.
 ;                     If Z=7, return max doses in Adolescent Report.
 ;                     If Z=8, return Vaccine Group Two-Yr-Old Report indicator:
 ;                             1=Yes,include; 0=No, exclude.
 ;
 ;---> If null, set Vaccine Group IEN=12: "Other".
 S:'$G(BIVG) BIVG=12
 S BIVG0=$G(^BISERT(BIVG,0))
 S:BIVG0="" BIVG=12,BIVG0=$G(^BISERT(BIVG,0))
 ;
 S:('$G(Z)) Z=1
 I Z=3 Q +$P(BIVG0,U,5)
 I Z=4 Q +$P(BIVG0,U,2)
 I Z=5 Q $P(BIVG0,U,3)
 I Z=6 Q $P(BIVG0,U,4)
 I Z=7 Q $P(BIVG0,U,7)
 I Z=8 Q $P(BIVG0,U,8)
 Q $P(BIVG0,U)
 ;
 ;
 ;----------
HL7TX(BICVX,BIGRP) ;EP
 ;---> Return the IEN of a Vaccine, given its HL7 Code.
 ;---> If lookup fails, return 137 for "OTHER".
 ;---> Parameters:
 ;     1 - BICVX  (req) CVX Code for this vaccine.
 ;     2 - BIGRP  (opt) If BIGRP=1, return Vaccine Group IEN for this CVX.
 ;
 ;
 I '$G(BICVX) S BICVX=999
 I '$D(^AUTTIMM("C",BICVX)) S BICVX=999
 N BIVIEN S BIVIEN=$O(^AUTTIMM("C",BICVX,0))
 S:'BIVIEN BIVIEN=137
 ;---> Return Vaccine IEN for this CVX.
 Q:'$G(BIGRP) BIVIEN
 ;---> Return Vaccine Group for this CVX.
 Q $P(^AUTTIMM(BIVIEN,0),"^",9)
 ;
 ;
 ;----------
VMAX(IEN) ;EP  ;MWRZZZ REMOVE?
 ;---> Return the Maximum Dose# for a Vaccine.
 ;---> Parameters:
 ;     1 - IEN  (req) IEN of Vaccine.
 ;
 Q:'$G(IEN) ""
 Q:'$D(^AUTTIMM(IEN,0)) ""
 Q $P(^AUTTIMM(IEN,0),"^",5)
 ;
 ;
 ;----------
VCOMPS(IEN) ;EP v8.0
 ;---> Return string of components for a Vaccine.
 ;---> Parameters:
 ;     1 - IEN  (req) IEN of Vaccine.
 ;
 Q:'$G(IEN) ""
 Q:'$D(^AUTTIMM(IEN,0)) ""
 N X S X=$P(^AUTTIMM(IEN,0),"^",21,26)
 S X=$TR(X,"^",";")
 Q X
 ;
 ;
 ;----------
LOTDEF(IEN) ;EP
 ;---> Return the IEN of the Default Lot# for a Vaccine.
 ;---> Parameters:
 ;     1 - IEN  (req) IEN of Vaccine in IMMUNIZATION File (9999999.14).
 ;
 Q:'$G(IEN) ""
 Q:'$D(^AUTTIMM(IEN,0)) ""
 N X,Y S X=$P(^AUTTIMM(IEN,0),"^",4)
 ;
 ;---> Quit if no Default Lot# stored.
 Q:'X ""
 ;---> Quit if pointed to Lot# does not exist.
 S Y=$G(^AUTTIML(X,0))
 Q:Y="" ""
 ;---> Quit if this Lot# does NOT point back to this Vaccine.
 Q:$P(Y,U,4)'=IEN ""
 ;---> Quit if this Lot# is INACTIVE.
 Q:$P(Y,U,3) ""
 ;
 ;********** PATCH 1, v8.2.1, FEB 01,2008, IHS/CMI/MWR
 ;---> Quit if this Lot# has a Facility and User's DUZ(2) does not match.
 Q:(($P(Y,U,14))&($P(Y,U,14)'=$G(DUZ(2)))) ""
 ;**********
 ;
 ;---> Return Default Lot# IEN.
 Q X
 ;
 ;
 ;----------
LOTREQ(BIDUZ2) ;EP
 ;---> Return 1 if Lot#'s are required, 0 if not.
 ;---> Parameters:
 ;     1 - BIDUZ2 (req) User's DUZ(2)
 ;
 Q $P($G(^BISITE(+$G(BIDUZ2),0)),U,9)
 ;
 ;
 ;----------
LOTLOW(BILIEN,BIDUZ2) ;EP
 ;---> Return the number of (remaining) doses of a Lot Number
 ;---> that will trigger a Low Supply Alert.
 ;---> If not set for this site, 50 will be returned.
 ;---> Parameters:
 ;     1 - BILIEN  (req) IEN of Lot Number in ^AUTTIML.
 ;     2 - BIDUZ2 (req) User's DUZ(2)
 ;                                         vvv83
 N X
 D
 .S X=$P($G(^AUTTIML(+BILIEN,0)),U,15)  Q:X
 .S X=$P($G(^BISITE(+$G(BIDUZ2),0)),U,25)
 S:(X="") X=50
 Q X
 ;
 ;
 ;----------
FORECAS(BIDUZ2) ;EP
 ;---> Return 1 if Forecasting is enabled.
 ;---> Parameters:
 ;     1 - BIDUZ2 (req) User's DUZ(2)
 ;
 Q $P($G(^BISITE(+$G(BIDUZ2),0)),U,11)
 ;
 ;
 ;----------
INPTCHK(BIDUZ2) ;EP
 ;---> Return 1 if Inpatient Visit Check is enabled.
 ;---> Parameters:
 ;     1 - BIDUZ2 (req) User's DUZ(2)
 ;
 Q $P($G(^BISITE(+$G(BIDUZ2),0)),U,23)
 ;
 ;
 ;----------
RISKP(BIDUZ2) ;EP - Risk Factor check (and smoking).
 ;---> Risk Parameter: Return 0 if disabled, 1 if enabled,
 ;---> 3 to include smoking in pneumo.
 ;---> Parameters:
 ;     1 - BIDUZ2 (req) User's DUZ(2)
 ;
 Q +$P($G(^BISITE(+$G(BIDUZ2),0)),U,19)
 ;
 ;
 ;----------
IMPCPT(BIDUZ2) ;EP
 ;---> Return 1 if Import of CPT-coded Visits is enabled.
 ;---> Parameters:
 ;     1 - BIDUZ2 (req) User's DUZ(2)
 ;
 Q $P($G(^BISITE(+$G(BIDUZ2),0)),U,20)
 ;
 ;
 ;----------
VISMNU(BIDUZ2) ;EP
 ;---> Visit Selection Menu Parameter: Return 1 to display a menu of matching
 ;---> Visits, if any; return 0 to automatically creat or link Visits.
 ;---> Parameters:
 ;     1 - BIDUZ2 (req) User's DUZ(2)
 ;
 Q +$P($G(^BISITE(+$G(BIDUZ2),0)),U,28)
 ;
 ;
 ;----------
CMGRACT(BICMGR) ;EP
 ;---> Return 1 if the Case Manager is INACTIVE.
 ;---> Parameters:
 ;     1 - BICMGR (req) IEN of Case Manager.
 ;
 Q:'$G(BICMGR) 1
 Q:'$D(^BIMGR(BICMGR,0)) 1
 Q $P(^BIMGR(BICMGR,0),U,2)
 ;
 ;
 ;----------
CMGRDEF(DUZ2,X) ;EP
 ;---> Return Default Case Manager for this site.
 ;---> Parameters:
 ;     1 - DUZ2 (req) User's DUZ(2)
 ;     2 - X    (opt) X=1 to return TEXT of default Case Manager name.
 ;
 Q:'$G(DUZ2) ""
 N Y S Y=$P($G(^BISITE(DUZ2,0)),U,2)
 Q:'Y ""
 Q:'$D(^BIMGR(Y,0)) ""
 Q:'$G(X) Y
 Q:$$CMGRACT(Y) $E($$PERSON^BIUTL1(Y),1,20)_" * INACTIVE!"
 Q $$PERSON^BIUTL1(Y)
 ;
 ;
 ;----------
DEFLET(DUZ2,X,Z) ;EP
 ;---> Return Default Letters (Standard Due Letter,
 ;---> Official Imm Record).
 ;---> Parameters:
 ;     1 - DUZ2 (req) User's DUZ(2)
 ;     2 - X    (opt) X=1 to return TEXT of default Due Letter.
 ;     3 - Z    (opt) Z="" returns Standard Due Letter.
 ;                    Z=1 returns Official Immunization Record.
 ;
 Q:'$G(DUZ2) ""
 N Y S Y=$P($G(^BISITE(DUZ2,0)),U,$S($G(Z):13,1:4))
 Q:'$G(X) Y
 Q:'Y ""
 Q $P($G(^BILET(Y,0)),U)
 ;
 ;
 ;----------
MINDAYS(DUZ2) ;EP
 ;---> Return Default Minimum Days Since Last Letter sent
 ;---> for this site.
 ;---> Parameters:
 ;     1 - DUZ2 (req) User's DUZ(2)
 ;
 Q:'$G(DUZ2) 60
 N Y S Y=$P($G(^BISITE(DUZ2,0)),U,5)
 Q:Y="" 60
 Q Y
 ;
 ;
 ;----------
MINAGE(DUZ2) ;EP
 ;---> Return parameter to forecast immunizations due at either the
 ;---> Minimum Acceptable Age or at the Recommended Age for this site.
 ;---> Parameters:
 ;     1 - DUZ2 (req) User's DUZ(2)
 ;
 Q:'$G(DUZ2) "R"
 N Y S Y=$P($G(^BISITE(DUZ2,0)),U,7)
 Q:Y="" "R"
 Q Y
 ;
 ;
 ;----------
RULES(DUZ2) ;EP
 ;---> Return parameter indicating which set of Immserve Forecasting
 ;---> Rules is being used (passed to Immserve).
 ;---> Parameters:
 ;     1 - DUZ2 (req) User's DUZ(2)
 ;
 N Y S Y=$$VALIDRUL(DUZ2)
 Q:'Y "IHS_1m18"
 Q "IHS_"_Y
 ;
 ;
 ;----------
VALIDRUL(DUZ2) ;EP - Return 0 if not a valid choice of Immserve Rules.
 ;---> Return whether current Immserve Site Parameter is a valid choice.
 ;---> Return 0 is NOT a valid choice; otherwise return the numeric choice.
 ;---> Parameters:
 ;     1 - DUZ2 (req) User's DUZ(2)
 ;
 Q:'$G(DUZ2) 0
 N X,Y
 S Y=$G(^BISITE(DUZ(2),0)),X=$P(Y,U,8)
 ;---> For a new set of Immserve Rules, change here below and $$RULES+10^BISITE2.
 ;---> Current valid choices are 1,2,3,4,5,11.
 Q:((X<1)!(X>11)) 0
 Q:((X>7)&(X<11)) 0
 Q X_$S($P(Y,U,21):"g",1:"")_$S($P(Y,U,24)=2:"m26",1:"m18")
 ;
 ;
 ;----------
VISDEF(IEN) ;EP
 ;---> Return the Default Date of the Vaccine Information Statement
 ;---> (VIS) for this vaccine (Fileman format).
 ;---> Parameters:
 ;     1 - IEN  (req) IEN of Vaccine in IMMUNIZATION File (9999999.14).
 ;
 Q:'$G(IEN) ""
 Q:'$D(^AUTTIMM(IEN,0)) ""
 Q $P(^AUTTIMM(IEN,0),"^",13)
 ;
 ;
 ;----------
ZIS(BIPOP,BIQUE,BIDEF,BIPRMPT,BIMES) ;EP
 ;---> Call to ^%ZIS
 ;---> Parameters:
 ;     1 - BIPOP         (ret) BIPOP=1 if POP=1 (fail or quit).
 ;     2 - BIQUE=1       (opt) SET=1 if job should be queueable.
 ;     3 - BIDEF=DEFAULT (opt) If exists, equals Default DEVICE.
 ;     4 - BIPRMPT       (opt) If exists, equals PROMPT.
 ;     5 - BIMES         (opt) A message to display if QUEUED.
 ;
 ;---> Example: D ZIS^BIUTL2(.BIPOP,1,"HOME")
 ;
ZIS1 ;EP for loop back from failed BIQUE.
 S BIPOP=0
 ;
 ;---> BIPRMPT=BIPRMPT.
 S %ZIS("A")=$S($D(BIPRMPT):BIPRMPT,1:"   Select DEVICE: ")
 ;
 ;---> BIDEF=DEFAULT PRINTER.
 ;---> IF NO BIDEF, SET BIDEF="P" FOR CLOSEST PRINTER.
 D
 .I '$D(BIDEF) S %ZIS="P" Q
 .S %ZIS("B")=BIDEF,%ZIS=""
 ;
 ;---> If BIQUE=1,job may be queued.
 I $G(BIQUE)]"" I BIQUE S %ZIS=%ZIS_"Q"
 ;
 W ! D ^%ZIS S:POP BIPOP=1
 ;---> Quit if BIPOP (DUOUT or DTOUT) or if not queued.
 G:BIPOP!('$D(IO("Q"))) ZISEXIT
 ;
 I IO=IO(0) W !?5,"Cannot queue to screen or slave printer!",! G ZIS1
 ;
 ;---> NEXT LINE: Line Label "ZISQ" added for entry where Device
 ;---> Info has already been adked and User queued output.
ZISQ ;EP
 ;---> NEXT LINES: Job was queued, therefore set BIPOP=1 so that the
 ;---> calling routine will quit (and let Taskman finish this job).
 S BIPOP=1
 I '$D(ZTRTN) D  G ZISEXIT
 .W !?5,*7,"NO ROUTINE NAMED FOR QUEUEING -- CONTACT PROGRAMMER."
 I '$D(ZTDESC) S ZTDESC=ZTRTN
 S BIMES=$S($D(BIMES):BIMES,1:"W !?5,""Request Queued."",!")
 ;
 S ZTIO=$S($D(ION):ION,1:"")
 I ZTIO]"" D
 .I $D(IO("DOC")) S ZTIO=ZTIO_";"_IOST_";"_IO("DOC") Q
 .S ZTIO=ZTIO_";"_IOST_";"_IOM_";"_IOSL
 ;
 ;---> Uncomment next line to suppress "Requested Start Time" question.
 ;S ZTDTH=$H
 D ^%ZTLOAD,^%ZISC
 X:$D(ZTQUEUED) BIMES H 2
 ;
ZISEXIT ;EP
 K BIMES,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
 Q
 ;
 ;
 ;----------
DFNCHECK() ;EP
 ;---> If BIDFN not supplied, set Error Code and quit.
 I '$G(BIDFN) D ERRCD^BIUTL2(201,,1) Q 1
 Q 0
 ;
 ;
 ;----------
DUZCHECK() ;EP
 ;---> If no BIDUZ2 (Site IEN), Set it equal to User's DUZ(2).
 ;---> If User's DUZ(2) fails, set Error Code and quit.
 S:'$G(BIDUZ2) BIDUZ2=$G(DUZ(2))
 I '$G(BIDUZ2) D ERRCD^BIUTL2(105,,1) Q 1
 Q 0
