ABSPECP0 ; IHS/FCS/DRS - receipt ; 
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 ; As of November 2000:
 ;  * This was only used for PCS Certification Testing
 ;  * But it's got the basis for a Receipt functionality
 ;    for a future release.
 ;  * So carry it along in the distribution, for that special
 ;    time and place when you get to go ahead with implementing
 ;    receipt functionality, which has been started in....
 ;  * ... RECEIPT^ABSPOS8, which calls FILEMAN^ABSPECP1 and @^ABSPECP3
 ;  * ^ABSPOS6G calls DUR^ABSPECP2 to interpret DUR codes
 ;
 ; ABSPECP0 - development utilities only
 Q
XYZ(N) D RESPONSE(N),RECEIPT(N) ;,^ABSPECT5 Q ; DUMPLAST^ABSPECT5, which needs work
 D IMPOSS^ABSPOSUE("P","TI","Development utility",,"XYZ",$T(+0))
 Q
BIGRUN ;
 ;C 51 ; maybe still open from previous run crashing
 F IEN=249:1:256 W "Receipt ",IEN,"..." D RECEIPT(IEN) W "done",!
 F IEN=249:1:256 W "Response to ",IEN,"..." D RESPONSE(IEN) W "done",!
 Q
RECEIPTF(IEN)      ;
 N FILE S FILE=$$RECTFN(IEN)
 ;O 51:(FILE:"W")
 D RECEIPT(IEN,51)
 ;C 51
 Q
RECEIPT(IEN,IO) ;
 K TMP D FILEMAN^ABSPECP1("TMP",IEN)
 I $D(IO) U IO
 D RECEIPT^ABSPECP3
 Q
RESPF(IEN)         ;
 N FILE S FILE=$$RESPFN(IEN)
 ;O 51:(FILE:"W")
 D RESPONSE(IEN,51)
 ;C 51
 Q
RESPONSE(IEN,IO)      K TMP D FILEMAN^ABSPECP1("TMP",IEN)
 I $D(IO) U IO
 N SRC S SRC="TMP"
 D FULL0^ABSPECP3()
 Q
DIR() Q "C:\MSMNEW\PCS\"
RECTFN(IEN)      Q $$DIR_"RCT"_IEN_".TXT"
RESPFN(IEN)         Q $$DIR_"RESP"_IEN_".TXT"
