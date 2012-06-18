PSOLLL7 ;BHAM/JLC - LASER LABEL MULTI RX REFILL REQUEST FORM ;09-Mar-2004 09:29;PLS
 ;;7.0;OUTPATIENT PHARMACY;**120**;DEC 1997
 ;
 ;Reference to ^PS(59.7 supported by DBIA 694
 ;Reference to ^PS(55 supported by DBIA 2228
 ;
 ; Modified - IHS/CIA/PLS - 03/05/04
EN D MAIL
 I $G(PSOIO("PII"))]"" X PSOIO("PII")
 S T="Use the adhesive label above to mail prescription" D PRINT(T)
 S T="documents to your pharmacy." D PRINT(T)
REFILL Q:'DFN  S PS1=$G(^PS(59,PSOSITE,1)),PSOSITE7=$G(^("IB")),PSOSYS=$G(^PS(59.7,1,40.1))
 I '$D(PSSPND) F PSRX=0:0 S PSRX=$O(RX(PSRX)) Q:'PSRX  K RX(PSRX)
 S BLNKLIN="",$P(BLNKLIN,"_",45)="_"
 F PSRX=0:0 S PSRX=$O(^PS(55,DFN,"P",PSRX)) Q:'PSRX  D RZX
 ;NEW LABEL
 S PSOX=0
DOCNEW I $G(PSOIO("RPI"))]"" X PSOIO("RPI")
 S PSOYI=PSOTYI,PSOX=PSOLX,ORIGY=PSOY
 D HDR S PSA=0
 F J=1:1 S PSA=$O(RX(PSA)) Q:'PSA  D SCRPTNEW
 I $O(RX(0))="" G EXIT
 I PSOY=ORIGY G EXIT
 S PSOYI=PSOSYI,T=BLNKLIN D PRINT(T) S PSOYI=PSOTYI
 S T="Patient's Signature & Date        "_$P(PS,"^",6)_"     "_PSONOW D PRINT(T)
EXIT K PSINF,AMC,PSA,PSDFN,PSDO,PSDT2,PSRFL,PSRX,PSLN,PSRXX,PSSS,PSST,PSOCR,DIWL,DIWR,DIWF,PSO9 Q
SCRPTNEW S T="____"_$$ZZ^PSOSUTL(PSA) K ZDRUG D PRINT(T) S PSOYI=PSOTYI
 D DTCONNW
 S PSOYI=PSOTYI,OPSOX=PSOX,PSOX=PSOX+PSOXI,T="Refills "_$P(RX(PSA),"^",2)_"   Exp "_PSDT2_"    Rx# "_$P(^PSRX(PSA,0),"^") K TN D PRINT(T)
 S PSOYI=PSOBYI
 ; IHS/CIA/PLS - 03/08/04 - Changed to use barcode output routine
 ;I $G(PSOIO("SBT"))]"" X PSOIO("SBT")
 S X2=PSOINST_"-"_PSA,PSOX=PSOX+PSOXI
 ;W X2
 W $$BC^CIAUBC28(X2,0,50,PSOX,PSOY)
 I $G(PSOIO("EBT"))]"" X PSOIO("EBT")
 S PSOX=OPSOX
 I PSOY>PSOYM D  D:$O(RX(PSA)) HDR Q
 . S T=BLNKLIN,PSOYI=PSOSYI D PRINT(T) S PSOYI=PSOTYI
 . S T="Patient's Signature & Date         "_$P(PS,"^",6)_"     "_PSONOW D PRINT(T)
 . S PSOY=ORIGY,PSOYI=PSOTYI
 . I PSOX=PSORX S PSOX=PSOLX W @IOF Q
 . S PSOX=PSORX
 Q
DTCONNW S PSDT2=$P(RX(PSA),"^"),PSDT2=$E(PSDT2,4,5)_"/"_$E(PSDT2,6,7)_"/"_($E(PSDT2,1,3)+1700) Q
RFILL2 F AMC=0:0 S AMC=$O(^PSRX(PSRXX,1,AMC)) Q:'AMC  S PSRFL=PSRFL-1
 I PSRFL>0 S X1=DT,X2=$P(^PSRX(PSRXX,0),"^",8)-10 D C^%DTC I X'<$P(^(2),"^",6) S PSRFL=0
 Q
RZX S PSRXX=+^PS(55,DFN,"P",PSRX,0)
 I $D(^PSRX(PSRXX,0)) S PSRFL=$P(^(0),"^",9) D:$D(^(1))&PSRFL RFILL2 I PSRFL>0,$P($G(^PSRX(PSRXX,"STA")),"^")<10,134'[$E(+$P($G(^("STA")),"^")),$P(^(2),"^",6)>DT S RX(PSRXX)=$P(^(2),"^",6)_"^"_PSRFL
 Q
HDR S T=PNM_"  "_SSNP D PRINT(T)
 D ADD^VADPT
 I $G(VAPA(1))="" G HDR5
 F I=1:1:3 I $G(VAPA(I))]"" S T=VAPA(I) D PRINT(T)
 S A=+$G(VAPA(5)) I A S A=$S($D(^DIC(5,A,0)):$P(^(0),"^",2),1:"UNKNOWN")
 S B=$G(VAPA(4))_", "_A_"  "_$S($G(VAPA(11)):$P(VAPA(11),"^",2),1:$G(VAPA(6)))
 S T=B D PRINT(T)
HDR5 I $O(RX(0))="" D  S PSOY=PSOY+PSOYI Q
 . S PSOY=PSOY+PSOYI,T="You have no refillable prescriptions as of "_PSONOW_"." D PRINT(T)
 . S T="Please contact your provider if you need new prescriptions." D PRINT(T)
ADD S PSOY=PSOY+PSOYI,T="Please check prescriptions to be refilled, sign the form, then" D PRINT(T)
 S T="mail or return to your pharmacy." D PRINT(T) S PSOY=PSOY+PSOYI
 Q
MAIL ;PRINT MAILING ADHESIVE LABEL
 S PS=$S($D(^PS(59,PSOSITE,0)):^(0),1:"")
 I $P(PSOSYS,"^",4),$D(^PS(59,+$P($G(PSOSYS),"^",4),0)) S PS=^PS(59,$P($G(PSOSYS),"^",4),0)
 S VAADDR1=$P(PS,"^"),VASTREET=$P(PS,"^",2),STATE=$S($D(^DIC(5,+$P(PS,"^",8),0)):$P(^(0),"^",2),1:"UNKNOWN")
 S PSZIP=$P(PS,"^",5),PSOHZIP=$S(PSZIP["-":PSZIP,1:$E(PSZIP,1,5)_$S($E(PSZIP,6,9)]"":"-"_$E(PSZIP,6,9),1:""))
 I $G(PSOIO("MLI"))]"" X PSOIO("MLI")
 I $G(PSOIO("PSOFONT"))]"" X PSOIO("PSOFONT")
 ; IHS/CIA/PLS - 03/05/04 - Changed from 119 to Pharmacy
 ;S TEXT="Attn: (119)" D PRINT(TEXT)
 S TEXT="Attn: Pharmacy" D PRINT(TEXT)
 S TEXT=VAADDR1 D PRINT(TEXT)
 S TEXT=$G(VASTREET) D PRINT(TEXT)
 S TEXT=$P(PS,"^",7)_", "_$G(STATE)_"  "_$G(PSOHZIP) D PRINT(TEXT)
 Q
PRINT(T) ;
 I $G(PSOIO(PSOFONT))]"" X PSOIO(PSOFONT)
 I $G(PSOIO("ST"))]"" X PSOIO("ST")
 W T,!
 I $G(PSOIO("ET"))]"" X PSOIO("ET")
 Q
