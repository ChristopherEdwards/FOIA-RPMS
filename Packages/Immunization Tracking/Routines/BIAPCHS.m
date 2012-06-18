BIAPCHS ;IHS/CMI/MWR - PRODUCE IMMUNIZATION PATIENT RECORD FOR HEALTH SUMMARY.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  BUILD TEMP ARRAY TO PASS BACK TO APCHS2.
 ;
 ;---> Call from IMMBI8^APCHS2: D IMMBI^BIAPCHS(APCHSPAT,.APCHSARR)
 ;
 ;----------
IMMBI(BIDFN,BIARRAY) ;EP
 ;---> Get patient's Immunization Data and write lines for display in
 ;---> Health Summary.  Pass formatted lines back in BIARRAY.
 ;---> Called by APCHS2.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient's IEN in VA PATIENT File #2.
 ;     2 - BIARRAY (ret) Local array of formatted lines for Health Summary.
 ;
 N BI31 S BI31=$C(31)_$C(31)
 K ^TMP("BIHS",$J)
 D GATHER($G(BIDFN))
 D PASSARR(.BIARRAY)
 K ^TMP("BIHS",$J)
 Q
 ;
 ;
 ;----------
GATHER(BIDFN) ;EP
 ;---> Get patient's Immunization Data and write lines for display in
 ;---> Health Summary.  Store lines in ^TMP("BIHS",$J...).
 ;---> Called by APCHS2.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient's IEN in VA PATIENT File #2.
 ;
 N BILINE S BILINE=0
 ;
 ;---> Error check.
 N BIERR,BIPDSS S BIERR=""
 D  I BIERR]"" D WRITE(.BILINE,BIERR) Q
 .I '$G(BIDFN) D ERRCD^BIUTL2(201,.BIERR) Q
 .I '$D(^DPT(BIDFN,0)) D ERRCD^BIUTL2(203,.BIERR) Q
 .S:'$G(BIFDT) BIFDT=DT
 ;
 ;---> Retrieve and store sections of letter in WP ^TMP global.
 D FORECAST(BIDFN,.BILINE,.BIPDSS)
 D CONTRAS(BIDFN,.BILINE)
 D HISTORY(BIDFN,.BILINE,BIPDSS)
 Q
 ;
 ;
 ;----------
PASSARR(BIARRAY) ;EP
 ;---> Get patient's Immunization Health Summary formatted display lines from
 ;---> ^TMP("BIHS",$J) and populate BIARRAY to pass back to APCHS2.
 ;---> Parameters:
 ;     1 - BIARRAY (req) Local array receiving copy of HS formatted lines
 ;                       from ^TMP("BIHS",$J...)
 N N S N=0
 F  S N=$O(^TMP("BIHS",$J,N)) Q:'N  S BIARRAY(N,0)=^(N,0)
 ;
 Q
 ;
 ;
 ;----------
FORECAST(BIDFN,BILINE,BIPDSS) ;EP
 ;---> Calculate and store Forecast in WP ^TMP global.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     2 - BILINE (ret) Last line written into ^TMP array.
 ;     3 - BIPDSS (ret) Returned string of Visit IEN's that are
 ;                      Problem Doses, according to ImmServe.
 ;
 ;
 N BIFORCST,BIERR S BIFORCST="",BIPDSS=""
 ;
 ;---> Get forecast string (BIFORCST) and problem dose string (BIPDSS).
 ;---> Pass BIPDSS to HISTORY to mark problem doses with asterisks.
 ;---> Pass BIFORCST to FORECAST for display.
 D IMMFORC^BIRPC(.BIFORCST,BIDFN,,,,.BIPDSS)
 D WRITE(.BILINE,"   IMMUNIZATION FORECAST:",1)
 ;
 ;---> Check for error in 2nd piece of return value.
 S BIERR=$P(BIFORCST,BI31,2)
 ;---> If there's an error, display it and quit.
 I BIERR]"" D WRITE(.BILINE,"      *"_BIERR) Q
 ;
 ;---> No error, so take 1st piece of return value and process it.
 S BIFORCST=$P(BIFORCST,BI31,1)
 N I,X
 F I=1:1 S X=$P(BIFORCST,U,I) Q:X=""  D
 .N Y S Y="   "_$$PAD($P(X,"|"),20)
 .S Y=Y_$$PAD($P(X,"|",2),36)_$P(X,"|",3)
 .D WRITE(.BILINE,Y)
 D WRITE(.BILINE)
 Q
 ;
 ;
 ;----------
CONTRAS(BIDFN,BILINE) ;EP
 ;---> Store Contraindications in ^TMP global.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     2 - BILINE (ret) Last line written into ^TMP array.
 ;
 N BIRETVAL S BIRETVAL=""
 ;---> RPC to retrieve Contraindications.
 D CONTRAS^BIRPC5(.BIRETVAL,BIDFN)
 ;
 ;---> If BIERR has a value, display it and quit.
 S BIERR=$P(BIRETVAL,BI31,2)
 I BIERR]"" D WRITE(.BILINE,"      *"_BIERR) Q
 ;
 ;---> Set BIC=to a string of Contraindications for this patient.
 N BIC S BIC=$P(BIRETVAL,BI31,1)
 Q:BIC=""
 ;---> Build Health Summary array from BIC string.
 N I,X
 F I=1:1 S X=$P(BIC,U,I) Q:X=""  D
 .;---> Build display line for this Contraindication.
 .N V,Y S V="|",Y="      "
 .S:I=1 Y=Y_"* Contraindications:" S Y=$$PAD(Y,28)
 .;
 .;---> Display "Vaccine:  Date  Reason"
 .S Y=Y_$P(X,V,2)_":",Y=$$PAD(Y,40)_$P(X,V,4)
 .S Y=$$PAD(Y,53)_$P(X,V,3)
 .;---> Set formatted Contraindication line and index in ^TMP.
 .D WRITE(.BILINE,Y)
 D WRITE(.BILINE)
 Q
 ;
 ;
HISTORY(BIDFN,BILINE,BIPDSS) ;EP
 ;---> Retrieve Patient's Imm History and store in WP ^TMP global.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     2 - BILINE (ret) Last line written into ^TMP array.
 ;     3 - BIPDSS (ret) Returned string of Visit IEN's that are
 ;                      Problem Doses, according to ImmServe.
 ;
 ;---> Next line: Change Data Elements called. ;Cimarron/Mike Remillard 7/30/03
 ;---> Use Date Element IEN 4 instead of 8.  DE 8 used to contain Dose#-Short Name;
 ;---> now it contains vaccine components.
 ;---> Also add DE 24 V File IEN, and DE 65 is Dose Override.
 ;NEW BIDE,I F I=8,26,27,60,33,44,57 S BIDE(I)=""
 ;
 ;
 ;
 ;---> If BIDE local array (Data Elements to be returned) is not
 ;---> passed, then set the following default Data Elements.
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
 ;---> 44  8 = Reaction to Immunization, text.
 ;---> 57  9 = Age at Visit.
 ;---> 65 10 = Dose Override.
 ;---> 66 11 = Date of Visit (MM/DD/YY).
 ;---> 69 12 = Vaccine Component CVX Code.
 ;
 ;
 ;
 N BIDE,I F I=4,8,24,26,27,33,44,57,65,66,69 S BIDE(I)=""
 ;
 ;call to get imm hx
 N BIERR,BIFORCST,BIRETVAL S BIRETVAL=""
 D IMMHX^BIRPC(.BIRETVAL,BIDFN,.BIDE,1,0)
 D WRITE(.BILINE,"   IMMUNIZATION HISTORY:")
 ;
 ;---> If there is an Invalid Dose or Reaction, append extra line feed.
 ;---> Use BILF as a line feed flag.  ***NOT USED for now.  CIM/MWR  8/4/03
 N BILF S BILF=0
 ;
 S BIERR=$P(BIRETVAL,BI31,2)
 I BIERR]"" D WRITE(.BILINE,"      *"_BIERR) Q
 ;
 S BIFORCST=$P(BIRETVAL,BI31,1)
 N I,V,BIX,BIZ S BIZ="",V="|"
 ;
 F I=1:1 S BIX=$P(BIFORCST,U,I) Q:BIX=""  D
 .Q:$P(BIX,V)'="I"
 .;
 .;---> Check if new vaccine group; if so, insert line feed.
 .I $P(BIX,V,6)'=BIZ D
 ..S BIZ=$P(BIX,V,6)
 ..;---> If extra line feed was just sent due to Invalid/Reaction, don't here.
 ..D:'$G(BILF) WRITE(.BILINE)
 .;---> Reset line feed flag to zero.
 .S BILF=0
 .;
 .;---> Set flag for ImmServe Problem Dose, flag for asterisk.
 .N BIAST,BIIMMS S BIAST=0,BIIMMS=0
 .;---> Next line: Insert asterisk if Problem Dose ;Cimarron/Mike Remillard 7/30/03
 .D
 ..;---> If there is a Dose Override, set asterisk flag (BIAST)=1.
 ..I $P(BIX,V,10) S BIAST=1 Q
 ..;---> If ImmServe considers this dose to be Invalid, insert asterisk.
 ..;---> Use BIPDSS (ImmServe problem dose string) from Forecast above.
 ..I $$PDSS^BIUTL8($P(BIX,V,4),$P(BIX,V,12),BIPDSS) S BIAST=1,BIIMMS=1
 .;
 .N Y S Y=""
 .S Y="     "_$S($G(BIAST):"*",1:" ")_$P(BIX,V,2)
 .S Y=$$PAD(Y,27)_$P(BIX,V,11)
 .S Y=$$PAD(Y,37)_$P(BIX,V,9)
 .S Y=$$PAD(Y,45)_$E($P(BIX,V,5),1,20)
 .S Y=$$PAD(Y,66)_$P(BIX,V,7)
 .D WRITE(.BILINE,Y)
 .;
 .;---> If there was a Dose Override, display it here.
 .D:$P(BIX,V,10)
 ..S Y=$$PAD(" ",27)_"-"_$$DOVER^BIUTL8($P(BIX,V,10))_"-"
 ..D WRITE(.BILINE,Y)  ;S BILF=1
 .;
 .;---> If ImmServe considers this dose to be Invalid, display it here.
 .;---> Use BIPDSS (ImmServe problem dose string) from Forecast above.
 .D:$G(BIIMMS)
 ..S Y=$$PAD(" ",27)_"-INVALID--SEE IMMSERVE-"
 ..D WRITE(.BILINE,Y)  ;S BILF=1
 .;
 .;---> If there was a Reaction, display it here.
 .D:$P(BIX,V,8)]""
 ..S Y=$$PAD(" ",27)_"Reaction: "_$P(BIX,V,8)
 ..D WRITE(.BILINE,Y)  ;S BILF=1
 ;
 Q
 ;
 ;
 ;----------
PAD(D,L,C) ;EP
 ;---> Pad the length of data to a total of L characters
 ;---> by adding spaces to the end of the data.
 ;     Example: S X=$$PAD("MIKE",7)  X="MIKE   " (Added 3 spaces.)
 ;---> Parameters:
 ;     1 - D  (req) Data to be padded.
 ;     2 - L  (req) Total length of resulting data.
 ;     3 - C  (opt) Character to pad with (default=space).
 ;
 Q:'$D(D) ""
 S:'$G(L) L=$L(D)
 S:$G(C)="" C=" "
 Q $E(D_$$REPEAT^XLFSTR(C,L),1,L)
 ;
 ;
 ;----------
WRITE(BILINE,BIVAL,BIBLNK) ;EP
 ;---> Write lines to ^TMP (see documentation in ^BIW).
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;     3 - BIBLNK (opt) Number of blank lines to add after line sent.
 ;
 Q:'$D(BILINE)
 D WL^BIW(.BILINE,"BIHS",$G(BIVAL),$G(BIBLNK))
 Q
