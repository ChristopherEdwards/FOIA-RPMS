VENPCCG ; IHS/OIT/GIS - GET ICD PREFERENCES ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ;
 ;
A ; EP-DRIVER
 N TMP,CFIGIEN,PATH,VENDEPT,%Q,%T,%Y,AGE,AGEBUK,AGEGRP,AGESEX,AP,BD,C,CC,DESALL,DUB,ED,I,ICD,ICDPTR,MOST,MOSTPNP
 N NARR,PAT,PNP,POP,PROVLG,SEX,TOTPN,TYPE,VD,VDFN,VENFLNO,VENT,VIS,DIR,DOB,PROVFLG,FL,DXPRV
 S TMP="^TMP(""VEN PREF"",$J)" K @TMP
 S CFIGIEN=$$CFG^VENPCCU I 'CFIGIEN Q
 S PATH=$G(^VEN(7.5,CFIGIEN,12)) I '$L(PATH) Q
 D ^XBCLS
 W !!,"Extract most commonly used Diagnoses...",!!
 ;
 ;
DATES ; GET DATES FOR REPORT   
 K DIR S DIR(0)="DO",DIR("A")="Enter start date for the search" D ^DIR Q:Y=""!$D(DUOUT)!$D(DLOUT)  S BD=+Y
 S ED=DT ; FORCE ENDING DATE TYO BE TODAY
 ;
TYPE ;
 K DIR
 S DIR(0)="SX^C:Certain Provider Class(es);P:Individual Provider(s);A:All"
 S DIR("A")="ENTER Code for Search Criteria"
 D ^DIR
 Q:$D(DIRUT)
 S TYPE=Y
 I TYPE="C" K VEN("PC") D CLASS I '$D(VEN("PC")) G TYPE
 I TYPE="P" K VEN("PRV") D PRV I '$D(VEN("PRV")) G TYPE
 ;
T1 ; SET FILTER FLAGS
 ;
 S @TMP@("VPOV",0)=BD_"^"_ED
 I TYPE="C" D
 . S $P(@TMP@("VPOV",0),"^",3)="CLINIC"
 . I (VEN("PC",0)=1) S $P(@TMP@("VPOV",0),"^",3)=$O(VEN("PC",0))
 . Q
 I TYPE="P" D
 . S $P(@TMP@("VPOV",0),"^",3)="PROVIDERS"
 . I (VEN("PRV",0)=1) S $P(@TMP@("VPOV",0),"^",3)=$O(VEN("PRV",0))
 . Q
 D DEPT ; ASK IF USER WANTS TO ADD A DEPARTMENT FILTER
 I $G(NEWDXP) S DXPRV=$$GETPRV I 'DXPRV W !,"No provider specified.  Request terminated..." Q  ; ASSIGNED PROVIDER
 ; IF NO DEPT IS SELECTED, THEN IT DEFAULTS TO "ALL"
CONF W !!,"This will take a while..."
 I $G(NEWDXP) H 1
 E  W !,"Are you sure you want to proceed" S %=1 D YN^DICN I %'=1 W !,"BYE!" Q
 D ST^VENPCCG1 ; MINE RAW DATA
 D FILE^VENPCCG2 ; FORMAT/SUBMIT DATA FOR THE "TOP 100"
 ;
END ;
 Q
 ;
PRV ;
 N DIC,PRV,MORE,X,Y,Z
 S MORE=0
AP S DIC("A")="Enter "_$S(MORE:"another ",1:"")_"provider: "
 S DIC(0)="AEMQ"
 S %=$C(68)_"IC(6,",DIC=$S($G(^DD(9000010.06,.01,0))[%:(U_%),1:"^VA(200,")
 D ^DIC
 K DIC,DA Q:+Y<0
 S VEN("PRV",+Y)=""
 S VEN("PRV",0)=$G(VEN("PRV",0))+1
 S MORE=1 G AP
 Q
CLASS ;
 N X,Y,DIC,CLASS,MORE S MORE=0
AC S DIC("A")="Enter "_$S(MORE:"another ",1:"")_"Provider Class: ",DIC="^DIC(7,",DIC(0)="AEMQ" D ^DIC K DIC,DA Q:Y<0
 S VEN("PC",+Y)=""
 S VEN("PC",0)=$G(VEN("PC",0))+1
 S MORE=1 G AC
 Q
 ; 
DEPT ; FILTER RESULTS BY DEPARTMENT
 N DIR,X,Y,DIC
 W ! S DIR(0)="YO",DIR("A")="Do you want to limit search results to one particular clinic",DIR("B")="NO" KILL DA D ^DIR KILL DIR
 I Y'=1 Q
 S DIC(0)="AEQM",DIC=40.7,DIC("A")="Name the clinic: "
 D ^DIC I Y=-1 Q
 S VENDEPT=+Y ; DEPT FILTER FLAG
 Q
 ;
GETPRV() ; EP-RETURN THE IEN OF THE ACTUAL OR GENERIC PROVIDER
 N PIEN,CFIGIEN
 S PIEN="",CFIGIEN=$$CFG^VENPCCU
 I '$G(VENDEPT),$G(TYPE)="A",'$P($G(^VEN(7.5,CFIGIEN,0)),U,13) D  Q PIEN ; GET INSTITUTIONAL GENERIC PROVIDER
 . W !!,"There is no generic provider listed for this institution...",!,"You must enter one now."
 . W !,"Enter a name like 'PIMC,GENERIC PROVIDER' OR 'CROWNPOINT,GENERIC PROVIDER'"
 . W !,"You can also enter '??' or a partial name like 'PIMC",!,"to see if a suitable name already exists."
 . W !,"If you are asked to enter INITIALS, just type them in; e.g., 'GPP'."
 . W !,"If you are asked to enter a mail code, press the return key.",!
 . S DIC="^VA(200,",DIC(0)="AEQL",DLAYGO=200,DIC("A")="Generic Provider: "
 . D ^DIC I Y=-1 Q
 . S PIEN=+Y
 . S DIE="^VEN(7.5,",DR=".13////"_PIEN,DA=CFIGIEN
 . L +^VEN(7.5,DA):0 I $T D ^DIE L -^VEN(7.5,DA) ; STORE THE GENERIC PROVIDER IN THE CONFIG FILE
 . Q
 I '$G(VENDEPT),$G(TYPE)="A" D  Q PIEN
 . S PIEN=$P($G(^VEN(7.5,CFIGIEN,0)),U,13) ; USE INSTITUTIONAL GENERIC PROVIDER
 . W !!,"Preferences will be assigned",!,"to the Default Institutional Provider: ",$P($G(^VA(200,PIEN,0)),U)
 . Q
 I $G(VENDEPT),'$P($G(^VEN(7.95,VENDEPT,2)),U,2) D  Q PIEN ; CREATE THE DEPARTMENT'S GENERIC PROVIDER
 . W !!,"There is no generic provider listed for this clinic/department...",!,"You must enter one now."
 . D GP I 'PIEN Q
 . S DIE="^VEN(7.95,",DA=VENDEPT,DR="2.02////"_PIEN
 . L +^VEN(7.95,DA):0 I $T D ^DIE L -^VEN(7.95,DA) ; ASSIGN THE GENERIC PROVIDER TO THE CLINIC
 . Q
 I $G(VENDEPT) D  Q PIEN ; USE THE EXISTING DEPARTMENTAL PROVIDER
 . S PIEN=$P($G(^VEN(7.95,VENDEPT,2)),U,2) I 'PIEN Q
 . W !!,"Preferred diagnoses will be assigned to ",$P($G(^VA(200,PIEN,0)),U)
 . Q
 I TYPE="P",$G(VEN("PRV",0))=1 D  Q PIEN ; ASSIGN PREFERENCES TO AN INDIVIDUAL PROVIDER
 . S PIEN=$O(VEN("PRV",0)) I 'PIEN Q
 . W !!,"Preferred diagnoses will be assigned to ",$P($G(^VA(200,PIEN,0)),U)
 . Q
 W !!,"You must assign a generic provider to represent this group of providers..." ; DEFINE PROVIDER GROUP
 D GP
 Q PIEN
 ;
GP ; EP-GET A GENERIC PROVIDER
 W !!,"Enter a name like 'PIMC,PEDIATRICIAN' OR 'CROWNPOINT,FAMILY DOCTOR'"
 W !,"You can also enter '??' or a partial name like 'PIMC,'",!,"to see if a suitable name already exists."
 W !,"If you are asked to enter INITIALS, just type them in; e.g., 'FDC'."
 W !,"If you are asked to enter a mail code, press the return key.",!
 S DIC="^VA(200,",DIC(0)="AEQL",DLAYGO=200,DIC("A")="Clinic/department Provider: "
 D ^DIC I Y=-1 Q
 S PIEN=+Y
 W !,"NOTE: In the future, this generic provider can be assigned to other PCC+ forms or clincs",!!
 Q
 ;
NEWLIST ; EP - NEW WAY TO SAVE DX PREFERENCES
 N NEWDXP,DIC,X,Y,%
 W !!
 W ?20,"*****  WARNING  ****"
 W !,"This procedure may delete exsiting preferences of selected provider(s)!!!"
 W !,"Do you want to proceed"
 S %="" D YN^DICN
 I %'=1 D ^XBFMK Q
 S DIC("A")="Enter the name of the ICD Preference Group: " S DIC("B")="PRIMARY"
 S DIC="^VEN(7.33,",DIC(0)="AEQL",DLAYGO=19707.33
 D ^DIC I Y=-1 D ^XBFMK Q
 S NEWDXP=+Y ; STORE THE PREFERENCE GROUP IEN IN NEWDXP
 D ^XBFMK
 D A
 Q
 ; 
