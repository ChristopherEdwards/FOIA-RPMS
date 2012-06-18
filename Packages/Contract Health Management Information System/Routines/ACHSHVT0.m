ACHSHVT0 ; IHS/ITSC/PMF - TRANSMIT MDO REPORTS TO HV PROVIDERS ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 I '$D(^AUTTTEL(DUZ(2),2)) U IO(0) W *7,?10,"UNIX 3780 PORT NOT DEFINED FOR THIS FACILITY - CONTACT SITE MANAGER" G ABEND
 S ACHSTTY=$P(^AUTTTEL(DUZ(2),2),U,1)
 I $L(ACHSTTY)=1 S ACHSTTY="0"_ACHSTTY
 D ^ACHSTUT2
A0 ;
 S ACHSZOPT=0,ACHSZFN=$$AOP^ACHS(2,1)_"achsm*"
 D ARCHLIST^ACHSARCH
 K ACHSFILE("N")
 S ACHSR=""
A1 ;
 S ACHSR=$O(ACHSFILE(ACHSR))
 G A5:+ACHSR=0
 S ACHSN=$P($P(ACHSFILE(ACHSR),U,2),"/",5),ACHSN1=$E($P(ACHSN,".",1),7,8)
 S X=$P(ACHSN,".",2),Y=$$GDT^ACHS(X),X=$$JTF^ACHS(X)
 S ACHSXX=9999999-X,ACHSFILE("N",ACHSN1,ACHSXX,ACHSR)=ACHSN_U_Y
 G A1
 ;
A5 ;
 S ACHSR="",ACHSCT=0
 K ACHSVAB
 I $D(ACHSFILE("N")) G A6
 W !!?10,"No High Volume Provider Reports Available for Transmission",!!
 I $$DIR^XBDIR("E","Enter <RETURN> to Continue")
 G EXIT
 ;
A6 ;
 U IO(0)
 W !,"High Volume Provider Reports Exist for the Following Facilities/Vendors: ",!
A8 ;
 S ACHSR=$O(ACHSFILE("N",ACHSR))
 G A10:ACHSR=""
 S Z=$O(^ACHSF("HVEA",ACHSR,"")),X=$O(^ACHSF("HVEA",ACHSR,Z,"")),(ACHSVPTR,Y)=$P(^ACHSF(Z,18,X,0),U,1),ACHSFN=$P(^AUTTVNDR(Y,0),U,1),ACHSN1=$P(^ACHSF(Z,18,X,0),U,2),ACHSCT=ACHSCT+1,ACHSVAB(ACHSCT)=ACHSN1
 W !?10,$J(ACHSCT,3),"  ",ACHSFN
 G A8
 ;
A10 ;
 U IO(0)
 S Y=$$DIR^XBDIR("N^1:"_ACHSCT,"Select Facility/Vendor (by number)","","","","",1)
 I $D(DTOUT)!($D(DUOUT)) G EXIT
 S ACHSV=ACHSVAB(Y)
 K ACHSTXFN
A15 ;
 D SUBA11
 U IO(0)
 S Y=$$DIR^XBDIR("L^1:"_ACHSCT,"Enter Report #(s) to Transmit (eg 1,3,4 or 1-5):","","","","",1)
A16 ;
 F I=1:1:ACHSCT Q:$P(Y,",",I)=""  S Z=$P(Y,",",I),$P(ACHSTXFN(Z),U,2)="Y"
 K ACHSTLST
 S ACHSJ=0
 F I=1:1:ACHSCT I $P(ACHSTXFN(I),U,2)="Y" S ACHSJ=ACHSJ+1,ACHSTLST(ACHSJ)=$P(ACHSTXFN(I),U,1)
 D SUBA11
 U IO(0)
 W !!,"The Reports Selected Above will Now be Transmitted"
 S Y=$$DIR^XBDIR("Y","Is This Correct? (Y/N)","N","","","",1)
 I $D(DTOUT)!($D(DUOUT)) G EXIT
 I +Y=0 G A6
TXGEN ;
 U IO(0)
 W !
 I $$DEL^%ZISH("/usr/spool/3780/","achshv.txname")
 S ACHSZFN="/usr/spool/3780/achshv.txname"
 I $$OPEN^%ZISH("/usr/spool/3780/","achshv.txname","W") S ACHSEMSG="M10" D ERROR^ACHSTCK1 G ABEND
 S ACHSHFS1=IO,ACHSX=""
 U ACHSHFS1
 F ACHSI=1:1:ACHSJ D
 . W ACHSTLST(ACHSI)," "
 . S X=$P(ACHSTLST(ACHSI),".",2)
 . W $$GDT^ACHS(X)," "
 . S X=$E($P(ACHSTLST(ACHSI),".",1),6,6)
 . W $S(X=0:"MDO",X=2:"DEN",1:" "),!
 .Q
 I $D(ACHSHFS1) S IO=ACHSHFS1,IONOFF="" D ^%ZISC
 I $$DEL^%ZISH("/usr/spool/3780/","achshv.tx")
 S ACHSZFN="/usr/spool/3780/achshv.tx"
 I $$OPEN^%ZISH("/usr/spool/3780/","achshv.tx","W") S ACHSEMSG="M10" D ERROR^ACHSTCK1 G ABEND
 S ACHSHFS1=IO
B2A ;
 S ACHSX=""
 U ACHSHFS1
 W "AN 90",!,"branch not OK to 500",!,"te /usr/spool/3780/achshv.txname",!,"branch not NRMEOF to 200",!
 F I=1:1:ACHSJ W "te "_$$AOP^ACHS(2,1)_ACHSTLST(I),!,"branch not NRMEOF TO 200",!
 W "vo",!,"qu",!,"200 vo",!,"qu 18",!,"500 vo",!,"qu 20",!
 ;
 S IO=ACHSHFS1,IONOFF=""
 D ^%ZISC
B3 ;
 S ACHSHCMD="cd /usr/bin/3780;3780Plus -d /dev/tty"_ACHSTTY_" -c /usr/bin/3780/3780.cfgachs.s -j /usr/spool/3780/achshv.tx -b 4800"
 ;
 ;IHS/ITSC/PMF  1/12/01  replace call to vendor routine with call
 ;to routine in our namespace
 S ACHSRTCD=$$TERMINAL^ACHSHCMD(ACHSHCMD)
 ;
 I ACHSRTCD=0 G TXOK
 ;
 ;DOES THIS FUNCTION RETURN MORE THAN 1 AND 0 ?????
 I ACHSRTCD=18 U IO(0) W !!,*7,?10,"3780 TRANSMISSION FAILURE -- CONTACT SITE MANAGER" G ABEND
 I ACHSRTCD=20 U IO(0) W !!,*7,?10,"Auto-Answer Timeout Limit Reached - Transmission not Completed." G ABEND
EXIT ;
 D EN^XBVK("ACHS"),^ACHSVAR
 K DIC,DIR,I,X,Y,Z
 Q
 ;
TXOK ;
 U IO(0)
 W !!?10,"Transmission Successful"
 G ABEND
 ;
ABEND ;
 U IO(0)
 I $$DIR^XBDIR("E","Enter <RETURN> to Continue")
 G EXIT
 ;
SUBA11 ;
A11 ;
 S ACHSR="",ACHSCT=0
 U IO(0)
 W !!?10,"The Following Reports Are Available for Transmission to",!?25,$P(^AUTTVNDR(ACHSVPTR,0),U,1),!,$$REPEAT^XLFSTR("-",70),!,"Report #",?10,"Report Type",?30,"Report Date",?50,"File Name",?67,"TX",!,$$REPEAT^XLFSTR("-",70)
A12 ;
 S ACHSR=$O(ACHSFILE("N",ACHSV,ACHSR))
 G A13:ACHSR=""
 S X="",X=$O(ACHSFILE("N",ACHSV,ACHSR,X)),ACHSRXX=$E(ACHSFILE("N",ACHSV,ACHSR,X),6,6),ACHSRTYP=$S(ACHSRXX="0":"MAST DEL ORDER",ACHSRXX="2":"DENIAL LIST",1:" "),ACHSCT=ACHSCT+1,$P(ACHSTXFN(ACHSCT),U,1)=$P(ACHSFILE("N",ACHSV,ACHSR,X),U,1)
 W !?5,ACHSCT,?10,ACHSRTYP,?30,$P(ACHSFILE("N",ACHSV,ACHSR,X),U,2),?50,$P(ACHSFILE("N",ACHSV,ACHSR,X),U,1),?68,$P(ACHSTXFN(ACHSCT),U,2)
 G A12
 ;
A13 ;
 Q
 ;
