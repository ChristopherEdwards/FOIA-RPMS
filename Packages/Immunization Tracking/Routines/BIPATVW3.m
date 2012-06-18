BIPATVW3 ;IHS/CMI/MWR - ADD OTHER ITEMS, DISPLAY HELP; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  BUILD LISTMANAGER ARRAY FOR DISPLAY AND EDIT OF
 ;;  PATIENT'S IMMUNIZATION DATA, DISPLAY HELP..
 ;
 ;
 ;----------
LASTLET(BIDFN,BIRMAX,BIENT) ;EP
 ;---> Retrieve date of last letter sent to this patient and
 ;---> display it just below forecast.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     2 - BIRMAX (ret) Maximum Right column line number.
 ;     3 - BIENT  (ret) Entry Number for LM selection in VALMY
 ;
 ;---> Check for BIDFN.
 Q:$$DFNCHECK^BIUTL2()
 ;
 ;---> Call RPC to retrieve date of last letter sent.
 ;     BIRETVAL - Return value of valid data from RPC.
 ;     BIRETERR - Return value (text string) of error from RPC.
 ;
 N BIRETVAL,BIRETERR S BIRETVAL=""
 ;
 ;---> RPC to retrieve date of last letter sent.
 D LASTLET^BIRPC5(.BIRETVAL,BIDFN)
 ;
 ;---> If BIRETERR has a value, display it and quit.
 S BIRETERR=$P(BIRETVAL,BI31,2)
 I BIRETERR]"" D
 .D EN^DDIOL("* "_BIRETERR,"","!!?5"),DIRZ^BIUTL3()
 .S BIRETVAL="ERROR!"
 ;
 ;---> Set BIDATE=to date of last letter sent to this patient.
 N BIDATE S BIDATE=$P(BIRETVAL,BI31,1)
 ;
 ;---> Set formatted Last Letter Date line and index in ^TMP.
 D RTCOL^BIPATVW1(.BIRMAX,,BIENT)
 D RTCOL^BIPATVW1(.BIRMAX,"   Last Letter: "_BIDATE,BIENT)
 ;
 Q
 ;
 ;
 ;----------
CONTRAS(BIDFN,BILMAX,BIRMAX,BIENT) ;EP
 ;---> Now retrieve Patient's Contraindications and append to
 ;---> right half of screen, below Forecast.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     2 - BILMAX (ret) Maximum Left column line number.
 ;     3 - BIRMAX (ret) Maximum Right column line number.
 ;     4 - BIENT  (ret) Entry Number for LM selection in VALMY
 ;
 ;---> Check for BIDFN.
 Q:$$DFNCHECK^BIUTL2()
 ;
 ;---> Call RPC to retrieve Contraindications.
 ;     BIRETVAL - Return value of valid data from RPC.
 ;     BIRETERR - Return value (text string) of error from RPC.
 ;
 N BIRETVAL,BIRETERR S BIRETVAL=""
 ;
 ;---> RPC to retrieve Contraindications.
 D CONTRAS^BIRPC5(.BIRETVAL,BIDFN)
 ;
 ;---> If BIRETERR has a value, display it and quit.
 S BIRETERR=$P(BIRETVAL,BI31,2)
 I BIRETERR]"" D EN^DDIOL("* "_BIRETERR,"","!!?5"),DIRZ^BIUTL3() Q
 ;
 ;---> Set BICONT=to a string of Contraindications for this patient.
 N BICONT,BILINE S BICONT=$P(BIRETVAL,BI31,1)
 S BILINE=BIRMAX S:BILINE<1 BILINE=1
 ;
 ;---> Write Contraindications Header.
 D:BICONT]""
 .D RTCOL^BIPATVW1(.BILINE,,BIENT)
 .N X S X="-----------------------------------"
 .D RTCOL^BIPATVW1(.BILINE,X,BIENT)
 .D RTCOL^BIPATVW1(.BILINE,"   * CONTRAINDICATIONS/REFUSALS *",BIENT)
 .D RTCOL^BIPATVW1(.BILINE,,BIENT)
 ;
 ;---> Build Listmanager array from BICONT string.
 ;
 F I=1:1 S Y=$P(BICONT,U,I) Q:Y=""  D
 .;---> Build display line for this Contraindication.
 .N V S V="|"
 .;S X="  "_$P(Y,V,2)_":",X=$$PAD^BIUTL5(X,14)_$P(Y,V,3),X=$E(X,1,40)
 .S X="  "_$P(Y,V,2)_": "_$P(Y,V,3),X=$E(X,1,36)
 .;---> Set formatted Contraindication line and index in ^TMP.
 .D RTCOL^BIPATVW1(.BILINE,X,BIENT)
 ;
 ;---> Save maximum right column line number.
 S BIRMAX=BILINE
 Q
 ;
 ;
 ;----------
ADDINFO(BIDFN,BILINE,BIENT,BIDUZ2,BIFDT) ;EP
 ;---> Display Additional Information from Patient Edit screen.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     2 - BIRMAX (req) Last Line# (last node in ^TMP array).
 ;     3 - BIENT  (ret) Entry Number for LM selection in VALMY
 ;     5 - BIDUZ2 (req) DUZ(2) (for forecasting parameter display).
 ;     4 - BIFDT  (req) Forecast date (for High Risk display).
 ;
 ;---> Check for BIDFN.
 Q:$$DFNCHECK^BIUTL2()
 S:'$G(BIDUZ2) BIDUZ2=$G(DUZ(2))
 S:'$G(BIFDT) BIFDT=$G(DT)
 ;
 N X,Z S Z=BIENT
 D WRITE^BIPATVW1(.BILINE,,1,Z)
 D WRITE^BIPATVW1(.BILINE,"   ADDITIONAL PATIENT INFORMATION",,Z)
 D WRITE^BIPATVW1(.BILINE,"   ------------------------------",,Z)
 S X=$$DECEASED^BIUTL1(BIDFN,1)
 D:X
 .S X="   DECEASED on..........: "_$$TXDT1^BIUTL5(X)
 .D WRITE^BIPATVW1(.BILINE,X,,Z)
 I '$D(^BIP(BIDFN,0)) D  Q
 .S X="   This Patient is not in the Register."
 .D WRITE^BIPATVW1(.BILINE,X,1,Z)
 ;
 S X="   Case Manager.........: "_$$CMGR^BIUTL1(BIDFN,1)
 D WRITE^BIPATVW1(.BILINE,X,,Z)
 S X="   Designated Provider..: "_$$DPRV^BIUTL1(BIDFN,1)
 D WRITE^BIPATVW1(.BILINE,X,,Z)
 S X="   Parent/Guardian......: "_$$PARENT^BIUTL1(BIDFN)
 D WRITE^BIPATVW1(.BILINE,X,,Z)
 S X="   Current Community....: "_$$CURCOM^BIUTL11(BIDFN,1)
 D WRITE^BIPATVW1(.BILINE,X,,Z)
 S X="   Date First Entered...: "_$$ENTERED^BIUTL1(BIDFN,,1)
 S X=X_" ("_$$ENTERED^BIUTL1(BIDFN,1,1)_")"
 D WRITE^BIPATVW1(.BILINE,X,,Z)
 D
 .N Y S Y=$$INACT^BIUTL1(BIDFN,1)
 .Q:'Y
 .S X="   Inactive Date........: "_Y
 .I Z]"" S X=X_" (Reason: "_$$INACTRE^BIUTL1(BIDFN)_")"
 .D WRITE^BIPATVW1(.BILINE,X,,Z)
 .S X="   Made Inactive by.....: "_$$INACTUSR^BIUTL1(BIDFN)
 .D WRITE^BIPATVW1(.BILINE,X,,Z)
 ;
 S X=$$MOVEDLOC^BIUTL1(BIDFN)
 I X]"" S X="   Moved to/Tx Elsewhere: "_X D WRITE^BIPATVW1(.BILINE,X,,Z)
 S X="" D
 .Q:'$G(DT)  N BIRISKI,BIRISKP
 .D RISK^BIDX(BIDFN,BIFDT,0,.BIRISKI,.BIRISKP)
 .I BIRISKI S X="Influenza" I BIRISKP S X=X_" and "
 .I BIRISKP S X=X_"Pneumo"
 I X="" S X="None on record"
 S X="   High Risk Flu/Pneumo.: "_X
 S X=X_" (as of "_$$SLDT2^BIUTL5(BIFDT,1)_")"
 D WRITE^BIPATVW1(.BILINE,X,,Z)
 S X="   Forecast Flu/Pneumo..: "_$$INFL^BIUTL11(BIDFN,1)
 D WRITE^BIPATVW1(.BILINE,X,,Z)
 ;D:$G(BIDUZ2)  ;Uncomment to display Pneumo Site Parameter.
 ;.N X,Y,Z S X=$$PNMAGE^BIPATUP2(BIDUZ2)
 ;.S Y=$P(X,U),Z=$P(X,U,2)
 ;. X=Y_" years old, "_$S(Z:"every 6 years.",1:"one time only.")
 ;.S X="   Pneumo Site Parameter: Set at "_X
 ;.D WRITE^BIPATVW1(.BILINE,X,,Z)
 S X="   Mother's HBsAG Status: "_$$T^BITRS($$MOTHER^BIUTL11(BIDFN,1))
 D WRITE^BIPATVW1(.BILINE,X,,Z)
 S X=$$NEXTAPPT^BIUTL11(BIDFN)
 I ((X]"")&(X'="None")) S X="   Next Appointment.....: "_$E(X,1,54) D
 .D WRITE^BIPATVW1(.BILINE,X,,Z)
 D
 .N Y S Y=$$CONSENT^BIUTL1(BIDFN)
 .I Y=1 S X="Consented" Q
 .I Y=0 S X="Declined" Q
 .S X="Unknown"
 S X="   State Registry.......: "_X
 D WRITE^BIPATVW1(.BILINE,X,,Z)
 S X="   Other Information....: "_$$OTHERIN^BIUTL11(BIDFN)
 D WRITE^BIPATVW1(.BILINE,X,,Z)
 D WRITE^BIPATVW1(.BILINE,,,Z)
 Q
 ;
 ;
 ;----------
HELP ;EP
 ;----> Explanation of this report.
 N BITEXT D TEXT1(.BITEXT)
 D START^BIHELP("PATIENT VIEW SCREEN - HELP",.BITEXT)
 Q
 ;
 ;
 ;----------
TEXT1(BITEXT) ;EP
 ;;
 ;;This is the main Patient View Screen, the single point from
 ;;which you manage all of an individual patient's immunization data.
 ;;
 ;;The screen is divided horizontally into THREE SECTIONS:
 ;;
 ;;The TOP third of the screen lists the patient's demographic information,
 ;;most of which is edited through the RPMS Patient Registration.
 ;;
 ;;The MIDDLE third of the screen is subdivided into LEFT and RIGHT Columns:
 ;;
 ;;   The LEFT column lists the Patient's Immunization and Skin Test
 ;;   history, including adverse reactions.
 ;;
 ;;   The RIGHT column lists the patient's Immunizations Due, date of last
 ;;   letter sent to the patient, and any contraindications.
 ;;
 ;;The BOTTOM third of the screen lists Actions you can take to add or edit
 ;;the patient's immunization data, or to display other relevant patient
 ;;information.
 ;;
 ;;For many patients, there is more information than can be displayed
 ;;in the middle section of the screen.  To view all of the information
 ;;on a Patient's Immunization History it may be necessary to use the
 ;;"arrow keys" to scroll up and down.
 ;;
 ;;The Actions at the bottom of the screen are:
 ;;
 ;;  A  Add Immunization  - to add a new immunization
 ;;  D  Delete Visit      - to delete an immunization
 ;;  P  Patient Edit      - to edit patient guardian, inactive date, etc.
 ;;  S  Skin Test Add     - to add a skin test
 ;;  I  ImmServe Profile  - to view details of the forecast
 ;;  C  Contraindications - to add/edit/delete contraindications
 ;;  E  Edit Visit        - to change data of an immunization
 ;;  H  Health Summary    - to view the patient's Health Summary
 ;;  L  Letter Print      - to select and print a patient letter
 ;;
 ;;
 ;;There are also Hidden Actions, which you can review by typing ??
 ;;at the "Select Action:" prompt.  If you entered ??, the Hidden
 ;;Actions will be displayed in a list after this text.  Any of the
 ;;Hidden Actions can be executed by typing their names or synonyms
 ;;at the "Select Action:" prompt, just as with the primary Actions.
 ;;
 ;;NOTE! There are two ways to print a patient's Immunization History:
 ;;
 ;;      1) At the Select Action prompt enter "PL" or "Print List".
 ;;         This action will print or queue the entire Patient View Screen
 ;;         as it appears on your screen.
 ;;
 ;;  or  2) Enter "L" or "Letter Print" and select the "Official
 ;;         Immunization Record" for the form letter to print.
 ;;
 D LOADTX("TEXT1",,.BITEXT)
 Q
 ;
 ;
 ;----------
LOADTX(BILINL,BITAB,BITEXT) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  S BITEXT(I)=T_$P(X,";;",2)
 Q
