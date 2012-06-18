ABSPOSAY ; IHS/FCS/DRS - Packet print utils ;    [ 09/12/2002  10:07 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;---------------------------------------------------------------------
 Q
 ;
 ; D DUMPLAST ; look at most recent response and associated claim.
 ;
 ; D DUMPN(pointer to 9002313.02) prints claim and response both
 ;
 ; Development and low-level support utilities
 ; Most useful callable entry points are:
 ;    PRINT02(pointer to 9002313.02)
 ;    PRINT03(pointer to 9002313.03)
 ;    DIAGPRT(string)  to print diagram in pretty formatted form
 ;
 ; 
DUMPLAST ;  Print the most recently-received claim-response pair
 N IEN03 S IEN03=$P(^ABSPR(0),U,3)
 N IEN02 S IEN02=$P(^ABSPR(IEN03,0),U)
 D PRINT02(IEN02),PRINT03(IEN03)
 Q
 ;
 ;
DUMP(REQ) ; given REQ = ien or ID of request packet, do the whole thing
 I REQ'?1N.N D  Q:REQ=""
 . S REQ=$O(^ABSPC("B",REQ,0))
 D PRINT02(REQ)
 N IEN03 S IEN03=$O(^ABSPR("B",REQ,""),-1) ; most recent response!
 I IEN03 D PRINT03(IEN03)
 Q
 ;
 ; Useful entry points now that we retain raw packet in 9002313.02,.03
 ; (earlier versions just saved the one single most recent packet)
 ;
PRINT02(N) ;EP - dump of a claim packet
 D PRINT0X(9002313.02,N) Q
PRINT03(N) ;EP - dump of a response packet
 D PRINT0X(9002313.03,N) Q
PRINT0X(FILE,N)         ; dump of a claim or response, given file number and IEN
 I FILE=9002313.02 D
 . W "Claim `",N,"  ",$P(^ABSPC(N,0),U)
 . N X S X=$P(^ABSPC(N,0),U,5)
 . I X W " transmitted ",X
 . S X=$P(^ABSPC(N,0),U,6)
 . I X W " created ",X
 E  W "Response `",N," received ",$P(^ABSPR(N,0),U,2)
 N PKT S PKT=$$GETPKT(FILE,N)
 D DIAGPRT(PKT)
 Q
GETPKT(FILE,N)     ; reassemble
 N X,ROOT
 S X="",ROOT="^ABSP"_$S(FILE=9002313.02:"C",FILE=9002313.03:"R")
 F I=1:1:$P(@ROOT@(N,"M",0),U,3) D
 . S X=X_@ROOT@(N,"M",I,0)
 Q X
 ;
 ; DIAGPRT(string) to print the given string in a pretty formatted way
 ;
DIAGPRT(A) ;
 N I,J,K,X
 I $E(A)=$C(2) S A=$E(A,2,$L(A))
 I $E(A,1,3)="HN."!($E(A,1,3)="HN*") S A=$E(A,4,$L(A))
 F I=1:15:$L(A) D
 .W !,$J(I,4),"/ "
 .F J=0:1:14 S K=I+J Q:K>$L(A)  S X=$E(A,K) D
 ..I X=" " W " ","sp"," "
 ..E  I X?1ANP W " ","'",X,"'"
 ..E  W $J($A(X),4)
 W ! Q
