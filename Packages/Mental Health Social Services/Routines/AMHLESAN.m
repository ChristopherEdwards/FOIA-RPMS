AMHLESAN ; IHS/CMI/LAB - DISPLAY/EDIT TREATMENT NOTES ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
 ;
 ;; ;
EN ; EP -- main entry point for AMH UPDATE ACTIVITY RECORDS
 S VALMCC=1
 D EN^VALM("AMH SAN UPDATE")
 D CLEAR^VALM1
 Q
 ;
EP1(DFN,AMHR) ;EP CALLED FROM PROTOCOL
 Q:'$G(AMHR)
 Q:'$D(^AMHREC(AMHR))
 I $G(AMHVTYPE)="" S AMHVTYPE=$P(^AMHREC(AMHR,0),U,33)
 ;get intake document or create new one
 D EN
 D FULL^VALM1
 K VALMHDR
 K X,Y
 Q
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
SELECT ;
 W ! S DIR(0)="LO^1:"_$S(AMHVTYPE="S":21,1:8),DIR("A")="Which item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G BACK
 I $D(DIRUT) W !,"No items selected." G BACK
 S AMHY=Y
 D FULL^VALM1 W:$D(IOF) @IOF
 S AMHC="" F AMHI=1:1 S AMHC=$P(AMHY,",",AMHI) Q:AMHC=""  D
 .I AMHVTYPE="S" S AMHX=$T(@AMHC)
 .I AMHVTYPE="U" S Y=AMHC+70 S AMHX=$T(@Y)
 .S AMHX1=$P(AMHX,";;",3),AMHX2=$P(AMHX,";;",4)
 .D @AMHX1 Q
 .Q
 D BACK
 Q
D ;
 W !
 D ^XBFMK S DA=AMHR,DIE="^AMHREC(",DR=AMHX2 D ^DIE D ^XBFMK
 Q
GATHER ;EP - called from AMHUAR
 K AMHQUIT,AMHLESAN S AMHRCNT=0,AMHLINE=0
 I AMHVTYPE="U" D GATHER1 Q
 F AMHE=1:1:21 D
 .S X=$T(@AMHE)
 .S AMHRCNT=AMHRCNT+1,AMHLINE=AMHLINE+1,AMHLESAN(AMHLINE,0)=$P(X,";;",1)_"   "_$P(X,";;",2),AMHLESAN("IDX",AMHRCNT,AMHLINE)=AMHLINE
 .Q
 Q
HDR ;EP -- header code
 S VALMHDR(1)="Patient Name:  "_$P(^DPT(DFN,0),U)_"     DOB:  "_$$FTIME^VALM1($P(^DPT(DFN,0),U,3))_"   Sex:  "_$P(^DPT(DFN,0),U,2)
 Q
 ;
GATHER1 ;
 F AMHE=71:1:78 D
 .S X=$T(@AMHE)
 .S AMHRCNT=AMHRCNT+1,AMHLINE=AMHLINE+1,AMHLESAN(AMHLINE,0)=$P(X,";;",1)-70_"   "_$P(X,";;",2),AMHLESAN("IDX",AMHRCNT,AMHLINE)=AMHLINE
 .Q
 Q
INIT ;EP -- init variables and list array
 D GATHER ;gather up all records for display
 S VALMCNT=AMHLINE
 Q
 ;
HELP ;EP -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
DISP ;
 D EN^AMHLESA1(AMHR)
 D BACK
 Q
EXIT ; -- exit code
 K AMHRCNT,AMHPTP,AMHE,AMHLINE,AMHLEL,AMHLETXT,AMHGNUM,AMHTPN,AMHCOL
 K VALMCC,VALMHDR
 Q
 ;
EXPND ; -- expand code
 Q
1 ;;Parents;;D;;7701
2 ;;Guardians;;D;;7702
3 ;;Lives With;;D;;7703
4 ;;Spouse/Partner Info;;D;;7704
5 ;;Person Referring Info;;D;;7706
6 ;;Relation To Victim;;D;;7707
7 ;;Suspected Perpetrator Info;;D;;7901
8 ;;History;;D;;7709
9 ;;Prior Incidents Noted;;D;;7717
10 ;;Assessment:  Problems Identified;;D;;7711
11 ;;Assessment:  Strengths Identified;;D;;7712
12 ;;Risk for Recurrence;;D;;7713
13 ;;Services Provided/Treatment Plan;;D;;7715
14 ;;Examining Physician;;D;;7902
15 ;;Date of Examination;;D;;7719
16 ;;Police Contacted: Y/N;;D;;7721
17 ;;Date/Time Complaint Filed;;D;;7722
18 ;;Complaint #;;D;;7903
19 ;;Officer Name and Agency;;D;;7904
20 ;;Referral(s) Made to;;D;;7905
21 ;;Other Comments;;D;;7724
 ;
 ;
71 ;;Reasons for Review;;D;;7801
72 ;;Outcome;;D;;7802
73 ;;Outcome Reasons;;D;;7803
74 ;;Assessment: Problems Identified;;D;;7804
75 ;;Assessment: Strengths Identified;;D;;7805
76 ;;Risk;;D;;7806
77 ;;Services Provided up to time of review;;D;;7808
78 ;;Recommendations/Comments;;D;;7809
