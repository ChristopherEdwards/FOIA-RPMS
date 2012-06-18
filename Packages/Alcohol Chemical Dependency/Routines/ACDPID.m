ACDPID ;IHS/ADC/EDE/KML - ENCRYPTED PATIENT IDENTIFIER;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ; This routine is passed a patient ien and returns an encrypted patient
 ; identifier 12 bytes long.  The entry point DEC reverses the process
 ; and returns the decoded output in a 27 byte long string.
 ;
ENC(DFN) ;EP - RETURN ENCRYPTED PATIENT IDENTIFIER
 NEW ACDV,ACDX,ACDY,I,X,X1,Y
 S ACDV=""
 G:'$G(DFN) ENCX ;                       exit if no patient ien passed
 G:'$D(^DPT(DFN,0)) ENCX ;               exit if patient doesn't exist
 ;----------
 ; take 1st 3 chars of name, replace punctuation with numbers, pad out
 ;   to 3 chars
 S ACDX=$E($P($P(^DPT(DFN,0),U),","),1,3)
 S ACDX=$TR(ACDX,"'-.,","1234")
 F I=1:1:(3-$L(ACDX)) S ACDX=ACDX_"5"
 S ACDV=ACDX
 ;----------
 ; take 1st initial, 0 if null
 S ACDX=$E($P($P(^DPT(DFN,0),U),",",2)) S:ACDX="" ACDX=0
 ;----------
 ; concatenate in reverse order
 S ACDV=$E(ACDV,3)_$E(ACDV,2)_$E(ACDV)_ACDX
 ;----------
 ; concatenate fileman date of birth (converted to $H/hex format)
 S ACDX=$$DOB^AUPNPAT(DFN) S:$L(ACDX)'=7 ACDX=3991231
 S ACDX=$$FMTH^XLFDT(ACDX,1)
 S X=ACDX,X1=16 D CNV^XTBASE S Y=$E(Y,1,4)
 F I=1:1:(4-$L(Y)) S Y=Y_"-"
 S ACDV=ACDV_Y
 ;----------
 ; concatenate last 4 digits of SSN
 S ACDX=$E($$SSN^AUPNPAT(DFN),6,9) S:$L(ACDX)'=4 ACDX="9999"
 F I=1:1:4 D
 . S X=$E(ACDX,I)
 . I X<5 S X=X+5,$E(ACDX,I)=X I 1
 . E  S X=X-5,$E(ACDX,I)=X
 . Q
 S ACDV=ACDV_ACDX
 ;----------
 ; shuffle
 S ACDV=$E(ACDV,4,6)_$E(ACDV,10,12)_$E(ACDV,1,3)_$E(ACDV,7,9)
 ;----------
 ; encrypt
 D ENCRYPT
 ;----------
ENCX ;
 Q ACDV
 ;
 ;
ENCRYPT ;
 S ACDV=$TR(ACDV,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","UVWXJKLMYZABQRSTCDGHIEFNOP")
 S ACDV=$TR(ACDV,"1234567890","8967320415")
 Q
 ;
 ;
 ;
DEC(PID) ;EP - RETURN DECRYPTED PATIENT IDENTIFIER
 NEW ACDV,ACDX,ACDY,I,X,X1,Y
 S ACDV=""
 G:$G(PID)="" DECX ;                     exit if no string
 G:$L(PID)'=12 DECX ;                    exit if string not 12 chars
 S ACDV="["
 ;----------
 ; decrypt
 D DECRYPT
 ;----------
 ; unshuffle
 S PID=$E(PID,7,9)_$E(PID,1,3)_$E(PID,10,12)_$E(PID,4,6)
 ;----------
 ; take 1st 3 chars of name, replace numbers with punctuation
 S ACDX=""
 F I=3,2,1 S ACDX=ACDX_$E(PID,I)
 S ACDX=$TR(ACDX,"1234","'-.,")
 S ACDY=""
 F I=1:1:3 S:$E(ACDX,I)'="5" ACDY=ACDY_$E(ACDX,I)
 S ACDX=ACDY_","_$S($E(PID,4)'="0":$E(PID,4),1:"")
 S ACDV=ACDV_ACDX
 ;----------
 ; fileman date of birth (converted to external format)
 S ACDX=""
 S X=$E(PID,5,8)
 F I=1:1:4 S:$E(X,I)'="-" ACDX=ACDX_$E(X,I)
 S X=ACDX,X1=16 D DEC^XTBASE S ACDX=Y
 S ACDX=$$HTE^XLFDT(ACDX,1)
 S ACDV=ACDV_"__"_ACDX
 ;----------
 ; last 4 digits of SSN
 S ACDX=$E(PID,9,12)
 F I=1:1:4 D
 . S X=$E(ACDX,I)
 . I X<5 S X=X+5,$E(ACDX,I)=X I 1
 . E  S X=X-5,$E(ACDX,I)=X
 . Q
 S:ACDX="9999" ACDX="    "
 S ACDV=ACDV_"__"_ACDX
 ;----------
 S ACDV=ACDV_"]"
DECX ;
 Q ACDV
 ;
DECRYPT ;
 S PID=$TR(PID,"UVWXJKLMYZABQRSTCDGHIEFNOP","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 S PID=$TR(PID,"8967320415","1234567890")
 Q
