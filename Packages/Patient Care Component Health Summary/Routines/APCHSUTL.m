APCHSUTL ; IHS/CMI/LAB - UTILITIES FOR APCHS -- SUMMARY PRODUCTION COMPONENTS ; [ 05/13/2009  2:28 PM ]
 ;;2.0;IHS PCC SUITE;**5**;MAY 14, 2009
 ;
 ;cmi/anch/maw 8/27/2007 code set versioning in GETICDDX and GETICDOP and GETCPT
 ;BJPC v1.0 patch 1
GETICDDX ;ENTRY POINT
 ;cmi/anch/maw 8/27/2007 need software for code set versioning
 ;S Y=$P(^ICD9(APCHSICD,0),U,1)  cmi/anch/maw 8/27/2007 orig line
 S Y=$$ICDDX^ICDCODE(APCHSICD,$G(APCHCSVD),,1)  ;cmi/anch/maw 8/27/2007 code set versioning
 N APCHSDSC
 S APCHSDSC=$$ICDD^ICDCODE($P(Y,U,2),"APCHSDSC",$G(APCHCSVD)) I $P(APCHSDSC,U)=-1 S APCHSDSC(1)=$G(^ICD9($P(Y,"^"),1))
 ;S:APCHSICF="L" APCHSICD=Y_"-"_$S($D(^ICD9(APCHSICD,1)):$P(^(1),U,1),1:"<DESCRIPTION field missing>")  cmi/anch/maw 8/27/2007 orig line
 S:APCHSICF="L" APCHSICD=$P(Y,U,2)_"-"_$S($D(APCHSDSC(1)):$G(APCHSDSC(1)),1:"<DESCRIPTION field missing>")  ;cmi/anch/maw 8/27/2007 code set versioning
 ;S:APCHSICF="S" APCHSICD=Y_"-"_$S($D(^ICD9(APCHSICD,0)):$P(^(0),U,3),1:"<DIAGNOSIS field missing>")  cmi/anch/maw 8/27/2007 orig line
 S:APCHSICF="S" APCHSICD=$P(Y,U,2)_"-"_$S($P(Y,U,4)]"":$P(Y,U,4),1:"<DIAGNOSIS field missing>")  ;cmi/anch/maw 8/27/2007 code set versioning
 ;S:APCHSICF="C" APCHSICD=Y
 S:APCHSICF="C" APCHSICD=$P(Y,U,2)
 ;cmi/anch/maw end of mods
 Q
GETICDOP ;ENTRY POINT
 ;cmi/anch/maw 8/28/2007 mods for code set versioning
 ;S Y=$P(^ICD0(APCHSICD,0),U,1)
 S Y=$$ICDOP^ICDCODE(APCHSICD)
 N APCHSDSC
 S APCHSDSC=$$ICDD^ICDCODE($P(Y,U,2),"APCHSDSC",$G(APCHCSVD)) I $P(APCHSDSC,U)=-1 S APCHSDSC(1)=$G(^ICD0($P(Y,"^"),1))
 ;S:APCHSICF="L" APCHSICD=Y_"-"_$S($D(^ICD0(APCHSICD,1)):$P(^(1),U,1),1:"<DESCRIPTION field missing>")
 S:APCHSICF="L" APCHSICD=$P(Y,U,2)_"-"_$S($D(APCHSDSC(1)):$G(APCHSDSC(1)),1:"<DESCRIPTION field missing>")  ;cmi/anch/maw 8/27/2007 code set versioning
 ;S:APCHSICF="S" APCHSICD=Y_"-"_$S($D(^ICD0(APCHSICD,0)):$P(^(0),U,4),1:"<OPERATION/PROCEDURE field missing>")
 S:APCHSICF="S" APCHSICD=$P(Y,U,2)_"-"_$S($P(Y,U,5)]"":$P(Y,U,5),1:"<OPERATION/PROCEDURE field missing>")
 ;S:APCHSICF="C" APCHSICD=Y
 S:APCHSICF="C" APCHSICD=$P(Y,U,2)
 ;cmi/anch/maw 8/28/2007 end of mods
 Q
GETCPT ;ENTRY POINT
 ;cmi/anch/maw 8/28/2007 mods for code set versioning
 ;S Y=$P(^ICPT(APCHSICD,0),U,1)
 S Y=$$CPT^ICPTCOD(APCHSICD)
 ;S:APCHSICF="L" APCHSICD=Y_"-"_$S($D(^ICPT(APCHSICD,0)):$P(^(0),U,2),1:"<DESCRIPTION field missing>")
 S:APCHSICF="L" APCHSICD=$P(Y,U,2)_"-"_$S($P(Y,U,3)]"":$P(Y,U,3),1:"<DESCRIPTION field missing>")
 ;S:APCHSICF="S" APCHSICD=Y_"-"_$S($D(^ICPT(APCHSICD,0)):$P(^(0),U,2),1:"<DESCRIPTION field missing>")
 S:APCHSICF="S" APCHSICD=$P(Y,U,2)_"-"_$S($P(Y,U,3)]"":$P(Y,U,3),1:"<DESCRIPTION field missing>")
 ;S:APCHSICF="C" APCHSICD=Y
 S:APCHSICF="C" APCHSICD=$P(Y,U,2)
 ;cmi/anch/maw 8/28/2007 end of mods
 Q
PRTICD ;ENTRY POINT
 I APCHSICF="N" S:APCHSNRQ="" APCHSNRQ="<no narrative provided>" S APCHSICD=""
 S APCHSTXT=$G(APCHSICD)
 S:'$D(APCHSNTE) APCHSNTE=""
 I APCHSNTE]"" S APCHSNTE=" "_APCHSNTE
 D PRTTXT
 Q
PRTICDE ;ENTRY POINT
 ;S APCHSTXT=$G(APCHSICD)
 I APCHSICF="N" S APCHSICD=""
 S:'$D(APCHSNTE) APCHSNTE=""
 I APCHSNTE]"" S APCHSNTE=" "_APCHSNTE
 D PRTTXT
 Q
 ;
PRTTXT ;PEP - PUBLISHED ENTRY POINT
 ; GENERALIZED TEXT PRINTER
 S:'$D(APCHSNTE) APCHSNTE=""
 S APCHSDLT=1,APCHSILN=IOM-APCHSICL-1
 F APCHSQ=0:0 D PRTTXT1 Q:APCHSTXT=""  D PRTTXT2
 K APCHSNTE
 K APCHSILN,APCHSDLT,APCHSF,APCHSC,APCHSTXT
 Q
PRTTXT1 ;
 S:APCHSNRQ]""&(($L(APCHSNRQ)+$L(APCHSTXT)+2)<255) APCHSTXT=$S(APCHSTXT]"":APCHSTXT_"; ",1:"")_APCHSNRQ,APCHSNRQ=""
 S:APCHSNTE]""&(APCHSNRQ="")&(($L(APCHSNTE)+$L(APCHSTXT)+2)<255) APCHSTXT=APCHSTXT_APCHSNTE,APCHSNTE=""
 Q
PRTTXT2 D GETFRAG X APCHSCKP Q:$D(APCHSQIT)  W ?APCHSICL W APCHSF,! S APCHSICL=APCHSICL+APCHSDLT,APCHSILN=APCHSILN-APCHSDLT,APCHSDLT=0
 Q
GETFRAG I $L(APCHSTXT)<APCHSILN S APCHSF=APCHSTXT,APCHSTXT="" Q
 F APCHSC=APCHSILN:-1:0 Q:$E(APCHSTXT,APCHSC)=" "
 S:APCHSC=0 APCHSC=APCHSILN
 S APCHSF=$E(APCHSTXT,1,APCHSC-1),APCHSTXT=$E(APCHSTXT,APCHSC+1,255)
 Q
 ;
GETNARR ;ENTRY POINT
 I APCHSNRQ]"",APCHSNRQ'=0,$D(^APCHSCTL(APCHSTYP,2)),$P(^(2),U,2)="Y" S APCHSNRQ=$S($D(^AUTNPOV(APCHSNRQ)):$P(^AUTNPOV(APCHSNRQ,0),U,1),1:"***** "_APCHSNRQ_" *****")
 E  S APCHSNRQ=""
 Q
 ;
GETSITEV ;ENTRY POINT
 S APCHSP=^AUPNVSIT(APCHSVDF,0),APCHSVSC=$P(APCHSP,U,7),APCHSITE=$P(APCHSP,U,6)
GETSITE ;ENTRY POINT
 S:APCHSITE="" APCHSITE="null"
 S APCHSP=$G(^AUTTLOC(APCHSITE,0))
 S:'$D(APCHSVDF) APCHSVDF=-1
 ;S APCHSNFL=$P(APCHSP,U,1),APCHSNFL=$S($D(^DIC(4,APCHSNFL,0)):$P(^(0),U,1),$D(^AUPNVSIT(APCHSVDF,21))#2:$P(^(21),U),1:"<"_APCHSITE_">") ;IHS/CMI/LAB - commented out and replaced with line below
 S APCHSNFL=$P(APCHSP,U,1) S:APCHSNFL="" APCHSNFL="null" S APCHSNFL=$S($D(^DIC(4,APCHSNFL,0)):$P(^(0),U,1),$P($G(^AUPNVSIT(APCHSVDF,21)),U)]"":$P(^(21),U),1:"<"_APCHSITE_">") ;IHS/CMI/LAB - fixed this line
 ;S APCHSNSH=$P(APCHSP,U,2) S:$D(^AUPNVSIT(APCHSVDF,21))#2 APCHSNSH=$E($P(^(21),U),1,12) I APCHSNSH="" S APCHSNSH="<"_APCHSITE_">" ;IHS/CMI/LAB - commented out
 S APCHSNSH=$P(APCHSP,U,2) S:$P($G(^AUPNVSIT(APCHSVDF,21)),U)]"" APCHSNSH=$E($P(^(21),U),1,12) I APCHSNSH="" S APCHSNSH="<"_APCHSITE_">" ;IHS/CMI/LAB - fixed this line to replace the one above
 K:APCHSVDF=-1 APCHSVDF
 S APCHSNAB=$J($P(APCHSP,U,7),4) I APCHSNAB="" S APCHSNAB="<"_APCHSITE_">"
 Q
 ;
 ; THE FOLLOWING CODE SEGMENTS ARE CALLED FROM 'ROUTINE"-TYPE
 ;  MENU OPTIONS TO DISPLAY ITEMS IN A FILE
 ;
LC ;ENTRY POINT - FOR APCHSLST HLTH SUM COMPONENTS
 S APCHSLST="^APCHSCMP(" G DSPLST
 ;
LS ;ENTRY POINT - FOR APCHSLST HLTH SUM TYPES
 S APCHSLST="^APCHSCTL(" G DSPLST
 ;
LM ;ENTRY POINT - FOR APCHSLST MEASUREMENT PANEL TYPES
 S APCHSLST="^APCHSMPN(" G DSPLST
 ;
LI ;ENTRY POINT - FOR APCHSLST HLTH SUM FLOWSHEET ITEMS
 S APCHSLST="^APCHSFLI(" G DSPLST
 ;
LF ;ENTRY POINT - FOR APCHSLST HLTH SUM FLOWSHEETS
 S APCHSLST="^APCHSFLC(" G DSPLST
 ;
DSPLST ; COMMON CODE FOR BUILD HLTH SUM & HLTH SUM MNX LISTS
 K DIR
 I '$D(@(APCHSLST_"""B"")")) W !,"NO ",$P(@(APCHSLST_"0)"),U),"S DEFINED.",! Q
 W @IOF,!!,"Existing ",$P(@(APCHSLST_"0)"),U)
 I $E($P(@(APCHSLST_"0)"),U),$L($P(@(APCHSLST_"0)"),U)))'="S" W "S"
 W ":",! S APCHSCNT=""
CONT F  S APCHSCNT=$O(@(APCHSLST_"""B"",APCHSCNT)")) Q:APCHSCNT=""  W !,?5,APCHSCNT I (IOSL-3)<$Y S DIR(0)="E" D ^DIR W @IOF G:1'[Y QUIT
 K DIR S DIR(0)="E" D ^DIR W !
 Q
 ;
GENFG ;generate filegrams for export
MEASPAN ;
 W !,"REMEMBER TO KILL APCHTMP BEFORE DOING THIS",!
 S APCHT="MEASPAN",APCHC=0 F APCHX="ADULT STD","ADULT STD METRIC","PEDIATRIC STD","PEDIATRIC STD METRIC" S DIFGT=$O(^DIPT("B","APCH MP TYPE",0)) D
 .I 'DIFGT W !,"measurement panel fg missing" Q
 .S DIFG("FE")=$O(^APCHSMPN("B",APCHX,0))
 .I 'DIFG("FE") W !,"panel ",APCHX," missing.",! Q
 .S APCHC=APCHC+1
 .D GEN1
 .Q
FLOW ;
 G TYPE
 S APCHT="FLOW",APCHC=0 F APCHX="DIABETIC FLOWSHEET" S DIFGT=$O(^DIPT("B","APCH FS TYPE",0)) D
 .I 'DIFGT W !,"flowsheet fg missing" Q
 .S DIFG("FE")=$O(^APCHSFLC("B",APCHX,0))
 .I 'DIFG("FE") W !,"flowsheet ",APCHX," missing.",! Q
 .S APCHC=APCHC+1
 .D GEN1
 .Q
TYPE ;
 S APCHT="TYPE",APCHC=0 F APCHX="ADULT REGULAR","CHR","DENTAL","DIABETES STANDARD","IMMUNIZATION","MENTAL HEALTH/SOCIAL SERVICES","PEDIATRIC","PATIENT MERGE (COMPLETE)","PROBLEM LIST" S DIFGT=$O(^DIPT("B","APCH HS TYPE",0)) D
 .I 'DIFGT W !,"health summary type fg missing" Q
 .S DIFG("FE")=$O(^APCHSCTL("B",APCHX,0))
 .I 'DIFG("FE") W !,"type ",APCHX," missing.",! Q
 .S APCHC=APCHC+1
 .D GEN1
 .Q
 K APCHC,APCHT W !,"all done"
 Q
GEN1 ;
 S DIFG("FUNC")="A"
 S DIFG("FGR")="^APCHTMP("""_APCHT_""",APCHC,"
 S DILC=0
 D EN^DIFGG
 I $D(DIFGER) W !,"error on ",APCHT," item ",APCHX,!
 Q
QUIT K DIR,X,Y,APCHSLST,APCHSCNT
 Q