ABSPOSQC ; IHS/FCS/DRS - POS background, Part 1 ;
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
 ;  GETPHARM, GETDIV, VISIT subroutines
 ;
GETPHARM ;EP -  given ABSBPDIV, ABSBSDIV, ABSBRXI, ABSBRXR
 S ABSPHARM=0 ; want to set this value
 N SUB S SUB=$P("OPSITE^",U,ABSBSDIV) Q:SUB=""  ; which list to check
 N X S X=0 F  S X=$O(^ABSP(9002313.56,X)) Q:'X  D  Q:ABSPHARM
 . Q:'$D(^ABSP(9002313.56,X,SUB,"B",ABSBPDIV))
 . N Y S Y=$O(^ABSP(9002313.56,X,SUB,"B",ABSBPDIV,0))
 . ; this division might belong to this pharmacy
 . ; if there's a providers list, you need to match on it, too
 . ; (This is to handle the Sitka situation with Haines)
 . I '$D(^ABSP(9002313.56,X,SUB,Y,1)) S ABSPHARM=X Q  ; none
 . N PRESC S PRESC=$P(^PSRX(ABSBRXI,0),U,4) Q:'PRESC
 . Q:'$D(^ABSP(9002313.56,X,SUB,Y,1,"B",PRESC))
 . S ABSPHARM=X ; matched both division and prescriber
 Q
GETDIV ;EP - Var setup: Given ABSBRXI, ABSBRXR, Set ABSBPDIV, ABSBSDIV
 S (ABSBSDIV,ABSBPDIV)=0 N X1,X
 I ABSBRXR D  ; if refill, get the (PRESCRIPTION,REFILL DATE,DIVISION)
 . S X=$P($G(^PSRX(ABSBRXI,1,ABSBRXR,0)),U,9)
 E  I ABSBRXI D  ; if not refill, get the (PRESCRIPTION,DIVISION)
 . S X=$P($G(^PSRX(ABSBRXI,2)),U,9)
 E  Q  ; must be a supply item - no prescription file entry
 ;       for supply item, leave division as 0, it's okay
 S ABSBPDIV=X ;$P($G(^PS(59,ABSBPDIV,0)),U,6) points to institution
 S ABSBSDIV=1 ; file 59 is where this points
 ;   $P(^PS(59,ABSBPDIV,"INI"),U) points to related institution
 I 'ABSBPDIV D  Q
 .D LOG^ABSPOSL("DIVISION - Incorrect or missing for "_ABSBRXI_","_ABSBRXR) Q
 ; and a lot of early ANMC complexity deleted
 Q
VISIT ;EP -  Var setup:  pointers ^AUPNVSIT(ABSBVISI and ^AUPNVMED(VMEDDFN
 ; We assume that the visit is already created,
 ; we assume that the prescription is already entered,
 ; we assume that the PCC link is already created.
 ; Isn't VMEDDFN required for us?  Or is the prescription # good enough?
 ;  (have to look at claim assembly code to know for sure)
 ; ANMC tally as of 03/10/2000 5:15PM EST:
 ;   4675 found via PCC link;  0 found by date@12;  2 visits created
 ; So we don't really need or want all that extra baggage, do we?
 S ABSBVISI="",VMEDDFN=""
 N X
VIS1 ;get PCC link for last refill, if any; otherwise for first fill
 N LINKSRC,PCCLINK,RESULT
 ; Start by getting the appropriate PCC link
 I ABSBRXR D
 . S PCCLINK=$P($G(^PSRX(ABSBRXI,1,ABSBRXR,999999911)),U) ;refill
 . S LINKSRC="#"_ABSBRXR
 E  D
 . S PCCLINK=$P($G(^PSRX(ABSBRXI,999999911)),U) ;first fill
 . S LINKSRC="#0"
 S RESULT="VISIT - PCC LINK "_LINKSRC_"->"
VIS2 I PCCLINK D  ; yes, a PCC link was found
 .S VMEDDFN=PCCLINK ; remember IEN into V MEDICATION
 .S RESULT=RESULT_"^AUPNVMED("_VMEDDFN_"->"
 .S ABSBVISI=$P($G(^AUPNVMED(VMEDDFN,0)),U,3)
 .S RESULT=RESULT_"^AUPNVSIT("_ABSBVISI
 I 'ABSBVISI S RESULT=RESULT_":FAILURE"
 D LOG^ABSPOSL(RESULT)
 D INCSTAT^ABSPOSUD("V",$S(ABSBVISI:1,1:2)) ; 1 success, 2 failure
 Q
 ; - - - - - - - - - - - - -
