ATXXB193 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON APR 29, 2014;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1804,BB16ZZZ ",.01)
 ;;BB16ZZZ 
 ;;9002226.02101,"1804,BB16ZZZ ",.02)
 ;;BB16ZZZ 
 ;;9002226.02101,"1804,BB16ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB17YZZ ",.01)
 ;;BB17YZZ 
 ;;9002226.02101,"1804,BB17YZZ ",.02)
 ;;BB17YZZ 
 ;;9002226.02101,"1804,BB17YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB18YZZ ",.01)
 ;;BB18YZZ 
 ;;9002226.02101,"1804,BB18YZZ ",.02)
 ;;BB18YZZ 
 ;;9002226.02101,"1804,BB18YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB19YZZ ",.01)
 ;;BB19YZZ 
 ;;9002226.02101,"1804,BB19YZZ ",.02)
 ;;BB19YZZ 
 ;;9002226.02101,"1804,BB19YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB1CZZZ ",.01)
 ;;BB1CZZZ 
 ;;9002226.02101,"1804,BB1CZZZ ",.02)
 ;;BB1CZZZ 
 ;;9002226.02101,"1804,BB1CZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB1DZZZ ",.01)
 ;;BB1DZZZ 
 ;;9002226.02101,"1804,BB1DZZZ ",.02)
 ;;BB1DZZZ 
 ;;9002226.02101,"1804,BB1DZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB2400Z ",.01)
 ;;BB2400Z 
 ;;9002226.02101,"1804,BB2400Z ",.02)
 ;;BB2400Z 
 ;;9002226.02101,"1804,BB2400Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BB240ZZ ",.01)
 ;;BB240ZZ 
 ;;9002226.02101,"1804,BB240ZZ ",.02)
 ;;BB240ZZ 
 ;;9002226.02101,"1804,BB240ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB2410Z ",.01)
 ;;BB2410Z 
 ;;9002226.02101,"1804,BB2410Z ",.02)
 ;;BB2410Z 
 ;;9002226.02101,"1804,BB2410Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BB241ZZ ",.01)
 ;;BB241ZZ 
 ;;9002226.02101,"1804,BB241ZZ ",.02)
 ;;BB241ZZ 
 ;;9002226.02101,"1804,BB241ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB24Y0Z ",.01)
 ;;BB24Y0Z 
 ;;9002226.02101,"1804,BB24Y0Z ",.02)
 ;;BB24Y0Z 
 ;;9002226.02101,"1804,BB24Y0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BB24YZZ ",.01)
 ;;BB24YZZ 
 ;;9002226.02101,"1804,BB24YZZ ",.02)
 ;;BB24YZZ 
 ;;9002226.02101,"1804,BB24YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB24ZZZ ",.01)
 ;;BB24ZZZ 
 ;;9002226.02101,"1804,BB24ZZZ ",.02)
 ;;BB24ZZZ 
 ;;9002226.02101,"1804,BB24ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB2700Z ",.01)
 ;;BB2700Z 
 ;;9002226.02101,"1804,BB2700Z ",.02)
 ;;BB2700Z 
 ;;9002226.02101,"1804,BB2700Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BB270ZZ ",.01)
 ;;BB270ZZ 
 ;;9002226.02101,"1804,BB270ZZ ",.02)
 ;;BB270ZZ 
 ;;9002226.02101,"1804,BB270ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB2710Z ",.01)
 ;;BB2710Z 
 ;;9002226.02101,"1804,BB2710Z ",.02)
 ;;BB2710Z 
 ;;9002226.02101,"1804,BB2710Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BB271ZZ ",.01)
 ;;BB271ZZ 
 ;;9002226.02101,"1804,BB271ZZ ",.02)
 ;;BB271ZZ 
 ;;9002226.02101,"1804,BB271ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB27Y0Z ",.01)
 ;;BB27Y0Z 
 ;;9002226.02101,"1804,BB27Y0Z ",.02)
 ;;BB27Y0Z 
 ;;9002226.02101,"1804,BB27Y0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BB27YZZ ",.01)
 ;;BB27YZZ 
 ;;9002226.02101,"1804,BB27YZZ ",.02)
 ;;BB27YZZ 
 ;;9002226.02101,"1804,BB27YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB27ZZZ ",.01)
 ;;BB27ZZZ 
 ;;9002226.02101,"1804,BB27ZZZ ",.02)
 ;;BB27ZZZ 
 ;;9002226.02101,"1804,BB27ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB2800Z ",.01)
 ;;BB2800Z 
 ;;9002226.02101,"1804,BB2800Z ",.02)
 ;;BB2800Z 
 ;;9002226.02101,"1804,BB2800Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BB280ZZ ",.01)
 ;;BB280ZZ 
 ;;9002226.02101,"1804,BB280ZZ ",.02)
 ;;BB280ZZ 
 ;;9002226.02101,"1804,BB280ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB2810Z ",.01)
 ;;BB2810Z 
 ;;9002226.02101,"1804,BB2810Z ",.02)
 ;;BB2810Z 
 ;;9002226.02101,"1804,BB2810Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BB281ZZ ",.01)
 ;;BB281ZZ 
 ;;9002226.02101,"1804,BB281ZZ ",.02)
 ;;BB281ZZ 
 ;;9002226.02101,"1804,BB281ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB28Y0Z ",.01)
 ;;BB28Y0Z 
 ;;9002226.02101,"1804,BB28Y0Z ",.02)
 ;;BB28Y0Z 
 ;;9002226.02101,"1804,BB28Y0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BB28YZZ ",.01)
 ;;BB28YZZ 
 ;;9002226.02101,"1804,BB28YZZ ",.02)
 ;;BB28YZZ 
 ;;9002226.02101,"1804,BB28YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB28ZZZ ",.01)
 ;;BB28ZZZ 
 ;;9002226.02101,"1804,BB28ZZZ ",.02)
 ;;BB28ZZZ 
 ;;9002226.02101,"1804,BB28ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB2900Z ",.01)
 ;;BB2900Z 
 ;;9002226.02101,"1804,BB2900Z ",.02)
 ;;BB2900Z 
 ;;9002226.02101,"1804,BB2900Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BB290ZZ ",.01)
 ;;BB290ZZ 
 ;;9002226.02101,"1804,BB290ZZ ",.02)
 ;;BB290ZZ 
 ;;9002226.02101,"1804,BB290ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB2910Z ",.01)
 ;;BB2910Z 
 ;;9002226.02101,"1804,BB2910Z ",.02)
 ;;BB2910Z 
 ;;9002226.02101,"1804,BB2910Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BB291ZZ ",.01)
 ;;BB291ZZ 
 ;;9002226.02101,"1804,BB291ZZ ",.02)
 ;;BB291ZZ 
 ;;9002226.02101,"1804,BB291ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB29Y0Z ",.01)
 ;;BB29Y0Z 
 ;;9002226.02101,"1804,BB29Y0Z ",.02)
 ;;BB29Y0Z 
 ;;9002226.02101,"1804,BB29Y0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BB29YZZ ",.01)
 ;;BB29YZZ 
 ;;9002226.02101,"1804,BB29YZZ ",.02)
 ;;BB29YZZ 
 ;;9002226.02101,"1804,BB29YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB29ZZZ ",.01)
 ;;BB29ZZZ 
 ;;9002226.02101,"1804,BB29ZZZ ",.02)
 ;;BB29ZZZ 
 ;;9002226.02101,"1804,BB29ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB2F00Z ",.01)
 ;;BB2F00Z 
 ;;9002226.02101,"1804,BB2F00Z ",.02)
 ;;BB2F00Z 
 ;;9002226.02101,"1804,BB2F00Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BB2F0ZZ ",.01)
 ;;BB2F0ZZ 
 ;;9002226.02101,"1804,BB2F0ZZ ",.02)
 ;;BB2F0ZZ 
 ;;9002226.02101,"1804,BB2F0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB2F10Z ",.01)
 ;;BB2F10Z 
 ;;9002226.02101,"1804,BB2F10Z ",.02)
 ;;BB2F10Z 
 ;;9002226.02101,"1804,BB2F10Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BB2F1ZZ ",.01)
 ;;BB2F1ZZ 
 ;;9002226.02101,"1804,BB2F1ZZ ",.02)
 ;;BB2F1ZZ 
 ;;9002226.02101,"1804,BB2F1ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB2FY0Z ",.01)
 ;;BB2FY0Z 
 ;;9002226.02101,"1804,BB2FY0Z ",.02)
 ;;BB2FY0Z 
 ;;9002226.02101,"1804,BB2FY0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BB2FYZZ ",.01)
 ;;BB2FYZZ 
 ;;9002226.02101,"1804,BB2FYZZ ",.02)
 ;;BB2FYZZ 
 ;;9002226.02101,"1804,BB2FYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB2FZZZ ",.01)
 ;;BB2FZZZ 
 ;;9002226.02101,"1804,BB2FZZZ ",.02)
 ;;BB2FZZZ 
 ;;9002226.02101,"1804,BB2FZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB3GY0Z ",.01)
 ;;BB3GY0Z 
 ;;9002226.02101,"1804,BB3GY0Z ",.02)
 ;;BB3GY0Z 
 ;;9002226.02101,"1804,BB3GY0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BB3GYZZ ",.01)
 ;;BB3GYZZ 
 ;;9002226.02101,"1804,BB3GYZZ ",.02)
 ;;BB3GYZZ 
 ;;9002226.02101,"1804,BB3GYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB3GZZZ ",.01)
 ;;BB3GZZZ 
 ;;9002226.02101,"1804,BB3GZZZ ",.02)
 ;;BB3GZZZ 
 ;;9002226.02101,"1804,BB3GZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB4BZZZ ",.01)
 ;;BB4BZZZ 
 ;;9002226.02101,"1804,BB4BZZZ ",.02)
 ;;BB4BZZZ 
 ;;9002226.02101,"1804,BB4BZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BB4CZZZ ",.01)
 ;;BB4CZZZ 
 ;;9002226.02101,"1804,BB4CZZZ ",.02)
 ;;BB4CZZZ 
 ;;9002226.02101,"1804,BB4CZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD11YZZ ",.01)
 ;;BD11YZZ 
 ;;9002226.02101,"1804,BD11YZZ ",.02)
 ;;BD11YZZ 
 ;;9002226.02101,"1804,BD11YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD11ZZZ ",.01)
 ;;BD11ZZZ 
 ;;9002226.02101,"1804,BD11ZZZ ",.02)
 ;;BD11ZZZ 
 ;;9002226.02101,"1804,BD11ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD12YZZ ",.01)
 ;;BD12YZZ 
 ;;9002226.02101,"1804,BD12YZZ ",.02)
 ;;BD12YZZ 
 ;;9002226.02101,"1804,BD12YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD12ZZZ ",.01)
 ;;BD12ZZZ 
 ;;9002226.02101,"1804,BD12ZZZ ",.02)
 ;;BD12ZZZ 
 ;;9002226.02101,"1804,BD12ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD13YZZ ",.01)
 ;;BD13YZZ 
 ;;9002226.02101,"1804,BD13YZZ ",.02)
 ;;BD13YZZ 
 ;;9002226.02101,"1804,BD13YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD13ZZZ ",.01)
 ;;BD13ZZZ 
 ;;9002226.02101,"1804,BD13ZZZ ",.02)
 ;;BD13ZZZ 
 ;;9002226.02101,"1804,BD13ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD14YZZ ",.01)
 ;;BD14YZZ 
 ;;9002226.02101,"1804,BD14YZZ ",.02)
 ;;BD14YZZ 
 ;;9002226.02101,"1804,BD14YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD14ZZZ ",.01)
 ;;BD14ZZZ 
 ;;9002226.02101,"1804,BD14ZZZ ",.02)
 ;;BD14ZZZ 
 ;;9002226.02101,"1804,BD14ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD15YZZ ",.01)
 ;;BD15YZZ 
 ;;9002226.02101,"1804,BD15YZZ ",.02)
 ;;BD15YZZ 
 ;;9002226.02101,"1804,BD15YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD15ZZZ ",.01)
 ;;BD15ZZZ 
 ;;9002226.02101,"1804,BD15ZZZ ",.02)
 ;;BD15ZZZ 
 ;;9002226.02101,"1804,BD15ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD16YZZ ",.01)
 ;;BD16YZZ 
 ;;9002226.02101,"1804,BD16YZZ ",.02)
 ;;BD16YZZ 
 ;;9002226.02101,"1804,BD16YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD16ZZZ ",.01)
 ;;BD16ZZZ 
 ;;9002226.02101,"1804,BD16ZZZ ",.02)
 ;;BD16ZZZ 
 ;;9002226.02101,"1804,BD16ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD19YZZ ",.01)
 ;;BD19YZZ 
 ;;9002226.02101,"1804,BD19YZZ ",.02)
 ;;BD19YZZ 
 ;;9002226.02101,"1804,BD19YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD19ZZZ ",.01)
 ;;BD19ZZZ 
 ;;9002226.02101,"1804,BD19ZZZ ",.02)
 ;;BD19ZZZ 
 ;;9002226.02101,"1804,BD19ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD1BYZZ ",.01)
 ;;BD1BYZZ 
 ;;9002226.02101,"1804,BD1BYZZ ",.02)
 ;;BD1BYZZ 
 ;;9002226.02101,"1804,BD1BYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD1BZZZ ",.01)
 ;;BD1BZZZ 
 ;;9002226.02101,"1804,BD1BZZZ ",.02)
 ;;BD1BZZZ 
 ;;9002226.02101,"1804,BD1BZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD2400Z ",.01)
 ;;BD2400Z 
 ;;9002226.02101,"1804,BD2400Z ",.02)
 ;;BD2400Z 
 ;;9002226.02101,"1804,BD2400Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BD240ZZ ",.01)
 ;;BD240ZZ 
 ;;9002226.02101,"1804,BD240ZZ ",.02)
 ;;BD240ZZ 
 ;;9002226.02101,"1804,BD240ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD2410Z ",.01)
 ;;BD2410Z 
 ;;9002226.02101,"1804,BD2410Z ",.02)
 ;;BD2410Z 
 ;;9002226.02101,"1804,BD2410Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BD241ZZ ",.01)
 ;;BD241ZZ 
 ;;9002226.02101,"1804,BD241ZZ ",.02)
 ;;BD241ZZ 
 ;;9002226.02101,"1804,BD241ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD24Y0Z ",.01)
 ;;BD24Y0Z 
 ;;9002226.02101,"1804,BD24Y0Z ",.02)
 ;;BD24Y0Z 
 ;;9002226.02101,"1804,BD24Y0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BD24YZZ ",.01)
 ;;BD24YZZ 
 ;;9002226.02101,"1804,BD24YZZ ",.02)
 ;;BD24YZZ 
 ;;9002226.02101,"1804,BD24YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD24ZZZ ",.01)
 ;;BD24ZZZ 
 ;;9002226.02101,"1804,BD24ZZZ ",.02)
 ;;BD24ZZZ 
 ;;9002226.02101,"1804,BD24ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD41ZZZ ",.01)
 ;;BD41ZZZ 
 ;;9002226.02101,"1804,BD41ZZZ ",.02)
 ;;BD41ZZZ 
 ;;9002226.02101,"1804,BD41ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD42ZZZ ",.01)
 ;;BD42ZZZ 
 ;;9002226.02101,"1804,BD42ZZZ ",.02)
 ;;BD42ZZZ 
 ;;9002226.02101,"1804,BD42ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD47ZZZ ",.01)
 ;;BD47ZZZ 
 ;;9002226.02101,"1804,BD47ZZZ ",.02)
 ;;BD47ZZZ 
 ;;9002226.02101,"1804,BD47ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD48ZZZ ",.01)
 ;;BD48ZZZ 
 ;;9002226.02101,"1804,BD48ZZZ ",.02)
 ;;BD48ZZZ 
 ;;9002226.02101,"1804,BD48ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD49ZZZ ",.01)
 ;;BD49ZZZ 
 ;;9002226.02101,"1804,BD49ZZZ ",.02)
 ;;BD49ZZZ 
 ;;9002226.02101,"1804,BD49ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BD4CZZZ ",.01)
 ;;BD4CZZZ 
 ;;9002226.02101,"1804,BD4CZZZ ",.02)
 ;;BD4CZZZ 
 ;;9002226.02101,"1804,BD4CZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BF000ZZ ",.01)
 ;;BF000ZZ 
 ;;9002226.02101,"1804,BF000ZZ ",.02)
 ;;BF000ZZ 
 ;;9002226.02101,"1804,BF000ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BF001ZZ ",.01)
 ;;BF001ZZ 
 ;;9002226.02101,"1804,BF001ZZ ",.02)
 ;;BF001ZZ 
 ;;9002226.02101,"1804,BF001ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BF00YZZ ",.01)
 ;;BF00YZZ 
 ;;9002226.02101,"1804,BF00YZZ ",.02)
 ;;BF00YZZ 
 ;;9002226.02101,"1804,BF00YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BF030ZZ ",.01)
 ;;BF030ZZ 