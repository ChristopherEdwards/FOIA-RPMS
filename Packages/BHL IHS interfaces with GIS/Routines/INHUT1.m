INHUT1 ; FRW,DGH ; 10 Jun 99 14:37; HL7 utilities 
 ;;3.01;BHL IHS Interfaces with GIS;**16**;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;NO LINETAGS IN THIS ROUTINE ARE SUPPORTED FOR EXECUTION BY ANY
 ;SOFTWARE OUTSIDE THE GIS PACKAGE (IN*)
 ;
CE(INTCE,FILE,CODE,INDELIMS,INENC,INDIR) ;Entry point
 ;INPUT:
 ; INTCE - Coded element in format ien or ien;file
 ; FILE  - File number in format NN or global ref in format ^GL(
 ; CODE  - Coding system
 ; INDELIMS - Delimeter values 
 ; INENC - 0 don't encode, 1 Encode
 ; INDIR - O Outbound, I Inbound 
 ;OUTPUT:
 ;  ien\value\coding system
 ;  note: the actual delimiter may not be "\"
 ;
 Q:'INTCE ""
 N DLM,CE,MAP,GL,GLO,OUT,X,Y,%
 S DLM=$S($L($G(INSUBDEL)):INSUBDEL,1:$$COMP^INHUT),CODE=$G(CODE)
 ;if INTCE format ien;file or ien;file;coding, over-ride other PARAMETERS
 I INTCE[";" S FILE=$P(INTCE,";",2) S:$L(INTCE,";")=3 CODE=$P(INTCE,";",3) S INTCE=$P(INTCE,";")
 ;if FILE is in "^GL(" format, set GL=FILE, convert FILE to number
 I $E(FILE,1,1)="^" S GL=FILE,GLO=FILE_"0)",GLO=$G(@GLO),FILE=+$P(GLO,U,2)
 ;if FILE and CODE are null, quit. If CODE exists, pass as 3rd piece
 I FILE="",CODE="" Q +INTCE
 Q:FILE="" +INTCE_DLM_DLM_CODE
 ;Verify that FILE is valid. If not, quit
 I '$D(^DIC(FILE)),CODE="" Q +INTCE
 Q:'$D(^DIC(FILE)) +INTCE_DLM_DLM_CODE
 ;remaining code will only be executed if FILE is input and valid
 ;NOTE - This will only get the first map function for the file, 
 ;       even if there are multiple map funcitons for the file.
 S MAP=$O(^INVD(4090.2,"D",FILE,""))
 ;If CODE provided as input, it takes precedence. 
 ;otherwise determine coding system, if identified
 I CODE="",MAP'="" S CODE=$P(^INVD(4090.2,MAP,0),U,7)
 ;
 ;If FILE entered as file number, determine GL here
 I '$D(GL) S GL=^DIC(FILE,0,"GL")
 S GL=GL_+INTCE_",0)"
 ;If encoded character conversion required
 S:$G(INENC) CODE=$$SUBESC^INHUT7(CODE,.INDELIMS,.INDIR)
 Q:'$D(@GL) +INTCE_$S('$L(CODE):"",1:DLM_DLM_CODE)
 ;NEED TO NAVIGATE FARTHER IF .01 FIELD IS A POINTER
 S CE=@GL,CE=$TR($P(CE,U),DLM)
 ;If encoded character conversion required
 S:$G(INENC) CE=$$SUBESC^INHUT7(CE,.INDELIMS,.INDIR)
 S OUT=+INTCE_DLM_CE
 ;
 S:CODE'="" OUT=OUT_DLM_CODE
 ;
 Q OUT
 ;
CM(INTCE,FILE,CODE,INDELIMS,INENC,INDIR) ;Entry point to transform to composite data type
 ;INPUT:   same as CE module
 ;OUTPUT:
 ;  internal value (i.e. .001 field) \ external value (i.e. .01 field)
 ;
 N % S %=$$CE(INTCE,$G(FILE),"",.INDELIMS,.INENC,.INDIR) Q:'$L(%) ""
 S %=$P(%,INSUBDEL,1,2)
 Q %
 ;
CN(INTCE,FILE,CODE,INDELIMS,INENC,INDIR) ;Entry point to transform to composite data type
 ;INPUT:   same as CE module
 ;OUTPUT:
 ;  internal value (i.e. .001 field) \ formatted person name
 ;
 N %
 S %=$$CE(INTCE,$G(FILE),$G(CODE),.INDELIMS,.INENC,.INDIR) Q:'$L(%) ""
 S $P(%,INSUBDEL,2)=$$PN($P(%,INSUBDEL,2))
 Q %
 ;
PN(N,INDELIMS,INENC,INDIR) ;Transform person name to HL7 formatted person name
 ;INPUT:
 ; N - name in format LAST,FIRST MI
 ; INDELIMS - Delimeter values
 ; INENC - 0 Don't encode, 1 Encode
 ; INDIR - O Outbound
 ;OUTPUT:
 ; function - name in format LAST\FIRST\MI
 ;
 Q:'$L(N) ""
 N N0,N1,N2
 S N0=$P(N,","),N1=$P($P(N,",",2)," ",2,99),N2=$P($P(N,",",2)," ")
 ;If encoded character conversion required
 I $G(INENC) D
 .S N0=$$SUBESC^INHUT7(N0,.INDELIMS,.INDIR)
 .S N1=$$SUBESC^INHUT7(N1,.INDELIMS,.INDIR)
 .S N2=$$SUBESC^INHUT7(N2,.INDELIMS,.INDIR)
 S N=N0_INSUBDEL_N2
 S N=N_INSUBDEL_$P(N1," ",1)_INSUBDEL_$P(N1," ",2)_INSUBDEL_INSUBDEL
 Q N
 ;
HLPN(X,INSUBDEL,INDELIMS,INENC,INDIR)   ;Transform HL7 formatted person name to person name
 ;INPUT:
 ; X - name in format LAST\FIRST\MI\SUFFIX (req)
 ; INSUBDEL - HL7 component delimiter (req)
 ; INDELIMS - Delimeter values
 ; INENC - 0 Don't encode, 1 Encode
 ; INDIR - I Inbound 
 ;OUTPUT:
 ;  function - name in format LAST,FIRST MI SU
 ;
 Q:'$L(X) ""
 S X=$TR(X,".","")
 S X=$P(X,INSUBDEL)_","_$P(X,INSUBDEL,2)_$S($P(X,INSUBDEL,3)]"":" "_$P(X,INSUBDEL,3),1:"")_$S($P(X,INSUBDEL,4)]"":" "_$P(X,INSUBDEL,4),1:"")_$S($P(X,INSUBDEL,5)]"":" "_$P(X,INSUBDEL,5),1:"")
 S:$G(INENC) X=$$SUBESC^INHUT7(X,.INDELIMS,.INDIR)
 Q X
 ;
DT(X) ;Transform date format to HL7 date format
 ;INPUT:
 ;   X  - date/time in any fileman or external format
 ;OUPUT:
 ;   function - date in HL7 format
 ;
 Q:'$L(X) "" N Y,%DT S %DT="ST" D ^%DT Q:Y<0 ""
 S X=$E(Y,1,3)+1700_$E(Y,4,7)
 Q X
 ;
TS(X) ;Transform date to HL7 time stamp format
 ;INPUT:
 ;   X  - date/time in any fileman or external format
 ;OUPUT:
 ;   function - date/time in HL7 format
 ;
 Q $$TS^INHUT10(X)
 ;
FDT(X,TS) ;Transform date format to HL7 date format
 ;INPUT:
 ;   X  - date/time in any fileman or external format
 ;   TS - control variable
 ;OUPUT:
 ;   function - date in HL7 format
 ;
 Q:'$L(X) "" S TS=$G(TS)
 N Y,%DT S %DT="ST" D ^%DT Q:Y<0 ""
 Q:TS'["T" $E(Y,1,3)+1700_$E(Y,4,7)
 ;Ignores +/- Zulu offsets and time zone differences
 S X=$P(Y,".",2) S:X=24 X=""
 S X=$E(Y,1,3)+1700_$E(Y,4,7)_$E(X_"000000",1,6)
 Q X
 ;
HDT(X,INTS,INVA) ;Transform HL7 date format to internal fileman format
 ;INPUT:
 ;   X  - HL7 date/time
 ;           format- ( YYYYMMDDHHMM[SS[.SSSS]][+/-ZZZZ] \ precision )
 ;   INTS - control variable 
 ;          used as %DT if data is validated
 ;              T - time allowed ; S - seconds allowed
 ;   INVA - validate data (1 - yes ; 0 - no (def))
 ;OUPUT:
 ;   function - date in internal fileman format
 ;   X - date in internal fileman format (pass by reference)
 ;   INVA - valid data (1 valid ; 0 - invalid))
 ;
 Q $$HDT^INHUT10(X,$G(INTS),$G(INVA))
 ;
CL(X,INDELIMS,INENC,INDIR) ;Transform to coded location
 ;INPUT:
 ; INDELIMS - Delimeter values 
 ; INENC - 0 don't encode 1 encode
 ; INDIR - O Outbound, I Inbound 
 ;
 Q:'$L(X) ""
 N INCL1,INCL2
 S INCL1=+X,INCL2=$P(X,";",2)
 ;If no division get Division (#3.5) from Hosp Loc file (#40.8)
 S:'INCL2 INCL2=$P($G(^SC(+INCL1,0)),U,15)
 ;Transform location and division to coded elements
 S INCL2=$$CE(INCL2_";40.8","","",.INDELIMS,.INENC,.INDIR),INCL1=$$CE(INCL1_";44","","",.INDELIMS,.INENC,.INDIR)
 ;Check for division only
 I '$L(INCL1),$L(INCL2) S INCL1=INSUBDEL_INSUBDEL
 Q INCL1_INSUBDEL_INCL2
 ;
CC(X,INDELIMS,INENC,INDIR) ;Transform to charge code
 ; INDELIMS - Delimeter values 
 ; INENC - 0 don't encode 1 encode
 ; INDIR - O Outbound, I Inbound 
 ;
 Q:'$L(X) ""
 ;Transform MEPRS to coded element
 N INCL1,INCL2
 S INCL1=$$CE(+X_";8119","","",.INDELIMS,.INENC,.INDIR)
 S INCL2=$P(X,";",2)
 ;encoded character
 I $G(INENC) S INCL2=$$SUBESC^INHUT7(INCL2,.INDELIMS,.INDIR)
 Q INCL2_$S($L(INCL1):INSUBDEL,1:"")_INCL1
 ;
CRB(X,INDELIMS,INENC,INDIR) ;Transform to code room-bed location
 ;
 Q:'$L($TR(X,";")) ""
 N D,B,W,WI
 S B=$P(X,";",1),WI=$P(X,";",2),(D,W)=""
 ;
 ;If ward indicated then transform to CE and get MTF Code
 I WI D
 .;Transform to CE data type
 .;demote component separator to subcomponent separator
 .S W=$$CE(WI,44,.CODE,.INDELIMS,1,"O")
 .S W=$TR(W,INSUBDEL,INSUBCOM)
 .;Get Division  ->  MTF  ->  MTF Code
 .S D=+$P($G(^SC(WI,0)),U,15),D=+$P($G(^DG(40.8,D,0)),U,2),D=$P($G(^DIC(4,D,8000)),U,1)
 I $G(INENC) D
 .S D=$$SUBESC^INHUT7(D,.INDELIMS,.INDIR)
 .S B=$$SUBESC^INHUT7(B,.INDELIMS,.INDIR)
 ;
 Q W_INSUBDEL_B_INSUBDEL_INSUBDEL_D
 ;
