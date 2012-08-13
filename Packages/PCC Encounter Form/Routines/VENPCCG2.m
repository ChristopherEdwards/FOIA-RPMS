VENPCCG2 ; IHS/OIT/GIS - GET ICD PREFERENCES: FILER ; 
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ;
 ;
FILE ;   --EP--   CALLED FROM VENPCCG1
 ;
 N VENIO K @TMP@("SORT")
 I '$G(NEWDXP) U 0 W !!,"Creating text files......"
 D ICD
 K @TMP@("SORT")
 K ^TMP("VEN PREF")
 D ^XBFMK
 Q
ICD ;
 ;
 I $P(@TMP@("VPOV",0),"^",3)'="" S PROVFLG=$P(@TMP@("VPOV",0),"^",3)
 E  S PROVFLG="-1"
 ;
 ;
 K @TMP@("SORT","VPOV")
 K @TMP@("SORT","VPOV2AGE")
 S ICDPTR=0
 F  S ICDPTR=$O(@TMP@("VPOV",ICDPTR)) Q:+ICDPTR=0  D
 .S TOT=@TMP@("VPOV",ICDPTR)
 .S DESALL=9999999-TOT
 .S @TMP@("SORT","VPOV",DESALL,ICDPTR)=""
 .S CODE=$P($G(^ICD9(ICDPTR,0)),"^",1)
 .D GETNARR
 .S AGEBUK=0
 .F  S AGEBUK=$O(@TMP@("VPOV",ICDPTR,"B",AGEBUK)) Q:AGEBUK=""  D
 ..S TOT=@TMP@("VPOV",ICDPTR,"B",AGEBUK)
 ..S DES=9999999-TOT
 ..S @TMP@("SORT","VPOV2AGE",AGEBUK,DES,CODE)=NAME
 .S AGESEX=0
 .S @TMP@("SORT","VPOV","AS","C",CODE)=DESALL
 .F  S AGESEX=$O(@TMP@("VPOV",ICDPTR,AGESEX)) Q:+AGESEX=0  D
 ..S TOT=@TMP@("VPOV",ICDPTR,AGESEX)
 ..S DES=9999999-TOT
 ..S @TMP@("SORT","VPOV","AS",AGESEX,DES,CODE)=NAME
 ..Q
 . Q
NEWAGSEX ;  save out actual counts for age and sex groups not 1 or 0
 S VENFLNO=$G(@TMP@("VPOV","FILECT"))+1
 I '$G(NEWDXP) D
 . D OPEN^%ZISH("",PATH,("ilc_icd"_VENFLNO_".txt"),"W") I POP Q
 . S VENIO=IO
 . Q
 K @TMP@("SORT","VPOV","ASP")
 ;
 ;
 ;   save all data to temp file to consolidate the top 100 for each
 ;   age and sex bucket so that there is only one record for each code
 ;
 ;
 S AG=0
 F  S CT=0 S AG=$O(@TMP@("SORT","VPOV","AS",AG)) Q:+AG=0  D
 .S DES=0
 .F  S DES=$O(@TMP@("SORT","VPOV","AS",AG,DES)) Q:+DES=0  D  Q:CT>99
 ..S CODE=""
 ..F  S CODE=$O(@TMP@("SORT","VPOV","AS",AG,DES,CODE)) Q:CODE=""  D  Q:CT>99
 ...S NAME=@TMP@("SORT","VPOV","AS",AG,DES,CODE)
 ...I '$D(@TMP@("SORT","VPOV","ASP",CODE)) S @TMP@("SORT","VPOV","ASP",CODE)=NAME_"^"_(9999999-@TMP@("SORT","VPOV","AS","C",CODE))
 ...S $P(@TMP@("SORT","VPOV","ASP",CODE,"A"),"^",AG)=(9999999-DES)
 ...S CT=CT+1
 ...Q
 .. Q
 . Q
CLN I $G(NEWDXP),$G(DXPRV) D CLEAN(NEWDXP,DXPRV) I '$G(QUIET) W !!,"Saving new preference list..."
 S C=""
 F  S C=$O(@TMP@("SORT","VPOV","ASP",C)) Q:C=""  D
 . S REC=@TMP@("SORT","VPOV","ASP",C)
 . S RECA=@TMP@("SORT","VPOV","ASP",C,"A")
 . S NAME=$P(REC,"^",1)
 . S ICDNAME=$$INM(C)
 . S TOT=$P(REC,"^",2)
 . S OUTREC=C_$C(9)_NAME_$C(9)_ICDNAME
 . F I=1:1:8 S PVAL=+$P(RECA,"^",I) S OUTREC=OUTREC_$C(9)_PVAL
 . S OUTREC=OUTREC_$C(9)_TOT_$C(9)_PROVFLG
 . I $G(NEWDXP),$G(DXPRV),$L(OUTREC) D STUFF(NEWDXP,DXPRV,OUTREC) Q  ; STUFF RESULT INTO THE VEN EHP IDC ITEM FILE
 . U VENIO W OUTREC,!
 . Q
END ;
 K OUTREC,REC,RECA,TOT,CODE,NAME,FREQ,CT,PVAL,DES,AG,ICDNAME
 I $G(NEWDXP) Q
 S @TMP@("VPOV","FILECT")=VENFLNO
 D CLOSE^%ZISH(VENIO)
 Q
 ;
CLEAN(GIEN,PIEN) ; CLEAN OUT THE OLD ENTRIES IN THE FILE FOR THIS PROVIDER AND ICD GROUP
 I '$G(QUIET) W !!,"Cleaning out this user's old preference list..."
 N DIK,DA,X
 I '$D(^VEN(7.33,+$G(GIEN),0)) Q
 I '$D(^VA(200,+$G(PIEN),0)) Q
 S DIK="^VEN(7.34,",DA=0
 F  S DA=$O(^VEN(7.34,DA)) Q:'DA  D
 . S X=$G(^VEN(7.34,DA,0))
 . I '$L(X) Q
 . I PIEN'=+X Q
 . I GIEN'=$P(X,U,2) Q
 . D ^DIK
 . Q
 D ^XBFMK
 Q
 ; 
STUFF(GIEN,PIEN,STG) ; NEW WAY TO STORE PREFERENCES
 I '$L(STG) Q
 I '$D(^VEN(7.33,+$G(GIEN),0)) Q
 I '$D(^VA(200,+$G(PIEN),0)) Q
 N T,INF,CHLD,TM,TF,AM,AF,SM,SF,ICD,ICDTXT,TXT,UID
 N DIC,DIE,DA,DR,X,Y,DIK
 S T=$C(9) ; TAB DELIMITER IS USED IN THIS STG
 S ICD=$P(STG,T)
 S TXT=$P(STG,T,2)
 S ICDTXT=$P(STG,T,3)
 S INF=$P(STG,T,4)
 S CHLD=$P(STG,T,5)
 S TM=$P(STG,T,6)
 S TF=$P(STG,T,7)
 S AM=$P(STG,T,8)
 S AF=$P(STG,T,9)
 S SM=$P(STG,T,10)
 S SF=$P(STG,T,11)
 S UID=PIEN_"_"_GIEN_"_"_ICD
 S DA=$O(^VEN(7.34,"AC",UID,0)) I DA G S1
 S DIC="^VEN(7.34,",DIC(0)="L",DLAYGO=19707.34
 S X="""`"_PIEN_""""
 D ^DIC I Y=-1 Q
 S DA=+Y
S1 S DIE=DIC
 S DR=".02////^S X=GIEN;.03////^S X=TXT;.04////^S X=ICD;.06////^S X=UID;.07////^S X=ICDTXT;"
 S DR=DR_"1.02////^S X=INF;1.04////^S X=CHLD;1.06////^S X=TF;1.08////^S X=TM;"
 S DR=DR_"1.1////^S X=AF;1.12////^S X=AM;1.14////^S X=SF;1.16////^S X=SM"
 L +^VEN(7.34,DA):0 I $T D ^DIE L -^VEN(7.34,DA)
 Q
 ; 
GETNARR ;   get most freq. prov. narr. used for this icd code   dmh 8/31/2000 
 K MOST
 S PNP=""
 F  S PNP=$O(@TMP@("VPOV","PN",ICDPTR,PNP)) Q:PNP=""  D
 .S TOTPN=@TMP@("VPOV","PN",ICDPTR,PNP)
 .I '$D(MOST) S MOST=TOTPN,MOSTPNP=PNP
 .I MOST<TOTPN S MOST=TOTPN,MOSTPNP=PNP
 .Q
 S NARR=$P($G(^AUTNPOV(MOSTPNP,0)),"^",1)
 D NARR^VENPCCG3
 S NAME=NARR
 Q
 ;
INM(CODE) ;
 N %
 S %=+$$ICD^VENPCCU($G(CODE))
 S %=$P($G(^ICD9(%,0)),U,3)
 Q %
 ; 
