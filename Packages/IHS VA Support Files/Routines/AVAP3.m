AVAP3 ;IHS/ORDC/LJF - MOVE LICENSURE BACK TO FILE 6 [ 10/27/93  9:47 AM ]
 ;;7.0I4;Kernel;**3**;Jul 17, 1992
 ;
 Q  ;no direct entry to rtn
 ;
LOOP ; loop thru provider file
 Q:'$O(^DIC(6,0))  ;no data in provider file
 W !!,"Moving licensure data back to Provider file "
 S LJF6=0
 F  S LJF6=$O(^DIC(6,LJF6)) Q:LJF6'=+LJF6  D
 .Q:'$D(^DIC(6,LJF6,0))  ;bad entry
 .Q:$P(^DIC(6,LJF6,0),U)'=LJF6  ;also bad entry
 .I LJF6#10=0 W ". "
 .I '$D(^DIC(16,LJF6,"A3")) D  Q
 ..W !,"^DIC(16,",LJF6,",""A3"" DOES NOT EXIST.",!
 .S LJF200=$P(^DIC(16,LJF6,"A3"),U) ;user pointer
 .I LJF200="" D  Q
 ..W !,"^DIC(16,",LJF6," HAS NO A3 POINTER TO ^DIC(3.",!
 .Q:'$D(^VA(200,LJF200))  ;no entry in file 200
 .D MOVE ;move then delete licensure multiple
 .Q  ;get next provider
 ;
 ;
END ;***> eoj
 K LJF6,LJF200
 K X,Y Q
 ;
 ;
 ;
 ;
MOVE ;**> SUBRTN to move licensure data to file 6 then delete in file 200
 Q:'$O(^VA(200,LJF200,"PS1",0))  ;no data to move
 I $O(^DIC(6,LJF6,999999921,0)) G MOVE1 ;data in file 6; don't overwrite
 S ^DIC(6,LJF6,999999921,0)="^6.999999921P^"_$P(^VA(200,LJF200,"PS1",0),U,3,4) ;set zero node
 W "+ " S X=0
 F  S X=$O(^VA(200,LJF200,"PS1",X)) Q:X'=+X  D
 .S ^DIC(6,LJF6,999999921,X,0)=^VA(200,LJF200,"PS1",X,0)
MOVE1 K ^VA(200,LJF200,"PS1") ;remove data from file 200
 Q
