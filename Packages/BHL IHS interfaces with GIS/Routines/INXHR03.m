INXHR03 ; GENERATED FROM 'INH BACKGROUND PROCESS DISPLAY' PRINT TEMPLATE (#2830) ; 10/25/01 ; (FILE 4004, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(2830,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D N:$X>0 Q:'DN  W ?0 W "Process Name:"
 S X=$G(^INTHPC(D0,0)) D N:$X>14 Q:'DN  W ?14,$E($P(X,U,1),1,60)
 D T Q:'DN  D N D N:$X>3 Q:'DN  W ?3 W "Active/Inactive:"
 D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 D N:$X>35 Q:'DN  W ?35 W "Routine:"
 S X=$G(^INTHPC(D0,"ROU")) D N:$X>44 Q:'DN  W ?44,$E($E(X,1,50),1,30)
 D T Q:'DN  D N D N:$X>10 Q:'DN  W ?10 W "Priority:"
 S X=$G(^INTHPC(D0,0)) D N:$X>20 Q:'DN  W ?20,$E($P(X,U,6),1,2)
 D N:$X>36 Q:'DN  W ?36 W "Device:"
 D N:$X>44 Q:'DN  W ?44,$E($P(X,U,3),1,20)
 D T Q:'DN  D N D N:$X>3 Q:'DN  W ?3 W "Connection Type:"
 D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,9) W:Y]"" $S($D(DXS(4,Y)):DXS(4,Y),1:Y)
 D T Q:'DN  D N D N:$X>5 Q:'DN  W ?5 W "Client/Server:"
 D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,8) W:Y]"" $S($D(DXS(5,Y)):DXS(5,Y),1:Y)
 D N:$X>42 Q:'DN  W ?42 W "Server IP Port"
 S DICMX="D L^DIWP" D T Q:'DN  D N D N:$X>44 Q:'DN  S DIWL=45,DIWR=74 N DIP S I(1,0)=$G(D1) X DXS(1,9.3):D0>0 S X="" S D1=I(1,0) K DIP K:DN Y
 D A^DIWW
 D T Q:'DN  D N D N:$X>5 Q:'DN  W ?5 W "Client IP Address                    Client IP Port"
 S I(1)=6,J(1)=4004.03 F D1=0:0 Q:$O(^INTHPC(D0,6,D1))'>0  X:$D(DSC(4004.03)) DSC(4004.03) S D1=$O(^(D1)) Q:D1'>0  D:$X>5 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^INTHPC(D0,6,D1,0)) D N:$X>7 Q:'DN  W ?7,$E($P(X,U,1),1,35)
 S I(2)=1,J(2)=4004.04 F D2=0:0 Q:$O(^INTHPC(D0,6,D1,1,D2))'>0  X:$D(DSC(4004.04)) DSC(4004.04) S D2=$O(^(D2)) Q:D2'>0  D:$X>7 T Q:'DN  D A2
 G A2R
A2 ;
 S X=$G(^INTHPC(D0,6,D1,1,D2,0)) D N:$X>44 Q:'DN  S DIWL=45,DIWR=74 S Y=$P(X,U,1) S X=Y D ^DIWP
 D A^DIWW
 Q
A2R ;
 Q
A1R ;
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "--------------------------- Parameters --------------------------------------"
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "Open Hang Time:"
 S X=$G(^INTHPC(D0,1)) D N:$X>20 Q:'DN  W ?20,$E($P(X,U,2),1,6)
 D N:$X>30 Q:'DN  W ?30 W "Open Retries:"
 D N:$X>44 Q:'DN  W ?44,$E($P(X,U,1),1,3)
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "Send Hang Time:"
 D N:$X>20 Q:'DN  W ?20,$E($P(X,U,12),1,5)
 D N:$X>30 Q:'DN  W ?30 W "Send Retries:"
 D N:$X>44 Q:'DN  W ?44,$E($P(X,U,11),1,3)
 D N:$X>53 Q:'DN  W ?53 W "Send Timeout:"
 D N:$X>67 Q:'DN  W ?67,$E($P(X,U,4),1,4)
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "Read Hang Time:"
 D N:$X>20 Q:'DN  W ?20,$E($P(X,U,6),1,5)
 D N:$X>30 Q:'DN  W ?30 W "Read Retries:"
 D N:$X>44 Q:'DN  W ?44,$E($P(X,U,5),1,3)
 D N:$X>52 Q:'DN  W ?52 W "Rec'v Timeout:"
 D N:$X>67 Q:'DN  W ?67,$E($P(X,U,3),1,4)
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "Transmitter Hang:"
 D N:$X>20 Q:'DN  W ?20,$E($P(X,U,10),1,6)
 D T Q:'DN  D N D N:$X>7 Q:'DN  W ?7 W "End of Line:"
 D N:$X>20 Q:'DN  W ?20,$E($P(X,U,7),1,60)
 D T Q:'DN  D N D N:$X>7 Q:'DN  W ?7 W "Init String:"
 D N:$X>20 Q:'DN  W ?20,$E($P(X,U,8),1,60)
 D T Q:'DN  D N D N:$X>5 Q:'DN  W ?5 W "Init Response:"
 D N:$X>20 Q:'DN  W ?20,$E($P(X,U,9),1,60)
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "------------------------------------------------------------------------------"
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "Status                     $JOB     Last Run Update        Last Started"
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W ""
 X DXS(2,9) K DIP K:DN Y
 S X=$G(^INTHPC(D0,0)) D N:$X>27 Q:'DN  W ?27,$E($P(X,U,4),1,7)
 D N:$X>36 Q:'DN  W ?36 W ""
 W $$LAST^INHB(D0)  K DIP K:DN Y
 S X=$G(^INTHPC(D0,0)) D N:$X>59 Q:'DN  W ?59 S Y=$P(X,U,5) D DT
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "Errors:"
 D T Q:'DN  D N D N:$X>3 Q:'DN  W ?3 W "Date/Time           Error"
 D T Q:'DN  D N D N:$X>3 Q:'DN  W ?3 W "---------           -----"
 S I(1)=2,J(1)=4004.01 F D1=0:0 Q:$O(^INTHPC(D0,2,D1))'>0  X:$D(DSC(4004.01)) DSC(4004.01) S D1=$O(^(D1)) Q:D1'>0  D:$X>3 T Q:'DN  D B1
 G B1R^INXHR031
B1 ;
 G ^INXHR031
