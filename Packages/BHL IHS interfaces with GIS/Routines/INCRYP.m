INCRYP ;LD,DGH; 22 Apr 99 19:36; Encryption socket functions 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
ENCRYPT(INARR,INV,DESKEY,INIP,INERR) ;
 ;INPUT:
 ; INARR =  Message array to be encrypted.
 ; INV = Array in which the encrypted message will be returned.
 ;       Pass by reference.
 ; DESKEY = DES encryption key.  This parameter is only needed
 ;          for the first string of a message.
 ; INIP = Array containing parameter (PBR).  Key parameter is:
 ; INIP("EOL") = End of line.  Pass by reference.
 ; INERR = Error message.  Pass by reference.
 ;
 ; OUTPUT:
 ; 1 if successful, 0 if error
 ;
 N STOP,START,END,INBUF,INMAX,INCRYPT,LINE,LINO,INSMIN,INVS,EOL,ENARR
 N NEWNODE,ORGNODE,COUNT,ORGLEN,RC
 I '$L($G(DESKEY)) S INERR="Missing DES key" Q 0
 I $L($G(DESKEY))>8 S INERR="Invalid length of DES key" Q 0
 I '$D(INARR)  S INERR="No message array to be encrypted" Q 0
 S START=1,INMAX=328,INBUF=""
 S INVS=$P(^INRHSITE(1,0),U,12)
 S EOL=$S($L($G(INIP("EOL"))):$C(INIP("EOL")),1:"")
 S RC=$$CRYPON^INCRYPT(DESKEY)
 S INSMIN=$S($P($G(^INRHSITE(1,0)),U,14):$P(^(0),U,14),1:2500)
 S (STOP,END)=0,LINO=1
 S ENARR=INARR,ORGLEN=$L(INARR)
 F  S ENARR=$Q(@ENARR) Q:'$L(ENARR)!STOP  D
 .S COUNT=$L(INARR,",")
 .;Local array
 .I COUNT=1 S NEWNODE=$E($G(ENARR),1,ORGLEN)
 .;Global with node and IEN(s)
 .I COUNT>1 S NEWNODE=$E($G(ENARR),1,ORGLEN-1)_")" D
 .. I $E($G(ENARR),ORGLEN)'["," S STOP=1 Q
 .S ORGNODE=$E($G(INARR),1,$L(INARR))
 .; Matching the current node with the original node 
 .I NEWNODE'=ORGNODE S STOP=1 Q
 . S LINE=$G(@ENARR)
 . I $L(EOL) S LINE=LINE_EOL
 . S X=$$PACK(LINE,INMAX,.INBUF)
 . Q:'$L(X)
 . I '$Q(@ENARR),'$L(INBUF) S END=1
 . D ENCRYPT^INCRYPT(X,.INCRYPT,$L(X),START,END) S START=0
 . D:'INVS MC^INHS
 . S @INV@(LINO)=$G(INCRYPT),LINO=LINO+1
 . I $L(INBUF)>INMAX D
 .. N LINE1,INCRYPT1
 .. S LINE1=INBUF,INBUF=""
 .. S X1=$$PACK(LINE1,INMAX,.INBUF)
 .. I '$Q(@ENARR),'$L(INBUF) S END=1
 .. D ENCRYPT^INCRYPT(X1,.INCRYPT1,$L(X1),START,END)
 .. D:'INVS MC^INHS
 .. S @INV@(LINO)=$G(INCRYPT1),LINO=LINO+1
 S END=1 D
 . Q:'$L(INBUF)
 . D ENCRYPT^INCRYPT(INBUF,.INCRYPT,$L(INBUF),START,END)
 . D:'INVS MC^INHS
 . S @INV@(LINO)=$G(INCRYPT)
 S RC=$$CRYPOFF^INCRYPT()
 Q 1
 ;
DECRYPT(DECARR,INV,DESKEY,INERR) ;
 ; INPUT:
 ; DECARR = Name of the array containing encrypted message strings
 ;          to be decrypted.
 ; INV = Name of the array which the API will use to return the 
 ;       decrypted message string.  Pass by reference.
 ;    If local symbol space is low, the API will return a global array.
 ; DESKEY = DES encryption key.  This parameter is only needed
 ;          for the first string to be decrypted.
 ; INERR = Error message.  Pass by reference.
 ;
 ; OUTPUT:
 ; 1 if successful, 0 if error
 ;
 N I,DECRYPT,INVS,INSMIN,START,END,LINE,LINO,RC
 I '$D(DECARR)  S INERR="No message array to be encrypted" Q 0
 I '$L($G(DESKEY)) S INERR="Missing DES key" Q 0
 I $L($G(DESKEY))>8 S INERR="Invalid length of DES key" Q 0
 S INVS=$P(^INRHSITE(1,0),U,12)
 S START=1
 S RC=$$CRYPON^INCRYPT(DESKEY)
 S INSMIN=$S($P($G(^INRHSITE(1,0)),U,14):$P(^(0),U,14),1:2500)
 S (I,END)=0,LINO=1
 F  S I=$O(@DECARR@(I)) Q:'+I  D
 . S LINE=$G(@DECARR@(I))
 . I '$O(@DECARR@(I)) S END=1
 . D DECRYPT^INCRYPT(LINE,.DECRYPT,$L(LINE),START,END) S START=0
 . D:'INVS MC^INHS
 . S @INV@(LINO)=$G(DECRYPT),LINO=LINO+1
 S RC=$$CRYPOFF^INCRYPT()
 Q 1
 ;
PACK(INLIN,INMAX,INBUF) ;pack segments into packets
 ;INPUT
 ;  INLIN = line to pack
 ;  INMAX = maximum string length
 ;  INBUF = Overflow buffer (PBR)
 ;RETURN
 ;  Return value will be a string with length of max string if
 ;  INLIN has been exceeded. Null if it has not.
 ;  INBUF will have the overflow from max string length. Calling
 ;  routine should keep returning INBUF without change.
 ;
 N BL,INLINE,L
 S INBUF=$G(INBUF),BL=$L(INBUF)
 I BL+$L(INLIN)'>INMAX S INBUF=INBUF_INLIN
 E  S L=(INMAX-BL),INBUF=INBUF_$E(INLIN,1,L),INLIN=$E(INLIN,L+1,$L(INLIN)) S INLINE=INBUF,INBUF=INLIN
 Q $G(INLINE)
