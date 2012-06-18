ABSPOSM ; IHS/FCS/DRS - Report Master (.61) ;     [ 09/12/2002  10:12 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;
 ; ABSPOSM1 - takes care of updating of file .61
 ; ABSPOSM2 - some report headers called from Print options
 ; ABSPOSMA-ABSPOSM* for lowercase * - general inquiry/report on .57
 ;
 Q
MESSAGE(IEN57,N) ;EP - message sent in e-claim response
 I 'IEN57 Q ""
 N RESP,POS D RESPPOS(IEN57) Q:'RESP!'POS ""
 I '$D(N) S N=0
 I N=1 Q $$MESSAGE^ABSPOS03(RESP,POS,1)
 I N=2 Q $$MESSAGE^ABSPOS03(RESP,POS,2)
 Q $$MESSAGE^ABSPOS03(RESP,POS)
RESPPOS(IEN57) ;EP - caller should N RESP,POS
 I $G(^ABSPTL(IEN57,4)) D  ; reversal
 . S RESP=$P(^ABSPTL(IEN57,4),U,2)
 . S POS=1
 E  D
 . S RESP=$P(^ABSPTL(IEN57,0),U,5)
 . S POS=$P(^ABSPTL(IEN57,0),U,9)
 Q
 ; Computed fields:
INSHELP(D0) ;EP - (#10002) INSURER HELP #
 N X S X=$P($G(^ABSPECX("RPT",D0,0)),U,3) I 'X Q "" ; IEN57
 S X=$P($G(^ABSPTL(X,1)),U,6) I 'X Q "" ; INSURER
 S X=$G(^ABSPEI(X,100)) I X="" Q "" ; insurer pharm e-claims info
 N Y S Y=$P(X,U,5) I Y]"" Q Y ; specific phone # for insurer
 S X=$P(X,U) I 'X Q "" ; format
 Q $P($G(^ABSPF(9002313.92,X,1)),U,5) ; phone # as stored with format
RELTIME(D0) ;EP - (#10003) RX RELEASED DATE/TIME
 N RXI,RXR D D0RXIRXR
 I RXI=""!(RXR="") Q "" ; should never happen
 I RXR Q $P($G(^PSRX(RXI,1,RXR,0)),U,17)
 E  Q $P($G(^PSRX(RXI,2)),U,13)
RETSTOCK(D0) ;EP - (#10004) RX RETURNED TO STOCK
 N RXI,RXR D D0RXIRXR
 I RXI=""!(RXR="") Q "" ; should never happen
 I RXR Q +$P($G(^PSRX(RXI,1,RXR,0)),U,16)
 E  Q +$P($G(^PSRX(RXI,2)),U,15)
DELETED(D0) ; EP - (#10001) RX DELETED
 N RXI,RXR D D0RXIRXR
 I RXI=""!(RXR="") Q "" ; should never happen
 Q $$RXDEL^ABSPOS(RXI,RXR)
QTY(D0) ;EP -
 N RXI,RXR D D0RXIRXR Q:RXI=""!(RXR="")
 I RXR Q $P($G(^PSRX(RXI,1,RXR,0)),U,4)
 E  Q $P($G(^PSRX(RXI,0)),U,7)
D0RXIRXR ; set up RXI,RXR,R for computed fields for ien D0
 N X S X=$G(^ABSPECX("RPT",D0,0)),RXI=$P(X,U,4),RXR=$P(X,U,5)
 Q
TEST ; TEMPORARY
 D UPDATE61^ABSPOSM1(3010110,3010110)
 Q
