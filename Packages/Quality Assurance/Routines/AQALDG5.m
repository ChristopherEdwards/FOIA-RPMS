AQALDG5 ; IHS/ORDC/LJF - AUTOLINK ADT OCCURRENCES ;
 ;;1;QI LINKAGES-RPMS;;AUG 15, 1994
 ;
 ;Called by OR/EE Event Driver via MAS option DGPM MOVEMENT EVENTS
 ;Required input:  DFN=patient internal #
 ;                 DGPMA=after node for movement
 ;                 DUZ(2)=admission facility
 ;                 DGPMT=type of movement
 ;
 Q:'$D(DFN)  Q:'$D(DGPMDA)  Q:DGPMDA=""
 Q:'$D(DUZ(2))  Q:'$D(DGPMA)  Q:'$D(DGPMT)
 ;
 Q:DGPMT>3  ;not adm,wd transf,disch
 S DGPMCA=$P(DGPMA,U,14) I DGPMA="" S DGPMCA=$P(DGPMP,U,14)
 I DGPMP="" D @DGPMT,^AQALKILL Q  ;new event, not an edit
 S AQALVST=$P($G(^DGPM(+DGPMCA,"IHS")),U) I AQALVST="" K AQALVST Q
 I '$D(^AQAOC("AE",DFN,AQALVST)),+DGPMA D @DGPMT,^AQALKILL Q  ;no occ
 D ^AQALDG53,^AQALKILL Q  ;mod or delete occ already set
 ;
1 ; >> admission events
 ;  find admit type & srv; check if transfer in
 K ^UTILITY("DIQ1",$J)
 S (AQALF,DIC)=405.1,DA=$P(DGPMA,U,4),DR="9999999.1"
 D EN^DIQ1 S AQALX=^UTILITY("DIQ1",$J,AQALF,DA,9999999.1)
 ;
 I (AQALX=2)!(AQALX=3) D
 .S AQALEV=1001,AQALSVI=2,AQALSV=$$SRV(DGPMCA) Q:'$$LINK
 .D TI^AQALDG50,^AQALDG51 ;get xtra data & create occ
 ;
 ; find last disch & current admit dates for readmission
 S AQALCUR=+DGPMA,AQALIVDT=$$IDATE(AQALCUR)
 S AQALST=$O(^DGPM("ATID3",DFN,AQALIVDT))
 I +AQALCUR,+AQALST D  ;at least one prev admission
 .S AQALEV=1011,AQALSVI=3,AQALSV=$$SRV(DGPMCA) Q:'$$LINK
 .D READM^AQALDG50,^AQALDG51 ;get xtra data & create occ
 ;
 ; find last day surgery
 S AQALST=$O(^ADGDS("APID",DFN,AQALIVDT))
 I +AQALCUR,+AQALST D  ;at least one d s
 .S AQALEV=1021,AQALSVI=4,AQALSV=$$SRV(DGPMCA) Q:'$$LINK
 .D DSADM^AQALDG50,^AQALDG51 ;get xtra data & create occ
 ;
 Q
 ;
2 ; >> ward transfer events
 ; check for icu transfer
 S X=$P(DGPMA,U,6) Q:'$$ICU(X)
 S AQALST=$$IDATE(+DGPMA)
 F  S AQALST=$O(^DGPM("APMV",DFN,DGPMCA,AQALST)) Q:AQALST=""  Q:$$TYP=2
 S AQALEV=1031,AQALSVI=5,AQALSV=$$SRV(DGPMDA)
 S:AQALST="" AQALST=$$IDATE(+^DGPM(DGPMCA,0))
 I $$LINK D ICU^AQALDG50,^AQALDG51 ;get xtra data & create occ
 ;
 ; check for return to icu
 S AQALST=$$IDATE(+DGPMA)
 F  S AQALST=$O(^DGPM("APMV",DFN,DGPMCA,AQALST)) Q:AQALST=""  Q:$$ICU1
 I AQALST]"" S AQALST=$O(^DGPM("APTT2",DFN,$$IDATE(AQALST)))
 I +DGPMA,+AQALST D
 .S AQALEV=1071,AQALSVI=9,AQALSV=$$SRV(DGPMDA) Q:'$$LINK
 .D RICU^AQALDG50,^AQALDG51 ;get xtra data & create occ
 ;
 Q
 ;
3 ;>> discharge events
 ;find discharge type
 K ^UTILITY("DIQ1",$J)
 S (AQALF,DIC)=405.1,DA=$P(DGPMA,U,4),DR="9999999.1"
 D EN^DIQ1 S AQALX=^UTILITY("DIQ1",$J,AQALF,DA,9999999.1)
 ;
 ;determine discharge link:1051=transfer,1041=ama,1061=death
 S AQALEV=$S(AQALX=2:1051,AQALX=3:1041,AQALX<2:"",AQALX>7:"",1:1061)
 Q:AQALEV="" 
 S AQALSVI=$S(AQALX=2:7,AQALX=3:6,AQALX<1:"",AQALX>7:"",1:8)
 S AQALSV=$$DSRV,AQALWD=$$DWD
 Q:'$$LINK
 D DSCH^AQALDG50,^AQALDG51 ;get data items & create occ
 ;
 Q
 ;
LINK() ; >> find if link turned on
 N DIC,DR,DA,AQALON S AQALON=0
 G LINKEND:'$D(^AQAGP(DUZ(2))) ;no params for site
 K ^UTILITY("DIQ1",$J) S AQALF=9002166.4,DIC="^AQAGP(",DA=DUZ(2)
 S DR="" F I=0:1:3 S DR=DR_(AQALEV+I)_";"
 D EN^DIQ1
 G LINKEND:^UTILITY("DIQ1",$J,AQALF,DUZ(2),AQALEV)'="ON" ;turned on?
 G LINKEND:^UTILITY("DIQ1",$J,AQALF,DUZ(2),AQALEV+1)="" ;chk ind 4 link
 G LINKEND:AQALSV="" S AQALX=0 ;link on for this srv?
 F  S AQALX=$O(^AQAGP(DUZ(2),"SRV","B",AQALSV,AQALX)) Q:AQALX=""  D
 .Q:'+$P($G(^AQAGP(DUZ(2),"SRV",AQALX,0)),U,AQALSVI)
 .Q:'$$TIME  ;check time limit
 .S AQALON=1
LINKEND Q AQALON
 ;
TIME() ; >> check time limit against dates
 N AQALYES,AQALNUM S AQALYES=1
 I (AQALEV=1011)!(AQALEV=1021)!(AQALEV=1071) D
 .S AQALNUM=$P($G(^AQAGP(DUZ(2),"SRV",AQALX,1)),U,AQALSVI) Q:AQALNUM=""
 .S X1=+DGPMA,X2=$$IDATE(AQALST) Q:X2=0  D ^%DTC
 .I X>AQALNUM S AQALYES=0
 Q $G(AQALYES)
 ;
SRV(X) ; >> hospital srv ifn for movement
 N Y
 S Y=$O(^DGPM("APHY",X,0))
 I Y="" S Y=$$LSRV
 I Y]"" S Y=$P(^DGPM(Y,0),U,9)
 I Y]"" S Y=$P($G(^DIC(45.7,Y,0)),U,4)
 Q Y
 ;
LSRV() ; >> find last time srv was transferred
 N X,Y S Y=$$IDATE(+DGPMA)
 S X=$O(^DGPM("ATID6",DFN,+$O(^DGPM("ATID6",DFN,Y)),0))
 I X="" S X=DGPMCA
 Q X
 ;
ICU(X) ; >> see if ward is an ICU
 Q $S($P($G(^DIC(42,X,"IHS")),U)="Y":1,1:0)
 ;
ICU1() ; >> was last ward ICU?
 N X,Y I $$TYP'=2 Q 0
 S X=$O(^DGPM("APMV",DFN,DGPMCA,AQALST,0))
 I X S X=$P($G(^DGPM(X,0)),U,6)
 I X S Y=$$ICU(X)
 Q $G(Y)
 ;
TYP() ; >> find type of movemnt for last movemnt
 N X,Y
 S X=$O(^DGPM("APMV",DFN,DGPMCA,AQALST,0))
 I X S Y=$P($G(^DGPM(X,0)),U,2)
 Q $G(Y)
 ;
DSRV() ; >> find disch srv
 N X,Y S Y=9999999.9999999-$G(^DGPM(+$P(^DGPM(DGPMCA,0),U,17),0))
 S X=$O(^DGPM("ATID6",DFN,$O(^DGPM("ATID6",DFN,Y)),0))
 I X="" S X=DGPMCA
 Q $P($G(^DIC(45.7,$P($G(^DGPM(+X,0)),U,9),0)),U,4)
 ;
DWD() ; >> find disch ward
 N X,Y,Z S Y=$G(^DGPM(+$P(^DGPM(DGPMCA,0),U,17),0)),Y=$$IDATE(+Y)
 S X=$O(^DGPM("ATID2",DFN,Y))
 I X>$$IDATE(+^DGPM(DGPMCA,0)) S Z=DGPMCA
 I X]"",'$D(Z) S Z=$O(^DGPM("ATID2",DFN,X,0))
 I X="" S Z=DGPMCA
 Q $P($G(^DGPM(+Z,0)),U,6)
 ;
IDATE(X) ; >> inverse date
 Q (9999999.9999999-X)
