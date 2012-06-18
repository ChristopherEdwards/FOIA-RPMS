ACHSYCOR ; IHS/ITSC/PMF - COMPARE RECORDS TO RECORDS FROM CORE 
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ;This utility is for comparing records of documents from
 ;CORE to the records in the CHS/MIS database.
 ;
 ;Before this program is run, the records from CORE must be
 ;loaded into a global in the present uci.
 ;
 ;the default storage of those records is:
 ;
 ;    ^TEMP("CHSCORE",docnum) = record
 ;
 ;where docnum is the document number stripped of the year/facility,
 ;so that doc 1-S83-00006 is listed as 6.
 ;
 ;the CORE record looks like this:
 ;
 ;patient type^doc_no^fy^can^obj_cls^cum_oblig^cum_dis^document balance
 ;
 ;At this point, the core records are going to be uniform in fiscal
 ;year; that is, they will send only one fiscal year at a time.  For
 ;that reason, this program will only work on one year at a time.
 ;
 ;the way this program works:
 ;
 ;GET the facility number
 ;IF there is more than one facility number, then
 ;  ask which one
 ;ASK for the fiscal year
 ;
 ;FOR each document of that year in the B xref
 ;  IF the document is listed in the core records, THEN
 ;    SEE if the CAN number matchs
 ;    SEE if the OCC matches
 ;    GET the document status
 ;    FOR each transaction on the document
 ;      draw out the trans type and amount
 ;    Record the total amount for each trans type
 ;    Calculate and record the balance
 ;    calculate and record the difference between the -
 ;    - core balance and our balance
 ;
 ;record number of documents examined and number reported on
 ;
 D INIT
 S FAC=$O(^ACHSF("B",""))
 I $O(^ACHSF("B",FAC))'=""  D GETFAC I 'OK Q
 ;
 D GETFY I 'OK Q
 ;
 S DOCXREF=1_FY F  S DOCXREF=$O(^ACHSF(FAC,"D","B",DOCXREF)) Q:DOCXREF=""  Q:$E(DOCXREF,2)'=FY  D
 . S SEQ=$O(^ACHSF(FAC,"D","B",DOCXREF,"")) I SEQ="" Q
 . S DOCDAT=$G(^ACHSF(FAC,"D",SEQ,0)) I DOCDAT="" Q
 . S NUMDEX=NUMDEX+1,ERR="" I NUMDEX#100=0 W " ."
 . S DOCN=+$P(DOCDAT,U,1)
 . I $P(DOCDAT,U,14)'=FY Q
 . ;I '$D(^TEMP("CHSCORE",DOCN)) Q
 . ;S COREDAT=$G(^TEMP("CHSCORE",DOCN))
 . ;for testing
 . S COREDAT="1^2^3^4^5^6^7^8^9^10^11^12^13^14^15"
 . ;
 . S NUMDMA=NUMDMA+1
 . ;
 . S STAT=$P(DOCDAT,U,12)
 . S OCC=$P(DOCDAT,U,10),OCC=$P($G(^ACHSOCC(OCC,0)),U,1)
 . I OCC'=$P(COREDAT,U,5) S ERR=ERR_BASH_"OCC MISMTC"
 . ;
 . S CAN=$P(DOCDAT,U,6),CAN=$P($G(^ACHS(2,CAN,0)),U,1)
 . I CAN'=$P(COREDAT,U,4) S ERR=ERR_BASH_"CAN MISMTC"
 . ;
 . ; for each transaction...
 . F TRANTYP="I","S","ZA","C","P","IP" S @TRANTYP=""
 . S TNUM=0 F  S TNUM=$O(^ACHSF(FAC,"D",SEQ,"T",TNUM)) Q:TNUM=""  D
 .. S TRANSDAT=$G(^ACHSF(FAC,"D",SEQ,"T",TNUM,0)) I TRANSDAT="" S ERR=ERR_BASH_"BAD TRANS" Q
 .. ;
 .. S TYPE=$P(TRANSDAT,U,2),AMT=+$P(TRANSDAT,U,4)
 .. I TYPE="" S ERR=ERR_BASH_"BAD TRANS" Q
 .. S @TRANTYP=@TRANTYP+AMT
 .. Q
 . ;
 . S ^TEMP("CHSCORE2",DOCN)=COREDAT
 . S ^TEMP("CHSCORE2",DOCN)=$G(^TEMP("CHSCORE2",DOCN))_U_STAT_U_($L(ERR,BASH)-1)_U_$P(ERR,BASH,2,9999)
 . F TRANTYP="I","S","ZA","C","IP","P" S ^TEMP("CHSCORE2",DOCN)=$G(^TEMP("CHSCORE2",DOCN))_U_@TRANTYP
 . S TOTAL=I+S-ZA-C-IP-P
 . S ^TEMP("CHSCORE2",DOCN)=$G(^TEMP("CHSCORE2",DOCN))_U_TOTAL
 . Q
 ;
 Q
 ;
INIT ;
 S U="^",BASH="\"
 ;number of docs examined and number of docs matched
 S (NUMDEX,NUMDMA)=0
 Q
 ;
GETFAC ;
 S OK=0
 W !!,"Enter the facility number to use:  "
 R R:300
 I R=""!(R="^") Q
 I R="?" D  G GETFAC
 . W ! S R="" F  S R=$O(^ACHSF("B",R)) Q:R=""  W !,?5,R
 I '$D(^ACHSF("B",R)) W "Facility not on record" G GETFAC
 S FAC=R,OK=1
 Q
 ;
GETFY ;
 S OK=0
 W !!,"Enter the fiscal year single digit:  "
 R R:300
 I R=""!(R="^") Q
 S FY=R,OK=1
 Q
