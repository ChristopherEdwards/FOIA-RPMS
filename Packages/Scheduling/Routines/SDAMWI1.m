SDAMWI1 ;ALB/MJK - Walk-Ins (cont.) ; [ 01/03/2002  4:11 PM ]
 ;;5.3;Scheduling;**94,167,206,168,1006,1009,1010,1012**;Aug 13, 1993
 ;IHS/ANMC/LJF 7/06/2000 added call to IHS routing slip code
 ;                       hard set of date appt made now includes time
 ;            11/29/2000 added call to enter other info
 ;            11/01/2001 added default to routing slip question
 ;IHS/OIT/LJF  09/21/2006 PATCH 1006 don't ask to print RS if not checked in
 ;cmi/anch/maw  04/07/2008 PATCH 1009 requirement 61 added check of default prompt for printing routing slips
 ;cmi/anch/maw  05/04/2009 PATCH 1010 added check of default prompt if no DIV
 ;cmi/flag/maw  06/17/2010 PATCH 1012 added setting of date appointment made xref for walkins RQMT147
 ;
MAKE(DFN,SDCL,SDT) ; -- set globals for appt
 ;    input:     DFN ; SDCL := clinic# ; SDT := appt d/t
 ; returned: success := 1
 ;
 N SD,SDINP,SC,DA,DIK
 S SC=SDCL,X=SDT,SDINP=$$INP^SDAM2(DFN,SDT)
 S SD=SDT D EN1^SDM3
 S:'$D(^DPT(DFN,"S",0)) ^(0)="^2.98P^^"
 ;S ^DPT(DFN,"S",SDT,0)=SC_"^"_$$STATUS^SDM1A(SC,SDINP,SDT)_"^^^^^4^^^^^^^^^"_SDAPTYP_"^^^"_DT_"^^^^^"_$G(SDXSCAT)_"^W^0"
 S ^DPT(DFN,"S",SDT,0)=SC_"^"_$$STATUS^SDM1A(SC,SDINP,SDT)_"^^^^^4^^^^^^^^^"_SDAPTYP_"^^^"_$$NOW^XLFDT_"^^^^^"_$G(SDXSCAT)_"^W^0"   ;IHS/ANMC/LJF 7/06/2000
 ;xref DATE APPT. MADE field
 D
 .N DIV
 .S DA=SDT,DA(1)=DFN,DIK="^DPT(DA(1),""S"",",DIK(1)=20 D EN1^DIK
 .Q
 ;F I=1:1 I '$D(^SC(SC,"S",SDT,1,I)) S:'$D(^(0)) ^(0)="^44.003PA^^" S ^(I,0)=DFN_"^"_SDSL_"^^^^"_DUZ_"^"_DT,^SC(SC,"S",SDT,0)=SDT,SDDA=I D RT,EVT,DUAL,ROUT(DFN) Q
 ;F I=1:1 I '$D(^SC(SC,"S",SDT,1,I)) S:'$D(^(0)) ^(0)="^44.003PA^^" S ^(I,0)=DFN_"^"_SDSL_"^^^^"_DUZ_"^"_$$NOW^XLFDT,^SC(SC,"S",SDT,0)=SDT,SDDA=I S X=$$OI^BSDAM(SC,SDT,I,DFN) D RT,EVT,DUAL,ROUT(DFN) Q   ;IHS/ANMC/LJF 7/06/2000;11/29/2000
 ;cmi/maw PATCH1012 RQMT147 begin mods
 F I=1:1 I '$D(^SC(SC,"S",SDT,1,I)) S:'$D(^(0)) ^(0)="^44.003PA^^" S ^(I,0)=DFN_"^"_SDSL_"^^^^"_DUZ_"^"_$$NOW^XLFDT,^SC(SC,"S",SDT,0)=SDT,SDDA=I S X=$$OI^BSDAM(SC,SDT,I,DFN) D RT,EVT,DUAL,ROUT(DFN),XREFC($S($G(SC):SC,1:$G(SDCL)),SDT,SDDA) Q
 ;cmi/maw PATCH1012 RQMT147 end mods
 ;update availability grid
 N HSI,SDDIF,SI,SL,STARTDAY,STR,SDNOT,X,SB,Y,S,I,ST,SS,SM
 S SD=SDT,SC=SDCL
 I '$D(^SC(SC,"ST",$P(SD,"."),1)) Q 1
  S SL=^SC(+SC,"SL"),X=$P(SL,U,3),STARTDAY=$S($L(X):X,1:8),SB=STARTDAY-1/100,X=$P(SL,U,6),HSI=$S(X=1:X,X:X,1:4),SI=$S(X="":4,X<3:4,X:X,1:4),STR="#@!$* XXWVUTSRQPONMLKJIHGFEDCBA0123456789jklmnopqrstuvwxyz",SDDIF=$S(HSI<3:8/HSI,1:2) K Y
SC L +^SC(SC,"ST",$P(SD,"."),1):5 G:'$T SC S S=^SC(SC,"ST",$P(SD,"."),1) S I=SD#1-SB*100,ST=I#1*SI\.6+($P(I,".")*SI),SS=SL*HSI/60*SDDIF+ST+ST G C:(I<1!'$F(S,"["))&(S'["CAN")
 S SM=0
 I SM<7 S %=$F(S,"[",SS-1) S:'%!($P(SL,"^",6)<3) %=999 I $F(S,"]",SS)'<%!(SDDIF=2&$E(S,ST+ST+1,SS-1)["[") S SM=7
SP I ST+ST>$L(S) S S=S_"  " G SP
 S SDNOT=1 F I=ST+ST:SDDIF:SS-SDDIF S ST=$E(S,I+1) S:ST="" ST=" " S Y=$E(STR,$F(STR,ST)-2) G C:S["CAN"!(ST="X"&($D(^SC(+SC,"ST",$P(SD,"."),"CAN")))),C:Y="" S:Y'?1NL&(SM<6) SM=6 S ST=$E(S,I+2,999) S:ST="" ST=" " S S=$E(S,1,I)_Y_ST
 S ^SC(+SC,"ST",$P(SD,"."),1)=S
C L -^SC(+SC,"ST",$P(SD,"."),1)
 Q 1
 ;
RT ; -- request record
 S SDRT="A",SDTTM=SDT,SDPL=I,SDSC=SC D RT^SDUTL
 Q
 ;
ROUT(DFN) ; -- print routing slip
 ;
 ;IHS/OIT/LJF 09/21/2006 PATCH 1006 don't ask if not checked in
 I '$$CI^BSDU2(DFN,SC,SDT) Q
 ;
 ;IHS/ANMC/LJF 7/06/2000; 11/01/2001; 1/03/2002 IHS lines added
 ;Q:'$$READ^BDGF("Y","OKAY TO PRINT A ROUTING SLIP IN MEDICAL RECORDS NOW","YES")  ;cmi/maw 4/7/2008 orig line
 N BSDPAR  ;cmi/maw 5/4/2009 patch 1010
 S BSDPAR=$O(^BSDPAR("B",0))  ;cmi/maw 5/4/2009 patch 1010
 I $G(DIV) Q:'$$READ^BDGF("Y","OKAY TO PRINT A ROUTING SLIP IN MEDICAL RECORDS NOW",$S($P($G(^BSDPAR(DIV,0)),U,24):"YES",1:"NO"))  ;cmi/maw 4/7/2008 PATCH 1009
 I '$G(DIV) Q:'$$READ^BDGF("Y","OKAY TO PRINT A ROUTING SLIP IN MEDICAL RECORDS NOW",$S($P($G(^BSDPAR(BSDPAR,0)),U,24):"YES",1:"NO"))  ;cmi/maw 5/4/2009 patch 1010
 K IOP S (SDX,SDSTART,ORDER,SDREP)=""
 D WISD^BSDROUT(DFN,SDT,"WI",$G(BSDDEV))
 Q
 ;IHS/ANMC/LJF end of IHS mods
 ;
 S DIR("A")="DO YOU WANT TO PRINT A ROUTING SLIP NOW",DIR(0)="Y"
 W ! D ^DIR K DIR G ROUTQ:$D(DIRUT)!(Y=0)
 K IOP S (SDX,SDSTART,ORDER,SDREP)="" D EN^SDROUT1
 ;
ROUTQ Q
 ;
DUAL ; -- ask elig if pt has more than one
 I $O(VAEL(1,0))>0 S SDEMP="" D ELIG^SDM4:"369"[SDAPTYP S SDEMP=$S(SDDECOD:SDDECOD,1:SDEMP) I +SDEMP S $P(^SC(SC,"S",SDT,1,I,0),"^",10)=+SDEMP K SDEMP
 Q
 ;
EVT ; -- separate if need to NEW vars
 N I,DIV D MAKE^SDAMEVT(DFN,SDT,SDCL,SDDA,0)
 Q
 ;
XREFC(C,D,N) ;-- set the date appointment made cross reference patch 1012
 D XREFC^BSDDAM(C,D,N)
 Q
 ;
