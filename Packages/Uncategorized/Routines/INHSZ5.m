INHSZ5 ;JSH; 16 Mar 92 08:35;Script compiler LOOKUP section handler ; 11 Nov 91   6:42 AM
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
L G L^INHSZ1
 ;
IN ;Enter code
 D QCHK^INHSZ0
 Q
 ;
OUT ;Exit code
 Q:REPEAT1&'REPEAT!LOOKUP
 D DOIT Q
 ;
DOIT ;Perform the lookup
 S:LPARAM="" LPARAM="N"
 I 'IDENT D ERROR^INHSZ0("LOOKUP cannot be done without an IDENT command.",1) Q
 S A=" S INDAS=$G(INDA) K @INV@(""IDENT.001"") I '$G(INDA) D" D L,DOWN^INHSZ1("")
 ;First Try to find a match
 D:LPARAM'="F"
 . N F S F="^"_$$REPLACE^UTIL($P(FILE,"^",2),"""","""""")
 . S A=" K DA F I=1:1:MULT S DA(I)=INDA(I)" D L
 . S Q="""""""""" S A=" K DO,DIC S:$D(FIELD) DIC(""S"")=""N X,Z I 1 S INF="_Q_",D0=Y F  S INF=$O(FIELD(INF)) Q:INF="_Q_"!'$T  X FIELD(INF) X """"S Z=""""_FIELD(INF,1) I ((X="_Q_"!(Z="_Q_"))&(FIELD(INF,0)=""""N""""))!(X=Z)""" D L
 . I MULT,MULT0["P" S A=" I IDENT?1""`""1.NP S (@INV@(""IDENT.001""),Y)=$P(IDENT,""`"",2),C=$P(^DD("_+MULT0_",.01,0),""^"",2) D Y^DIQ S IDENT=Y,MDESC(2)="".01 = ""_Y" D L D
 .. N LINE,V,DICOMPX S V="IDENT.001",DICOMPX("IDENT.001")="",LINE="MATCH IDENT.001=INTERNAL(#.01);E" D MATCH
 . S A=" S DIC="""_F_""",DIC(0)=""Y"",X=IDENT K Y S Y=-1 D:$O(@(DIC_""0)"")) ^DIC K DIC S INDA=+Y" D L
 . S A=" I 'INDA S MDESC(1)=""Ambiguous lookup - multiple matched found in '"_$S(MULT:$P(^DD(+FILE,0),U)_"' in the '",1:"")_$P(^DIC(+FILE1,0),U)_"' file"" D ERROR^INHS(.MDESC,2)" D L
 I LPARAM="N" D
 . S A=" I INDA<0 S MDESC(1)=""Entry not found in '"_$S(MULT:$P(^DD(+FILE,0),U)_"' in the '",1:"")_$P(^DIC(+FILE1,0),U)_"' file"" D ERROR^INHS(.MDESC,1)" D L
 I LPARAM="L" D
 . S A=" D:INDA<0" D L S INDL(INRL)=""
 . D LAYGO^INHSZ51
 . I 'MULT S A=" I INDA<0 S MDESC(1)=""Could not create new entry in file #"_+FILE_" ("_$P(^DIC(+FILE,0),U)_")"" D ERROR^INHS(.MDESC,2)" D L
 . I MULT S A=" I INDA<0 S MDESC(1)=""Could not create new entry in "_$P(^DD(+FILE,0),U)_" in the "_$P(^DIC(+FILE1,0),U)_" file"" D ERROR^INHS(.MDESC,2)" D L
 I LPARAM="F" D
 . S A=" D" D L S INDL(INRL)=""
 . D LAYGO^INHSZ51
 . I 'MULT S A=" I INDA<0 S MDESC(1)=""Could not create new entry in file #"_+FILE_" ("_$P(^DIC(+FILE,0),U)_")"" D ERROR^INHS(.MDESC,2)" D L
 . I MULT S A=" I INDA<0 S MDESC(1)=""Could not create new entry in "_$P(^DD(+FILE,0),U)_" in the "_$P(^DIC(+FILE1,0),U)_" file"" D ERROR^INHS(.MDESC,2)" D L
 S LOOKUP=1 D UP^INHSZ1
 S A=" K @INV@(""IDENT.001"") I $G(INDAS)<0 D ERROR^INHS(""Programmer lookup failed (""_INDAS_"") in file #"_+FILE_""",$S(INDAS=-1:2,1:1))" D L
 I 'REPEAT,'OTHER,'MULT D QCHK^INHSZ0
 Q
 ;
LOOKUP ;Handle lines in LOOKUP section
 ;Enter here with LINE array set
 N COMM
 S COMM=$$LBTB^UTIL($P(LINE," ")) I '$$CMD^INHSZ1(COMM,"SAVE^IF^ENDIF^IDENT^MATCH^PARAM^ERROR^REPEAT^ENDREPEAT^TEMPLATE^ROUTINE^LOOK") D ERROR^INHSZ0("Invalid command in LOOKUP section.",1) Q
 S X=$E($$CASECONV^UTIL(COMM,"U"),1,8) G:$T(@X)]"" @X
 G @(X_"^INHSZ51")
 ;
IF G IF^INHSZ21
 ;
ENDIF G ENDIF^INHSZ21
 ;
ERROR G ERROR^INHSZ21
 ;
IDENT ;
 Q:'$$SYNTAX^INHSZ0($P(LINE,COMM,2,99),"1."" ""1.ANP")
 N V
 S V=$$LBTB^UTIL($P(LINE," ",2,999))
 I '$D(DICOMPX(V)) D ERROR^INHSZ0("Variable '"_V_"' was not defined.",1) Q
 I $D(LVARS(V)),'REPEAT D ERROR^INHSZ0("Variable '"_V_"' was defined in a loop and cannot be used as identifier.",1) Q
 S A=" S IDENT=$G(@INV@("""_V_""")),MDESC(2)="" .01 = ""_IDENT" D L
 S IDENT=1,MCNT=2 Q
 ;
MATCH ;Match other fields
 N %1,M,F,V,V1,A1
 S %1=$$LBTB^UTIL($P(LINE," ",2,999))
 Q:'$$SYNTAX^INHSZ0(%1,"1.ANP1""=""1.ANP")
 S:%1'?1.ANP1";"1A %1=%1_";E"
 S V=$$LBTB^UTIL($P(%1,"=")),F=$$LBTB^UTIL($P($P(%1,"=",2),";")),M=$$CASECONV^UTIL($$LBTB^UTIL($P(%1,";",2)),"U")
 I '$D(DICOMPX(V)) D WARN^INHSZ0("Variable '"_V_"' was not defined.",1) S DICOMPX(V)="$G(@INV@("""_V_"""))"
 I $D(LVARS(V)),LVARS(V)'=SLVL D ERROR^INHSZ0("Variable '"_V_"' was defined at a different level.",1) Q
 I "EN"'[M D ERROR^INHSZ0("Match specifier '"_M_"' is invalid.",1) Q
 S:+F F="#"_F
 S I(0)="^"_$P(FILE,U,2),J(0)=+FILE,DQI="Y(",DA="FIELD("""_V_""",",DICOMP="",X=F
 D
 . N DS,DL,DE,V,F,M,DICOMPX D ^DICOMP
 . I $D(X),Y["D" S X=X_" S Y=X D DD^%DT S X=Y"
 I '$D(X) D ERROR^INHSZ0("Invalid field or expression: "_F,1) Q
 S A=" S FIELD("""_V_""")=""N Y "_$$REPLACE^UTIL(X,"""","""""")_"""" D L
 S I=0 F  S I=$O(X(I)) Q:'I  S A=" S FIELD("""_V_""","_I_")="""_$$REPLACE^UTIL(X(I),"""","""""")_"""" D L
 S V1=$$VEXP^INHSZ51(V),A1="$S($D("_V1_")#2:"_V1_",1:$G(@INV@("""_V_""")))",A=" S FIELD("""_V_""",1)="""_$$REPLACE^UTIL(A1,"""","""""")_"""" D L
 S MCNT=MCNT+1,A=" S FIELD("""_V_""",0)="""_M_""",MDESC("_MCNT_")="" "_$$REPLACE^UTIL(F,"""","""""")_" = ""_"_A1_"_""  ("_$S(M="E":"Exact Match",1:"Null Matches anything")_")""" D L
 Q
 ;
LOOK ;command used in REPEAT block to perform lookup
 I 'REPEAT D ERROR^INHSZ0("LOOK command only used within a REPEAT block in the LOOKUP section.",1) Q
 D DOIT Q
 ;
PARAM ;Set Lookup parameter
 S LPARAM=$$CASECONV^UTIL($$LBTB^UTIL($P(LINE," ",2,999)),"U") I "NFL"'[LPARAM!($L(LPARAM)>1) D ERROR^INHSZ0("Invalid LOOKUP specifier.",1)
 Q
 ;
