LA7VHLU3 ;VA/DALOI/JMC - HL7 Segment Utility ;JUL 06, 2010 3:14 PM
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**46,64,1027**;NOV 01, 1997
 ;
 Q
 ;
NTE(LA7TXT,LA7TYP,LA7FS,LA7ECH,LA7NTESN) ; Build NTE segment -  notes and comments
 ; Call with  LA7TXT = text to send
 ;            LA7TYP = source of comment - HL table 0105
 ;                     Default to L (ancilliary/filler)
 ;             LA7FS = HL field separator
 ;            LA7ECH = HL encoding characters
 ;          LA7NTESN = segment SET ID (pass by reference)
 ;
 ; Returns LA7Y - built segment
 ;
 N LA7Y
 ;
 S LA7FS=$G(LA7FS),LA7TXT=$G(LA7TXT)
 ; Remove leading "~" from comments
 I $E(LA7TXT,1)="~" S LA7TXT=$$TRIM^XLFSTR(LA7TXT,"L","~")
 S LA7TXT=$$CHKDATA^LA7VHLU3(LA7TXT,LA7FS_LA7ECH)
 ;
 ; Update segment SET ID
 S LA7NTESN=$G(LA7NTESN)+1
 ;
 ; Default source of comment if undefined
 I $G(LA7TYP)="" S LA7TYP="L"
 ;
 S LA7Y="NTE"_LA7FS_LA7NTESN_LA7FS_LA7TYP_LA7FS_LA7TXT_LA7FS
 ;
 Q LA7Y
 ;
 ;
CHKDATA(LA7IN,LA7CH) ; Check data to be built into an HL7 field for characters that
 ; conflict with encoding characters. Convert conflicting character using HL7 escape encoding.
 ;
 ; Call with LA7IN = data to be checked
 ;           LA7CH = HL7 delimiters to check for
 ;
 ; Returns LA7OUT - checked data, converted if appropriate
 ;
 N J,LA7DLIM,LA7ESC,LA7LEN,LA7OUT,X
 ;
 S LA7IN=$G(LA7IN),LA7CH=$G(LA7CH)
 S LA7OUT=""
 ;
 I LA7IN=""!(LA7CH="") Q LA7OUT
 ;
 ; Build array of encoding characters to check
 S LA7LEN=$L(LA7CH)
 S LA7DLIM=$S(LA7LEN=5:"FSRET",1:"SRET")
 S LA7ESC=$E(LA7CH,LA7LEN-1)
 F J=1:1:LA7LEN S LA7CH($E(LA7CH,J))=$E(LA7DLIM,J)
 ;
 ; Check each character and convert if appropiate
 F J=1:1:$L(LA7IN) D
 . S X=$E(LA7IN,J)
 . I $D(LA7CH(X)) S X=$$ENESC(LA7CH(X),LA7ESC)
 . S LA7OUT=LA7OUT_X
 ;
 Q LA7OUT
 ;
 ;
CNVFLD(LA7IN,LA7ECH1,LA7ECH2) ; Convert an encoded HL7 segment/field from one encoding scheme to another
 ; Call with   LA7IN = data to be converted
 ;           LA7ECH1 = delimiters of input
 ;           LA7ECH2 = delimiters of output
 ;
 ; Returns LA7OUT - segment/field converted to new encoding scheme
 ;
 N J,LA7DLIM,LA7ECH,LA7ESC,LA7LEN,LA7OUT,X
 ;
 S LA7IN=$G(LA7IN),LA7ECH1=$G(LA7ECH1),LA7ECH2=$G(LA7ECH2)
 S LA7OUT=""
 ;
 I LA7IN=""!(LA7ECH1="")!(LA7ECH2="") Q LA7OUT
 ;
 ; Abort if encoding schemes not equal length
 I $L(LA7ECH1)'=$L(LA7ECH2) Q LA7OUT
 ;
 ; If same then return input as output
 I LA7ECH1=LA7ECH2 Q LA7IN
 ;
 ; Determine position of HL7 ESCAPE encoding character
 ; 4th position if field separator and encoding characters passed
 ; 3rd position if only encoding characters passed
 ; Based on length of input encoding character variable
 S LA7LEN=$L(LA7ECH1)
 S LA7DLIM=$S(LA7LEN=5:"FSRET",1:"SRET")
 S LA7ESC=$E(LA7DLIM,LA7LEN-1)
 ;
 ; Build array to convert source encoding to target encoding
 F J=1:1:$L(LA7ECH1) S LA7ECH($E(LA7ECH1,J))=$E(LA7ECH2,J)
 ;
 ; Check each character and convert if appropiate
 ; If source conflicts with target encoding character
 ;    then convert to escape encoding
 ; If match on source encoding character - convert to new encoding
 F J=1:1:$L(LA7IN) D
 . S X=$E(LA7IN,J)
 . I '$D(LA7ECH(X)),LA7ECH2[X S X=$$ENESC($E(LA7DLIM,($F(LA7ECH2,X)-1)),LA7ESC)
 . I $D(LA7ECH(X)) S X=LA7ECH(X)
 . S LA7OUT=LA7OUT_X
 ;
 Q LA7OUT
 ;
 ;
ENESC(LA7X,LA7ESC) ; Encode data using HL7 escape encoding
 ; Call with   LA7X = character to encode
 ;           LA7ESC = HL7 escape encoding character
 ;
 ; Returns string of escape encoded data.
 ;
 N LA7Y
 ;
 S LA7Y=""
 S LA7Y=LA7ESC_LA7X_LA7ESC
 ;
 Q LA7Y
 ;
 ;
UNESC(LA7X,LA7CH) ; Unescape data using HL7 escape encoding
 ; Call with  LA7X = string to decode
 ;           LA7CH = HL7 delimiters (both field separator & encoding characters)
 ;
 ; Returns string of unencoded data.
 ;
 N J,LA7ESC,LA7DLIM,LA7LEN
 ;
 ; If data does not contain escape encoding then return input string as output
 S LA7LEN=$L(LA7CH),LA7ESC=$E(LA7CH,LA7LEN-1)
 I LA7X'[LA7ESC Q LA7X
 ;
 ; Build array of encoding characters to replace
 S LA7DLIM=$S(LA7LEN=5:"FSRET",1:"SRET")
 F J=1:1:LA7LEN S LA7CH(LA7ESC_$E(LA7DLIM,J)_LA7ESC)=$E(LA7CH,J)
 ;
 Q $$REPLACE^XLFSTR(LA7X,.LA7CH)
 ;
 ;
UNESCFT(LA7X,LA7CH,LA7Y) ; Unescape formatted text data using HL7 escape encoding
 ; Call with  LA7X = array to decode (pass by reference)
 ;           LA7CH = HL7 delimiters (both field separator & encoding characters)
 ;
 ; Returns    LA7Y =  array of unencoded data.
 ;
 N J,K,LA7ESC,LA7I,LA7Z,SAVX,SAVY,Z
 ;
 S J=0,LA7ESC=$E(LA7CH,$L(LA7CH)-1),(LA7I,SAVX,SAVY)=""
 F  S LA7I=$O(LA7X(LA7I)) Q:LA7I=""  D
 . S J=J+1
 . I LA7X(LA7I)'[LA7ESC,SAVY="" S LA7Y(J,0)=LA7X(LA7I) Q
 . F K=1:1:$L(LA7X(LA7I)) D
 . . S Z=$E(LA7X(LA7I),K)
 . . I Z=LA7ESC D  Q
 . . . I SAVY="" S SAVY=Z Q
 . . . S SAVY=SAVY_Z
 . . . I $P(SAVY,LA7ESC,2)=".br" S LA7Y(J,0)=$S(SAVX]"":SAVX,1:" "),SAVX="",J=J+1
 . . . I $E(SAVY,2)'="." S SAVX=SAVX_$$UNESC(SAVY,LA7CH)
 . . . S SAVY=""
 . . I SAVY]"" S SAVY=SAVY_Z Q
 . . S SAVX=SAVX_Z
 . S LA7Y(J,0)=SAVX,SAVX=""
 S LA7Y=J
 ;
 Q
