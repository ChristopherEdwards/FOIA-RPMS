BHLRXPST ; IHS/TUCSON/DCP - HL7 - POST-INIT FOR COTS PHARMACY INSTALLATION ;
 ;;1.0;IHS SUPPORT FOR HL7 INTERFACES;;JUL 7, 1997
 ;
 ; This routine performs all necessary post-init actions. It is called
 ; from the MUMPS prompt: ">" This routine does not require any pre-
 ; defined external variables.
 ;
START ; ENTRY POINT from MUMPS prompt ">"
 S BHLPKG=$O(^DIC(9.4,"C","BHL",""))
 D ^XBKVAR
 ;
LOC ;
 S BHLLOC=""
 S DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("A")="Enter Facility:  ",DIC("B")=$P(^DIC(4,DUZ(2),0),U) D ^DIC K DIC,DA
 G:Y=-1 LOC
 S BHLLOC=+Y
 ;
 D   ;                 find/create PHARM MGR mail grp
 . S BHLMGRP=$O(^XMB(3.8,"B","PHARM MGR",0))
 . I BHLMGRP W !,"PHARM MGR Mail Group already exists.  Nothing added.",!! Q
 . K DD,DO
 . S DIC="^XMB(3.8,",DIC(0)="L",DLAYGO=3.8
 . S DIC("DR")="4////PU;5////"_DUZ_";5.1////"_DUZ_";10////0;3///This is the PHARM MGR Mail Group."
 . S X="PHARM MGR"
 . D FILE^DICN K DIC
 . I Y<0 W !,"Entry was unsuccessful:  ",X K X Q
 . W:+Y !!?5,"I created a PHARM MGR Mail Group entry.  Please add appropriate",!?5,"members to this group.",!
 . S BHLMGRP=+Y
 . K X,Y,DLAYGO
 . Q
 ;
 D   ;                add PHARM MGR mail grp to bulletins
 . S BHLBULL1="BHLBPS RX-PCC MESSAGE ERROR"
 . S BHLBULL2="BHLBPS RX-PCC LINK DATA ERROR"
 . F BHLBULL=BHLBULL1,BHLBULL2 D
 . . S BHLBIEN=$O(^XMB(3.6,"B",BHLBULL,0))
 . . I 'BHLBIEN W !,BHLBULL," bulletin not found.....I was unable to add this bulletin to the PHARM MGR mail group." Q
 . . Q:$D(^XMB(3.6,BHLBIEN,2,"B",BHLMGRP))  ;quit if already there
 . . S DIC="^XMB(3.6,"_BHLBIEN_",2,"
 . . S DIC(0)="L"
 . . S DIC("P")=$P(^DD(3.6,4,0),U,2)
 . . S DA(1)=BHLBIEN
 . . S X=BHLMGRP
 . . K DD,DO D FILE^DICN K DIC
 . . I +Y<0 W !?5,"Multiple entry was unsuccessful:  ",X K X Q
 . . W !?5,"PHARM MGR Mail Group added to the "_BHLBULL_" Bulletin."
 . . K X,Y,DA
 . . Q
 . K BHLBIEN,BHLBULL,BHLBULL1,BHLBULL2
 . W !!
 ;
ADDEN ; ENTRY POINT - Add entries to the HL7 APPLICATION PARAMETER and PROTOCOL files
 ; This entry point is only used if it is necessary to restart the post-
 ; init process after installing the DHCP HL7 package.
 ;
 S BHLHL7=$O(^DIC(9.4,"B","HEALTH LEVEL SEVEN",0))
 I 'BHLHL7 D  G XIT
 . W !?5,"Cannot find the HEALTH LEVEL SEVEN package entry.  Unable to install"
 . W !?5,"the required entries to the following files:"
 . W !!?30,"HL7 APPLICATION PARAMETER",!?30,"PROTOCOL"
 . W !!!!?5,"Once the HL7 Package has been installed, this process can"
 . W !?5,"be restarted with the following command:  D ADDEN^BHLRXPST",!!
 . K BHLHL7
 . Q
 K BHLHL7
 ;
 W !,"Adding required entries to the HL7 APPLICATION PARAMETER file."
 D START^BHLRXPS1
 ;
 W !!,"Adding required entries to the PROTOCOL file."
 D START^BHLRXPS2
 ;
HLLOG ; add entry to HL7 LOWER LEVEL PROTOCOL file
 I $D(^HLCS(869.2,"B","BPSLNK")) W !!,"HL7 Lower Level Protocol Parameter exists" G HLLOG1
 K DD,DO
 S DIC(0)="L",DIC="^HLCS(869.2,",DLAYGO=869.2,DIADD=1,X="BPSLNK",DIC("DR")=".02///HLLP;200.02////3;200.04////10;200.05////10;200.06////11;200.07////28;200.08////22" D FILE^DICN
 W:Y=-1 !!,"Entry of HL7 Lower Level Protocol Entry FAILED!"
 W:Y'=-1 !!,"Adding HL7 Lower Level Protocol Entry."
 ;
HLLOG1 ; add entry to HL LOGICAL LINK
 I $D(^HLCS(870,"B","BPSLNK")) W !!,"HL Logical Link already exists." G XIT
 K DD,DO
 S DIC(0)="L",DIC="^HLCS(870,",X="BPSLNK",DLAYGO=870,DIADD=1,DIC("DR")="1////H;2///BPSLNK;21////2000" D FILE^DICN
 W:Y=-1 !!,"Entry of HL7 Logical Link FAILED!",!!
 W:Y'=-1 !!,"Adding HL7 Logical Link Entry."
 ;
 ; update subscriber protocol with logical link
 S DIE="^ORD(101,",DR="770.7////"_$O(^HLCS(870,"B","BPSLNK","")),DA=$O(^ORD(101,"B","BHLBPS","")) D:DA'="" ^DIE
 ;
XIT ;
 K DA,DIC,DR,Y,X,D0,DD,DI,DIE,DIX,DIY,DIZ,DO,DQ,DZ
 K BHLPKG,BHLLOC,BHLMGRP,BHLFAC,BHLCODE
 K BHLACACK,BHLAPACK,BHLDIC,BHLDR,BHLEVNT,BHLFLG,BHLIEN,BHLISEQC,BHLITEM
 K BHLMTG,BHLMTR,BHLNAME,BHLPTR,BHLTEXT,BHLVID,BHLTYPE
 W !,"ALL DONE WITH POST-INIT",!!
 Q
