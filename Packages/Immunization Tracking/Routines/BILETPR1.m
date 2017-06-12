BILETPR1 ;IHS/CMI/MWR - PRINT PATIENT LETTERS.; DEC 15, 2011
 ;;8.5;IMMUNIZATION;**10**;MAY 30,2015
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  BUILD ^TMP WP ARRAY FOR PRINTING LETTERS.
 ;;  PATCH 10: If no skin tests on record, display explicitly. HISTORY1+190
 ;;            Display only the most recent three dates of Skin Tests. HISTORY1+209
 ;
 ;
 ;----------
BUILD(BIDFN,BILET,BIDLOC,BIFDT) ;EP
 ;---> Build temporary global of populated letter in ^TMP("BILET",$J).
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     2 - BILET  (req) IEN of Letter in BI LETTER File.
 ;     3 - BIDLOC (opt) Text of Date/Location line.
 ;     4 - BIFDT  (opt) Forecast Date.
 ;
 K ^TMP("BILET",$J)
 N BILINE,BI31 S BILINE=0,BI31=$C(31)_$C(31)
 ;
 ;---> Error check.
 N BIERR S BIERR=""
 D  I BIERR]"" D WRITE(.BILINE,BIERR) Q
 .I '$G(BIDFN) D ERRCD^BIUTL2(201,.BIERR) Q
 .I '$D(^DPT(BIDFN,0)) D ERRCD^BIUTL2(203,.BIERR) Q
 .I '$G(BILET) D ERRCD^BIUTL2(609,.BIERR) Q
 .I '$D(^BILET(BILET,0)) D ERRCD^BIUTL2(610,.BIERR) Q
 .S:'$G(BIFDT) BIFDT=DT
 ;
 ;---> Get forecast string (BIFORCST) and problem dose string (BIPDSS).
 ;---> Pass BIPDSS to HISTORY to mark problem doses with asterisks.
 ;---> Pass BIFORCST to FORECAST for display.
 N BIFORCST,BIPDSS S BIPDSS=""
 D IMMFORC^BIRPC(.BIFORCST,BIDFN,BIFDT,,$G(BIDUZ2),.BIPDSS)
 ;---> If Forecast comes first, set BIFF=1
 N BIFF S BIFF=$P(^BILET(BILET,0),U,6)
 ;
 ;---> Retrieve and store sections of letter in WP ^TMP global.
 D SECTION(BILET,.BILINE,1)
 D
 .I BIFF D FORECAST(BILET,.BILINE,BIFORCST,BIFDT) Q
 .D HISTORY(BILET,.BILINE,BIDFN,BIPDSS)
 D SECTION(BILET,.BILINE,2)
 D
 .I BIFF D HISTORY(BILET,.BILINE,BIDFN,BIPDSS) Q
 .D FORECAST(BILET,.BILINE,BIFORCST,BIFDT)
 D SECTION(BILET,.BILINE,3)
 D DATELOC(BILET,.BILINE,BIDLOC)
 D SECTION(BILET,.BILINE,4)
 Q
 ;
 ;
 ;----------
SECTION(BILET,BILINE,BISEC) ;EP
 ;---> Store Section of letter in ^TMP("BILET",$J).
 ;---> Parameters:
 ;     1 - BILET  (req) IEN of Letter in BI LETTER File.
 ;     2 - BILINE (ret) Last line written into ^TMP array.
 ;     3 - BISEC  (req) Section of Form Letter to retrieve.
 ;
 N N S N=0
 F  S N=$O(^BILET(BILET,BISEC,N)) Q:'N  D
 .D WRITE(.BILINE,^BILET(BILET,BISEC,N,0))
 Q
 ;
 ;
 ;----------
HISTORY(BILET,BILINE,BIDFN,BIPDSS) ;EP
 ;---> Retrieve and store Imm History in WP ^TMP global.
 ;---> Parameters:
 ;     1 - BILET  (req) IEN of Letter in BI LETTER File.
 ;     2 - BILINE (ret) Last line written into ^TMP array.
 ;     3 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     4 - BIPDSS (opt) Returned string of Visit IEN's that are Problem Doses,
 ;
 ;---> Quit if this Form Letter does not included Imm History.
 N BIFORM S BIFORM=$P(^BILET(BILET,0),U,2)
 N BINVAL S BINVAL=+$P(^BILET(BILET,0),U,5)
 Q:'BIFORM
 ;
 ;---> If History should be listed by Date, BIFORM=1 or 2;
 ;---> If History should be listed by Vaccine, BIFORM=3 or 4.
 D WRITE(.BILINE)
 D HISTORY1(.BILINE,BIDFN,BIFORM,BINVAL,"BILET",BIPDSS)
 D WRITE(.BILINE)
 D CONTRAS(.BILINE,BIDFN,"BILET")
 D WRITE(.BILINE)
 Q
 ;
 ;
 ;----------
HISTORY1(BILINE,BIDFN,BIFORM,BINVAL,BIGBL,BIPDSS,BIHDRS,BINOSK,BILOC,BIMMRF,BIMMLF) ;EP
 ;---> Retrieve and store Imm History in WP ^TMP global.
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line written into ^TMP array.
 ;     2 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     3 - BIFORM (opt) 1=List by Date (default), 2=by Date w/Lot#,
 ;                      3=List by Vaccine, 4=by Vaccine w/Lot#,
 ;                      5=by Date w/VFC, 6=by Vaccine w/VFC
 ;                      7=by Date w/Lot & VFC, 8=by Vaccine w/Lot & VFC.
 ;     4 - BINVAL (opt) 0=Include Invalid Doses, 1=Exclude Invalid Doses.
 ;     5 - BIGBL  (opt) ^TMP global node to write to (def="BILET").
 ;     6 - BIPDSS (opt) Returned string of Visit IEN's that are
 ;                        Problem Doses, according to ImmServe.
 ;     7 - BIHDRS (opt) 0=Print Imm and Skin Subheaders; 1=No Subeaders.
 ;     8 - BINOSK (opt) 0=Include Skin Tests, 1=Do not include Skin Tests
 ;                      2=Include Skin Tests ONLY (NO Immunizations).
 ;     9 - BILOC  (opt) 1=Add Location in the form: [4-char] for BIFORM 1&2.
 ;    10 - BIMMRF (opt) Imms Received Filter array (subscript=CVX's included).
 ;    11 - BIMMLF (opt) Lot Number Filter array (subscript=lot number text).
 ;
 S:$G(BIGBL)="" BIGBL="BILET"
 S:$G(BIFORM)="" BIFORM=1 S:$G(BINVAL)="" BINVAL=0
 ;
 ;---> RPC to gather Immunization History.
 ;     BIRETVAL - Return value of valid data from RPC.
 ;     BIRETERR - Return value (text string) of error from RPC.
 ;
 N BIDE,BIRETVAL,BIRETERR,I S BIRETVAL=""
 ;
 ;---> Set BIDE local array for Data Elements to be returned.
 ;---> The following are IEN's in ^BIEXPDD(.
 ;---> IEN PC  DATA
 ;---> --- --  ----
 ;--->     1 = Visit Type: "I"=Immunization, "S"=Skin Test.
 ;--->  4  2 = Vaccine Name, Short.
 ;--->  8  3 = Vaccine Components.  ;v8.0
 ;---> 24  4 = IEN, V File Visit.
 ;---> 26  5 = Location (or Outside Location) where Imm was given.
 ;---> 27  6 = Vaccine Group (Series Type) for grouping of vaccines.
 ;---> 33  7 = Vaccine Lot#, Text.
 ;---> 38  8 = Skin Test Result.
 ;---> 39  9 = Skin Test Reading.
 ;---> 41 10 = Skin Test Name.
 ;---> 44 11 = Reaction to Immunization, text.
 ;---> 56 12 = Date of Visit Fileman format (YYYMMDD).
 ;---> 65 13 = Dose Override.
 ;---> 69 14 = Vaccine Component CVX Code.
 ;---> 77 15 = VFC for this immunization.
 ;
 ;
 F I=4,8,24,26,27,33,38,39,41,44,56,65,69,77 S BIDE(I)=""
 D IMMHX^BIRPC(.BIRETVAL,BIDFN,.BIDE,1,0)
 ;
 ;---> If BIRETERR has a value, store it and quit.
 S BIRETERR=$P(BIRETVAL,BI31,2)
 I BIRETERR]"" D  Q
 .D WRITE(.BILINE,"     "_BIRETERR,BIGBL)
 .D WRITE(.BILINE,,BIGBL)
 ;
 ;---> Set BIHX=to a valid Immunization History for this patient.
 N BIHX S BIHX=$P(BIRETVAL,BI31,1)
 ;
 ;---> Build Listmanager array from BIHX string.
 ;
 ;---> List Immunization (and Skin Test)  History by Vaccine, and quit.
 I (BIFORM=3)!(BIFORM=4) D HISTORY2^BILETPR3(.BILINE,BIHX,BIDFN,BIFORM,BINVAL,BIPDSS) Q
 ;
 D:$G(BINOSK)'=2 WRITE(.BILINE,,BIGBL)
 ;
 N BIAR,I,V,Y S V="|"
 ;
 ;---> List Immunization History by Date (if call is not for Skin Test ONLY).
 ;---> Loop through "^"-pieces of Imm History, getting data.
 I $G(BINOSK)'=2 F I=1:1 S Y=$P(BIHX,U,I) Q:Y=""  D
 .;---> Quit if this is not an Immunization.
 .Q:$P(Y,V)'="I"
 .;
 .;---> Set BIPD=1 if Immserve has a problem with this dose.
 .N BIPD S BIPD=$$PDSS^BIUTL8($P(Y,V,4),$P(Y,V,14),$G(BIPDSS))
 .;
 .;---> Quit if not displaying Invalid Doses (but will display a Forced Valid).
 .;Q:((BINVAL=1)&(($P(Y,V,13)&($P(Y,V,13)'=9))!BIPD))
 .;
 .;---> Do not display if this vaccine is not in the display filter array.
 .I $D(BIMMRF) Q:('$D(BIMMRF(+$P(Y,V,14))))
 .;
 .;---> Do not display if this lot number is not in the display filter array.
 .I $D(BIMMLF) Q:('$D(BIMMLF(+$P(Y,V,7))))
 .;
 .;---> Set Vaccine Name.
 .N X S X=$P(Y,V,2)
 .;
 .;---> Tack on Lot# if specified.
 .N BILOT S BILOT=$P(Y,V,7)
 .S:((BIFORM=2)&(BILOT]"")) X=X_" (#"_BILOT_")"
 .;
 .;---> Tack on VFC if specified.
 .N BIVFC S BIVFC=$P(Y,V,15)
 .S:((BIFORM=5)&(BIVFC>1)) X=X_" (VFC+)"
 .;
 .;---> Tack on Lot# & VFC if specified.
 .I BIFORM=7 D
 ..I (BILOT="")&(BIVFC<2) Q
 ..S X=X_" ("
 ..I BILOT]"" S X=X_"#"_BILOT
 ..I (BILOT]"")&(BIVFC>1) S X=X_", "
 ..I BIVFC>1 S X=X_"VFC+"
 ..S X=X_")"
 .;
 .;---> Tack on Location if specified.
 .S:$G(BILOC) X=X_" ["_$E($P(Y,V,5),1,4)_"]"
 .;
 .;---> If this Dose has a User Override or is an ImmServe Problem Dose,
 .;---> prepend an asterisk and tack the reason on the end.
 .D
 ..I $P(Y,V,13) D  Q
 ...;---> But don't display text "Force Valid" ($P(Y,V,13)'=9).
 ...S X="*"_X
 ...;---> Next line would display Invalid Reason.
 ...;I $P(Y,V,13)'=9 S X=X_"-"_$$DOVER^BIUTL8($P(Y,V,13))_"-"
 ..;
 ..S:BIPD X="*"_X
 ..;---> Next line would display Immserve problem.
 ..;_"-INVALID--SEE IMMSERVE-"
 .;
 .;---> If there was a Reaction, tack it on.
 .I $P(Y,V,11)]"" S X=X_" Reaction: "_$P(Y,V,11)
 .;
 .;---> Set this Immunization in the array:
 .;---> BIAR(VisitDate,VaccineName,VisitIEN)=VaccineName (Lot#)--Problem Dose
 .S BIAR($P(Y,V,12),$P(Y,V,2),$P(Y,V,4))=X
 ;
 ;---> Build Imm History lines for History Section of Form Letter.
 N N S N=0
 F  S N=$O(BIAR(N)) Q:'N  D
 .N BIHXLN
 .S BIHXLN=$$SLDT2^BIUTL5(N,1)_": "
 .N I,M S M=0
 .;---> Note: I and J below are counters for inserting ", ".
 .;---> In v8.1 come back here and allow for extremely long immunizations
 .;---> that have Combo name + Lot# + Invalid text + reaction text.
 .F I=1:1 S M=$O(BIAR(N,M)) Q:M=""  D
 ..N J,P S P=0
 ..F J=1:1 S P=$O(BIAR(N,M,P)) Q:'P  D
 ...N X S X=BIAR(N,M,P)
 ...;---> If this line will be too long, write it and start a new line.
 ...I $L(BIHXLN_X)>70 D  Q
 ....D WRITE(.BILINE,"     "_BIHXLN_",",BIGBL)
 ....S BIHXLN="          "_X
 ...S BIHXLN=BIHXLN_$S((I>1!(J>1)):", ",1:"")_X
 .D:$O(BIAR(0)) WRITE(.BILINE,"     "_BIHXLN,BIGBL)
 ;
 ;---> If there are no previous immunizations and this call is NOT for
 ;---> Skin Tests ONLY, then store next line.
 I '$O(BIAR(0)),$G(BINOSK)'=2 D
 .D WRITE(.BILINE,"        No previous immunizations recorded.",BIGBL)
 ;
 ;---> Quit if NOT including Skin Tests.
 Q:($G(BINOSK))=1
 ;
 ;---> SKIN TESTS
 ;---> PC  DATA
 ;---> --  ----
 ;--->  1 = Visit Type: "I"=Immunization, "S"=Skin Test.
 ;--->  4 = V Skin Test File IEN.
 ;--->  5 = Location (or Outside Location) where Imm was given.
 ;--->  8 = Skin Test Result.
 ;--->  9 = Skin Test Reading.
 ;---> 10 = Skin Test Name.
 ;---> 12 = Date of Visit Fileman format (YYYMMDD).
 ;
 ;---> List Skin Test History by Date.
 ;---> Loop through "^"-pieces of Imm History, getting data.
 K BIAR
 F I=1:1 S Y=$P(BIHX,U,I) Q:Y=""  D
 .;---> Quit if this is not a Skin Test.
 .Q:$P(Y,V)'="S"
 .;---> Set display line for this Skin Test Name and Date.
 .S X=$P(Y,V,10),X=$$PAD^BIUTL5(X,12)
 .;
 .D
 ..I $P(Y,V,8)]"" S X=X_$P(Y,V,8) Q
 ..I $P(Y,V,9) S X=X_$P(Y,V,9)_" mm" Q
 ..S X=X_"Not recorded"
 .;
 .;---> Set this Skin Test in the array:
 .;---> BIAR(VisitDate,SkinTestName,VisitIEN)=Skin Test display line.
 .S BIAR($P(Y,V,12),$P(Y,V,10),$P(Y,V,4))=X
 ;
 ;********** PATCH 10, v8.5, MAY 30,2015, IHS/CMI/MWR
 ;---> If no skin tests on record, display that explicitly.
 ;Q:'$D(BIAR)
 I '$D(BIAR) D  Q
 .D WRITE(.BILINE)
 .S X="     Skin Tests/PPD: None on record" D WRITE(.BILINE,X)
 ;**********
 ;
 ;---> Skin Test Header.
 D:$G(BINOSK)'=2 WRITE(.BILINE,,BIGBL)
 D:'$G(BIHDRS)
 .;S X="               Skin Tests:"
 .S X="               Recent Skin Tests:"
 .D WRITE(.BILINE,X,BIGBL)
 .S X="               -----------------------"
 .D WRITE(.BILINE,X,BIGBL)
 ;
 ;---> Build Skin Test History lines for History Section of Form Letter.
 ;
 ;********** PATCH 10, v8.5, MAY 30,2015, IHS/CMI/MWR
 ;---> Display only the most recent three dates of Skin Tests.
 ;
 N BIZTEMP
 ;
 N N S N=0
 F  S N=$O(BIAR(N)) Q:'N  D
 .N BIDT
 .S BIDT=$$SLDT2^BIUTL5(N,1)
 .N I,M S M=0
 .F I=1:1 S M=$O(BIAR(N,M)) Q:M=""  D
 ..N P S P=0
 ..F  S P=$O(BIAR(N,M,P)) Q:'P  D
 ...N X S X=BIAR(N,M,P)
 ...S X="     "_$S(I=1:BIDT_": ",1:"          ")_X
 ...;
 ...S BIZTEMP(N,M)=X
 ...;D WRITE(.BILINE,X,BIGBL)
 ;
 N N S N=9999999
 F I=1:1:4 S N=+$O(BIZTEMP(N),-1) Q:'N
 F  S N=$O(BIZTEMP(N)) Q:'N  D
 .N M S M=""
 .F  S M=$O(BIZTEMP(N,M)) Q:(M="")  D
 ..D WRITE(.BILINE,BIZTEMP(N,M),BIGBL)
 ;**********
 ;
 Q
 ;
 ;
 ;----------
CONTRAS(BILINE,BIDFN,BIGBL) ;EP
 ;---> Retrieve and store Contraindications in WP ^TMP global.
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line written into ^TMP array.
 ;     2 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     3 - BIGBL  (opt) ^TMP global node to write to (def="BILET").
 ;
 S:$G(BIGBL)="" BIGBL="BILET"
 N BIRETVAL,BIRETERR,I S BIRETVAL=""
 ;
 ;---> RPC to retrieve Contraindications.
 D CONTRAS^BIRPC5(.BIRETVAL,BIDFN)
 ;
 ;---> If BIRETERR has a value, display it and quit.
 S BIRETERR=$P(BIRETVAL,BI31,2)
 I BIRETERR]"" D  Q
 .D WRITE(.BILINE,"     "_BIRETERR,BIGBL)
 .D WRITE(.BILINE,,BIGBL)
 ;
 ;---> Set BICONT=to a string of Contraindications for this patient.
 N BICONT S BICONT=$P(BIRETVAL,BI31,1)
 Q:BICONT=""
 ;
 ;---> Build Listmanager array from BICONT string.
 ;
 N J S J=1
 F I=1:1 S Y=$P(BICONT,U,I) Q:Y=""  D
 .;---> Build display line for this Contraindication.
 .N V S V="|",X="     "
 .S:J X=X_"* Contraindications:",J=0 S X=$$PAD^BIUTL5(X,28)
 .;
 .;---> Display "Vaccine:  Date  Reason"
 .;---> Quit if Reason is a "Refusal."  Also, if it's the first line of Contras
 .;---> reset J so that "Contraindications:" header displays on the next one.
 .I Y["Refusal" D  Q
 ..I I=1 S J=1
 .S X=X_$P(Y,V,2)_":",X=$$PAD^BIUTL5(X,40)_$P(Y,V,4)
 .S X=$$PAD^BIUTL5(X,53)_$P(Y,V,3)
 .;---> Set formatted Contraindication line and index in ^TMP.
 .D WRITE(.BILINE,X,BIGBL)
 Q
 ;
 ;
 ;----------
FORECAST(BILET,BILINE,BIFORCST,BIFDT) ;EP
 ;---> Calculate and store Forecast in WP ^TMP global.
 ;---> Parameters:
 ;     1 - BILET    (req) IEN of Letter in BI LETTER File.
 ;     2 - BILINE   (ret) Last line written into ^TMP array.
 ;     3 - BIFORCST (req) Raw forecast string back from call to IMMFORC^BIRPC.
 ;     4 - BIFDT    (opt) Forecast Date.
 ;
 ;---> Quit if this Form Letter does not included a Forecast.
 Q:'$P(^BILET(BILET,0),U,3)
 ;
 ;---> If Forecast Date not provided, set it equal to today.
 S:'$G(BIFDT) BIFDT=DT
 ;
 ;---> RPC to gather Immunization History.
 ;     BIFORCST - Return value of valid data from RPC.
 ;     BIRETERR - Return value (text string) of error from RPC.
 ;
 N BIRETERR S BIRETVAL=""
 ;
 ;---> If BIRETERR has a value, store it and quit.
 S BIRETERR=$P(BIFORCST,BI31,2)
 I BIRETERR]"" D  Q
 .D WRITE(.BILINE),WRITE(.BILINE,"     "_BIRETERR),WRITE(.BILINE)
 ;
 ;---> Set BIFORC=to the Immunization Forecast for this patient.
 N BIFORC,I,V S V="|",BIFORC=$P(BIFORCST,BI31,1)
 ;
 D WRITE(.BILINE)
 ;
 ;---> If Forecast Date is not Today, display Forecast Date in letter.
 D:BIFDT'=DT
 .;---> Set Forecast Date external form for letter text.
 .N BIFDT1 S BIFDT1=$$TXDT1^BIUTL5(BIFDT)
 .D WRITE(.BILINE,"        For "_BIFDT1_":")
 ;
 ;---> Loop through "^"-pieces of Imm Forecast, getting data.
 F I=1:1 S Y=$P(BIFORC,U,I) Q:Y=""  D
 .;
 .S Y=$P(Y,V) I +Y&($E(Y,2)="-") S Y=$E(Y,3,99)
 .;
 .D WRITE(.BILINE,"        "_$$STRIP^BIUTL5(.Y))
 D WRITE(.BILINE)
 Q
 ;
 ;
 ;----------
DATELOC(BILET,BILINE,BIDLOC) ;EP
 D DATELOC^BILETPR2(BILET,.BILINE,BIDLOC)
 Q
 ;
 ;
 ;----------
WRITE(BILINE,BIVAL,BIGBL) ;EP
 D WRITE^BILETPR3(.BILINE,$G(BIVAL),$G(BIGBL))
 Q
