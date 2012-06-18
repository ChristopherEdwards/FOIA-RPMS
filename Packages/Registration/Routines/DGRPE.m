DGRPE ;ALB/MRL - REGISTRATIONS EDITS ; 8/11/03 1:27pm
 ;;5.3;Registration;**32,114,139,169,175,247,190,343,397,342,454,415,489,506,244,547**;Aug 13, 1993
 ;
 ;DGDR contains a string of edits; edit=screen*10+item #
 ;
 ;line tag screen*10+item*1000 = continuation line
 ;
 I DGRPS=8 D ^DGRPEIS,Q Q  ; family demographic edit...not conventional!!  :)
 I DGRPS=9 D EDIT9^DGRPEIS2,Q Q  ; income screening data ($$$)
 I DGRPS=5,DGDR["501," D
 .I $G(DGPRFLG) D PREG^IBCNBME(DFN) Q
 .D REG^IBCNBME(DFN)
 .Q
 ;-- Tricare screen #15
 I DGRPS=15 D EDIT^DGRP15,Q Q
 ;
 N DGPH,DGPHFLG
 K DR S (DA,Y)=DFN,DIE="^DPT(",DR="",DGDRS="DR",DGCT=0 G ^DGRPE1:DGRPS>6
 F I=1:1 S J=$P(DGDR,",",I) Q:J=""  F J1=J,J*1000,J*1000+1,J*1000+2 Q:'$T(@J1)  S DGDRD=$P($T(@J1),";;",2) D S
 D ^DIE
 I $G(DGPHFLG)>0 D EDITPH1^DGRPLE()
Q K DA,DIE,DR,DGCT,DGDR,DGDRD,DGDRS,DGRPADI,I,J,J1
 Q
S I $L(@DGDRS)+$L(DGDRD)<241 S @DGDRS=@DGDRS_DGDRD Q
 S DGCT=DGCT+1,DGDRS="DR(1,2,"_DGCT_")",@DGDRS=DGDRD Q
 Q
101 ;;K DG20NAME;.01;.01///^S X=$$NCEDIT^DPTNAME(DFN,,.DG20NAME);K DG20NAME;.09;.03;
102 ;;1;
103 ;;.091;
104 ;;S DIE("NO^")="OUTOK";.111;S:X="" Y="@1112";.112;S:X="" Y="@1112";.113;@1112;S EASZIPLK=1;.1112;K EASDO2;.114;S:'$$KEY^DGREGDD1(DUZ,DA) Y=.131;.115;.117;.131;.132;.121;K DIE("NO^");
105 ;;.12105//NO;S:X="N" Y="@15" S:X="Y" DIE("NO^")="";.1217;I X']"" W !?4,$C(7),"But I need a Start Date for this Temporary Address." S Y=.12105;.1218;.1211;I X']"" W !?4,$C(7),"But I need at least one line of a Temporary address." S Y=.12105;
111 ;;.14105//NO;S:X="N" Y="@15" S:X="Y" DIE("NO^")="";.1417;I X']"" W !?4,$C(7),"But I need a Start Date." S Y=.14105;.1418;D DR111^DGRPE;.141;I '$P($$CAACT^DGRPCADD(DFN),U,2) W !?4,"But I need at least one active category." S Y=.14105;
111000 ;;K DR(2,2.141);.1411;I X']"" W !?4,$C(7),"I need at least one line of Address." S Y=.14105;.1412;S:X']"" Y=.1414;.1413;.1414;.1415;.1416;Q;.14111;@15;K DIE("NO^");
109 ;;S DIE("NO^")="OUTOK";.111;S:X="" Y="@1112";.112;S:X="" Y="@1112";.113;@1112;S EASZIPLK=1;.1112;K EASDO2;.114;S:'$$KEY^DGREGDD1(DUZ,DA) Y=.131;.115;.117;.131;.132;.121;.02;D DR109^DGRPE;6;2;K DR(2,2.02),DR(2,2.06);.05;.08;K DIE("NO^");
105000 ;;.1212;S:X']"" Y=.1214;.1213:.1215;.12112;Q;.12111;.1219;@15;K DIE("NO^");
201 ;;.02;.05;.08;.092;.093;.2401:.2403;57.4//NOT APPLICABLE;
202 ;;1010.15//NO;S:X'="Y" Y="@22";S DIE("NO^")="";1010.152;I X']"" W !?4,*7,"But I need to know where you were treated most recently." S Y=1010.15;1010.151;1010.154;S:X']"" Y="@22";1010.153;@22;K DIE("NO^");
203 ;;D DR203^DGRPE;6ETHNICITY;2RACE;K DR(2,2.02),DR(2,2.06);
301 ;;.211;S:X']"" Y="@31";.212;.2125//NO;I X="Y" S DGADD=".21" D AD^DGRPE S Y=.21011;.213;S:X']"" Y=.216;.214;S:X']"" Y=.216;.215:.217;.2207;.219;.21011;@31;
302 ;;.2191;S:X']"" Y="@32";.2192;.21925//NO;I X="Y" S DGADD=".211" D AD^DGRPE S Y=.211011;
302000 ;;.2193;S:X']"" Y=.2196;.2194;S:X']"" Y=.2196;.2195:.2197;.2203;.2199;.211011;@32;
303 ;;N DGX1,DGX2;I '$L($P($G(^DPT(DFN,.21)),U)) S Y="@33";.3305//NO;I X="Y" S Y="@34",DGX1=1;@33;S:$D(^DPT(DFN,.22)) $P(^(.22),U,1)=$P(^(.22),U,7);.331;S:X']"" DGX1=2,Y="@34";.332;@34;
303000 ;;S:$G(DGX1) Y="@341";.333;S:X']"" Y=.336;.334;S:X']"" Y=.336;.335:.337;.2201;.339;.33011;S DGX1=2;@341;
303001 ;;S:$G(DGX1)=2 Y="@35";S DGX2=$G(^DPT(DA,.21));.331///^S X=$P(DGX2,U);.332///^S X=$P(DGX2,U,2);.333///^S X=$P(DGX2,U,3);.334///^S X=$P(DGX2,U,4);@35;
303002 ;;S:$G(DGX1)=2 Y="@351";.335///^S X=$P(DGX2,U,5);.336///^S X=$P(DGX2,U,6);.337///^S X=$P(DGX2,U,7);.338///^S X=$P(DGX2,U,8);.339///^S X=$P(DGX2,U,9);.33011///^S X=$P(DGX2,U,11);@351;K DGX1,DGX2;
304 ;;.3311;S:X']"" Y="@36";.3312;.3313;S:X']"" Y=.3316;.3314;S:X']"" Y=.3316;.3315:.3317;.2204;.3319;.331011;@36;        
305 ;;N DGX1,DGX2;I '$L($P($G(^DPT(DFN,.21)),U)) S Y="@37";.3405//NO;I X="Y" S DGX1=1,Y="@371";@37;S:$D(^DPT(DFN,.22)) $P(^(.22),U,2)=$P(^(.22),U,7);.341;S:X']"" DGX1=2,Y="@371";.342;@371;
305000 ;;S:$G(DGX1) Y="@38";.343;S:X']"" Y=.346;.344;S:X']"" Y=.346;.345:.347;.2202;.349;.34011;S DGX1=2;@38;
305001 ;;S:$G(DGX1)=2 Y="@381";S DGX2=$G(^DPT(DA,.21));.341///^S X=$P(DGX2,U);.342///^S X=$P(DGX2,U,2);.343///^S X=$P(DGX2,U,3);.344///^S X=$P(DGX2,U,4);@381
305002 ;;S:$G(DGX1)=2 Y="@39";.345///^S X=$P(DGX2,U,5);.346///^S X=$P(DGX2,U,6);.347///^S X=$P(DGX2,U,7);.348///^S X=$P(DGX2,U,8);.349///^S X=$P(DGX2,U,9);.34011///^S X=$P(DGX2,U,11);@39;K DGX1,DGX2;
401 ;;.07;.31115;I $S(X']"":1,X=3:1,X=9:1,1:0) S Y="@41";.3111;S:X']"" Y="@41";.3113;S:X']"" Y=.3116;.3114;S:X']"" Y=.3116;.3115:.3117;.2205;.3119;@41;
402 ;;.2514;.2515;I $S(X']"":1,X=3:1,X=9:1,1:0) S Y="@42";.251;S:X']"" Y="@42";.252;S:X']"" Y=.255;.253;S:X']"" Y=.255;.254:.256;.2206;.258;@42;
501 ;;
502 ;;.381;.382///NOW;
503 ;;.383;
601 ;;.325;S:X']"" Y="@61";.328;.326;.327;.324;.3285//NO;S:X'="Y" Y="@61";.3291;S:X']"" Y="@61";.3294;.3292;.3293;.329;.32945//NO;S:X'="Y" Y="@61";.3296;S:X']"" Y="@61";.3299;.3297;.3298;.3295;@61;
602 ;;.525//NO;S:X'="Y" Y="@62";.526:.528;@62;
603 ;;.5291//NO;S:X'="Y" Y="@63";.5292:.5294;@63;
604 ;;.32101//NO;S:X'="Y" Y="@64";.32104;.32105;@64;
605 ;;.32102//NO;S:X'="Y" Y="@65";.32107;.32109;.3211;.3213;@65;
606 ;;.32103//NO;S:X'="Y" Y="@66";.3212;.32111;@66;
607 ;;.3221//NO;S:X'="Y" Y="@67";.3222;Q;.3223;@67;
608 ;;.3224//NO;S:X'="Y" Y="@68";.3225;Q;.3226;@68;
609 ;;.3227//NO;S:X'="Y" Y="@69";.3228;Q;.3229;@69;
610 ;;.32201//NO;S:X'="Y" Y="@610";.322011;Q;.322012;@610;
611 ;;.322016//NO;S:X'="Y" Y="@611";.322017;Q;.322018;@611;
612 ;;.322013//NO;S:X'="Y" Y="@612";.322014;Q;.322015;@612;
613 ;;.362;
614 ;;.368//NO;.369//NO;I $S('$D(^DPT(DA,.36)):1,$P(^(.36),U,8)="Y"!($P(^(.36),U,9)="Y"):0,1:1) S Y="@614";.37;@614;
615 ;;.322019//NO;S:X'="Y" Y="@615";.32202;Q;.322021;@615;
616 ;;S DGPHFLG=0;.531;S:X'="Y" DGX=X,Y="@616";.532///^S X="PENDING";S Y="@6161";@616;S:DGX'="N" Y="@6162";.533///^S X="VAMC";@6161;S DGPHFLG=1;.535///^S X=$$DIV^DGRPLE();@6162;
617 ;;D REG^DGNTQ(DFN);
AD N DGZ4,DGPC
 S X=$S($D(^DPT(DA,.11)):^(.11),1:""),DGZ4=$P(X,U,12),DGPHONE=$S($D(^(.13)):$P(^(.13),U,1),1:""),Y=$S($D(^(DGADD)):^(DGADD),1:""),^(DGADD)=$P(Y,U,1)_U_$P(Y,U,2)_U_$P(X,U,1,6)_U_DGPHONE_U_$P(Y,U,10)
 I DGZ4 S DGPC=$S((DGADD=.33):1,(DGADD=.34):2,(DGADD=.211):3,(DGADD=.331):4,(DGADD=.311):5,(DGADD=.25):6,(DGADD=.21):7,1:0) S:DGPC $P(^DPT(DFN,.22),U,DGPC)=DGZ4
 K DGADD,DGPHONE Q
DR109 ;Drop through (use same logic as DR203)
DR203 S DR(2,2.02)=".01RACE;I $P($G(^DIC(10.3,+$P($G(^DPT(DA(1),.02,DA,0)),""^"",2),0)),""^"",2)=""S"" S Y=""@2031"";.02;@2031;"
 S DR(2,2.06)=".01ETHNICITY;I $P($G(^DIC(10.3,+$P($G(^DPT(DA(1),.06,DA,0)),""^"",2),0)),""^"",2)=""S"" S Y=""@2032"";.02;@2032;"
 Q
DR111 ;Set DR string for Confidential Address categories
 S DR(2,2.141)=".01;1//YES;"
 Q
