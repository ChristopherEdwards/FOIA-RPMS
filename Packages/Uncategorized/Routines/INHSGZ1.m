INHSGZ1 ; cmi/flag/maw - JSH,DGH 20 Dec 1999 09:24 Interface - script generator for OUTPUT scripts ; [ 05/10/2002 3:16 PM ]
 ;;3.01;BHL IHS Interfaces with GIS;**1**;JUN 01, 2002
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 7; 17-JUL-1997
 ;COPYRIGHT 1988, 1989, 1990 SAIC
 ;
 ;This routine enters with:
 ;  FILE = file #
 ;  MESS = entry # of message
 ;  MESS(0) = zero node of message file entry
 ;
 ;This routine will set ERR to 1 if an error has occurred.
 ;
L(%C) ;Place a line in the global
 ;%C = 1: place |CR| at the end   0: do not place |CR| at the end
 S LC=LC+1,^UTILITY("INS",$J,LC)=A_$P("|CR|",U,%C) Q
 ;
OUT ;Create an outgoing script
 N LC,A,INS,SEG,X,F,LEN,FIELD,DTY,SUB,I,DL,P01,FLVL,SCREEN,INMSH9
 S BHLMIEN=MESS  ;cmi/sitka/maw setup a local variable for message ien
 S (FLVL,LC)=0,FILE(0)=FILE,MESS(7)=$G(^INTHL7M(MESS,7))
 S INSTD=$G(INSTD,"HL7")
 S A=";Script generated from '"_$P(MESS(0),U)_"' "_INSTD_" message." D L(1)
 I $D(^INTHL7M(MESS,6)) D
 . S A="MUMPS:" D L(1)
 . S X=0 F  S X=$O(^INTHL7M(MESS,6,X)) Q:'X  S A=$G(^(X,0)) D L(1)
 . S A=" " D L(1)
 S A="DATA:" D L(1)
 ;Enhance note -- dgh -- if a call is created to specify delimiters
 ;by standard, it should probably go here.
 ;Default to standard set if nothing is specified above
 D
 .;Set field separator character ("^")
 .S A="DELIM="""_$$FIELD^INHUT()_"""" D L(1)
 .;NCPDP doesn't use subdelimiters, but null SUBDELIM needed downstream
 .I $G(INSTD)="NC" S A="SUBDELIM=""""" D L(1) Q
 .;X12 Subdelimiter - LD
 .;I $G(INSTD)="X12" S A="SUBDELIM="":""" D L(1) Q
 .I $G(INSTD)="X12" S A="SUBDELIM="":""",INEOSM=$P($G(^INTHL7M(MESS,12)),U,17) D L(1)  ;cmi/maw added set of end of segment marker 7/20/2001
 .;Set component separator character ("\")
 .S A="SUBDELIM="""_$$COMP^INHUT()_"""" D L(1)
 ;Message Header (MSH) segment. Must be conditional on standard
 I $G(INSTD)="HL" D MSH
 ;I $G(INSTD)="X12" D ISA^INHSGZ23 maw original line
 ;Event Type (EVN) segment. Must only occur for HL7 messages before 2.2
 ;I INSTD="HL",$P(MESS(0),U,4)<2.2 S A="LINE ""EVN""^"""_$P(MESS(0),U,2)_"""^" D L(1) ;cmi/maw build EVN dynamically from file/tables orig
 ;Process segments
 S INS="" F  S INS=$O(^INTHL7M(MESS,1,"AS",INS)) Q:'INS  S X=$O(^(INS,0)),SEG(1)=^INTHL7M(MESS,1,X,0) D:'$P(SEG(1),U,11) SEG(X) Q:ERR
 S A="" D L(1)
 S A="END:" D L(1)
 Q
 ;
MSH ;Set up Message header (MSH) segment
 Q  ;maw added we use the file/table build for this in IHS orig
 ;
 S A="LINE ""MSH""^""\|~&""^"_$P(MESS(7),U,1)_U_$P(MESS(7),U,2)_U
 ;this is dave's suggested code
 S A="LINE ""MSH""^@INDELIMS^"_$P(MESS(7),U,1)_U_$P(MESS(7),U,2)_U ;mod
 ;
 S A=A_$P(MESS(7),U,3)_U_$P(MESS(7),U,4)_"^INTX(NOW,""TS"")^^"
 ;Message type \ event type
 S INMSH9=$P(MESS(0),U,6) D  S A=A_INMSH9
 .  ;Check for special variable
 .  I $E(INMSH9)="@" Q
 .  S INMSH9=""""_$P(MESS(0),U,6)
 .  ;Check for event type
 .  S:$L($P(MESS(0),U,2)) INMSH9=INMSH9_"\"_$P(MESS(0),U,2)
 .  S INMSH9=INMSH9_""""
 ;        message ID   Accept Ack               Appl Ack
 S A=A_"^@MESSID^"""_$P(MESS(0),U,3)_"""^"""_$P(MESS(0),U,4)_""""
 S A=A_"^@INSEQ^^"""_$P(MESS(0),U,10)_"""^"""_$P(MESS(0),U,11)_""""
 D L(1)
 Q
 ;
SEG(SEG) ;Processes a segment
 ;SEG = internal entry number in SEGMENT multiple of MESSAGE file
 S SEG(1)=^INTHL7M(MESS,1,SEG,0),SCREEN=$G(^(4)),SEG(2)=SEG,SEG=+SEG(1)
 Q:'$D(^INTHL7S(SEG,0))
 N CH,WHILE,FDFMT,INUDI,FD,FDMT,FLEN
 S SEG(0)=^(0)
 ;Q:$P(SEG(0),U,2)="MSH" cmi/maw we use file/table build for MSH
 Q:($P(MESS(0),U,4)<2.2)&($P(SEG(0),U,2)="EVN")
 ;I INSTD="X12",",ISA,GS,ST,"[$P(SEG(0),U,2) Q ;maw orig line
 ;I INSTD="X12",",ISA,GS,"[$P(SEG(0),U,2) Q ;maw modified
 K FD,FDMT,FLEN
 S A=";'"_$P(SEG(0),U,2)_"' segment" D L(1)
 ;Support for HL7 Set ID fields
 S A="^SET INSETID=0" D L(1)
 S WHILE=$P(SEG(1),U,3)!$P(SEG(1),U,4)
 S INUDI=$P(SEG(1),U,12) ;User=defined index.
 I WHILE,(INUDI="") D  Q:ERR  S A="WHILE "_WHILE(1) D L(1) I SCREEN]"" S A="SCREEN="_SCREEN D L(1)
 . I $P(SEG(1),U,3),'$P(SEG(1),U,4) D  Q
 .. N DIC S X=$P(SEG(1),U,8),DIC="^DD("_+FILE(FLVL)_",",DIC(0)="FMZ",DIC("S")="I $P(^(0),U,2)" D ^DIC I Y<0 D ERROR^INHSGZ2("Multiple field '"_X_"' not found in file #"_+FILE(FLVL)) Q
 .. S FLVL=FLVL+1,FILE(FLVL)=+$P(Y(0),U,2),WHILE(1)=$P(Y,U,2)
 . S FLVL=FLVL+1,FILE(FLVL)=+$P(SEG(1),U,5) I 'FILE(FLVL) D ERROR^INHSGZ2("No file specified in segment '"_$P(SEG(0),U)_"'")
 . S WHILE(1)=$P(^DIC(+FILE(FLVL),0),U)
 I $L(INUDI) S WHILE=1,A="WHILE """_INUDI_"""" D L(1) I SCREEN]"" S A="SCREEN="_SCREEN D L(1)
 I $D(^INTHL7M(MESS,1,SEG(2),5)) S X=0 F  S X=$O(^INTHL7M(MESS,1,SEG(2),5,X)) Q:'X  S A=$G(^(X,0)) I $L(A) S A=U_A D L(1)
 S INF="" K SUB F  S INF=$O(^INTHL7S(SEG,1,"AS",INF)) Q:'INF  S X=$O(^(INF,0)),FIELD=+^INTHL7S(SEG,1,X,0) D:$D(^INTHL7F(FIELD,0)) FIELD  Q:ERR
 ;NCPDP does not use segment ID. Setting ID  must be conditional
 S A="LINE " D
 .I $G(INSTD)'="NC" S A=A_""""_$P(SEG(0),U,2)_""""
 .S INSEGST=A
 F I=1:1 Q:'$D(FD(I))&'$O(FD(I))  S A=A_"^" D:$D(FD(I))
 . I $D(SUB(I)) D  Q
 .. I ($L(A)+$L(SUB(I)))>240 D L(0) S A=""
 .. S A=A_SUB(I) Q
 . I FD(I) S E="$E("_$P(SEG(0),U,2)_I_",1,"_FD(I)_")"
 . I 'FD(I) S E=$P(SEG(0),U,2)_I
 .;If field is fixed or min/max, FLEN(INF) will exist
 .;Also set to contain field ID for NCPDP variable fields
 . I $D(FLEN(I)) S E=E_"="_FLEN(I)
 . I ($L(A)+$L(E))>240 D L(0) S A=""
 . S A=A_E
 D L(1):(A]""&(INSEGST'=A))
 I $D(^INTHL7M(MESS,1,"ASP",SEG)) S CH=0 F  S CH=$O(^INTHL7M(MESS,1,"ASP",SEG,CH)) Q:'CH  D SEG($O(^(CH,0)))
 I WHILE S A="ENDWHILE" S FLVL=FLVL-1 D L(1)
 Q
 ;
FIELD ;Process a field
 N SVAR
 S FIELD(0)=^(0),FD(INF)="" I $O(^INTHL7F(FIELD,10,0)) G SUB
 S SVAR=$P(SEG(0),U,2)_INF
FD1 ;set a field
 N I W "." S LEN=$P(FIELD(0),U,3) S:LEN="" LEN=30
 S DTY=$P(FIELD(0),U,2),GL="",DTY(0)=$G(^INTHL7FT(+DTY,0))
 I 'DTY!(DTY(0)="") D ERROR^INHSGZ2("Field '"_$P(FIELD(0),U)_"' does not have a valid data type.") Q
 ;Determine if field length is Variable, Fixed or Min/Max.
 N LENTYP,MIN,PADC,PADP,DLM,FID
 S LENTYP=$P(FIELD(0),U,7),FID=$P(FIELD(0),U,14) D
 .S:LENTYP="" LENTYP="V"
 .;Variable field length is the default
 .I LENTYP="V" D  Q
 ..Q:$G(INSTD)'="NC"
 ..;If interface standard is NCPDP, set field identifier in FLEN array
 ..I '$L(FID) D ERROR^INHSGZ2("Field '"_$P(FIELD(0),U)_"' does not have a field identifier.") Q
 ..;NCPDP only needs last two characters of FID
 ..S:$L(FID)>2 FID=$E(FID,$L(FID)-1,$L(FID))
 ..S FLEN(INF)="V("_FID_")"
 .S MIN=+$P(FIELD(0),U,8),PADC=$P(FIELD(0),U,9),PADP=$P(FIELD(0),U,10)
 .;X12 uses delimiters for fixed (& min/max fields). HL7 & NCPDP do not.
 .S DLM=$S(INSTD="X12":1,1:0)
 .;Set NCPDP defaults
 .I $G(INSTD)="NC" D
 ..S PADP=$S($L(PADP):PADP,$P(DTY(0),U,2)="NM":"R",$P(DTY(0),U,2)="DL":"R",1:"L")
 ..S PADC=$S($L(PADC):PADC,$P(DTY(0),U,2)="NM":0,$P(DTY(0),U,2)="DL":0,1:"")
 .;Otherwise default pad position is right/justify left
 .S:PADP="" PADP="L"
 .;Set array into FLEN(INF), a companion to FD(INF).
 .S FLEN(INF)=LENTYP_PADP_"("_PADC_")"_LEN
 .;defaut min length equal one if there is no data for this field - LD
 .I LENTYP="M",'MIN S MIN=1
 .S:MIN FLEN(INF)=FLEN(INF)_","_MIN_","_DLM
 ;; Modify the character conversion
 I $G(^INTHL7F(FIELD,5))]"" S GL="^INTHL7F("_FIELD_",5)"
 I GL="",$G(^INTHL7FT(DTY,3))]"" S GL="^INTHL7FT("_DTY_",3)"
 N GL1 S GL1=""
 I $G(^INTHL7FT(DTY,5))]"",$P($G(^INTHL7F(FIELD,2)),U,4) S GL1="^INTHL7FT("_DTY_",5)"
 ;set precision, convert flag, add time if not a sub field
 I $L($TR($P($G(^INTHL7F(FIELD,2)),U,1,4),"^")) S A="^S INTHL7F2="""_$G(^INTHL7F(FIELD,2))_"""" D L(1)
 S A="SET "_SVAR_" = ",DL=$$LBTB^UTIL($G(^INTHL7F(FIELD,"C"))) S:+DL=DL DL="#"_DL
 I DL="" S A=A_"""""" D L(1) D KILL Q
 I $P(DTY(0),U,2)="ID" S A=A_"$E(INTERNAL("_DL_"),1,"_LEN_")" D L(1) D KILL Q
 ;If an outgoing transform exists, store it in script file as follows
 I (GL]"")!(GL1]"") S A=A_"INSGX\"_GL_"\"_GL1_"\"_LEN_"\"_DL D L(1) D KILL Q
 I $D(SUB(INF)) S A=A_"$E("_DL_",1,"_LEN_")" D L(1) D KILL Q
 S FD(INF)=LEN,A=A_DL D L(1)
 D KILL
 Q
KILL ;Kill if existed and was not a sub field
 I $L($TR($P($G(^INTHL7F(FIELD,2)),U,1,4),"^")) S A="^K INTHL7F2" D L(1)
 Q
 ;
SUB ;This field has subfields
 N I,I1,F S SUB(INF)=""
 S F=FIELD,I=0 F  S I=$O(^INTHL7F(F,10,"AS",I)) Q:'I  S FIELD=+^INTHL7F(F,10,+$O(^(I,0)),0) I FIELD,$D(^INTHL7F(FIELD,0)) D
 . S FIELD(0)=^(0),SVAR=$P(SEG(0),U,2)_INF_"."_I D FD1
 . S SUB(INF)=SUB(INF)_$S(SUB(INF)]"":"_SUBDELIM_",1:"")_SVAR
 Q
CNDT ;Handle CN (composite ID number and name) data type
 Q
 ;
 ;D
 ;. ;** NEW CODE ** to auto-handle CN data type
 ;. S P01=0,I(0)="",J(0)=+FILE(FLVL),DICOMPX="",DA="X(",DQI="Y(",X=DL D ^DICOMP I $L(DICOMPX),$L(DICOMPX,";")=1,+DICOMPX=+FILE(FLVL),$P(DICOMPX,U,2)=.01,$P(^DD(+DICOMPX,+$P(DICOMPX,"^",2),0),"^",2)'["P" S P01=1
 ;. S IEN=$S(P01:"NUMBER",1:"INTERNAL("_DL_")")
 ;. S ROOTFILE=$P($G(^DD(+DICOMPX,+$P(DICOMPX,U,2),0)),U,2)
 ;. S ROOTFILE=+$P(ROOTFILE,"P",2)
 ;. S ROOTFILE=$S(P01:+DICOMPX,1:ROOTFILE)
 ;. ;S A=A_"$E($$CN^INHUT1("_IEN_";"_ROOTFILE_"),1,"_LEN_")" D L(1) Q
 ;. ;S A=A_"$E("_$S(GL]"":"INSGX("""_GL_""","_IEN_"_"";"_ROOTFILE_""")",1:DL)_"),1,"_LEN_")" D L(1) Q
 ;Must call DICOMP twice
 ;   the $E will not be accepted in the first expression
 ;. S A=A_$S(GL]"":"INSGX("""_GL_""","_IEN_"_"";"_ROOTFILE_""")",1:DL) D L(1) Q
 ;.S A="SET "_SVAR_" = $E("_SVAR_",1,"_LEN_")" D L(1)
 ;
 ;D
 ;.;*** Old Code to handle CN data type ***
 ;. S P01=0,I(0)="",J(0)=+FILE(FLVL),DICOMPX="",DA="X(",DQI="Y(",X=DL D ^DICOMP I $L(DICOMPX),$L(DICOMPX,";")=1,+DICOMPX=+FILE(FLVL),$P(DICOMPX,U,2)=.01,$P(^DD(+DICOMPX,+$P(DICOMPX,"^",2),0),"^",2)'["P" S P01=1
 ;. S A=A_"$E("_$S(P01:"NUMBER",1:"INTERNAL("_DL_")")_"_SUBDELIM_("_$S(GL]"":"INSGX("""_GL_""","_DL_")",1:DL)_"),1,"_LEN_")" D L(1) Q
 Q
 ;
