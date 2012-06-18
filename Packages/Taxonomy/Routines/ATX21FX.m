ATX21FX ; IHS/OHPRD/TMJ - FIX ATXAX GLOBAL MULTIPLE 21 NODE ; 
 ;;5.1;TAXONOMY;;FEB 04, 1997
 ;
 ;This Routine fixes the 0 Node of Subscript 21 of the Taxonomy Global
 ;The file # in multiple sub-file (on some old Taxonomies) is 9002226.2101
 ;The file # should be 9002226.02101A
 ;
START ;
 D PROCESS
 D END
 Q
 ;
 ;
PROCESS ;$O to get IEN of Taxonomy
 S ATXTDFN=0
 F  S ATXTDFN=$O(^ATXAX(ATXTDFN)) Q:'ATXTDFN  D
 .Q:'$D(^ATXAX(ATXTDFN,0))
 .Q:'$D(^ATXAX(ATXTDFN,21,0))
 .S $P(^ATXAX(ATXTDFN,21,0),U,2)="9002226.02101A"
 .Q
 Q
END ;
 W !!,?10,"Fix of Taxonomy Global Subscript 21 Now Complete",!
 K ATXTDFN
 Q
