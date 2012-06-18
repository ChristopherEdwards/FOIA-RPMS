ACHSHV04 ; IHS/ITSC/PMF - PRINT/PROCESS HV NOTIFICATION DATA ;  [ 06/27/2003  8:35 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 D HOME^%ZIS
 S ACHSHMD=IO(0)
 U ACHSHMD
 W !,$$C^XBFUNC("Just a moment -- Reading File Information",70),!
A0 ; Mail Loop.
 D ^ACHSHVRC
 G:$G(ACHSJFLG) END
A1 ; Display name of vendors that reports exist for.
 S (ACHSR,ACHSRR,ACHSCT)=0
 U ACHSHMD
 W !!?5,"NOTIFICATION REPORTS EXIST FOR THE FOLLOWING VENDORS: ",!!
A2 ;
 K ACHSCTZ
A2A ;
 S ACHSR=$O(^ACHSHVLG("C",ACHSR))
 G A5:+ACHSR=0
 S ACHSCT=ACHSCT+1,ACHSCTZ(ACHSCT)=ACHSR,ACHSFN=$E($P(^AUTTVNDR(ACHSR,0),U,1),1,30)
 U ACHSHMD
 W ?5,ACHSCT,?10,ACHSFN,!
 G A2A
 ;
A5 ; Ask user to pick vendor.
 I 'ACHSCT U IO(0) W !?10,"NONE FOUND..." S %=$$DIR^XBDIR("E","Press RETURN...") G ENDZ
 S X=$$DIR^XBDIR("N^1:"_ACHSCT,"Enter Number of Vendor to Print/Process","","","","",1)
 I $D(DUOUT)!($D(DTOUT)) G ENDZ
 S ACHSV=ACHSCTZ(X)
 K ACHSCTZ
 S ACHSCNT=0
FILDPSC ; Display file info about selected vendor.
 S (ACHSR,ACHSRR,ACHSDELD,ACHSCNT,ACHSDSAV)=0
 K ACHSCTZ
 S X="",$P(X,"-",73)=""
 U ACHSHMD
 W !!,X,!," #",?5,"UNIX FILE",?17,"REPORT",?25,"REPORT  DATE",?38,"# RCDS",?46,"LAST PRINTED",?60,"PROCESS DATE",!,X,!
FILDPSC1 ;
 S ACHSR=$O(^ACHSHVLG("C",ACHSV,ACHSR))
 G FILDPSF:+ACHSR=0
FILDPSC2 ;
 S ACHSRR=$O(^ACHSHVLG("C",ACHSV,ACHSR,ACHSRR))
 G FILDPSC1:+ACHSRR=0
 S ACHSCNT=ACHSCNT+1,ACHSCTZ(ACHSCNT)=ACHSRR
 W !,$J(ACHSCNT,3),?5,$P(^ACHSHVLG(ACHSV,1,ACHSRR,0),U,4)
 S X=$P(^ACHSHVLG(ACHSV,1,ACHSRR,0),U,2)
 W ?17,$S(X="O":"OUTPAT",X="D":"DENTAL",X="I":"INPAT",1:"UNKNWN")
 S Y=$P(^ACHSHVLG(ACHSV,1,ACHSRR,0),U,1)
 D DD^%DT
 W ?25,Y,?38,$J($P(^ACHSHVLG(ACHSV,1,ACHSRR,0),U,3),5)
 S Y=$P(^ACHSHVLG(ACHSV,1,ACHSRR,0),U,5)
 G:+Y=0 FILDSKP6
 D DD^%DT
 W ?46,Y
FILDSKP6 ;
 S Y=$P(^ACHSHVLG(ACHSV,1,ACHSRR,0),U,6)
 G FILDSKP7:+Y=0
 D DD^%DT
 W ?60,Y
FILDSKP7 ;
 G FILDPSC2
 ;
FILDPSF ; Ask user to pick file.
 U ACHSHMD
 S X=$$DIR^XBDIR("N^1:"_ACHSCNT,"Enter Number of Notification File to Print/Scan for Errors","","","","",1)
 I $D(DUOUT)!($D(DTOUT)) G A1
 S ACHSNO=ACHSCTZ(X)
B2 ; Ask user to PRINT or SCAN FOR ERRORS.
 S Y=$$DIR^XBDIR("S^1:PRINT;2:SCAN REPORT FOR ERRORS")
 I $D(DUOUT)!($D(DTOUT)) G FILDPSC
 G PRINTSEL:Y=1,PROCESS:Y=2
 Q
 ;
PRINTSEL ; Select printer for report.
 U ACHSHMD
 W !!
 S %ZIS="NP",%ZIS("A")="Print report on which Printer: "
 D ^%ZIS
 K %ZIS
 I POP U ACHSHMD W !,*7,"Device Not Available -- Job Aborted" G END
 I $D(IO("S")) U IO(0) W !!,*7,?10,"Selection of Slave Printer not allowed -- Please Select Again" G PRINTSEL
 S ACHSPTRN=ION
 I IOM<132 W !!,*7,"Device Right Margin < 132 Char -- Select another Device" G PRINTSEL
 S ACHSPRT=IO
 D CHK16^ACHSPS16
 G A0:$D(DUOUT)
 I '$D(ACHS("PRINT","ERROR")) G A7A
 G A0:$$DIR^XBDIR("E"),END
 ;
A7A ;
 U IO(0)
 W !!?10,"Your Request is now being Processed",!
A7B ;
 S IOP=ACHSPTRN
 D ^%ZIS
 I POP U IO(0) W !!,"Device Unavailable" G END
A7C ;
 I $D(ACHS("PRINT",16)) U ACHSPRT W @ACHS("PRINT",16)
 S ACHSRCT=0
 K ACHSKILL
 S ACHSZFN=$$AOP^ACHS(2,1)_$P(^ACHSHVLG(ACHSV,1,ACHSNO,0),U,4)
 I $$OPEN^%ZISH($$AOP^ACHS(2,1),$P(^ACHSHVLG(ACHSV,1,ACHSNO,0),U,4),"R") S ACHSEMSG="M10" D ERROR^ACHSTCK1 G END
 S ACHSHFS1=IO
 U ACHSHMD
 W !!
 F ACHSI=1:1 U ACHSHFS1 R ACHSLINE:1 G SUSPEND:'$T G PREOF:$$STATUS^%ZISH D PRINT G SUSPEND:$D(ACHSKILL)
 Q
 ;
PREOF ;
 U ACHSHMD
 W !!,"PRINTING HAS COMPLETED "
 I $D(^ACHSHVLG(ACHSV,1,ACHSNO,0)) S $P(^(0),U,5)=DT
 I $$DIR^XBDIR("E","Press <RETURN> To Continue....")
 G A1
 ;
PRINT ; Check if user has pressed ESC, else print line.
 S ACHSRCT=ACHSRCT+1
 I (ACHSRCT#60)=0 G PRINTC
 G PRINTR
 ;
PRINTC ;
 U ACHSHMD
 R *ACHSESC:1 ; Exception for star read.
 I ACHSESC=27 G PTRSTOP
PRINTR ;
 U ACHSPRT
 W ACHSLINE,!
 Q
 ;
PTRSTOP ; User pressed ESC to suspend printing.
 U ACHSHMD
 W *7,*7,*7
 F  R ACHSESC:0 E  Q  ; Clear Keyboard buffer, if any.
 I $$DIR^XBDIR("E","Enter <RETURN> to continue '^' to Cancel Printing","","","","",2)
 I $D(DUOUT) S ACHSKILL=""
 Q
 ;
SUSPEND ; User suspended printing.
 U IO(0)
 S Y=$$DIR^XBDIR("Y","Printing SUSPENDED -- Do you want to print other Reports","","","","",2)
 I $D(DUOUT)!($D(DTOUT)) G END
 I +Y=1 G FILDPSC
 G A1
 ;
PROCESS ; Ensure OUTPAT report, then scan.
 G PROCESSA:$P(^ACHSHVLG(ACHSV,1,ACHSNO,0),U,2)["O"
 U IO(0)
 W *7,!!?10,"Only Outpatient Reports can be Scanned for Errors"
 H 3
 G A1
 ;
PROCESSA ;
 D ^ACHSHV01
 G A1
 ;
END ; Reset printer from condensed print.
 D 10^ACHSPS16
ENDZ ; Close device(s), kill vars, quit.
 I $D(ACHSPRT) S IO=ACHSPRT D ^%ZISC
 I $D(ACHSHFS1) S IO=ACHSHFS1 S IONOFF="" D ^%ZISC
 D EN^XBVK("ACHS"),^ACHSVAR
 K X,Y,DIC,DIR,DA,Z
 Q
 ;
