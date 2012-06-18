AQAQEDTS ;IHS/ANMC/LJF - CREDENTIALING SUBRTNS; [ 09/15/95  8:48 AM ]
 ;;2.2;STAFF CREDENTIALS;**7**;01 OCT 1992
 ;
ITEMFIND ;EP;>>subrtn to find each items on page and display them by number<<
 ;
 ;***> find items for this page
 K AQAQA
 F  S AQAQTM=$O(^AQAQX(AQAQPT,"PG",AQAQPN,"IT","B",AQAQTM)) Q:AQAQTM'=+AQAQTM  D
 .S AQAQTMN=0
 .F  S AQAQTMN=$O(^AQAQX(AQAQPT,"PG",AQAQPN,"IT","B",AQAQTM,AQAQTMN)) Q:AQAQTMN=""  D
 ..Q:'$D(^AQAQX(AQAQPT,"PG",AQAQPN,"IT",AQAQTMN,0))
 ..;
 ..;***> print items in order with contents and save field # in array
 ..S AQAQMFL=^(0),AQAQFLD=$P(AQAQMFL,U,2),AQAQSEN=$P(AQAQMFL,U,5)
 ..S AQAQSFL=$P(AQAQMFL,U,3),AQAQDR=$P(AQAQMFL,U,4)
 ..W !,$J(+AQAQMFL,2),")  ",$P(^DD(9002165,AQAQFLD,0),U)
 ..I AQAQSFL]"" D FSTMULT Q
 ..K ^UTILITY("DIQ1",$J)
 ..S (DIC,AQAQFL)=9002165,DA=AQAQPRV,DR=AQAQFLD D EN^DIQ1
 ..I $D(^UTILITY("DIQ1",$J,AQAQFL,DA,AQAQFLD)) W ?45,^(AQAQFLD)
 ..K ^UTILITY("DIQ1",$J)
 ..S AQAQA(+AQAQMFL)=AQAQFLD
 ;
 ;***> choose items to edit and edit via ^die
 S (AQAQTM,AQAQX)=0 W !!
 F  S AQAQX=$O(AQAQA(AQAQX)) Q:AQAQX=""  S AQAQTM=AQAQX
 S DIR(0)="LO^0:"_AQAQTM D ^DIR Q:$D(DIRUT)  Q:Y=-1  S DR=""
 S AQAQXLF(".")=",",Y=$$REPLACE^XLFSTR(Y,.AQAQXLF) K AQAQXLF ;PATCH #7
 I +Y=0 F  S X=$O(AQAQA(X)) Q:X=""  D
 .I AQAQA(X)[U S DR(2,$P(AQAQA(X),U,2))=$P(AQAQA(X),U,3)
 .S DR=DR_";"_$P(AQAQA(X),U)
 E  F  S X=$P(Y,",") Q:X=""  D
 .I AQAQA(X)[U S DR(2,$P(AQAQA(X),U,3))=$P(AQAQA(X),U,2)
 .S X=$P(AQAQA(X),U),DR=DR_";"_X
 .S Y=$P(Y,",",2,99)
 I DR?1";".E S DR=$E(DR,2,99)
 K DIE S DIE=9002165,DA=AQAQPRV D ^DIE
 K DIR S DIR(0)="Y",DIR("B")="NO" ;PATCH #7
 S DIR("A")="Do you wish to REVIEW this category" D ^DIR K DIR
 I Y=1 S AQAQTM=0,DIR("A")=AQAQDIR K AQAQDIR W !!! G ITEMFIND
 Q
 ;>>end of ITEMFIND subrtn<<
 ;
 ;
FSTMULT ;>>subrtn called by ITEMFIND for ist entry in multiple field
 ;
 S AQAQNOD=$P($P(^DD(9002165,AQAQFLD,0),U,4),";"),(AQAQTMP,AQAQSEN)=0
 F  S AQAQTMP=$O(^AQAQC(AQAQPRV,AQAQNOD,AQAQTMP)) Q:AQAQTMP'=+AQAQTMP  D
 .S AQAQSEN=AQAQTMP
 S Y=$P($G(^AQAQC(AQAQPRV,AQAQNOD,AQAQSEN,0)),U)
 I Y]"" S C=$P(^DD(AQAQSFL,+AQAQDR,0),U,2) D Y^DIQ W ?45,Y
 S AQAQA(AQAQTM)=AQAQFLD_U_AQAQDR_U_AQAQSFL
 Q
 ;>>end of FSTMULT subrtn<<
 ;
 ;
MULTFIND ;EP;>>subrtn to display multiple fields' data<<
 ;
 ;***> set variables about subfile
 S AQAQFLD=$P(AQAQSTR,U),AQAQSFD=$P(AQAQSTR,U,2),AQAQPC=$P(AQAQSTR,U,3)
 S AQAQSTR1=^DD(9002165,AQAQFLD,0),AQAQSF=$P(AQAQSTR1,U,2)
 S AQAQSUB=$P($P(AQAQSTR1,U,4),";"),AQAQNOD=$P($P(AQAQSTR1,U,4),";",2)
 ;
 ;***> loop thru entries under multiple and display them by #
 S (AQAQX,AQAQCNT)=0,DA(1)=AQAQPRV
 F  S AQAQX=$O(^AQAQC(AQAQPRV,AQAQSUB,AQAQX)) Q:AQAQX'=+AQAQX  D
 .S AQAQTM=$P(^AQAQC(AQAQPRV,AQAQSUB,AQAQX,AQAQNOD),U,AQAQPC)
 .S AQAQCNT=AQAQCNT+1,AQAQA(AQAQCNT)=AQAQX
 .S Y=AQAQTM,C=$P(^DD(+AQAQSF,+AQAQSFD,0),U,2) D Y^DIQ
 .W !,AQAQCNT,")  ",Y
 .Q
 ;***> last number is choice to add new entry
 I AQAQCNT>0 S AQAQCNT=AQAQCNT+1 W !,AQAQCNT,")  ADD NEW ENTRY"
 I AQAQCNT=0 G ADD ;add if no entries in file
 W !
 ;
CHOOSE ;***> choose item(s) to edit
 S DIR(0)="NO^1:"_AQAQCNT
 D ^DIR Q:X=""  Q:$D(DIRUT)  G CHOOSE:Y=-1
 I +Y=AQAQCNT G ADD G MULTFIND
 E  S DA=AQAQA(+Y) G EDIT G MULTFIND
 ;
ADD ;add new entry to subfile
 I '$D(^AQAQC(AQAQPRV,AQAQSUB,0)) S ^(0)=U_AQAQSF
 K DIC S DIC="^AQAQC("_AQAQPRV_","""_AQAQSUB_""",",DIC(0)="AQEMLZI"
 D ^DIC S DA=+Y Q:Y=-1
 ;
EDIT ;***> edit entries
 K DIC,DIE S DIE="^AQAQC("_AQAQPRV_","""_AQAQSUB_""","
 S DR=AQAQSFD D ^DIE
 W !!!! G MULTFIND
 ;
 ;>>end of MULTFIND subrtn<<
