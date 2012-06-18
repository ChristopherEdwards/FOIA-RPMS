BIRPC6 ;IHS/CMI/MWR - REMOTE PROCEDURE CALLS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  CALL TO PRODUCE TEMP GLOBAL OF PATIENTS FOR TWO-YR-OLD GPRA REPORT.
 ;;  PATCH 1: If Code Set versioning is present, use standard call.  CPTIMM+14
 ;
 ;
 ;----------
ACTLIST(BIQDT,BITAR,BISITE,BIERR) ;PEP - Produce ^TMP of Patients for Imm Report.
 ;---> Produce ^TMP array of Patients for Quarterly Immunization Report.
 ;---> Parameters:
 ;     1 - BIQDT  (req) Quarter Ending Date.
 ;     2 - BITAR  (opt) Two-Yr-Old Report Age Range: either "19-35" or "24-35"
 ;     3 - BISITE (req) Site IEN.
 ;     4 - BIERR  (ret) Error text (if null, then no error).
 ;
 K ^TMP("BIDUL",$J),^TMP("BIREPT1",$J)
 ;
 ;---> Check for required Variables.
 I '$G(BIQDT) D ERRCD^BIUTL2(623,.BIERR) Q
 I '$D(BITAR)  D ERRCD^BIUTL2(613,.BIERR) Q
 S:'%G(BISITE) BISITE=$G(DUZ(2)) I '$G(BISITE) S BIERR=109 Q
 ;
 S BIBEN("ALL")="",BICC("ALL")="",BICM("ALL")="",BIHCF("ALL")=""
 S BIAGRPS="3,5,7,16,19,36"
 S:'$G(BITAR) BITAR="19-35"
 ;
 ;---> Gather data.
 ;***** GO BACK TO GETDATA^BIREPT3 AND CHECK OUT BIVAL (STORE/DON'T STORE) DEAL!!!!
 D GETDATA^BIREPT3(.BICC,.BIHCF,.BICM,.BIBEN,BIQDT,BITAR,BIAGRPS,BISITE,.BIERR)
 ;
 ;***** NEXT LINE: PASS AS LOCAL ARRAY OR SIMPLER ^TMP ARRAY?
 ;***** ASK LORI HOW SHE WANTS IT?
 ;***** Array is stored in ^TMP("BIDUL",$J,CURRENT-COMMUNITY-IEN,1,HRCN,DFN)
 ;
 ;---> Clean up would be:
 ;K ^TMP("BIDUL",$J),^TMP("BIREPT1",$J)
 Q
 ;
 ;
 ;----------
CPTIMM ;EP
 ;---> Create a V Immunization entry (if none exists) for a CPT Coded
 ;---> Immunization.  Called by the AIMM Mumps Cross Reference on the
 ;---> .01 Field of the V CPT File# 9000010.18.
 ;
 ;---> Edit and uncomment next line to test directly.
 ;;S APCDVSIT=37529775,APCDPAT=227582,APCDDATE=3051017,X=90663,BICCPT=1776
 ;
 Q:'$G(X)
 N BICPT,BIDATE,BIDFN,BIPTR,BIVAC,BIVSIT
 ;
 ;********** PATCH 1, v8.2.1, FEB 01,2008, IHS/CMI/MWR
 ;---> If Code Set versioning is present, use standard call.
 D
 .I $L($T(^ICPTCOD)) S BICPT=$P($$CPT^ICPTCOD(X),"^",2) Q
 .S BICPT=$P($G(^ICPT(X,0)),"^")
 ;**********
 ;
 S BIVSIT=$G(APCDVSIT)
 S BIDFN=$G(APCDPAT)
 S BIDATE=$G(APCDDATE)
 Q:'BICPT  Q:'BIVSIT  Q:'BIDFN  Q:'BIDATE
 ;
 ;---> Quit if Site Parameter has Import CPT Visits feature disabled.
 Q:'$$IMPCPT^BIUTL2($G(DUZ(2)))
 ;
 ;---> Set this piece = IEN in V CPT if available.
 S BICCPT=$S($G(DA):DA,1:1)
 ;
 ;---> Quit if this CPT Code is not in the Immunization File (Vaccine Table).
 S BIVAC=$O(^AUTTIMM("ACPT",BICPT,0))
 Q:'BIVAC  Q:'$D(^AUTTIMM(BIVAC,0))
 ;
 ;---> Quit if an Immunization for this Patient and this Vaccine
 ;---> on this Date already exists.
 ;
 ;********** PATCH 1, APR 4,2006, IHS/CMI/MWR
 ;---> Fix xref lookup when checking to avoid CPT-Coded duplicate
 ;---> immunizations by striping time from BIDATE.
 Q:$D(^AUPNVIMM("AA",BIDFN,BIVAC,(9999999-$P(BIDATE,"."))))
 ;**********
 ;
 N BIDATA
 S BIDATA="I|"_BIDFN_"|"_BIVAC_"|||"_BIDATE_"||||||||||||||||||"_BICCPT
 D
 .D EN^XBNEW("VFILE1^BIVISIT","BIVSIT;BIDATA")
 Q
