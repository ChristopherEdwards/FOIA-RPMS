ABSPOSC1 ; IHS/FCS/DRS - certification testing ;  
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
 ;
 ;  DEVELOPMENT USE ONLY!!!  For use when doing certification testing.
 ;  (Envoy, PCS, etc.)
 ;
 ;    The format has to be in 9002313.92, with NDC BIN number and
 ;    Envoy plan number filled in.
 ;    Need to have ^ABSPEI(insurer,100) pointing to the format
 ;    The insurer comes from $P(^ABSPC(n,0),U,2)
 ;    Point the insurer to the RESERVED - FOR TESTING dial out.
 ;
 ; Have to set up an entry in 9002313.31.  Fill in values for
 ;  each of the NCPDP data dictionary fields for the test claim.
 ; In general, DON'T fill in 101 BIN Number.  It will pick up the
 ;  Envoy plan number from the 9002313.92 record for you.
 ;
 ; Once, before doing any of these,
 ;
 ;  DO SETINSUR^ABSPOSC1(low,high pointer to 9002313.31)
 ;  It prompts for insurer and sets the right insurer into each of
 ;  those .31 records.
 ;
 ;  ABSP INSURER file  - ABSP SETUP INSURER QUICK to attach it to
 ;    the format you're testing.
 ;
 ;  DO SETDATE^ABSPOSC1(date,low,high pointer to 9002313.31)
 ;
 ;
 ; Then, to test an individual claim:
 ;
 ;  DO TEST^ABSPOSC2(pointer to 9002313.31)
 ;  But if you're doing a Reversal, 
 ;  instead DO REVERSAL^ABSPOSC2(pointer to 9002313.31)
 ;   Temporarily uncomment the line in RXI4REV^ABSPOSU
 ;
 ;  DO SEND^ABSPOSC2(pointer to 9002313.31) to transmit
 ; 
 ;  DO LOG^ABSPOSC2 to invoke ABSP COMMS LOG
 ;    RESERVED - FOR TESTING is dial out `5 (saves typing!)
 ;
 ;  DO PRINT^ABSPOSC2(pointer to 9002313.31) to dump raw claim
 ;    and response packets
 ;  DO PRINTR^ABSPOSC2(pointer to 9002313.31) to dump response only
 ;
 ;  Use Fileman to print 9002313.02, .03  fields' contents.
 ;  DO ^%G on ^ABSPC(entry #  to look at fields that 
 ;   way, especially the trailing spaces.
 ;
 ; When there's multiple test claims to send, and the data varies
 ; just a little bit, use fileman Transfer Entries, then Enter/Edit
 ; to change the few that need to be changed.
 ;     
 Q
 ; Utilities to operate on lots of claims at once:
SETDATE(DATE,LOW,HIGH)       ; Set DATE FILLED,DATE WRITTEN fields
 ; to the given date ; DT is a good choice for parameter 1!
 N CLAIM,FIELD
 I '$G(DATE) S DATE=DT
 F CLAIM=LOW:1:HIGH F FIELD=401,414 D SETFIELD(CLAIM,FIELD,DATE)
 Q
SETINSUR(LOW,HIGH) ;
 N DIC,X,DTIME,DLAYGO,DINUM,Y,DTOUT,DUOUT
 S DIC="^AUTNINS(",DIC(0)="AEMN" D ^DIC Q:Y<1  S Y=+Y
 F CLAIM=LOW:1:HIGH D SET0(CLAIM,4,Y)
 Q
SET0(CLAIM,PIECE,VALUE)      ; set given piece of 0 node of 9002313.31 entry
 Q:'$D(^ABSP(9002313.31,CLAIM))
 S X=^ABSP(9002313.31,CLAIM,0)
 N REF S REF="^ABSP(9002313.31,"_CLAIM_",0)" ;=$ZR
 S ^TMP("ABSP",$J,"ABSPOSC1",DT,REF)=X ; save old values, just in case
 S $P(X,U,PIECE)=Y
 S ^ABSP(9002313.31,CLAIM,0)=X
 W "Done for `",CLAIM,": ",X,!
 Q
SETFIELD(CLAIM,FIELD,VALUE)  ; general - set NCPDP field # value for given
 ; entry in 9002313.31 ; both in claim header and prescription detail
 N M,N S M=0
 F  S M=$O(^ABSP(9002313.31,CLAIM,1,M)) Q:'M  D  ; claim header loop
 . N X S X=^ABSP(9002313.31,CLAIM,1,M,0)
 . S REF="^ABSP(9002313.31,"_CLAIM_",1,"_M_",0)" ;,REF=$ZR
 . D SETF1
 S N=0 F  S N=$O(^ABSP(9002313.31,CLAIM,2,N)) Q:'N  D  ; presc loop
 . N M S M=0
 . F  S M=$O(^ABSP(9002313.31,CLAIM,2,N,1,M)) Q:'M  D  ; field in presc
 . . N X S X=^ABSP(9002313.31,CLAIM,2,N,1,M,0)
 . . S REF="^ABSP(9002313.31,"_CLAIM_",2,"_N_",1,"_M_",0)" ;,REF=$ZR
 . . D SETF1
 Q
SETF1 ; given REF, X, FIELD, VALUE
 I REF'?1"^ABSP(9002313.31,".E D  Q  ; safety!!!
 . D IMPOSS^ABSPOSUE("P","T","Bad global REF="_REF,,"SETF1",$T(+0))
 N F S F=$P(X,U) ; pointer to 9002313.91
 N Y S Y=^ABSPF(9002313.91,F,0)
 I $P(Y,U)'=FIELD Q  ; match on NCPDP Field #
 S ^TMP("ABSP",$J,"ABSPOSC1",DT,REF)=X ; save old value of node
 S $P(X,U,2)=VALUE ; replace it with the new value
 W "Changed ",REF,"=",@REF
 S @REF=X
 W " to ",@REF,!
 Q
