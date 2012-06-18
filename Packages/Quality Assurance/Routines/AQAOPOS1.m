AQAOPOS1 ; IHS/ORDC/LJF - POST INIT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This is a continuation of postinits.  Installs
 ;indicators sent with the package, then calls ^AQAOPOS2.
 ;
2 ; step 2 - install indicators sent with pkg
 W !!,"STEP 2 - INSTALL INDICATORS DISTRIBUTED WITH PACKAGE",!!
 W !,"I will install any indicator you do not already have PLUS"
 W !,"those you do have but which are inactive.",!!
 ;
 ;want to update inactive ind?
 I $O(^AQAO(2,0)) S AQAOUPD=$$INACT I AQAOUPD=U!(AQAOUPD="")!(AQAOUPD="N") G NEXT
 ;
 ; loop thru indicators in scratch file
 S AQAOX=0 L +^AQAO(2,0):1
 I '$T W !!,"INDICATOR FILE LOCKED!  BYPASSING STEP 2!",!! G NEXT
 F  S AQAOX=$O(^AQAOXX(2,AQAOX)) Q:AQAOX'=+AQAOX  D
 .S AQAOID=$P(^AQAOXX(2,AQAOX,0),U)
 .;  if ind exists & inactive, ok to update?
 .I $D(^AQAO(2,"B",AQAOID)) D  Q:$G(AQAONUPD)=U
 ..S DA=$O(^AQAO(2,"B",AQAOID,0)) Q:DA=""  ;bad xref
 ..I $P($G(^AQAO(2,DA,0)),U,6)'="I" S AQAONUPD=U Q  ;do not update active ind
 ..I AQAOUPD="S" S AQAONUPD=$$UPD Q:AQAONUPD=U  ;not ok to update
 ..S DIE="^AQAO(2,",DR=$$DRSET D ^DIE S Y=DA ;update ind
 .;
 .E  D  ; else create entry
 ..K DIC,DD,DO S DIC="^AQAO(2,",DIC(0)="L",DLAYGO=9002164
 ..S X=AQAOID,DIC("DR")=$$DRSET ;set dr string from gbl
 ..D FILE^DICN Q:Y=-1
 .;
 .S AQAOIFN=+Y,AQAOCNT=0 ;set descrip wp field
 .F  S AQAOCNT=$O(^AQAOXX(2,AQAOX,"D",AQAOCNT)) Q:AQAOCNT=""  D
 ..S ^AQAO(2,AQAOIFN,"D",AQAOCNT,0)=^AQAOXX(2,AQAOX,"D",AQAOCNT,0)
 .S ^AQAO(2,AQAOIFN,"D",0)=U_U_AQAOCNT_U_AQAOCNT_U_DT
 .;
 .S AQAOCNT=0 ;set methodology wp field
 .F  S AQAOCNT=$O(^AQAOXX(2,AQAOX,"M",AQAOCNT)) Q:AQAOCNT=""  D
 ..S ^AQAO(2,AQAOIFN,"M",AQAOCNT,0)=^AQAOXX(2,AQAOX,"M",AQAOCNT,0)
 .S ^AQAO(2,AQAOIFN,"M",0)=U_U_AQAOCNT_U_AQAOCNT_U_DT
 .;
 .;install review criteria for ind
 .Q:'$D(^AQAOXX(6,"C",AQAOX))  ;no crit for ind
 .D CRIT ;install crit & ind links
 ;
 L -^AQAO(2,0)
NEXT ; go to next rtn for more
 D ^AQAOPOS2 Q
 ;
 ;
CRIT ; SUBRTN to install criteria for ind
 L +^AQAO1(6,0):1 I '$T W !!,"QI REVIEW CRITERIA file locked!" Q
 L +^AQAO1(4,0):1 I '$T W !!,"QI CRITERIA CODES file locked" Q
 ;
 S AQAOC=0 ;get all crit for ind,add to site's file
 F  S AQAOC=$O(^AQAOXX(6,"C",AQAOX,AQAOC)) Q:AQAOC=""  D
 .Q:'$D(^AQAOXX(6,AQAOC,0))  S AQAOS=^(0)
 .;
 .; if crit doesn't exist, add it
 .I '$D(^AQAO1(6,"B",$E($P(AQAOS,U),1,30))) D
 ..K DD,DO,DIC S DIC="^AQAO1(6,",DIC(0)="L",X=$P(AQAOS,U)
 ..S DIC("DR")=".02////"_$P(AQAOS,U,2)_";.03////"_$P(AQAOS,U,3)_";.04////"_$P(AQAOS,U,4)
 ..S DLAYGO=9002169 D FILE^DICN K DLAYGO
 ..I Y=-1 W !!,"Can't ADD ",$P(^AQAOXX(6,AQAOC,0),U)," as criterion." Q
 ..S AQAOCIFN=+Y
 ..;
 ..S AQAOCD=0 ;add any crit codes, if any
 ..F  S AQAOCD=$O(^AQAOXX(6,AQAOC,"CD",AQAOCD)) Q:AQAOCD'=+AQAOCD  D
 ...Q:'$D(^AQAOXX(6,AQAOC,"CD",AQAOCD,0))  S AQAOCOD=^(0)
 ...S AQAOSS=$G(^AQAOXX(4,AQAOCOD,0))
 ...S AQAOCODN=$$CODE Q:AQAOCODN=U  ;get code,create if needed
 ...I '$D(^AQAO1(6,AQAOCIFN,"CD",0)) S ^(0)="^9002169.61P^^"
 ...S DIC="^AQAO1(6,"_AQAOCIFN_",""CD"",",DA(1)=AQAOCIFN
 ...S DIC(0)="L",X=AQAOCODN D ^DIC
 .;
 .; link indicator to crit entry
 .S AQAOCIFN=$O(^AQAO1(6,"B",$E($P(AQAOS,U),1,30),0)) Q:AQAOCIFN=""
 .Q:$D(^AQAO1(6,"C",AQAOIFN,AQAOCIFN))  ;already linked
 .I '$D(^AQAO1(6,AQAOCIFN,"IND",0)) S ^(0)="^9002169.699P^^"
 .S DIC="^AQAO1(6,"_AQAOCIFN_",""IND"",",DA(1)=AQAOCIFN
 .S DIC(0)="L",X=$P(^AQAO(2,AQAOIFN,0),U) D FILE^DICN
 L -^AQAO1(6,0) L -^AQAO1(4,0)
 Q
 ;
 ;
CODE() ; EXTR VAR to add crit codes to file
 N X,DD,DO,DIC,Y,DLAYGO
 S X=$O(^AQAO1(4,"B",$E($P(AQAOSS,U),1,30),0)) I X="" S Y=""
 I X]"",($P(AQAOSS,U,2)'=$P(^AQAO1(4,X,0),U,2)) S Y=""
 I $D(Y) D
 .S DIC="^AQAO1(4,",DIC(0)="L",DLAYGO=9002169
 .S X=$P(AQAOSS,U),DIC("DR")=".02////"_$P(AQAOSS,U,2)
 .K DD,DO D FILE^DICN S:Y=-1 X=U
 Q X
 ;
 ;
INACT() ;EXTR VAR to ask if updating ind is allowed 
 N Y,DIR
 S DIR(0)="SB^N:NONE;S:SELECTED;A:ALL"
 S DIR("A",1)="You already have indicators in your file.  If I find"
 S DIR("A",2)="any that match those I sent with this package, I will"
 S DIR("A",3)="UPDATE them if they have been inactivated.  You can"
 S DIR("A",4)="choose from:    NONE - do not update any"
 S DIR("A",5)="                SELECTED - I will ask about each one"
 S DIR("A",6)="                ALL - update all without further discussion"
 S DIR("A")="UPDATE INACTIVE INDICATORS?" D ^DIR
 Q Y
 ;
 ;
UPD() ;EXTR VAR to ask if user wants indicator updated
 N X,Y,DIR
 S DIR(0)="Y",DIR("B")="YES"
 S DIR("A",1)="You already have "_AQAOID_" as an inactive indicator."
 S DIR("A")="Do you want to update this indicator" D ^DIR
 S X=$S(Y=1:1,1:U)
 Q X
 ;
 ;
DRSET() ;EXTR VAR to set dr string
 N X,Y S DR=""
 S X=^AQAOXX(2,AQAOX,0) ;zero node data
 F J=1:1 S Y=$P($T(DATA2+J),";;",2) Q:Y=""  D
 .S Z=$P($T(DATA2+J),";;",3)
 .S DR=DR_";"_Y_"////"_$P(X,U,Z)
 S X=^AQAOXX(2,AQAOX,1) ;one node data
 F J=1:1 S Y=$P($T(DATA2A+J),";;",2) Q:Y=""  D
 .S Z=$P($T(DATA2A+J),";;",3)
 .S DR=DR_";"_Y_"////"_$P(X,U,Z)
 S DR=$E(DR,2,250)_";.06////I"
 Q DR
 ;
 ;
DATA2 ;; data for step 2 drset extr var
 ;;.02;;2
 ;;.03;;3
 ;;.04;;4
 ;;.05;;5
 ;
DATA2A ;; data for step 2 drset extr var second loop
 ;;.11;;1
 ;;.12;;2         
