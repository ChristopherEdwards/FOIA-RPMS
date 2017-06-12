APCM2AE0 ;IHS/CMI/LAB - IHS MU REPORT; 
 ;;1.0;MU PERFORMANCE REPORTS;**7,8**;MAR 26, 2012;Build 22
 ;
 ;
CALC(N,O) ;ENTRY POINT
 NEW Z
 S Z=N-O,Z=$FN(Z,"+,",1)
 Q Z
 ;
SB(X) ;EP - Strip 
 NEW %
 X ^DD("FUNC",$O(^DD("FUNC","B","STRIPBLANKS",0)),1)
 Q X
 ;
C(X,X2,X3) ;
 S X3=""
 I X'?.N Q $$LBLK^APCLUTL(X,7)
 D COMMA^%DTC
 S X=$$STRIP^XLFSTR(X," ")
 Q $$LBLK^APCLUTL(X,7)
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name .
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;
SETN ;EP - set numerator fields
 S APCMCYN=$$V(1,APCMRPT,N,P,APCMPROV,$S($G(APCMTOT):"T",1:"I"),APCMRPTT) ;SPDX
 Q:$P(^APCM25OB(M,0),U,6)="A"  ;no % on attestation measures
 S APCMCYP=$S(APCMCYD:((APCMCYN/APCMCYD)*100),1:"")
 Q
 ;
V(T,R,N,P,PROV,K,RT) ;EP
 NEW X,Y,Z,I,J
 I RT=1 S I=PROV_";VA(200,"
 I RT=2 S I=PROV_";AUTTLOC("
 I T=1 D  Q X
 .S J=$O(^APCMM25C(R,11,"B",I,0))
 .I 'J S X=0 Q
 .S X=$P($G(^APCMM25C(R,11,J,N)),U,P)
 Q ""
SETND ;
 S APCMDF=$P(^APCM25OB(M,0),U,8)
 S APCMNP=$P(^DD(9001304.0311,APCMDF,0),U,4),N=$P(APCMNP,";"),P=$P(APCMNP,";",2)
 S APCMCYD=$$V(1,APCMRPT,N,P,APCMPROV,$S($G(APCMTOT):"T",1:"I"),APCMRPTT)
 I $P(^APCM25OB(M,0),U,6)="A" S (APCMPRN,APCMCYN)="" Q
 S APCMNF=$P(^APCM25OB(M,0),U,9)  ;numerator field
 S APCMNP=$P(^DD(9001304.0311,APCMNF,0),U,4),N=$P(APCMNP,";"),P=$P(APCMNP,";",2)
 D SETN
 Q
MEDREC ;EP
 I APCMPTYP="P" D
 .D
 ..S M=APCMIC
 ..D W^APCM2AEH(" 7. Medication Rec 2016",0,2,APCMPTYP)
 ..;
 ..S T=">50%"
 ..D W^APCM2AEH(T,0,0,APCMPTYP,,35)
 ..;
 ..D SETND
 ..D WRATE
 ..;
 ..D WNUMDEN
 ..;
 ..D WEXCL
 ..;
 ..S I=$P(^APCM25OB(APCMIC,0),U,1)
 ..D W^APCM2AEH("N/A",0,0,APCMPTYP,,77)
 I APCMPTYP="D" D
 .D
 ..S M=APCMIC
 ..S APCMX="Medication Rec 2016"
 ..;
 ..S T=">50%"
 ..S $P(APCMX,U,2)=T
 ..;
 ..D SETND
 ..D WRATE
 ..;
 ..D WNUMDEN
 ..;
 ..D WEXCL
 ..;
 ..S I=$P(^APCM25OB(APCMIC,0),U,1)
 ..S $P(APCMX,U,7)="N/A"
 ..D W^APCM25EH(APCMX,0,2,APCMPTYP,1)
 Q
PEA ;EP
 I APCMPTYP="P" D
 .S M=APCMIC
 .D W^APCM2AEH(" 8. Patient Elec Access",0,2,APCMPTYP)
 .;
 .S T=">50%"
 .D W^APCM2AEH(T,0,0,APCMPTYP,,35)
 .;
 .D SETND
 .D WRATE
 .;
 .D WNUMDEN
 .;
 .D WEXCL
 .;
 .D W^APCM2AEH("N/A",0,0,APCMPTYP,,77)
 I APCMPTYP="D" D
 .S M=APCMIC
 .S APCMX="Patient Elec Access"
 .;
 .S T=">50%"
 .S $P(APCMX,U,2)=T
 .;
 .D SETND
 .D WRATE
 .;
 .D WNUMDEN
 .;
 .D WEXCL
 .;
 .S $P(APCMX,U,7)="N/A"
 .D W^APCM25EH(APCMX,0,2,APCMPTYP,1)
 ;VDT
 I APCMPTYP="P" D
 .D
 ..S M=$O(^APCM25OB("B","S2.020.EP.1",0))
 ..D W^APCM2AEH("    VDT 2016",0,1,APCMPTYP)
 ..;
 ..S T=">=1"
 ..D W^APCM2AEH(T,0,0,APCMPTYP,,35)
 ..;
 ..D SETND
 ..D W^APCM2AEH($$C(APCMCYN,0,9),0,0,APCMPTYP,,40)
 ..;
 ..D WNUMDEN
 ..;
 ..D WEXCL
 ..;
 ..S I=$O(^APCM25OB("B","S2.020.EP,1",0))
 ..D W^APCM2AEH("N/A",0,0,APCMPTYP,,77)
 ..I $G(APCMVDTE) D
 ...D W^APCM25EH("Note: PHR Server access failed during report generation "_$P(APCMSEME,U,2)_" which may",0,1,APCMPTYP,,0)
 ...D W^APCM25EH("have affected the numerator results for this measure. Contact your IT staff to",0,1,APCMPTYP,,0)
 ...D W^APCM25EH("resolve the error and then regenerate the report again to obtain accurate",0,1,APCMPTYP,,0)
 ...D W^APCM25EH("results.",0,1,APCMPTYP,,0)
 I APCMPTYP="D" D
 .D
 ..;S M=APCMIC
 ..S M=$O(^APCM25OB("B","S2.020.EP.1",0))  ;IHS/CMI/LAB - PATCH 8?
 ..S APCMX="VDT 2016"
 ..;
 ..S T=">=1"
 ..S $P(APCMX,U,2)=T
 ..;
 ..D SETND
 ..S $P(APCMX,U,3)=+APCMCYN  ;IHS/CMI/LAB - PATCH 8 ADDED "+"
 ..;
 ..D WNUMDEN
 ..;
 ..D WEXCL
 ..;
 ..S I=$P(^APCM25OB(APCMIC,0),U,1)
 ..S $P(APCMX,U,7)="N/A"
 ..D W^APCM25EH(APCMX,0,1,APCMPTYP,1)
 ..I $G(APCMVDTE) D
 ...D W^APCM25EH("Note: PHR Server access failed during report generation "_$P(APCMSEME,U,2)_" which may",0,1,APCMPTYP,1)
 ...D W^APCM25EH("have affected the numerator results for this measure. Contact your IT staff to",0,1,APCMPTYP,1)
 ...D W^APCM25EH("resolve the error and then regenerate the report again to obtain accurate results.",0,1,APCMPTYP,1)
 Q
SEM ;EP
 I APCMPTYP="P" D
 .D
 ..S M=APCMIC
 ..D W^APCM2AEH(" 9. Secure Messaging 2016",0,2,APCMPTYP)
 ..;
 ..S T=">=1"
 ..D W^APCM2AEH(T,0,0,APCMPTYP,,35)
 ..;
 ..;S (APCMCYN,APCMCYD,APCMCYP)=0
 ..S (APCMCYN,APCMCYD,APCMCYP)=0
 ..S APCMDF=31.02,APCMNF=31.01 D SETND^APCM25EA
 ..D W^APCM2AEH($$C(APCMCYN,0,9),0,0,APCMPTYP,,40)
 ..D W^APCM2AEH($$C(APCMCYN,0,9),0,0,APCMPTYP,,51),W^APCM2AEH($$C(APCMCYD,0,9),0,0,APCMPTYP,,61)
 ..;
 ..D WEXCL
 ..;
 ..S I=$P(^APCM25OB(APCMIC,0),U,1)
 ..D W^APCM2AEH("N/A",0,0,APCMPTYP,,77)
 ..I $G(APCMSEME) D
 ...D W^APCM25EH("Note: PHR Server access failed during report generation "_$P(APCMSEME,U,2)_" which may",0,1,APCMPTYP,,0)
 ...D W^APCM25EH("have affected the numerator results for this measure. Contact your IT staff to",0,1,APCMPTYP,,0)
 ...D W^APCM25EH("resolve the error and then regenerate the report again to obtain accurate",0,1,APCMPTYP,,0)
 ...D W^APCM25EH("results.",0,1,APCMPTYP,,0)
 I APCMPTYP="D" D
 .D
 ..S M=APCMIC
 ..S APCMX="Secure Messaging 2016"
 ..;
 ..S T=">=1"
 ..S $P(APCMX,U,2)=T
 ..;
 ..S (APCMCYN,APCMCYD,APCMCYP)=0
 ..S APCMDF=31.02,APCMNF=31.01 D SETND^APCM25EA
 ..S $P(APCMX,U,3)=APCMCYN  ;RATE IS NUMERATOR
 ..S $P(APCMX,U,4)=APCMCYN  ;NUMER
 ..S $P(APCMX,U,5)=APCMCYD  ;DENOM
 ..D WEXCL
 ..;
 ..S I=$P(^APCM25OB(APCMIC,0),U,1)
 ..S $P(APCMX,U,7)="N/A"
 ..D W^APCM25EH(APCMX,0,2,APCMPTYP,1)
 ..Q:'$G(APCMSEME)
 ..D W^APCM25EH("Note: PHR Server access failed during report generation "_$P(APCMSEME,U,2)_" which may",0,1,APCMPTYP,1)
 ..D W^APCM25EH("have affected the numerator results for this measure. Contact your IT staff to",0,1,APCMPTYP,1)
 ..D W^APCM25EH("resolve the error and then regenerate the report again to obtain accurate results.",0,1,APCMPTYP,1)
 Q
IMM ;EP
 I APCMPTYP="P" D
 .S M=APCMIC
 .D W^APCM2AEH("10. Public Health",0,2,APCMPTYP)
 .D W^APCM2AEH("    Immunization Regis*+",0,1,APCMPTYP)
 .;
 .S T="Yes"
 .D W^APCM2AEH(T,0,0,APCMPTYP,,35)
 .;
 .D SETND
 .D WRATE
 .;
 .D WNUMDEN
 .;
 .D WEXCL
 .;
 .D W^APCM2AEH("N/A",0,0,APCMPTYP,,77)
 I APCMPTYP="D" D
 .S M=APCMIC
 .S APCMX="Public Health" D W^APCM25EH(APCMX,0,2,APCMPTYP,1)
 .S APCMX="Immunization Regis*+"
 .;
 .S T="Yes"
 .S $P(APCMX,U,2)=T
 .;
 .D SETND
 .D WRATE
 .;
 .D WNUMDEN
 .;
 .D WEXCL
 .;
 .S $P(APCMX,U,7)="N/A"
 .D W^APCM25EH(APCMX,0,1,APCMPTYP,1)
 Q
SYN ;EP
 I APCMPTYP="P" D
 .S M=APCMIC
 .;D W^APCM2AEH(" 9. Public Health",0,2,APCMPTYP)
 .D W^APCM2AEH("    Syndromic Surveil*+",0,1,APCMPTYP)
 .;
 .S T="Yes"
 .D W^APCM2AEH(T,0,0,APCMPTYP,,35)
 .;
 .D SETND
 .D WRATE
 .;
 .D WNUMDEN
 .;
 .D WEXCL
 .;
 .D W^APCM2AEH("N/A",0,0,APCMPTYP,,77)
 I APCMPTYP="D" D
 .S M=APCMIC
 .;S APCMX="Public Health" D W^APCM25EH(APCMX,0,2,APCMPTYP,1)
 .S APCMX="Syndromic Surveil*+"
 .;
 .S T="Yes"
 .S $P(APCMX,U,2)=T
 .;
 .D SETND
 .D WRATE
 .;
 .D WNUMDEN
 .;
 .D WEXCL
 .;
 .S $P(APCMX,U,7)="N/A"
 .D W^APCM25EH(APCMX,0,1,APCMPTYP,1)
 Q
SR ;EP
 I APCMPTYP="P" D
 .S M=APCMIC
 .;D W^APCM2AEH(" 9. Public Health",0,2,APCMPTYP)
 .D W^APCM2AEH("    Rept to Special Reg*+",0,1,APCMPTYP)
 .;
 .S T="Yes"
 .D W^APCM2AEH(T,0,0,APCMPTYP,,35)
 .;
 .D SETND
 .D WRATE
 .;
 .D WNUMDEN
 .;
 .D WEXCL
 .;
 .D W^APCM2AEH("N/A",0,0,APCMPTYP,,77)
 I APCMPTYP="D" D
 .S M=APCMIC
 .S APCMX="Rept to Special Reg*+"
 .;
 .S T="Yes"
 .S $P(APCMX,U,2)=T
 .;
 .D SETND
 .D WRATE
 .;
 .D WNUMDEN
 .;
 .D WEXCL
 .;
 .S $P(APCMX,U,7)="N/A"
 .D W^APCM25EH(APCMX,0,1,APCMPTYP,1)
 Q
WEXCL ;
 S APCMEF=$P(^APCM25OB(M,0),U,11)
 I APCMEF]"" D
 .S APCMNP=$P(^DD(9001304.0311,APCMEF,0),U,4),N=$P(APCMNP,";"),P=$P(APCMNP,";",2)
 .S APCMEV=$$V(1,APCMRPT,N,P,APCMPROV,$S($G(APCMTOT):"T",1:"I"),APCMRPTT)
 .I APCMPTYP="P" D W^APCM25EH($S(APCMEV="N/A":"N/A",APCMEV]"":"Yes",1:"No"),0,0,APCMPTYP,,71)
 .I APCMPTYP="D" S $P(APCMX,U,6)=$S(APCMEV="N/A":"N/A",APCMEV]"":"Yes",1:"No")
 I APCMEF="" D
 .I APCMPTYP="P" D W^APCM25EH("N/A",0,0,APCMPTYP,,71)
 .S $P(APCMX,U,6)="N/A"
 Q
WRATE ;
 I APCMPTYP="P" D  Q
 .I $P(^APCM25OB(M,0),U,6)="A" D W^APCM2AEH($S(APCMCYD]"":$$LBLK^APCLUTL(APCMCYD,8),1:$$LBLK^APCLUTL("N/A",8)),0,0,APCMPTYP,,40)
 .I $P(^APCM25OB(M,0),U,6)'="A" D W^APCM2AEH($J(APCMCYP,8,2)_"%",0,0,APCMPTYP,,40)
 I $P(^APCM25OB(M,0),U,6)="A" S $P(APCMX,U,3)=$S(APCMCYD]"":APCMCYD,1:"N/A")
 I $P(^APCM25OB(M,0),U,6)'="A" S $P(APCMX,U,3)=$S($P(^APCM25OB(M,0),U,6)="A":"N/A",1:$J(APCMCYP,8,2)_"%")
 Q
WNUMDEN ;
 I APCMPTYP="P" D  Q
 .D W^APCM2AEH($S($P(^APCM25OB(M,0),U,6)="A":"    N/A",APCMCYN'?.N:"    N/A",1:$$C(APCMCYN,0,9)),0,0,APCMPTYP,,51)
 .D W^APCM2AEH($S($P(^APCM25OB(M,0),U,6)="A":"    N/A",APCMCYD'?.N:"    N/A",1:$$C(APCMCYD,0,9)),0,0,APCMPTYP,,61)
 S $P(APCMX,U,4)=$S($P(^APCM25OB(M,0),U,6)="A":"N/A",1:+APCMCYN)
 S $P(APCMX,U,5)=$S($P(^APCM25OB(M,0),U,6)="A":"N/A",1:+APCMCYD)
 Q
