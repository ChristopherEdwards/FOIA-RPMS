ATXXB131 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON APR 29, 2014;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1804,0XBB3ZX ",.02)
 ;;0XBB3ZX 
 ;;9002226.02101,"1804,0XBB3ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBB3ZZ ",.01)
 ;;0XBB3ZZ 
 ;;9002226.02101,"1804,0XBB3ZZ ",.02)
 ;;0XBB3ZZ 
 ;;9002226.02101,"1804,0XBB3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBB4ZX ",.01)
 ;;0XBB4ZX 
 ;;9002226.02101,"1804,0XBB4ZX ",.02)
 ;;0XBB4ZX 
 ;;9002226.02101,"1804,0XBB4ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBB4ZZ ",.01)
 ;;0XBB4ZZ 
 ;;9002226.02101,"1804,0XBB4ZZ ",.02)
 ;;0XBB4ZZ 
 ;;9002226.02101,"1804,0XBB4ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBC0ZX ",.01)
 ;;0XBC0ZX 
 ;;9002226.02101,"1804,0XBC0ZX ",.02)
 ;;0XBC0ZX 
 ;;9002226.02101,"1804,0XBC0ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBC0ZZ ",.01)
 ;;0XBC0ZZ 
 ;;9002226.02101,"1804,0XBC0ZZ ",.02)
 ;;0XBC0ZZ 
 ;;9002226.02101,"1804,0XBC0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBC3ZX ",.01)
 ;;0XBC3ZX 
 ;;9002226.02101,"1804,0XBC3ZX ",.02)
 ;;0XBC3ZX 
 ;;9002226.02101,"1804,0XBC3ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBC3ZZ ",.01)
 ;;0XBC3ZZ 
 ;;9002226.02101,"1804,0XBC3ZZ ",.02)
 ;;0XBC3ZZ 
 ;;9002226.02101,"1804,0XBC3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBC4ZX ",.01)
 ;;0XBC4ZX 
 ;;9002226.02101,"1804,0XBC4ZX ",.02)
 ;;0XBC4ZX 
 ;;9002226.02101,"1804,0XBC4ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBC4ZZ ",.01)
 ;;0XBC4ZZ 
 ;;9002226.02101,"1804,0XBC4ZZ ",.02)
 ;;0XBC4ZZ 
 ;;9002226.02101,"1804,0XBC4ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBD0ZX ",.01)
 ;;0XBD0ZX 
 ;;9002226.02101,"1804,0XBD0ZX ",.02)
 ;;0XBD0ZX 
 ;;9002226.02101,"1804,0XBD0ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBD0ZZ ",.01)
 ;;0XBD0ZZ 
 ;;9002226.02101,"1804,0XBD0ZZ ",.02)
 ;;0XBD0ZZ 
 ;;9002226.02101,"1804,0XBD0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBD3ZX ",.01)
 ;;0XBD3ZX 
 ;;9002226.02101,"1804,0XBD3ZX ",.02)
 ;;0XBD3ZX 
 ;;9002226.02101,"1804,0XBD3ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBD3ZZ ",.01)
 ;;0XBD3ZZ 
 ;;9002226.02101,"1804,0XBD3ZZ ",.02)
 ;;0XBD3ZZ 
 ;;9002226.02101,"1804,0XBD3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBD4ZX ",.01)
 ;;0XBD4ZX 
 ;;9002226.02101,"1804,0XBD4ZX ",.02)
 ;;0XBD4ZX 
 ;;9002226.02101,"1804,0XBD4ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBD4ZZ ",.01)
 ;;0XBD4ZZ 
 ;;9002226.02101,"1804,0XBD4ZZ ",.02)
 ;;0XBD4ZZ 
 ;;9002226.02101,"1804,0XBD4ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBF0ZX ",.01)
 ;;0XBF0ZX 
 ;;9002226.02101,"1804,0XBF0ZX ",.02)
 ;;0XBF0ZX 
 ;;9002226.02101,"1804,0XBF0ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBF0ZZ ",.01)
 ;;0XBF0ZZ 
 ;;9002226.02101,"1804,0XBF0ZZ ",.02)
 ;;0XBF0ZZ 
 ;;9002226.02101,"1804,0XBF0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBF3ZX ",.01)
 ;;0XBF3ZX 
 ;;9002226.02101,"1804,0XBF3ZX ",.02)
 ;;0XBF3ZX 
 ;;9002226.02101,"1804,0XBF3ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBF3ZZ ",.01)
 ;;0XBF3ZZ 
 ;;9002226.02101,"1804,0XBF3ZZ ",.02)
 ;;0XBF3ZZ 
 ;;9002226.02101,"1804,0XBF3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBF4ZX ",.01)
 ;;0XBF4ZX 
 ;;9002226.02101,"1804,0XBF4ZX ",.02)
 ;;0XBF4ZX 
 ;;9002226.02101,"1804,0XBF4ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBF4ZZ ",.01)
 ;;0XBF4ZZ 
 ;;9002226.02101,"1804,0XBF4ZZ ",.02)
 ;;0XBF4ZZ 
 ;;9002226.02101,"1804,0XBF4ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBG0ZX ",.01)
 ;;0XBG0ZX 
 ;;9002226.02101,"1804,0XBG0ZX ",.02)
 ;;0XBG0ZX 
 ;;9002226.02101,"1804,0XBG0ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBG0ZZ ",.01)
 ;;0XBG0ZZ 
 ;;9002226.02101,"1804,0XBG0ZZ ",.02)
 ;;0XBG0ZZ 
 ;;9002226.02101,"1804,0XBG0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBG3ZX ",.01)
 ;;0XBG3ZX 
 ;;9002226.02101,"1804,0XBG3ZX ",.02)
 ;;0XBG3ZX 
 ;;9002226.02101,"1804,0XBG3ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBG3ZZ ",.01)
 ;;0XBG3ZZ 
 ;;9002226.02101,"1804,0XBG3ZZ ",.02)
 ;;0XBG3ZZ 
 ;;9002226.02101,"1804,0XBG3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBG4ZX ",.01)
 ;;0XBG4ZX 
 ;;9002226.02101,"1804,0XBG4ZX ",.02)
 ;;0XBG4ZX 
 ;;9002226.02101,"1804,0XBG4ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBG4ZZ ",.01)
 ;;0XBG4ZZ 
 ;;9002226.02101,"1804,0XBG4ZZ ",.02)
 ;;0XBG4ZZ 
 ;;9002226.02101,"1804,0XBG4ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBH0ZX ",.01)
 ;;0XBH0ZX 
 ;;9002226.02101,"1804,0XBH0ZX ",.02)
 ;;0XBH0ZX 
 ;;9002226.02101,"1804,0XBH0ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBH0ZZ ",.01)
 ;;0XBH0ZZ 
 ;;9002226.02101,"1804,0XBH0ZZ ",.02)
 ;;0XBH0ZZ 
 ;;9002226.02101,"1804,0XBH0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBH3ZX ",.01)
 ;;0XBH3ZX 
 ;;9002226.02101,"1804,0XBH3ZX ",.02)
 ;;0XBH3ZX 
 ;;9002226.02101,"1804,0XBH3ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBH3ZZ ",.01)
 ;;0XBH3ZZ 
 ;;9002226.02101,"1804,0XBH3ZZ ",.02)
 ;;0XBH3ZZ 
 ;;9002226.02101,"1804,0XBH3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBH4ZX ",.01)
 ;;0XBH4ZX 
 ;;9002226.02101,"1804,0XBH4ZX ",.02)
 ;;0XBH4ZX 
 ;;9002226.02101,"1804,0XBH4ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBH4ZZ ",.01)
 ;;0XBH4ZZ 
 ;;9002226.02101,"1804,0XBH4ZZ ",.02)
 ;;0XBH4ZZ 
 ;;9002226.02101,"1804,0XBH4ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBJ0ZX ",.01)
 ;;0XBJ0ZX 
 ;;9002226.02101,"1804,0XBJ0ZX ",.02)
 ;;0XBJ0ZX 
 ;;9002226.02101,"1804,0XBJ0ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBJ0ZZ ",.01)
 ;;0XBJ0ZZ 
 ;;9002226.02101,"1804,0XBJ0ZZ ",.02)
 ;;0XBJ0ZZ 
 ;;9002226.02101,"1804,0XBJ0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBJ3ZX ",.01)
 ;;0XBJ3ZX 
 ;;9002226.02101,"1804,0XBJ3ZX ",.02)
 ;;0XBJ3ZX 
 ;;9002226.02101,"1804,0XBJ3ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBJ3ZZ ",.01)
 ;;0XBJ3ZZ 
 ;;9002226.02101,"1804,0XBJ3ZZ ",.02)
 ;;0XBJ3ZZ 
 ;;9002226.02101,"1804,0XBJ3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBJ4ZX ",.01)
 ;;0XBJ4ZX 
 ;;9002226.02101,"1804,0XBJ4ZX ",.02)
 ;;0XBJ4ZX 
 ;;9002226.02101,"1804,0XBJ4ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBJ4ZZ ",.01)
 ;;0XBJ4ZZ 
 ;;9002226.02101,"1804,0XBJ4ZZ ",.02)
 ;;0XBJ4ZZ 
 ;;9002226.02101,"1804,0XBJ4ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBK0ZX ",.01)
 ;;0XBK0ZX 
 ;;9002226.02101,"1804,0XBK0ZX ",.02)
 ;;0XBK0ZX 
 ;;9002226.02101,"1804,0XBK0ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBK0ZZ ",.01)
 ;;0XBK0ZZ 
 ;;9002226.02101,"1804,0XBK0ZZ ",.02)
 ;;0XBK0ZZ 
 ;;9002226.02101,"1804,0XBK0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBK3ZX ",.01)
 ;;0XBK3ZX 
 ;;9002226.02101,"1804,0XBK3ZX ",.02)
 ;;0XBK3ZX 
 ;;9002226.02101,"1804,0XBK3ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBK3ZZ ",.01)
 ;;0XBK3ZZ 
 ;;9002226.02101,"1804,0XBK3ZZ ",.02)
 ;;0XBK3ZZ 
 ;;9002226.02101,"1804,0XBK3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBK4ZX ",.01)
 ;;0XBK4ZX 
 ;;9002226.02101,"1804,0XBK4ZX ",.02)
 ;;0XBK4ZX 
 ;;9002226.02101,"1804,0XBK4ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0XBK4ZZ ",.01)
 ;;0XBK4ZZ 
 ;;9002226.02101,"1804,0XBK4ZZ ",.02)
 ;;0XBK4ZZ 
 ;;9002226.02101,"1804,0XBK4ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH201Z ",.01)
 ;;0XH201Z 
 ;;9002226.02101,"1804,0XH201Z ",.02)
 ;;0XH201Z 
 ;;9002226.02101,"1804,0XH201Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH203Z ",.01)
 ;;0XH203Z 
 ;;9002226.02101,"1804,0XH203Z ",.02)
 ;;0XH203Z 
 ;;9002226.02101,"1804,0XH203Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH20YZ ",.01)
 ;;0XH20YZ 
 ;;9002226.02101,"1804,0XH20YZ ",.02)
 ;;0XH20YZ 
 ;;9002226.02101,"1804,0XH20YZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH231Z ",.01)
 ;;0XH231Z 
 ;;9002226.02101,"1804,0XH231Z ",.02)
 ;;0XH231Z 
 ;;9002226.02101,"1804,0XH231Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH233Z ",.01)
 ;;0XH233Z 
 ;;9002226.02101,"1804,0XH233Z ",.02)
 ;;0XH233Z 
 ;;9002226.02101,"1804,0XH233Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH23YZ ",.01)
 ;;0XH23YZ 
 ;;9002226.02101,"1804,0XH23YZ ",.02)
 ;;0XH23YZ 
 ;;9002226.02101,"1804,0XH23YZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH241Z ",.01)
 ;;0XH241Z 
 ;;9002226.02101,"1804,0XH241Z ",.02)
 ;;0XH241Z 
 ;;9002226.02101,"1804,0XH241Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH243Z ",.01)
 ;;0XH243Z 
 ;;9002226.02101,"1804,0XH243Z ",.02)
 ;;0XH243Z 
 ;;9002226.02101,"1804,0XH243Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH24YZ ",.01)
 ;;0XH24YZ 
 ;;9002226.02101,"1804,0XH24YZ ",.02)
 ;;0XH24YZ 
 ;;9002226.02101,"1804,0XH24YZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH301Z ",.01)
 ;;0XH301Z 
 ;;9002226.02101,"1804,0XH301Z ",.02)
 ;;0XH301Z 
 ;;9002226.02101,"1804,0XH301Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH303Z ",.01)
 ;;0XH303Z 
 ;;9002226.02101,"1804,0XH303Z ",.02)
 ;;0XH303Z 
 ;;9002226.02101,"1804,0XH303Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH30YZ ",.01)
 ;;0XH30YZ 
 ;;9002226.02101,"1804,0XH30YZ ",.02)
 ;;0XH30YZ 
 ;;9002226.02101,"1804,0XH30YZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH331Z ",.01)
 ;;0XH331Z 
 ;;9002226.02101,"1804,0XH331Z ",.02)
 ;;0XH331Z 
 ;;9002226.02101,"1804,0XH331Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH333Z ",.01)
 ;;0XH333Z 
 ;;9002226.02101,"1804,0XH333Z ",.02)
 ;;0XH333Z 
 ;;9002226.02101,"1804,0XH333Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH33YZ ",.01)
 ;;0XH33YZ 
 ;;9002226.02101,"1804,0XH33YZ ",.02)
 ;;0XH33YZ 
 ;;9002226.02101,"1804,0XH33YZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH341Z ",.01)
 ;;0XH341Z 
 ;;9002226.02101,"1804,0XH341Z ",.02)
 ;;0XH341Z 
 ;;9002226.02101,"1804,0XH341Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH343Z ",.01)
 ;;0XH343Z 
 ;;9002226.02101,"1804,0XH343Z ",.02)
 ;;0XH343Z 
 ;;9002226.02101,"1804,0XH343Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH34YZ ",.01)
 ;;0XH34YZ 
 ;;9002226.02101,"1804,0XH34YZ ",.02)
 ;;0XH34YZ 
 ;;9002226.02101,"1804,0XH34YZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH401Z ",.01)
 ;;0XH401Z 
 ;;9002226.02101,"1804,0XH401Z ",.02)
 ;;0XH401Z 
 ;;9002226.02101,"1804,0XH401Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH403Z ",.01)
 ;;0XH403Z 
 ;;9002226.02101,"1804,0XH403Z ",.02)
 ;;0XH403Z 
 ;;9002226.02101,"1804,0XH403Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH40YZ ",.01)
 ;;0XH40YZ 
 ;;9002226.02101,"1804,0XH40YZ ",.02)
 ;;0XH40YZ 
 ;;9002226.02101,"1804,0XH40YZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH431Z ",.01)
 ;;0XH431Z 
 ;;9002226.02101,"1804,0XH431Z ",.02)
 ;;0XH431Z 
 ;;9002226.02101,"1804,0XH431Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH433Z ",.01)
 ;;0XH433Z 
 ;;9002226.02101,"1804,0XH433Z ",.02)
 ;;0XH433Z 
 ;;9002226.02101,"1804,0XH433Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH43YZ ",.01)
 ;;0XH43YZ 
 ;;9002226.02101,"1804,0XH43YZ ",.02)
 ;;0XH43YZ 
 ;;9002226.02101,"1804,0XH43YZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH441Z ",.01)
 ;;0XH441Z 
 ;;9002226.02101,"1804,0XH441Z ",.02)
 ;;0XH441Z 
 ;;9002226.02101,"1804,0XH441Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH443Z ",.01)
 ;;0XH443Z 
 ;;9002226.02101,"1804,0XH443Z ",.02)
 ;;0XH443Z 
 ;;9002226.02101,"1804,0XH443Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH44YZ ",.01)
 ;;0XH44YZ 
 ;;9002226.02101,"1804,0XH44YZ ",.02)
 ;;0XH44YZ 
 ;;9002226.02101,"1804,0XH44YZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH501Z ",.01)
 ;;0XH501Z 
 ;;9002226.02101,"1804,0XH501Z ",.02)
 ;;0XH501Z 
 ;;9002226.02101,"1804,0XH501Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH503Z ",.01)
 ;;0XH503Z 
 ;;9002226.02101,"1804,0XH503Z ",.02)
 ;;0XH503Z 
 ;;9002226.02101,"1804,0XH503Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH50YZ ",.01)
 ;;0XH50YZ 
 ;;9002226.02101,"1804,0XH50YZ ",.02)
 ;;0XH50YZ 
 ;;9002226.02101,"1804,0XH50YZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH531Z ",.01)
 ;;0XH531Z 
 ;;9002226.02101,"1804,0XH531Z ",.02)
 ;;0XH531Z 
 ;;9002226.02101,"1804,0XH531Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH533Z ",.01)
 ;;0XH533Z 
 ;;9002226.02101,"1804,0XH533Z ",.02)
 ;;0XH533Z 
 ;;9002226.02101,"1804,0XH533Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0XH53YZ ",.01)
 ;;0XH53YZ 
 ;;9002226.02101,"1804,0XH53YZ ",.02)
 ;;0XH53YZ 