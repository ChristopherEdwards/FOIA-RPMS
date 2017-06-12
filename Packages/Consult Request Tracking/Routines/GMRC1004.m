GMRC1004 ; IHS/CIA/MGH - PRE-INSTALL ROUTINE FOR GMRC PATCH 1004 ;06-Jun-2013 20:22;DU
 ;;3.0;CONSULT/REQUEST TRACKING;**1004**;NOV 04, 2004;Build 12
 ;
ENV ;EP; environmen check
 N PATCH
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;
 S PATCH="GMRC*3.0*1003"
 I '$$PATCH(PATCH) D  Q
 .W !,"You must first install "_PATCH_"." S XPDQUIT=2
 Q
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch numb
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
 ;
PRE ;EP; beginning of pre install code
 Q
 ;
POST ;EP; beginnig of post install code
 D REGNMSP^CIAURPC("GMRC","CIAV VUECENTRIC")
 D RESET
 D XREF
 Q
RESET ;EP
 ;Loop through all the consult services and if set to S or R
 ;change S to O and R to null
 ;1 node 1st piece
 N I,DATA
 S I=0
 F  S I=$O(^GMR(123.5,I)) Q:'+I  D
 .S DATA=$G(^GMR(123.5,I,1))
 .I $P(DATA,U,1)="R" D UPDATE(I,"")
 .I $P(DATA,U,1)="S" D UPDATE(I,"O")
 Q
UPDATE(IEN,VALUE) ;Update data
 N FDA
 S FDA(123.5,I_",",1.01)=VALUE
 D FILE^DIE("E","FDA")
 Q
XREF ;Create a new type cross-reference
 N XREF,RESULT,MSG
 S XREF("TYPE")="R"
 S XREF("NAME")="APRV"
 S XREF("SHORT DESCR")="Problems by provider."
 S XREF("DESCR",1)="This cross-reference sorts consult requests that have associated problems"
 S XREF("DESCR",2)="by problem, provider and inverse date. This is used to find consults by provider"
 S XREF("DESCR",3)="for a particular problem"
 S XREF("USE")="SORTING ONLY"
 S XREF("EXECUTION")="R"
 S XREF("ACTIVITY")="IR"
 S XREF("VAL",1)=9999999.02
 S XREF("VAL",1,"SUBSCRIPT")=1
 S XREF("VAL",2)=10
 S XREF("VAL",2,"SUBSCRIPT")=2
 S XREF("VAL",3)=3
 S XREF("VAL",3,"SUBSCRIPT")=3
 S XREF("VAL",3,"XFORM FOR STORAGE")="S X=9999999-X"
 S XREF("FILE")=123
 S XREF("ROOT FILE")=123
 D CREIXN^DDMOD(.XREF,"SW",.RESULT,"","MSG")
 Q
