AMER4 ; IHS/ANMC/GIS - ER VISIT SUMMARY ; 
 ;;3.0;ER VISIT SYSTEM;;FEB 23, 2009
 ;
EDIT ; NEED TO REEDIT??
 I $D(IOF) W @IOF
 K AMEREFLG
 S %=$P(^DPT(AMERDFN,0),U),%=$P(%,",",2,99)_" "_$P(%,",")
 W "Summary of this ER data entry session for ",%," =>"
 W ! D FORMAT,PRINT S AMERDEST="PRINT"
YN W !!,"*Do you want to make any changes" S %=2
 D YN^DICN S:%Y?1."^^" DIROUT="" D OUT^AMER I $D(AMERQUIT) Q
 I $E(%Y)=U W !,*7,"Sorry...You may not 'back up' here.  Enter '^^' if you want to exit.",!!  K % G YN
 I %Y="" S %Y=$S(%=1:"Y",1:"N")
 S (X,Y)='("Nn"[$E(%Y))
 I 'Y Q
 I $D(AMERTRG) S Y=1,AMEREFLG="" D ADM Q
 S DIR(0)="SO^1:ADMISSION SUMMARY;2:CAUSE OF VISIT;3:INJURY INFO;4:PROCEDURES;5:EXIT ASSESSMENT;6:DISPOSITION;7:DISCHARGE INFO;8:FOLLOW UP INSTRUCTIONS"
 S DIR(0)=DIR(0)_";9:ER CONSULTANTS"
 S DIR("A")="Which section do you want to edit",DIR("?")="Select one choice." D ^DIR K DIR
 I Y="" Q
 D OUT^AMER I $D(AMERQUIT) Q
 S AMEREFLG=""
ED I Y=1 D ADM Q
 S %=$P("^5;5^2;71^10;10^11;12^14;15^17;19^16;16^6;8",U,Y)
 S AMERSTRT=+%,AMERFIN=$P(%,";",2)
 D EDIT^AMERD
 Q
 ;
PRINT ; PRINT VISIT SUMMARY
 N X,Y,Z,I,T,C,L,% S L=2
 S C="ADMISSION SUMMARY^CAUSE OF VISIT^INJURY INFORMATION^ER PROCEDURES^ER CONSULTANT^EXIT ASSESSMENT^DISPOSITION^DISCHARGE INFO^FOLLOW UP INSTRUCTIONS"
 I $D(AMERTRG) S C="ADMISSION SUMMARY"
 ;IHS/OIT/SCR 10/09/08 Removed display of fields that are no longer populated
 ;I $G(^TMP("AMER",$J,2,33))=+$O(^AMER(3,"B","MOTOR VEHICLE",0)) S C=C_U_"MOTOR VEHICLE COLLISION INFO"
 F I=1:1 S X=$P(C,U,I) Q:X=""  D
 . S Y=$O(^AMER(2,"B",X,0)) I 'Y Q
 . I '$D(^TMP("AMER",$J,3,Y)) Q
 . W ?20,"---  ",X,"  ---" S T=0
 . F N=0:0 S N=$O(^TMP("AMER",$J,3,Y,N)) Q:'N  S Z=^TMP("AMER",$J,3,Y,N) D
 ..I (N=6)&(Y=38) Q  ;SCR - don't want to print "ER CONSULTANTS: YES"
 ..I Z["^"  D   ;Multiple fields are returned with this separator
 ...F I1=1:1 S Z=$P(^TMP("AMER",$J,3,Y,N),U,I1) Q:Z=""  W !,Z
 ..E  D
 ...I 'T D INC W Z S:$L(Z)<39 T=1 Q
 ... I $L(Z)<39 W ?40,Z S T=0 Q
 ...D INC W Z S T=0
 ...Q
 ..Q
 .D INC
 .Q
 Q
INC ; LINE COUNTER
 N X,Y
 S L=L+1 W !
 I '(L#($G(IOSL,24)-0)) S DIR(0)="E",DIR("A")="Press 'Return to continue" D ^DIR  W *13,?$G(IOM,80)-1,*13 K DIR,DUOUT,DTOUT,DIROUT
 Q
 ;
OT(V,T) ;ENTRY POINT FROM AMER5
 ; OUTPUT TRANSFORM
 ; 1 = DATE
 ; 2 = ER OPTIONS FILE
 ; 3 = ER LOCAL FACILITY FILE
 ; 4 = Patient
 ; 5 = Person (doctor name)
 ; 6 = Yes/No
 ; 7 = ICD9
 ; 8 = ER CONSULTANT
 N Y
 S Y=""
 I V?1.N1"^"1.E S Y=$P(V,U,2) Q Y
 I T=1 S Y=V X ^DD("DD") Q Y
 I T=2 S Y=$P($G(^AMER(3,+V,0)),U) Q Y
 I T=3 S Y=$P($G(^AMER(2.1,+V,0)),U) Q Y
 I T=4 S Y=$P($G(^DPT(+V,0)),U) Q Y
 I T=5 S Y=$P($G(^VA(200,+V,0)),U) Q Y
 I T=6 S Y=$S(V=1:"YES",1:"NO") Q Y
 I T=7 D
 .;IHS/OIT/SCR 11/18/08 allow 'local code' option instead of default which screens valid codes
 .;S Y=$P($$ICDDX^ICDCODE(+V),U,2)
 .S Y=$P($$ICDDX^ICDCODE(+V,,,1),U,2)
 .S Y=Y_"{"_$P($$ICDDX^ICDCODE(+V,,,1),U,4)_"}"
 .Q
 I T=8 S Y=$P($G(^AMER(2.9,+V,0)),U) Q Y
 Q Y
 ;
 ;
MULT(N) ; FORMATS MULTIPLES
 ; N = 10 - Procedure - contains a pointer to ER OPTIONS file
 ;                    - want to return a list of numbers and names
 ; N = 11 - Diagnosis - contains a pointer to ICD Diagnostic file
 ;                    - want to return a list of numbers and names
 ; N = 7  - ER Consultants - want to return a list of 
 ;                    - Consultant Types, times, and Person
 ;
  ;N A,X,I S A="" ;AMER*2.5*1 req 5 IHS/OIT/SCR 2/15/06 replaced with following two lines
  N A,X,I,K1,K2,K3
  S A=""
  I $D(^TMP("AMER",$J,2,N))<10 Q ""
  F I=0:0 S I=$O(^TMP("AMER",$J,2,N,I)) Q:'I  D
  .I $D(^TMP("AMER",$J,2,N,I))<10 D
  .. S X=^TMP("AMER",$J,2,N,I)
  .. S X=$$OT(X,2) I X="" Q
  .. I A]"" S A=A_"^ "
  .. S A=A_X
  ..Q
  .E  D
  ..S K1=$G(^TMP("AMER",$J,2,N,I,.01)) Q:'K1
  ..S K2=$G(^TMP("AMER",$J,2,N,I,.02))
  ..S K3=$G(^TMP("AMER",$J,2,N,I,.03))
  ..S K1=$$OT(K1,8)
  ..S K2=$$OT(K2,1)
  ..S K3=$$OT(K3,5)
  .. I A]"" S A=A_"^  "
  .. S A=A_K1_" @ "_K2_"  "_K3
  .. Q
  Q A
 ;
FORMAT ; SETS UTL ARRAY FOR VISIT SUMMARY
 N X,Y,Z,I,N,V,H,C,%,Q
 S X="QA" F  S X=$O(^AMER(2.3,"B",X)) Q:$E(X)'="Q"  D
 . S Y=$O(^AMER(2.3,"B",X,"")) I 'Y Q
 . S Z=^AMER(2.3,Y,0),Q=$P(Z,U),N=$P(Z,U,3) I 'N Q
 . S C=$P(Z,U,8) I 'C Q
 . S T=$P(Z,U,9),H=$G(^AMER(2.3,Y,2)) I H="" Q
 . I $P(Z,U,7)]"" S ^TMP("AMER",$J,3,C,N)=H_": "_$$MULT(N) Q
 . S V=$G(^TMP("AMER",$J,1+($E(Q,2)="D"),N))
 . I V]"",T S V=$$OT(V,T)
 . S ^TMP("AMER",$J,3,C,N)=H_": "_V
 . Q
 Q
 ;
ADM ; ADMISSION SEQUENCE
 N AMERTFLG,AMERXSEQ
 S AMERSTRT=2
ADM1 S AMERFIN=14 D EDIT^AMER
 I AMERQSEQ'[2 Q
 S AMERXSEQ=AMERQSEQ
 S AMERSTRT=20,AMERFIN=25 K AMERTFLG D EDIT^AMERD
 I '$D(AMERTFLG) Q
 S AMERQSEQ=AMERXSEQ
 S AMERSTRT=+$P(AMERQSEQ,";",$L(AMERQSEQ,";")-1)
 S AMERQSEQ=$P(AMERQSEQ,";",1,$L(AMERQSEQ,";")-2)_";"
 G ADM1
 Q
