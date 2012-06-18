LA7VOBXA ;VA/DALOI/JMC - LAB OBX Segment message builder (cont'd) ;JUL 06, 2010 3:14 PM
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**46,70,64,1027**;NOV 01, 1997
 ;
 Q
 ;
OBX2 ; Build OBX-2 sequence - Value type
 ;
 ; default value - string data
 S LA7VAL="ST"
 S LA7TYP="",LA7FILE=$G(LA7FILE),LA7FIELD=$G(LA7FIELD)
 ;
 I LA7FILE,LA7FIELD S LA7TYP=$$GET1^DID(LA7FILE,LA7FIELD,"","TYPE","","LA7ERR")
 ;
 I LA7TYP="DATE/TIME" S LA7VAL="TS"
 I LA7TYP="FREE TEXT" S LA7VAL="ST"
 I LA7TYP="WORD-PROCESSING" S LA7VAL="FT"
 I LA7TYP="NUMERIC" S LA7VAL="NM"
 I LA7TYP="SET" S LA7VAL="ST"
 I LA7TYP="POINTER" S LA7VAL="CE"
 ;
 Q
 ;
 ;
OBX3 ; Build OBX-3 sequence - Observation identifier field
 ;
 ; Initialize variables 
 S LA7J=1,LA7Y=""
 ;
 ; Build sequence using LOINC codes only
 ; LOINC code/code name/"LN"
 I LA7953'="" D
 . N LA7IENS,LA7Z
 . S LA7953=$P(LA7953,"-"),LA7IENS=LA7953_","
 . D GETS^DIQ(95.3,LA7IENS,".01;80","E","LA7X")
 . ; Invalid code???
 . I $G(LA7X(95.3,LA7IENS,.01,"E"))="" Q
 . S LA7Z=LA7X(95.3,LA7IENS,.01,"E")
 . S LA7Z=$$CHKDATA^LA7VHLU3(LA7Z,LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH,1),LA7J)=LA7Z
 . S LA7Z=$G(LA7X(95.3,LA7IENS,80,"E")),LA7Z=$TR(LA7Z,"~","^")
 . S LA7Z=$$CHKDATA^LA7VHLU3(LA7Z,LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH,1),LA7J+1)=LA7Z
 . S $P(LA7Y,$E(LA7ECH,1),LA7J+2)="LN"
 . S LA7J=4
 ;
 ; Build sequence using NLT codes
 ; File #64 NLT code/NLT code name/"99VA64"
 ; If LOINC is primary make NLT alternate, otherwise NLT primary.
 I LA7NLT'="" D
 . N LA7642,LA7Z
 . S LA764=$O(^LAM("E",LA7NLT,0)),LA7Z=""
 . S $P(LA7Y,$E(LA7ECH,1),LA7J)=LA7NLT
 . I LA764 S LA7Z=$$GET1^DIQ(64,LA764_",",.01,"I")
 . I LA7Z="" D
 . . S LA764=$O(^LAM("E",$P(LA7NLT,".")_".0000",0))
 . . I LA764 S LA7Z=$$GET1^DIQ(64,LA764_",",.01,"I")
 . . S LA7642=$O(^LAB(64.2,"C","."_$P(LA7NLT,".",2),0))
 . . I LA764,LA7642 S LA7Z=LA7Z_"~"_$$GET1^DIQ(64.2,LA7642_",",.01,"I")
 . S LA7Z=$$CHKDATA^LA7VHLU3(LA7Z,LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH,1),LA7J+1)=LA7Z
 . S $P(LA7Y,$E(LA7ECH,1),LA7J+2)="99VA64"
 . S LA7J=LA7J+3
 ;
 ; Non-standard/non-VA code
 ; Don't use alternate code when it's "99VA63" and we've already encoded
 ; a primary and alternate. If alternate is a non-VA code then use as
 ; alternate code.
 ; If primary and alternate are not 99VA63 then code 3rd triplet with
 ; 99VA63 per Julius Chou for Clinical Case Registry (JMC/May 13, 2004)
 I LA7ALT="" Q
 I $P(LA7ALT,"^",3)'="99VA63",LA7J>4 S LA7J=4
 I $P(LA7ALT,"^",3)="99VA63" D  Q:LA7J=0
 . I $P(LA7Y,$E(LA7ECH,1),3)="99VA63" S LA7J=0 Q
 . I LA7J>4,$P(LA7Y,$E(LA7ECH,1),6)="99VA63" S LA7J=0 Q
 . I LA7J>4 S LA7J=7
 S $P(LA7Y,$E(LA7ECH,1),LA7J)=$$CHKDATA^LA7VHLU3($P(LA7ALT,"^"),LA7FS_LA7ECH)
 S $P(LA7Y,$E(LA7ECH,1),LA7J+1)=$$CHKDATA^LA7VHLU3($P(LA7ALT,"^",2),LA7FS_LA7ECH)
 S $P(LA7Y,$E(LA7ECH,1),LA7J+2)=$$CHKDATA^LA7VHLU3($P(LA7ALT,"^",3),LA7FS_LA7ECH)
 ;
 Q
 ;
 ;
OBX5 ; Build OBX-5 sequence - Observation value
 ; Removes trailing spaces on string and text results.
 ; Removes leading & trailing spaces on numeric results.
 ;
 S LA7Y=""
 ;
 I $G(LA7OBX2)="" S LA7OBX2="ST" ; default value type
 I LA7OBX2="ST"!(LA7OBX2="TX") D
 . S LA7VAL=$$TRIM^XLFSTR(LA7VAL,"R"," ")
 . S LA7Y=$$CHKDATA^LA7VHLU3(LA7VAL,LA7FS_LA7ECH)
 I LA7OBX2="NM" S LA7Y=$$TRIM^XLFSTR(LA7VAL,"RL"," ")
 I LA7OBX2="TS" D
 . S LA7VAL=$$CHKDT^LA7VHLU1(LA7VAL)
 . S LA7Y=$$FMTHL7^XLFDT(LA7VAL)
 I LA7OBX2="CE" D
 . N I,X
 . F I=1:1:6 D
 . . I '$L($P(LA7VAL,"^",I)) Q
 . . S X=$$CHKDATA^LA7VHLU3($P(LA7VAL,"^",I),LA7FS_LA7ECH)
 . . S $P(LA7Y,$E(LA7ECH),I)=X
 ;
 Q
 ;
 ;
OBX5M ; Build OBX-5 sequence - Observation value - multi-line textual result
 ;
 K LA7WP
 ;
 S LA7WP=""
 S LA7TYPE=$$GET1^DID(LA7FN,LA7FLD,"","TYPE","LA7ERR(1)")
 ;
 ; Process word-processing type field.
 ; Check and encode data
 I LA7TYPE="WORD-PROCESSING" D  Q
 . N DIWF,DIWL,DIWR,X
 . S LA7WP=$$GET1^DIQ(LA7FN,LA7IENS,LA7FLD,"","LA7WP","LA7ERR(2)")
 . K ^UTILITY($J,"W")
 . S DIWL=1,DIWR=245,DIWF="",LA7I=0
 . I $$GET1^DID(+$$GET1^DID(LA7FN,LA7FLD,"","SPECIFIER","LA7ERR(1)"),.01,"","SPECIFIER","LA7ERR(3)")["L" S DIWF="N"
 . F  S LA7I=$O(LA7WP(LA7I)) Q:'LA7I  S X=LA7WP(LA7I) D ^DIWP
 . K LA7WP
 . S LA7I=0
 . F  S LA7I=$O(^UTILITY($J,"W",DIWL,LA7I)) Q:'LA7I  D
 . . S LA7WP(LA7I)=$$CHKDATA^LA7VHLU3(^UTILITY($J,"W",DIWL,LA7I,0),LA7FS_LA7ECH)
 . . I LA7I>1 S LA7WP(LA7I)=$E(LA7ECH,3)_".br"_$E(LA7ECH,3)_LA7WP(LA7I)
 . K ^UTILITY($J,"W")
 ;
 ; Free text, assumes multiple valued
 I LA7TYPE="FREE TEXT" D
 . D GETS^DIQ(LA7FN,LA7IENS,LA7FLD_"*","","LA7WP","LA7ERR")
 ;
 Q
 ;
 ;
OBX5R ; Build OBX-5 sequence with repetition - Observation value
 ;
 S (LA7I,LA7Y)=""
 F  S LA7I=$O(LA7VAL(LA7I)) Q:'LA7I  D
 . S LA7Y=LA7Y_$$OBX5^LA7VOBX(LA7VAL(LA7I),LA7OBX2,LA7FS,LA7ECH)_$E(LA7ECH,2)
 ;
 Q
 ;
 ;
OBX6 ; Build OBX-6 sequence - Units
 ;
 S LA7ECH=$G(LA7ECH),LA7Y=""
 ;
 ; Units - remove leading and trailing spaces
 I $G(LA7VAL)'="" S LA7Y=$$TRIM^XLFSTR(LA7VAL,"LR"," ")
 ;
 ; Build sequence using LOINC codes only
 ; LOINC code/code name/"LN"
 I $G(LA764061) D
 . N LA7IENS,LA7X,LA7Z
 . S LA7IENS=LA764061_","
 . D GETS^DIQ(64.061,LA7IENS,".01;1","E","LA7X")
 . ; LOINC code
 . S LA7Z=$G(LA7X(64.061,LA7IENS,.01,"E"))
 . S LA7Z=$$CHKDATA^LA7VHLU3(LA7Z,LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH,1),1)=LA7Z
 . ; LOINC code name
 . S LA7Z=$G(LA7X(64.061,LA7IENS,1,"E"))
 . S LA7Z=$$CHKDATA^LA7VHLU3(LA7Z,LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH,1),2)=LA7Z
 . S $P(LA7Y,$E(LA7ECH,1),3)="LN"
 ;
 Q
 ;
 ;
OBX7 ; Build OBX-7 sequence - Reference range
 ; Removes leading and trailing quote marks ("").
 ;
 S LA7Y=""
 ;
 I $G(LA7LOW)'="" D
 . S LA7LOW=$$TRIM^XLFSTR(LA7LOW,"RL","""")
 . I LA7LOW?1A.E S LA7Y=LA7Y_LA7LOW Q  ; alphabetic value
 . I $G(LA7HIGH)="",$E(LA7LOW)'=">" S LA7Y=">"
 . S LA7Y=LA7Y_LA7LOW
 ;
 I $G(LA7HIGH)'="" D
 . S LA7HIGH=$$TRIM^XLFSTR(LA7HIGH,"RL","""")
 . I LA7HIGH?1A.E S LA7Y=LA7Y_LA7HIGH Q  ; alphabetic value
 . I $G(LA7LOW)="" D  Q
 . . I $E(LA7HIGH)'="<" S LA7Y="<"
 . . S LA7Y=LA7Y_LA7HIGH
 . S LA7Y=LA7Y_"-"_LA7HIGH
 ;
 S LA7Y=$$CHKDATA^LA7VHLU3(LA7Y,LA7FS_LA7ECH)
 ;
 Q
