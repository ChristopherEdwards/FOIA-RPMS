AQAQMCP ;IHS/ANMC/LJF - PRINT MISSING CREDENTIALS; [ 04/03/95  7:57 AM ]
 ;;2.2;STAFF CREDENTIALS;**4,7**;01 OCT 1992
 ;
 ;***> initialize variables
 S AQAQDUZ=$P(^DIC(3,DUZ,0),U,2),AQAQSTOP=""
 S AQAQSITE=$P(^DIC(4,DUZ(2),0),U)
 S AQAQPAGE=0,AQAQLINE="",$P(AQAQLINE,"=",80)="" D HEAD
 I '$D(^UTILITY("AQAQMC",$J)) W !!,"NO MISSING CREDENTIALS FOUND" G END
 ;
 ;***> loop thru ^utility then print data
 S AQAQSR=0
 F  S AQAQSR=$O(^UTILITY("AQAQMC",$J,AQAQSR)) Q:AQAQSR=""  Q:AQAQSTOP=U  D
 .S AQAQNM=0
 .F  S AQAQNM=$O(^UTILITY("AQAQMC",$J,AQAQSR,AQAQNM)) Q:AQAQNM=""  Q:AQAQSTOP=U  D
 ..S AQAQ=0
 ..F  S AQAQ=$O(^UTILITY("AQAQMC",$J,AQAQSR,AQAQNM,AQAQ)) Q:AQAQ=""  Q:AQAQSTOP=U  D
 ...;
 ...;**> print name, category and last application date
 ...S AQAQST=^(AQAQ) W !!,$E(AQAQNM,1,30) ;name
 ...S Y=$P(AQAQST,U),C=$P(^DD(9002165,.02,0),U,2)
 ...I Y'="" D Y^DIQ W ?35,Y ;category
 ...S Y=$P(AQAQST,U,2) X ^DD("DD") W ?60,Y ;application date
 ...;**> loop thru missing credentials and print them
 ...S AQAQMS=$P(AQAQST,U,3) D PRINTMSG Q:AQAQSTOP=U
 ...I $Y>(IOSL-5) D NEWPG
 ;
END ;***> end of job
 I IOST["C-" K DIR S DIR(0)="E",DIR("A")="Hit RETURN to continue" D ^DIR
 W @IOF D ^%ZISC D KILL^AQAQUTIL Q
 ;
 ;
NEWPG ;***> SUBRTN for end of page control
 I IOST'?1"C-".E D HEAD S AQAQSTOP="" Q
 I AQAQPAGE>0 K DIR S DIR(0)="E" D ^DIR S AQAQSTOP=X
 I AQAQSTOP'=U D HEAD
 Q
 ;
 ;
HEAD ;***> SUBRTN to print heading
 I (IOST["C-")!(AQAQPAGE>0) W @IOF
 W !,AQAQLINE S AQAQPAGE=AQAQPAGE+1
 W !?8,"*****Confidential Medical Staff Data Covered by Privacy Act*****"
 W !,AQAQDUZ,?80-$L(AQAQSITE)/2,AQAQSITE
 S AQAQTY="MISSING CREDENTIALS REPORT"
 W ! D ^%T W ?80-$L(AQAQTY)/2,AQAQTY,?70,"Page: ",AQAQPAGE
 S Y=DT X ^DD("DD") S Y="As of "_Y W !?80-$L(Y)/2,Y
 W !,"Provider Name",?35,"Staff Category",?58,"Last Application Date"
 W !,AQAQLINE
 Q
 ;
 ;
PRINTMSG ;***> SUBRTN to print missing credential messages
 F  S AQAQMSG=$E(AQAQMS,1) Q:AQAQMSG=""  Q:AQAQSTOP=U  D
 .W:$P($T(@AQAQMSG),";;",2)'="" !
 .W ?10,$P($T(@AQAQMSG),";;",2)
 .I AQAQMSG="N" W !?15,"# of Letters on file: ",$P(^AQAQC(AQAQ,0),U,17)
 .S AQAQMS=$E(AQAQMS,2,99)
 .I $Y>(IOSL-4) D NEWPG
 Q
 ;
 ;
A ;;Professional Degree NOT on file
B ;;Professional Degree NOT verified
C ;;Internship Certificate NOT on file
D ;;Internship NOT verified
F ;;2nd Residency/Fellowship NOT verified
G ;;Residency Certificate NOT on file
H ;;Residency NOT verified
I ;;Bylaws Agreement NOT signed       
J ;;Information Release NOT signed
K ;;Curriculum Vitae NOT on file
N ;;Number of Letters of Reference NOT acceptable
O ;;Health Status NOT on file
P ;;NPDB Inquiry NOT Made;;PATCH #4
Z ;;No Medical License Entered;;PATCH #7
