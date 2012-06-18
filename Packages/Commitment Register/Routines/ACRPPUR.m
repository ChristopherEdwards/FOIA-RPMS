ACRPPUR ; GENERATED FROM 'ACR PURCHASING OFFICE' PRINT TEMPLATE (#3892) ; 09/30/09 ; (FILE 9002199.4, MARGIN=80)
 G BEGIN
N W !
T W:$X ! I '$D(DIOT(2)),DN,$D(IOSL),$S('$D(DIWF):1,$P(DIWF,"B",2):$P(DIWF,"B",2),1:1)+$Y'<IOSL,$D(^UTILITY($J,1))#2,^(1)?1U1P1E.E X ^(1)
 S DISTP=DISTP+1,DILCT=DILCT+1 D:'(DISTP#100) CSTP^DIO2
 Q
DT I $G(DUZ("LANG"))>1,Y W $$OUT^DIALOGU(Y,"DD") Q
 I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 W Y Q
M D @DIXX
 Q
BEGIN ;
 S:'$D(DN) DN=1 S DISTP=$G(DISTP),DILCT=$G(DILCT)
 I $D(DXS)<9 M DXS=^DIPT(3892,"DXS")
 S I(0)="^ACRPO(",J(0)=9002199.4
 D N:$X>4 Q:'DN  W ?4 W "PURCHASING OFFICE......:"
 S X=$G(^ACRPO(D0,0)) W ?30 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTLOC(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^DIC(4,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>50 Q:'DN  W ?50 W "AREA SETUP:"
 W ?63 S Y=$P(X,U,19) S Y=$S(Y="":Y,$D(^ACRSYS(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^AUTTAREA(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,16)
 D N:$X>4 Q:'DN  W ?4 W "PURCHASING OFFICE CODE.:"
 W ?30,$E($P(X,U,7),1,6)
 D N:$X>4 Q:'DN  W ?4 W "FINANCE OFFICE.........:"
 W ?30 S Y=$P(X,U,8) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>4 Q:'DN  W ?4 W "REGIONAL FINANCE OFFICE:"
 W ?30 S Y=$P(X,U,16) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>4 Q:'DN  W ?4 W "AREA OFFICE............:"
 W ?30 S Y=$P(X,U,10) S Y=$S(Y="":Y,$D(^AUTTAREA(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>4 Q:'DN  W ?4 W "CONTRACT OFFICER.......:"
 W ?30 S Y=$P(X,U,11) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 D N:$X>4 Q:'DN  W ?4 W "PURCHASING SUPERVISOR..:"
 S X=$G(^ACRPO(D0,0)) W ?30 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^ACRPA(Y,0))#2:$P(^(0),U),1:Y) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 D N:$X>4 Q:'DN  W ?4 W "SADBUS COORDINATOR.....:"
 S X=$G(^ACRPO(D0,"DT")) W ?30 S Y=$P(X,U,7) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 D N:$X>4 Q:'DN  W ?4 W "ACCOUNTING POINT.......:"
 S X=$G(^ACRPO(D0,0)) W ?30 S Y=$P(X,U,4) S Y=$S(Y="":Y,$D(^AUTTACPT(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,2)
 D N:$X>4 Q:'DN  W ?4 W "LOCATION CODE..........:"
 W ?30 S Y=$P(X,U,5) S Y=$S(Y="":Y,$D(^AUTTLCOD(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>4 Q:'DN  W ?4 W "PRINTER................:"
 W ?30 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^%ZIS(1,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>44 Q:'DN  W ?44 W "TRAVEL PRINTER:"
 W ?61 S Y=$P(X,U,14) S Y=$S(Y="":Y,$D(^%ZIS(1,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,15)
 D N:$X>4 Q:'DN  W ?4 W "AREA PROPERTY PRINTER..:"
 W ?30 S Y=$P(X,U,15) S Y=$S(Y="":Y,$D(^%ZIS(1,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,12)
 D N:$X>44 Q:'DN  W ?44 W "SUPPLY PRINTER:"
 W ?61 S Y=$P(X,U,17) S Y=$S(Y="":Y,$D(^%ZIS(1,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,15)
 D N:$X>4 Q:'DN  W ?4 W "AREA PERSONNEL PRINTER.:"
 W ?30 S Y=$P(X,U,18) S Y=$S(Y="":Y,$D(^%ZIS(1,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,12)
 D N:$X>44 Q:'DN  W ?44 W "CONDENSED PRTR:"
 S X=$G(^ACRPO(D0,"DT")) D T Q:'DN  W ?2 S Y=$P(X,U,10) S Y=$S(Y="":Y,$D(^%ZIS(1,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>4 Q:'DN  W ?4 W "SIGNATURE WARNING DAYS.:"
 S X=$G(^ACRPO(D0,0)) W ?30 S Y=$P(X,U,6) W:Y]"" $J(Y,2,0)
 D N:$X>44 Q:'DN  W ?44 W "REQ TO FINANCE:"
 S X=$G(^ACRPO(D0,"DT")) W ?61 S Y=$P(X,U,9) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D N:$X>4 Q:'DN  W ?4 W "PHONE..................:"
 S X=$G(^ACRPO(D0,0)) W ?30,$E($P(X,U,9),1,12)
 D N:$X>44 Q:'DN  W ?44 W "FAX NUMBER....:"
 S X=$G(^ACRPO(D0,"DT")) W ?61,$E($P(X,U,8),1,15)
 D N:$X>4 Q:'DN  W ?4 W "ISSUING OFFICE.........:"
 W ?30 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>4 Q:'DN  W ?4 W "SHIP TO................:"
 W ?30 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>4 Q:'DN  W ?4 W "MAIL INVOICE TO........:"
 W ?30 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>4 Q:'DN  W ?4 W "INSPECTION LOCATION....:"
 W ?30 S Y=$P(X,U,4) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>4 Q:'DN  W ?4 W "TRAVEL VOUCHER AUDITOR.:"
 S X=$G(^ACRPO(D0,0)) W ?30 S Y=$P(X,U,13) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 D N:$X>4 Q:'DN  W ?4 W "TRAVEL PAYMT CERTIFIER.:"
 S X=$G(^ACRPO(D0,0)) W ?30 S Y=$P(X,U,12) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 D N:$X>4 Q:'DN  W ?4 W "PURCHASE ORDER # COPIES:"
 S X=$G(^ACRPO(D0,"DT")) W ?30 S Y=$P(X,U,6) W:Y]"" $J(Y,3,0)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
