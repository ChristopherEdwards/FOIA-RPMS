AQALPOST ; IHS/ORDC/LJF - SET UP MAS/QI EVENT DRIVER LINKS ;
 ;;1;QI LINKAGES-RPMS;;AUG 15, 1994
 ;
 ;This routine adds the option AQAL ADT EVENT to Protocol file.
 ;Then it will add the protocol AQAL ADT EVENT to the MAS event
 ;driver protocol entry if MAS 5 has been installed.
 ;
 I '$$MAS5 W !!,*7,"MAS5 NOT INSTALLED, BYPASSING POSTINIT!",!! Q
 D 1,2,QUIT Q
 ;
1 ; >> step 1: add aqal option to file 101
 S AQALOPT=$O(^DIC(19,"B","AQAL ADT EVENT",0))
 I AQALOPT="" D  Q
 .W !!,*7,"**ERROR!! Option AQAL ADT EVENT was not filed!**"
 .W !,"Contact developer immediately!!",!!,*7
 S X="ORV19" X ^%ZOSF("TEST") I '$T D  Q
 .W !!,*7,"**ERROR!! Routine ^ORV19 not in this UCI!"
 .W !,"Should have been installed with MAS version 5.0."
 .W !,"Contact developer immediately!!",!!,*7
 S X="AQAL" D EN^ORV19 ;moves options to file 101
 Q
 ;
2 ; >> step 2: add aqal protocol to mas event driver
 Q:AQALOPT=""
 S Y=+$O(^ORD(101,"B","DGPM MOVEMENT EVENTS",0))
 I 'Y D  Q
 .W !!,*7,"**ERROR!! Protocol DGPM MOVEMENT EVENTS does not exist!"
 .W !!,"Contact developer immediately!!",!!,*7
 I '$D(^ORD(101,Y,10,0)) S ^(0)="^101.01PA^^"
 S X="AQAL ADT EVENT",DA(1)=Y,DIC="^ORD(101,"_DA(1)_",10,"
 S DLAYGO=101,DIC(0)="L",DIC("DR")="3////2" D ^DIC K DIC,DLAYGO
 W !!,"Adding AQAL ADT EVENT to DGPM MOVEMENT EVENTS protocol. . ."
 W !!
 Q
 ;
QUIT ; >> eoj
 K AQALOPT D ^XBFMK Q
 ;
 ;
MAS5() ;EXTRN VAR to see if MAS version 5 has been installed
 N X,Y S (X,Y)=0
 F  S X=$O(^DIC(9.4,"C","DG",X)) Q:X=""  D
 .I $G(^DIC(9.4,X,"VERSION"))'<5 S Y=1 ;v5 is installed
 Q Y
