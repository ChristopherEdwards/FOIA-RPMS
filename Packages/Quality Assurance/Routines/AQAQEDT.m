AQAQEDT ;IHS/ANMC/LJF - MAIN DRIVER FOR DATA ENTRY; [ 09/15/95  8:46 AM ]
 ;;2.2;STAFF CREDENTIALS;**7**;01 OCT 1992
 ;
 ;This routine uses the QI Data Entry file to create data entry
 ;screens and controls editing of those screens.
 ;The calling option sends AQAQOPTN (option name) before calling rtn
 ;5/2/94 Routine modified to work with changes to QI Data Entry file
 ;needed by QAI Mgt. System.  Distributed in patch AQAO*1*1.
 ;
SETOPT K DIC S X=AQAQOPTN,DIC(0)="",DIC="^AQAQX("
 D ^DIC G END:Y=-1 S AQAQPT=+Y
 ;
 ;***> for each provider, choose pages and data items to enter/edit
 F  D  Q:$D(DIRUT)  Q:Y=-1
 .D GETPROV Q:X=U  Q:X=""
 .D PAGELOOP K DIRUT
 ;
END ;***> eoj
 D KILL^AQAQUTIL Q
 ;
 ;>>>>END OF MAIN ROUTINE; SUBRTNS TO FOLLOW<<<<<
 ;
GETPROV ;>>subrtn ask for provider & find/create entry in Credentialing file<<
 ;***> ask provider name
 K DIC S DIC("A")="Select PROVIDER NAME:  ",DIC(0)="AELMQZ"
 S (DIC,DLAYGO)=9002165 D ^DIC
 Q:X=U  Q:X=""  G GETPROV:Y=-1 S AQAQPRV=+Y
 S AQAQPRVN=$P(^DIC(16,AQAQPRV,0),U) ;provider name
 S AQAQPRVC="",Y=$P($G(^DIC(6,AQAQPRV,0)),U,4)
 I Y]"" S C=$P(^DD(6,2,0),U,2) D Y^DIQ S AQAQPRVC=Y ;provider class
 Q
 ;
 ;
PAGELOOP ;>>subrtn to get each page (screen), display items and do edit<<
 ;***> find all pages available to work on
 S AQAQPG=0,AQAQOPTT=$P(^AQAQX(AQAQPT,0),U,2)
 W @IOF,!?80-$L(AQAQOPTT)/2,AQAQOPTT
 W !?80-$L(AQAQPRVN)/2,AQAQPRVN
 W !?80-$L(AQAQPRVC)/2,AQAQPRVC
 W !!
 F  S AQAQPG=$O(^AQAQX(AQAQPT,"PG","B",AQAQPG)) Q:AQAQPG=""  D
 .K DIR S AQAQPN=0,DIR(0)="LO^0:"_AQAQPG
 .F  S AQAQPN=$O(^AQAQX(AQAQPT,"PG","B",AQAQPG,AQAQPN)) Q:AQAQPN=""  D
 ..Q:'$D(^AQAQX(AQAQPT,"PG",AQAQPN,0))
 ..S AQAQPTL=$P(^AQAQX(AQAQPT,"PG",AQAQPN,0),U,3)
 ..S AQAQP(AQAQPG)=AQAQPTL_U_AQAQPN W !?5,AQAQPG,") ",AQAQPTL
 ..Q
 ;
 ;***> choose page to work on
 W !!
 S DIR("A")="Choose category to edit (Enter 0 for ALL categories)"
 D ^DIR Q:$D(DIRUT)  G PAGELOOP:Y=-1 S Y=$E(Y,1,$L(Y)-1)
 I $D(^AQAQC(AQAQPRV,2)) S $P(^(2),U,3,4)=DT_U_DUZ ;editing user
 ;
 ;***> loop thru all pages selected
 K DIROUT
 S AQAQXLF(".")=",",Y=$$REPLACE^XLFSTR(Y,.AQAQXLF) K AQAQXLF ;PATCH #7
 I Y=0 S AQAQO="" F  S X=$O(AQAQP(X)) Q:X=""  S AQAQO=AQAQO_","_X
 E  S AQAQO=Y
 I AQAQO?1",".E S AQAQO=$E(AQAQO,2,99)
 F AQAQ=1:1 S Y=$P(AQAQO,",",AQAQ) Q:Y=""  Q:$D(DIROUT)  Q:$D(DUOUT)  D
 .S AQAQPTL=$P(AQAQP(Y),U),AQAQPN=$P(AQAQP(Y),U,2)
 .W @IOF,!?80-$L(AQAQPTL)/2,AQAQPTL ;page title
 .W !?80-$L(AQAQPRVN)/2,AQAQPRVN ;print provider name
 .W !?80-$L(AQAQPRVC)/2,AQAQPRVC,!! ;print provider class
 .W $P(^AQAQX(AQAQPT,"PG",AQAQPN,0),U,4),! ;page heading
 .K DIR S Y=$P(^AQAQX(AQAQPT,"PG",AQAQPN,0),U,2)
 .I Y]"" S C=$P(^DD(9002166.11,.02,0),U,2) D Y^DIQ S (DIR("A"),AQAQDIR)=Y ;PATCH #7
 .;
 .;***> display items and ask user for choice, and then edit via ^die
 .S AQAQTM=0
 .S AQAQSTR=$S('$D(^AQAQX(AQAQPT,"PG",AQAQPN,1)):"",1:^(1))
 .I $D(^AQAQX(AQAQPT,"PG",AQAQPN,2)) S DA=AQAQPRV X ^(2) Q  ;IHS/ORDC/LJF 10/5/93 change for QAI pkg
 .I $P(AQAQSTR,U)'="" D MULTFIND^AQAQEDTS Q  ;multiple field page
 .D ITEMFIND^AQAQEDTS:$P(AQAQSTR,U)="" ;multiple items on page
 .Q
 Q:$D(DIROUT)  Q:X="^^"
 G PAGELOOP
 ;>>end of PAGELOOP subrtn<<
