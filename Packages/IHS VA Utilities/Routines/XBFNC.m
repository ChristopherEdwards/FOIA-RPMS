XBFNC ;IHS/SET/GTH - Field Numbering Conventions ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002
 ;
 ; Given an input of files, check the fields in the files
 ; for conformance to the SAC field numbering conventions.
 ;
 ; Can also print conventions.
 ;
Q ; F = File
 ; H = Header
 ; I = Field
 ; N = Node
 ; P = Piece
 ;
 W !,"FileMan Field Numbering Conventions",!
 D FNC,^XBDSET
 Q:'$D(^UTILITY("XBDSET",$J))
 NEW F
 S F=0
 F  S F=$O(^UTILITY("XBDSET",$J,F)) Q:'F  D FILE(F)
 Q
 ;
FILE(F) ;
 NEW I,H,N,P
 S I=0
 F  S I=$O(^DD(F,I)) Q:'I  I '($P(^(I,0),U,2)["C") D
 . S H=0
 . I +$P(^DD(F,I,0),U,2) D  Q
 .. I $L(I)'=4 D ERR(1)
 .. D FILE(+$P(^DD(F,I,0),U,2))
 ..Q
 . S N=$P($P(^DD(F,I,0),U,4),";",1),P=$P($P(^(0),U,4),";",2)
 . I N=0 D  Q
 .. I $E(I)'="." D ERR(2)
 .. I P'=+$P(I,".",2)!(+$P(I,".")) D ERR(3)
 .. I P=10 D ERR(4)
 ..Q
 . I $E(I)="." D ERR(5)
 . I +N,N'=+$E(I,1,$L(N)) D ERR(6)
 . I +N,P'=+$E(I,$L(N)+1,99) D ERR(7)
 . I 'N,P'=I D ERR(8)
 .Q
 Q
 ;
ERR(E) ;
 W:'H !," ",F," (",$O(^DD(F,0,"NM","")),"), ",I," (",$P(^DD(F,I,0),U,1),"), global location ",$P(^(0),U,4),$S(+P:"",1:"(Multiple)")
 S H=1
 W !?5,$P($T(@E),";",3),"."
 Q
 ;
1 ;;Field number of multiple field is not 4 digits
2 ;;Field number in 0th node should begin with '.'
3 ;;Piece number in 0th node should = +$P(fld#,".",2)
4 ;;Piece 10 of 0th node should be null
5 ;;Field begins with '.' and not in 0th node
6 ;;Field number does not begin with node location
7 ;;Piece number does not match non-nodal part of field number
8 ;;Field number and piece number do not match
 ;
FNC ;
 Q:'$$DIR^XBDIR("Y","Print conventions","N")
 D ^%ZIS
 Q:POP
 U IO
 D HELP^XBHELP("TXT","XBFNC",0),^%ZISC
 Q
 ;
TXT ;
 ;;
 ;;              -------------------------------
 ;;              DATA DICTIONARY FIELD NUMBERING
 ;;              AND DATA PLACEMENT CONVENTIONS
 ;;              -------------------------------
 ;;
 ;;The following conventions for numbering fields, and placing data in pieces, is
 ;;extracted from a mail message dated 25 Feb 88, and is considered to be those
 ;;conventions referred to in the Programming Standards And Conventions paragraph
 ;;which states "Field numbers for FileMan files will be assigned in accordance
 ;;with established conventions."
 ;;
 ;; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
 ;;
 ;;1)  There is a direct correlation between the field number and the node and
 ;;piece, and for multiples, between the field number and the sub-file number.
 ;;
 ;;2)  Fields beginning with a "." are all .01-.n and are in the 0th node.  Where
 ;;possible, files only have a 0th node.  This reduces the number of disc accesses
 ;;required.  A field number must be canonic, therefore, there is no .10 field.
 ;;It  goes from .09 to .11.  That means piece 10 will always be NULL.
 ;;
 ;;3)  Where the entire entry cannot be put in one node, there are more nodes,
 ;;generally grouped by logically related fields into field numbers within some
 ;;range, say 1101-1116.  These would be node 11 piece 1-16, and in this case
 ;;piece 10 is allowed because it is canonic.
 ;;
 ;;4)  Multiple fields are always 4 digits.  The first two digits are the next
 ;;higher group, using the example above, 11 would be the next higher group.  The
 ;;second two digits are always 00.  The subscript for that multiple is always the
 ;;first two digits of the multi-valued field number.  11 in this case.  The
 ;;sub-file number is always the parent file number with the first two digits of
 ;;the multi-valued field number appended.  If we were in file 9000001 in the
 ;;above example, the sub-file for field 1100 would be 9000001.11, and the
 ;;subscript would be 11.  Now, if we added a multiple to that sub-file, as say
 ;;field number 1500, its sub-file would be 9000001.1115 and its subscript would
 ;;be 15.  In the data global it would look like ^AUPNPAT(DA(1),11,DA,15,0).  The
 ;;assigning of sub-file numbers is important, because if you let FileMan do it,
 ;;he will assign numbers that may fall within the number space of primary files
 ;;using our file number assigning logic.
 ;;
 ;;5)  There are special cases that do not follow the rules, of course.  On most
 ;;of the pointed to files, we have added a field number 9901 MNEMONIC which is
 ;;used on a site by site basis if you have a very high percentage of your lookups
 ;;to two or three entries, you can add data to the MNEMONIC field, say 1, 2, and
 ;;3, and instead of responding CLAREMORE to a LOCATION lookup, you can respond 1.
 ;;This field is in node 88 piece 1.   It is 8801 so the MNEMONIC field would be
 ;;the same number in all dictionaries, regardless of how many fields, and field
 ;;numbers, a particular file had already.
 ;;
 ;;6)  Computed fields, where ever possible, immediately follow the field from
 ;;which they are computed, and the computed field number is the same as the real
 ;;field followed by a 9.  If the field above was .12 the computed field would be
 ;;.129.  If you wanted more than one computed field off of .12 they would be
 ;;.1291 and .1292.
 ;;
 ;;7)  There is another class of computed field.  That is a computed field that
 ;;points back to the VA PATIENT file.  Those fields have a .2 following the field
 ;;number.  That indicates it is not really a computed field, but just a pointer
 ;;back to the VA PATIENT file.
 ;;
 ;;********************************************
