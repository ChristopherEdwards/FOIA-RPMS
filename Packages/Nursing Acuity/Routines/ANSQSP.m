ANSQSP ;IHS/OIRM/DSD/CSC - PRINT NURSE STAFFING STATS; [ 02/25/98  10:32 AM ]
 ;;3.0;NURSING PATIENT ACUITY;;APR 01, 1996
 ;;PRINT NURSE STAFFING STATS
A0 S ANSU=$S($D(^ANSD(59.1,ANSUNIT,0)):$P(^(0),U),1:""),Y=ANSBDT
 X ^DD("DD")
 S ANSDT=Y,ANSPG=0,ANSDU=""
 S ANSWTH=$T(WTH),ANSTAB=$T(TAB)
 I ANSBDT'=ANSEDT S Y=ANSEDT X ^DD("DD") S ANSDU=Y
 S (ANSR,ANSPTC)="",ANSD=0
 K A
 S ANSIOT=0
 I $D(IOST),IOST?1"C-".E S ANSIOT=1 I $D(IOF) W @IOF
A1 D HEAD,^ANSQSP1
 I ANSIOT D PAUSE^ANSDIC
 Q
HEAD ;EP
 K ANSPLK
 S ANSHEAD=""
 D STAFSTAT^ANSQ
 S ANSPG=ANSPG+1
 W ?70,"Page ",ANSPG
 W !,?80-$L(ANSU)\2,ANSU,!!,?80-$L(ANSDT)\2,ANSDT,!
 I ANSDU]"" W ?39,"to",!,?80-$L(ANSDU)\2,ANSDU,!
H1 W !!,?1,"Date/",?8,"Avg",?12,"Max",?16,"#",?20,"#",?27,"-----  Acuity Level  -----",?60,"Req",?66,"Aval",?72,"% Effi-"
 W !,?1,"Shift",?8,"#Pt",?12,"#Pt",?16,"Adm",?20,"D/C",?24,"I",?30,"II",?36,"III",?42,"IV",?48,"V",?54,"VI",?60,"Hours",?66,"Hours",?72,"ciency"
H9 ;EP
 W !,"------ ---- --- --- --- ----- ----- ----- ----- ----- ----- ----- ----- -------"
 Q
 ;;8;;12;;16;;20;;24;;30;;36;;42;;48;;54;;60;;66;;72;;
TAB ;;6;;11;;15;;19;;23;;29;;35;;41;;47;;53;;59;;65;;71;;
WTH ;;2;;3;;3;;3;;3;;3;;3;;3;;3;;3;;3;;3;;5;;
