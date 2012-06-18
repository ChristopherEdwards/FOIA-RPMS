PSOLLL4 ;BHAM/JLC - LASER LABELS PRINT PMI ;11-Mar-2009 14:30;PLS
 ;;7.0;OUTPATIENT PHARMACY;**120,135,1006,1008**;DEC 1997
 ;
 ;Reference to PSNPPIO supported by DBIA 3794
 ;
 ; Modified - IHS/CIA/PLS - 03/05/04 - Retrieve PMI data for drug
 ;            IHS/MSC/PLS - 08/13/07 - EN+4 - Drug information conditional for refills
 ;                        - 03/11/09 - Restored use of VistA PMI information
 S FLAG=$$EN^PSNPPIO(+$P(RXY,"^",6),.MSG)
 ;S FLAG=$$EN^APSPPPIO(+$P(RXY,U,6),.MSG)
EN I $G(PSOIO("PMII"))]"" X PSOIO("PMII")
 ; IHS/CIA/PLS - 03/31/04 - Output Barcode containing NDC,QTY and increment counter
 S PSOY=PSOY+20
 W $$BC^CIAUBC28($TR($$NDCVAL^APSPFUNC(RX,+$G(RXFL(RX))),"-","")_","_+$G(QTY),0,50,PSOX,PSOY)
 Q:$$GET1^DIQ(9009033,PSOSITE,318)="NO"&$G(RXF)  ;IHS/MSC/PLS - 08/13/07
 S PSOY=PSOY+60
 S T=PNM_"  Rx#: "_RXN_"   "_DRUG D PRINT(T,0) S PSOY=PSOY+PSOYI
 S CONT=0 I PMIM S CONT=1 D PRINT(PMIF("T"),PMIF("H")) G CONT
 I 'FLAG D PRINT(MSG) Q
 ; IHS/CIA/PLS - 03/08/04 - Data not needed
 S T=^TMP($J,"PSNPMI",0)_": "_$G(^TMP($J,"PSNPMI","F",1,0)) D PRINT(T,1) S PSOY=PSOY+PSOYI  ; IHS/CIA/PLS - 03/05/04 - Not needed
 S T=$G(^TMP($J,"PSNPMI","C",1,0)) I T]"" D PRINT(T,1) S PSOY=PSOY+PSOYI
 ;S T=$G(^TMP($J,"PSNPMI","G",1,0)) I T]"" D PRINT(T,1) S PSOY=PSOY+PSOYI
CONT S XFONT=$E(PSOFONT,2,99),(CNT,OUT,PMIM)=0
 ; IHS/CIA/PLS - 03/08/04 - IHS uses different captions
 K A F A="W","U","H","S","M","P","I","O","N","D","R" S CNT=CNT+1,A(CNT)=A
 ;K A F A="U","H","C","A","W","S","B","O","I","T" S CNT=CNT+1,A(CNT)=A
 F J=PMIF("A"):1 Q:$G(A(J))=""  S A=A(J) I $D(^TMP($J,"PSNPMI",A,1,0)) S HDR=$S(PMIF("A")=1:1,PMIF("B")=1:1,J=PMIF("A"):0,1:1),LENGTH=0,PTEXT="" D  Q:OUT  S PSOY=PSOY+PSOYI
 . F B=PMIF("B"):1 Q:'$D(^TMP($J,"PSNPMI",A,B,0))  S TEXT=^(0) D  Q:OUT
 .. F I=1:1 Q:$E(TEXT,I)'=" "  S TEXT=$E(TEXT,2,255)
 .. F I=PMIF("I"):1:$L(TEXT," ") D STRT^PSOLLU1("FULL",$P(TEXT," ",I)_" ",.L) D  Q:OUT
 ... I LENGTH+L(XFONT)<7.1 S PTEXT=PTEXT_$P(TEXT," ",I)_" ",LENGTH=LENGTH+L(XFONT) Q
 ... S LENGTH=0,I=I-1
 ... I HDR D  Q
 .... I PSOY>PSOYM S PMIF("A")=J,PMIF("I")=I+1,PMIF("B")=B,OUT=1,PMIM=1
 .... D PRINT(PTEXT,1) S PTEXT="",HDR=0
 ... I PSOY>PSOYM S PMIF("A")=J,PMIF("I")=I+1,PMIF("B")=B,OUT=1,PMIM=1 Q
 ... D PRINT(PTEXT,0) S PTEXT=""
 .. I 'PMIM F I="I","B" S PMIF(I)=1
 . I 'PMIM S PMIF("B")=1
 . I OUT S PMIF("T")=PTEXT,PMIF("H")=HDR
 . Q:OUT  I HDR,PTEXT[":" D  Q
 .. I PSOY>PSOYM S PMIF("A")=J,PMIF("I")=I+1,PMIF("B")=B,OUT=1,PMIM=1,PMIF("T")=PTEXT,PMIF("H")=HDR Q
 .. I PTEXT]"" D PRINT(PTEXT,1)
 . I PTEXT]"",PSOY>PSOYM S PMIF("A")=J,PMIF("I")=I+1,PMIF("B")=B,OUT=1,PMIM=1,PMIF("T")=PTEXT,PMIF("H")=HDR Q
 . I PTEXT]"" D PRINT(PTEXT,0)
 Q
PRINT(T,HDR) ;
 ; Input: T - text to be printed
 ;        HDR - 0-no / 1-yes
 ;
 S HDR=+$G(HDR)
 I $G(PSOIO(PSOFONT))]"" X PSOIO(PSOFONT)
 I $G(PSOIO("ST"))]"" X PSOIO("ST")
 I HDR,$G(PSOIO(PSOFONT_"B"))]"" X PSOIO(PSOFONT_"B")
 I HDR D  G PRINT2
 . W $P(T,":"),":"
 . I $G(PSOIO(PSOFONT))]"" X PSOIO(PSOFONT)
 . W $P(T,":",2,99)
 W T
PRINT2 I $G(PSOIO("ET"))]"" X PSOIO("ET")
 W ! Q
