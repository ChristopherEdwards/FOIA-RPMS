INHSGZ20 ;JSH,DGH; 20 Dec 1999 09:29 ;INHSGZ2 Inbound script cont'd
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 5; 17-JUL-1997
 ;COPYRIGHT 1988, 1989, 1990 SAIC
 ;
L(%L,%C) ;Place a line in the global
 G L1^INHSGZ2
 ;
FIELD ;Handle a field
 I $O(^INTHL7F(FIELD,10,0)) D  G:INSTD'="NC" SUB
 .I INSTD="NC" D WARN^INHSGZ2("Sub-fields not supported for NCPDP. Ignoring.")
 S (LVAR,SVAR)=$P(SEG(0),U,2)_INF
FD1 ;one field
 W "." S FIELD(0)=^INTHL7F(FIELD,0),DTY=+$P(FIELD(0),U,2),DTY(0)=$G(^INTHL7FT(DTY,0))
 I 'DTY D ERROR^INHSGZ2("Field '"_$P(FIELD(0),U)_"' does not have a Data Type.") Q
 ;--Add support for fixed and min/max fields - dgh
 ;Determine if field length is Variable, Fixed or Min/Max.
 N LENTYP,MIN,PADC,PADP,DLM,FID,LEN
 S LENTYP=$P(FIELD(0),U,7),FID=$P(FIELD(0),U,14),LEN=$P(FIELD(0),U,3)
 ;NCPDP formats will identify fields by id instead of position
 ;so SVAR is replaced by FID. (Subfields not supported for fixed)
 I $G(INSTD)="NC" S (LVAR,SVAR)=FID I '$L(FID) D ERROR^INHSGZ2("Field '"_$P(FIELD(0),U)_" requires an ID.") Q
 D
 .S:LENTYP="" LENTYP="V"
 .;Variable field length is the default
 .I LENTYP="V" D  Q
 ..Q:$G(INSTD)'="NC"
 ..;If interface standard is NCPDP, set field identifier in FLEN array
 ..;NOTE, MINMAX FORMAT WAS DONE FOR OUTGOING, NOT YET SUPPORTING INCOM.
 ..I '$L(FID) D ERROR^INHSGZ2("Field '"_$P(FIELD(0),U)_"' does not have a field identifier.") Q
 ..S FLEN(INF)="V("_FID_")"
 .S MIN=+$P(FIELD(0),U,8),PADC=$P(FIELD(0),U,9),PADP=$P(FIELD(0),U,10)
 .;Indicate Delimiter - LD (Some fixed formats use delims, others no)
 .S DLM=$P(FIELD(0),U,13)
 .;Set NCPDP defaults
 .I $G(INSTD)="NC" D  Q
 ..S PADP=$S($L(PADP):PADP,$P(DTY(0),U,2)="NM":"R",$P(DTY(0),U,2)="DL":"R",1:"L")
 ..S PADC=$S($L(PADC):PADC,$P(DTY(0),U,2)="NM":0,$P(DTY(0),U,2)="DL":0,1:" ")
 .;Otherwise default pad position is right/justify left
 .S:PADP="" PADP="L" S:PADC="" PADC=" "
 .;Inbound parsing of Min/Max will be identical to Variable
 .I LENTYP="M" S LENTYP="V"
 ;Reset LVAR to include fixed format information (not yet min/max)
 I $G(LENTYP)'="V" S LVAR=LVAR_"="_LENTYP_PADP_"("_PADC_")"_LEN
 ;--
 I $L($TR($P($G(^INTHL7F(FIELD,2)),U,1,4),"^")) S A="^S INTHL7F2="""_$G(^INTHL7F(FIELD,2))_"""" D L(.TRANS,1)
 F J=1:1:(INF-CP) S CL=CL_"^"
 S CP=INF,CL=CL_LVAR I $L(CL)>220 S A=CL D L(.DATA,0) S CL=""
 ; Do the escape conversion first if conversion flag exists
 S GL=""
 I $P($G(^INTHL7F(FIELD,2)),U,4),$G(^INTHL7FT(DTY,4))]"" S GL="^INTHL7FT("_DTY_",4)"
 ;;Do the input override
 I $G(^INTHL7F(FIELD,4))]"" S GL=GL_"^INTHL7F("_FIELD_",4)"
 ;Do the input transform if no input override
 I $G(^INTHL7F(FIELD,4))="",$G(^INTHL7FT(DTY,2))]"" S GL=GL_"^INTHL7FT("_DTY_",2)"
 ;For NCPDP, transforms and required field checks need full subscripts
 I $G(INSTD)="NC" S SVAR=$P(SEG(0),U,2)_","_SVAR
 I GL]"" S A=SVAR_$E("$",$P(SEG(1),U,6))_"$^"_$$LB^UTIL(@GL) D L(.TRANS,1)
 S MAP=$G(^INTHL7F(FIELD,50)) I MAP,$G(^("I"))=""  D:'$D(^INVD(4090.2,MAP))  Q:ERR  S A=SVAR_$E("$",$P(SEG(1),U,6))_"$^I X]"""" S X=$$MAP^INHVA2("""_$P(^INVD(4090.2,MAP,0),U)_""",X,0)"_$S($G(^INTHL7FT(DTY,50))]"":" "_^(50),1:"") D L(.TRANS,1)
 . D ERROR^INHSGZ2("Map function for field: "_$P(FIELD(0),U)_" has broken pointer.")
 I $G(^INTHL7F(FIELD,"I"))]"" S A=SVAR_"$^"_^("I") D L(.TRANS,1)
 ;Kill 2 node local if exists
 I $L($TR($P($G(^INTHL7F(FIELD,2)),U,1,4),"^")) S A="^K INTHL7F2" D L(.TRANS,1)
 I 'NOLS D PROC^INHSGZ21 Q:ERR
 D:REQ
 . I 'REPEAT S A=SVAR_$S('$P(MESS(1),U,9):"^"_$P(SEG(0),U,2)_1_"^D KILL^INHVA1("""_$P(SEG(0),U,2)_""","""_$P(FIELD(0),U)_""")",1:" ;"_$P(FIELD(0),U)) D L(.REQUIRED,1) Q
 . S REPEAT("REQ",SVAR)=$P(FIELD(0),U)
 Q
 ;
SUB ;Handle a field with subfields
 ;Subfields not supported for NCPDP
 I INSTD="NC" D WARN^INHSGZ2("Sub-fields not supported for NCPDP. Ignoring.") Q
 N I,F,I0
 S F=FIELD,(I0,I)=0 F  S I0=$O(^INTHL7F(F,10,"AS",I0)) Q:'I0  S I=I+1,Y=$G(^INTHL7F(F,10,+$O(^(I0,0)),0)),FIELD=+Y I FIELD,$D(^INTHL7F(FIELD,0)) D
 . S FIELD(0)=^INTHL7F(FIELD,0),(LVAR,SVAR)=$P(SEG(0),U,2)_INF_"."_I
 . S REQ=$P(Y,U,3),UFL=$P(Y,U,4) D FD1
 . S:$O(^INTHL7F(F,10,"AS",I0)) CL=CL_","
 Q
 ;
WP ;Handle a segment residing in a WP field
 ;Enter here with FILE(FLVL) holding the WP fields sub-dictionay number
 ;--NCPDP messages do not use word processing fields.
 ;--Changes may be needed in the WP section if future NCPDP messages do
 N MODE
 I GROUP S A="ENDGROUP" D L(.DATA,1) S GROUP=0
 S A=";'"_$P(SEG(0),U,2)_"' segment" D L(.DATA,1)
 S A="WHILE $P(DATA,DELIM)="""_$P(SEG(0),U,2)_"""" D L(.DATA,1)
 S A="LINE ^"_$P(SEG(0),U,2)_"1" D L(.DATA,1) S A="ENDWHILE" D L(.DATA,1)
 S INF0=$O(^INTHL7S(SEG,1,"AS",0)) Q:'INF0
 S FIELD=+^INTHL7S(SEG,1,INF0,0) Q:'$D(^INTHL7F(FIELD))  S MODE=$P(^(FIELD,0),U,4)
 S SEGC=SEGC+1,A="IF $D(@INV@("""_$P(SEG(0),U,2)_1_"""))" D L(.STORE,1) S A="ROUTINE=WP^INHS("_+FILE(FLVL-1)_","_MULTF_",""DIPA("""""_$P(SEG(0),U,2)_1_""""")"","_+MODE_")" D L(.STORE,1) S A="ENDIF" D L(.STORE,1)
 S MULTF=0,FLVL=FLVL-1
 Q
 ;
ROPOST ;Post field processing for REPEAT and OTHER segments
 I '$D(SVAR(.01)),$G(INSTD)'="X12" D ERROR^INHSGZ2("Segment '"_$P(SEG(0),U)_"' does not contain the .01 field of the multiple or other file.") Q
 S FSAV(+FILE(FLVL))=$P(SEG(0),U,2)_".01"
 I $P(OTHER,U,4)]"" S A="PARAM "_$S($P(OTHER,U,4)="O":"N",1:$P(OTHER,U,4)) D L(.STORE,1)
 I $O(@MUMPS@(0)) S I=0 F  S I=$O(@MUMPS@(I)) Q:'I  S A="^"_$P(@MUMPS@(I,0),"|CR|") D:$L(A)>1 L(.STORE,1)
 I $O(@SCODE@(0)) S I=0 F  S I=$O(@SCODE@(I)) Q:'I  S A=$P(@SCODE@(I,0),"|CR|") D:$L(A) L(.STORE,1)
 S A="LOOK "_$P(SEG(0),U,2)_".01" D L(.STORE,1)
 D:'NOSTORE
 . I $P(OTHER,U,3)]""!$D(T) S A="TEMPLATE = ["_$TR($S($P(OTHER,U,3)]"":$P(OTHER,U,3),1:T),"[]")_"]" D L(.STORE,1)
 . I $G(@ROUTINE)]"" S X=@ROUTINE S:$P(X,"(")'[U X=U_X S A="ROUTINE = "_X D L(.STORE,1)
 . I INAUDIT S Z=ARSEG($P(SEG(0),U,2)),A="ROUTINE = "_$P(SEG(0),U,2)_U_ARNAME_$S(Z>1:$C(63+Z),1:"") D L(.STORE,1)
 Q
 ;
ROPOST1 ;Post segment processing
 S FLVL=FLVL-1,A=$S(OTHER:"ENDOTHER",1:"ENDMULT") D L(.STORE,1) S A="ENDIF" D L(.STORE,1) S A="" D L(.STORE,1)
 Q
