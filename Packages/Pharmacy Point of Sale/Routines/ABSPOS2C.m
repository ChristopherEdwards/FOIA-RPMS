ABSPOS2C ; IHS/FCS/DRS - ABSPOS2 continuation ; 
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
LABELS ;EP - from ABSPOS2 ; set up the labels display
 N R,R1,R2,C,CDIV,X
 S R1=1 ; start in row 1
 S CDIV=50 ; column divider line goes in column 50
LA001 S R=R1,C=3,X="* * * * * COMMUNICATIONS STATISTICS * * * * *" D L1
 S R=R+1,C=9,X="Packets  Per min      Bytes     Per Min" D L1
 S R=R+1,C=3,X="Sent" D L1
 ;S R=R+1,C=1,X="Rexmit" D L1
LA005 S R=R+1,C=3,X="Recd" D L1
 S R=R+1,C=3,X="Total claims" D L1 S C=26,X="Average per min" D L1
 S R=R+1,C=3,X="Average claims per packet" D L1
 S R=R+1,C=3,X="Average seconds per transaction" D L1
 S R=R+1,C=32,X="Now   Average" D L1
LA010 S R=R+1,C=3,X="Packets waiting to be sent" D L1
 S R=R+1,C=3,X="Responses waiting for proc" D L1
 S R=R+1,C=1,X=" * * Transaction Codes * * * Comms Problems * *" D L1
 S R=R+1
 S C=1,X="01:" D L1 S C=16,X="04:" D L1 S C=27,X="|  Dialing out" D L1
 S R=R+1
 S C=1,X="02:" D L1 S C=16,X="11:" D L1 S C=27,X="|  Sending data" D L1
LA015 S R=R+1
 S C=1,X="03:" D L1 S C=15,X="Oth:" D L1 S C=27,X="|  Rec'v'g data" D L1
 S R=R+1,C=27,X="|  We sent NAK" D L1
 S R=R+1 ; nothing on the left side on this line         
LA099 ;
 S R2=R,C=CDIV-1,X="|" F R=R1:1:R2 D L1
 S R2=R,C=CDIV,X="|" F R=R1:1:R2 D L1
LA101 S R=R1,C=CDIV+2,X="* CLAIM STATUS *  Now  Avg" D L1
 S R=R+1,C=CDIV+2,X="Waiting to start" D L1
 S R=R+1,X="Gathering info" D L1
LA105 S R=R+1,X="Wait packet build" D L1
 S R=R+1,X="Building packet" D L1
 S R=R+1,X="Wait for transmit" D L1
 S R=R+1,X="Transmitting" D L1
 S R=R+1,X="Receiv'g response" D L1
LA110 S R=R+1,X="Wait resp process" D L1
 S R=R+1,X="Proces'g response" D L1
 S R=R+1,C=CDIV+5,X="   * CLAIM RESULTS *"  D L1
 S C=CDIV+9
 S R=R+1,C=CDIV+10,X="Paid claims" D L1
 S R=R+1,X="Rejected claims" D L1
 S R=R+1,X="Paper or Unbillable" D L1
LA115 S R=R+1,X="Duplicate claims" D L1
LA116 S R=R+1,X="Captured claims" D L1
 S VALMCNT=$S(R>R2:R,1:R2)
LA200 ; Then line 18 begins "Next screen"
 S (R,R1)=17
 S X="***** Communications Problems *****",C=$L(X)/2*-1+40 D L1
 S C=1
LA210 S R=R+1,X="*** Dialing and Connecting ***" D L1
 S R=R+1,X="How many times we dialed" D L1
 S R=R+1,X="Did not receive CONNECT" D L1
 S R=R+1,X="Other errors during dialing" D L1
 S R=R+1
LA220 S R=R+1,X="*** Before & After Sending ***" D L1
 S R=R+1,X="Didn't get init ENQ" D L1
 S R=R+1,X="Didn't get STX back" D L1
 S R=R+1,X="Got ENQ instead" D L1
 S R=R+1,X="Got NAK instead" D L1
 S R=R+1,X="Got +++ instead" D L1
 S R=R+1,X="Got null instead" D L1
 S R=R+1,X="Got something else" D L1
 S R2=R,CDIV=40,C=CDIV,X="|" F R=R1+1:1:R2 D L1
 S R=R1,C=CDIV+4
LA260 S R=R+1,X="*** While receiving responses ***" D L1
 S R=R+1,X="Did not receive ETX" D L1
 S R=R+1,X="Received EOT during" D L1
 S R=R+1,X="Received null during" D L1
 S R=R+1,X="Received +++ during" D L1
 S R=R+1,X="Miscellaneous" D L1
 S R=R+1
LA270 S R=R+1,X="*** We sent NAK (LRC disagrees) ***" D L1
 S R=R+1,X="How many times" D L1
 S R=R+1,X="Got STX back (good)" D L1
 S R=R+1,X="Got null back" D L1
 S R=R+1,X="Got +++ back" D L1
 S R=R+1,X="Got something else" D L1
LA300 I R<33 F  Q:R=33  D
 .S R=R+1 S X=" " D L1
 S R1=R ; begin page 3 ; 
 S C=15
 S R=R+1,X="***  Front-end inputs  ***" D L1
 S R=R+1,X="Total claims submitted" D L1
 S R=R+1,X="Unique, first-time ones" D L1
 S R=R+1,X="Repeat submissions" D L1
 S R=R+1
 S R=R+1,X="***  Finding PCC Visits  ***" D L1
 S R=R+1,X="Found via PCC link in prescription file" D L1
 S R=R+1,X="Found by patient,date@time ""AA"" index" D L1
 S R=R+1,X="Could not find; created new visit" D L1
 S VALMCNT=R
 Q
L1 ; given R=row,C=col,X=string
 ; Duplicate of L1^ABSPOS2B
 D SET^VALM10(R,$$SETSTR^VALM1(X,$G(@VALMAR@(R,0)),C,$L(X)))
 I $$VISIBLE(R) D WRITE^VALM10(R)
 Q
VISIBLE(R)         Q $$VISIBLE^ABSPOS2B(R)
