AQAQMIS1 ;IHS/ASU/RPL 4/17/89 ;MISSING CREDENTIALS REPORT-PART 2 ; 11/7/89  10:04 AM
 ;;STAFF CREDENTIALS Version 1.1;11/7/89
 ;
START S AQAQ80D="--------------------------------------------------------------------------------"
 S Y=DT X ^DD("DD") S AQAQDTP=Y
 S AQAQSTRT=""
 S AQAQ(3)="DEA Registration not on file."
 S AQAQ(4)="Internship Certificate Missing."
 S AQAQ(5)="Residency Certificate Missing."
 S AQAQ(6)="Professional degree not on file."
 S AQAQ(7)="Professional degree not verified."
 S AQAQ(8)="Bylaws Agreement not signed."
 S AQAQ(9)="Information Release not signed."
 S AQAQ(10)="Curriculum Vitae not on file."
 S AQAQ(11)="3 Letters of Reference not on file."
 S AQAQ(12)="No Medical License on file."
 S AQAQ(13)="Latest Medical License renewal not verified."
 S AQAQ(14)="No Health Status Statement on file."
 S AQAQ(15)="No Health Status Verification Statement on file."
 S AQAQ(16)="No Credentials approval date on file."
 S AQAQ(17)="No request for Clinical Privileges on file."
 S AQAQ(18)="No Clinical Privileges approval date on file for last request."
 S AQAQPG=0 D HEAD
 S AQAQNM="" F I=0:0 S AQAQNM=$O(^UTILITY($J,AQAQNM)) Q:AQAQNM=""!($D(AQAQQUIT))  D P1
 G QUIT
P1 S AQAQDFN="" F J=0:0 S AQAQDFN=$O(^UTILITY($J,AQAQNM,AQAQDFN)) Q:AQAQDFN=""!($D(AQAQQUIT))  D P15
 Q
P15 D:$Y>(IOSL-7) HEAD Q:$D(AQAQQUIT)
 S AQAQ=^UTILITY($J,AQAQNM,AQAQDFN)
 W !!,AQAQNM,?32,$P(AQAQ,"^",1),?60,$P(AQAQ,"^",2)
 W !!
 F I=1:1:18 I $P(AQAQ,"^",I) W ?10,AQAQ(I),! D:$Y>(IOSL-6) HEAD Q:$D(AQAQQUIT)
 Q
HEAD S AQAQPG=AQAQPG+1 I $D(AQAQSTRT) K AQAQSTRT G HEAD1
 I $E(IOST)="C",IO=IO(0) R X:DTIME I $E(X)="^"!('$T) S AQAQQUIT="" Q
HEAD1 W @IOF
 W AQAQSITE,?58,AQAQDTP,?72,"Page ",AQAQPG,!
 W !,?26,"MISSING CREDENTIALS REPORT"
 W !,?60,"Credentials",!
 W "Name",?32,"Staff Category",?60,"Application Date"
 W !,AQAQ80D,!
 Q
QUIT Q
