BIRPC4 ;IHS/CMI/MWR - REMOTE PROCEDURE CALLS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  ADD AND DELETE CONTRAINDICATIONS, EDIT PATIENT CASE DATA.
 ;
 ;
 ;----------
ADDCONT(BIERR,BIDATA) ;PEP - Add a Contraindication.
 ;---> Add Contraindication for a patient.
 ;---> Called by RPC: BI CONTRAINDICATION ADD.
 ;---> Parameters:
 ;     1 - BIERR  (ret) Text of Error Code if any, otherwise null.
 ;     2 - BIDATA (req) String of data for the Contraindication to be added.
 ;                      Data elements are parsed by "|" as follows:
 ;                      Patient IEN|Vaccine IEN|Contra Reason IEN|Date Noted|Edit Flag
 ;
 ;---> Define delimiter to pass error and error variable.
 N BI31 S BI31=$C(31)_$C(31),BIERR=""
 ;
 ;---> If BIDATA not supplied, set Error Code and quit.
 I $G(BIDATA)']"" D  Q
 .D ERRCD^BIUTL2(416,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> Break out BIDATA into pieces.
 N BICRIEN,BIDATE,BIDFN,BIEDIT,BIMDEF,BIVIEN
 S BIDFN=$P(BIDATA,"|",1)   ;Patient DFN.
 S BIVIEN=$P(BIDATA,"|",2)  ;Vaccine IEN.
 S BICRIEN=$P(BIDATA,"|",3) ;Contraindication Reason IEN.
 S BIDATE=$P(BIDATA,"|",4)  ;Date Noted.
 S BIEDIT=$P(BIDATA,"|",5)  ;If BIEDIT=1, this is an Edit.
 ;
 ;---> If valid Patient DFN not provided, set Error Code and quit.
 I ('BIDFN)!('$D(^AUPNPAT(BIDFN,0))) D  Q
 .D ERRCD^BIUTL2(417,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> If valid Vaccine IEN not provided, set Error Code and quit.
 I ('BIVIEN)!('$D(^AUTTIMM(BIVIEN,0))) D  Q
 .D ERRCD^BIUTL2(418,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> If IEN for Contra Reason is not valid, set Error Code and quit.
 I BICRIEN I '$D(^BICONT(BICRIEN,0)) D  Q
 .D ERRCD^BIUTL2(419,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> Check if Contra already exists for this reason; quit if duplicate.
 N BIQUIT,N,X S BIQUIT=0
 I '$G(BIEDIT) D
 .S X=BIDFN_"^"_BIVIEN_"^"_BICRIEN
 .S N=0
 .F  S N=$O(^BIPC("B",BIDFN,N)) Q:'N  Q:BIQUIT  D
 ..I $P(^BIPC(N,0),U,1,3)=X S BIQUIT=1 D  Q
 ...D ERRCD^BIUTL2(439,.BIERR) S BIERR=BI31_BIERR
 Q:BIQUIT
 ;
 ;---> If this patient is Immune Deficient, use BIMDEF array below
 ;---> to add other live vaccines as contraindicated.
 I $P($G(^BICONT(+BICRIEN,0)),U)="Immune Deficiency" D
 .S BIMDEF("C")=BICRIEN,BIMDEF("D")=BIDATE
 ;
 ;---> Add Contraindication.
 N BIERR,BIFLD
 S BIFLD(.01)=BIDFN,BIFLD(.02)=BIVIEN,BIFLD(.03)=BICRIEN,BIFLD(.04)=BIDATE
 D UPDATE^BIFMAN(9002084.11,,.BIFLD,.BIERR)
 ;
 ;---> If add contraindication fails, set Error Code and quit.
 I $G(BIERR)]"" D  Q
 .N X S X=BIERR
 .D ERRCD^BIUTL2(420,.BIERR) S BIERR=BI31_BIERR_" "_X
 ;
 ;---> If this is a Refusal, add it to PATIENT REFUSALS FOR SERVICE/NMI
 ;---> File #9000022.
 D:((BICRIEN=11)!(BICRIEN=16))
 .N BIREFI S BIREFI=$$VNAME^BIUTL2(BIVIEN)_" - "_$$CONTXT^BIUTL6(BICRIEN)
 .D REFUSAL("IMMUNIZATION",BIDFN,BIDATE,BIREFI,9999999.14,BIVIEN,"R",$G(DUZ))
 ;
 ;
 ;---> Add Adverse Reaction to ART Package.
 ;---> Sept 2005: Not possible at this time.
 I (BICRIEN=4)!(BICRIEN=8)!(BICRIEN=9) D
 .;SEND EVENT(?) TO ART PACKAGE.
 ;
 ;---> Quit if this patient is not Immune Deficient.
 Q:'$D(BIMDEF)
 ;
 ;---> Patient is Immune Deficient, so add MMR, Varicella, & Flu-Nasal
 ;---> contraindications.
 ;---> Imm v8.5: added all Rotavirus, per Ros.
 N BIHL7
 F BIHL7=3,21,111,74,116,119,122 D
 .N BIIEN,DR S BIIEN=$$HL7TX^BIUTL2(BIHL7)
 .;
 .N BIADD,N S N=0,BIADD=1
 .;---> Loop through patient's existing contraindications.
 .F  S N=$O(^BIPC("B",BIDFN,N)) Q:'N  Q:'BIADD  D
 ..N X S X=$G(^BIPC(N,0))
 ..Q:'X
 ..;---> Quit (BIADD=0) if this contra & reason already exists.
 ..I $P(X,U,2)=BIIEN&($P(X,U,3)=BIMDEF("C")) S BIADD=0
 .Q:'BIADD
 .;
 .;---> Add contraindication with a reason of Immune Deficiency.
 .N BIERR,BIFLD
 .S BIFLD(.01)=BIDFN,BIFLD(.02)=BIIEN
 .S BIFLD(.03)=BIMDEF("C"),BIFLD(.04)=BIMDEF("D")
 .D UPDATE^BIFMAN(9002084.11,,.BIFLD,.BIERR)
 Q
 ;
 ;
 ;----------
DELCONT(BIERR,BICIEN) ;PEP - Add a Contraindication.
 ;---> Delete a Contraindication.
 ;---> Called by RPC: BI CONTRAINDICATION DELETE.
 ;---> Parameters:
 ;     1 - BIERR  (ret) Text of Error Code if any, otherwise null.
 ;     2 - BICIEN (req) IEN of BI CONTRAINDICATION to be deleted.
 ;
 ;---> Define delimiter to pass error and error variable.
 N BI31 S BI31=$C(31)_$C(31),BIERR=""
 ;
 ;---> If DA not supplied, set Error Code and quit.
 I '$G(BICIEN) D  Q
 .D ERRCD^BIUTL2(414,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> Delete BI CONTRAINDICATION entry.
 N DA,DIK S DA=BICIEN,DIK="^BIPC("
 D ^DIK
 Q
 ;
 ;
 ;----------
EDITCAS(BIERR,BIDATA) ;EP
 ;---> Edit a Patient's Case Data.
 ;---> Called by RPC: BI ?
 ;---> Parameters:
 ;     1 - BIERR   (ret) Text of Error Code if any, otherwise null.
 ;     2 - BIDATA  (req) String of Patient's Case Data to be edited.
 ;
 ;---> Define delimiter to pass error and error variable.
 N BI31,U S BI31=$C(31)_$C(31),BIERR="",U="^"
 ;
 ;---> If BIDATA not supplied, set Error Code and quit.
 I $G(BIDATA)']"" D  Q
 .D ERRCD^BIUTL2(207,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> Break out BIDATA into pieces.
 N A,B,C,D,E,F,G,H,I,J
 S A=$P(BIDATA,U,1)    ;Patient DFN.
 S B=$P(BIDATA,U,2)    ;IEN of Case Manager.
 S C=$P(BIDATA,U,3)    ;Parent or Guardian, text.
 S D=$P(BIDATA,U,4)    ;Mother's HBsAG Status (P,N,A,U).
 S E=$P(BIDATA,U,5)    ;Date Patient became Inactive (external format).
 S F=$P(BIDATA,U,6)    ;Reason for Inactive.
 S G=$P(BIDATA,U,7)    ;Other Info.
 S H=$P(BIDATA,U,8)    ;Forecast Influ/Pneumo.
 S I=$P(BIDATA,U,9)    ;Location Moved or Tx Elsewhere.
 S J=$P(BIDATA,U,10)   ;IEN of User who Inactivated this patient.
 S K=$P(BIDATA,U,11)   ;Consent State Registry.
 ;
 ;---> If valid Patient DFN not provided, set Error Code and quit.
 I ('A)!('$D(^BIP(+A,0))) D  Q
 .D ERRCD^BIUTL2(206,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> If Case Manager is null (possibly deleted), send @ to delete.
 S:'B B="@"
 ;
 ;---> If valid Case Manager IEN not provided, set Error Code and quit.
 I B&('$D(^BIMGR(+B,0))) D  Q
 .D ERRCD^BIUTL2(208,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> If Case Manager is INACTIVE, set Error Code and quit.
 I B,$$CMGRACT^BIUTL2(B) D  Q
 .D ERRCD^BIUTL2(213,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> If Inactive Date was set but no Reason given, set Error Code and quit.
 I (E]"")&(F="") D  Q
 .D ERRCD^BIUTL2(219,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> If Parent or Guardian="" or was deleted, set C="@" to delete.
 S:C="" C="@" S C=$$TR(.C)
 ;
 ;---> If Mother's HGsAG Status not valid, set to null.
 S:"PANU"'[D D=""
 ;
 ;---> If Inactive Date is null (possibly deleted), send @ to delete.
 ;---> If Date is valid, convert to Fileman format.
 D
 .I E="" S E="@" Q
 .N %DT,X,Y S X=E
 .D ^%DT S E=Y
 ;
 ;---> If Inactive Date=@, set Reason for Inactive and Inactivated by User
 ;---> both ="" (E,F="" to delete).
 S:(E="@"!(F="")) (F,J)="" S F=$$TR(.F)
 ;
 ;---> If Date is invalid, set Error Code and quit.
 I E=-1 D  Q
 .D ERRCD^BIUTL2(209,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> If Other Info="" or was deleted, set G="@" to delete.
 S:G="" G="@" S G=$$TR(.G)
 ;
 ;---> If Forecast Influ/Pneumo is not valid, set to null.
 S:"01234"'[H H="" S:H="" H="@"
 ;
 ;---> Build FDA field=value array.
 N BIFLD
 S BIFLD(.08)=E
 S BIFLD(.09)=C
 S BIFLD(.1)=B
 S BIFLD(.11)=D
 S BIFLD(.12)=I
 S BIFLD(.13)=G
 S BIFLD(.15)=H
 S BIFLD(.16)=F
 S BIFLD(.23)=J
 S BIFLD(.24)=K
 ;
 ;---> Store edit data.
 D FDIE^BIFMAN(9002084,+A,.BIFLD,.BIERR)
 S:BIERR["" BIERR=BI31_BIERR
 Q
 ;
 ;
 ;----------
REFUSAL(BIREFT,BIDFN,BIDATE,BIREFI,BIREFF,BIREFV,BIREFR,BIPROV,BIERR) ;EP
 ;---> Add a Refusal to the PATIENT REFUSALS FOR SERVICE/NMI File #9000022.
 ;---> Parameters:
 ;     1 - BIREFT (req) Text of Refusal Type in REFUSAL TYPE File #9999999.73.
 ;     2 - BIDFN  (req) Patient DFN, .02.
 ;     3 - BIDATE (req) Date (Fman) refused or not indicated, .03.
 ;     4 - BIREFI (req) Refusal Item (80 characters of free text), .04.
 ;     5 - BIREFF (req) Pointer file (Immunization #9999999.14), .05
 ;     6 - BIREFV (req) Pointer Value (IEN of vaccine in #9999999.14), .06
 ;     7 - BIREFR (opt) Reason for Refusal (set of codes), .07
 ;     8 - BIPROV (opt) Provider IEN, 1204,
 ;     9 - BIERR  (ret) Text of Error Code if any, otherwise null.
 ;
 N BIREFT1 S BIREFT1=$O(^AUTTREFT("B",BIREFT,0))
 ;---> Quit if there isn't a good pointer to the Refusal Type file.
 I 'BIREFT1 D ERRCD^BIUTL2(440,.BIERR) Q
 ;
 ;---> First check for duplicate refusal already on file.
 N BIFLD,BIQUIT,N,X S BIQUIT=0
 S X=BIREFT1_"^"_BIDFN_"^"_BIDATE_"^"_BIREFI
 S N=0
 F  S N=$O(^AUPNPREF("AC",BIDFN,N)) Q:'N  Q:BIQUIT  D
 .I $P(^AUPNPREF(N,0),U,1,4)=X S BIQUIT=1 Q
 Q:BIQUIT
 ;
 ;---> Okay, no duplicates; store this in Patient Refusals file.
 ;
 S BIFLD(.01)=BIREFT1,BIFLD(.02)=BIDFN,BIFLD(.03)=BIDATE,BIFLD(.04)=BIREFI
 S BIFLD(.05)=BIREFF,BIFLD(.06)=BIREFV,BIFLD(.07)=BIREFR,BIFLD(1204)=BIPROV
 D UPDATE^BIFMAN(9000022,,.BIFLD,.BIERR)
 Q
 ;
 ;
 ;----------
TR(X) ;EP
 ;---> Translate any ";" to ",", so that DR string will parse
 ;---> correctly.
 ;---> Parameters:
 ;     1 - X   (req) String to be scanned for ";".
 ;
 S X=$TR($G(X),";",",")
 Q X
