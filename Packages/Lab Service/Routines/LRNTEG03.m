LRNTEG03 ;ISC/XTSUMBLD KERNEL - Package checksum checker ;3070621.074623
 ;;5.2;LR;**1022**;September 20, 2007
 ;;7.3;3070621.074623
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 G CONT^LRNTEG04
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
LAMIAUT7 ;;14518538
LAMIAUT8 ;;10340000
LAMICRA ;;6311788
LAMILL ;;8944628
LAMIV00 ;;5862733
LAMIV10 ;;3331102
LAMIV11 ;;4680759
LAMIV12 ;;3619700
LAMIVT5 ;;6927182
LAMIVT6 ;;6921240
LAMIVTE6 ;;6998056
LAMIVTK ;;6784909
LAMIVTK6 ;;7085259
LAMIVTKC ;;3994248
LAMIVTKD ;;14216541
LAMIVTKU ;;7044950
LAMIVTL0 ;;4804881
LAMIVTL1 ;;4142338
LAMIVTL2 ;;10703707
LAMIVTL3 ;;3299284
LAMIVTL4 ;;6769238
LAMIVTL5 ;;1376331
LAMIVTL6 ;;3288456
LAMIVTLB ;;1364766
LAMIVTLC ;;5019925
LAMIVTLD ;;7972214
LAMIVTLE ;;994051
LAMIVTLG ;;8564481
LAMIVTLP ;;6086662
LAMIVTLW ;;770337
LAMIVTLX ;;3266873
LAMLA1KC ;;3124093
LAMLA7 ;;1641617
LAMODH ;;3459105
LAMODU ;;3794865
LAMODUT ;;2211014
LAMONARK ;;2309407
LAMSA ;;6083064
LAMSA1 ;;3625448
LAMSBLD ;;3734278
LAMSP ;;692212
LAMSPAN ;;1838580
LAMSTAT ;;2119915
LANOVA ;;1712264
LANOVST ;;1848215
LANTEG ;;4211836
LANTEG0 ;;3033078
LAPARA ;;2066711
LAPARAP ;;2874335
LAPER ;;2576867
LAPERD ;;3827771
LAPFICH ;;4131949
LAPMAX ;;2268261
LAPMAXD ;;6418961
LAPORT33 ;;5382490
LAPORTXX ;;4485013
LAPOS ;;882550
LAPRE ;;5512799
LAPX ;;1834961
LARA1K ;;1945610
LARA2K ;;2831956
LARAPMT ;;4611052
LARMK ;;449162
LAS550 ;;1626746
LAS790 ;;1638395
LASCT ;;1709672
LASET ;;6955342
LASMA12 ;;1846087
LASMA2 ;;3074622
LASMA2C ;;2897999
LASMAC4 ;;3193623
LASMACA ;;4323959
LASP120 ;;1840673
LASPEC ;;2719343
LASTATUS ;;5936005
LASTRA ;;2662339
LASYS8K ;;1648831
LASYSMEX ;;1733439
LATDX ;;2882657
LATDX1 ;;3024728
LATOA ;;1873692
LAWATCH ;;9710096
LAXSYM ;;5565011
LAXSYMBL ;;5696006
LAXSYMDL ;;2981097
LAXSYMHQ ;;3995005
LAXSYMU ;;6538662
LAYIRIS ;;3237785
LR00I001 ;;18594257
LR00I002 ;;2441896
LR00INI1 ;;5646091
LR00INI2 ;;5232407
LR00INI3 ;;16090539
LR00INI4 ;;3357579
LR00INI5 ;;399044
LR00INIS ;;2199350
LR00INIT ;;10903109
LR01NTEG ;;3330266
LR08KILL ;;56870
LR1001 ;;2721914
LR1008P ;;502386
LR104 ;;2259194
LR105 ;;2776988
LR105PO ;;4566808
LR116 ;;2914350
LR119 ;;2185349
LR119PO ;;264897
LR125 ;;2260244
LR127P ;;882777
LR127PO ;;6121685
LR132P ;;4634747
LR138PO ;;4947028
LR140P ;;2584185
LR153 ;;10233379
LR156P ;;59608
LR157 ;;2746802
LR161 ;;2465270
LR163 ;;15398346
LR175 ;;3256174
LR175P ;;3819464
LR176 ;;2214791
LR201 ;;2363645
LR210 ;;13030860
LR212 ;;1389532
LR213 ;;1389561
LR221 ;;2442952
LR231 ;;1389557
LR232 ;;9549526
LR232P ;;8998905
LR234 ;;1305221
LR239 ;;2518066
LR240 ;;2517832
LR243 ;;7341436
LR248 ;;3570608
LR256 ;;327087
LR258 ;;4256733
LR258PO ;;12125678
LR259 ;;3570617
LR260 ;;13700
LR263 ;;7411624
LR264 ;;2486450
LR267PRE ;;3840011
LR267PST ;;5378337
LR274POA ;;4237646
LR275PRE ;;3875657
LR281 ;;4418718
LR287 ;;5220915
LR302 ;;7036526
LR302A ;;4415522
LR302P ;;3800106
LR302PO ;;9375744
LR302POA ;;2988034
LR305 ;;5011529
LR307 ;;2107378
LR313 ;;4332772
LR52IHS ;;7230609
LR6NTEG ;;3951596
LR6NTEG0 ;;3981121
LR6NTEG1 ;;3970312
LR6NTEG2 ;;3928543
LR6NTEG3 ;;3901103
LR6NTEG4 ;;2622271
LR72ENVC ;;10118822
LR72PRE ;;10042975