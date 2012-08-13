INHUT9 ;JPD ; 6 May 98 12:49;HL7 MESSAGE PARSER UTILITY 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 W !,"Not an entry point",*7
 ;
 Q
ONE(IND,INOUT,INIOM,INDNT,INSEP,INDL,INK) ;Get 1 set of nodes and 
 ;                                        separate by INSEP
 ; Input :
 ;   IND - Global or local node. ie ^INTHU(ien,3,0) or TEMP(1)
 ; INIOM - Margin Width
 ; INDNT - Indent by this number after 1st line
 ; INSEP - Separate on this value. ie |CR|
 ;  INDL - delimit using these values
 ;   INK - 1 Kill Output node upon entry 0 don't kill output node
 ; Output :
 ; INOUT - Global or local 
 ;
 N TEMP,COUNT,Y,INP,INP1,I,INSMIN
 S IND=$G(IND),INIOM=+$G(INIOM),INDNT=+$G(INDNT),INSEP=$G(INSEP)
 S INDL=$G(INDL),INK=+$G(INK),INP=$L(IND,","),COUNT=0
 S INSMIN=$S($P($G(^INRHSITE(1,0)),U,14):$P(^(0),U,14),1:2500)
 I INP>2 S INP1="" F I=1:1:($L(IND,",")-1) S INP1=INP1_$P(IND,",",I)_","
 E  S INP1=$P(IND,",",1)
 F  S IND=$Q(@IND)  Q:IND=""!(IND'[$P(INP1,")"))  D
 .I INSEP="" D PARSEDCT(IND,.INOUT,INIOM,INDNT,INDL,INK) Q
 .S TEMP=@IND
 .S COUNT=COUNT+1,Y(COUNT)=TEMP
 .I TEMP[INSEP D
 ..S TEMP=$P(TEMP,INSEP,1)
 ..S Y(COUNT)=TEMP
 ..D PARSEDCT("Y",.INOUT,INIOM,INDNT,INDL,INK)
 ..I $S<INSMIN,(INOUT'["^") N INTEMPY S INTEMPY=INOUT,INOUT="^UTILITY(""INHUT9"",$J)" K @INOUT M @INOUT=@INTEMPY K @INTEMPY,INTEMPY
 ..K Y S COUNT=0
 Q
PARSE(INIG1,IOM,INIG2,INDENT,INDL,INK) ;Set INIG array
 ;This will return INIG2 in array of 245 or less per line
 ; each line in array will take delimeted value or IOM, whichever is grtr
 ;    Input - 
 ;      INIG1 - Array or Single line of data or both
 ;      IOM - width
 ;      INDENT - Indent this number of spaces on overflow line
 ;      INDL - delimiter for line
 ;             Pass in as array or string
 ;      INK  - 0 - Don't kill INIG2 upon entry - 1 - kill INIG2
 ;    Output - INIG2 - Array of parsed data
 S IOM=+$G(IOM),INDENT=+$G(INDENT)+1,INDL=$G(INDL),INIG2=+$G(INIG2)
 S INK=$G(INK)
 I INK K INIG2
 I $D(INIG1)>1 D ARRAY(.INIG1,.INIG2,IOM,INDL,INDENT) Q
 D LINE(.INIG1,.INIG2,IOM,INDL,INDENT)
 I $L(INIG1) D SETTMP(INIG1,.INIG2,.IND)
 Q
PARSEDCT(INIG1,INIG2,IOM,INDENT,INDL,INK) ;Parse Global Array
 ; This will return a value in the indirection value of what is
 ; passed in in INIG2 from the indirection of whatever value is
 ; passed in from INIG1 in a delimted format of IOM long lines
 ;Input -
 ;  INIG1 - Name of Global or local variable to parse
 ;  IOM - width
 ;  INDENT - Indent this number of spaces on overflow line
 ;  INDL - delimiter for line
 ;         Pass in as array or string
 ;  INK  - 0 - Don't kill INIG2 upon entry - 1 - kill INIG2
 ;Output - 
 ;  INIG2 - Name of Global or local variable with parsed data in it
 ;
 N J,INFST,IND,INX
 S IOM=+$G(IOM),INDENT=+$G(INDENT)+1,INDL=$G(INDL),INIG2=$G(INIG2)
 S INFST=0,(IND,INX)="",INK=$G(INK)
 I INK K @INIG2
 S INX=$G(@INIG1)
 I $L(INX) D LINE(.INX,.INIG2,IOM,INDL,INDENT,.INFST,.IND,1)
 S J="" F  S J=$O(@INIG1@(J)) Q:J=""  D
 .S INX=INX_@INIG1@(J)
 .D LINE(.INX,.INIG2,.IOM,INDL,INDENT,.INFST,.IND,1)
 ;If there was anything left over put in array
 I $L(INX) D SETTMP(INX,.INIG2,IND,1)
 Q
ARRAY(INIG1,INIG2,IOM,INDL,INDENT) ;Parse array of data
 ; Input:
 ;      INIG1 - array of Data
 ;      IOM - Width
 ;      INDL - Delimeter(s)
 ;      INDENT - Chars to indent for overflow of line
 ; Output:
 ;      INIG2 - Array of data broken down by delimeters and IOM length
 ;
 N J,INFST,IND,INX
 S INFST=0,(IND,INX)=""
 I $D(INIG1)=11 D
 .S INX=INIG1
 .D LINE(.INX,.INIG2,IOM,INDL,INDENT,.INFST,.IND,0)
 S J="" F  S J=$O(INIG1(J)) Q:J=""  D
 .S INX=INX_INIG1(J)
 .D LINE(.INX,.INIG2,.IOM,INDL,INDENT,.INFST,.IND,0)
 I $L(INX) D SETTMP(INX,.INIG2,.IND)
 Q
LINE(INIG1,INIG2,IOM,INDL,INDENT,INFST,IND,INDCT) ;
 ; Input:
 ;      INIG1 - Single line of data
 ;      INIG2 - Array with old and new data
 ;      IOM - Width
 ;      INDL - Delimeter(s)
 ;      INDENT - Chars to indent for overflow of line
 ; Output:
 ;      INIG1 - Orig data with front part removed up to delimeter or IOM
 ;      INIG2 - Array of data broken down by delimeters and IOM length
 N OPOS,POS,J,INTMP
 S IND=$G(IND),INFST=+$G(INFST),INDCT=+$G(INDCT)
 ;get parts of line and process until less than IOM length.
 F  Q:$L(INIG1)<IOM  D
 .;get section of line up to desired length
 .S INTMP=$E(INIG1,1,IOM),OPOS=0
 .;check for delimeters
 .I $L($G(INDL)) D
 ..S POS=0
 ..;loop and look for last occurence of delimeter within section
 ..F J=1:1:$L(INDL) D
 ...F  S POS=$F(INTMP,$E(INDL,J),POS) Q:'POS  S:POS>OPOS OPOS=POS
 .;If delimeter was not found stick whole section in array
 .I 'OPOS D
 ..D SETTMP(INTMP,.INIG2,IND,INDCT)
 ..S INIG1=$E(INIG1,$L(INTMP)+1,$L(INIG1))
 .E  I OPOS D
 ..;delimeter was found, break at last occurence of it.
 ..D SETTMP($E(INTMP,1,OPOS-1),.INIG2,IND,INDCT)
 ..S INIG1=$E(INIG1,OPOS,$L(INIG1))
 .I 'INFST S INFST=1,$P(IND," ",INDENT)="",IOM=IOM-$L(IND)
 Q
 ;
SETTMP(INTMP,INX,IND,INDCT) ;set array
 ;    Input - INTMP - next set of words< or = to IOM
 ;            IND - Spaces to indent
 ;            INDCT - 1 store in indirection of output
 ;                    0 - store in array
 ;    Output  INX - temporary to go in INIG1
 N INCNT
 S IND=$G(IND),INDCT=$G(INDCT)
 I 'INDCT S INX=INX+1,INX(INX)=IND_INTMP
 E  D
 .S INCNT=+$O(@INX@(""),-1),INCNT=$G(INCNT)+1
 .S @INX@(INCNT)=IND_INTMP
 .S @INX=INCNT
 Q
ROULNCNT(ROU) ;Count lines in routine
 ;Input:
 ; ROU - Routine name
 N I,X
 I '$$ROUTEST^%ZTF(ROU) W *7,"ROUTINE NOT FOUND" Q ""
 F I=0:1 S @("X=$T("_ROU_"+"_I_"^"_ROU_")") Q:X=""
 W I," Lines of code in routine "_ROU
 Q I
