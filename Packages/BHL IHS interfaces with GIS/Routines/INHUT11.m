INHUT11 ; DGH ; 11 Nov 1999 16:13 ; X12 and NCPDP utilities
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 1; 17-JUL-1997
 ;COPYRIGHT 1988, 1989, 1990 SAIC
 ;
 ;NO LINETAGS IN THIS ROUTINE ARE SUPPORTED FOR EXECUTION BY ANY
 ;SOFTWARE OUTSIDE THE GIS PACKAGE (IN*)
 Q
 ;
OPIN(X) ;Transform incoming overpunch value
 ;INPUT
 ; NCPDP overpunch value such as 32E or 25}
 ;RETURN
 ; Dollar value in normal format such as 3.50 or -2.50
 ; Negative values will have a minus sign at the start of X
 ; X will be returned with two decimal digits
 ; returns X if invalid format
 ;
 N L,N,S,R
 S R=X,X=$TR(X,"abcdefghijklmnopqr","ABCDEFGHIJKLMNOPQR")
 S L=$L(X),N=$F("{ABCDEFGHI}JKLMNOPQR",$E(X,L))-2,S=""
 Q:N<0 R
 S:N>9 N=N-10,S="-" S $E(X,L)=N
 Q S_$E(X,1,L-2)_"."_$E(X,L-1,L)
 ;
OPOUT(X) ;Transform outgoing dollar value to overpunch value 
 ;INPUT
 ; Dollar value in normal format such as 3.5 or -2.50
 ; three or more decimals are rounded to two
 ; Negative values must have minus sign at the start of X
 ; X does not have to have two decimal digits coming in
 ; 789=789.00, 78.9=78.90, 7.89=7.89, .789=0.79
 ;RETURN
 ; NCPDP overpunch value such as 32E or 25}
 ;
 N L,D,OP
 S X=$J(X,0,2),L=$L(X),D=$E(X,$L(X))+1
 S OP=$S($E(X)="-":$E("}JKLMNOPQR",D),1:$E("{ABCDEFGHI",D))
 S $E(X,L)=OP
 Q $TR(X,"+-.")
 ;
CHKNC(LINE,POS,VAL) ;Identifies an NCPDP segment based on specified values
 ;Called only from within an inbound script.
 ;INPUT:
 ; LINE = Array of INTHU global nodes the comprise a single segment.
 ; POS = Position or starting position in the segment
 ; VAL = A value or a pattern match at that position
 ;       If VAL starts with a "?", assume pattern match.
 ;       Otherwise VAL will be a string of comma-delimited values
 ;RETURN:
 ; 1 = A match was found
 ; 0 = No match
 S:'$G(POS) POS=1 Q:'$L(LINE) 0
 Q:'POS 0
 N MATCH,STR,Z,VAL1
 S MATCH=0
 I $E($G(VAL))'="?" D  Q MATCH
 .;compare $L(VAL) characters begining as POS for exact match
 .F Z=1:1 S VAL1=$P(VAL,",",Z) Q:'$L(VAL1)  D  Q:MATCH
 ..I $E(LINE,POS,(POS+$L(VAL1)-1))=VAL1 S MATCH=1
 ;
 ;Else use pattern match logic
 ;extract from position on
 S STR=$S(POS=1:LINE,1:$E(LINE,POS,$L(LINE)))
 Q @(""""_STR_""""_VAL_$S(VAL'[".ANPC":".ANPC",1:""))
 ;
CHKID(LINE,FLD,VAL) ;Identifies a segment based on specified values
 ;Intended for use for incoming X12 scripts. May not be final design.
 ;INPUT:
 ; LINE = Array of INTHU global nodes the comprise a single segment.
 ; FLD = Field number in the segment
 ; VAL = Array of values that constitute a match
 ;RETURN:
 ; 1 = A match was found
 ; 0 = No match
 N X,Z,ID
 S X=$$PIECE^INHU(.LINE,DELIM,FLD)
 Q:X="" 0
 S (ID,Z)=0 F  S Z=$O(VAL(Z)) Q:'Z  D  Q:ID
 .S:VAL(Z)=X ID=1
 Q $S(ID:1,1:0)
 ;
MEDE ;Sets MEDE header used for NCPDP outgoing messeges
 ;This function is to be called from outgoing M code for the NC MEDE ENP
 ;header segment as defined in the segment section of the message.
 ;It provides a sequence number that is no longer than 8 digits based
 ;on MESSID. $$MESSID^INHD concatenates the 8th field of the Interface 
 ;Site Parameter File (which is normally a MTF code) to a unique 
 ;sequence number. The following function strips the prefix and 
 ;insures that the number will never be more than 8 digits.
 S INA("INSEQ")=$P(MESSID,$P($G(^INRHSITE(1,0)),U,8),2)#10000000
 S INA("INLENGTH")=0
 Q
 ;
 ;
MEDET ;MEDE trailer code
 ;This function is to be called from outgoing M code for the NC MEDE END
 ;segment as defined in the segment section of the message.
 ;The NC MEDE END should be defined to have the highest sequence number,
 ;and will have no fields--only outgoing M code.
 ;This function calculates the length of the NCPCP message and stores
 ;the length in the NC MEDE HEADER, ^UTILITY("INH",$J,1).
 N INL,LEN,STR
 S LEN=$$CALCLEN^INHUT11("^UTILITY(""INH"",$J)")
 ;Pad with zeros to a total length of 4
 S INL=$TR($J(LEN,4)," ",0)
 ;Insert in UTILITY in positions 21 through 24.
 S STR=^UTILITY("INH",$J,1)
 S ^UTILITY("INH",$J,1)=$E(STR,1,20)_INL_$E(STR,25,$L(STR))
 Q
CALCLEN(G) ;Calculate the length of the NCPDP portion of the message
 ;Called from an outgoing script in the END section after all
 ;segments have been built and stored in ^UTILITY("INH",$J,line)
 ;
 N LEN,I,C,J
 ;Start counting from I=1 because MEDE header is in ^UTILITY(..,1)
 ;and it's length is not to be included in NCP count.
 S (LEN,C)=0,I=1
 F  S I=$O(@G@(I)) Q:'I  D
 .S C=C+1,LEN=LEN+$L(@G@(I))
 .I $O(@G@(I,0)) D
 ..;go through all overflow nodes
 .. S J=0 F  S J=$O(@G@(I,J)) Q:'J  S C=C+1,LEN=LEN+$L(@G@(I,J))
 .;add 1 byte for segment terminator
 .S LEN=LEN+1
 ;Decrement by 1 because last NCPDP group won't have segment terminator
 Q (LEN-1)
 ;
 ;
XREF ;Store SEQ in .17 field and set x-ref.
 ;This tag is called at end of script after it has called NEWO^INHD.
 ;INPUT:
 ; UIF is a state variable if NEWO^INHD was successful
 ; INDEST is a state variable inside the script
 ; INA("INSEQ")=sequence number
 Q:'$D(UIF)
 N INSEQ S INSEQ=+$G(INA("INSEQ")) Q:'INSEQ
 S $P(^INTHU(UIF,0),U,17)=INSEQ,^INTHU("ASEQ",INDEST,INSEQ,UIF)=""
 Q:$G(INSTD)="X12"
 ;Following x-ref only used by NCPDP transceiver
 S ^INTHU("ASEQ1",INDEST,UIF,INSEQ)=""
 Q
 ;
 ; THIS WILL CHECK FOR THE CASE $D(LINE)=1 or 10 or 11
 ; For example: $D(LINE)=11
 ; LINE="PID^A^B^^^^^^^^^"
 ; LINE(1)="THIS IS LINE1 ^^^^^"
 ; LINE(2)="THIS IS LINE2^^^^^^^^^^"
 ;
LINE(%L,%D,LCT) ;Suppress trailing null fields and suppress null segs
 ; %L = Line array to be stripped (PBR)
 ; %D = delimiter
 ; LCT = current number of line
 ;
 N I,J,CNT,N,TLCT,ORGL
 S %L=$G(%L),%D=$G(%D),TLCT=LCT
 ; Check overflow and number of overflow line
 F J=0:1 Q:'$D(%L(J+1))
 N EMPTY,CKOUT S (CKOUT,EMPTY)=0
 ;Go through each overflow line
 I J F N=J:-1:1 D  Q:'N!CKOUT
 .N STOP
 .F I=$L(%L(N)):-1:1 D  Q:CKOUT
 .. S STOP=$E(%L(N),I)
 .. I I=1,STOP="^" S TLCT=TLCT-1 K %L(N)
 ..I STOP'["^" S CKOUT=1,%L(N)=$E(%L(N),1,I)
 .;EMPTY=1 means lines in array have been checked
 .;and these lines are empty e.g LINE(1)=^^^^^^^,LINE(2)=^^^^^^^,...
 .I (N=1),(LCT-TLCT=J) S EMPTY=1,J=0
 ;Check the case that has no overflow node e.g LINE=a^^^^
 ;or has overflow node but the array lines are empty
 I 'J,$L(%L) D
 .S CNT=$L(%L,%D)
 .F I=CNT:-1:1 S A(I)=$$TB^UTIL($P(%L,%D,I)) Q:$G(A(I))'=""
 .S ORGL=$P(%L,%D,1),%L=$E(%L,1,$$TOTL(I,%L,%D))
 ; If all lines are empty then decrease segment count and line count by 1
 I $G(%L)=$G(ORGL),(EMPTY!('EMPTY&($D(%L)<9))) S %L="",LCT=LCT-1
 Q
 ;
TOTL(I,%L,%D) ;Calculate the length of valid fields
 N CNTL,K
 S CNTL=0
 F K=1:1:I S B(K)=$L($P(%L,%D,K)),CNTL=CNTL+B(K)
 S CNTL=CNTL+I-1
 Q CNTL
 ;
X1DATE() ;This is check for the X12 date stamp
 ; This function is obsolete. - ld
 N YRCOMP
 S YRCOMP=$E(DT,2,3)-$E($G(X),1,2)
 ; 2000 - 1999  e.g 00 - 99 = -99
 Q:YRCOMP<-50 ($E(DT)-1)_X
 ; 1999 - 2000 e.g 99 - 00= 99
 Q:YRCOMP>50 ($E(DT)+1)_X
 ; Use current century
 Q:$E(DT)_X
 ;
