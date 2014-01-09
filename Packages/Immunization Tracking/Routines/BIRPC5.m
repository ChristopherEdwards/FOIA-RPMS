BIRPC5 ;IHS/CMI/MWR - REMOTE PROCEDURE CALLS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**2**;MAY 15,2012
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  RETURN IMMUNIZATION CONTRAINDICATIONS, CASE DATA, AND LAST LETTER.
 ;   PATCH 2: New Public Entry Point to automatically add Lot Number.  ADDLOT+0
 ;
 ;
 ;----------
CONTRAS(BICONTR,BIDFN) ;PEP - Return Patient's Contraindications and their Reasons.
 ;---> Return Patient's Contraindications and their Reasons.
 ;---> Contraindications returned in one string, delimited by "^".
 ;---> Each Contra has 3 "|" pieces: Vaccine Name|Reason|Date Entered.
 ;---> Parameters:
 ;     1 - BICONTR (ret) String of patient's Contraindications_||_Error.
 ;     2 - BIDFN   (req) DFN of patient.
 ;
 ;---> Delimiter to pass error with result to GUI.
 N BI31,BIERR,U,V S BI31=$C(31)_$C(31),U="^",V="|"
 S BICONTR="",BIERR=""
 ;
 ;---> If DFN not provided, set Error Code and quit.
 I '$G(BIDFN) D  Q
 .D ERRCD^BIUTL2(308,.BIERR) S BICONTR=BI31_BIERR
 ;
 N N,X S N=0,X=""
 F  S N=$O(^BIPC("B",BIDFN,N)) Q:'N  D
 .;
 .;---> Kill any false xref.
 .I '$D(^BIPC(N,0)) K ^BIPC("B",BIDFN,N) Q
 .;
 .N Y S Y=^BIPC(N,0)
 .;---> Get Contraindication:
 .;---> IEN of Contraindication, Vaccine Short Name, Reason, Date.
 .S X=X_N_V_$$VNAME^BIUTL2($P(Y,U,2))_V_$$CONTXT^BIUTL6($P(Y,U,3))
 .S X=X_V_$$TXDT1^BIUTL5($P(Y,U,4))_U
 ;
 S BICONTR=X_BI31
 Q
 ;
 ;
 ;----------
CASEDAT(BICASED,BIDFN) ;PEP - Return Patient's Case Data, pieces delimited by "^".
 ;---> Parameters:
 ;     1 - BICASED (ret) String of Patient's Case Data_||_Error.
 ;     2 - BIDFN   (req) DFN of patient.
 ;
 ;---> Delimiter to pass error with result to GUI.
 N BI31,BIERR,U S BI31=$C(31)_$C(31),U="^"
 S BICASED="",BIERR=""
 ;
 ;---> If DFN not provided, set Error Code and quit.
 I '$G(BIDFN) D  Q
 .D ERRCD^BIUTL2(206,.BIERR) S BICASED=BI31_BIERR
 ;
 ;---> If Patient not in Immunization database, set Error Code and quit.
 I '$D(^BIP(BIDFN,0)) D  Q
 .D ERRCD^BIUTL2(204,.BIERR) S BICASED=BI31_BIERR
 ;
 ;---> Case Data Elements returned as follows:
 ;
 ;--->  PC  DATA
 ;--->  --  ----
 ;--->   1 = Text of Case Manager's name.
 ;--->   2 = Text of Parent or Guardian in Immunization database.
 ;--->   3 = Mother's HBsAG Status Code (P,N,A,U).
 ;--->   4 = Date Patient became Inactive (DD-Mmm-YYYY).
 ;--->   5 = Reason for Inactive.
 ;--->   6 = Other Info.
 ;--->   7 = Forecast Influenza/Pneumococcal.
 ;--->   8 = Location Moved or Tx Elsewhere.
 ;--->   9 = State Registry Consent.
 ;
 N X
 S X=$$CMGR^BIUTL1(BIDFN,1) S:X="Unknown" X=""
 S X=X_U_$$PARENT^BIUTL1(BIDFN)
 S X=X_U_$$MOTHER^BIUTL11(BIDFN)
 S Z=$$TXDT1^BIUTL5($$INACT^BIUTL1(BIDFN)) S:Z="NO DATE" Z=""
 S X=X_U_Z
 S X=X_U_$$INACTRE^BIUTL1(BIDFN)_U_$$OTHERIN^BIUTL11(BIDFN)
 S X=X_U_$$INFL^BIUTL11(BIDFN)
 S X=X_U_$$MOVEDLOC^BIUTL1(BIDFN)
 S X=X_U_$$CONSENT^BIUTL1(BIDFN)
 ;
 S BICASED=X_BI31
 Q
 ;
 ;
 ;----------
LASTLET(BILASTL,BIDFN) ;EP
 ;---> Return date of last letter sent to this patient.
 ;---> Parameters:
 ;     1 - BILASTL (ret) Date of last letter_||_Error.
 ;     2 - BIDFN   (req) DFN of patient.
 ;
 ;---> Delimiter to pass error with result to GUI.
 N BI31,BIERR,U S BI31=$C(31)_$C(31),U="^"
 S BILASTL="",BIERR=""
 ;
 ;---> If DFN not provided, set Error Code and quit.
 I '$G(BIDFN) D  Q
 .D ERRCD^BIUTL2(201,.BIERR) S BILASTL=BI31_BIERR
 ;
 ;---> Last Letter Elements returned as follows:
 ;
 ;--->  PC  DATA
 ;--->  --  ----
 ;--->   1 = Date of last letter (DD-Mmm-YYYY) or "None".
 ;
 S BILASTL=$$LASTLET^BIUTL1(BIDFN,1)_BI31
 Q
 ;
 ;********** PATCH 2, v8.5, MAY 15,2012, IHS/CMI/MWR
 ;---> New Public Entry Point to automatically add Lot Number.
 ;
 ;
 ;----------
ADDLOT(BIERR,BIDATA,BIIEN) ;PEP - Add a new Lot Number for imported data.
 ;---> Add new (imported) Lot Number to the IMMUNIZATION LOT File #9999999.41.
 ;---> Called by RPC: BI LOT NUMBER ADD.
 ;---> Parameters:
 ;     1 - BIERR   (ret) Text of Error Code if any, otherwise null.
 ;     2 - BIDATA  (req) String of data for the Lot Number to be added.
 ;     3 - BIIEN   (ret) IEN of newly added Lot Number in ^AUTTIML(.
 ;                       NOTE: If Lot Number already exists, BIERR will return
 ;                             error #444, but BIIEN will be returned with IEN
 ;                             pre-existing Lot Number.
 ;
 ;---> Pieces of BIDATA delimited by "|":
 ;     ----------------------------------
 ;     1 - (req) Text of the Lot Number.
 ;     2 - (req) CVX Code of the Vaccine associated with this Lot Number.
 ;     3 - (req) MVX Code of the Manufacturer associated with this Lot Number.
 ;
 ;---> Define delimiter to pass error and error variable.
 N BI31
 S BI31=$C(31)_$C(31),BIERR=""
 ;
 ;---> If DATA not supplied, set Error Code and quit.
 I $G(BIDATA)']"" D  Q
 .D ERRCD^BIUTL2(442,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> Set data values in BI local array.
 N BI
 S BI("AS")=$P(BIDATA,"|",1)   ;Full Lot Number Text.
 S BI("B")=$P(BIDATA,"|",2)    ;CVX Code of Vaccine.
 S BI("M")=$P(BIDATA,"|",3)    ;MVX Code of Manufacturer.
 ;
 ;---> If Lot Number="", quit with error.
 I 'BI("AS")']"" D  Q
 .D ERRCD^BIUTL2(442,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> If Lot Number is too long, quit with error.
 I $L(BI("AS"))>19 D  Q
 .D ERRCD^BIUTL2(443,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> If Lot Number already exists, set BIIEN=IEN, BUT quit with error.
 I $D(^AUTTIML("B",BI("AS"))) D  Q
 .N Y S Y=$O(^AUTTIML("B",BI("AS"),0))
 .I $P($G(^AUTTIML(Y,0)),U)=BI("AS") S BIIEN=Y
 .D ERRCD^BIUTL2(444,.BIERR) S BIERR=BI31_BIERR
 ;
 ;
 ;---> S BI("B")=IEN of Vaccine.
 S BI("B")=$O(^AUTTIMM("C",+$G(BI("B")),0))
 ;---> If CVX Code is invalid, quit with error.
 I 'BI("B") D  Q
 .D ERRCD^BIUTL2(445,.BIERR) S BIERR=BI31_BIERR
 ;
 ;
 ;---> S BI("M")=IEN of Manufacturer.
 ;---> If MVX Code is invalid, quit with error.
 I BI("M")="" D  Q
 .D ERRCD^BIUTL2(446,.BIERR) S BIERR=BI31_BIERR
 S BI("M")=$O(^AUTTIMAN("C",BI("M"),0))
 I BI("M")="" D  Q
 .D ERRCD^BIUTL2(446,.BIERR) S BIERR=BI31_BIERR
 ;
 ;
 ;---> Build local array for this Lot Number.
 S BIFLD(.01)=$G(BI("AS")),BIFLD(.02)=$G(BI("M"))
 ;---> Imported Lot Number will have a Status of Inactive.
 S BIFLD(.03)=1,BIFLD(.04)=$G(BI("B"))
 ;
 ;---> Add the Lot Number.  BIIEN1(1) will equal IEN of newly added Lot Number.
 N BIIEN1
 D UPDATE^BIFMAN(9999999.41,.BIIEN1,.BIFLD,.BIERR)
 ;
 ;---> If there was an error, return it.
 S BIERR=BI31_BIERR
 ;
 ;---> Return BIIEN.
 S BIIEN=$G(BIIEN1(1))
 ;
 ;---> Check IEN.
 I $P($G(^AUTTIML(+BIIEN,0)),U)'=BI("AS") D  Q
 .D ERRCD^BIUTL2(447,.BIERR) S BIERR=BI31_BIERR
 ;
 Q
