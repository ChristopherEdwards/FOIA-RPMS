AUPNCIX ; IHS/CMI/LAB - CREATE COMPOUND "AQ" INDICIES LAB&MEAS ; 
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;; MODIFIED TO SUPPORT Q-MAN 1.3 BY GIS/OHPRD MAY 24,1991
 ; The old compound index "BA" is no longer created and will be killed
 ;
VMSR04 ;EP - V MEASUREMENT:MEASUREMENT (9000010.01,.04)
 G:X="" EXIT
 S AUPNCIXK="AUPNCIX1,AUPNCIX2,AUPNCIXA,AUPNCIXB,AUPNCIXK,AUPNCIXT,AUPNCIXX,AUPNCIXY,AUPNCIXZ,AUPNCIXV"
 S AUPNCIXT=$P(^AUTTMSR(+^AUPNVMSR(DA,0),0),U)
 S AUPNCIXA="^BP^VC^VU^",AUPNCIXB="^HC^HT^WT^",AUPNCIXZ=U_AUPNCIXT_U
 I (AUPNCIXA_AUPNCIXB)'[AUPNCIXZ G EXIT
 I AUPNCIXB[AUPNCIXZ D VMSR04X G EXIT
 I AUPNCIXA[AUPNCIXZ S AUPNCIXX=$P(X,"/",1),AUPNCIXY=$P(X,"/",2) D @("VMSR04"_AUPNCIXT) G EXIT
 W !!,"AUPNCIX:VMSR04 ERROR",!!,"NOTIFY YOUR SUPERVISOR IMMEDIATELY - CROSS REFERENCE IS BAD!!"
 ;
VMSRPCT ;EP Calls ^AUPNPCT for "AQ" x-ref of .05 percentile field
 S AUPNSAVX=X,X="AUPNPCT" X ^%ZOSF("TEST") S X=AUPNSAVX K AUPNSAVX I $T D ^AUPNPCT
 Q
 ;
EXIT ; COMMON ROUTINE EXIT
 K @AUPNCIXK
 Q
 ;
VMSR04X S AUPNCIXV=$D(^AUPNVMSR("AQ",AUPNCIXT_$E("000",1,3-$L($P(X,".",1)))_X,DA)) S:AUPNCIXF="S" ^(DA)="" K:AUPNCIXF="K" ^(DA)
 Q
 ;
VMSR04B ; ENTRY POINT MAINTAINED FOR BACKWARD COMPATIBILITY
VMSR04BP S AUPNCIX1="BPS",AUPNCIX2="BPD" G VMSR04XX
VMSR04VU S AUPNCIX1="VUR",AUPNCIX2="VUL" G VMSR04XX
VMSR04VC S AUPNCIX1="VCR",AUPNCIX2="VCL"
VMSR04XX S AUPNCIXV=$D(^AUPNVMSR("AQ",AUPNCIX1_$E("000",1,3-$L(AUPNCIXX))_AUPNCIXX,DA)) S:AUPNCIXF="S" ^(DA)="" K:AUPNCIXF="K" ^(DA)
 S AUPNCIXV=$D(^AUPNVMSR("AQ",AUPNCIX2_$E("000",1,3-$L(AUPNCIXY))_AUPNCIXY,DA)) S:AUPNCIXF="S" ^(DA)="" K:AUPNCIXF="K" ^(DA)
 Q
 ;
VMSR01 ;EP V MEASUREMENT:MEASUREMENT (9000010.01,.01)
 S AUPNCIXK="AUPNCIX1,AUPNCIX2,AUPNCIXA,AUPNCIXB,AUPNCIXK,AUPNCIXT,AUPNCIXX,AUPNCIXY,AUPNCIXZ,AUPNCIXV"
 G:$P(^AUPNVMSR(DA,0),U,4)="" EXIT
 S AUPNCIXT=$P(^AUTTMSR(X,0),U)
 S AUPNCIXA="^BP^VC^VU^",AUPNCIXB="^HC^HT^WT^",AUPNCIXZ=U_AUPNCIXT_U
 I (AUPNCIXA_AUPNCIXB)'[AUPNCIXZ G EXIT
 I AUPNCIXB[AUPNCIXZ D VMSR01X G EXIT
 I AUPNCIXA[AUPNCIXZ S AUPNCIXX=$P($P(^AUPNVMSR(DA,0),U,4),"/",1),AUPNCIXY=$P($P(^AUPNVMSR(DA,0),U,4),"/",2) D @("VMSR01"_AUPNCIXT) G EXIT
 W !!,"AUPNCIX:VMSR01 ERROR",!!,"NOTIFY YOUR SUPERVISOR IMMEDIATELY - CROSS REFERENCE IS BAD!!"
 G EXIT
 ;
 ;
VMSR01X S AUPNCIXV=$D(^AUPNVMSR("AQ",AUPNCIXT_$E("000",1,3-$L($P($P(^AUPNVMSR(DA,0),U,4),".",1)))_$P(^AUPNVMSR(DA,0),U,4),DA)) S:AUPNCIXF="S" ^(DA)="" K:AUPNCIXF="K" ^(DA)
 Q
 ;
VMSR01B ; ENTRY POINT MAINTAINED FOR BACKWARD COMPATIBILITY
VMSR01BP S AUPNCIX1="BPS",AUPNCIX2="BPD" G VMSR01XX
VMSR01VU S AUPNCIX1="VUR",AUPNCIX2="VUL" G VMSR01XX
VMSR01VC S AUPNCIX1="VCR",AUPNCIX2="VCL"
VMSR01XX S AUPNCIXV=$D(^AUPNVMSR("AQ",AUPNCIX1_$E("000",1,3-$L(AUPNCIXX))_AUPNCIXX,DA)) S:AUPNCIXF="S" ^(DA)="" K:AUPNCIXF="K" ^(DA)
 S AUPNCIXV=$D(^AUPNVMSR("AQ",AUPNCIX2_$E("000",1,3-$L(AUPNCIXY))_AUPNCIXY,DA)) S:AUPNCIXF="S" ^(DA)="" K:AUPNCIXF="K" ^(DA)
 Q
 ;
AUTO ; SETS V MEASUREMENT "AQ" XREF WITHOUT CALLING FILEMAN
 K ^AUPNVMSR("AQ")
 F DA=0:0 S DA=$O(^AUPNVMSR(DA)) Q:'DA  S AUPNCIXF="S",AUPNCIXV=$G(^(DA,0)),X=$P(AUPNCIXV,U,4) I X'="" D VMSR04 W "."
 Q
AUTO1 ;
 ;
 K ^AUPNVMSR("AQ")
 F DA=0:0 S DA=$O(^AUPNVMSR(DA)) Q:'DA  S AUPNCIXF="S",AUPNCIXV=^(DA,0),X=$P(^AUPNVMSR(DA,0),U,1) D VMSR01 W "."
 Q
 ;
VLAB04 ;EP - called from input transform on .04 of vlab
 ;if entry is made from PCC Data entry AND BLRENPUT routine exists
 ;then apply input tx check on result field
 ;IHS/TUCSON/LAB - added this sub routine to support lab 5.2 - patch 6 6/23/97
 Q:DUZ=.5  ;postmaster - filegram
 Q:$D(BLRLINK)  ;in lab 5.2
 Q:'$D(APCDEIN)  ;not in direct data entry
 Q:$D(BLRCHKIP)  ;override variable is set
 Q:'$D(X)
 Q:X=""
 NEW AUPNX
 S AUPNX=X,X="BLRENPUT"
 X ^%ZOSF("TEST")
 S X=AUPNX
 I '$T S X=AUPNX K AUPNX Q
 K AUPNX
 D ^BLRENPUT
 I $D(X) K:$L(X)>200!($L(X)<1)!($D(BLRKILL)) X
 I $D(BLRKILL) D EN^DDIOL($C(7)_"Results can not be entered for this test!") K BLRKILL
 Q
 ;
VXAM04 ;EP - called from input tx on .04 field of V EXAM
 Q:'$D(X)
 Q:'$G(DA)
 NEW C S C=$P(^AUTTEXAM($P(^AUPNVXAM(DA,0),U),0),U,2)
 I X="PA",C'=34 K X Q
 I X="PR",C'=34 K X Q
 I X="PAP",C'=34 K X Q
 I X="A",C=34 K X Q
 I X="A",C=35 K X Q
 I X="A",C=36 K X Q
 I X="PO",(C'=35&(C'=36)) K X Q
 Q
VXAM04H ;EP
 D EN^DDIOL("N is a valid choice for all exam types","","!")
 D EN^DDIOL("PR, PAP, PA are only valid for Intimate Partner Violence exam type","","!")
 D EN^DDIOL("A is not valid for Intimate Partner Violence/Alcohol Screening/Depression ","","!")
 D EN^DDIOL("Screening exam types","","!")
 D EN^DDIOL("PO is valid for Depression Screening and Alcohol Screening exam types","","!")
 ;D EN^DDIOL("L, M and H are only valid for Autism in Toddlers exam","","!")
 Q
INPH ;EP - called from help 9000024
 D EN^DDIOL("Must begin with a numeric value.")
 D EN^DDIOL("Must contain a D for Days, W for Weeks, M for Months or Y for years.")
 D EN^DDIOL("Examples:  2W for 2 weeks, 10M for 10 Months, 365D for 365 days, 2Y for 2 years.")
 Q
OUTTX(%) ;EP called from input transform
 I $G(%)="" Q ""
 I %["D" Q +%_" Day"_$S(+%>1:"s",1:"")
 I %["M" Q +%_" Month"_$S(+%>1:"s",1:"")
 I %["Y" Q +%_" Year"_$S(+%>1:"s",1:"")
 I %["W" Q +%_" Week"_$S(+%>1:"s",1:"")
 Q %
INP ;EP - called from input transform 9000024
 I $G(X)="" K X Q
 I '(+X) D EN^DDIOL("Must begin with a numeric value.") K X Q
 I "MDYW"'[$E(X,$L(X)) D EN^DDIOL("Must contain a D for Days, W for Weeks, M for Months or Y for Years.") K X Q
 Q
CONVDAYS(V) ;EP
 NEW VAL
 I V="" Q ""
 I V["D" Q +V
 I V["M" S VAL=+V*30.5 Q $P(VAL,".")
 I V["Y" S VAL=+V*365 Q $P(VAL,".")
 I V["W" S VAL=+V*7 Q $P(VAL,".")
 Q ""
KGLB(V) ;EP
 I V="" Q ""
 NEW VAL
 S VAL=V*2.2046226
 Q $P(VAL,".")
KGOZ(V) ;EP
 I V="" Q ""
 NEW VAL
 S VAL=V*2.2046226
 S VAL="."_$P(VAL,".",2)
 S VAL=VAL*16
 Q $$STRIP^XLFSTR($J($P(VAL,5,0)," "))
LBKG(V) ;EP
 I V="" Q ""
 NEW VAL
 S VAL=V*.453592
 Q $$STRIP^XLFSTR(VAL," ")
OZ(V) ;EP
 NEW VAL
 I V="" Q ""
 S VAL=$P(V,".",2)
 I VAL="" Q 0
 S VAL="."_VAL
 S VAL=VAL*16
 S VAL=$$STRIP^XLFSTR(VAL," ")
 Q VAL
CMPLDATE(%) ;EP - called from trigger on TREATMENT PLAN File
 I $G(%)="" Q ""
 NEW A,B,C
 S A=$P(^AUPNTP(%,0),U,3)
 I A="" Q ""
 S B=$P(^AUPNTP(%,0),U,4)
 I B="" Q ""
 S C=$$CONVDAYS(B)
 Q $$FMADD^XLFDT(A,C)
ICD(Y,N,D) ;EP - called from input transforms
 I $$CHK(Y,N,D)
 Q:$D(^ICD9(Y))
 Q
CHK(Y,I,D) ; SCREEN OUT E CODES AND INACTIVE CODES
 I $D(DIFGLINE) Q 1
 NEW %,A,I,V
 I $G(D) G CHK1
 I $G(N) S D=$P(^AUPNTP(N,0),U,2)
 ;
CHK1 S %=$$ICDDX^ICDCODE(Y,D)  ;CSV
 I $E($P(%,U,2),1)="E" Q 0  ;no E codes ;CSV
 I $$VERSION^XPDUTL("BCSV")]"" D  I 1  ;CSV
 .S A=$P(%,U,17),I=$P(%,U,12),V=$P(%,U,10) ;CSV
 E  S A=$P($G(^ICD9(Y,9999999)),U,4),I=$P(^ICD9(Y,0),U,11)  ;CSV
 I $G(V)]"" Q V
 I D]"",I]"",D>I Q 0
 I D]"",A]"",D<A Q 0
 ;if have no date to check then check 9th piece
 I '$G(D),$S($$VERSION^XPDUTL("BCSV")]"":$P(%,U,10),1:$P(^ICD9(Y,0),U,9)) Q 0
CSEX ; IF 'USE WITH SEX' FIELD HAS A VALUE CHECK THAT VALUE AGAINST AUPNSEX
 I '$D(AUPNSEX) Q 1
 I $P(%,U,11)]"",$P(%,U,11)'=AUPNSEX Q 0
 Q 1
WT ;EP (WEIGHT)
 D:X?.E.A.E MWT
 Q:'$D(X)
 D WTC
 ;S:$P(X,".",2)?1N.N X=X+.00005,X=$P(X,".",1)_"."_$E($P(X,".",2),1,4)
 S X=+X
 Q:'$D(X)
 K:+X'=X!(X>1000) X
 Q:'$D(X)
 ;K:X-(X\1)#.0625 X
 Q
WTC Q:+X=X!(X'[" ")
 Q:'(X?1.3N1" "1.2N!(X?1.3N1" "1.2N1"/"1.2N))
 I X'["/" Q:+$P(X," ",2)>16  S X=+X+(+$P(X," ",2)/16) Q
 Q:+$P($P(X," ",2),"/",1)'<+$P($P(X," ",2),"/",2)
 S X=+X+((+$P(X," ",2)/$P($P(X," ",2),"/",2)))
 Q
 ;
MWT ;
 NEW AUPNC,AUPNI,AUPNJ
 S AUPNJ=$L(X) F AUPNI=1:1:AUPNJ S AUPNC=$E(X,AUPNI) I AUPNC?1A S AUPNC=$S(AUPNC?1L:$C($A(AUPNC)-32),1:AUPNC)
 S (AUPNI,AUPNC)="" F AUPNI=1:1:AUPNJ S AUPNC=$E(X,AUPNI) Q:"GK"[AUPNC
 I "GK"[AUPNC D @AUPNC
 K AUPNC,AUPNI,AUPNJ
 Q
MWTC ;
 Q:+X=X!(X'[" ")!(X'["/")
 K:'(X?1.6N1" "1.2N1"/"1.2N) X
 Q:'$D(X)
 S X=+X+((+$P(X," ",2)/$P($P(X," ",2),"/",2)))
 Q
K ;
 I X["/" S X=$P(X,AUPNC,1) D MWTC
 Q:'$D(X)
 S X=+X
 S X=(X*2.2046226)
 Q
G ;
 I X["/" S X=$P(X,AUPNC,1) D MWTC
 Q:'$D(X)
 S X=+X
 S X=(X*.0022046226)
 Q
C ;
 I X["/" S X=$P(X,AUPNC,1) D MWTC
 Q:'$D(X)
 S X=+X
 S X=(X*.393701)
 Q
 ;
V4906 ;EP - help
 D EN^DDIOL("Select whether the patient has any high risk weight issues.")
 D EN^DDIOL("For adults, this might be: <80% IBW; 1 week > 2% weight change;")
 D EN^DDIOL("1 month > 5% weight change; 3 months > 7.5% weight change;")
 D EN^DDIOL("6 months > 10% weight change. For pediatrics, this might ")
 D EN^DDIOL("be: < 80% IBW; Wt < 5%ile; L < 5%ile; Wt/L < 5%ile.")
 Q
V4907 ;EP - help
 D EN^DDIOL("Select whether the patient has any high risk diagnoses; ")
 D EN^DDIOL("for example: acute renal failure; AIDS; bone marrow transplant; ")
 D EN^DDIOL("new-onset diabetes; pancreatitis; sepsis; congenital heart ")
 D EN^DDIOL("disease; failure to thrive; high risk pregnancy.")
 Q
NY(%) ;EP - called from computed field
 I $G(%)="" Q ""
 I '$D(^AUPNVNTS(%,0)) Q ""
 NEW T,A
 S T=0
 F A=4:1:12 S T=T+$P(^AUPNVNTS(%,0),U,A)
 Q T
DURENDDT(%) ;EP - called from trigger on V ANTI-COAG File
 I $G(%)="" Q ""
 NEW A,B,C
 S A=$P(^AUPNVACG(%,0),U,7)
 I A="" Q ""
 S B=$P(^AUPNVACG(%,0),U,8)
 I B="" Q ""
 S C=$$CONVDUR(A)
 I C="" Q ""
 Q $$FMADD^XLFDT(B,C)
CONVDUR(B) ;
 I B=1 Q 90
 I B=2 Q 180
 I B=3 Q 365
 Q ""
