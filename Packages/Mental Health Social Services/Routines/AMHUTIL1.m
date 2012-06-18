AMHUTIL1 ; IHS/CMI/LAB - provider functions 06 Aug 2009 11:15 AM ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;IHS/CMI/LAB - added stage as output parameter
 ;
 ;IHS/TUCSON/LAB - patch 1 05/19/97 - fixed setting of array
DEMO(P,T) ;EP - called to exclude demo patients
 I $G(P)="" Q 0
 I $G(T)="" S T="I"
 I T="I" Q 0
 NEW R
 S R=""
 I T="E" D  Q R
 .I $P($G(^DPT(P,0)),U)["DEMO,PATIENT" S R=1 Q
 .NEW %
 .S %=$O(^DIBT("B","RPMS DEMO PATIENT NAMES",0))
 .I '% S R=0 Q
 .I $D(^DIBT(%,1,P)) S R=1 Q
 I T="O" D  Q R
 .I $P($G(^DPT(P,0)),U)["DEMO,PATIENT" S R=0 Q
 .NEW %
 .S %=$O(^DIBT("B","RPMS DEMO PATIENT NAMES",0))
 .I '% S R=1 Q
 .I $D(^DIBT(%,1,P)) S R=0 Q
 .S R=1 Q
 Q 0
 ;
DEMOCHK(R) ;EP - check demo pat
 NEW DIR,DA
 S R=-1
 S DIR(0)="S^I:Include ALL Patients;E:Exclude DEMO Patients;O:Include ONLY DEMO Patients",DIR("A")="Demo Patient Inclusion/Exclusion",DIR("B")="E"
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S R=-1 Q
 S R=Y
 Q
CHKD(Y,D) ;EP check dsm with Date
 S D=$G(D)
 I 'Y Q 0
 I '$D(^AMHPROB(Y,0)) Q 0
 NEW M,Z,J
 S M=$P(^AMHPROB(Y,0),U,13) I M D  Q Z
 .S Z=1
 .S J=$P(^AMHPROB(Y,0),U,14)
 .I J="" S Z=0 Q
 .I D]"",J]"",J<D S Z=0
 .I D="" S Z=0
 NEW I S I=$P(^AMHPROB(Y,0),U,5)
 ;I I="" Q $P(^AMHPROB(Y,0),U,13)  ;cmi/maw orig
 I I="" Q $S($P(^AMHPROB(Y,0),U,13):0,1:1)  ;cmi/maw modified
 Q $$POVICD9D(I,D)
 ;
CHKICD(Y,D,R,A,E) ;EP
 S D=$G(D)
 S R=$G(R)
 S A=$G(A)
 S E=$G(E)
 I $$POVICD9(Y,D,R,A,E)
 Q:$D(^AMHPROB(Y))
 Q
POVICD9(Y,D,R,A,E) ;EP
 ;Y=ien of entry in MHSS PROBLEM/DSM CODE file
 ;E - indicates we are in EHR so it is accepted since PCC accepted it
 ;R - ien of MHSS RECORD if known and in a record
 ;D - date of visit for which this pov is being added
 ;A - equal to DA of MHSS RECORD PROBLEMS file, to be used if in fileman's edit??? and not in BH software?, maybe someone is doing D P^DI and editting the .01 field of the file??
 ;
 I $G(E) Q 1  ;take whatever EHR passes as EHR rules
 S R=$G(R)
 S D=$G(D)
 S A=$G(A)
 S Y=$G(Y)
 I 'Y Q 0  ;pass an IEN!
 NEW I,V,M,Z,J
 I '$D(^AMHPROB(Y,0)) Q 0  ;pass a VALID IEN!
 S M=$P(^AMHPROB(Y,0),U,13) I M D  Q Z
 .S Z=1
 .S J=$P(^AMHPROB(Y,0),U,14)
 .I J="" S Z=0 Q
 .I D="",R S D=$P($P($G(^AMHREC(R,0)),U),".")
 .I D]"",J]"",J<D S Z=0
 .I D="" S Z=0
 S I=$P(^AMHPROB(Y,0),U,5)  ;GET ICD9 code that this is mapped to
 I I="" Q $S('$P(^AMHPROB(Y,0),U,13):1,1:0)   ;if there is no icd9 code to look at then just check status field and quit
 ;now figure out if valid based on what data is passed.
 ;if passed in D, use it and quit
 I D Q $$POVICD9D(I,D)
 I R,$D(^AMHREC(R,0)) S D=$P($P(^AMHREC(R,0),U,1),".") Q $$POVICD9D(I,D)
 I A S V=$P($G(^AMHRPRO(A,0)),U,3) I V,$D(^AMHREC(V,0)) S D=$P($P(^AMHREC(V,0),U,1),".") Q $$POVICD9D(I,D)
 Q $$POVICD9D(I)
 ;
POVICD9D(Y,D) ;
 NEW A,I
 S D=$G(D)
 I $$VERSION^XPDUTL("BCSV")]"" Q $P($$ICDDX^ICDCODE(Y,D),U,10)  ;CSV
 ;10TH PIECE OF THAT CALL DOESN'T WORK IF CSV NOT INSTALLED
 S Y=$P($$ICDDX^ICDCODE(Y,D),U,1)
 I $G(Y)<0 Q 0  ;cmi/maw added for return of -1
 S A=$P($G(^ICD9(Y,9999999)),U,4),I=$P(^ICD9(Y,0),U,11)  ;CSV
 I D]"",I]"",D>I Q 0
 I D]"",A]"",D<A Q 0
 Q 1
 ;
PRIMPOV(V,F) ;EP - primary provider in many different formats
 I 'V Q ""
 I '$D(^AMHREC(V)) Q ""
 NEW %,Y,P,C,Z
 S (Z,P)="",(Y,C)=0
 S Y=$O(^AMHRPRO("AD",V,0)) I Y S P=$P(^AMHRPRO(Y,0),U),Z=Y
 I 'P Q P
 I '$D(^AMHPROB(P)) Q ""
 I $G(F)="" S F="C"
 S %="" D @F
 Q %
 ;
SECPOV(V,N,F) ;EP
 I 'V Q ""
 I '$D(^AMHREC(V)) Q ""
 I '$G(N) Q ""
 NEW %,Y,P,C,Z
 S (Z,P)="",(Y,C)=0
 S Y=0,C=-1 F  S Y=$O(^AMHRPRO("AD",V,Y)) Q:Y'=+Y   S C=C+1 I C=N S P=$P(^AMHRPRO(Y,0),U),Z=Y
 I 'P Q P
 I '$D(^AMHPROB(P)) Q ""
 I $G(F)="" S F="C"
 S %="" D @F
 Q %
 ;
POV ;EP
 NEW Z,C,%,S,I,J
 S (C,Y)=0 F  S Y=$O(^AMHRPRO("AD",V,Y)) Q:Y'=+Y   S C=C+1 S APCLV(C)="",P=$P(^AMHRPRO(Y,0),U),Z=Y D
 .I F=99 D  Q
 ..F I=1:1 S S=$T(@I) Q:S=""  S %="" D @I S $P(APCLV(C),U,I)=%
 .I F[";" D  Q
 ..F J=1:1 S I=$P(F,";",J) Q:I=""  I I'=99 S %="" D @I S $P(APCLV(C),U,I)=% ;IHS/TUCSON/LAB - patch 1 05/19/97 changed ,I TO ,J
 .S %="",I=F D @I S $P(APCLV(C),U)=%
 .Q
 Q
ADMDX ;EP
 I 'V Q ""
 I '$D(^AMHREC(V)) Q ""
 NEW %,Y,Z
 S %="",Z=$O(^AUPNVINP("AD",V,0))
 I 'Z Q %
 S P=$P(^AUPNVINP(Z,0),U,12)
 I 'P Q P
 I '$D(^AMHPROB(P)) Q ""
 I $G(F)="" S F="C"
 S %="" D @F
 Q %
 ;
I ;
 S %=P Q
E ;
 S %=$P(^AMHPROB(P,0),U,3) Q
C ;EP
 S %=$P(^AMHPROB(P,0),U) Q
D ;EP
 S %=$P(^AMHRPRO(Z,0),U,7) Q
J ;
 S %=$P(^AMHRPRO(Z,0),U,9) I % S %=$P(^AMHPROB(%,0),U) Q
 Q
P ;
 S %=$P(^AMHRPRO(Z,0),U,11) Q
N ;
 S %=$P(^AMHRPRO(Z,0),U,4) I %,$D(^AUTNPOV(%,0)) S %=$P(^AUTNPOV(%,0),U)
 Q
S ;stage
 S %=$P(^AMHRPRO(Z,0),U,5) Q
 ;
1 ;
 S %=$$VD^APCLV($P(^AMHRPRO(Y,0),U,3),"I")
 Q
2 ;
 S %=$$VD^APCLV($P(^AMHRPRO(Y,0),U,3),"S")
 Q
3 ;
 S %=$P(^AMHRPRO(Y,0),U,2)
 Q
4 ;
 S %=$$PATIENT^APCLV($P(^AMHRPRO(Y,0),U,3),"E")
 Q
5 ;
 S %=Y
 Q
6 D E Q
7 D C Q
9 D D Q
10 S %=$$VAL^XBDIQ1(9000010.07,Y,.07) Q
11 D J Q
12 D P Q
13 S %=$$VAL^XBDIQ1(9000010.07,Y,.11) Q
14 D N Q
15 S %=$P(^AMHRPRO(Y,0),U,12) Q
16 S %=$$VAL^XBDIQ1(9000010.07,Y,.12) Q
17 S %=$$VAL^XBDIQ1(9000010.07,Y,.13) Q
18 S %=$$VAL^XBDIQ1(9000010.07,Y,.05) Q
19 S %=$$VALI^XBDIQ1(9000010.07,Y,.06) Q
20 S %=$$VAL^XBDIQ1(9000010.07,Y,.06) Q
DATEEDIT ;EP
 I $P(X,".",2)="" D HLP^DDSUTL("You must enter a valid date/time. Time is required.") S DDSERROR=1 Q
 Q
UID(AMHA) ;EP-Given DFN return unique patient record id.
 ; AMHA can be DFN, but is not required if DFN or DA exists.
 ;
 ; pt record id = 6DIGIT_PADDFN
 ;     where 6DIGIT is the ASUFAC at the time of implementation of
 ;     this functionality.  I.e., the existing ASUFAC was frozen and
 ;     stuffed into the .25 field of the RPMS SITE file.
 ; PADDFN = DFN right justified in a field of 10.
 ;
 ; If not there, stuff the ASUFAC into RPMS SITE for durability.
 ;I '$P($G(^AUTTSITE(1,1)),U,3) S $P(^AUTTSITE(1,1),U,3)=$P(^AUTTLOC($P(^AUTTSITE(1,0),U,1),0),U,10)
 ;
 ; If AMHA is not specified, try DFN, then DA if DIC=AUPNPAT.
 I '$G(AMHA),$G(DFN) S AMHA=DFN
 I '$G(AMHA),$G(DA),$G(DIC)="^AUPNPAT(" S AMHA=DA
 ;
 I '$G(AMHA) Q "DFN undefined."
 I '$D(^AUPNPAT(AMHA)) Q "No entry in AUPNPAT(."
 ;
 Q $$GET1^DIQ(9999999.06,$P(^AUTTSITE(1,0),U),.32)_$E("0000000000",1,10-$L(AMHA))_AMHA
 ;
UIDV(VISIT) ;EP - generate unique ID for visit
 I '$G(VISIT) Q VISIT
 NEW X
 ;I '$P($G(^AUTTSITE(1,1)),"^",3) S $P(^AUTTSITE(1,1),"^",3)=$P(^AUTTLOC($P(^AUTTSITE(1,0),"^",1),0),"^",10)
 S X=$$GET1^DIQ(9999999.06,$P(^AUTTSITE(1,0),U),.32)
 Q X_$$LZERO(VISIT,10)
 ;
LZERO(V,L) ;EP - left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
 ;
DAYSBACK ;EP - called from option
 W !,"This option is used to edit the parameter definition for the "
 W !,"Number of days back the BH-EHR should look for displaying visits"
 W !,"to the user.",!!
 D EDITPAR^XPAREDIT("AMHBH DAYS BACK")
 Q
EDITTIUT ;EP - called from option
 W !!,"This option is used to edit the parameters for the list"
 W !,"of preferred TIU Note Titles that the BH-EHR should display"
 W !,"to the user when they select a TIU title for the following:"
 W !?5," - Behavioral Health record Progress Note/SOAP"
 W !?5," - Treatment Plan Narrative"
 W !?5," - Group Note Narrative"
 W !?5," - Intake Document Narrative"
 W !!
ED1 ;
 K DIR
 S DIR(0)="SO^P:Behavioral Health record Progress Note/SOAP;T:Treatment Plan Narrative;G:Group Note Narrative;I:Intake Document Narrative"
 S DIR("A")="Enter the type of Preferred TIU Note Titles to Update" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I Y="" Q
 S AMHY=Y_"X"
 S AMHPAR=$P($T(@AMHY),";;",2)
 D EDITPAR^XPAREDIT(AMHPAR)
 G ED1
PX ;;AMHBH TIU TITLES 9002011-1108
TX ;;AMHBH TIU TITLES TP .21
GX ;;AMHBH TIU TITLES GROUP-.17
IX ;;AMHBH TIU TITLES INTAKE-.09
 ;
 ;
EDITHLD ;EP - called from option
 W !!,"This option is used to edit the default hospital locations"
 W !,"do be displayed to the user when creating a TIU Note."
 W !!
HL1 ;
 D EDITPAR^XPAREDIT("AMHBH HOSPITAL LOCATION (TIU)")
 Q
CPT(Y,D) ;EP - screen on CPT
 S D=$G(D)
 I $$CHKCPT(Y,D)
 Q:$D(^ICPT(Y))
 Q
 ;
CHKCPT(Y,D) ;EP
 NEW A,I,%
 S %=$$CPT^ICPTCOD(Y,D)
 I $G(%)<0 Q 0  ;cmi/maw added for return of -1
 I $$VERSION^XPDUTL("BCSV")]"" Q $P(%,U,7)
 S A="",I=$P(^ICPT(Y,0),U,7)  ;CAN'T RELY ON A IN OLD MODE
 ;A is date added, I is date inactivated/deleted
 I I]"",D]"",I<D Q 0
 Q 1
 ;
OPEN ;
 NEW O,A,C,N
 S O=$$GET^DDSVAL(9002011.58,DA,.01,,"I")
 S A=$$GET^DDSVAL(9002011.58,DA,.04,,"I")
 S C=$$GET^DDSVAL(9002011.58,DA,.05,,"I")
 S N=$$GET^DDSVAL(9002011.58,DA,.12,,"I")
 Q:O=""
 I A,O>A D  Q
 .D EN^DDIOL("Open Date cannot be before admit date.  You must change")
 .D EN^DDIOL("or remove the admit date before changing the open date.")
 .D PUT^DDSVAL(DIE,.DA,.01,DDSOLD,,"I")
 .S DDSBR=1
 I C,O>C D  Q
 .D EN^DDIOL("Open Date cannot be before the closed date.  You must change")
 .D EN^DDIOL("or remove the closed date before changing the open date.")
 .D PUT^DDSVAL(DIE,.DA,.01,DDSOLD,,"I")
 .S DDSBR=1
 I N,O>N D  Q
 .D EN^DDIOL("Open Date cannot be before the next review date.  You must change")
 .D EN^DDIOL("or remove the next review date before changing the open date.")
 .D PUT^DDSVAL(DIE,.DA,.01,DDSOLD,,"I")
 .S DDSBR=1
 Q
ADMIT ;
 NEW O,A,C,N
 S O=$$GET^DDSVAL(9002011.58,DA,.01,,"I")
 S A=$$GET^DDSVAL(9002011.58,DA,.04,,"I")
 S C=$$GET^DDSVAL(9002011.58,DA,.05,,"I")
 S N=$$GET^DDSVAL(9002011.58,DA,.12,,"I")
 Q:A=""
 I O>A D  Q
 .D EN^DDIOL("Admit date cannot be before open date.  You must change")
 .D EN^DDIOL("the open date before changing the admit date.")
 .D PUT^DDSVAL(DIE,.DA,.04,DDSOLD,,"I")
 .S DDSBR=5
 I C,A>C D  Q
 .D EN^DDIOL("Admit Date cannot be before the closed date.  You must change")
 .D EN^DDIOL("or remove the closed date before changing the admit date.")
 .D PUT^DDSVAL(DIE,.DA,.04,DDSOLD,,"I")
 .S DDSBR=5
 ;I N,A>N D  Q
 ;.D EN^DDIOL("Admit Date cannot be before the next review date.  You must change")
 ;.D EN^DDIOL("or remove the next review date before changing the admit date.")
 ;.D PUT^DDSVAL(DIE,.DA,.04,DDSOLD,,"I")
 ;.S DDSBR=1
 Q
NRD ;
 NEW O,A,C,N
 S O=$$GET^DDSVAL(9002011.58,DA,.01,,"I")
 S A=$$GET^DDSVAL(9002011.58,DA,.04,,"I")
 S C=$$GET^DDSVAL(9002011.58,DA,.05,,"I")
 S N=$$GET^DDSVAL(9002011.58,DA,.12,,"I")
 Q:N=""
 I O,O>N D  Q
 .D EN^DDIOL("Next review date cannot be before open date.  You must change")
 .D EN^DDIOL("the open date before changing the next review date.")
 .D PUT^DDSVAL(DIE,.DA,.12,DDSOLD,,"I")
 .S DDSBR=6
 ;I A,A>N D  Q
 ;.D EN^DDIOL("Next Review Date cannot be before the closed date.  You must change")
 ;.D EN^DDIOL("or remove the closed date before changing the admit date.")
 ;.D PUT^DDSVAL(DIE,.DA,.04,DDSOLD,,"I")
 ;.S DDSBR=1
 ;I N,A>N D  Q
 ;.D EN^DDIOL("Admit Date cannot be before the next review date.  You must change")
 ;.D EN^DDIOL("or remove the next review date before changing the admit date.")
 ;.D PUT^DDSVAL(DIE,.DA,.04,DDSOLD,,"I")
 ;.S DDSBR=1
 Q
CLOSED ;
 NEW O,A,C,N
 S O=$$GET^DDSVAL(9002011.58,DA,.01,,"I")
 S A=$$GET^DDSVAL(9002011.58,DA,.04,,"I")
 S C=$$GET^DDSVAL(9002011.58,DA,.05,,"I")
 S N=$$GET^DDSVAL(9002011.58,DA,.12,,"I")
 Q:C=""
 I O,O>C D  Q
 .D EN^DDIOL("Closed date cannot be before open date.  You must change")
 .D EN^DDIOL("the open date before changing the closed date.")
 .D PUT^DDSVAL(DIE,.DA,.05,DDSOLD,,"I")
 .S DDSBR=7
 I A,A>C D  Q
 .D EN^DDIOL("Admit Date cannot be before the closed date.  You must change")
 .D EN^DDIOL("or remove the admit date before changing the closed date.")
 .D PUT^DDSVAL(DIE,.DA,.05,DDSOLD,,"I")
 .S DDSBR=7
 Q
TARGET(R) ;EP
 I $O(^AMHRPA("AD",R,0)) Q
 NEW E
 D PUT^DDSVAL(9002011,AMHR,1106,"@",.E)
 D REQ^DDSUTL("TARGET","AMH PREV ACT TARGET BLK",5.3,0)
 Q
TAR1(R) ;EP
 K DLAYGO
 I $O(^AMHRPA("AD",R,0)) D REQ^DDSUTL("TARGET","AMH PREV ACT TARGET BLK",5.3,1) Q
 D REQ^DDSUTL("TARGET","AMH PREV ACT TARGET BLK",5.3,0)
 Q
