AMHLESM ; IHS/CMI/LAB - calls from within screenman ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;PATCH 2 - limit meds to 2 years
 ;
 ;CMI/TUCSON/LAB - 10/06/97 - PATCH 1 ADDED CODE TO PROPERLY DISPLAY AXIS IV&V ON PREVIOUS POV DISPLAYS (SUB ROUTINES HPOV AND HPOV1)
 ;*** Lori Butcher - IHS Information Systems Division Tucson, AZ ***
EN1(AMHPAT) ;EP - called from protocol
 Q:'$G(AMHPAT)
 D HMED1
 NEW C S C="Medication List for "_$P(^DPT(AMHPAT,0),U)
 D ARRAY^XBLM("^TMP(""AMHDSPMEDS"",$J,",C)
 K ^TMP("AMHSMEDS",$J),^TMP("AMHDSPMEDS",$J)
 Q
HMED ;EP - display last
 ;display last 2 years worth of meds from V Med
 ;display last 2 years worth of meds from mhss record
 I '$G(AMHPAT) S AMHMSG(1)="Unknown Patient" D HLP^DDSUTL(.AMHMSG) K AMHMSG Q
 D HMED1
 NEW C S C="Medication List for "_$P(^DPT(AMHPAT,0),U)
 D ARRAY^XBLM("^TMP(""AMHDSPMEDS"",$J,",C)
 K ^TMP("AMHDSPMEDS",$J)
REFRESH ;
 S X=0 X ^%ZOSF("RM")
 W $P(DDGLVID,DDGLDEL,8)
 D REFRESH^DDSUTL
 Q
HMED1 ;EP
 ;S (%,%1)=""
 S %=$$FMADD^XLFDT(DT,-731),%1=""
 D GETMEDS^AMHLEMD(AMHPAT,%,%1,"L")
 D GETMHMD
 D SETARRAY
 Q
SETARRAY ;
 K ^TMP("AMHDSPMEDS",$J) S ^TMP("AMHDSPMEDS",$J,0)=0
 ;S X="Displayed is the MEDICATIONS PRESCRIBED data field from the BH data file" D S(X)
 ;S X="for the past 2 years of visits." D S(X)
 ;S X="Also, the last of each type of medication from the PCC Database is displayed." D S(X)
 S X=" " D S(X)
 S X=" " D S(X) S X="*** Medications Prescribed entries in BH Database for last 2 years ***" D S(X)
 S I=0 F  S I=$O(^TMP("AMHSMEDS",$J,"M",I)) Q:I'=+I  S X=^TMP("AMHSMEDS",$J,"M",I) D S(X)
 S X=" " D S(X) S X="The last of each type of medication from the PCC Database is displayed below." D S(X)
 S I=0 F  S I=$O(^TMP("AMHSMEDS",$J,"A",I)) Q:I'=+I  S X=^TMP("AMHSMEDS",$J,"A",I) D S(X)
 Q
GETMHMD ;set array ^TMP("AMHSMEDS",$J,"M" OF MEDS IN MH FILE
 K ^TMP("AMHSMEDS",$J,"M")
 NEW AMHLAST,AMHC S AMHLAST=9999999-(DT-20000),AMHC=0
 NEW I S I=0 F  S I=$O(^AMHREC("AE",AMHPAT,I)) Q:I=""!(I>AMHLAST)  D
 .S X=0 F  S X=$O(^AMHREC("AE",AMHPAT,I,X)) Q:X=""  D
 ..Q:'$D(^AMHREC(X,41,0))
 ..Q:'$$ALLOWVI^AMHUTIL(DUZ,X)
 ..S AMHC=AMHC+1,^TMP("AMHSMEDS",$J,"M",AMHC)=$$FMTE^XLFDT((9999999-$P(I,".")),"2E")
 ..S C=0 F  S C=$O(^AMHREC(X,41,C)) Q:C'=+C  S AMHC=AMHC+1,^TMP("AMHSMEDS",$J,"M",AMHC)=^AMHREC(X,41,C,0)
 ..Q
 Q
S(Y,F,C,T) ;
 I '$G(F) S F=0
 I '$G(T) S T=0
 ;blank lines
 F F=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S %=$P(^TMP("AMHDSPMEDS",$J,0),U)+1,$P(^TMP("AMHDSPMEDS",$J,0),U)=%
 S ^TMP("AMHDSPMEDS",$J,%,0)=X
 Q
HPOV ;EP display last visit's povs
 NEW AMHC1,AMHA,AMHMSG,%,AMHA,AMHB,AMHT,AMHV,AMHC,AMHCC,X,S,Y,Z ;CMI/TUCSON/LAB - added X,S,Y,Z patch 1 10/06/97
 Q:'$G(AMHR)
 Q:'$G(AMHPAT)
 S AMHC=$$VAL^XBDIQ1(9002013,DUZ(2),.25) S:'AMHC AMHC=1
 S AMHC1=1,AMHMSG(AMHC1)="Patient's Diagnoses from last "_AMHC_" visit"_$S(AMHC=1:"",1:"s")_":"
 S (AMHA,AMHV,AMHCC)=0 F  S AMHA=$O(^AMHREC("AE",AMHPAT,AMHA)) Q:AMHA'=+AMHA!(AMHV)  D
 .S AMHT=0 F  S AMHT=$O(^AMHREC("AE",AMHPAT,AMHA,AMHT)) Q:AMHT'=+AMHT!(AMHV)  I AMHT'=AMHR,$D(^AMHRPRO("AD",AMHT)) D
 ..I $P($G(^AMHSITE(DUZ(2),0)),U,26) Q:$$NOSHOW(AMHT)
 ..Q:'$$ALLOWVI^AMHUTIL(DUZ,AMHT)
 ..S AMHB=0 F  S AMHB=$O(^AMHRPRO("AD",AMHT,AMHB)) Q:AMHB'=+AMHB  D
 ...Q:'$P(^AMHRPRO(AMHB,0),U,3)
 ...S AMHC1=AMHC1+1,AMHMSG(AMHC1)=$$FMTE^XLFDT($P($P(^AMHREC($P(^AMHRPRO(AMHB,0),U,3),0),U),"."),"2E")_"  "_$$VAL^XBDIQ1(9002011.01,AMHB,.01)_"  "_$E($$VAL^XBDIQ1(9002011.01,AMHB,.04),1,52)
 ...;S AMHC1=AMHC1+1,AMHMSG(AMHC1)="Provider: "_$$PPINI^AMHUTIL(AMHT)_" " ;CMI/TUCSON/LAB - removed 1 space patch 1 10/06/97
 ...;I $P(^AMHREC(AMHT,0),U,14)]""!($P(^AMHREC(AMHT,0),U,13)]"") D
 ...;S AMHMSG(AMHC1)=AMHMSG(AMHC1)_"AXIS IV: "_$$VAL^XBDIQ1(9002011,AMHT,.13)_" "_$S($P(^AMHREC(AMHT,0),U,13)]"":$P(^AMHTAXIV($P(^AMHREC(AMHT,0),U,13),0),U,2),1:"")_"    AXIS V: "_$$VAL^XBDIQ1(9002011,AMHT,.14)
 ...;CMI/TUCSON/LAB - 10/06/97 - replaced the 2 lines above with 4 lines below to properly display AXIS IV data  patch 1
 ...;S X=0,S="" F  S X=$O(^AMHREC(AMHT,61,X)) Q:X'=+X  S Y=$P(^AMHREC(AMHT,61,X,0),U),S=S_" "_$P(^AMHTAXIV(Y,0),U)_"-"_$E($P(^AMHTAXIV(Y,0),U,2),1,8)
 ...;S Z="AXIS IV:"_S
 ...;I $P(^AMHREC(AMHT,0),U,14)]"" S Z=Z_" AXIS V: "_$P(^AMHREC(AMHT,0),U,14)
 ...;S AMHMSG(AMHC1)=AMHMSG(AMHC1)_" "_Z
 ...S AMHCC=AMHCC+1 I AMHCC=AMHC S AMHV=AMHT Q
 I 'AMHCC S AMHMSG(1)="No prior diagnoses on file for this patient." G HLP
HLP D HLP^DDSUTL(.AMHMSG)
 K AMHCC
 Q
HPOV1 ;EP called from input template
 NEW C,AMHMSG,%,A,B,R
 Q:'$G(AMHR)
 Q:'$G(AMHPAT)
 S (A,%)=0 F  S A=$O(^AMHREC("AE",AMHPAT,A)) Q:A'=+A!(%)  D
 .S R=0 F  S R=$O(^AMHREC("AE",AMHPAT,A,R)) Q:R'=+R!(%)  I R'=AMHR,$D(^AMHRPRO("AD",R)) S %=R
 I '% W !!,"No prior diagnoses on file for this patient."
 S C=1 W !!,"Patient's Diagnoses from last visit:"
 S B=0 F  S B=$O(^AMHRPRO("AD",%,B)) Q:B'=+B  D
 .;CMI/TUCSON/LAB - 10/06/97 - patch 1 added display of axis iv&v by adding next 4 lines
 .I '$P(^AMHRPRO(B,0),U,3) Q
 .S C=C+1 W !,$$FMTE^XLFDT($P($P(^AMHREC($P(^AMHRPRO(B,0),U,3),0),U),"."),"2E")_"  "_$$VAL^XBDIQ1(9002011.01,B,.01)_"  "_$E($$VAL^XBDIQ1(9002011.01,B,.04),1,52)
 .S X=0,S="" F  S X=$O(^AMHREC(%,61,X)) Q:X'=+X  S Y=$P(^AMHREC(%,61,X,0),U),S=S_" "_$P(^AMHTAXIV(Y,0),U)_"-"_$E($P(^AMHTAXIV(Y,0),U,2),1,8)
 .S Z=" AXIS IV:"_S
 .I $P(^AMHREC(%,0),U,14)]"" S Z=Z_" AXIS V: "_$P(^AMHREC(%,0),U,14) I $P($G(^AMHREC(%,11)),U,15)]"" S Z=Z_"  GAF Scale Type: "_$P($G(^AMHREC(%,11)),U,15)
 .W !,"Provider: ",$$PPINI^AMHUTIL(%),$G(Z)
 .Q
 W !
 Q
NOSHOW(V) ;EP - return 0 if no noshows, 1 if noshow
 Q:'$G(V)
 NEW %,X,P
 S (%,X)=0 F  S X=$O(^AMHRPRO("AD",V,X)) Q:X'=+X  S P=$$VAL^XBDIQ1(9002011.01,X,.01) I P>7.9999&(P<9) S %=1
 Q %
