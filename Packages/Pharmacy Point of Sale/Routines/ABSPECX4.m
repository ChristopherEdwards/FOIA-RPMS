ABSPECX4 ; IHS/FCS/DRS - JWS ;  [ 09/12/2002  10:00 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;Function which gets a claim or response record from the ^ABSPECX
 ;transmission scratch global.
 ;
 ;Input Variables:    IEN  - Internal Entry Number of Claim Record
 ;                    MODE - "C" for Claim or "R" for Response
 ;
 ;Function Returns:   AREC - ASCII formated record
 ;----------------------------------------------------------------------
 ; SVEAREC (Save a Record)
 ;    Called from ABSPOSQH from ABSPOSQG from ABSPOSQ2
 ; GETAREC is apparently obsolete?
 ;
 ;GetAREC(IEN,MODE) 
 ;Manage Local variables
 ;N AREC,NNODES,INDEX
 ;
 ;Make sure input variables are defined
 ;Q:$G(IEN)="" ""
 ;Q:$G(MODE)="" ""
 ;
 ;Assemble ascii record from its 245 character sections
 ;S AREC=""
 ;S NNODES=$G(^ABSPECX($J,MODE,IEN,0))
 ;Q:+NNODES=0
 ;F INDEX=1:1:NNODES D
 ;.S AREC=AREC_$G(^ABSPECX($J,MODE,IEN,INDEX))
 ;
 ;Q AREC
 ;----------------------------------------------------------------------
 ;Routine which creates and breaks apart an ASCII claim or response
 ;record and stores it in the ^ABSPECX transmission scratch global.
 ;
 ;Input Variables:    AREC - ASCII formatted record
 ;                    IEN  - Internal Entry Number of Claim Record
 ;                    MODE - "C" for Claim or "R" for Response
 ;
 ;Function Returns:   AREC - ASCII formated record
 ;----------------------------------------------------------------------
SVEAREC(AREC,IEN,MODE) ;EP - from ABSPOSQH
 ;Manage local variables
 N NCHARS,NNODES,INDEX,START,END
 ;
 ;Make sure input variables are defined
 Q:$G(AREC)=""
 Q:$G(MODE)=""
 Q:$G(IEN)=""
 ;
 ;Determine number of nodes need to store AREC
 S NCHARS=$L(AREC)
 S NNODES=((NCHARS-1)\245)+1
 ;
 K ^ABSPECX($J,MODE,IEN)
 S ^ABSPECX($J,MODE,IEN,0)=NNODES
 ;
 ;Break AREC into 245 character sections
 F INDEX=1:1:NNODES D
 .S START=((INDEX-1)*245)+1
 .S END=START+245-1
 .S:END>NCHARS END=NCHARS
 .S ^ABSPECX($J,MODE,IEN,INDEX)=$E(AREC,START,END)
 Q
