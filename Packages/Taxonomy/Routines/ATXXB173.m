ATXXB173 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON APR 29, 2014;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1804,57.94 ",.02)
 ;;57.94 
 ;;9002226.02101,"1804,57.94 ",.03)
 ;;2
 ;;9002226.02101,"1804,5A02115 ",.01)
 ;;5A02115 
 ;;9002226.02101,"1804,5A02115 ",.02)
 ;;5A02115 
 ;;9002226.02101,"1804,5A02115 ",.03)
 ;;31
 ;;9002226.02101,"1804,5A02215 ",.01)
 ;;5A02215 
 ;;9002226.02101,"1804,5A02215 ",.02)
 ;;5A02215 
 ;;9002226.02101,"1804,5A02215 ",.03)
 ;;31
 ;;9002226.02101,"1804,5A05121 ",.01)
 ;;5A05121 
 ;;9002226.02101,"1804,5A05121 ",.02)
 ;;5A05121 
 ;;9002226.02101,"1804,5A05121 ",.03)
 ;;31
 ;;9002226.02101,"1804,5A05221 ",.01)
 ;;5A05221 
 ;;9002226.02101,"1804,5A05221 ",.02)
 ;;5A05221 
 ;;9002226.02101,"1804,5A05221 ",.03)
 ;;31
 ;;9002226.02101,"1804,5A09357 ",.01)
 ;;5A09357 
 ;;9002226.02101,"1804,5A09357 ",.02)
 ;;5A09357 
 ;;9002226.02101,"1804,5A09357 ",.03)
 ;;31
 ;;9002226.02101,"1804,5A09358 ",.01)
 ;;5A09358 
 ;;9002226.02101,"1804,5A09358 ",.02)
 ;;5A09358 
 ;;9002226.02101,"1804,5A09358 ",.03)
 ;;31
 ;;9002226.02101,"1804,5A09359 ",.01)
 ;;5A09359 
 ;;9002226.02101,"1804,5A09359 ",.02)
 ;;5A09359 
 ;;9002226.02101,"1804,5A09359 ",.03)
 ;;31
 ;;9002226.02101,"1804,5A0935B ",.01)
 ;;5A0935B 
 ;;9002226.02101,"1804,5A0935B ",.02)
 ;;5A0935B 
 ;;9002226.02101,"1804,5A0935B ",.03)
 ;;31
 ;;9002226.02101,"1804,5A0935Z ",.01)
 ;;5A0935Z 
 ;;9002226.02101,"1804,5A0935Z ",.02)
 ;;5A0935Z 
 ;;9002226.02101,"1804,5A0935Z ",.03)
 ;;31
 ;;9002226.02101,"1804,5A09457 ",.01)
 ;;5A09457 
 ;;9002226.02101,"1804,5A09457 ",.02)
 ;;5A09457 
 ;;9002226.02101,"1804,5A09457 ",.03)
 ;;31
 ;;9002226.02101,"1804,5A09458 ",.01)
 ;;5A09458 
 ;;9002226.02101,"1804,5A09458 ",.02)
 ;;5A09458 
 ;;9002226.02101,"1804,5A09458 ",.03)
 ;;31
 ;;9002226.02101,"1804,5A09459 ",.01)
 ;;5A09459 
 ;;9002226.02101,"1804,5A09459 ",.02)
 ;;5A09459 
 ;;9002226.02101,"1804,5A09459 ",.03)
 ;;31
 ;;9002226.02101,"1804,5A0945B ",.01)
 ;;5A0945B 
 ;;9002226.02101,"1804,5A0945B ",.02)
 ;;5A0945B 
 ;;9002226.02101,"1804,5A0945B ",.03)
 ;;31
 ;;9002226.02101,"1804,5A0945Z ",.01)
 ;;5A0945Z 
 ;;9002226.02101,"1804,5A0945Z ",.02)
 ;;5A0945Z 
 ;;9002226.02101,"1804,5A0945Z ",.03)
 ;;31
 ;;9002226.02101,"1804,5A09557 ",.01)
 ;;5A09557 
 ;;9002226.02101,"1804,5A09557 ",.02)
 ;;5A09557 
 ;;9002226.02101,"1804,5A09557 ",.03)
 ;;31
 ;;9002226.02101,"1804,5A09558 ",.01)
 ;;5A09558 
 ;;9002226.02101,"1804,5A09558 ",.02)
 ;;5A09558 
 ;;9002226.02101,"1804,5A09558 ",.03)
 ;;31
 ;;9002226.02101,"1804,5A09559 ",.01)
 ;;5A09559 
 ;;9002226.02101,"1804,5A09559 ",.02)
 ;;5A09559 
 ;;9002226.02101,"1804,5A09559 ",.03)
 ;;31
 ;;9002226.02101,"1804,5A0955B ",.01)
 ;;5A0955B 
 ;;9002226.02101,"1804,5A0955B ",.02)
 ;;5A0955B 
 ;;9002226.02101,"1804,5A0955B ",.03)
 ;;31
 ;;9002226.02101,"1804,5A0955Z ",.01)
 ;;5A0955Z 
 ;;9002226.02101,"1804,5A0955Z ",.02)
 ;;5A0955Z 
 ;;9002226.02101,"1804,5A0955Z ",.03)
 ;;31
 ;;9002226.02101,"1804,5A12012 ",.01)
 ;;5A12012 
 ;;9002226.02101,"1804,5A12012 ",.02)
 ;;5A12012 
 ;;9002226.02101,"1804,5A12012 ",.03)
 ;;31
 ;;9002226.02101,"1804,5A19054 ",.01)
 ;;5A19054 
 ;;9002226.02101,"1804,5A19054 ",.02)
 ;;5A19054 
 ;;9002226.02101,"1804,5A19054 ",.03)
 ;;31
 ;;9002226.02101,"1804,5A1935Z ",.01)
 ;;5A1935Z 
 ;;9002226.02101,"1804,5A1935Z ",.02)
 ;;5A1935Z 
 ;;9002226.02101,"1804,5A1935Z ",.03)
 ;;31
 ;;9002226.02101,"1804,5A1945Z ",.01)
 ;;5A1945Z 
 ;;9002226.02101,"1804,5A1945Z ",.02)
 ;;5A1945Z 
 ;;9002226.02101,"1804,5A1945Z ",.03)
 ;;31
 ;;9002226.02101,"1804,5A1955Z ",.01)
 ;;5A1955Z 
 ;;9002226.02101,"1804,5A1955Z ",.02)
 ;;5A1955Z 
 ;;9002226.02101,"1804,5A1955Z ",.03)
 ;;31
 ;;9002226.02101,"1804,5A2204Z ",.01)
 ;;5A2204Z 
 ;;9002226.02101,"1804,5A2204Z ",.02)
 ;;5A2204Z 
 ;;9002226.02101,"1804,5A2204Z ",.03)
 ;;31
 ;;9002226.02101,"1804,69.7 ",.01)
 ;;69.7 
 ;;9002226.02101,"1804,69.7 ",.02)
 ;;69.7 
 ;;9002226.02101,"1804,69.7 ",.03)
 ;;2
 ;;9002226.02101,"1804,6A0Z0ZZ ",.01)
 ;;6A0Z0ZZ 
 ;;9002226.02101,"1804,6A0Z0ZZ ",.02)
 ;;6A0Z0ZZ 
 ;;9002226.02101,"1804,6A0Z0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,6A0Z1ZZ ",.01)
 ;;6A0Z1ZZ 
 ;;9002226.02101,"1804,6A0Z1ZZ ",.02)
 ;;6A0Z1ZZ 
 ;;9002226.02101,"1804,6A0Z1ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,6A150ZZ ",.01)
 ;;6A150ZZ 
 ;;9002226.02101,"1804,6A150ZZ ",.02)
 ;;6A150ZZ 
 ;;9002226.02101,"1804,6A150ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,6A151ZZ ",.01)
 ;;6A151ZZ 
 ;;9002226.02101,"1804,6A151ZZ ",.02)
 ;;6A151ZZ 
 ;;9002226.02101,"1804,6A151ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,6A210ZZ ",.01)
 ;;6A210ZZ 
 ;;9002226.02101,"1804,6A210ZZ ",.02)
 ;;6A210ZZ 
 ;;9002226.02101,"1804,6A210ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,6A211ZZ ",.01)
 ;;6A211ZZ 
 ;;9002226.02101,"1804,6A211ZZ ",.02)
 ;;6A211ZZ 
 ;;9002226.02101,"1804,6A211ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,6A220ZZ ",.01)
 ;;6A220ZZ 
 ;;9002226.02101,"1804,6A220ZZ ",.02)
 ;;6A220ZZ 
 ;;9002226.02101,"1804,6A220ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,6A221ZZ ",.01)
 ;;6A221ZZ 
 ;;9002226.02101,"1804,6A221ZZ ",.02)
 ;;6A221ZZ 
 ;;9002226.02101,"1804,6A221ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,6A3Z0ZZ ",.01)
 ;;6A3Z0ZZ 
 ;;9002226.02101,"1804,6A3Z0ZZ ",.02)
 ;;6A3Z0ZZ 
 ;;9002226.02101,"1804,6A3Z0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,6A3Z1ZZ ",.01)
 ;;6A3Z1ZZ 
 ;;9002226.02101,"1804,6A3Z1ZZ ",.02)
 ;;6A3Z1ZZ 
 ;;9002226.02101,"1804,6A3Z1ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,6A4Z0ZZ ",.01)
 ;;6A4Z0ZZ 
 ;;9002226.02101,"1804,6A4Z0ZZ ",.02)
 ;;6A4Z0ZZ 
 ;;9002226.02101,"1804,6A4Z0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,6A4Z1ZZ ",.01)
 ;;6A4Z1ZZ 
 ;;9002226.02101,"1804,6A4Z1ZZ ",.02)
 ;;6A4Z1ZZ 
 ;;9002226.02101,"1804,6A4Z1ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,6A550Z0 ",.01)
 ;;6A550Z0 
 ;;9002226.02101,"1804,6A550Z0 ",.02)
 ;;6A550Z0 
 ;;9002226.02101,"1804,6A550Z0 ",.03)
 ;;31
 ;;9002226.02101,"1804,6A550Z1 ",.01)
 ;;6A550Z1 
 ;;9002226.02101,"1804,6A550Z1 ",.02)
 ;;6A550Z1 
 ;;9002226.02101,"1804,6A550Z1 ",.03)
 ;;31
 ;;9002226.02101,"1804,6A550Z2 ",.01)
 ;;6A550Z2 
 ;;9002226.02101,"1804,6A550Z2 ",.02)
 ;;6A550Z2 
 ;;9002226.02101,"1804,6A550Z2 ",.03)
 ;;31
 ;;9002226.02101,"1804,6A550Z3 ",.01)
 ;;6A550Z3 
 ;;9002226.02101,"1804,6A550Z3 ",.02)
 ;;6A550Z3 
 ;;9002226.02101,"1804,6A550Z3 ",.03)
 ;;31
 ;;9002226.02101,"1804,6A550ZT ",.01)
 ;;6A550ZT 
 ;;9002226.02101,"1804,6A550ZT ",.02)
 ;;6A550ZT 
 ;;9002226.02101,"1804,6A550ZT ",.03)
 ;;31
 ;;9002226.02101,"1804,6A550ZV ",.01)
 ;;6A550ZV 
 ;;9002226.02101,"1804,6A550ZV ",.02)
 ;;6A550ZV 
 ;;9002226.02101,"1804,6A550ZV ",.03)
 ;;31
 ;;9002226.02101,"1804,6A551Z0 ",.01)
 ;;6A551Z0 
 ;;9002226.02101,"1804,6A551Z0 ",.02)
 ;;6A551Z0 
 ;;9002226.02101,"1804,6A551Z0 ",.03)
 ;;31
 ;;9002226.02101,"1804,6A551Z1 ",.01)
 ;;6A551Z1 
 ;;9002226.02101,"1804,6A551Z1 ",.02)
 ;;6A551Z1 
 ;;9002226.02101,"1804,6A551Z1 ",.03)
 ;;31
 ;;9002226.02101,"1804,6A551Z2 ",.01)
 ;;6A551Z2 
 ;;9002226.02101,"1804,6A551Z2 ",.02)
 ;;6A551Z2 
 ;;9002226.02101,"1804,6A551Z2 ",.03)
 ;;31
 ;;9002226.02101,"1804,6A551Z3 ",.01)
 ;;6A551Z3 
 ;;9002226.02101,"1804,6A551Z3 ",.02)
 ;;6A551Z3 
 ;;9002226.02101,"1804,6A551Z3 ",.03)
 ;;31
 ;;9002226.02101,"1804,6A551ZT ",.01)
 ;;6A551ZT 
 ;;9002226.02101,"1804,6A551ZT ",.02)
 ;;6A551ZT 
 ;;9002226.02101,"1804,6A551ZT ",.03)
 ;;31
 ;;9002226.02101,"1804,6A551ZV ",.01)
 ;;6A551ZV 
 ;;9002226.02101,"1804,6A551ZV ",.02)
 ;;6A551ZV 
 ;;9002226.02101,"1804,6A551ZV ",.03)
 ;;31
 ;;9002226.02101,"1804,6A600ZZ ",.01)
 ;;6A600ZZ 
 ;;9002226.02101,"1804,6A600ZZ ",.02)
 ;;6A600ZZ 
 ;;9002226.02101,"1804,6A600ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,6A601ZZ ",.01)
 ;;6A601ZZ 
 ;;9002226.02101,"1804,6A601ZZ ",.02)
 ;;6A601ZZ 
 ;;9002226.02101,"1804,6A601ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,6A650ZZ ",.01)
 ;;6A650ZZ 
 ;;9002226.02101,"1804,6A650ZZ ",.02)
 ;;6A650ZZ 
 ;;9002226.02101,"1804,6A650ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,6A651ZZ ",.01)
 ;;6A651ZZ 
 ;;9002226.02101,"1804,6A651ZZ ",.02)
 ;;6A651ZZ 
 ;;9002226.02101,"1804,6A651ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,6A800ZZ ",.01)
 ;;6A800ZZ 
 ;;9002226.02101,"1804,6A800ZZ ",.02)
 ;;6A800ZZ 
 ;;9002226.02101,"1804,6A800ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,6A801ZZ ",.01)
 ;;6A801ZZ 
 ;;9002226.02101,"1804,6A801ZZ ",.02)
 ;;6A801ZZ 
 ;;9002226.02101,"1804,6A801ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,73.09 ",.01)
 ;;73.09 
 ;;9002226.02101,"1804,73.09 ",.02)
 ;;73.09 
 ;;9002226.02101,"1804,73.09 ",.03)
 ;;2
 ;;9002226.02101,"1804,7W00X0Z ",.01)
 ;;7W00X0Z 
 ;;9002226.02101,"1804,7W00X0Z ",.02)
 ;;7W00X0Z 
 ;;9002226.02101,"1804,7W00X0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W00X1Z ",.01)
 ;;7W00X1Z 
 ;;9002226.02101,"1804,7W00X1Z ",.02)
 ;;7W00X1Z 
 ;;9002226.02101,"1804,7W00X1Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W00X2Z ",.01)
 ;;7W00X2Z 
 ;;9002226.02101,"1804,7W00X2Z ",.02)
 ;;7W00X2Z 
 ;;9002226.02101,"1804,7W00X2Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W00X3Z ",.01)
 ;;7W00X3Z 
 ;;9002226.02101,"1804,7W00X3Z ",.02)
 ;;7W00X3Z 
 ;;9002226.02101,"1804,7W00X3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W00X4Z ",.01)
 ;;7W00X4Z 
 ;;9002226.02101,"1804,7W00X4Z ",.02)
 ;;7W00X4Z 
 ;;9002226.02101,"1804,7W00X4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W00X5Z ",.01)
 ;;7W00X5Z 
 ;;9002226.02101,"1804,7W00X5Z ",.02)
 ;;7W00X5Z 
 ;;9002226.02101,"1804,7W00X5Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W00X6Z ",.01)
 ;;7W00X6Z 
 ;;9002226.02101,"1804,7W00X6Z ",.02)
 ;;7W00X6Z 
 ;;9002226.02101,"1804,7W00X6Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W00X7Z ",.01)
 ;;7W00X7Z 
 ;;9002226.02101,"1804,7W00X7Z ",.02)
 ;;7W00X7Z 
 ;;9002226.02101,"1804,7W00X7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W00X8Z ",.01)
 ;;7W00X8Z 
 ;;9002226.02101,"1804,7W00X8Z ",.02)
 ;;7W00X8Z 
 ;;9002226.02101,"1804,7W00X8Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W00X9Z ",.01)
 ;;7W00X9Z 
 ;;9002226.02101,"1804,7W00X9Z ",.02)
 ;;7W00X9Z 
 ;;9002226.02101,"1804,7W00X9Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W01X0Z ",.01)
 ;;7W01X0Z 
 ;;9002226.02101,"1804,7W01X0Z ",.02)
 ;;7W01X0Z 
 ;;9002226.02101,"1804,7W01X0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W01X1Z ",.01)
 ;;7W01X1Z 
 ;;9002226.02101,"1804,7W01X1Z ",.02)
 ;;7W01X1Z 
 ;;9002226.02101,"1804,7W01X1Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W01X2Z ",.01)
 ;;7W01X2Z 
 ;;9002226.02101,"1804,7W01X2Z ",.02)
 ;;7W01X2Z 
 ;;9002226.02101,"1804,7W01X2Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W01X3Z ",.01)
 ;;7W01X3Z 
 ;;9002226.02101,"1804,7W01X3Z ",.02)
 ;;7W01X3Z 
 ;;9002226.02101,"1804,7W01X3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W01X4Z ",.01)
 ;;7W01X4Z 
 ;;9002226.02101,"1804,7W01X4Z ",.02)
 ;;7W01X4Z 
 ;;9002226.02101,"1804,7W01X4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W01X5Z ",.01)
 ;;7W01X5Z 
 ;;9002226.02101,"1804,7W01X5Z ",.02)
 ;;7W01X5Z 
 ;;9002226.02101,"1804,7W01X5Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W01X6Z ",.01)
 ;;7W01X6Z 
 ;;9002226.02101,"1804,7W01X6Z ",.02)
 ;;7W01X6Z 
 ;;9002226.02101,"1804,7W01X6Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W01X7Z ",.01)
 ;;7W01X7Z 
 ;;9002226.02101,"1804,7W01X7Z ",.02)
 ;;7W01X7Z 
 ;;9002226.02101,"1804,7W01X7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W01X8Z ",.01)
 ;;7W01X8Z 
 ;;9002226.02101,"1804,7W01X8Z ",.02)
 ;;7W01X8Z 
 ;;9002226.02101,"1804,7W01X8Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W01X9Z ",.01)
 ;;7W01X9Z 
 ;;9002226.02101,"1804,7W01X9Z ",.02)
 ;;7W01X9Z 
 ;;9002226.02101,"1804,7W01X9Z ",.03)
 ;;31
 ;;9002226.02101,"1804,7W02X0Z ",.01)
 ;;7W02X0Z 
 ;;9002226.02101,"1804,7W02X0Z ",.02)
 ;;7W02X0Z 