INHSZ2 ;JSH,DGH; 15 Oct 1999 15:50 ;Script compiler DATA section handler ; 11 Nov 91   6:42 AM 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 4; 4-SEP-1997
 ;COPYRIGHT 1988, 1989, 1990 SAIC
 ;
L G L^INHSZ1
 ;
IN ;Enter code
 Q
 ;
OUT ;Exit code
 S A=" D:'INVS MC^INHS" D L
 Q
 ;
DATA ;Handle lines in DATA section
 ;Enter here with LINE array set to current line
 ;Get command
 N COMM
 S COMM=$P($TR(LINE,"=(","  ")," ") I '$$CMD^INHSZ1(COMM,"ERROR^SUBDELIM^DELIM^SET^LINE^WHILE^ENDWHILE^TEMPLATE^GROUP^ENDGROUP^IF^ENDIF^SCREEN^BHLMIEN") D ERROR^INHSZ0("Invalid command in DATA section.",1) Q  ;cmi/maw added BHLMIEN
 S X=$$CASECONV^UTIL(COMM,"U") G:$T(@X)]"" @X
 G @(X_"^INHSZ21")
 ;
TEMPLATE ;Invoke a print template to generate lines
 G TEMPLATE^INHSZ20
 ;
LINE ;LINE statement
 N %1,I,%2,V,F,POS,LC,OUT,P,%0,PM,W
 S %1=$$LB^UTIL($P(LINE," ",2,999)),LC=0,OUT=0,%0=$P(LINE," ")
 I INSTD="NC",%1["NCID" D LINENC^INHSZ23 Q
 I MODE="O" Q:'$$SYNTAX^INHSZ0(%1,"1.ANP")
 I %0["(",MODE="O" D ERROR^INHSZ0("Pattern check only allowed in INPUT mode.",1) Q
 I %0["(" Q:'$$SYNTAX^INHSZ0($P(%0,"LINE",2),"1""(""1.ANP1"")""")
 S PM=$P($P(%0,"(",2),")")
 S A=" D:'INVS MC^INHS" D L
 G LINEO^INHSZ20:MODE="O"
LINEI ;Input mode
 S A=" D GET^INHOU(UIF,0) S LINE=$G(LINE),DO="_'GROUP D L S POS=1
 ; Initial lookup/processing logic for segment. PM is null at this point.
 I PM]"" D
 . I INSTD="NC",$G(INIDF) D  Q
 .. S WHPRE=""""""_$TR(PM,"*","")_""""","
 .. S A=" I 'MATCH,$$CHKNC^INHUT11(.LINE,"_INIDF_","""_INIDV_""") S DO=1,MATCH=1" D L
 .. S A=" E  S LCT=LCT-CNT,DO=0" D L
 . S A=" I "_$S(GROUP:"'MATCH,",1:"")_"LINE?"_$$PMTO(PM)_" S DO=1"_$S(GROUP:",MATCH=1",1:"") D L
 . S A=" E  S LCT=LCT-CNT,DO=0" D L
 ;Loop through all fields in LINE and create extraction logic for each
 S I=1,P=0 F  D  Q:ER!OUT  S I=I+1,P=P+1
 . ;Determine type of field
 . I I=$L(%1,"^"),$O(LINE(LC)) S LC=LC+1,%1=$P(%1,"^",I)_LINE(LC),I=1
 . S %2=$P(%1,"^",I),V=$$LBTB^UTIL($P(%2,"=")),F=$$LBTB^UTIL($P(%2,"=",2)) K V(0)
 . I I>$L(%1,"^")!(I=$L(%1,"^")&(%2="")) S OUT=1 Q
 . Q:V=""  S:F="" F="V"
 . I INSTD="NC"&('$G(INIDF)!'$L($G(INIDV))) D ERROR^INHSZ0("NCPDP segment "_$G(PM)_" must have an ID FIELD and an ID VALUE") Q
 . I '$$FORMAT(F) D ERROR^INHSZ0("Illegal format: '"_F_"'",1) Q
 . I V'["," D  Q:ER
 .. ;I $D(DICOMPX(V)) D WARN^INHSZ0("Duplicate Variable Usage: '"_V_"'",1)
 .. S DICOMPX(V)="$G(@INV@("""_V_"""))" S:WHILE LVARS(V)=WHILE
 . I V["," S V(0)=V D  Q:V=""
 .. F K=$L(V(0),","):-1:0 Q:'K  Q:$$LBTB^UTIL($P(V(0),",",K))]""
 .. S V="" S:K V=$$LBTB^UTIL($P(V(0),",",K))
 . ;--Extraction logic for variable-length fields.
 . I $E(F)="V" D  Q:ER
 .. I 'DELIM D ERROR^INHSZ0("Delimiter not defined.  Cannot interpret a variable field.",1) Q
 ..;NCPDP variable fields are at end of LINE and must be recognized by last two characters of field id--but stored with full identifier.
 .. I $G(INSTD)="NC" S A=" I DO F I=2:1 S X=$$PIECE^INHU(.LINE,DELIM,I) Q:'$L(X)  S:$E(X,1,2)="""_$E(V,$L(V)-1,$L(V))_""" @(""@INV@("_WHPRE_""""""_V_""""""_WHSUB_")"")=$E(X,3,$L(X))" D L Q
 .. I $E(V,1,3)'="MSH" S A=" S:DO @(""@INV@("""""_V_""""""_WHSUB_")"")=$$PIECE^INHU(.LINE,DELIM,"_(P+1)_")" D L Q
 .. ; MSH line 1 set to delimeter
 .. I $E(V,1,3)="MSH",P=1 S A=" S:DO @(""@INV@("""""_V_""""""_WHSUB_")"")=$E($G(LINE),4)" D L Q
 .. ; MSH line everything else
 .. S A=" S:DO @(""@INV@("""""_V_""""""_WHSUB_")"")=$$PIECE^INHU(.LINE,DELIM,"_P_")" D L Q
 . ;--Extraction logic for fixed-length fields.
 . I $E(F)="F" D
 .. ;--Fixed length logic is not currently specific to data types
 .. ;--In the future, it may be necessary to handle numeric fields
 .. ;--differently than alpha because the logic that strips pad
 .. ;--characters (variable PD) leaves 0000 equal to "", which
 .. ;--fails the required field check downstream.
 .. S PC=$P($P(F,"(",2),")")
 .. S A=" S:DO X=$$EXTRACT^INHU(.LINE,"_POS_","_(POS+$P(F,")",2)-1)_")",POS=POS+$P(F,")",2) D L
 .. ;For NCPCP, variable WHPRE is used to fully subscript the INV
 .. ;array into the nest. This may also work for X12. The NCPDP
 .. ;logic would work for HL7 if WHPRE is set to null, but needs
 .. ;extensive testing before replacing HL7 logic.
 .. I $G(INSTD)="NC" D  Q
 ... I PC="" S A=" S:DO @(""@INV@("_WHPRE_""""""_V_""""""_WHSUB_")"")=X" D L Q
 ... S:"Rr"[$E(F,2) A=" I DO F I=1:1:$L(X) " S:"Ll"[$E(F,2) A=" I DO F I=$L(X):-1:1 " S A=A_"Q:$E(X,I)'="""_PC_"""" D L
 ... I "Ll"[$E(F,2) S A=" S:DO @(""@INV@("_WHPRE_""""""_V_""""""_WHSUB_")"")=$E(X,1,$S($E(X,I)'="""_PC_""":I,1:0))" D L
 ... I "Rr"[$E(F,2) S A=" S:DO @(""@INV@("_WHPRE_""""""_V_""""""_WHSUB_")"")=$E(X,$S($E(X,I)'="""_PC_""":I,1:I+1),$L(X))" D L
 ...;----end of NCPDP logic
 .. I PC="" S A=" S:DO @(""@INV@("""""_V_""""""_WHSUB_")"")=X" D L Q
 .. S:"Rr"[$E(F,2) A=" I DO F I=1:1:$L(X) " S:"Ll"[$E(F,2) A=" I DO F I=$L(X):-1:1 " S A=A_"Q:$E(X,I)'="""_PC_"""" D L
 .. I "Ll"[$E(F,2) S A=" S:DO @(""@INV@("""""_V_""""""_WHSUB_")"")=$E(X,1,$S($E(X,I)'="""_PC_""":I,1:0))" D L
 .. I "Rr"[$E(F,2) S A=" S:DO @(""@INV@("""""_V_""""""_WHSUB_")"")=$E(X,$S($E(X,I)'="""_PC_""":I,1:I+1),$L(X))" D L
 . I $D(V(0)) D
 .. I 'SUBDELIM D ERROR^INHSZ0("Sub-delimiter not defined.",1) Q
 .. N I
 .. F I=1:1:$L(V(0),",") S V1=$$LBTB^UTIL($P(V(0),",",I)) Q:V1=""  D  Q:ER
 ... ;I $D(DICOMPX(V1)) D WARN^INHSZ0("Duplicate Variable Usage: '"_V1_"'",1)
 ... S A=" S:DO @(""@INV@("""""_V1_""""""_WHSUB_")"")=$P(@(""@INV@("""""_V_""""""_WHSUB_")""),SUBDELIM,"_I_")" D L S DICOMPX(V1)="$G(@INV@("""_V1_"""))" S:WHILE LVARS(V1)=WHILE
 I GROUP S A=" Q:MATCH" D L
 K INIDF,INIDV
 Q
 ;
FORMAT(%F) ;Check format string (Modified 6/1/95 to support M and V)
 ;%F = string to verify    Function returns 1 if OK, 0 otherwise
 ;Allowable formats are F=fixed, V=Variable, M=Minimum/Maximum
 N ER,MIN
 I "FVfvMm"'[$E(%F) Q 0
 ;NCPDP format for V allows more than single character
 I "Vv"[$E(%F),$G(INSTD)="NC" Q 1
 S ER=0 I "Vv"[$E(%F) Q $S($L(%F)>1:0,1:1)
 I %F["," S MIN=$P(%F,",",2),%F=$P(%F,",")
 I $E(%F,2,999)'?1A1"(".1ANP1")"1.N!("LRlr"'[$E(%F,2)) Q 0
 I $D(MIN),MIN'?.N Q 0
 Q 1
 ;
 ;
PMTO(%P) ;Convert Script Pattern string to MUMPS Pattern Match equivalent
 ;%P = script pattern
 ;Function returns MUMPS equivalent or "" if an error occured
 I %P="*" Q "1.E"
 N PAT,POS,C
 S PAT="" F I=1:1:$L(%P) S C=$E(%P,I) D
 . ;Following pattern matches changed from ANP to ANPC to meet
 . ;PWS need to have control characters in ZIL segment. This may not
 . ;be a permanent solution
 . I C="*" S PAT=PAT_".ANPC" Q
 . I C="?" S PAT=PAT_"1ANPC" Q
 . S PAT=PAT_"1"""_C_"""" Q
 Q PAT
 ;
SCREEN G SCREEN^INHSZ20
