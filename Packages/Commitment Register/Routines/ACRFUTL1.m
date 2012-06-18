ACRFUTL1 ;IHS/OIRM/DSD/AEF - VARIOUS UTILITY SUBROUTINES [ 07/20/2006  8:00 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**5,13,16,19,20**;NOV 05, 2001
 ;
NOTA(X) ;----- ALLOW/DISALLOW TRAVEL ADVANCE
 ;      USED BY INPUT TRANSFORM ON FMS DOCUMENT FIELD TRAVEL ADVANCE
 ;      ALLOWED
 ;
 ;      INPUT:
 ;      X  =  DOCUMENT IEN
 ;
 ;      OUTPUT:
 ;      0  =  TRAVEL ADVANCE NOT ALLOWED
 ;      1  =  TRAVEL ADVANCE ALLOWED
 ;
 N ACRCAN,Y
 S Y=1
 ;
 ;----- IF ATM AUTHORIZED, NO TRAVEL ADVANCE ALLOWED
 I $P($G(^ACRDOC(X,"TO")),U,22) S Y=0
 ;
 ;----- DON'T ALLOW TRAVEL ADVANCE FOR HEADQUARTERS EAST
 S ACRCAN=$P($G(^ACRDOC(X,"REQ")),U,10)
 I ACRCAN S ACRCAN=$P($G(^AUTTCAN(ACRCAN,0)),U)
 ;I $E(ACRCAN,1,3)="J94" S Y=0 ;COMMENTED OUT TO UNBLOCK TRAVEL ADVANCES AT HQE
 ;
 Q Y
 ;
NAME(X) ;EP -- RETURNS EXTERNAL PERSON FILE 200 NAME   ;ACR*2.1*5.15
 ;
 ;      X  =  PERSON FILE 200 IEN
 ;
 N Y,Z
 S Y=""
 ;I X S Y=$P($G(^VA(200,X,0)),U)  ;ACR*2.1*19.02 IM16848
 I X S Y=$$NAME2^ACRFUTL1(X)  ;ACR*2.1*19.02 IM16848
 Q Y
NAME2(X) ;EP;   EXTRINSIC FUNCTION                   ;ACR*2.1*19.02 IM16848
 ;      X = IEN TO NEW PERSON FILE
 ;      RETURNS NAME IN   LAST,FIRST MIDDLE SUFFIX DEGREE   FORMAT
 ;      FROM NAME COMPONENTS FILE
 ;
 I '+X Q ""
 N Y,YY,Z
 K XUNAME
 S XUNAME("FILE")=200
 S XUNAME("FIELD")=.01
 S XUNAME("IENS")=X
 ;PARAMETER 2: F=FAMILY NAME FIRST  G=GIVEN NAME FIRST
 ;PARAMETER 3: P=INCLUDE PREFIX  D=INCLUDE DEGREE
 S Y=$$NAMEFMT^XLFNAME1(.XUNAME,"F","D")
 ; Need comma after last name, prompting the following code.
 ; Just in case utility doesn't return a name, go get the value from New Person.
 I Y']"" D
 .S Y=$P($G(^VA(200,XUNAME("IENS")),0),U)
 .I Y=0 S Y=""
 ;
 I Y="" Q ""
 S Z=$O(^VA(20,"BB",+XUNAME("FILE"),+$G(XUNAME("FIELD")),XUNAME("IENS")_",",0))
 I Z="" Q ""
 S Z=$P(^VA(20,Z,1),U)                    ; Last name
 S YY=$P(Y,Z_" ",2,99)                    ; Everything after last name
 S Y=Z_","_YY                             ; Last name, everything else
 Q Y
 ;
NAME3(X) ;EP;   EXTRINSIC FUNCTION                   ;ACR*2.1*19.02 IM16848
 ;      X = IEN TO NEW PERSON FILE
 ;      RETURNS NAME IN   FIRST MIDDLE LAST SUFFIX DEGREE   FORMAT
 ;      FROM NAME COMPONENTS FILE
 ;
 I '+X Q ""
 N Y
 K XUNAME
 S XUNAME("FILE")=200
 S XUNAME("FIELD")=.01
 S XUNAME("IENS")=X
 ;PARAMETER 2: F=FAMILY NAME FIRST  G=GIVEN NAME FIRST
 ;PARAMETER 3: P=INCLUDE PREFIX  D=INCLUDE DEGREE
 S Y=$$NAMEFMT^XLFNAME1(.XUNAME,"G","D")
 Q Y
 ;
NAMEFT(X) ;EP; EXTRINSIC FUNCTION
 ;     X = FREE TEXT NAME
 ;     ATTEMPTS TO RETURN LAST,FIRST
 ;
 N Y,P1,P2,PL
 S Y=""
 I X']"" Q Y
 I $E(X)=" " Q Y
 I $E(X)="-" Q Y
 S X=$$UPPER^ACRFUTL(X)                           ;MAKE SURE IS UPPER CASE
 I X'[" " Q ","_X                                 ;SINGLE NAME, PRESUMED FIRST
 S PL=$L(X," ")                                   ;Number of spaces in name
 I X["," D
 .S PL=PL-1 S X=$TR(X,",")                        ;Disregard commas
 S P2=$P(X," ",PL,PL+1)                           ;Get piece(s) after last space
 S P1=$P(X," ",1,PL-1)                            ;Get rest of pieces
 S Y=P2_","_P1
 Q Y
 ;
FYFUN(X) ;EP -- RETURNS FISCAL YEAR OF FUNDS         ; ACR*2.1*13.05 IM10810
 ;
 ;      X  =  FMS DEPARTMENT ACCOUNT IEN
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^ACRLOCB(X,"DT")),U)
 Q Y
OBJDA(X) ;EP -- RETURNS IEN OF OBJECT CLASS CODE    ;ACR*2.1*16.06 IM15505
 ;
 ;     X = EXTERNAL FORM OF OBJECT CLASS CODE
 ;
 N Y
 S Y=""
 I X,$D(^AUTTOBJC("C",X)) S Y=$O(^AUTTOBJC("C",X,0))
 Q Y
 ;
 ; New code ACR*2.1*20.14
SCREEN() ;EP -- RETURNS IF USER CAN USE SCREENMAN
 ; INPUT   none
 ; OUTPUT  Y = USER USE SCREENMAN?
 ;             1 = YES
 ;             0 = NO
 N Y
 S Y=0                                 ; Default to no screenman
 I +$G(^ACRSYS(1,"DT1")) S Y=1         ; ARMS system defaults forces screenman
 I '+Y D
 . I +$P($G(^ACRSYS(1,"DT")),U,40) D   ; ARMS SYSTEM DEFAULTS allows screenman
 . . I +$P($G(^ACRAU(DUZ,1)),U,13) D   ; ARMS User says use Screenman
 . . . S Y=1
 Q Y
 ;
 ; New code ACR*2.1*20.14
FORM(X) ;EP -- IS THERE A FORM FOR THIS INPUT TEMPLATE?
 ; INPUT   X = DR   (Input Template and Form name should be the same)
 ; OUTPUT  Y = IS THERE A FORM?
 ;             1 = YES
 ;             0 = NO
 N Y
 S Y=0
 I $G(X)="" Q 0
 S X=$TR(X,"[]","")
 I $D(^DIST(.403,"B",X)) S Y=1
 Q Y
 ;
PA(X) ;EP -- PURCHASING AGENT
 ;
 ;      INPUT:      X  =  DOCUMENT IEN
 ;      RETURNS:    Y  =  PURCHASING AGENT POINTER TO NEW PERSON FILE
 N Y
 S Y=""
 I X S Y=$P($G(^ACRDOC(X,"PA")),U)
 Q Y
 ;
STRIPTB(X) ;EP  - STRIP TRAILING BLANKS FROM STRING - ACR*2.1*20.14
 N I,ACRLEN
 I X="" Q X
 F I=$L(X):-1:1 D  Q:$G(ACRLEN)
 .Q:$E(X,I)=" "
 .S ACRLEN=I
 S X=$E(X,1,ACRLEN)
 Q X
 ;
STRIPLB(X) ;EP - STRIP LEADING BLANKS FROM STRING - ACR*2.1*20.14
 N I,ACRLEN
 I X="" Q X
 S ACRLEN=$L(X," ")
 F I=1:1:ACRLEN D  Q:$P(X," ",I)'=""
 .Q:$P(X," ",I)'=""
 S X=$P(X," ",I,ACRLEN)
 Q X
 ; New code ACR*2.1*PCARD
CC(X) ;EP -- IS THIS A REQUEST FOR CREDIT CARD PURCHASE/PAY WITH CC
 ; INPUT   X = DOCUMENT IEN
 ; OUTPUT  Y = IS THERE A FORM?
 ;             1 = YES
 ;             0 = NO
 N Y,Z
 S Z=""
 I $G(X)]"" S Z=$P(^ACRDOC(X,0),U,4)
 S Y=$S(Z=35:1,1:0)
 Q Y
