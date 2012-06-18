LJFPV200 ;IHS/ORDC/LJF - DUPLICATE PROV DATA IN FILE 200; [ 04/27/93  1:03 PM ]
 ;;7.0I4;Kernel;;Jul 17, 1992
 ;This routine is called from XUINEND in Kernel 7 postinits
 ;
 Q    ;no direct entry to rtn
 ;
START ;EP;  ENTRY POINT called by Kernel 7 post init
 Q:'$O(^DIC(6,0))   ;no data in provider file
 W !!,"Duplicating provider data into New Person file "
 S LJFPV=0
 F  S LJFPV=$O(^DIC(6,LJFPV)) Q:LJFPV'=+LJFPV  D
 .Q:'$D(^DIC(6,LJFPV,0))   ;bad entry
 .Q:$P(^DIC(6,LJFPV,0),U)'=LJFPV    ;also bad entry
 .I LJFPV#10=0 W ". "
 .I '$D(^DIC(16,LJFPV,"A3")) D  Q                                   ;MWR
 ..W !,"^DIC(16,",LJFPV,",""A3"" DOES NOT EXIST.",!                 ;MWR
 .S LJF200=$P(^DIC(16,LJFPV,"A3"),U)    ;user pointer
 .I LJF200="" D  Q                                                  ;MWR
 ..W !,"^DIC(16,",LJFPV," HAS NO A3 POINTER TO ^DIC(3.",!           ;MWR
 .Q:'$D(^VA(200,LJF200))    ;no entry in file 200
 .Q:$D(^VA(200,LJF200,9999999))   ;already converted
 .D DUPL      ;duplicate fields into VA(200
 .D MOVE      ;move then delete licensure multiple
 .Q           ;get next provider
 ;
 ;
END ;***> eoj
 K LJFPV,LJF200,LJFI,LJFF,LJFN6,LJFN200,LJFF6,LJFF200,LJFXREF,LJFDATA
 K X,Y Q
 ;
 ;
DUPL ;**> SUBRTN to duplicate data into file 200
 F LJFI=1:1:4 D    ;loop thru nodes
 .S LJFN6=$P($T(@LJFI),";;",2),LJFN200=$P($T(@LJFI),";;",3)
 .Q:'$D(^DIC(6,LJFPV,LJFN6))   ;node doesn't exist in file 6
 .F LJFJ=1:1 Q:$P($T(@LJFI+LJFJ),";;",2)="END"  D    ;loop thru fields
 ..;
 ..S LJFF6=$P($T(@LJFI+LJFJ),";;",2)   ;field piece number in file 6
 ..Q:$P(^DIC(6,LJFPV,LJFN6),U,LJFF6)=""   ;don't overwrite if null
 ..S LJFDATA=$P(^DIC(6,LJFPV,LJFN6),U,LJFF6)   ;data to duplicate
 ..S LJFF200=$P($T(@LJFI+LJFJ),";;",3)  ;field piece number in file 200
 ..I '$D(^VA(200,LJF200,LJFN200)) S ^VA(200,LJF200,LJFN200)=""
 ..Q:$P(^VA(200,LJF200,LJFN200),U,LJFF200)'=""  ;don't overwrite if data
 ..;
 ..S $P(^VA(200,LJF200,LJFN200),U,LJFF200)=LJFDATA  ;set data
 ..;
 ..S LJFXREF=$P($T(@LJFI+LJFJ),";;",4) Q:LJFXREF=""   ;no xref to set
 ..S ^VA(200,LJFXREF,LJFDATA,LJF200)=""    ;set xref
 ..;
 ..Q    ;get next field for this node
 .Q    ;get next node in file
 Q    ;quit subrtn
 ;
 ;
MOVE ;**> SUBRTN to move licensure data to file 200 then delete in file 6
 Q:'$O(^DIC(6,LJFPV,999999921,0))   ;no data to move
 I $D(^VA(200,LJF200,"PS1")) G MOVE1  ;data in file 200; don't overwrite
 S ^VA(200,LJF200,"PS1",0)="^200.541P^"_$P(^DIC(6,LJFPV,999999921,0),U,3,4)  ;set zero node
 W "+ " S X=0
 F  S X=$O(^DIC(6,LJFPV,999999921,X)) Q:X'=+X  D
 .S ^VA(200,LJF200,"PS1",X,0)=^DIC(6,LJFPV,999999921,X,0)
 .S ^VA(200,LJF200,"PS1","B",+^VA(200,LJF200,"PS1",X,0),X)=""
MOVE1 K ^DIC(6,LJFPV,999999921)  ;remove data from file 6
 Q
 ;
 ;
1 ;;0;;PS
 ;;3;;2;;APS1
 ;;4;;5;;
 ;;5;;6;;
 ;;6;;3;;APS2
 ;;END
2 ;;.11;;.11
 ;;1;;1;;
 ;;2;;2;;
 ;;3;;3;;
 ;;4;;4;;
 ;;5;;5;;
 ;;6;;6;;
 ;;END
3 ;;9999999;;9999999
 ;;1;;1;;
 ;;2;;2;;F
 ;;5;;5;;H
 ;;6;;6;;
 ;;7;;7;;
 ;;8;;8;;
 ;;END
4 ;;I;;I
 ;;1;;1;;
 ;;END
