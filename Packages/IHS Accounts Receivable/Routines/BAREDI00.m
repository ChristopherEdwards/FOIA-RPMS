BAREDI00 ; IHS/SD/LSL - ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;
EN ;EP EDI MAINTENANCE
 W !,"This enters/edits EDI transport architecute(s)"
 W !,"Please backup globals prior to changing",!!
 W !,?5,"1  Edit EDI Demographics"
 W !,?5,"2  Edit Data Types & Tranforms"
 W !,?5,"3  Edit Segments"
 W !,?5,"4  Edit Elements"
 W !,?5,"5  Auto Generate Tables "
 W !,?5,"6  Edit Tables"
 W !,?5,"7  Edit Claim Level Reason Codes"
 W !,?5,"8  Edit Variables' Processing Routines"
 W !,?5,"9  Print Variables by location within the transport"
 W !
 K DIR
 S DIR(0)="NO^1:9:0"
 D ^DIR
 K DIR
 S Y=+X
 I Y'>0 W !,"None Selected - Exiting",! H 2 Q
 I Y=1 D DEMOG^BAREDI01 G EN
 I Y=2 D EDTDATA^BAREDI01 G EN
 I Y=3 D EDTSEG^BAREDI01 G EN
 I Y=4 D EDTELEM^BAREDI01 G EN
 I Y=5 D GENTAB^BAREDI01 G EN
 I Y=6 D EDTTAB^BAREDI01 G EN
 I Y=7 D EDTCLAIM^BAREDI01 G EN
 I Y=8 D EDTVROU^BAREDI01 G EN
 I Y=9 D PRTVARS^BAREDI01 G EN
 Q
