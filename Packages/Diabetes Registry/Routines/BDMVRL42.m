BDMVRL42 ; IHS/CMI/LAB - VIEW PT RECORD CON'T ; 11 Jan 2011  12:34 PM
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2,3,4**;JUN 14, 2007
 ;MOVED VARIOUS SUBROUTINES INTO BDMVRL42
 ;
 ;
FUHEAD ;EP;TO SET UP HEADER
 N BDMP,X,Y,Z,XX,YY,ZZ
 S VALMCNT=0
 D FUH1
 S A=""
 F  S A=$O(^TMP("BDMTMP",$J,A)) Q:A=""  D
 .Q:A="FUL"
 .S Y=""
 .F  S Y=$O(^TMP("BDMTMP",$J,A,Y)) Q:Y=""  D
 ..S DFN=$G(^TMP("BDMTMP",$J,A,Y))
 ..S BDMP=""
 ..F  S BDMP=$O(^TMP("BDMTMP",$J,A,Y,BDMP)) Q:BDMP=""  D
 ...S BDM=""
 ...F  S BDM=$O(^TMP("BDMTMP",$J,A,Y,BDMP,BDM)) Q:BDM=""  D
 ....S BDMX=$G(^TMP("BDMTMP",$J,A,Y,BDMP,BDM))
 ....Q:BDMX=""
 ....S X=$E(A,1,16)
 ....S $E(X,17)=$E(Y,1,24)
 ....S $E(X,41)=$P(BDMX,U,2)
 ....S $E(X,48)=$P(BDMX,U)
 ....D Z(X)
 ..I $D(BDMFUAPP) D APP^BDMVRL6(DFN,BDMBEGIN,BDMEND)
 Q
FUH1 ;EP;
 S:'$G(BDMPAGE) BDMPAGE=1
 I $G(BDMGUI),BDMPAGE'=1 D
 . S X="ZZZZZZZ"
 . D Z(X)
 K X,Z
 S Z=BDM("STATUS")
 S Z=$S(Z="A":"Active",Z="I":"Inactive",Z="T":"Transient",Z="U":"Unreviewed",Z="D":"Deceased",Z="N":"Non-IHS",Z="NON":"Noncompliant",Z="Z":"All Register Patients",1:"")
 S $E(X,6)=BDMREGNM_" Register - "_Z_" Patients"
 D Z(X)
 K X
 S $E(X,6)="Follow-up Report: "_$S($D(BDM("FOLLOW-UP TYPE HEAD")):BDM("FOLLOW-UP TYPE HEAD"),'$D(BDM("ALL")):BDM("FOLLOW-UP TYPE"),1:"ALL FOLLOW-UP NEEDS")
 S $E(X,65)="Page: "_BDMPAGE
 D Z(X)
 I $G(BDM("DM DIAGNOSIS"))]"" D
 .K X
 .S $E(X,6)="(For ** "_BDM("DM DIAGNOSIS")_" ** Diabetics Only.)"
 .D Z(X)
 K X
 S $E(X,6)="(For Patients due now or within the next 30 days)"
 D Z(X)
 I '$D(BDM("ALL")),BDM("FOLLOW-UP TYPE")["SGOT/SGPT" D
 .S X=""
 .S $E(X,28)="(Patient on REZULIN or METFORMIN without"
 .D Z(X)
 .S X=""
 .S $E(X,29)="SGOT or SGPT in past 4 months.)"
 .D Z(X)
 S Y=DT
 X ^DD("DD")
 S X="     REPORT DATE: "_Y
 D Z(X)
 S X=""
 D Z(X)
 I BDMK["WHER" D
 .S X="WHERE"
 .D Z(X)
 S X=$S(BDMK["COMM":"COMMUNITY",BDMK["PROV":"PROVIDER ",1:"FOLLOWED")
 S X=X_"       PATIENT                 HRN    STATUS"
 D Z(X)
 S X="--------------- ----------------------- ------ --------------------"
 D Z(X)
 Q
APPT ;EP;TO INCLUDE PATIENT APPOINTMENTS ON THE FOLLOW-UP REPORT
 S DIR(0)="YO"
 S DIR("A",1)="Include list of patient's"
 S DIR("A")="upcoming appointments"
 S DIR("B")="NO"
 W !
 D DIR^BDMFDIC
 I Y<1 K BDMQUIT Q
 D ^BDMDATE
 I '$G(BDMBEGIN)!'$G(BDMEND) D  Q
 .W !,"The beginning and/or ending date for the appointments was not indicated."
 .W !,"Upcoming patient appointments will not be included."
 S BDMFUAPP=""
 Q
PROTO ;EP;TO PRINT PROTOCOL
 S (ZTRTN,BDMRTN)="P1^BDMVRL42"
 D ^BDMFZIS
 Q
P1 ;EP;TO PRINT PROTOCOL LISTING
 S VALMCNT=0
 I IO'=IO(0) D  Q
 .W @IOF
 .D PHEAD
 .D P11
 S BDMVALM="BDM FOLLOW-UP PROTOCOL"
 D VALM^BDMVRL(BDMVALM)
 Q
PINIT ;
 D PHEAD
 D P11
 Q
PHEAD ;PROTOCOL HEADER
 K X
 S $E(X,5)="DMS Follow-up Protocol Listing"
 D Z(X)
 Q
P11 S X="Foot Exam       Annually"
 D Z(X)
 S X="Eye Exam        Annually"
 D Z(X)
 S X="Rectal Exam     Annually"
 D Z(X)
 S X="Depression Screening       Annually"
 D Z(X)
 S X="Breast Exam     Annually"
 D Z(X)
 S X="Mammography     Annually"
 D Z(X)
 S X="Hypertension    Annually"
 D Z(X)
 S X="Nutrition       Possible Hypertension, No Ace Inhibitors or ARB"
 D Z(X)
 S X="Exercise        Annually"
 D Z(X)
 S X="General Info    Annually"
 D Z(X)
 S X="Flu Shot        Annually"
 D Z(X)
 S X="Pneumovax       Every 6 years"
 D Z(X)
 S X="Td              Every 10 years"
 D Z(X)
 S X="PPD             Annually unless PPD positive or Hx of TB treatment"
 D Z(X)
 S X="LDL Cholesterol xxxxxxxx"
 D Z(X)
 S X="HDL Cholesterol xxxxxxxx"
 D Z(X)
 S X="Cholesterol xxxxxxxx"
 D Z(X)
 S X="Triglyceride    xxxxxxxx"
 D Z(X)
 S X="Creatinine      xxxxxxxx"
 D Z(X)
 S X="Hemoglobin A1c  xxxxxxxx"
 D Z(X)
 S X="Liver Function  xxxxxxxx"
 D Z(X)
 S X="Estimated GFR   xxxxxxxx"
 D Z(X)
 S X="A/C Ratio    xxxxxxxx"
 D Z(X)
 Q
Z(X) ;SET TMP NODE
 I IO'=IO(0) W !,X Q
 S VALMCNT=VALMCNT+1
 S ^TMP("BDMVR",$J,VALMCNT,0)=X
 Q
ZZ(X) ;SET TMP NODE
 S VALMCNT=VALMCNT+1
 S ^TMP("BDMVR",$J,VALMCNT,0)=X
 Q
 ;MOVED VARIOUS SUBROUTINES INTO BDMVRL42
SCREEN ;EP;LIST FU REPORT CHOICES
 N I,J,K,X,Y,Z
 F I=1:1:4 D
 .S X=$T(@("S"_I)+1)
 .S Y=$P(X,";",2)
 .S Z=$P(X,";",3)
 .S BDM("REPORT",Y)=$P(X,";",4)
 .W !?8
 .W Y,?$X+6,Z
 .S L=65-$X
 .F K=1:1:L W "-"
 .F J=2:1 S X=$T(@("S"_I)+J) Q:$P(X,";",2)=""  D
 ..S Y=$P(X,";",2)
 ..S Z=$P(X,";",3)
 ..S BDM("REPORT",Y)=$P(X,";",4)
 ..W:J#2 ?40
 ..W:'(J#2) !?10
 ..W ?$X,Y,?$X+3,Z
 Q
SSET ;EP;SCREEN SET
 N I,J,K,X,Y,Z
 F I=1:1:4 D
 .S X=$T(@("S"_I)+1)
 .S Y=$P(X,";",2)
 .S Z=$P(X,";",3)
 .S BDM("REPORT",Y)=$P(X,";",4)
 .F J=2:1 S X=$T(@("S"_I)+J) Q:$P(X,";",2)=""  D
 ..S Y=$P(X,";",2)
 ..S Z=$P(X,";",3)
 ..S BDM("REPORT",Y)=$P(X,";",4)
 D ALL
 D PARSE
 S BDMLET=2
 S:$G(BDMK)="" BDMK="COMM"
 D FUGET^BDMVRL4
 K BDMLET
 Q
ALL ;EP;ALL Patients requiring Follow-up
 S BDM("ALL")=""
 S Y=""
 S Y="11,12,14,18,19,21,22,23,31,32,33,34,41,42,43,44,45,46,47,48,49"
 S BDMY=Y
 Q
PARSE ;EP;TO PARSE ENTRIES
 F J=1:1:$L(BDMY,",") D
 .S X=$P(BDMY,",",J)
 .I X=1!(X=2)!(X=3)!(X=4) D  Q
 ..S:X=1 BDM("FOLLOW-UP TYPE HEAD")="ALL Exams/Procedures"
 ..S:X=2 BDM("FOLLOW-UP TYPE HEAD")="ALL Patient Education"
 ..S:X=3 BDM("FOLLOW-UP TYPE HEAD")="ALL Immunizations/Vaccines"
 ..S:X=4 BDM("FOLLOW-UP TYPE HEAD")="ALL Lab Tests"
 ..S A=(X_0)
 ..S B=(X+1)_0
 ..F K=A:1:B I $D(BDM("REPORT",K)) S BDM("PARSE",K)=""
 .I X,X'["-",$D(BDM("REPORT",X)) S BDM("PARSE",X)="" Q
 .S A=$P(X,"-")
 .S B=$P(X,"-",2)
 .F K=A:1:B I $D(BDM("REPORT",K)) S BDM("PARSE",K)=""
 Q
FURESULT ;EP;FIND LAST VISIT AND RESULT OF FU
 K BDM("VISIT"),BDMQUIT,BDMNOGO
 S Z=999999999
 F  S Z=$O(@BDMGBL@("AC",DFN,Z),-1) Q:'Z!$D(BDMQUIT)  I $D(BDM("IEN",+$G(@BDMGBL@(Z,0)))) S BDMV0=^(0),BDMVDA=$P(BDMV0,U,3) D:BDMVDA
 .S BDMVDATE=$P($P($G(^AUPNVSIT(BDMVDA,0)),U),".")
 .Q:'BDMVDATE
 .I BDMFU="PPD" D  Q:BDMVDATE=9999999
 ..S BDM("PPD")=$P($G(^AUPNVSK(Z,0)),U,4,5)
 ..I $P(BDM("PPD"),U)="P"!($P(BDM("PPD"),U,2)>9) S BDMVDATE=9999999,BDMQUIT=""
 .I BDMFU="UPRO" D  Q:BDMVDATE=9999999
 ..I "Pp"[$E($P(BDMV0,U,4)) S BDMVDATE=9999999
 ..I $P(BDMV0,U,4),$P($G(^AUPNVLAB(Z,11)),U,4),$P(BDMV0,U,4)>$P(^(11),U,4) S BDMVDATE=9999999
 ..S ZZ=Z
 ..F  S ZZ=$O(^AUPNVLAB("AC",DFN,ZZ)) Q:'ZZ!$D(BDMQUIT)  D
 ...S BDMV0=$G(^AUPNVLAB(ZZ,0))
 ...I "^1665044^9999382^9999383^9999570^"[(U_+BDMV0_U) D
 ....S BDMVDA=$P(BDMV0,U,3)
 ....S BDMVDATE=$P($P($G(^AUPNVSIT(BDMVDA,0)),U),".")
 .S BDMVDATE=9999999-BDMVDATE
 .I BDMVDATE S BDM("VISIT",BDMVDATE)="",BDMQUIT=""
 Q:$G(BDMVDATE)=9999999
 S BDMDOA=$$DODX^BDMD116(DFN,BDMRDA,"I")
 S Z=$O(BDM("VISIT",0)) I Z S Z=9999999-Z I Z>BDMDOA S BDMQUIT="" Q
 K BDMQUIT
 S Z=$O(BDM("VISIT",0))
 Q
S1 ;;
 ;1;ALL Exams/Procedures;ALL EXAMS
 ;11;Foot Exam;FTEX
 ;12;Eye Exam;EYE
 ;14;Depression Screening;DEP
 ;18;Dental Exam;DENT
 ;19;EKG;EKG
 ;;
 ;
S2 ;;
 ;2;ALL Patient Education;ALL EDUCATION
 ;21;Nutrition;NTED
 ;22;Exercise;EXER
 ;23;General Info;GENI
 ;;
 ;
S3 ;;
 ;3;ALL Immunizations/Vaccines;ALL VACCINES
 ;31;Seasonal Flu Shot;FLU
 ;32;Pneumovax;PNEU
 ;33;Td/Tdap;TD
 ;34;TB Test;PPD
 ;
S4 ;;
 ;4;ALL Lab Tests;ALL LAB TESTS
 ;41;LDL Cholesterol;LDL
 ;42;HDL Cholesterol;HDL
 ;43;Cholesterol;CHOL
 ;44;Triglyceride;TRIG
 ;45;Creatinine;CREA
 ;46;Hemoglobin A1c;HGB
 ;47;Urine Protein Testing;UPT
 ;48;Estimated GFR;GFR
 ;49;A/C Ratio;UACR
 ;
