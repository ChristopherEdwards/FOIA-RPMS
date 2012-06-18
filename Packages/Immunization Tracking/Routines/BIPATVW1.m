BIPATVW1 ;IHS/CMI/MWR - BUILD LIST ARRAY OF IMM DATA; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  BUILD LISTMANAGER ARRAY FOR DISPLAY AND EDIT OF
 ;;  PATIENT'S IMMUNIZATION DATA.
 ;
 ;
 ;----------
MAIN(BIPRT) ;EP
 ;---> Build LM array for Patient Data Screen.
 ;---> Parameters:
 ;     1 - BIPRT  (opt) If BIPRT=1 array is for print: skip INIT.
 ;
 ;---> Check for BIDFN.
 Q:$$DFNCHECK^BIUTL2()
 Q:$$DUZCHECK^BIUTL2()
 ;
 N BI31,BIENT,BIFORCST,BILINE,BIPDSS,BIRETVAL,BIRETERR,BILMAX,BIRMAX
 S BIENT=0,BILMAX=0,BIRMAX=0,BI31=$C(31)_$C(31)
 S:'$G(BIFDT) BIFDT=$G(DT)
 ;
 D:'$G(BIPRT) INIT
 ;---> Get forecast string (BIFORCST) and problem dose string (BIPDSS).
 ;---> Pass BIPDSS to HISTORY to mark problem doses with asterisks.
 ;---> Pass BIFORCST to FORECAST for display.
 D IMMFORC^BIRPC(.BIFORCST,BIDFN,BIFDT,,$G(BIDUZ2),.BIPDSS)
 D HISTORY(BIDFN,$G(BIPDSS),.BILMAX,.BIENT)
 D FORECAST(BIFORCST,.BIRMAX)
 D LASTLET^BIPATVW3(BIDFN,.BIRMAX,.BIENT)
 D CONTRAS^BIPATVW3(BIDFN,.BILMAX,.BIRMAX,.BIENT)
 ;
 N BILINE S BILINE=$S(BIRMAX>BILMAX:BIRMAX,1:BILMAX)
 D ADDINFO^BIPATVW3(BIDFN,.BILINE,.BIENT,$G(BIDUZ2),BIFDT)
 ;
 D:$G(BIPRT)
 .N X S X="Printed: "_$$NOW^BIUTL5() D CENTERT^BIUTL5(.X)
 .D WRITE(.BILINE,X)
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=BILINE
 I VALMCNT>12 D
 .S VALMSG="Scroll down to view more. Type ?? or Q to QUIT."
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 ;
 S VALMSG="Type ?? for more actions or Q to Quit."
 ;
 ;---> Set default date for Screenman (if not already set, today).
 S:'$D(BIDEFDT) BIDEFDT=$G(DT)
 ;
 ;---> If no Forecast Date passed, set it equal to today.
 S:'$G(BIFDT) BIFDT=DT
 ;
 ;---> Show Forecast Date on Imms Due column header.
 D:$G(BIFDT)
 .N X S X="Immunizations DUE on "_$$SLDT2^BIUTL5(BIFDT)
 .D CHGCAP^VALM("IMMUNIZATIONS DUE",X)
 Q
 ;
 ;
 ;----------
HISTORY(BIDFN,BIPDSS,BILMAX,BIENT) ;EP
 ;---> Gather Immunization History and set in Listman display array.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     2 - BIPDSS (opt) Returned string of Visit IEN's that are
 ;                        Problem Doses, according to ImmServe.
 ;     3 - BILMAX (ret) Maximum Left column line number.
 ;     4 - BIENT  (ret) Entry Number for LM selection in VALMY
 ;
 ;---> Check for BIDFN.
 Q:$$DFNCHECK^BIUTL2()
 ;
 ;---> Call RPC to gather Immunization History.
 ;     BIRETVAL - Return value of valid data from RPC.
 ;     BIRETERR - Return value (text string) of error from RPC.
 ;
 N BIRETVAL,BIRETERR S BIRETVAL=""
 D IMMHX^BIRPC(.BIRETVAL,BIDFN,,1,0)
 ;
 ;---> If BIRETERR has a value, display it and quit.
 S BIRETERR=$P(BIRETVAL,BI31,2)
 I BIRETERR]"" D EN^DDIOL("* "_BIRETERR,"","!!?5"),DIRZ^BIUTL3() Q
 ;
 ;---> Set BIHX(BIDFN)=to a valid Immunization History for this patient.
 ;---> * NOTE! BIHX(BIDFN) is not newed; it is used to edit and delete
 ;       Immunizations for this patient (sub BIDFN for insurance).
 ;
 S BIHX(BIDFN)=$P(BIRETVAL,BI31,1)
 ;
 ;---> Build Listmanager array from BIHX(BIDFN) string.
 K ^TMP("BILMVW",$J)
 N BILINE,BISK,I,V,X,Y,Z
 S BILINE=0,V="|",Z=""
 ;
 ;---> Loop through "^"-pieces of Imm History, displaying.
 F I=1:1 S Y=$P(BIHX(BIDFN),U,I) Q:Y=""  D
 .;
 .;---> IMMUNIZATIONS
 .;---> If this is an Immunization, display as follows and quit.
 .I $P(Y,V)="I" D  Q
 ..;
 ..;---> If not the same Vaccine Group, insert a blank line.
 ..I $P(Y,V,6)'=Z D:I>1 RTCOL(.BILINE,,BIENT) S Z=$P(Y,V,6)
 ..;
 ..S BIENT=BIENT+1
 ..;---> Set display line for this immunization.
 ..S X=$S(BIENT>9:" ",1:"  ")_BIENT_"  "_$P(Y,V,17)
 ..;
 ..;---> Next line: Prepend asterisk if this Dose has a User Override
 ..;---> or is an ImmServe Problem Dose (flag stored in BIPDSSA).
 ..;---> (Override=pc 16, ImmServe string of prob doses=pc 4.)
 ..N A,BIPDSSA S A="  ",BIPDSSA=0
 ..D
 ...I $P(Y,V,16) S A=" *" Q
 ...I $$PDSS^BIUTL8($P(Y,V,4),$P(Y,V,18),BIPDSS) S A=" *",BIPDSSA=1
 ..S X=X_A_$P(Y,V,2)
 ..;
 ..;---> Pad with spaces to line up in columns.
 ..S X=$$PAD^BIUTL5(X,37)
 ..;---> Pre-pend "+" if this immunization was imported from an outside registry.
 ..S X=X_$S($P(Y,V,20):"+",1:" ")
 ..;---> Display first 4 characters of Location of Visit.
 ..S X=X_$E($P(Y,V,5),1,4)
 ..S X=$$PAD^BIUTL5(X,43)_"|"
 ..;
 ..;---> Set formatted line and index in ^TMP.
 ..D WRITE(.BILINE,X,,BIENT)
 ..;
 ..;---> If this is a Dose Override by user, set another line to display it.
 ..D:$P(Y,V,16)
 ...S X="               -"_$$DOVER^BIUTL8($P(Y,V,16))_"-"
 ...;---> Pad Result with trailing spaces to justify columns.
 ...D WRITE(.BILINE,$$PAD^BIUTL5(X,43)_"|",,BIENT)
 ..;
 ..;---> If this is a Problem Dose by ImmServe, set another line to display it.
 ..D:$G(BIPDSSA)
 ...S X="               -INVALID--SEE IMMSERVE-"
 ...;---> Pad Result with trailing spaces to justify columns.
 ...D WRITE(.BILINE,$$PAD^BIUTL5(X,43)_"|",,BIENT)
 ..;
 ..;
 ..;---> If there was a Reaction, set another line to display it.
 ..D:$P(Y,V,13)]""
 ...S X="               ("_$P(Y,V,13)_")"
 ...;---> Pad Result with trailing spaces to justify columns.
 ...D WRITE(.BILINE,$$PAD^BIUTL5(X,43)_"|",,BIENT)
 ..;
 ..;
 ..;---> If this was created by a CPT Coded Visit, set a line to display it.
 ..D:$P(Y,V,19)
 ...S X="               (CPT-Coded visit)"
 ...;---> Pad Result with trailing spaces to justify columns.
 ...D WRITE(.BILINE,$$PAD^BIUTL5(X,43)_"|",,BIENT)
 ..;
 .;
 .;
 .;---> SKIN TESTS
 .;---> If this is a Skin Test, display as follows and quit.
 .I $P(Y,V)="S" D  Q
 ..;
 ..;---> Insert a blank line to set apart Skin Tests.
 ..I I>1 I '$D(BISK) S BISK="" D RTCOL(.BILINE,,BIENT)
 ..;
 ..S BIENT=BIENT+1
 ..;---> Set display line for this Skin Test.
 ..;S X=$S(BIENT>9:" ",1:"  ")_BIENT_"  "_$P($P(Y,V,7)," @")  v8.0
 ..S X=$S(BIENT>9:" ",1:"  ")_BIENT_"  "_$P(Y,V,17)
 ..S X=X_"  "_$P(Y,V,11)
 ..D
 ...;---> Pad with spaces to line up columns.
 ...S X=$$PAD^BIUTL5(X,38)_$E($P(Y,V,5),1,4)
 ...S X=$$PAD^BIUTL5(X,43)_"|"
 ..;
 ..;---> Set formatted line and index in ^TMP.
 ..D WRITE(.BILINE,X,,BIENT)
 ..;
 ..;---> Now set second line (results) of Skin Test.
 ..S X="               ("_$P(Y,V,8)
 ..D
 ...I $P(Y,V,8)="" I $P(Y,V,9)="" D  Q
 ....S X=X_"No result",X=$$PAD^BIUTL5(X,25)
 ...;---> Pad out to reading column.
 ...S X=$$PAD^BIUTL5(X,24)
 ..D
 ...;---> Justify Reading column.
 ...N Z S Z=$P(Y,V,9)
 ...Q:Z=""
 ...S:Z<10 Z=" "_Z
 ...S X=X_" "_Z_"mm"
 ..D
 ...;---> Justify Read Date column.
 ...N Z S Z=$P(Y,V,10)
 ...Q:'Z
 ...S X=X_" on "_Z
 ..S X=X_")",X=$$PAD^BIUTL5(X,43)_"|"
 ..;
 ..D WRITE(.BILINE,X,,BIENT)
 ;
 ;---> Save maximum left column line number.
 S BILMAX=BILINE
 Q
 ;
 ;
 ;----------
FORECAST(BIFORCST,BIRMAX) ;EP
 ;---> Now retrieve ImmServe Forecast and append to right half
 ;---> of screen.
 ;---> Parameters:
 ;     1 - BIFORCST (req) Raw forecast string back from call to IMMFORC^BIRPC.
 ;     2 - BIRMAX   (ret) Maximum Right column line number.
 ;
 N BII,BILINE,BIRETERR
 ;
 ;---> If BIRETERR has a value, this is a FATAL ERROR in Forecasting;
 ;---> Display the error, and set its text in the forecast box.
 S BILINE=0,BIRETERR=$P(BIFORCST,BI31,2)
 I BIRETERR]"" D  S BIRMAX=BILINE Q
 .;---> Display error, require <return> to go on.
 .D EN^DDIOL("* "_BIRETERR,"","!!?5"),DIRZ^BIUTL3()
 .D PARSE(.BILINE,BIRETERR," ERROR:",BIENT)
 ;
 ;---> If there is NO fatal error, then process forecast string.
 ;---> Set BIFORC=to an Immunization Forecast for this patient.
 N BIFORC,BIPC S BIFORC=$P(BIFORCST,BI31,1)
 ;
 ;---> Build Listmanager array from BIFORC string.
 ;---> For each piece of the Forecast, format and set in Listman.
 F BII=1:1 S BIPC=$P(BIFORC,U,BII) Q:BIPC=""  D
 .;
 .;---> If forecast contains a minor error, write it and quit.
 .I BIPC["ERROR:" D PARSE(.BILINE,BIPC,,BIENT) Q
 .;
 .;---> Set display line for this forecast immunization.
 .;---> Pad Date with trailing spaces to line up in a columns.
 .N V S V="|"
 .D
 ..N Z S Z=$P(BIPC,V)
 ..;---> If "No Immunizations Due", write this instead of other data.
 ..;---> ("No immunizations due." text is set in ^BIRPC.)
 ..I Z="No immunizations due." S X="   "_Z Q
 ..S X="   "_Z,X=$$PAD^BIUTL5(X,16)_$P(BIPC,V,2)_$P(BIPC,V,3)
 .;
 .;---> Set formatted Imm Due line and index in ^TMP.
 .D RTCOL(.BILINE,X,BIENT)
 ;
 ;---> Save maximum right column line number.
 S BIRMAX=BILINE
 Q
 ;
 ;
 ;----------
RTCOL(BILINE,BIVAL,BIENT) ;EP
 ;---> Set right column entries in ^TMP.
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;                      (Null=blank line.)
 ;     3 - BIENT  (opt) Entry Number for LM selection in VALMY
 ;
 ;---> If an Imm  History line already exists, append to it.
 N Z S Z=$G(^TMP("BILMVW",$J,BILINE+1,0))
 I Z]"" S BIVAL=Z_$G(BIVAL) D WRITE(.BILINE,BIVAL) Q
 ;
 ;---> If this is a new line, set line count and index.
 D WRITE(.BILINE,$$SP^BIUTL5(43)_"|"_$G(BIVAL),,$G(BIENT))
 Q
 ;
 ;
 ;----------
WRITE(BILINE,BIVAL,BIBLNK,BIENT) ;EP
 ;---> Write lines to ^TMP (see documentation in ^BIW).
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;     3 - BIBLNK (opt) Number of blank lines to add after line sent.
 ;     4 - BIENT  (opt) Entry Number for LM selection in VALMY
 ;
 Q:'$D(BILINE)
 D WL^BIW(.BILINE,"BILMVW",$G(BIVAL),$G(BIBLNK),$G(BIENT))
 Q
 ;
 ;
 ;----------
PARSE(BILINE,BISTR,BIFLN,BIENT) ;EP
 ;---> Parse Right Column lines to fit in proper length.
 ;---> Parameters:
 ;     1 - BILINE (req) Line Number, Right Column.
 ;     2 - BISTR  (req) String of text to be parsed out.
 ;     3 - BIFLN  (opt) First line (if null, blank line inserted).
 ;     4 - BIENT  (ret) Entry Number for LM selection in VALMY
 ;
 Q:'$D(BILINE)  Q:$G(BISTR)=""
 N A,Y,Z
 D RTCOL(.BILINE,$G(BIFLN),$G(BIENT))
 S A=1
 F  D  Q:Y=""
 .S Z=A+31,Y=$E(BISTR,A,Z)
 .D:$L(Y)=32
 ..F  Q:$E(BISTR,Z)=" "  S Z=Z-1  Q:Z<10
 ..S Y=$E(BISTR,A,Z)
 .;---> Set formatted Error line and index in ^TMP.
 .D:Y]"" RTCOL(.BILINE,"   "_Y,$G(BIENT))
 .S A=Z+1
 Q
