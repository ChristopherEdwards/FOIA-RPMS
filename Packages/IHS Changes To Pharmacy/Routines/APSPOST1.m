APSPOST1 ; IHS/DSD/ENM - POST CONVERSION RTN - ;  [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 ;CALLED BY PSOPOST
 ;This routine will move the Pharmacy System parameters from the
 ;IHS Systems file to the APSP Control file.
 ;
EP ;EP - GET PHARMACY SITE(S) 
 ;W !,"Converting Pharmacy System Parameters to IHS Systems File....",! ;IHS/DSD/ENM 01/08/97 COMMENTED OUT
 S U="^",APSPSIT=0,APSPSN="",APS=0,AP=0
 S:$G(^APSPCTRL("FLAG"))]"" APSPSIT=^APSPCTRL("FLAG")
 S APSP1=$G(^AUSYS(1,"PS",1,0)) Q:APSP1=0
 F AP=0:0 S APSPSIT=$O(^PS(59,"B",APSPSIT)) Q:APSPSIT=""  F APS=0:0 S APSPSN=$O(^PS(59,"B",APSPSIT,APSPSN)) Q:'APSPSN  D SET
 D FIN ;W !,"Done......",! ;IHS/DSD/ENM 01/08/97 COMMENTED OUT
 Q
SET ;DINUM APSPCTRL FILE AND SET ZERO NODE
 Q:APSPSN=""
 K DD,D0
 S DINUM=APSPSN
 I $G(^APSPCTRL(APSPSN,0))]"" S DIK="^APSPCTRL(",DA=APSPSN D ^DIK
 S DIC="^APSPCTRL(",DIC(0)="",X=APSPSN D FILE^DICN G:Y'>0 EXIT
 S $P(^APSPCTRL(+Y,0),"^",2)="",$P(^APSPCTRL(+Y,0),"^",3)=$P(APSP1,"^",3),$P(^APSPCTRL(+Y,0),"^",4)=$P(APSP1,"^",4),$P(^APSPCTRL(+Y,0),"^",5)=$P(APSP1,"^",5)
 S $P(^APSPCTRL(+Y,0),"^",6)=$P(APSP1,"^",6),$P(^APSPCTRL(+Y,0),"^",7)=$P(APSP1,"^",7),$P(^APSPCTRL(+Y,0),"^",8)=$P(APSP1,"^",8),$P(^APSPCTRL(+Y,0),"^",9)=$P(APSP1,"^",9)
 S $P(^APSPCTRL(+Y,0),"^",10)=$P(APSP1,"^",10),$P(^APSPCTRL(+Y,0),"^",11)=$P(APSP1,"^",11),$P(^APSPCTRL(+Y,0),"^",12)=$P(APSP1,"^",12),$P(^APSPCTRL(+Y,0),"^",13)=$P(APSP1,"^",13)
 S $P(^APSPCTRL(+Y,0),"^",14)=$P(APSP1,"^",14),$P(^APSPCTRL(+Y,0),"^",15)=$P(APSP1,"^",15),$P(^APSPCTRL(+Y,0),"^",16)=$P(APSP1,"^",16),$P(^APSPCTRL(+Y,0),"^",17)=$P(APSP1,"^",17)
 S $P(^APSPCTRL(+Y,0),"^",18)=$P(APSP1,"^",18),$P(^APSPCTRL(+Y,0),"^",19)=$P(APSP1,"^",19),$P(^APSPCTRL(+Y,0),"^",21)=$P(APSP1,"^",21),$P(^APSPCTRL(+Y,0),"^",22)=$P(APSP1,"^",22)
 S $P(^APSPCTRL(+Y,0),"^",23)=$P(APSP1,"^",23),$P(^APSPCTRL(+Y,0),"^",24)=$P(APSP1,"^",24),$P(^APSPCTRL(+Y,0),"^",25)=$P(APSP1,"^",25),$P(^APSPCTRL(+Y,0),"^",26)=$P(APSP1,"^",26)
 S $P(^APSPCTRL(+Y,0),"^",27)=$P(APSP1,"^",27),$P(^APSPCTRL(+Y,0),"^",28)=$P(APSP1,"^",28),$P(^APSPCTRL(+Y,0),"^",29)=$P(APSP1,"^",29),$P(^APSPCTRL(+Y,0),"^",31)=$P(APSP1,"^",31)
 S $P(^APSPCTRL(+Y,0),"^",32)=$P(APSP1,"^",32),$P(^APSPCTRL(+Y,0),"^",33)=$P(APSP1,"^",33),$P(^APSPCTRL(+Y,0),"^",34)=$P(APSP1,"^",34),$P(^APSPCTRL(+Y,0),"^",35)="",$P(^APSPCTRL(+Y,0),"^",36)=$P(APSP1,"^",20)
 ;Index the newly created record
 S DIK="^APSPCTRL(",DA=+Y D IX1^DIK
 S ^APSPCTRL("FLAG")=APSPSIT
 Q
 ;
FIN ;
 K AP,APS,APSP1,DA,DIC,DINUM,APSPSIT,APSPSN,^APSPCTRL("FLAG")
EXIT Q
