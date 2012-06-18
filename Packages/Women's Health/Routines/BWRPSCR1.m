BWRPSCR1 ;IHS/ANMC/MWR - WOMEN'S HEALTH PCC LINK  [ 09/07/99  7:28 AM ];15-Feb-2003 22:37;PLS
 ;;2.0;WOMEN'S HEALTH;**6,8**;MAY 16, 1996
 ;patch 6 modified current community screen
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  THIS REPORT WILL DISPLAY SCREENING RATES FOR PAPS & MAMS.
 ;;  ENTRY POINTS CALLED BY BWRPSCR.
 ;
 ;
DATA ;EP
 ;---> SORT AND STORE ARRAY IN ^TMP("BW",$J
 K BWTMP,^TMP("BW",$J)
 ;---> BWBEGDT1=ONE SECOND BEFORE BEGIN DATE.
 ;---> BWENDDT1=THE LAST SECOND OF END DATE.
 S BWBEGDT1=BWBEGDT-.0001,BWENDDT1=BWENDDT+.9999
 ;
 S BWDATE=BWBEGDT1
 F  S BWDATE=$O(^BWPCD("D",BWDATE)) Q:'BWDATE!(BWDATE>BWENDDT1)  D
 .S BWIEN=0
 .F  S BWIEN=$O(^BWPCD("D",BWDATE,BWIEN)) Q:'BWIEN  D
 ..S Y=^BWPCD(BWIEN,0)
 ..S BWDFN=$P(Y,U,2),BWPCDN=$P(Y,U,4),BWRES=$P(Y,U,5)
 ..;
 ..;---> QUIT IF THIS PROCEDURE HAS A RESULT OF "ERROR/DISREGARD".
 ..Q:BWRES=8
 ..;
 ..;---> QUIT IF NEITHER A PAP (IEN=1) NOR A SCREENING MAM (IEN=28).
 ..Q:((BWPCDN'=1)&(BWPCDN'=28))
 ..;
 ..;---> QUIT IS PATIENT IS NOT WITHIN AGE RANGE.
 ..S BWAGE=+$$AGE^BWUTL1(BWDFN)
 ..I BWAGRG'=1 Q:((BWAGE<$P(BWAGRG,"-"))!(BWAGE>$P(BWAGRG,"-",2)))
 ..;
 ..;---> QUIT IF NOT SELECTING ALL CURRENT COMMUNITIES AND IF THIS
 ..;---> IS NOT ONE OF THE SELECETED.
 ..I '$D(BWCC("ALL")) S X=$P($G(^AUPNPAT(BWDFN,11)),U,18) Q:X=""  Q:'$D(BWCC(X))
 ..;
 ..;---> GET VALUE OF RESULT: 0=NORMAL, 1=ABNORMAL, 2=NO RESULT
 ..S BWNORM=$$NORMAL^BWUTL4(BWRES) S:BWNORM=2 BWNORM=0
 ..;
 ..S ^TMP("BW",$J,BWDFN,BWNORM,BWPCDN,BWIEN)=""
 ;
 ;---> NOW COLLATE DATA FROM ^TMP ARRAY INTO LOCAL BWTMP REPORT ARRAY.
 ;---> FIRST, SEED LOCAL ARRAY WITH ZEROS.
 F M=1,28 D
 .N I F I=1:1:9 S BWTMP("RES",M,I)=0
 ;
 ;---> COLLATE DATA.
 S N=0
 F  S N=$O(^TMP("BW",$J,N)) Q:'N  D
 .F M=1,28 D
 ..Q:$D(^TMP("BW",$J,N,1,M))
 ..S P=0,Q=0
 ..F  S P=$O(^TMP("BW",$J,N,0,M,P)) Q:'P  S Q=Q+1
 ..Q:'Q
 ..I '$D(BWTMP("RES",M,Q)) S BWTMP("RES",M,Q)=1 Q
 ..S BWTMP("RES",M,Q)=BWTMP("RES",M,Q)+1
 ;
 ;---> STORE ALL NODES >9 IN THE 9+ NODE.
 F M=1,28 D
 .S Q=9
 .F  S Q=$O(BWTMP("RES",M,Q)) Q:'Q  D
 ..S BWTMP("RES",M,9)=BWTMP("RES",M,9)+BWTMP("RES",M,Q)
 ..K BWTMP("RES",M,Q)
 ;
 ;---> FIGURE PERCENTAGES OF WOMEN AND STORE IN ARRAY.
 F M=1,28 D
 .S BWTOT=0
 .F Q=1:1:9 S BWTOT=BWTOT+BWTMP("RES",M,Q)
 .S:'BWTOT BWTOT=1
 .F Q=1:1:9 S $P(BWTMP("RES",M,Q),U,2)=$J((+BWTMP("RES",M,Q)/BWTOT),0,2)
 ;
 ;---> BUILD DISPLAY ARRAY.
 N BWNODE K ^TMP("BW",$J)
 ;
 ;---> PAPS SUBHEADER LINE.
 S BWNODE=$$S(32)_"SCREENING PAPS"
 D WRITE(1,BWNODE)
 S BWNODE=$$S(31)_"----------------"
 D WRITE(2,BWNODE)
 S BWNODE=" # of PAPs:      1      2      3      4      5"
 S BWNODE=BWNODE_"      6      7      8     9+"
 D WRITE(4,BWNODE)
 S BWNODE=" -----------  ------ ------ ------ ------ ------"
 S BWNODE=BWNODE_" ------ ------ ------ ------"
 D WRITE(5,BWNODE)
 ;
 ;---> PAPS NUMBER OF WOMEN DATA LINE.
 S BWNODE=" # of Women: "
 F Q=1:1:9 S BWNODE=BWNODE_$J($P(BWTMP("RES",1,Q),U),7)
 D WRITE(6,BWNODE)
 S BWNODE=" % of Women: "
 F Q=1:1:9 S BWNODE=BWNODE_$J(($P(BWTMP("RES",1,Q),U,2)*100),6)_"%"
 D WRITE(7,BWNODE)
 ;
 ;---> LINE FEEDS BETWEEN PAPS AND MAMS.
 S BWNODE="" D WRITE(8,BWNODE) S BWNODE="" D WRITE(9,BWNODE)
 ;
 ;---> MAMS SUBHEADER LINE.
 S BWNODE=$$S(32)_"SCREENING MAMS"
 D WRITE(10,BWNODE)
 S BWNODE=$$S(31)_"----------------"
 D WRITE(11,BWNODE)
 S BWNODE=" # of MAMs:      1      2      3      4      5"
 S BWNODE=BWNODE_"      6      7      8     9+"
 D WRITE(13,BWNODE)
 S BWNODE=" -----------  ------ ------ ------ ------ ------"
 S BWNODE=BWNODE_" ------ ------ ------ ------"
 D WRITE(14,BWNODE)
 ;
 ;---> PAPS NUMBER OF WOMEN DATA LINE.
 S BWNODE=" # of Women: "
 F Q=1:1:9 S BWNODE=BWNODE_$J($P(BWTMP("RES",28,Q),U),7)
 D WRITE(15,BWNODE)
 S BWNODE=" % of Women: "
 F Q=1:1:9 S BWNODE=BWNODE_$J(($P(BWTMP("RES",28,Q),U,2)*100),6)_"%"
 D WRITE(16,BWNODE)
 Q
 ;
WRITE(I,Y) ;EP
 S ^TMP("BW",$J,I,0)=Y
 Q
 ;
S(S) ;EP
 ;---> SPACES.
 Q $$S^BWUTL7($G(S))
 ;
 ;
AGERNG(BWAGRG,BWPOP) ;EP
 ;---> ASK AGE RANGE.
 ;---> RETURN AGE RANGE IN BWAGRG.
 N DIR,DIRUT,Y S BWPOP=0
 W !!?3,"Do you wish to limit this report to an age range?"
 S DIR(0)="Y",DIR("B")="NO" D HELP1
 S DIR("A")="   Enter Yes or No"
 D ^DIR K DIR W !
 S:$D(DIRUT) BWPOP=1
 ;---> IF NOT DISPLAYING BY AGE RANGE, SET BWAGRG (AGE RANGE)=1, QUIT.
 I 'Y S BWAGRG=1 Q
BYAGE1 ;
 W !?5,"Enter the age range you wish to select in the form of: 40-75"
 W !?5,"Use a dash ""-"" to separate the limits of the range."
 W !?5,"To select only one age, simply enter that age, with no dash."
 W !?5,"(NOTE: Patient ages will reflect the age they are today.)",!
 K DIR
 S DIR(0)="FOA",DIR("A")="     Enter age range: "
 S:$D(^BWAGDF(DUZ,0)) DIR("B")=$P(^(0),U,3)
 D ^DIR K DIR
 I $D(DIRUT) S BWPOP=1 Q
 D CHECK(.Y)
 I Y="" D  G BYAGE1
 .W !!?5,"* INVALID AGE RANGE.  Please begin again."
 ;---> BWAGRG=SELECTED AGE RANGE(S).
 S BWAGRG=Y
 D DIC^BWFMAN(9002086.72,"L",.Y,"","","","`"_DUZ)
 Q:Y<0
 D DIE^BWFMAN(9002086.72,".03////"_BWAGRG,+Y,.BWPOP,1)
 Q
 ;
HELP1 ;EP
 ;;Answer "YES" to display screening rates for a specific age range.
 ;;If you choose to display for an age range, you will be given the
 ;;opportunity to select the age range.  For example, you might choose
 ;;to display from ages 50-75.
 ;;Answer "NO" to display screening rates for all ages.
 S BWTAB=5,BWLINL="HELP1" D HELPTX
 Q
 ;
PRINTX ;EP
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
 ;
HELPTX ;EP
 ;---> CREATES DIR ARRAY FOR DIR.  REQUIRED VARIABLES: BWTAB,BWLINL.
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  S DIR("?",I)=T_$P(X,";;",2)
 S DIR("?")=DIR("?",I-1) K DIR("?",I-1)
 Q
 ;
CHECK(X) ;EP
 ;---> CHECK SYNTAX OF AGE RANGE STRING.
 ;---> IF X=ONE AGE ONLY, SET IT IN THE FORM X-X AND QUIT.
 I X?1N.N S X=X_"-"_X Q
 ;
 N FAIL,I,Y1,Y2
 S FAIL=0
 ;---> CHECK EACH RANGE.
 S Y1=$P(X,"-"),Y2=$P(X,"-",2)
 ;---> EACH END OF EACH RANGE SHOULD BE A NUMBER.
 I (Y1'?1N.N)!(Y2'?1N.N) S X="" Q
 ;---> THE LOWER NUMBER SHOULD BE FIRST.
 I Y2<Y1 S FAIL=1
 I FAIL S X="" Q
 Q
