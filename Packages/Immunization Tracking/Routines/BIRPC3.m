BIRPC3 ;IHS/CMI/MWR - REMOTE PROCEDURE CALLS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  ADD/EDIT A VISIT (IMMUNIZATION OR SKIN TEST), DELETE A VISIT.
 ;;  Check validity of data in several fields.
 ;
 ;----------
ADDEDIT(BIERR,BIDATA) ;PEP - Add/Edit an V IMMUNIZATION or V SKIN TEST.
 ;---> Add/Edit an V IMMUNIZATION or V SKIN TEST.
 ;---> Called by RPC: BI VISIT ADD/EDIT.
 ;---> Parameters:
 ;     1 - BIERR   (ret) Text of Error Code if any, otherwise null.
 ;     2 - BIDATA  (req) String of data for the Visit to be added.
 ;
 ;---> Pieces of BIDATA delimited by "|":
 ;     ----------------------------------
 ;     1 - (req) "I"=Immunization Visit, "S"=Skin Text Visit.
 ;     2 - (req) DFN of patient.
 ;     3 - (req) Vaccine or Skin Test .01 pointer.
 ;     4 - (opt) Dose# number for this Immunization (NO LONGER USED).
 ;     5 - (opt) Lot number IEN for this Immunization.
 ;     6 - (req) Date.Time of Visit.
 ;     7 - (req) Location of encounter IEN.
 ;     8 - (opt) Other Location of encounter.
 ;     9 - (req) Category: A (Ambul), I (Inpat), E (Event/Hist)
 ;    10 - (opt) Visit IEN.
 ;    11 - (opt) Old V File IEN (for edits).
 ;    12 - (req) Skin Test Result: P,N,D,O.
 ;    13 - (req) Skin Test Reading: 0-40.
 ;    14 - (req) Skin Test Date Read.
 ;    15 - (opt) Vaccine Reaction.
 ;    16 - (opt) VFC Eligibility.  vvv83
 ;    17 - (opt) Release/Revision Date of VIS.
 ;    18 - (opt) IEN of Provider of Immunization/Skin Test.
 ;    19 - (opt) Dose Override.
 ;    20 - (opt) Injection Site.
 ;    21 - (opt) Volume.
 ;    22 - (opt) IEN of Reader (Provider) of Skin Test.
 ;    23 - (req) DUZ(2) for Site Parameters.
 ;    23 - (opt) If this was an imported CPT Coded Imm from PCC (=IEN of V CPT).
 ;    25 - (opt) If this =1, then imported (IF =2, then was edited after import).
 ;    26 - (opt) NDC pointer IEN (to file #9002084.95).
 ;
 ;---> Define delimiter to pass error and error variable.
 N BI31,BIDUZ2,BIOIEN
 S BI31=$C(31)_$C(31),BIERR=""
 ;
 ;---> If this is an edit of an old Visit, preserve IEN of old V File entry.
 S BIOIEN=$P(BIDATA,"|",11)
 ;
 ;---> If DATA not supplied, set Error Code and quit.
 I $G(BIDATA)']"" D  Q
 .D ERRCD^BIUTL2(403,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> Get Site IEN (passed DUZ(2)) for Site Parameters.
 S BIDUZ2=$P(BIDATA,"|",23)
 ;---> If no Site IEN was passed, try to get it from local symbol table.
 S:'BIDUZ2 (BIDUZ2,$P(BIDATA,"|",23))=$G(DUZ(2))
 ;--> If still no Site IEN, error out.
 I '$G(BIDUZ2) D ERRCD^BIUTL2(121,.BIERR) S BIERR=BI31_BIERR Q
 ;
 ;---> Check for valid Patient.
 N BIDFN S BIDFN=$P(BIDATA,"|",2)
 I '$G(^AUPNPAT(+BIDFN,0)) D  Q
 .D ERRCD^BIUTL2(217,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> Visit Type: "I"=Immunization Visit, "S"=Skin Text Visit.
 ;---> If BIVTYPE does not="I" (Immunization Visit) and it does
 ;---> not="S" (Skin Test Visit), then set Error Code and quit.
 N BIVTYPE S BIVTYPE=$P(BIDATA,"|",1)
 I ($G(BIVTYPE)'="I")&($G(BIVTYPE)'="S") D  Q
 .D ERRCD^BIUTL2(410,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> If this is an Immunization Visit and the Vaccine Table
 ;---> not standard, set Error Code and quit.
 I (BIVTYPE="I")&($D(^BISITE(-1))) D  Q
 .D ERRCD^BIUTL2(503,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> If this Visit (new or edited) will be a duplicate, set error
 ;---> and quit.
 D DUPTEST^BIUTL8(.BIERR,BIDATA,$G(BIOIEN))
 Q:BIERR]""
 ;
 ;---> Reformat dates to Fileman Internal format.
 D
 .N I F I=6,14,17 D
 ..N X S X=$P(BIDATA,"|",I)
 ..D DT^DILF("PT",X,.X)
 ..S $P(BIDATA,"|",I)=X
 ;
 ;---> If Visit Date is before Patient's DOB, set Error Code and quit.
 I $P(BIDATA,"|",6)<$$DOB^BIUTL1($P(BIDATA,"|",2)) D  Q
 .D ERRCD^BIUTL2(422,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> Set Lot# and Category.
 N BILOT S BILOT=$P(BIDATA,"|",5)
 N BICAT S BICAT=$P(BIDATA,"|",9)
 ;
 ;---> If this is an Immunization, check for valid.
 D:BIVTYPE="I"  Q:$G(BIERR)]""
 .N BIVAC S BIVAC=$P(BIDATA,"|",3)
 .;
 .;---> If Vaccine not provided, set Error and quit.
 .I '$G(BIVAC) D  Q
 ..D ERRCD^BIUTL2(502,.BIERR) S BIERR=BI31_BIERR
 .;
 .;---> If Vaccine does not exist, set Error and quit.
 .I '$D(^AUTTIMM(BIVAC,0)) D  Q
 ..D ERRCD^BIUTL2(430,.BIERR) S BIERR=BI31_BIERR
 .;
 .;---> If the Vaccine is INACTIVE and Category is NOT "Historical Event"
 .;---> set Error Code and quit.
 .I $P(^AUTTIMM(BIVAC,0),U,7)&(BICAT'="E") D  Q
 ..D ERRCD^BIUTL2(429,.BIERR) S BIERR=BI31_BIERR
 .;
 .;********** PATCH 1, v8.2.1, FEB 01,2008, IHS/CMI/MWR
 .;---> Use new call, LOTCHK, to check validity of Lot Number.
 .;---> If Lot# is required and one was not passed, set Error and quit.
 .;---> (If Category is Historical Event, Lot# not required.)
 .I $$LOTREQ^BIUTL2(BIDUZ2)&(BILOT="")&(BICAT'="E") D  Q
 ..D ERRCD^BIUTL2(431,.BIERR) S BIERR=BI31_BIERR
 .;
 .;---> If Lot Number was passed, check it.
 .D:BILOT  Q:$G(BIERR)]""
 ..D LOTCHK(BILOT,BIVAC,.BIERR)
 ..I $G(BIERR)]"" S BIERR=BI31_BIERR
 ;
 ;---> If this is a Skin Test, Category is NOT Historical, and it has a Result,
 ;---> then check for Reading in mm.
 I BIVTYPE="S",BICAT'="E",$P(BIDATA,"|",12)]"",$P(BIDATA,"|",13)="" D  Q
 .D ERRCD^BIUTL2(436,.BIERR) S BIERR=BI31_BIERR
 ;
 ;***********
 ;
 ;---> Add Visit.
 D ADDV^BIVISIT(.BIERR,BIDATA)
 ;
 ;---> If add Visit fails, then return error and quit;
 ;---> do NOT delete the old Visit.
 I BIERR S BIERR=BI31_$P(BIERR,U,2) Q
 ;
 ;---> If this is an Edit of an old Visit, then DELETE the old V File entry.
 I $G(BIOIEN) D DELETE(.BIERR,BIOIEN,BIVTYPE) Q
 ;
 ;---> Since this was a New Visit (not an Edit), decrement the Lot Total.
 I $G(BILOT) D LOTDECR(BILOT)
 ;
 Q
 ;
 ;
 ;----------
LOTDECR(BILOT) ;PEP - Decrement Lot Total for a given Lot Number.
 ;---> Parameters:
 ;     1 - BILOT  (req) Lot Number IEN for this Immunization.
 ;
 Q:'$G(BILOT)  Q:'$D(^AUTTIML(BILOT,0))
 N X,Y,Z S X=^AUTTIML(BILOT,0),Y=$P(X,U,11),Z=$P(X,U,12)
 ;---> Quit if no Starting Amount (i.e., not tracked).
 Q:Y=""
 ;---> Okay, decrement Number Unused by 1.
 S $P(^AUTTIML(BILOT,0),U,12)=Z-1
 ;
 Q
 ;
 ;
 ;----------
LOTRBAL(BILIEN) ;PEP - Return Remaining Balance (Starting Total - Number Used).
 ;---> Parameters:
 ;     1 - BILIEN (req) Lot Number IEN for this Immunization.
 ;
 N BIERR
 I '$G(BILIEN) D ERRCD^BIUTL2(511,.BIERR) Q BIERR
 I '$D(^AUTTIML(BILIEN,0)) D ERRCD^BIUTL2(512,.BIERR) Q BIERR
 N X,Y,Z S X=^AUTTIML(BILIEN,0),Y=$P(X,U,11),Z=$P(X,U,12)
 Q:(Y="") "Not tracked"
 Q +Z
 ;
 ;
 ;----------
LOTEXP(BILIEN,BIYY) ;PEP - Return Lot Expiration Date in format: MM/DD/YYYY.
 ;---> Parameters:
 ;     1 - BILIEN (req) Lot Number IEN for this Immunization.
 ;     2 - BIYY   (opt) If BIYY=1, return 2-digit year: MM/DD/YY.
 ;                      If BIYY=2, return Fileman format of date.
 ;
 I '$G(BILIEN) D ERRCD^BIUTL2(511,.BIERR) Q BIERR
 I '$D(^AUTTIML(BILIEN,0)) D ERRCD^BIUTL2(512,.BIERR) Q BIERR
 N BIDATE S BIDATE=$P(^AUTTIML(BILIEN,0),U,9)
 Q:($G(BIYY)=2) BIDATE
 Q $$SLDT2^BIUTL5(BIDATE,$G(BIYY))
 ;
 ;
 ;********** PATCH 1, v8.2.1, FEB 01,2008, IHS/CMI/MWR
 ;---> New LOTCHK subroutine to combine all checks for valid Lot Number.
 ;----------
LOTCHK(BILOT,BIVAC,BIERR) ;EP
 ;---> Check for valid Lot Number given the Vaccine passed.
 ;---> Parameters:
 ;     1 - BILOT (req) IEN of Lot Number.
 ;     2 - BIVAC (req) IEN of Vaccine IMMUNIZATION File (9999999.14).
 ;     3 - BIERR (ret) Text of Error Code if any, otherwise null.
 ;
 ;---> Check a) Valid Vaccine and Lot Number
 ;--->       b) Lot Number has been assigned to the Vaccine passed;
 ;--->       b) Lot Number is Active
 ;--->       c) Lot Number does not have duplicates
 ;
 S BIERR=""
 ;
 ;---> If Lot# IEN not passed, set Error and quit.
 I '$G(BILOT) D ERRCD^BIUTL2(511,.BIERR) Q
 ;
 ;---> If Vaccine IEN not passed, set Error and quit.
 I '$G(BILOT) D ERRCD^BIUTL2(502,.BIERR) Q
 ;
 ;---> Set Y=^AUTTIML(BILOT,0).
 N Y S Y=$G(^AUTTIML(BILOT,0))
 ;
 ;---> If Lot# does not exist, set Error and quit.
 I Y="" D  Q
 .D ERRCD^BIUTL2(512,.BIERR)
 ;
 ;---> if this Lot# does NOT point back to this Vaccine, set Error and quit.
 I $P(Y,U,4)'=BIVAC D ERRCD^BIUTL2(513,.BIERR) Q
 ;
 ;---> If the Lot# is INACTIVE (attempted save of earlier visit
 ;---> with Lot# previously chosen), set Error Code and quit.
 I $P(Y,U,3) D ERRCD^BIUTL2(426,.BIERR) Q
 ;
 ;---> If Lot# is duplicated in the IMM LOT File, set Error and quit.
 I $$LOTDUP^BIUTL4(BILOT) D ERRCD^BIUTL2(427,.BIERR)
 ;
 Q
 ;**********
 ;
 ;
 ;----------
DELETE(BIERR,BIDA,BIVTYPE) ;PEP - Delete an Immunization or Skin Test.
 ;---> Delete an Immunization or Skin Test.
 ;---> Called by RPC: BI VISIT DELETE.
 ;---> Parameters:
 ;     1 - BIERR   (ret) Text of Error Code if any, otherwise null.
 ;     2 - BIDA    (req) IEN of V IMM or V SKIN entry to be deleted.
 ;     3 - BIVTYPE (req) "I"=Immunization Visit, "S"=Skin Text Visit.
 ;
 ;---> Define delimiter to pass error and error variable.
 N BI31 S BI31=$C(31)_$C(31),BIERR=""
 ;
 ;---> If DA not supplied, set Error Code and quit.
 I '$G(BIDA) D  Q
 .D ERRCD^BIUTL2(404,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> If BIVTYPE does not="I" (Immunization Visit) and it does
 ;---> not="S" (Skin Test Visit), then set Error Code and quit.
 I ($G(BIVTYPE)'="I")&($G(BIVTYPE)'="S") D  Q
 .D ERRCD^BIUTL2(410,.BIERR) S BIERR=BI31_BIERR
 ;
 ;---> Delete V IMMUNIZATION entry.
 D DELETE^BIVISIT2(BIDA,BIVTYPE,.BIERR) S BIERR=BI31_BIERR
 Q
