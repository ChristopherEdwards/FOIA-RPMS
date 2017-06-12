ATXTV ; IHS/CMI/LAB - DISPLAY IND LISTS 15 Dec 2010 9:42 AM ;
 ;;5.1;TAXONOMY;**11**;FEB 4, 1997;Build 48
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 D EN^XBVK("ATX")
 Q
 ;; ;
EN ;EP -- main entry point for 
 D EN^VALM("ATX TAXONOMY VIEW")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="VIEW TAXONOMIES"
 Q
 ;
INIT ;EP -- init variables and list array
 K ATXTAX,ATXALL S ATXHIGH="",C=0,J=0
 S ATXT=""
 F  S ATXT=$O(^ATXAX("B",ATXT)) Q:ATXT=""  D
 .S ATXY=0 F  S ATXY=$O(^ATXAX("B",ATXT,ATXY)) Q:ATXY'=+ATXY  D
 ..S ATXALL(ATXT,ATXY)=1
 S ATXT=""
 F  S ATXT=$O(^ATXLAB("B",ATXT)) Q:ATXT=""  D
 .S ATXY=0 F  S ATXY=$O(^ATXLAB("B",ATXT,ATXY)) Q:ATXY'=+ATXY  D
 ..S ATXALL(ATXT,ATXY)=2
 S ATXT="" F  S ATXT=$O(ATXALL(ATXT)) Q:ATXT=""  D
 .S ATXY=0 F  S ATXY=$O(ATXALL(ATXT,ATXY)) Q:ATXY'=+ATXY  D
 ..S Z=ATXALL(ATXT,ATXY)
 ..I Z=1 S ATXFILE=$P(^ATXAX(ATXY,0),U,15),ATXDESC=$P(^ATXAX(ATXY,0),U,2),J=J+1
 ..I Z=2 S ATXFILE=60,ATXDESC=$P(^ATXLAB(ATXY,0),U,2),J=J+1
 ..S ATXTAX(J,0)=J_")  "_ATXT
 ..S $E(ATXTAX(J,0),38)=$E($$VAL^XBDIQ1($S(Z=1:9002226,1:9002228),ATXY,.15),1,15)
 ..S $E(ATXTAX(J,0),55)=ATXDESC
 ..S ATXTAX("IDX",J,J)=ATXY_U_$S(Z'=2:"T",1:"L")_U_ATXY
 ..S C=C+1
 .Q
 S (VALMCNT,ATXHIGH)=C
 Q
 ;
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
 ;
DISP ;EP - add an item to the selected list - called from a protocol
 W !
 S DIR(0)="NO^1:"_ATXHIGH,DIR("A")="Which Taxonomy"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No taxonomy selected." G DISPX
 I $D(DIRUT) W !,"No taxonomy selected." G DISPX
 ;S ATXFIEN=$P(ATXTAX("IDX",Y,Y),U,3)
 S ATXSEL=Y
 S ATXTIEN=$P(ATXTAX("IDX",Y,Y),U,1)
 S ATXTYPE=$P(ATXTAX("IDX",Y,Y),U,2)
 D EP^ATXTV1(ATXTIEN,ATXTYPE)
DISPX ;
 D BACK
 Q
