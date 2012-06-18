ACHSDARR ; IHS/ITSC/PMF - PATIENT RELEASE OF INFORMATION FOR ALT RES ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ;'PARENT OR GUARDIAN (CHILD)'
 S ACHDNAME=$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,800,ACHDALRS,0)),U,4)
 G START:ACHDNAME'=""
 ;
 ;'IS PATIENT REGISTERED?'
 I $$DN^ACHS(0,6)="Y" S ACHDNAME=$P($G(^DPT($$DN^ACHS(0,7),0)),U) G START
 I $$DN^ACHS(0,6)="N" S ACHDNAME=$$DN^ACHS(10,1)
 ;
START ;
 W @IOF,!!!!!!!!!!
 S ACHD=0
 F I=1:1:$L(ACHDNAME) S ACHD=$E(ACHDNAME,I) Q:ACHD=","  G:ACHD="" START1
 S ACHDNAME=$P(ACHDNAME,",",2)_" "_$P(ACHDNAME,",")
 ;
START1 ;
 S X=$P($G(^AUTNINS($P($G(^ACHSDEN(DUZ(2),"D",ACHSA,800,ACHDALRS,0)),U),0)),U)
 S X="I, |_|"_ACHDNAME_"|_|, hereby authorize and request the |_|"_X_"|_| to release any and all information contained in my files to the Indian Health Service, Contract Health Services (CHS) Office."
 D ^DIWP
 S X="Information in the file should be forwarded to the following address: "
 D ^DIWP,^DIWW
 W !!!?DIWL+10,$$SUD^ACHS(1)
 I $L($$SUD^ACHS(7)) W !?DIWL+10,$$SUD^ACHS(7)
 ;
 W !?DIWL+10,$$SUD^ACHS(2),!?DIWL+10,$$SUD^ACHS(3),", ",$P($G(^DIC(5,$$SUD^ACHS(4),0)),U,2),"  ",$$SUD^ACHS(5),!?DIWL+10,"Telephone: ",$$SUD^ACHS(6),!?DIWL+10,"ATTN: Contract Health",!!!
 S X="This information will aid the CHS Office in assisting and/or representing me in completing my application for alternate resources."
 D ^DIWP,^DIWW
 W !!!?DIWL+5,"Dated this ",$$DATE(DT,"DD",1)," day of ",$$DATE(DT,"MM",1),", ",$$DATE(DT,"YY"),"."
 W !!!!!?DIWL+30,"_________________________________",!!?DIWL+30,ACHDNAME
END ;
 Q
 ;
DATE(D,P,O) ;EP - "D" = Date, "P" = Part of Date, "O" = Option
 ;              if Month or day.
 I '$G(D) Q -1
 I $L($G(P))'=2 Q -1
 I "MMDDYY"'[P Q -1
 S O=$G(O)
 S Y=$$FMTE^XLFDT(D)
 I P="YY" Q $P(Y," ",3)
 I P="MM" D  Q Y
 . S Y=$P(Y," ",1)
 . Q:'O
 . S %=Y,Y=$S(%="Jan":"January",%="Feb":"February",%="Mar":"March",%="Apr":"April",%="May":%,%="Jun":"June",%="Jul":"July",%="Aug":"August",%="Sep":"September",%="Oct":"October",%="Nov":"November",1:"December")
 .Q
 S Y=$P(Y," ",2),Y=+$P(Y,",",1)
 Q:'O Y
 S %=Y,Y=Y_$S(%=1:"st",%=2:"nd",%=3:"rd",((%>3)&(%<21)):"th",%=21:"st",%=22:"nd",%=23:"rd",((%>23)&(%<31)):"th",1:"st")
 Q Y
 ;
